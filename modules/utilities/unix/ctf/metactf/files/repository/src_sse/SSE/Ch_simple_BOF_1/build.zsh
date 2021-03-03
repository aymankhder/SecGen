#!/bin/zsh
SALT=`date +%g`
if [[ ARGC -gt 0 ]] then
  BINNAME=`basename $PWD`
  foreach USER ($@)
    mkdir -p obj/$USER
    gcc -g -m32 -z execstack -z norelro -fno-pie -no-pie -o obj/$USER/$BINNAME program.c
  end
else
  echo "USAGE: build.zsh <user_email(s)>"
fi
