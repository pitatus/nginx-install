install-nginx:
  pkg.installed:
    - name: nginx

install-firewalld:
  pkg.installed:
    - name: firewalld

/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://nginx/default.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default

/var/www/html/index.html:
  file.managed:
    - source: salt://nginx/default.html.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

nginx-config-test:
  module.wait:
    - name: nginx.configtest

start-firewalld:
  service.running:
    - name: firewalld
    - enable: True

open_nginx_ports:
  firewalld.present:
    - name: public
    - ports:
      - 80/tcp
      - 22/tcp

reload-nginx:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - module: nginx-config-test
      - module: nginx-reload

nginx-reload:
  module.wait:
    - name: nginx.signal reload


