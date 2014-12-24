sed -i -e '/session    required     pam_selinux.so open/i\
session    required     \/lib64\/security\/pam_limits.so\
session    required     pam_limits.so' /etc/pam.d/login
