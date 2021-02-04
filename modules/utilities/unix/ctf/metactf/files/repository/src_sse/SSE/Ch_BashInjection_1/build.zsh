#!/bin/zsh
SALT=`date +%g`
if [[ ARGC -gt 0 ]] then
  BINNAME=`basename $PWD`
  foreach USER ($@)
    mkdir -p obj/$USER
    gcc -Og -o obj/$USER/$BINNAME program.c
  end
  rm program.c
else
  echo "USAGE: build.zsh <user_email(s)>"
fi
