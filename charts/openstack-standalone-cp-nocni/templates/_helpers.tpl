{{- define "cluster.name" -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openstackmachinetemplate.controlplane.name" -}}
    {{- include "cluster.name" . }}-cp-mt
{{- end }}

{{- define "openstackmachinetemplate.worker.name" -}}
    {{- include "cluster.name" . }}-worker-mt
{{- end }}

{{- define "openstackmachinetemplate.ingress.name" -}}
    {{- include "cluster.name" . }}-ingress-mt
{{- end }}

{{- define "openstackmachinetemplate.gpu.name" -}}
    {{- include "cluster.name" . }}-gpu-mt
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

{{- define "machinedeployment.gpu.name" -}}
    {{- include "cluster.name" . }}-gpu-md
{{- end }}
