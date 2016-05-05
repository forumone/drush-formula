# Grab the repo, branch from pillar. Default to 8.x.
https://github.com/drush-ops/drush.git:
  git.latest:
    - rev: {{ salt['pillar.get']('drush:version', '8.x') }}
    - target: /opt/drush

# Drop a symlink for users' paths
/usr/local/bin/drush:
  file.symlink:
    - target: /opt/drush/drush
    - onlyif: test -f /opt/drush/drush

/opt/drush:
  composer.installed:
    - composer: /usr/local/bin/composer
    - php: /usr/bin/php

{% if salt['pillar.get']('drush:version') == '8.x' -%}
composer-install-drush8:
  cmd.run:
    - name: /usr/local/bin/composer install
    - cwd: /opt/drush
{%- endif %}

# Execute once to make sure requisites are installed
run-drush:
  cmd.run:
    - name: /usr/local/bin/drush > /opt/drush/testrun
    - require:
       - file: /usr/local/bin/drush
    - unless: test -f /opt/drush/testrun
