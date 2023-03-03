{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb.fullName" }}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb.chart" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb.labels" }}
helm.sh/chart: {{ include "mongodb.chart" . }}
{{ include "mongodb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ lower .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongodb.selectorLabels" }}
app.kubernetes.io/name: {{ include "mongodb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongodb.serviceAccountName" }}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongodb.fullName" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret containing credentials
*/}}
{{- define "mongodb.secretName" }}
{{- if .Values.auth.secretName }}
{{- printf "%s" (tpl .Values.auth.secretName $) }}
{{- else }}
{{- printf "%s" (include "mongodb.fullName" .) }}
{{- end }}
{{- end }}

{{/*
Create the key of the value containing root user secret
*/}}
{{- define "mongodb.secretKeyUser" }}
{{- default "mongodb-root-user" (tpl .Values.auth.secretKeyUser $) }}
{{- end }}

{{/*
Create the key of the value containing root password secret
*/}}
{{- define "mongodb.secretKeyPassword" }}
{{- default "mongodb-root-password" (tpl .Values.auth.secretKeyPassword $) }}
{{- end }}
