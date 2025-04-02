{{/*
Basename for elementCall resources
{{ include "elementCall.basename" . }}
*/}}
{{- define "elementCall.basename" -}}
element-call-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for elementCall
labels: {{ include "elementCall.labels" . | nindent 4 }}
*/}}
{{- define "elementCall.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: elementCall
# app.metaways.net/software: 
app.kubernetes.io/version: {{ .Values.elementCall.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match elementCall labels
selector: {{- include "elementCall.matchLabels" . | nindent 4 }}
*/}}
{{- define "elementCall.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: elementCall
{{- end -}}

{{/*
Secret name
secretName: {{ template "elementCall.secret" . }}
*/}}
{{- define "elementCall.secret" -}}
{{- if .Values.elementCall.secrets.existingSecret -}}
{{ .Values.elementCall.secrets.existingSecret }}
{{- else -}}
{{ include "elementCall.basename" . }}
{{- end -}}
{{- end -}}

{{/*
Pvc name
claimName: {{ template "elementCall.pvc" . }}
*/}}
{{- define "elementCall.pvc" -}}
{{- if .Values.elementCall.persistence.existingPvc -}}
{{ .Values.elementCall.persistence.existingPvc }}
{{- else -}}
{{ include "elementCall.basename" . }}
{{- end -}}
{{- end -}}