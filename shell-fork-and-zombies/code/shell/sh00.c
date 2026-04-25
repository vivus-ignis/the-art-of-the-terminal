main()
{
  int pid;
  pid = fork();
  switch (pid) {
    case -1:
      printf("Fork failed\n");
      exit(1);
    case 0:
      printf("In parent process\n");
      exit(0);
    default:
      printf("In child process\n");
      exit(0);
  }
}
