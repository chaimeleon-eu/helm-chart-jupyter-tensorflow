{{/* vim: set filetype=mustache: */}}

{{/*
Chaimeleon annotations
*/}}
{{- define "chaimeleon.annotations" -}}
{{- if .Values.datasets_list }}
chaimeleon.eu/datasetsIDs: "{{ .Values.datasets_list }}"
{{- end }}
chaimeleon.eu/toolName: "{{ .Chart.Name }}"
chaimeleon.eu/toolVersion: "{{ .Chart.Version }}"
{{- end }}

{{/*
Obtain chaimeleon common variables
*/}}
{{- define "chaimeleon.ceph.user" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "ceph.user" | default (printf "%s-%s" "chaimeleon-user" .Release.Namespace) -}}
{{- end }}

{{- define "chaimeleon.ceph.gid" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "ceph.gid"  | int | default 1000 -}}
{{- end }}

{{- define "chaimeleon.ceph.monitor" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "ceph.monitor" -}}
{{- end }}

{{- define "chaimeleon.datalake.path" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "datalake.path" -}}
{{- end }}

{{- define "chaimeleon.datalake.mount_point" -}}
/mnt/datalake
{{- end }}

{{/* Generate the contents of a volume object wich provide access to the datalake folder. */}}
{{- define "chaimeleon.datalake.volume" -}}
cephfs:
  path: "{{ include "chaimeleon.datalake.path" . }}" 
  user: "{{ include "chaimeleon.ceph.user" . }}" 
  monitors:
      - "{{ include "chaimeleon.ceph.monitor" . }}"  
  secretRef:
      name: "ceph-auth"
  readOnly: true
{{- end }}

{{- define "chaimeleon.persistent_home.path" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "persistent_home.path" -}}
{{- end }}

{{- define "chaimeleon.persistent_home.mount_point" -}}
/home/chaimeleon/persistent-home
{{- end }}

{{/* Generate the contents of a volume object wich provide access to the persistent home folder. */}}
{{- define "chaimeleon.persistent_home.volume" -}}
cephfs:
  path: "{{ include "chaimeleon.persistent_home.path" . }}" 
  user: "{{ include "chaimeleon.ceph.user" . }}" 
  monitors:
      - "{{ include "chaimeleon.ceph.monitor" . }}"  
  secretRef:
      name: "ceph-auth"
{{- end }}

{{- define "chaimeleon.persistent_shared_folder.path" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "persistent_shared_folder.path" -}}
{{- end }}

{{- define "chaimeleon.persistent_shared_folder.mount_point" -}}
/home/chaimeleon/persistent-shared-folder
{{- end }}

{{/* Generate the contents of a volume object wich provide access to the persistent shared folder. */}}
{{- define "chaimeleon.persistent_shared_folder.volume" -}}
cephfs:
  path: "{{ include "chaimeleon.persistent_shared_folder.path" . }}" 
  user: "{{ include "chaimeleon.ceph.user" . }}" 
  monitors:
      - "{{ include "chaimeleon.ceph.monitor" . }}"  
  secretRef:
      name: "ceph-auth"
{{- end }}

{{- define "chaimeleon.datasets.path" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "datasets.path" -}}
{{- end }}

{{- define "chaimeleon.datasets.mount_point" -}}
/home/chaimeleon/datasets
{{- end }}

{{/* Generate the contents of a volume object wich provide access to a dataset files.
     Input required: a list with 2 params ( top-level scope, dataset Id ) */}}
{{- define "chaimeleon.dataset.volume" -}}
{{- $top := index . 0 -}}
{{- $datasetID := index . 1 -}}
cephfs:
  path: "{{ include "chaimeleon.datasets.path" $top }}/{{ $datasetID }}" 
  user: "{{ include "chaimeleon.ceph.user" $top }}" 
  monitors:
      - "{{ include "chaimeleon.ceph.monitor" $top }}"  
  secretRef:
      name: "ceph-auth"
  readOnly: true
{{- end }}


{{- define "chaimeleon.user.name" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "user.name" -}}
{{- end }}

{{- define "chaimeleon.user.uid" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "user.uid" | int -}}
{{- end }}

{{- define "chaimeleon.group.name" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "group.name" -}}
{{- end }}

{{- define "chaimeleon.group.gid" -}}
{{- $configmap := (lookup "v1" "ConfigMap" .Release.Namespace .Values.configmaps.chaimeleon) }}
{{- index $configmap "data" "group.gid" | int -}}
{{- end }}

