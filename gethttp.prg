
#Cinline


/* includes FlagShip */
#include "FSopenc.h"
#include "FSextend.h"


#include <stdio.h> /* printf, sprintf */
#include <stdlib.h> /* exit */
#include <string.h> /* memcpy, memset */
#include <winsock.h> /* socket, connect */



/* Global - descrição do último erro */
char errmsg[1024];


UDF_DECL(igethttp) /* argc, argv */
{

        char *host;
        char *message_fmt;
        char *operacao; // GET, POST
        struct hostent *server;
        struct sockaddr_in serv_addr;
        int portno, bytes, sent, received, total;
        char message[1024], response[65536];
        char * retorno;

        WSADATA data;
        SOCKET sockfd;
        SOCKADDR_IN sock;

        FSvar *retval;  /* geral para retorno de funcoes */

        retval = VAR_NEW;

// a.out api.somesite.com 80 POST / "name=ARG1&value=ARG2" "Content-Type: application/x-www-form-urlencoded"

        _setmode( _fileno( stdout ), 0x8000); // Compatibilidade para preservar os dados original sem conversão de chr(10) e chr(13)

        /* zerando mensagem de erro */
        MsgErrInit();

        if (argc < 3)
        {
           MsgErrAdd("isjgethttp", "Numero de parametros invalido !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);
        }

        portno       = VAR_INT(argv[0]);

//host        = _parc(1);
//message_fmt = _parc(2);


        host = (char *)malloc((strlen(VAR_CHR(argv[1]))*sizeof(char)) + 1);
        strcpy(host, VAR_CHR(argv[1]) + 0x0);

        message_fmt = (char *)malloc((strlen(VAR_CHR(argv[2]))*sizeof(char)) + 1);
        strcpy(message_fmt, VAR_CHR(argv[2]) + 0x0);

//host        = "desenvwin.inso.com.br";
//message_fmt = "GET /alfa44/gr5.exe\r\n\r\n";


        if(WSAStartup(MAKEWORD(1,1),&data)==SOCKET_ERROR){
           MsgErrAdd("isjgethttp", "ERROR inicialing winsocket !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);
        }
printf("Host:%s\n",host);
printf("Porta:%i\n",portno);
        /* fill in the parameters */
        sprintf(message,message_fmt);

printf("message_fmt:%s\n",message_fmt);
printf("Request:%s\n",message);

        /* create the socket */
        if((sockfd = socket(AF_INET,SOCK_STREAM,0))==SOCKET_ERROR)
        {
           MsgErrAdd("isjgethttp", "ERROR opening socket !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);
        }

        if (sockfd == INVALID_SOCKET) {
           MsgErrAdd("isjgethttp", "ERROR invalid socket !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);
        }

        /* lookup the ip address */
        server = gethostbyname(host);
        if (server == NULL)
        {
           MsgErrAdd("isjgethttp", "ERROR, no such host !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);

        }

        /* fill in the structure */
        memset(&serv_addr,0,sizeof(serv_addr));
        serv_addr.sin_family = AF_INET;
        serv_addr.sin_port   = htons(portno);
        memcpy(&serv_addr.sin_addr.s_addr,server->h_addr,server->h_length);

        /* connect the socket */
        if (connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) ==SOCKET_ERROR)
        {
           MsgErrAdd("isjgethttp", "ERROR connecting !", -1);
           SET_VAR_INT(retval,-1);
           return(retval);
        }

        /* send the request */
        total = strlen(message);
        sent  = 0;

        do {
            //bytes = write(sockfd,message+sent,total-sent);
            bytes = send(sockfd, message+sent,total-sent,0);
            if (bytes < 0)
            {
              MsgErrAdd("isjgethttp", "ERROR writing message to socket !", -1);
              SET_VAR_INT(retval,-1);
              return(retval);
            }
            if (bytes == 0)
                break;

            sent += bytes;
        }
        while (sent < total);

        memset(response, 0, sizeof(response));
        total    = sizeof(response)-1;
        received = 0;
        do {
            printf("RESPONSE: %s\n", response);
            // HANDLE RESPONSE CHUCK HERE BY, FOR EXAMPLE, SAVING TO A FILE.


            memset(response, 0, sizeof(response));
            bytes = recv(sockfd, response, 65536, 0);
            if (bytes == -1)
            {
              MsgErrAdd("isjgethttp", "ERROR reading response from socket !", -1);
              SET_VAR_INT(retval,-1);
              break;
            }

            if (bytes == 0)
                break;
            received+=bytes;
            retorno = (char *)malloc((strlen(response)*sizeof(char)) + 1);
            strcpy(retorno, response);
            SET_VAR_CHR(retval, retorno);

        }
        while (1);

        /* close the socket */

        closesocket(sockfd);
        WSACleanup();

//        SET_VAR_CHR(retval, response);

        return(retval);

}



/*------------------------------------------------------------------------------
**  oderrmsg - retorna o conteudo atual do buffer de mensagem de erro
**             os tipos de retorno sao diferentes para C e Flagship,
**             sendo necessario o uso de ifdefs
------------------------------------------------------------------------------*/
UDF_DECL(errigethtt)
{
        int i;
        FSvar *retval;  /* geral para retorno de funcoes */
        char *buffer;
        int bufsize;

        retval = VAR_NEW;

        i = strlen(errmsg);

        buffer = (char *)malloc((i+1)*sizeof(char));
        if (buffer == NULL) {
                SET_VAR_SPECIAL(retval, NIL_VAR);
                return(retval);
        }

        strncpy(buffer, errmsg, i);

        buffer[i] = 0x0;

        SET_VAR_CHR(retval, buffer);

        return(retval);
}




      int MsgErrInit(void)
      {
        errmsg[0] = 0x0;
        return(0);
      }

      /*------------------------------------------------------------------------------
      **  MsgErrAdd - gera mensagem de erro interno e concatena em errmsg
      ------------------------------------------------------------------------------*/
      int MsgErrAdd(char *funcao, char *diag, int retcode)
      {
          char bufmsg[1024];
          sprintf(bufmsg, "\ngethttp: erro interno em %s\nDiag: (%s)\nReturn Code: (%d)\n",
          funcao, diag, retcode);
          strcat(errmsg, bufmsg);
          return(0);
      }


#endCinline
