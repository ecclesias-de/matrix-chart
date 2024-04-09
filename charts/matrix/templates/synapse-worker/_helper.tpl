{{/*
Basename for synapse-worker resources
{{ include "synapse-worker.basename" . }}
*/}}
{{- define "synapse-worker.basename" -}}
synapse-worker-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for synapse-worker
labels: {{ include "synapse-worker.labels" . | nindent 4 }}
*/}}
{{- define "synapse-worker.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: synapse-worker
app.kubernetes.io/version: {{ .Values.synapse.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match synapse-worker labels
selector: {{- include "synapse-worker.matchLabels" . | nindent 4 }}
*/}}
{{- define "synapse-worker.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: synapse-worker
{{- end -}}