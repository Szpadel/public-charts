{{- define "headscale.headplaneConfigMapName" -}}
{{- printf "%s-headplane-config" (include "common.names.fullname" .) -}}
{{- end -}}

{{- define "headscale.headplaneCookieSecretName" -}}
{{- if .Values.headplane.cookieSecret.existingSecret -}}
{{- .Values.headplane.cookieSecret.existingSecret -}}
{{- else -}}
{{- printf "%s-headplane-cookie" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
