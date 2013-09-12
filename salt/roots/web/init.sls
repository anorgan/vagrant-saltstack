# Ty https://github.com/visualphoenix/awesome-saltstack

# This doesn't run - can't create www-data user
www-data:
  user.present:
    - shell: /sbin/nologin
    - home: False
    - system: False

{% set php = "php" %}
{% if grains['os_family'] == 'Debian' %}
  {% set v = "php5" %}
{% endif %}


{% if grains['os_family'] == 'RedHat' %}
php-epel:
  cmd.run:
    - name: curl -L http://www.atomicorp.com/installers/atomic | grep -v "check_input \"" | sudo sh
    - unless: test -e /etc/yum.repos.d/atomic.repo
{% endif %}

php5-pkgs:
  pkg.installed:
    {% if grains['os_family'] == 'RedHat' %}
    - repo: remi
    - require:
      - cmd: php-epel
      # - user: www-data
    {% endif %}
    - names:
      - {{ php }}
      {% if grains['os_family'] == 'RedHat' %}
      - php-common
      {% endif %}
      - {{ php }}-mysql
      - {{ php }}-curl
      - {{ php }}-cli
      - {{ php }}-cgi
      - {{ php }}-dev
      - php-pear
      - {{ php }}-gd
      - {{ php }}-imagick

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

{% if grains['os'] == 'Ubuntu' %}
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