
{{/* Make sure all variables are set properly */}}
{{- include "common.values.setup" . }}

{{- define "repman.configmap.files" -}}
configmap:
  files:
    data:
      nginx.conf: {{ include "repman.nginx.config" . | quote }}
      services_prod.yaml: {{ include "repman.repman.config.services" . | quote }}
      php-overrides.ini: {{ include "repman.repman.config.phpConfig" . | quote}}
{{- end -}}

{{- define "repman.names.postgresql" -}}
  {{ .Values.postgresql.team }}-{{ include "common.names.releasename" . }}-postgresql
{{- end -}}

{{- define "repman.names.postgresql-hostname" -}}
  {{- include "repman.names.postgresql" . -}}
  {{- if .Values.postgresql.connectionPooler -}}
    -pooler
  {{- end -}}
{{- end -}}

{{- define "repman.values.setup" -}}
  {{/* Set dynamic values */}}
  {{- $_ := set . "Values" (mergeOverwrite .Values (include "repman.configmap.files" . | fromYaml)) -}}
  {{- $_ := set .Values "secret" (mergeOverwrite .Values.secret (include "repman.repman.config.secrets" . | fromYaml)) -}}

  {{/* Generate cronjobs */}}
  {{- range .Values.cronJobs -}}
    {{- if .enabled -}}
      {{- $_ := set $.Values.additionalControllers (printf "cronjob-%v" .name) (include "repman.cronjob" . | fromYaml) -}}
    {{- end -}}
  {{- end -}}

  {{/* Enable install or upgrade job */}}
  {{- if .Release.IsInstall -}}
    {{- $_ := set .Values.additionalControllers.install "enabled" true -}}
    {{- if .Values.createAdmin.enabled -}}
      {{- $_ := set (index . "Values" "additionalControllers" "create-admin") "enabled" true -}}
    {{- end -}}
  {{- else if .Release.IsUpgrade -}}
    {{- $_ := set .Values.additionalControllers.upgrade "enabled" true -}}
  {{- end -}}
{{- end -}}
