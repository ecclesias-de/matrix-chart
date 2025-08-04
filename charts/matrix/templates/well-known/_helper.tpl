{{/*
Basename for well-known resources
{{ include "wellknown.basename" . }}
*/}}
{{- define "wellknown.basename" -}}
well-known-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for well-known
labels: {{ include "wellknown.labels" . | nindent 4 }}
*/}}
{{- define "wellknown.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: well-known
{{- end -}}