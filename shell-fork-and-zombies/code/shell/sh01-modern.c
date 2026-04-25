#include <stdio.h>

int main()
{
  int c;

  while(1)
  {
    printf("> ");
    while((c = getchar()) != '\n')
    {
        putchar(c);
    }
    putchar('\n');
  }
}
