php5-pkgs:
  pkg.installed:
    - names:
      - php5
      - php5-mysql
      - php5-curl
      - php5-cli
      - php5-cgi
      - php5-dev
      - php-pear
      - php5-gd
      - php5-imagick

apache2:
  pkg:
    - installed
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: httpd
    {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: apache2
    {% endif %}
  service:
    - running
    {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: httpd
    {% endif %}
    - enable: True
    - require:
      - pkg: apache2

{% if grains['os'] == 'Ubuntu'%}
mariadb-server-5.5:
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
  pkg:
    - installed
    - refresh: True
    - require:
      - cmd: mariadb-server-5.5
{% endif %}

git:
  pkg:
    - installed