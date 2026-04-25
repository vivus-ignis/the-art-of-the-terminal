main()
{
  int nproc, i, pid;
  char args[2][];

  nproc = 20;
  i = 0;
  args[0] = "date";
  args[1] = '\0';

  while (i++ < nproc) {
    pid = fork();
    if (pid == -1) {
        printf("[!] Fork failed\n");
        exit(1);
    } else if (pid == 0) {
        printf("[D] In child process %d\n", i);
        execv("/bin/date", args);
        printf("[!] Exec failed\n");
        exit(1);
    } else {
        printf("[D] In parent process\n");
        /* wait(); */
    }
  }
}
