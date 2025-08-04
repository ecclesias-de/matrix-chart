{{/*
Basename for synapse resources
{{ include "synapse.basename" . }}
*/}}
{{- define "synapse.basename" -}}
synapse-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for synapse
labels: {{ include "synapse.labels" . | nindent 4 }}
*/}}
{{- define "synapse.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: synapse
app.kubernetes.io/version: {{ .Values.synapse.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match synapse labels
selector: {{- include "synapse.matchLabels" . | nindent 4 }}
*/}}
{{- define "synapse.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: synapse
{{- end -}}

{{/*
Pvc name
claimName: {{ template "synapse.pvc" . }}
*/}}
{{- define "synapse.pvc" -}}
{{- if .Values.synapse.pvc.existingPvc -}}
{{ .Values.synapse.pvc.existingPvc }}
{{- else -}}
{{ include "synapse.basename" . }}
{{- end -}}
{{- end -}}

{{/*
Secret name
secretName: {{ template "synapse.secret" . }}
*/}}
{{- define "synapse.secret" -}}
{{- if .Values.synapse.secrets.existingSecret -}}
{{ .Values.synapse.secrets.existingSecret }}
{{- else -}}
{{ include "synapse.basename" . }}
{{- end -}}
{{- end -}}