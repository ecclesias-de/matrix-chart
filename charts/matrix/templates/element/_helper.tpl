{{/*
Basename for element resources
{{ include "element.basename" . }}
*/}}
{{- define "element.basename" -}}
element-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for element
labels: {{ include "element.labels" . | nindent 4 }}
*/}}
{{- define "element.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: element
app.kubernetes.io/version: {{ .Values.element.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match element labels
selector: {{- include "element.matchLabels" . | nindent 4 }}
*/}}
{{- define "element.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: element
{{- end -}}
