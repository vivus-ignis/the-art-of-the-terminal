main()
{
  extern tsp;
  char ts[500];  /* allocating memory to copy strings */

  char cmd[1][];
  char args[10][];

  char line[80];

  int c, i, maxstr, maxargs;
  maxstr = 80;
  maxargs = 10;
  tsp = ts;

  while(1) {
    printf("> ");

    i = 0;

    while((c = getchar()) != '\n') {
      if(i < (maxstr-1)) {
        line[i++] = c;
      }
    }
    line[i] = '\n';
    line[++i] = '\0';

    if(cmpstr(line, "quit\n", 5)) {
      exit(0);
    } else {

      split(line, cmd, args);

      printf("[D] Running command\n");
      printf("[D] cmd = '%s'\n", cmd[0]);
      i = 0;
      while(i < maxargs) {
          if(args[i] == '\0') {
              break;
          }
          printf("[D] arg %d = '%s'\n", i, args[i]);
          i++;
      }

      run(cmd, args);
    }
  }
}

run(cmd, args)
char cmd[][];
char args[][]; {
  int pid;

  pid = fork();

  if (pid == -1) {
      printf("[!] Fork failed\n");
      exit(1);
  } else if (pid == 0) {
      printf("[D] In child process\n");
      execv(cmd[0], args);
      printf("[!] Exec failed\n");
      exit(1);
  } else {
      printf("[D] In parent process\n");
      wait();
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

/* this is shamelessly stolen from the c compiler code, file cc.c */
copy(s)
char s[]; {
  extern tsp;
  char tsp[], otsp[];

  otsp = tsp;
  while(*tsp++ = *s++);
  return(otsp);
}

split(cmdline, cmd, args)
char cmdline[];
char cmd[][];
char args[][]; {
    char word[80];
    int i, j, k, words, end, maxargs;

    i = k = words = end = 0;
    maxargs = 10;

    cmd[0] = '\0';
    while(i < maxargs) {
        args[i] = '\0';
        i++;
    }

    i = 0;

    while(1) {
        if(cmdline[i] == '\n') end = 1;
        if(cmdline[i] == ' ' | cmdline[i] == '\t' | cmdline[i] == '\n') {
            word[k] = '\0';

            if(words == 0) {
              cmd[0] = copy(word);
              args[words] = copy(word);
            } else {
              args[words] = copy(word);
            }

            if(end) break;

            i++;
            words++;

            k=0;
            word[0] = '\0';
        } else {
            word[k++] = cmdline[i++];
        }
    }
}

tsp;
