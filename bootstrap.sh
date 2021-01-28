#!/bin/bash 

echo "*** Starting device bootstrap ***"

#Install homebrew
if ! [ -x "$(command -v brew)" ]
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

#Minimal dependencies
if ! [ -x "$(command -v git)" ]
then
  brew install git
fi

if ! [ -x "$(command -v ansible)" ]
then
  brew install ansible
fi

#Make sure we have the latest repo
if [ -d "./osx-setup" ]
then 
  #Git pull if the directory exists the repo
  git -C ./osx-setup pull
else
  #Git clone the repo
  git clone https://github.com/patrickfnielsen/osx-setup
fi


#Fix ansible localhost warning
export ANSIBLE_LOCALHOST_WARNING=False

if [ -z $(git config --global user.email) ]
then
  echo Enter your e-mail:
  read gitEmail

  echo Enter your name:
  read gitName
else
  export gitEmail="$(git config --global user.email)"
  export gitName="$(git config --global user.name)"
fi

#Run ansible playbook
echo "Running playbook 'setup-playbook.yml', please note you will be asked for you password before it runs!"
ansible-playbook osx-setup/setup-playbook.yml --extra-vars "git_global_name=$gitName git_global_email=$gitEmail" --ask-become-pass
