#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function werror_access_wic()
   whttphead("text/html")
   gbFL_UI_DYN := .t.

   #include "../wh/werror_access_wic.wh"

return
