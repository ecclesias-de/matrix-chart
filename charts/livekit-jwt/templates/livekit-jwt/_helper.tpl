{{/*
Basename for livekitJwt resources
{{ include "livekitJwt.basename" . }}
*/}}
{{- define "livekitJwt.basename" -}}
livekit-jwt-{{ include "basename" . }}
{{- end -}}

{{/*
Kubernetes standard labels for livekitJwt
labels: {{ include "livekitJwt.labels" . | nindent 4 }}
*/}}
{{- define "livekitJwt.labels" -}}
{{ include "labels" . }}
app.kubernetes.io/component: livekitJwt
# app.metaways.net/software: 
app.kubernetes.io/version: {{ .Values.livekitJwt.deployment.image.tag | quote }}
{{- end -}}

{{/*
Labels used to match livekitJwt labels
selector: {{- include "livekitJwt.matchLabels" . | nindent 4 }}
*/}}
{{- define "livekitJwt.matchLabels" -}}
{{include "matchLabels" . }}
app.kubernetes.io/component: livekitJwt
{{- end -}}

{{/*
Secret name
secretName: {{ template "livekitJwt.secret" . }}
*/}}
{{- define "livekitJwt.secret" -}}
{{- if .Values.livekitJwt.secrets.existingSecret -}}
{{ .Values.livekitJwt.secrets.existingSecret }}
{{- else -}}
{{ include "livekitJwt.basename" . }}
{{- end -}}
{{- end -}}

{{/*
Pvc name
claimName: {{ template "livekitJwt.pvc" . }}
*/}}
{{- define "livekitJwt.pvc" -}}
{{- if .Values.livekitJwt.persistence.existingPvc -}}
{{ .Values.livekitJwt.persistence.existingPvc }}
{{- else -}}
{{ include "livekitJwt.basename" . }}
{{- end -}}
{{- end -}}