{% set DIR = salt['pillar.get']('rbd-path','/opt/rainbond') %}

#=========================== /cache directory ===========================
cache-dir:
  file.directory:
    - name: /cache
    - makedirs: True

cache-build-dir:
  file.directory:
    - name: /cache/build
    - makedirs: True

cache-source-dir:
  file.directory:
    - name: /cache/source
    - makedirs: True

#=========================== /grdata directory ===========================
grdata-dir:
  file.directory:
    - name: /grdata
    - makedirs: True

#=========================== rainbond/scripts directory ===========================
scripts-dir:
  file.directory:
    - name: {{ DIR }}/scripts
    - makedirs: True

#=========================== rainbond/envs directory ===========================
env-dir:
  file.directory:
    - name: {{ DIR }}/envs
    - makedirs: True


#=========================== rainbond/etc directory ===========================
etc-dir:
  file.directory:
    - name: {{ DIR }}/etc
    - makedirs: True

etc-chaos-dir:
  file.directory:
    - name: {{ DIR }}/etc/rbd-chaos/ssh
    - makedirs: True

etc-lb-dir:
  file.directory:
    - name: {{ DIR }}/etc/rbd-lb
    - makedirs: True

etc-db-dir:
  file.directory:
    - name: {{ DIR }}/etc/rbd-db
    - makedirs: True

etc-prometheus-dir:
  file.directory:
    - name: {{ DIR }}/etc/prometheus
    - makedirs: True

#=========================== rainbond/data directory ===========================
data-dir:
  file.directory:
    - name: {{ DIR }}/data
    - makedirs: True

data-db-dir:
 file.directory:
    - name: {{ DIR }}/data/rbd-db
    - makedirs: True

data-etcd-dir:
  file.directory:
    - name: {{ DIR }}/data/etcd
    - makedirs: True

#=========================== rainbond/logs directory ===========================
logs-dir:
  file.directory:
    - name: {{ DIR }}/logs
    - makedirs: True

logs-appui-dir:
  file.directory:
    - name: {{ DIR }}/logs/rbd-app-ui
    - makedirs: True

logs-lb-dir:
  file.directory:
    - name: {{ DIR }}/logs/rbd-lb
    - makedirs: True

logs-api-dir:
  file.directory:
    - name: {{ DIR }}/logs/rbd-api
    - makedirs: True

logs-eventlog-dir:
  file.directory:
    - name: {{ DIR }}/logs/rbd-eventlog
    - makedirs: True