#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function sias_caixa_html(pcPARAM)
   whttphead("text/html")

   #include "../wh/sias_caixa_html.wh"

return
