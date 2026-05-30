echo "==== Ensure a valid UTF-8 locale for all users ..."
sudo tee /etc/profile.d/00-locale-fix.sh > /dev/null <<'EOF'
# Some environments set LC_CTYPE=UTF-8, which is not a valid locale name.
# Use C.UTF-8 to avoid warnings
if [ "${LANG:-}" = "UTF-8" ] || [ -z "${LANG:-}" ]; then
  echo "Overriding invalid LANG=${LANG}"
  export LANG=C.UTF-8
fi
if [ "${LC_CTYPE:-}" = "UTF-8" ] || [ -z "${LC_CTYPE:-}" ]; then
  echo "Overriding invalid LC_CTYPE=${LC_CTYPE}"
  export LC_CTYPE=C.UTF-8
fi
EOF
sudo chmod +x /etc/profile.d/00-locale-fix.sh
