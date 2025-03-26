{{- define "cluster.name" -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "awsmachinetemplate.controlplane.name" -}}
    {{- include "cluster.name" . }}-cp-mt
{{- end }}

{{- define "awsmachinetemplate.worker.name" -}}
    {{- include "cluster.name" . }}-worker-mt
{{- end }}

{{- define "awsmachinetemplate.ingress.name" -}}
    {{- include "cluster.name" . }}-ingress-mt
{{- end }}

{{- define "awsmachinetemplate.gpua10.name" -}}
    {{- include "cluster.name" . }}-gpua10-mt
{{- end }}

{{- define "k0scontrolplane.name" -}}
    {{- include "cluster.name" . }}-cp
{{- end }}

{{- define "k0sworkerconfigtemplate.name" -}}
    {{- include "cluster.name" . }}-machine-config
{{- end }}

{{- define "machinedeployment.worker.name" -}}
    {{- include "cluster.name" . }}-worker-md
{{- end }}

{{- define "machinedeployment.ingress.name" -}}
    {{- include "cluster.name" . }}-ingress-md
{{- end }}

{{- define "machinedeployment.gpua10.name" -}}
    {{- include "cluster.name" . }}-gpua10-md
{{- end }}
