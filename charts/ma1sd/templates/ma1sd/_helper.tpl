{{/*
Basename for ma1sd resources
{{ include "ma1sd.basename" . }}
*/}}
{{- define "ma1sd.basename" -}}
ma1sd-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for ma1sd
labels: {{ include "ma1sd.labels" . | nindent 4 }}
*/}}
{{- define "ma1sd.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: ma1sd
app.kubernetes.io/version: {{ .Values.ma1sd.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match ma1sd labels
selector: {{- include "ma1sd.matchLabels" . | nindent 4 }}
*/}}
{{- define "ma1sd.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: ma1sd
{{- end -}}
