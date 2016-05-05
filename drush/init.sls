# Grab the repo, branch from pillar. Default to 6.x.
https://github.com/drush-ops/drush.git:
  git.latest:
    - rev: {{ salt['pillar.get']('drush:version', '6.x') }}
    - target: /opt/drush

# Drop a symlink for users' paths
/usr/local/bin/drush:
  file.symlink:
    - target: /opt/drush/drush
    - onlyif: test -f /opt/drush/drush

{% if salt['pillar.get']('drush:version') == '8.x' -%}
composer-install-drush8:
  cmd.run:
    - name: /usr/local/bin/composer install
    - cwd: /opt/drush
    - require:
      - file: /usr/local/bin/composer
{%- endif %}

# Execute once to make sure requisites are installed
run-drush:
  cmd.run:
    - name: /usr/local/bin/drush > /opt/drush/testrun
    - require:
       - file: /usr/local/bin/drush
    - unless: test -f /opt/drush/testrun
