

/*
* Autor.....: Consultoria - 09/09/2008
* Function..: wingedstructfile(fnGED,fnGEDFILE,fnGEDFVERS)
* Objetivo..:
* Parâmetros:
*   fnGED:....: Documento GED
*   fnGEDFILE.: Id do arquivo a ser armazenado no GED
*   fnGEDFVERS: Versão do arquivo armazenado (utilizado para geração da extensão do arquivo)
* Retorno: 
*               Retorna o caminho com completo com o nome do arquivo
*   
* 
*
*/
static function wingedstructfile(fnGED,fnGEDFILE,fnGEDFVERS)

   #define lcDIRSEP  '\'
   local lcDIR    := '' ,;
   		   lcDIRW   := '' ,;
         lcFILE   := '' ,;
         lcRETURN := '' as string

   local laDIR    := {} as array

   local llWIN32  := .f. as logical

   if valtype(fnGED) == 'U' .or. fnGED == 0
      puterror('wingedstructfile: GED not defined')
      return('')
   endif

   if valtype(fnGEDFILE) == 'U' .or. fnGEDFILE == 0
      puterror('wingedstructfile: File not defined')
      return('')
   endif

   if valtype(fnGEDFVERS) == 'U' .or. fnGEDFVERS == 0
      puterror('wingedstructfile: GED version not defined')
      return('')
   endif

   lcDIR := alltrim(lower(wset('PATHGED')))

   //walert('Rodou wingedstructfile em ged_mgrnew')
   llWIN32  := .t.
   
   if empty(lcDIR)
      lcDIR := '\gedstor'
      run('mkdir '+lcDIR)
      lcDIRW   := lcDIR      
   else
      lcDIR  := lcDIR+lcDIRSEP+'gedstor'
      run('mkdir '+lcDIR)
      lcDIRW   := lcDIR      
   endif
   //wout('lcDir:'+lcDir)
   lcDIR  += lcDIRSEP
   //wout('lcDir:'+lcDir)
   run('mkdir '+lcDIR)
   lcDIR  += substr(strzero(fnGED,9),1,3) //+lcDIRSEP
   //wout('lcDir:'+lcDir)
   run('mkdir '+lcDIR)
   lcDIR  += lcDIRSEP+substr(strzero(fnGED,9),4,3)//+lcDIRSEP
   //wout('lcDir:'+lcDir)
   run('mkdir '+lcDIR)
   lcDIR  += lcDIRSEP + substr(strzero(fnGED,9),7,3) //+ lcDIRSEP
   //wout('lcDir:'+lcDir)
   run('mkdir '+lcDIR)
   lcFILE := strzero(fnGEDFILE,9)+'.'+strzero(fnGEDFVERS,3)
   //wout('lcDir:'+lcDir)
   run('mkdir '+lcDIR)
   laDIR  := directory(lcDIR,'D')
   //lcDIR  += lcDIRSEP

   //if len(laDIR) == 0  // Diretorio nao existe
  //    if !llWIN32
  //       run('mkdir -p '+lcDIR)
//      else
//         run('mkdir '+lcDIRW)
//         run('mkdir '+lcDIRW+lcDIRSEP+'gedstor')
//         run('mkdir '+lcDIRW+lcDIRSEP+'gedstor'+lcDIRSEP+substr(strzero(fnGED,9),1,3))
//         run('mkdir '+lcDIRW+lcDIRSEP+'gedstor'+lcDIRSEP+substr(strzero(fnGED,9),1,3)+lcDIRSEP+substr(strzero(fnGED,9),4,3))
//         run('mkdir '+lcDIRW+lcDIRSEP+'gedstor'+lcDIRSEP+substr(strzero(fnGED,9),1,3)+lcDIRSEP+substr(strzero(fnGED,9),4,3)+lcDIRSEP+substr(strzero(fnGED,9),7,3))
//      endif
//   endif
return(lcDIR+lcFILE)
