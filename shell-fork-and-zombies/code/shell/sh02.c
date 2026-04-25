main()
{
  char line[];
  int c, i, maxstr;
  maxstr = 80;

  while(1) {
    printf("> ");

    i = 0;

    while((c = getchar()) != '\n') {
      if(i < maxstr-1) {
        line[i++] = c;
      }
    }
    line[i] = '\n';
    line[++i] = '\0';

    if(cmpstr(line, "quit\n", 5)) {
      exit(0);
    } else {
      printf(line);
    }

  }
}

cmpstr(s1, s2, s2len)
char s1[];
char s2[];
int s2len; {
  int k;
  k = 0;

  while(k < s2len) {
    if(s1[k] != s2[k]) return(0);
    k++;
  }

  return(1);
}
