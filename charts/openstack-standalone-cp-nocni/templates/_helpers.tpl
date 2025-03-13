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

{{- define "openstackmachinetemplate.gpul4.name" -}}
    {{- include "cluster.name" . }}-gpul4-mt
{{- end }}

{{- define "openstackmachinetemplate.gpul40.name" -}}
    {{- include "cluster.name" . }}-gpul40-mt
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

{{- define "machinedeployment.gpul4.name" -}}
    {{- include "cluster.name" . }}-gpul4-md
{{- end }}

{{- define "machinedeployment.gpul40.name" -}}
    {{- include "cluster.name" . }}-gpul40-md
{{- end }}
