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
app.metaways.net/software: nginx
app.kubernetes.io/version: {{ .Values.wellknown.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match well-known labels
selector: {{- include "wellknown.matchLabels" . | nindent 4 }}
*/}}
{{- define "wellknown.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: well-known
{{- end -}}
