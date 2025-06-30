{{- define "cluster.name" -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "openstackmachinetemplate.controlplane.name" -}}
    {{- include "cluster.name" . }}-cp-mt-{{ .Values.controlPlane.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.worker.name" -}}
    {{- include "cluster.name" . }}-worker-mt-{{ .Values.worker.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.ingress.name" -}}
    {{- include "cluster.name" . }}-ingress-mt-{{ .Values.ingress.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpul4.name" -}}
    {{- include "cluster.name" . }}-gpul4-mt-{{ .Values.gpul4.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpul40.name" -}}
    {{- include "cluster.name" . }}-gpul40-mt-{{ .Values.gpul40.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpuh100.name" -}}
    {{- include "cluster.name" . }}-gpuh100-mt-{{ .Values.gpuh100.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpuh200.name" -}}
    {{- include "cluster.name" . }}-gpuh200-mt-{{ .Values.gpuh200.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpub200.name" -}}
    {{- include "cluster.name" . }}-gpub200-mt-{{ .Values.gpub200.image | toString | sha256sum | trunc 8 }}
{{- end }}

{{- define "openstackmachinetemplate.gpub200vm.name" -}}
    {{- include "cluster.name" . }}-gpub200vm-mt-{{ .Values.gpub200vm.image | toString | sha256sum | trunc 8 }}
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

{{- define "machinedeployment.gpuh200.name" -}}
    {{- include "cluster.name" . }}-gpuh200-md
{{- end }}

{{- define "machinedeployment.gpuh100.name" -}}
    {{- include "cluster.name" . }}-gpuh100-md
{{- end }}

{{- define "machinedeployment.gpub200vm.name" -}}
    {{- include "cluster.name" . }}-gpub200vm-md
{{- end }}

{{- define "machinedeployment.gpub200.name" -}}
    {{- include "cluster.name" . }}-gpub200-md
{{- end }}