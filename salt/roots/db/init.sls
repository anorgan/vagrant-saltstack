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
  {% elif grains['os_family'] == 'RedHat' %}
  cmd.run:
    - name: rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && yum --enablerepo=remi-test --disablerepo=remi install compat mysql55
    - unless: test -e /etc/yum.repos.d/atomic.repo
  {% endif %}
  pkg:
    {% if grains['os_family'] == 'RedHat' %}
    - name: MariaDB-server
    {% endif %}
    - installed
    - refresh: True
    {% if grains['os'] == 'Ubuntu' %}
    - require:
      - cmd: mariadb-server-5.5
    {% endif %}
