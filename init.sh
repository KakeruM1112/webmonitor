#!/bin/sh

# You need to execute 'pip3 install virtualenv' in advance.

cd src
if [ ! -e virtualenv ]; then
  virtualenv virtualenv
  source virtualenv/bin/activate
  pip3 install requests slackweb
  deactivate
fi

cd ..

