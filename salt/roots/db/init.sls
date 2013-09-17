{% if grains['os_family'] == 'RedHat' %}
/etc/yum.repos.d/MariaDB.repo:
  file.managed:
    - source: salt://db/MariaDB.repo
    - user: root
    - group: root
    - mode: 644

mariadb-client:
  pkg.installed:
    - name: MariaDB-client

{% endif %}
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
    - name: MariaDB-server
    {% endif %}
    - installed
    {% if grains['os'] == 'Ubuntu' %}
    - require:
      - cmd: mariadb-server-5.5
    {% elif grains['os_family'] == 'RedHat' %}
    
    {% endif %}
