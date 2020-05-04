file.remove:
  module.run:
    - path: {{ salt['config.get']('config_dir')}}/minion.d/100-retry.conf
