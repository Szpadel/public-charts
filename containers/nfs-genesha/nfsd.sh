#!/bin/bash

# Trap signals for a clean shutdown of ganesha.nfsd
trap "stop; exit 0;" SIGTERM SIGINT

stop()
{
  echo "SIGTERM caught, terminating Ganesha NFS process..."
  # Kill ganesha.nfsd gracefully
  pkill -TERM ganesha.nfsd
  echo "Terminated."
  exit
}

set -uo pipefail
IFS=$'\n\t'

# Check if the SHARED_DIRECTORY variable is empty
if [ -z "${SHARED_DIRECTORY}" ]; then
  echo "The SHARED_DIRECTORY environment variable is unset or null, exiting..."
  exit 1
else
  echo "SHARED_DIRECTORY is set to ${SHARED_DIRECTORY}"
fi

# Check if the PERMITTED variable is empty
if [ -z "${PERMITTED:-}" ]; then
  echo "The PERMITTED environment variable is unset or null, defaulting to '*'."
  echo "Any client can mount."
  PERMITTED="*"
else
  echo "The PERMITTED environment variable is set."
  echo "The permitted clients are: ${PERMITTED}."
fi

# Check if the READ_ONLY variable is set (rather than a null string)
READ_ONLY_FLAG="RW"
if [ -z ${READ_ONLY+y} ]; then
  echo "The READ_ONLY environment variable is unset or null, defaulting to 'rw'."
  READ_ONLY_FLAG="RW"
else
  echo "The READ_ONLY environment variable is set. Clients will have read-only access."
  READ_ONLY_FLAG="RO"
fi

# SYNC variable doesn't directly map to NFS Ganesha concepts like sync/async the same way.
# We'll ignore SYNC differences since Ganesha does not use the same exportfs sync/async semantics.

# Ownership and permissions adjustments
if [ -n "${FILEPERMISSIONS_UID:-}" ]; then
  UID_ERROR=""
  targetUID=$(printf %d ${FILEPERMISSIONS_UID}) || UID_ERROR=$?
  if [ -n "${UID_ERROR}" ]; then
    echo "user change error: Invalid UID ${FILEPERMISSIONS_UID}"
    exit 1
  fi

  presentUID=$(stat ${SHARED_DIRECTORY} --printf=%u)
  if [ "$presentUID" -ne "$targetUID" ]; then
    CHOWN_UID_ERROR=""
    chown -R $targetUID ${SHARED_DIRECTORY} || CHOWN_UID_ERROR=$?
    if [ -n "${CHOWN_UID_ERROR}" ]; then
      echo "user change error: Failed to change user owner of ${SHARED_DIRECTORY}"
      exit 1
    fi
    echo "chown user command succeeded"
  fi
fi

if [ -n "${FILEPERMISSIONS_GID:-}" ]; then
  GID_ERROR=""
  targetGID=$(printf %d ${FILEPERMISSIONS_GID}) || GID_ERROR=$?
  if [ -n "${GID_ERROR}" ]; then
    echo "group change error: Invalid GID ${FILEPERMISSIONS_GID}"
    exit 1
  fi

  presentGID=$(stat ${SHARED_DIRECTORY} --printf=%g)
  if [ "$presentGID" -ne "$targetGID" ]; then
    CHOWN_GID_ERROR=""
    chown -R :${targetGID} ${SHARED_DIRECTORY} || CHOWN_GID_ERROR=$?
    if [ -n "${CHOWN_GID_ERROR}" ]; then
      echo "group change error: Failed to change group owner of ${SHARED_DIRECTORY}"
      exit 1
    fi
    echo "chown group command succeeded"
  fi
fi

if [ -n "${FILEPERMISSIONS_MODE:-}" ]; then
  TEST_CHMOD_ERROR=""
  TEST_CHMOD_OUT=$(chmod ${FILEPERMISSIONS_MODE} ${SHARED_DIRECTORY} -c) || TEST_CHMOD_ERROR=$?
  if [ -n "${TEST_CHMOD_ERROR}" ]; then
    echo "mode change error: chmod test command failed. 'mode' value ${FILEPERMISSIONS_MODE} might be invalid"
    exit 1
  fi

  if [ -n "${TEST_CHMOD_OUT}" ]; then
    CHMOD_ERROR=""
    chmod -R ${FILEPERMISSIONS_MODE} ${SHARED_DIRECTORY} || CHMOD_ERROR=$?
    if [ -n "${CHMOD_ERROR}" ]; then
      echo "mode change error: Failed to change file mode of ${SHARED_DIRECTORY}"
      exit 1
    fi
    echo "chmod command succeeded"
  fi
fi

# Handle custom configuration if provided
GANESHA_CONF="/etc/ganesha/ganesha.conf"
if [ ! -z "${CUSTOM_EXPORTS_CONFIG:-}" ]; then
  echo "CUSTOM_EXPORTS_CONFIG is set, using it as Ganesha configuration..."
  echo "${CUSTOM_EXPORTS_CONFIG}" > ${GANESHA_CONF}
else
  echo "No CUSTOM_EXPORTS_CONFIG provided. Generating default Ganesha configuration..."

  # If PERMITTED is "*", we won't restrict clients. If not, we convert PERMITTED into a client list.
  ALLOWED_CLIENTS=""
  if [ "${PERMITTED}" != "*" ]; then
    # Convert space-separated IPs/subnets into a Ganesha array
    # E.g. PERMITTED="10.0.0.1 192.168.1.0/24" => Allowed_clients = ["10.0.0.1","192.168.1.0/24"];
    IFS=' ' read -r -a client_array <<< "${PERMITTED}"
    formatted_clients=$(printf '"%s",' "${client_array[@]}")
    # Remove trailing comma
    formatted_clients="${formatted_clients%,}"
    ALLOWED_CLIENTS="Allowed_clients = [ ${formatted_clients} ];"
  fi

  # Build a minimal Ganesha configuration
  cat <<EOF > ${GANESHA_CONF}
NFS_Core_Param {
  NFS_Protocols = 4;
  # Allow NFS Ganesha to continue if PR_SET_IO_FLUSHER fails
  allow_set_io_flusher_fail = true;
}

EXPORT_DEFAULTS {
  Transports = TCP;
  SecType = sys;
}

EXPORT {
  Export_Id = 1;
  Path = "${SHARED_DIRECTORY}";
  Pseudo = "${SHARED_DIRECTORY}";
  ${ALLOWED_CLIENTS}
  Access_Type = ${READ_ONLY_FLAG};
  Squash = No_root_squash;
  # NFS Ganesha uses caching and other settings differently from kernel NFS,
  # so we won't replicate sync/async semantics here.
}
EOF

fi

function init_rpc {
    echo "Starting rpcbind"
    rpcbind || return 0
    rpc.statd -L || return 0
    rpc.idmapd || return 0
    sleep 1
}

function init_dbus {
    echo "Starting dbus"
    rm -f /var/run/dbus/system_bus_socket
    rm -f /var/run/dbus/pid
    dbus-uuidgen --ensure
    dbus-daemon --system --fork
    sleep 1
}

init_rpc
init_dbus

echo "Final Ganesha configuration:"
cat ${GANESHA_CONF}
echo ""

# Start NFS Ganesha with additional debug flags
echo "Starting NFS-Ganesha..."
ganesha.nfsd -F -L /dev/stdout -f ${GANESHA_CONF} -N NIV_EVENT  &
GANESHA_PID=$!

# Wait until ganesha stops running
while kill -0 $GANESHA_PID 2>/dev/null; do
  sleep 1
done

echo "NFS-Ganesha has stopped unexpectedly, exiting..."
exit 1
