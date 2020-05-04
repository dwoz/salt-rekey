rejected_config:
  file.managed:
    - name: {{ salt['config.get']('config_dir')}}/minion.d/100-retry.conf
    - contents: |
        rejected_retry: True

script:
  cmd.script:
    - name: salt://rekey-minion.sh
    - env:
       - PKI_DIR: {{ salt['config.get']('pki_dir') }}
