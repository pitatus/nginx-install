/etc/nginx/sites-available/example:
  file.managed:
    - source: salt://nginx/example
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/example:
  file.symlink:
    - target: /etc/nginx/sites-available/example
    - require:
      - file: /etc/nginx/sites-available/example

/var/www/example:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/var/www/example/index.html:
  file.managed:
    - source: salt://nginx/example.html.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-available/error:
  file.managed:
    - source: salt://nginx/domain-error.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640

/etc/nginx/sites-enabled/error:
  file.symlink:
    - target: /etc/nginx/sites-available/error
    - require:
      - file: /etc/nginx/sites-available/error

/var/www/error:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/var/www/error/domain-error.html:
  file.managed:
    - source: salt://nginx/domain-error.html
    - user: root
    - group: root
    - mode: 644

nginx-config-test:
  module.wait:
    - name: nginx.configtest

open_example_port:
  firewalld.present:
    - name: public
    - ports:
      - 3200/tcp

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
