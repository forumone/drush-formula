get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

install-drush:
  cmd.run:
    - name: COMPOSER_HOME=/opt/drush COMPOSER_BIN_DIR=/usr/local/bin COMPOSER_VENDOR_DIR=/opt/drush/{{ salt['pillar.get']('drush:branch', '8') }} /usr/local/bin/composer require drush/drush:{{ salt['pillar.get']('drush:branch', '8') }}
    - cwd: /root/
