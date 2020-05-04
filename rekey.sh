if [ -z "$FILE_ROOT_DIR" ]; then
  if [ -z "$FILE_ROOT_ENV" ]; then
    FILE_ROOT_ENV=base
  fi
  FILE_ROOT_DIR=$(salt-run config.get file_roots:$FILE_ROOT_ENV | head -n 1 | cut -c 3-)
fi
if [ -z "$PKI_DIR" ]; then
  PKI_DIR=$(salt-run config.get pki_dir)
fi
if [ -z "$MINION_RESTART_WAIT" ]; then
  MINION_RESTART_WAIT=120
fi

echo '======== Environment ========'
if [ -n "$FILE_ROOT_ENV" ]; then
  echo FILE_ROOT_ENV: $FILE_ROOT_ENV
fi
echo FILE_ROOT_DIR: $FILE_ROOT_DIR
echo PKI_DIR: $PKI_DIR
echo MINION_RESTART_WAIT: $MINION_RESTART_WAIT
echo '============================='


echo 'Setup minion rekey states'
cp states/rekey-minions.sls states/rekey-minions-cleanup.sls states/rekey-minion.sh $FILE_ROOT_DIR

echo 'Send command to rekey salt minions (No response from minions is expected)'
salt '*' state.sls rekey-minions

echo 'Rekey salt master'
rm -r $PKI_DIR
echo 'Restart salt master'
systemctl restart salt-master

echo "Sleep for $MINION_RESTART_WAIT"
sleep $MINION_RESTART_WAIT
salt-key -A -y

echo "Sleep for $MINION_RESTART_WAIT"
sleep $MINION_RESTART_WAIT

echo 'Run cleanup on minions'
salt '*' state.sls rekey-minions-cleanup

echo "Cleanup minion rekey states"
rm $FILE_ROOT_DIR/rekey-minions.sls
rm $FILE_ROOT_DIR/rekey-minions-cleanup.sls
rm $FILE_ROOT_DIR/rekey-minion.sh
