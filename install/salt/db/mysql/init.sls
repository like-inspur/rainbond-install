{% set DBIMG = salt['pillar.get']('database:mysql:image') -%}
{% set DBVER = salt['pillar.get']('database:mysql:version') -%}
{% set DBPORT = salt['pillar.get']('database:mysql:port') -%}
{% set DBUSER = salt['pillar.get']('database:mysql:user') -%}
{% set DBPASS = salt['pillar.get']('database:mysql:pass') -%}
{% set PUBDOMAIN = salt['pillar.get']('public-image-domain') -%}

docker-pull-db-image:
  cmd.run:
{% if pillar['install-type']!="offline" %}
    - name: docker pull {{PUBDOMAIN}}/{{ DBIMG }}:{{ DBVER }}
{% else %}
    - name: docker load -i {{ pillar['install-script-path'] }}/install/imgs/{{PUBDOMAIN}}_{{ DBIMG }}_{{ DBVER }}.gz
{% endif %}
    - unless: docker inspect {{PUBDOMAIN}}/{{ DBIMG }}:{{ DBVER }}

my.cnf:
  file.managed:
    - source: salt://db/mysql/files/my.cnf
    - name: {{ pillar['rbd-path'] }}/etc/rbd-db/my.cnf
    - makedirs: True

charset.cnf:
  file.managed:
    - source: salt://db/mysql/files/charset.cnf
    - name: {{ pillar['rbd-path'] }}/etc/rbd-db/conf.d/charset.cnf
    - makedirs: True

db-upstart:
  cmd.run:
    - name: dc-compose up -d rbd-db
    - unless: check_compose rbd-db
    - require:
      - cmd: docker-pull-db-image
      - file: charset.cnf
      - file: my.cnf

waiting_for_db:
  cmd.run:
    - name: docker exec rbd-db mysql -e "show databases"
    - require:
      - cmd: db-upstart
    - retry:
        attempts: 20
        until: True
        interval: 3
        splay: 3

create_mysql_admin:
  cmd.run:
    - name: docker exec rbd-db mysql -e "grant all on *.* to '{{ DBUSER }}'@'%' identified by '{{ DBPASS }}' with grant option; flush privileges";docker exec rbd-db mysql -e "delete from mysql.user where user=''; flush privileges"
    - unless: docker exec rbd-db mysql -u {{ DBUSER }} -P {{ DBPORT }} -p{{ DBPASS }} -e "select user,host,grant_priv from mysql.user where user={{ DBUSER }}"
    - require:
      - cmd: waiting_for_db
    
create_region:
  cmd.run: 
    - name: docker exec rbd-db mysql -e "CREATE DATABASE IF NOT EXISTS region DEFAULT CHARSET utf8 COLLATE utf8_general_ci;"
    - require:
      - cmd: waiting_for_db

create_console:
  cmd.run:     
    - name: docker exec rbd-db mysql -e "CREATE DATABASE IF NOT EXISTS console DEFAULT CHARSET utf8 COLLATE utf8_general_ci;"
    - require:
      - cmd: waiting_for_db
