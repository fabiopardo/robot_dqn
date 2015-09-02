#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

#include <iostream>
#include <string>

void error(const char *msg)
{
  perror(msg);
  exit(1);
}

int main(int argc, char *argv[])
{
  int sockfd, newsockfd, portno;
  socklen_t clilen;
  char buffer[256];
  struct sockaddr_in serv_addr, cli_addr;
  int n;
  if (argc < 2) {
    fprintf(stderr, "ERROR, no port provided\n");
    exit(1);
  }

  sockfd = socket(AF_INET, SOCK_STREAM, 0);                               // socket
  if (sockfd < 0) error("ERROR opening socket");
  bzero((char *) &serv_addr, sizeof(serv_addr));
  portno = atoi(argv[1]);
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = INADDR_ANY;
  serv_addr.sin_port = htons(portno);
  n = bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr));    // bind
  if (n < 0) error("ERROR on binding");

  listen(sockfd, 1);                                                      // listen
  clilen = sizeof(cli_addr);
  newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);     // accept (blocks until a client connects)
  if (newsockfd < 0) error("ERROR on accept");

  for (int i = 0; i < 3; ++i) {
    bzero(buffer, 256);
    const std::string state("stuck");
    n = write(newsockfd, state.c_str(), state.size());                           // write
    if (n < 0) error("ERROR writing to socket");

    bzero(buffer, 256);
    n = read(newsockfd, buffer, 255);                                            // read
    if (n < 0) error("ERROR reading from socket");
    printf("message from client: action=%s\n", buffer);
  }

  close(newsockfd);
  close(sockfd);
  return 0; 
}

