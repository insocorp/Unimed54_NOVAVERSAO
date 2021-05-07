#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function make_lst_html(pnMODE,pcTARGET_SRC,pcPROG_SRC,paONCLICK,paBUTTON,pcPROGRAM,pcTARGET_MOD,paFLD_JAVA,paQUICK_SCH,paFLDS_GRID,paFLDS_DB,pcTABLE,paJOIN,paWHERE,paORDERBY,pcSORT,paGROUPBY,paLIMIT,pcDBNAME)
   whttphead("text/html")
   gbFL_UI_DYN := .t.

   #include "../wh/make_lst_html.wh"

return
