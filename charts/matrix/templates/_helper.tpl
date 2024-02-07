{{/*
Basename for chart resources
{{ include "basename" . }}
*/}}
{{- define "basename" -}}
{{ if hasSuffix .Chart.Name .Release.Name  }}
{{- .Release.Name -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Kubernetes standard labels
labels: {{ include "labels" . | nindent 4 }}
*/}}
{{- define "labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}

{{/*
Labels used to match standard labels
selector: {{- include "matchLabels" . | nindent 4 }}
*/}}
{{- define "matchLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
