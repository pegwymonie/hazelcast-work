{{/*1
Expects a List to be handed in. Will create a job for each elements in the list.
List should be formatted according to the scrape-job spec above.
*/}}
{{- define "prometheus-config" -}}
scrape_configs:
{{- range .}}
  - job_name: {{ .name }}
    dns_sd_configs:
    - names:
      - {{ .dnsEntry }}
      type: A
      port: 8080
      refresh_interval: 10s
    metric_relabel_configs:
      #Drop System Objects From the scrapes
      - source_labels:
          - tag0
        regex: (.name=__.*)
        action: drop
        #Relabel the objects to reflect that this is the object name
      - source_labels:
          - tag0
        regex: \"name=(.*)\"
        target_label: object_name
        replacement: $1
{{- end -}}
{{- end -}}
