#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function pfpj_cf_tipo_campo_html()
   whttphead("text/html")
   gbFL_UI_DYN := .t.

   #include "../wh/pfpj_cf_tipo_campo_html.wh"

return