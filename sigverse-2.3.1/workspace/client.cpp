#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 

#include <iostream>
#include <string>

void error(const char *msg)
{
  perror(msg);
  exit(0);
}

int main(int argc, char *argv[])
{
  int buffer_size = 230400; // 320*240*3 image
  int sockfd, portno, n;
  struct sockaddr_in serv_addr;
  struct hostent *server;

  char buffer[buffer_size];
  if (argc < 3) {
     fprintf(stderr, "usage %s hostname port\n", argv[0]);
     exit(0);
  }
  portno = atoi(argv[2]);
  sockfd = socket(AF_INET, SOCK_STREAM, 0);                                   // socket
  if (sockfd < 0) error("ERROR opening socket");
  server = gethostbyname(argv[1]);
  if (server == NULL) {
    fprintf(stderr, "ERROR, no such host\n");
    exit(0);
  }

  bzero((char *) &serv_addr, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  bcopy((char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
  serv_addr.sin_port = htons(portno);
  n = connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr));     // connect
  if (n < 0) error("ERROR connecting");

 while (true) {
    bzero(buffer, buffer_size);
    n = read(sockfd, buffer, buffer_size);                                       // read
    if (n < 0) error("ERROR reading from socket");
    std::cout << "message from server: state=" << std::endl;
    for (int j = 0; j < buffer_size; ++j)
      std::cout << int(buffer[j]) << " ";
    std::cout << std::endl;

    int action = -1;
    while (action < 0 or action > 9) {
      std::cout << "action? ";
      std::cin >> action;
    }

    n = write(sockfd, &action, 1);                    // write
    if (n < 0) error("ERROR writing to socket");
  }
  
  close(sockfd);
  return 0;
}

