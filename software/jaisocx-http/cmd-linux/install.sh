sudo touch /etc/systemd/system/jaisocx.service
cp --no-target-directory "service-template/jaisocx.service" "/etc/systemd/system/jaisocx.service"
sudo systemctl daemon-reload
sudo systemctl enable jaisocx.service
sudo systemctl start jaisocx