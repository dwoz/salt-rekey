rm -r $PKI_DIR
systemctl restart salt-minion
sleep 60
rm $CONF_FILE
