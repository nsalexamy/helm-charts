{{- define "backend.service" }}

apiVersion: v1
kind: Service
metadata:
  name: {{ default (include "backend.fullname" .) .serviceName }}
  labels:
    {{- include "backend.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "backend.selectorLabels" . | nindent 4 }}

{{- end }}