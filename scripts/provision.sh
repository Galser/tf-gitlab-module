#!/usr/bin/env bash
# Provision script for GitLab proxy instance
sudo apt update -q -y
if [ $? -ne 0 ]; then
  echo "First APT update failed, retrying"
  for i in 1 2 3
  do
    sudo apt update -q -y
    if [ $? -eq 0 ]; then
      break;
    fi # APT success
  done # APT repeats
  exit 1
fi
sleep 3
sudo apt update -y
sleep 3
which curl || (
  sudo apt install -y curl wget openssh-server ca-certificates
  sleep 3
  # installing GitLab repo
  curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
)