{{/*
Basename for corporal resources
{{ include "corporal.basename" . }}
*/}}
{{- define "corporal.basename" -}}
corporal-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for corporal
labels: {{ include "corporal.labels" . | nindent 4 }}
*/}}
{{- define "corporal.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: corporal
app.kubernetes.io/version: {{ .Values.corporal.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match corporal labels
selector: {{- include "corporal.matchLabels" . | nindent 4 }}
*/}}
{{- define "corporal.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: corporal
{{- end -}}

{{/*
Secret name
secretName: {{ template "corporal.secret" . }}
*/}}
{{- define "corporal.secret" -}}
{{- if .Values.corporal.secrets.existingSecret -}}
{{ .Values.corporal.secrets.existingSecret }}
{{- else -}}
{{ include "corporal.basename" . }}
{{- end -}}
{{- end -}}
