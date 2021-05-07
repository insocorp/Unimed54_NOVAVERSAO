#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )
#define DLAP chr(39)                  // delimited ( ' )
function build_program(pcTABLE,paJOIN,paWHERE,paORDERBY,pcSORT,paGROUPBY,paLIMIT,pcDBNAME,pnPROG_TYPE,pcTARGET_SRC,pcPROG_SRC,paONCLICK,paBUTTON,pcPROGRAM,pcTARGET_MOD,paFLD_JAVA,paQUICK_SCH,paFLDS_HIDDEN,paFLDS_INPUT,paFLDS_GRID,paFLDS_DB,paBTN_LST,paBTN_MNT)
   whttphead("text/html")
   gbFL_UI_DYN := .t.

   #include "../wh/build_program.wh"

return
