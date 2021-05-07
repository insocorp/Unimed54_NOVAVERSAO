#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function pagnet_export_html(pcPARAM1, pcPARAM2)
   whttphead("text/html")

   #include "../wh/pagnet_export_html.wh"

return
