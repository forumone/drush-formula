# Grab the repo, branch from pillar. Default to 10.x.
https://github.com/drush-ops/drush.git:
  git.latest:
    - rev: {{ salt['pillar.get']('drush:version', '10.x') }}
    - target: /opt/drush
    - force_reset: True

/opt/drush:
  composer.installed:
    - composer: /usr/local/bin/composer
    - php: /usr/bin/php
    - onchanges:
      - git: https://github.com/drush-ops/drush.git

# Execute once to make sure requisites are installed
run-drush:
  cmd.run:
    - name: /usr/local/bin/drush > /opt/drush/testrun
    - require:
       - file: /usr/local/bin/drush
    - unless: test -f /opt/drush/testrun

# Drop a symlink for users' paths
/usr/local/bin/drush:
  file.symlink:
    - target: /opt/drush/drush
    - onlyif: test -f /opt/drush/drush

