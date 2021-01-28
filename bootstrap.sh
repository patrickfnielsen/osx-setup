#!/bin/bash 

echo "*** Starting device bootstrap ***"

#Install homebrew
if ! command -v brew &> /dev/null
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

#Minimal dependencies
if ! command -v git &> /dev/null
then
  brew install git
fi

if ! command -v ansible &> /dev/null
then
  brew install ansible
fi

#Git clone the repo
git clone https://github.com/patrickfnielsen/osx-setup

#Fix ansible localhost warning
export ANSIBLE_LOCALHOST_WARNING=False

if [ -z $(git config --global user.email) ]
then
  echo Enter your e-mail:
  read gitEmail

  echo Enter your name:
  read gitName
else
  export gitEmail=$(git config --global user.email)
  export gitName=$(git config --global user.name)
fi

#Run ansible playbook
echo "Running playbook 'setup-playbook.yml', please note you will be asked for you password before it runs!"
ansible-playbook osx-setup/setup-playbook.yml --extra-vars "git_global_name=$gitName git_global_email=$gitEmail" --ask-become-pass
