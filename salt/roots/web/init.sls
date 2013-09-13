{# Ty https://github.com/visualphoenix/awesome-saltstack #}

include:
  - .php

apache2:
  pkg:
    - installed
    {% if grains['os_family'] == 'RedHat' %}
    - name: httpd
    {% endif %}
  service:
    - running
    {% if grains['os_family'] == 'RedHat' %}
    - name: httpd
    {% endif %}
    - enable: True
    - require:
      - pkg: apache2


mariadb-server-5.5:
  {% if grains['os'] == 'Ubuntu' %}
  cmd.run:
    - name: sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
    - unless: apt-key list | grep -q 0xcbcb082a1bb943db
    - require:
      - file: mariadb-server-5.5
  file:
    - append
    - name: /etc/apt/sources.list
    - text: deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu quantal main
    - skip_verify: True
  {% endif %}
  pkg:
    {% if grains['os_family'] == 'RedHat' %}
    - name: mariadb
    {% endif %}
    - installed
    - refresh: True
    {% if grains['os'] == 'Ubuntu' %}
    - require:
      - cmd: mariadb-server-5.5
    {% endif %}


git:
  pkg:
    - installed