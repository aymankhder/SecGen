#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>

int main()
{
  printf("      	UID         	GID +AFw-n"
     	"Real  	%d  Real  	%d +AFw-n"
     	"Effective %d  Effective %d +AFw-n",
     	getuid (), 	getgid (),
     	geteuid(), 	getegid());

  FILE *fp = fopen("flag1", "r");
  if (fp == NULL) {
  	printf("Error: Could not open file");
  	exit(EXIT_FAILURE);
  }
  char c;
  while ((c=getc(fp)) != EOF) {
    putchar(c);
  }
  putchar('+AFw-n');
  return EXIT_SUCCESS;
}
