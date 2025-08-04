{{/*
Basename for nginx resources
{{ include "nginx.basename" . }}
*/}}
{{- define "nginx.basename" -}}
nginx-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for nginx
labels: {{ include "nginx.labels" . | nindent 4 }}
*/}}
{{- define "nginx.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: nginx
app.kubernetes.io/version: {{ .Values.nginx.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match nginx labels
selector: {{- include "nginx.matchLabels" . | nindent 4 }}
*/}}
{{- define "nginx.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: nginx
{{- end -}}