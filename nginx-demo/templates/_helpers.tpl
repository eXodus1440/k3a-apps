{{/*
Expand the name of the chart.
*/}}
{{- define "chart-defaults.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Returns the hostname assembled using `hosts.nginx` as the prefix, and `hosts.domain` domain.
*/}}
{{- define "chart-defaults.hostname" -}}
{{- printf "%s.%s" .Values.hosts.nginx .Values.hosts.domain -}}
{{- end -}}

{{/*
Returns the Url, ex: `http://nginx-demo.example.com` if `hosts.https` is true, it uses https, otherwise http.
Calls into the `chart-defaults.hostname` function for the hostname part of the url.
*/}}
{{- define "chart-defaults.url" -}}
{{- if .Values.ingress.tls -}}
{{-   printf "https://%s" (include "chart-defaults.hostname" .) -}}
{{- else -}}
{{-   printf "http://%s" (include "chart-defaults.hostname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chart-defaults.fullname" -}}
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
{{- define "chart-defaults.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chart-defaults.labels" -}}
helm.sh/chart: {{ include "chart-defaults.chart" . }}
{{ include "chart-defaults.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chart-defaults.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chart-defaults.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "chart-defaults.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "chart-defaults.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
