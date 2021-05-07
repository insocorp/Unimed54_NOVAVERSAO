/*
Project      : gr5
Product      : gr5
Module       : gr5
Created on   : 13-Dec-2004
 Autor       : 
*/


#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLAP chr(39)                  // delimited ( ' )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )

function main()

  local ii := 0 as int
  
 // Esta diretiva deve ser usada caso seja necessário usar o antigo controle de acesso
 #ifdef USE_OLD_DG_WACCESS
   local lnTmPage := 0.000 ,;
         lnTmFunc := 0.000 as float
 #endif

   local lePROG := '' as string
   local lcCONTENTTYPE := {} as array
   local llcheckdb := .f.
   local lnArq, lntam,lcBuffer
   
   parameters pPARM1,pPARM2,pPARM3,pPARM4

   public gaPAGE       := {} ,;
          gaWSET       := {} ,;
          gaWGET       := {} ,;
          gaWGET_FILE  := {} ,;
          gaWPUT       := {} ,;
          ga2WPUT      := {} ,;
          gaDBS        := {'GR5'} ,;
          gaERROR_SYS  := {} ,;
          gaWDATAURL   := {} ,;
          gaWDATAGLOBAL := {},;
          gaWCACHE      := {} ,;
          gaWLOG        := {{'',''}}
          
   public gcDB_ACTIVE      := '' ,;
          gcDB_DRV_ACTIVE  := '',;
          gcWOUT_GZIP      := '' ,;
          gcWOUT_HEAD      := '' ,;
          gcLOG_SQL        := ''

   public gmID         := '' ,;
          gmPAGE       := '' ,;
          gmPAGE_OLD   := '' ,;
          gmLANGUAGE   := '' ,;
          gcWOUT       := '' ,;
          gcPAGE_HOME  := ''
   public gnROW := 1 ,;
          gnTIME := 0.00000 ,;
          gnWN_ACCESS := 0
   public gbFL_UI_DYN := .f. ,;
          gbHTTPHEAD  := .f.
 // Accees control enviroment
   public gbWFL_AC      := .t. ,;
          gbWAC_EXEC    := .f. ,;
          gbWAC_READ    := .f. ,;
          gbWAC_WRITE   := .f. ,;
          gbWAC_CREATE  := .f. ,;
          gbWAC_DELETE  := .f.

     public gbWDEBUG      := .f.

   public gnWN_ACS           := 0 ,;
          gnWN_ACS_FILE      := 0 ,;
          gnTIME_TASK        := 0 ,;
          gnTIME_OUT         := 0 ,;
          gnUID              := 0 ,;
          gnGID              := 0 ,;
          gnMaxQueryCount    := 0 ,;
          gnContentLengthOut := 0

   public gfTimeStart   := 0.000 ,;
          gfTimeSQL     := 0.000 ,;
          gfMaxSQLTime  := 0.000 ,;
          gfTimeFetch   := 0.000

   public gaWDATAURL := {}
   public aDb  := {} // Database names
   public aObj := {} // Database objects
   public oWic

   public gcLOGIN       := ''
   public gcAC_RESTRICT := ''

   gfTimeStart := seconds()
   gnTIME_OUT  := seconds()
   
   set century on
   set date british
   set epoch to 1990


   // Glauber 07/2018 - Tratamento para wout, para que o parser da linguagem c não tente tratar os caracteres especiais

        #Cinline
        {
          _setmode( _fileno( stdout ), 0x8000);
        }
        #endCinline



   cleanTmpFiles() // Função estática no final deste arquivo

 #ifdef USE_OLD_DG_WACCESS
   lntmfunc := wic_time()
 #endif


   readWSysProfile()
   readWSysProfile(pPARM3)
   if ! empty(pPARM1)

      if pPARM1 = 'WENV'
         laPARM := str2array(pPARM2,'&,')
         laPARM2 := {}
         for ii := 1 to len(laPARM)
            laPARM2 := str2array(laPARM[ii],'&=')
            if len(laPARM2) > 1
               wSet('_WENV_'+laPARM2[1],laPARM2[2])
            endif
         next ii
      endif

      if upper(pPARM1) == 'CHECKDB'
         llcheckdb := .t.
      endif
   endif

   ii := 0

  //  Chama o componente e altera o DRV do BD
   if wSet('_WENV_DRV_DB_OVER') = 'ODB'
      wSet('DRV_GR5','ODB')
   endif

   readWGet()

   wSet("_PROJECT","GR5")
   wSet("_BUILD_SRC_PROJECT",     10422)
   wSet("_BUILD_SRC_MODULE",      5873)
   wSet("_BUILD_UI",      5224)
   wSet("_BUILD_DB",       910)
 //  wSet("_PROJECT_VERSION","5.4 2019-04-16 AD Sem Pesquisa/CT/Evida F2 - Unimed")
 wSet("_PROJECT_VERSION","5.4 2021-05-07 AD Sem Pesquisa/CT/Evida F2 - Unimed")

   wSet("_PROGRAM_DEFAULT","portal.html")
   wSet("_PROGRAM_LOGIN","login.html")
   wSet("_LANGUAGE_DEFAULT","pt_BR")
   wSet("_LANGUAGE_ACTIVE","pt_BR")

   wSet ("_WICCOMPONENT",wSet("URL_COMPONENTS"))

   if empty(wSet("_USER_INTERFACE"))
      if gbWFL_AC
         wSet("_USER_INTERFACE","login.html")
      else
         wSet("_USER_INTERFACE","portal.html")
      endif
   endif
   gmPAGE     := wSet("_USER_INTERFACE")
   gmPAGE_OLD := wSet("_USER_INTERFACE")
   gmLANGUAGE := "pt_BR"
   if empty(gmLANGUAGE)
      gmLANGUAGE := "pt_BR"
   endif

   wSet("_dbcursor","N")
   db_active('GR5')
   if empty(gcDB_DRV_ACTIVE)
      wOut('db_active: not defined database: ISJ')
      quit
   endif

   if val(wgetenv('TIMEOUT_COM')) > 0
      gnTIMEOUT := val(wgetenv('TIMEOUT_COM'))
   endif

   #include "wh/main_befdb.wh"

   db_init('GR5')
   if db_connect('GR5',;
           WSet("INSTANCE_GR5"),;
           WSet("HOST_GR5"),;
           WSet("PORT_GR5"),;
           WSet("USER_GR5"),;
           WSet("PASS_GR5")) != 0
      error_sys("db_connect -> "+db_error('GR5'))
   else
      // Glauber 16/10/2011 - Solicitação do Alfa
      if llcheckdb
         CheckDbIsj() // Funçaõ estatica no final deste programa
         db_disconnect()
         quit         
      endif   
   endif

   if gbWFL_AC    //  access control
      wAccess_control()
      if ! gbWAC_EXEC
         error_sys('Acesso não liberado ao programa '+gmPAGE)
      endif
   endif
 #ifdef USE_OLD_DG_WACCESS
   ReadDataGlobal()
 #else
//   ReadWCache()
   ReadDataGlobal()
 #endif
   reTypeWget()

  wout('')  // so' pra ativar o http



   #include "wh/main_aftdb.wh"

   WSet("_USER_INTERFACE_IN",WSet("_USER_INTERFACE"))
   lePROG := strtran(wSet("_USER_INTERFACE"),'.','_')



   if isfunction(lePROG)
      lePROG := lePROG+'()'

      eval({||&lePROG})

     #include "wh/main_aftmain.wh"

   else
      lcCONTENTTYPE := wprogstruct(wSet("_USER_INTERFACE"))
      if len(lcCONTENTTYPE) < 3
         whttphead('text/html')
         error_sys('Function not found: '+wSet("_USER_INTERFACE"))
      else
         gbFL_UI_DYN := lcCONTENTTYPE[3]
         if empty(lcCONTENTTYPE[2])
            whttphead('text/html')
            error_sys('Function not found: '+wSet("_USER_INTERFACE"))
         else
            whttphead(lcCONTENTTYPE[2])
         endif
      endif
   endif
   
 #ifdef USE_OLD_DG_WACCESS
   lntmpage := wic_time()
   lntmfunc := wic_time() - lntmfunc
 #endif

   if ! (gmPAGE_OLD == wSet("_USER_INTERFACE"))
      gmPAGE := wSet("_USER_INTERFACE")
   endif

   if gbFL_UI_DYN .and. gmPAGE != 'none.wic'
   
      if gmPAGE != gmPAGE_OLD
         if gbWFL_AC .and. 'pasta' $ gmPAGE
            wAccess_control()
            if ! gbWAC_EXEC
               error_sys('Acesso não liberado ao programa '+wSet("_USER_INTERFACE"))
            endif
         endif
      endif
      
      exec_page(gmPAGE,gmLANGUAGE)

      
   endif
   


   if wSet("_WDEBUG") = "ENABLE" .and. len(gaERROR_SYS) > 0 .and. WSet("scCONTENT_TYPE") = "text/html"
//   if  len(gaERROR_SYS) > 0 .and. WSet("scCONTENT_TYPE") = "text/html"
      wOut(' ')
      wOut('  <!-- # error debug list # ')
      for ii := 1 to len(gaERROR_SYS)
         wOut('  <!-- ' + gaERROR_SYS[ii] + '  ')
      next  ii
      wOut('  -->')
   endif

 #ifdef USE_OLD_DG_WACCESS
   lntmpage := wic_time() - lntmpage
   wAccess_File(lntmfunc,lntmpage)
 #else
   //wAccess_File()
 #endif

 #ifdef NO_COMPRESS_OUT
   db_disconnect()
   quit
 #else
    quit
  // WQuit() // Saída compactada
 #endif
 
return

FUNCTION CursesInit()       // see SYS.2.7
RETURN NIL

FUNCTION ProgramInit()   // see SYS.2.9
//   CALL fgsUse4html
RETURN NIL

/* modulos do sistema */

   function wprogstruct(fcPROGRAM)
      local laWPROGRAM := {} ,;
            laWTYPE := {}
      if "aba.administracao.pfpj.html" == fcPROGRAM
         return({"aba.administracao.pfpj.html","text/html",.t.})
      elseif "aba.contas.pfpj.html" == fcPROGRAM
         return({"aba.contas.pfpj.html","text/html",.t.})
      elseif "aba.contato.pfpj.html" == fcPROGRAM
         return({"aba.contato.pfpj.html","text/html",.t.})
      elseif "aba.socios.pfpj.html" == fcPROGRAM
         return({"aba.socios.pfpj.html","text/html",.t.})
      elseif "abat_autorizado.mnt.html" == fcPROGRAM
         return({"abat_autorizado.mnt.html","text/html",.t.})
      elseif "abat_fixo.mnt.html" == fcPROGRAM
         return({"abat_fixo.mnt.html","text/html",.t.})
      elseif "ac.field.redef.html" == fcPROGRAM
         return({"ac.field.redef.html","text/html",.t.})
      elseif "acordo.mnt.html" == fcPROGRAM
         return({"acordo.mnt.html","text/html",.t.})
      elseif "acsel_import" == fcPROGRAM
         return({"acsel_import","text/html",.f.})
      elseif "acsel_tokio.html" == fcPROGRAM
         return({"acsel_tokio.html","text/html",.f.})
      elseif "adiantamento_financeiro.mnt.html" == fcPROGRAM
         return({"adiantamento_financeiro.mnt.html","text/html",.t.})
      elseif "aditivo_tipo.mnt.html" == fcPROGRAM
         return({"aditivo_tipo.mnt.html","text/html",.t.})
      elseif "afastamento.mnt.html" == fcPROGRAM
         return({"afastamento.mnt.html","text/html",.t.})
      elseif "ajuste_monetario.html" == fcPROGRAM
         return({"ajuste_monetario.html","text/html",.f.})
      elseif "alcada.aprovacao.html" == fcPROGRAM
         return({"alcada.aprovacao.html","text/html",.t.})
      elseif "alt.capacidadeescritorio.html" == fcPROGRAM
         return({"alt.capacidadeescritorio.html","text/html",.t.})
      elseif "ambito.mnt.html" == fcPROGRAM
         return({"ambito.mnt.html","text/html",.t.})
      elseif "analiserisco.mnt.html" == fcPROGRAM
         return({"analiserisco.mnt.html","text/html",.t.})
      elseif "andamento.par.mnt.html" == fcPROGRAM
         return({"andamento.par.mnt.html","text/html",.t.})
      elseif "apresentacao.mnt.html" == fcPROGRAM
         return({"apresentacao.mnt.html","text/html",.t.})
      elseif "area.mnt.html" == fcPROGRAM
         return({"area.mnt.html","text/html",.t.})
      elseif "area_solicitante.mnt.html" == fcPROGRAM
         return({"area_solicitante.mnt.html","text/html",.t.})
      elseif "ar_solicitada.mnt.html" == fcPROGRAM
         return({"ar_solicitada.mnt.html","text/html",.t.})
      elseif "assdoc.class" == fcPROGRAM
         return({"assdoc.class","text/html",.f.})
      elseif "assedio.mnt.html" == fcPROGRAM
         return({"assedio.mnt.html","text/html",.t.})
      elseif "ato_registrado.mnt.html" == fcPROGRAM
         return({"ato_registrado.mnt.html","text/html",.t.})
      elseif "atualiza_full_sinistro_isj.html" == fcPROGRAM
         return({"atualiza_full_sinistro_isj.html","text/html",.f.})
      elseif "atualiza_sinistro_isj.html" == fcPROGRAM
         return({"atualiza_sinistro_isj.html","text/html",.f.})
      elseif "autosch.wic" == fcPROGRAM
         return({"autosch.wic","text/html",.t.})
      elseif "auto_search.sbhtml" == fcPROGRAM
         return({"auto_search.sbhtml","text/html",.t.})
      elseif "auxiliar1.mnt.html" == fcPROGRAM
         return({"auxiliar1.mnt.html","text/html",.t.})
      elseif "auxiliar2.mnt.html" == fcPROGRAM
         return({"auxiliar2.mnt.html","text/html",.t.})
      elseif "auxiliar3.mnt.html" == fcPROGRAM
         return({"auxiliar3.mnt.html","text/html",.t.})
      elseif "auxiliar4.mnt.html" == fcPROGRAM
         return({"auxiliar4.mnt.html","text/html",.t.})
      elseif "auxiliar5.mnt.html" == fcPROGRAM
         return({"auxiliar5.mnt.html","text/html",.t.})
      elseif "banco.mnt.html" == fcPROGRAM
         return({"banco.mnt.html","text/html",.t.})
      elseif "bat.markup.html" == fcPROGRAM
         return({"bat.markup.html","text/html",.t.})
      elseif "bat.rb.export.html" == fcPROGRAM
         return({"bat.rb.export.html","text/html",.f.})
      elseif "bloqueio.tipo.mnt.html" == fcPROGRAM
         return({"bloqueio.tipo.mnt.html","text/html",.t.})
      elseif "boleto.aprovacao.html" == fcPROGRAM
         return({"boleto.aprovacao.html","text/html",.t.})
      elseif "build_program" == fcPROGRAM
         return({"build_program","text/html",.t.})
      elseif "canais.relacionamento.mnt.html" == fcPROGRAM
         return({"canais.relacionamento.mnt.html","text/html",.t.})
      elseif "canal.mnt.html" == fcPROGRAM
         return({"canal.mnt.html","text/html",.t.})
      elseif "canal_produto.mnt.html" == fcPROGRAM
         return({"canal_produto.mnt.html","text/html",.t.})
      elseif "canal_venda.mnt.html" == fcPROGRAM
         return({"canal_venda.mnt.html","text/html",.t.})
      elseif "cancela.despesa.mnt.html" == fcPROGRAM
         return({"cancela.despesa.mnt.html","text/html",.t.})
      elseif "cancelamento_motivo.mnt.html" == fcPROGRAM
         return({"cancelamento_motivo.mnt.html","text/html",.t.})
      elseif "carregaindicesvpar.html" == fcPROGRAM
         return({"carregaindicesvpar.html","text/html",.t.})
      elseif "causa.mnt.html" == fcPROGRAM
         return({"causa.mnt.html","text/html",.t.})
      elseif "ccwsdiario" == fcPROGRAM
         return({"ccwsdiario","text/html",.f.})
      elseif "cfg.pst.juros.html" == fcPROGRAM
         return({"cfg.pst.juros.html","text/html",.t.})
      elseif "cfg.pst.valores.html" == fcPROGRAM
         return({"cfg.pst.valores.html","text/html",.t.})
      elseif "check_fields.html" == fcPROGRAM
         return({"check_fields.html","text/html",.f.})
      elseif "chkencerrapasta.js.sbhtml" == fcPROGRAM
         return({"chkencerrapasta.js.sbhtml","text/html",.t.})
      elseif "cidade.mnt.html" == fcPROGRAM
         return({"cidade.mnt.html","text/html",.t.})
      elseif "clarblogexec.class" == fcPROGRAM
         return({"clarblogexec.class","text/html",.f.})
      elseif "clarbschfil.class" == fcPROGRAM
         return({"clarbschfil.class","text/html",.f.})
      elseif "clasrbschedule" == fcPROGRAM
         return({"clasrbschedule","text/html",.f.})
      elseif "classchedulefiltros" == fcPROGRAM
         return({"classchedulefiltros","text/html",.f.})
      elseif "classificacao_pessoas.mnt.html" == fcPROGRAM
         return({"classificacao_pessoas.mnt.html","text/html",.t.})
      elseif "clastokenrbschedule.class" == fcPROGRAM
         return({"clastokenrbschedule.class","text/html",.f.})
      elseif "clas_contabil.mnt.html" == fcPROGRAM
         return({"clas_contabil.mnt.html","text/html",.t.})
      elseif "clas_doenca.mnt.html" == fcPROGRAM
         return({"clas_doenca.mnt.html","text/html",.t.})
      elseif "clo.perfil.html" == fcPROGRAM
         return({"clo.perfil.html","text/html",.t.})
      elseif "close.reload.wic" == fcPROGRAM
         return({"close.reload.wic","text/html",.t.})
      elseif "close.wic" == fcPROGRAM
         return({"close.wic","text/html",.t.})
      elseif "complexidade.mnt.html" == fcPROGRAM
         return({"complexidade.mnt.html","text/html",.t.})
      elseif "compliance.mnt.html" == fcPROGRAM
         return({"compliance.mnt.html","text/html",.t.})
      elseif "conclusao_contrato.mnt.html" == fcPROGRAM
         return({"conclusao_contrato.mnt.html","text/html",.t.})
      elseif "confidenc_abrangencia.mnt.html" == fcPROGRAM
         return({"confidenc_abrangencia.mnt.html","text/html",.t.})
      elseif "config_ressarcimento.mnt.html" == fcPROGRAM
         return({"config_ressarcimento.mnt.html","text/html",.t.})
      elseif "conhecimento.mnt.html" == fcPROGRAM
         return({"conhecimento.mnt.html","text/html",.t.})
      elseif "consequencia.mnt.html" == fcPROGRAM
         return({"consequencia.mnt.html","text/html",.t.})
      elseif "cont2valor" == fcPROGRAM
         return({"cont2valor","text/html",.f.})
      elseif "contrato_situacao.mnt.html" == fcPROGRAM
         return({"contrato_situacao.mnt.html","text/html",.t.})
      elseif "contribuiu.mnt.html" == fcPROGRAM
         return({"contribuiu.mnt.html","text/html",.t.})
      elseif "cont_renovacao.mnt.html" == fcPROGRAM
         return({"cont_renovacao.mnt.html","text/html",.t.})
      elseif "convencao.mnt.html" == fcPROGRAM
         return({"convencao.mnt.html","text/html",.t.})
      elseif "conv_snt" == fcPROGRAM
         return({"conv_snt","text/html",.f.})
      elseif "corrige_andamentos_html" == fcPROGRAM
         return({"corrige_andamentos_html","text/html",.t.})
      elseif "cosesp1504.html" == fcPROGRAM
         return({"cosesp1504.html","text/html",.f.})
      elseif "cosesp_sios1503.html" == fcPROGRAM
         return({"cosesp_sios1503.html","text/html",.f.})
      elseif "credito.cfg.etapas.html" == fcPROGRAM
         return({"credito.cfg.etapas.html","text/html",.t.})
      elseif "css.atack.cfg.html" == fcPROGRAM
         return({"css.atack.cfg.html","text/html",.t.})
      elseif "custo.mnt.html" == fcPROGRAM
         return({"custo.mnt.html","text/html",.t.})
      elseif "daemon.defdb" == fcPROGRAM
         return({"daemon.defdb","text/html",.f.})
      elseif "daemon.wic" == fcPROGRAM
         return({"daemon.wic","text/plain",.f.})
      elseif "deleta.pedidos.mnt.html" == fcPROGRAM
         return({"deleta.pedidos.mnt.html","text/html",.t.})
      elseif "deliberacao.mnt.html" == fcPROGRAM
         return({"deliberacao.mnt.html","text/html",.t.})
      elseif "desenvoltura.mnt.html" == fcPROGRAM
         return({"desenvoltura.mnt.html","text/html",.t.})
      elseif "desligamento.mnt.html" == fcPROGRAM
         return({"desligamento.mnt.html","text/html",.t.})
      elseif "desp.aprovacao.html" == fcPROGRAM
         return({"desp.aprovacao.html","text/html",.t.})
      elseif "desp.rej.aprovacao.html" == fcPROGRAM
         return({"desp.rej.aprovacao.html","text/html",.t.})
      elseif "desp.cfg.etapas.html" == fcPROGRAM
         return({"desp.cfg.etapas.html","text/html",.t.})
      elseif "desp.imp.revisao.html" == fcPROGRAM
         return({"desp.imp.revisao.html","text/html",.t.})
      elseif "desp.rej.aprovacao.html" == fcPROGRAM
         return({"desp.rej.aprovacao.html","text/html",.t.})
      elseif "desp.rej.imp.revisao.html" == fcPROGRAM
         return({"desp.rej.imp.revisao.html","text/html",.t.})
      elseif "desp.rej.revisao.html" == fcPROGRAM
         return({"desp.rej.revisao.html","text/html",.t.})
      elseif "desp.revisao.html" == fcPROGRAM
         return({"desp.revisao.html","text/html",.t.})
      elseif "desp.rej.revisao.html" == fcPROGRAM
         return({"desp.rej.revisao.html","text/html",.t.})
      elseif "detalhes_sinistro.html" == fcPROGRAM
         return({"detalhes_sinistro.html","text/html",.t.})
      elseif "dic.exc.cfg.html" == fcPROGRAM
         return({"dic.exc.cfg.html","text/html",.t.})
      elseif "diretoriacontrato.mnt.html" == fcPROGRAM
         return({"diretoriacontrato.mnt.html","text/html",.t.})
      elseif "diretoria_resp.mnt.html" == fcPROGRAM
         return({"diretoria_resp.mnt.html","text/html",.t.})
      elseif "doc.mnt.html" == fcPROGRAM
         return({"doc.mnt.html","text/html",.t.})
      elseif "docrtf.mnt.html" == fcPROGRAM
         return({"docrtf.mnt.html","text/html",.t.})
      elseif "documento_tipo.mnt.html" == fcPROGRAM
         return({"documento_tipo.mnt.html","text/html",.t.})
      elseif "desp.imp.revisao.html" == fcPROGRAM
         return({"desp.imp.revisao.html","text/html",.t.})
      elseif "desp.rej.imp.revisao.html" == fcPROGRAM
         return({"desp.rej.imp.revisao.html","text/html",.t.})
      elseif "doc_assunto.mnt.html" == fcPROGRAM
         return({"doc_assunto.mnt.html","text/html",.t.})
      elseif "doc_contratos.mnt.html" == fcPROGRAM
         return({"doc_contratos.mnt.html","text/html",.t.})
      elseif "doc_necessario.mnt.html" == fcPROGRAM
         return({"doc_necessario.mnt.html","text/html",.t.})
      elseif "doc_rh.mnt.html" == fcPROGRAM
         return({"doc_rh.mnt.html","text/html",.t.})
      elseif "doenca.mnt.html" == fcPROGRAM
         return({"doenca.mnt.html","text/html",.t.})
      elseif "dynamicui" == fcPROGRAM
         return({"dynamicui","text/html",.t.})
      elseif "edificacao.mnt.html" == fcPROGRAM
         return({"edificacao.mnt.html","text/html",.t.})
      elseif "efinance_import.html" == fcPROGRAM
         return({"efinance_import.html","text/html",.f.})
      elseif "encerramento_contrato.mnt.html" == fcPROGRAM
         return({"encerramento_contrato.mnt.html","text/html",.t.})
      elseif "envio.mnt.html" == fcPROGRAM
         return({"envio.mnt.html","text/html",.t.})
      elseif "escalonamento.honorarios.mnt.html" == fcPROGRAM
         return({"escalonamento.honorarios.mnt.html","text/html",.t.})
      elseif "escritorio.mnt.html" == fcPROGRAM
         return({"escritorio.mnt.html","text/html",.t.})
      elseif "esocial1.mnt.html" == fcPROGRAM
         return({"esocial1.mnt.html","text/html",.t.})
      elseif "esocial2.mnt.html" == fcPROGRAM
         return({"esocial2.mnt.html","text/html",.t.})
      elseif "exclusiv_abrangencia.mnt.html" == fcPROGRAM
         return({"exclusiv_abrangencia.mnt.html","text/html",.t.})
      elseif "exito_riscoperda.mnt.html" == fcPROGRAM
         return({"exito_riscoperda.mnt.html","text/html",.t.})
      elseif "exp.perfil.html" == fcPROGRAM
         return({"exp.perfil.html","text/html",.f.})
      elseif "e_finance_html" == fcPROGRAM
         return({"e_finance_html","text/html",.f.})
      elseif "familia.mnt.html" == fcPROGRAM
         return({"familia.mnt.html","text/html",.t.})
      elseif "fase_plano.mnt.html" == fcPROGRAM
         return({"fase_plano.mnt.html","text/html",.t.})
      elseif "fat.emite.html" == fcPROGRAM
         return({"fat.emite.html","text/html",.t.})
      elseif "fat.gera.html" == fcPROGRAM
         return({"fat.gera.html","text/html",.t.})
      elseif "fat.honorario.revisa.html" == fcPROGRAM
         return({"fat.honorario.revisa.html","text/html",.t.})
      elseif "fat.lst.revisa.html" == fcPROGRAM
         return({"fat.lst.revisa.html","text/html",.t.})
      elseif "fat.revisa.html" == fcPROGRAM
         return({"fat.revisa.html","text/html",.t.})
      elseif "fat.rpt.emite.html" == fcPROGRAM
         return({"fat.rpt.emite.html","text/html",.t.})
      elseif "fat.servico.revisa.html" == fcPROGRAM
         return({"fat.servico.revisa.html","text/html",.t.})
      elseif "forma_contato.mnt.html" == fcPROGRAM
         return({"forma_contato.mnt.html","text/html",.t.})
      elseif "forma_realizacao.mnt.html" == fcPROGRAM
         return({"forma_realizacao.mnt.html","text/html",.t.})
      elseif "fr.cfg.gerais.html" == fcPROGRAM
         return({"fr.cfg.gerais.html","text/html",.t.})
      elseif "fr.menu.pop.sbhtml" == fcPROGRAM
         return({"fr.menu.pop.sbhtml","text/html",.t.})
      elseif "func.calculo.wic" == fcPROGRAM
         return({"func.calculo.wic","text/html",.f.})
      elseif "func.wic" == fcPROGRAM
         return({"func.wic","text/html",.f.})
      elseif "funcgroupware.wic" == fcPROGRAM
         return({"funcgroupware.wic","text/html",.f.})
      elseif "garantiaexecucao.mnt.html" == fcPROGRAM
         return({"garantiaexecucao.mnt.html","text/html",.t.})
      elseif "garantiafinadianta.mnt.html" == fcPROGRAM
         return({"garantiafinadianta.mnt.html","text/html",.t.})
      elseif "garantia_financeira.mnt.html" == fcPROGRAM
         return({"garantia_financeira.mnt.html","text/html",.t.})
      elseif "gasto.mnt.html" == fcPROGRAM
         return({"gasto.mnt.html","text/html",.t.})
      elseif "gem_export_html" == fcPROGRAM
         return({"gem_export_html","text/html",.f.})
      elseif "gem_import" == fcPROGRAM
         return({"gem_import","text/html",.f.})
      elseif "gem_isj_cont_provisoes_html" == fcPROGRAM
         return({"gem_isj_cont_provisoes_html","text/html",.f.})
      elseif "gem_isj_despesas_html" == fcPROGRAM
         return({"gem_isj_despesas_html","text/html",.f.})
      elseif "gem_isj_indenizacoes_html" == fcPROGRAM
         return({"gem_isj_indenizacoes_html","text/html",.f.})
      elseif "gem_tokio.html" == fcPROGRAM
         return({"gem_tokio.html","text/html",.f.})
      elseif "gera.honorarios.html" == fcPROGRAM
         return({"gera.honorarios.html","text/html",.t.})
      elseif "gera.rel.html" == fcPROGRAM
         return({"gera.rel.html","text/html",.t.})
      elseif "gerar.saldos.mnt.html" == fcPROGRAM
         return({"gerar.saldos.mnt.html","text/html",.t.})
      elseif "gr5.js.sbhtml" == fcPROGRAM
         return({"gr5.js.sbhtml","text/html",.t.})
      elseif "grau_parentesco.mnt.html" == fcPROGRAM
         return({"grau_parentesco.mnt.html","text/html",.t.})
      elseif "grid.js.sbhtml" == fcPROGRAM
         return({"grid.js.sbhtml","text/html",.t.})
      elseif "grpman.lst.html" == fcPROGRAM
         return({"grpman.lst.html","text/html",.t.})
      elseif "grpman.mnt.html" == fcPROGRAM
         return({"grpman.mnt.html","text/html",.t.})
      elseif "grupo_despesa.mnt.html" == fcPROGRAM
         return({"grupo_despesa.mnt.html","text/html",.t.})
      elseif "helponline" == fcPROGRAM
         return({"helponline","text/html",.t.})
      elseif "imovel_tipo.mnt.html" == fcPROGRAM
         return({"imovel_tipo.mnt.html","text/html",.t.})
      elseif "imp.perfil.html" == fcPROGRAM
         return({"imp.perfil.html","text/html",.t.})
      elseif "importapfpj.html" == fcPROGRAM
         return({"importapfpj.html","text/html",.t.})
      elseif "imp_andamentos.html" == fcPROGRAM
         return({"imp_andamentos.html","text/html",.f.})
      elseif "imp_dersaxrayes.html" == fcPROGRAM
         return({"imp_dersaxrayes.html","text/html",.f.})
      elseif "imp_pend_andamentos.html" == fcPROGRAM
         return({"imp_pend_andamentos.html","text/html",.f.})
      elseif "incorporacao.mnt.html" == fcPROGRAM
         return({"incorporacao.mnt.html","text/html",.t.})
      elseif "indices.web.mnt.html" == fcPROGRAM
         return({"indices.web.mnt.html","text/html",.t.})
      elseif "inter.andamentos.mnt.html" == fcPROGRAM
         return({"inter.andamentos.mnt.html","text/html",.t.})
      elseif "investimento_propriedade.mnt.html" == fcPROGRAM
         return({"investimento_propriedade.mnt.html","text/html",.t.})
      elseif "isj.js.sbhtml" == fcPROGRAM
         return({"isj.js.sbhtml","text/html",.t.})
      elseif "isjsha512" == fcPROGRAM
         return({"isjsha512","text/html",.f.})
      elseif "janela_dados.js.sbhtml" == fcPROGRAM
         return({"janela_dados.js.sbhtml","text/html",.t.})
      elseif "jquery-1.11.2" == fcPROGRAM
         return({"jquery-1.11.2","text/html",.t.})
      elseif "jquery-1.11.2.min.js" == fcPROGRAM
         return({"jquery-1.11.2.min.js","text/html",.t.})
      elseif "jquery-2.0.2.min.js" == fcPROGRAM
         return({"jquery-2.0.2.min.js","text/html",.t.})
      elseif "jsongridcomp.html" == fcPROGRAM
         return({"jsongridcomp.html","text/html",.f.})
      elseif "lic_certificado.mnt.html" == fcPROGRAM
         return({"lic_certificado.mnt.html","text/html",.t.})
      elseif "link_pasta.js.sbhtml" == fcPROGRAM
         return({"link_pasta.js.sbhtml","text/html",.t.})
      elseif "lmi_cobertura.mnt.html" == fcPROGRAM
         return({"lmi_cobertura.mnt.html","text/html",.t.})
      elseif "local.mnt.html" == fcPROGRAM
         return({"local.mnt.html","text/html",.t.})
      elseif "login.html" == fcPROGRAM
         return({"login.html","text/html",.t.})
      elseif "logout.wic" == fcPROGRAM
         return({"logout.wic","text/html",.t.})
      elseif "loja.lst.html" == fcPROGRAM
         return({"loja.lst.html","text/html",.t.})
      elseif "loja.mnt.html" == fcPROGRAM
         return({"loja.mnt.html","text/html",.t.})
      elseif "lojap.lst.html" == fcPROGRAM
         return({"lojap.lst.html","text/html",.t.})
      elseif "lojap.mnt.html" == fcPROGRAM
         return({"lojap.mnt.html","text/html",.t.})
      elseif "loteamento.mnt.html" == fcPROGRAM
         return({"loteamento.mnt.html","text/html",.t.})
      elseif "lst.acgroup.html" == fcPROGRAM
         return({"lst.acgroup.html","text/html",.t.})
      elseif "lst.acuser.html" == fcPROGRAM
         return({"lst.acuser.html","text/html",.t.})
      elseif "lst.can.a" == fcPROGRAM
         return({"lst.can.a","text/html",.t.})
      elseif "lst.canc.andamento.html" == fcPROGRAM
         return({"lst.canc.andamento.html","text/html",.t.})
      elseif "lst.cfg.pasta.html" == fcPROGRAM
         return({"lst.cfg.pasta.html","text/html",.t.})
      elseif "lst.cob.cliente.html" == fcPROGRAM
         return({"lst.cob.cliente.html","text/html",.t.})
      elseif "lst.cob.pasta.html" == fcPROGRAM
         return({"lst.cob.pasta.html","text/html",.t.})
      elseif "lst.desp.corp.html" == fcPROGRAM
         return({"lst.desp.corp.html","text/html",.t.})
      elseif "lst.ext.andamento.html" == fcPROGRAM
         return({"lst.ext.andamento.html","text/html",.t.})
      elseif "lst.fase_processual.html" == fcPROGRAM
         return({"lst.fase_processual.html","text/html",.t.})
      elseif "lst.faturamento.html" == fcPROGRAM
         return({"lst.faturamento.html","text/html",.t.})
      elseif "lst.mvt.despesa.html" == fcPROGRAM
         return({"lst.mvt.despesa.html","text/html",.t.})
      elseif "lst.mvt.indice.html" == fcPROGRAM
         return({"lst.mvt.indice.html","text/html",.t.})
      elseif "lst.mvt.moeda.html" == fcPROGRAM
         return({"lst.mvt.moeda.html","text/html",.t.})
      elseif "lst.mvt.servico.html" == fcPROGRAM
         return({"lst.mvt.servico.html","text/html",.t.})
      elseif "lst.ouvidoria.html" == fcPROGRAM
         return({"lst.ouvidoria.html","text/html",.t.})
      elseif "lst.pasta.html" == fcPROGRAM
         return({"lst.pasta.html","text/html",.t.})
      elseif "lst.plct.html" == fcPROGRAM
         return({"lst.plct.html","text/html",.t.})
      elseif "lst.provisao.html" == fcPROGRAM
         return({"lst.provisao.html","text/html",.t.})
      elseif "lst.pst.andamento.html" == fcPROGRAM
         return({"lst.pst.andamento.html","text/html",.t.})
      elseif "lst.resultado_processo.html" == fcPROGRAM
         return({"lst.resultado_processo.html","text/html",.t.})
      elseif "lst.serv.corp.html" == fcPROGRAM
         return({"lst.serv.corp.html","text/html",.t.})
      elseif "lst.tb.despesa.html" == fcPROGRAM
         return({"lst.tb.despesa.html","text/html",.t.})
      elseif "lst.tb.honorario.html" == fcPROGRAM
         return({"lst.tb.honorario.html","text/html",.t.})
      elseif "lst.tb.servico.html" == fcPROGRAM
         return({"lst.tb.servico.html","text/html",.t.})
      elseif "lst.timesheet.html" == fcPROGRAM
         return({"lst.timesheet.html","text/html",.t.})
      elseif "lst.tp_contrato.html" == fcPROGRAM
         return({"lst.tp_contrato.html","text/html",.t.})
      elseif "lst.trct.html" == fcPROGRAM
         return({"lst.trct.html","text/html",.t.})
      elseif "lst.ts.cp.preventivo.html" == fcPROGRAM
         return({"lst.ts.cp.preventivo.html","text/html",.t.})
      elseif "lst.ts.ct.revisao.html" == fcPROGRAM
         return({"lst.ts.ct.revisao.html","text/html",.t.})
      elseif "lst.ts.pr.revisao.html" == fcPROGRAM
         return({"lst.ts.pr.revisao.html","text/html",.t.})
      elseif "lst.tsht.preventivo.html" == fcPROGRAM
         return({"lst.tsht.preventivo.html","text/html",.t.})
      elseif "lst.usuario.html" == fcPROGRAM
         return({"lst.usuario.html","text/html",.t.})
      elseif "main.aftdb" == fcPROGRAM
         return({"main.aftdb","text/html",.f.})
      elseif "main.aftmain" == fcPROGRAM
         return({"main.aftmain","text/html",.f.})
      elseif "main.befdb" == fcPROGRAM
         return({"main.befdb","text/html",.f.})
      elseif "main.css.sbhtml" == fcPROGRAM
         return({"main.css.sbhtml","text/html",.t.})
      elseif "make_lst.html" == fcPROGRAM
         return({"make_lst.html","text/html",.t.})
      elseif "mark_calc_html" == fcPROGRAM
         return({"mark_calc_html","text/html",.t.})
      elseif "melhoria_tipo.mnt.html" == fcPROGRAM
         return({"melhoria_tipo.mnt.html","text/html",.t.})
      elseif "menu.cfg.gerais.html" == fcPROGRAM
         return({"menu.cfg.gerais.html","text/html",.t.})
      elseif "menu.pop.html" == fcPROGRAM
         return({"menu.pop.html","text/html",.t.})
      elseif "menu.pendencias.html" == fcPROGRAM
         return({"menu.pendencias.html","text/html",.t.})
      elseif "mesbasereajuste.mnt.html" == fcPROGRAM
         return({"mesbasereajuste.mnt.html","text/html",.t.})
      elseif "mkcips" == fcPROGRAM
         return({"mkcips","text/html",.f.})
      elseif "mkgrpdesp.wh" == fcPROGRAM
         return({"mkgrpdesp.wh","text/html",.f.})
      elseif "mnt.1codaux.html" == fcPROGRAM
         return({"mnt.1codaux.html","text/html",.t.})
      elseif "mnt.2codaux.html" == fcPROGRAM
         return({"mnt.2codaux.html","text/html",.t.})
      elseif "mnt.3codaux.html" == fcPROGRAM
         return({"mnt.3codaux.html","text/html",.t.})
      elseif "mnt.abrangencia.html" == fcPROGRAM
         return({"mnt.abrangencia.html","text/html",.t.})
      elseif "mnt.ac.grp_program.html" == fcPROGRAM
         return({"mnt.ac.grp_program.html","text/html",.t.})
      elseif "mnt.acgroup.html" == fcPROGRAM
         return({"mnt.acgroup.html","text/html",.t.})
      elseif "mnt.acprogram.html" == fcPROGRAM
         return({"mnt.acprogram.html","text/html",.t.})
      elseif "mnt.acuser.html" == fcPROGRAM
         return({"mnt.acuser.html","text/html",.t.})
      elseif "mnt.alocadas.html" == fcPROGRAM
         return({"mnt.alocadas.html","text/html",.t.})
      elseif "mnt.analise.html" == fcPROGRAM
         return({"mnt.analise.html","text/html",.t.})
      elseif "mnt.andamentos_pendentes.html" == fcPROGRAM
         return({"mnt.andamentos_pendentes.html","text/html",.t.})
      elseif "mnt.andpossiveis.html" == fcPROGRAM
         return({"mnt.andpossiveis.html","text/html",.t.})
      elseif "mnt.anexo.html" == fcPROGRAM
         return({"mnt.anexo.html","text/html",.t.})
      elseif "mnt.aprova.con.html" == fcPROGRAM
         return({"mnt.aprova.con.html","text/html",.t.})
      elseif "mnt.aprovdiretor.html" == fcPROGRAM
         return({"mnt.aprovdiretor.html","text/html",.t.})
      elseif "mnt.areacontrato.html" == fcPROGRAM
         return({"mnt.areacontrato.html","text/html",.t.})
      elseif "mnt.ass.dig.html" == fcPROGRAM
         return({"mnt.ass.dig.html","text/html",.t.})
      elseif "mnt.assunto.html" == fcPROGRAM
         return({"mnt.assunto.html","text/html",.t.})
      elseif "mnt.atividades.html" == fcPROGRAM
         return({"mnt.atividades.html","text/html",.t.})
      elseif "mnt.atuacao_poder.html" == fcPROGRAM
         return({"mnt.atuacao_poder.html","text/html",.t.})
      elseif "mnt.autoproc.html" == fcPROGRAM
         return({"mnt.autoproc.html","text/html",.t.})
      elseif "mnt.autoresultado.html" == fcPROGRAM
         return({"mnt.autoresultado.html","text/html",.t.})
      elseif "mnt.aux_filtro_andam.html" == fcPROGRAM
         return({"mnt.aux_filtro_andam.html","text/html",.t.})
      elseif "mnt.avaliacao.html" == fcPROGRAM
         return({"mnt.avaliacao.html","text/html",.t.})
      elseif "mnt.boleto.html" == fcPROGRAM
         return({"mnt.boleto.html","text/html",.t.})
      elseif "mnt.budget.html" == fcPROGRAM
         return({"mnt.budget.html","text/html",.t.})
      elseif "mnt.canal2.html" == fcPROGRAM
         return({"mnt.canal2.html","text/html",.t.})
      elseif "mnt.canc.andamento.html" == fcPROGRAM
         return({"mnt.canc.andamento.html","text/html",.t.})
      elseif "mnt.capacidadeescritorio.html" == fcPROGRAM
         return({"mnt.capacidadeescritorio.html","text/html",.t.})
      elseif "mnt.cargo.html" == fcPROGRAM
         return({"mnt.cargo.html","text/html",.t.})
      elseif "mnt.categoria.html" == fcPROGRAM
         return({"mnt.categoria.html","text/html",.t.})
      elseif "mnt.causaacao.html" == fcPROGRAM
         return({"mnt.causaacao.html","text/html",.t.})
      elseif "mnt.causanis.html" == fcPROGRAM
         return({"mnt.causanis.html","text/html",.t.})
      elseif "mnt.causaraiz.html" == fcPROGRAM
         return({"mnt.causaraiz.html","text/html",.t.})
      elseif "mnt.ccusto.html" == fcPROGRAM
         return({"mnt.ccusto.html","text/html",.t.})
      elseif "mnt.cfg.aprov.html" == fcPROGRAM
         return({"mnt.cfg.aprov.html","text/html",.t.})
      elseif "mnt.cfg.ass.html" == fcPROGRAM
         return({"mnt.cfg.ass.html","text/html",.t.})
      elseif "mnt.cfg.pasta.html" == fcPROGRAM
         return({"mnt.cfg.pasta.html","text/html",.t.})
      elseif "mnt.cf_and_retorno.html" == fcPROGRAM
         return({"mnt.cf_and_retorno.html","text/html",.t.})
      elseif "mnt.cf_docs_envio.html" == fcPROGRAM
         return({"mnt.cf_docs_envio.html","text/html",.t.})
      elseif "mnt.cf_envio_and.html" == fcPROGRAM
         return({"mnt.cf_envio_and.html","text/html",.t.})
      elseif "mnt.cf_siscod.html" == fcPROGRAM
         return({"mnt.cf_siscod.html","text/html",.t.})
      elseif "mnt.class_poder.html" == fcPROGRAM
         return({"mnt.class_poder.html","text/html",.t.})
      elseif "mnt.cli2.html" == fcPROGRAM
         return({"mnt.cli2.html","text/html",.t.})
      elseif "mnt.cob.cliente.html" == fcPROGRAM
         return({"mnt.cob.cliente.html","text/html",.t.})
      elseif "mnt.cob.pasta.html" == fcPROGRAM
         return({"mnt.cob.pasta.html","text/html",.t.})
      elseif "mnt.coberturas_ramos.html" == fcPROGRAM
         return({"mnt.coberturas_ramos.html","text/html",.t.})
      elseif "mnt.cobobj.html" == fcPROGRAM
         return({"mnt.cobobj.html","text/html",.t.})
      elseif "mnt.cobranca.html" == fcPROGRAM
         return({"mnt.cobranca.html","text/html",.t.})
      elseif "mnt.comarca.html" == fcPROGRAM
         return({"mnt.comarca.html","text/html",.t.})
      elseif "mnt.combinacao_poder.html" == fcPROGRAM
         return({"mnt.combinacao_poder.html","text/html",.t.})
      elseif "mnt.concluitc.html" == fcPROGRAM
         return({"mnt.concluitc.html","text/html",.t.})
      elseif "mnt.confidenc.para.html" == fcPROGRAM
         return({"mnt.confidenc.para.html","text/html",.t.})
      elseif "mnt.config.html" == fcPROGRAM
         return({"mnt.config.html","text/html",.t.})
      elseif "mnt.cossegtipo.html" == fcPROGRAM
         return({"mnt.cossegtipo.html","text/html",.t.})
      elseif "mnt.ctr.reajuste.period.html" == fcPROGRAM
         return({"mnt.ctr.reajuste.period.html","text/html",.t.})
      elseif "mnt.ctr.tipo.html" == fcPROGRAM
         return({"mnt.ctr.tipo.html","text/html",.t.})
      elseif "mnt.ctr.valor.period.html" == fcPROGRAM
         return({"mnt.ctr.valor.period.html","text/html",.t.})
      elseif "mnt.ctrdo.html" == fcPROGRAM
         return({"mnt.ctrdo.html","text/html",.t.})
      elseif "mnt.ctrte.html" == fcPROGRAM
         return({"mnt.ctrte.html","text/html",.t.})
      elseif "mnt.cumprimento.html" == fcPROGRAM
         return({"mnt.cumprimento.html","text/html",.t.})
      elseif "mnt.decisao.html" == fcPROGRAM
         return({"mnt.decisao.html","text/html",.t.})
      elseif "mnt.delegacia.html" == fcPROGRAM
         return({"mnt.delegacia.html","text/html",.t.})
      elseif "mnt.deliberacao.html" == fcPROGRAM
         return({"mnt.deliberacao.html","text/html",.t.})
      elseif "mnt.departamento.html" == fcPROGRAM
         return({"mnt.departamento.html","text/html",.t.})
      elseif "mnt.depexcontabil.html" == fcPROGRAM
         return({"mnt.depexcontabil.html","text/html",.t.})
      elseif "mnt.deposito.status.html" == fcPROGRAM
         return({"mnt.deposito.status.html","text/html",.t.})
      elseif "mnt.desp.corp.html" == fcPROGRAM
         return({"mnt.desp.corp.html","text/html",.t.})
      elseif "mnt.despesa.html" == fcPROGRAM
         return({"mnt.despesa.html","text/html",.t.})
      elseif "mnt.det.reclamacao.html" == fcPROGRAM
         return({"mnt.det.reclamacao.html","text/html",.t.})
      elseif "mnt.detal_pedido.html" == fcPROGRAM
         return({"mnt.detal_pedido.html","text/html",.t.})
      elseif "mnt.diario_indice.html" == fcPROGRAM
         return({"mnt.diario_indice.html","text/html",.t.})
      elseif "mnt.diretoria.html" == fcPROGRAM
         return({"mnt.diretoria.html","text/html",.t.})
      elseif "mnt.disponibilidade.plataforma.html" == fcPROGRAM
         return({"mnt.disponibilidade.plataforma.html","text/html",.t.})
      elseif "mnt.emissao_acoes.html" == fcPROGRAM
         return({"mnt.emissao_acoes.html","text/html",.t.})
      elseif "mnt.empresa_usuaria.html" == fcPROGRAM
         return({"mnt.empresa_usuaria.html","text/html",.t.})
      elseif "mnt.endosso.html" == fcPROGRAM
         return({"mnt.endosso.html","text/html",.t.})
      elseif "mnt.estipulacao.html" == fcPROGRAM
         return({"mnt.estipulacao.html","text/html",.t.})
      elseif "mnt.excl_desp.html" == fcPROGRAM
         return({"mnt.excl_desp.html","text/html",.t.})
      elseif "mnt.excl_gem.html" == fcPROGRAM
         return({"mnt.excl_gem.html","text/html",.t.})
      elseif "mnt.excl_plataforma.html" == fcPROGRAM
         return({"mnt.excl_plataforma.html","text/html",.t.})
      elseif "mnt.ext.andamento.html" == fcPROGRAM
         return({"mnt.ext.andamento.html","text/html",.t.})
      elseif "mnt.fase_processual.html" == fcPROGRAM
         return({"mnt.fase_processual.html","text/html",.t.})
      elseif "mnt.filtro_aux_desp.html" == fcPROGRAM
         return({"mnt.filtro_aux_desp.html","text/html",.t.})
      elseif "mnt.filxgrupo.html" == fcPROGRAM
         return({"mnt.filxgrupo.html","text/html",.t.})
      elseif "mnt.filxplat.html" == fcPROGRAM
         return({"mnt.filxplat.html","text/html",.t.})
      elseif "mnt.fnp.html" == fcPROGRAM
         return({"mnt.fnp.html","text/html",.t.})
      elseif "mnt.formatopagamento.html" == fcPROGRAM
         return({"mnt.formatopagamento.html","text/html",.t.})
      elseif "mnt.forma_pagamento.html" == fcPROGRAM
         return({"mnt.forma_pagamento.html","text/html",.t.})
      elseif "mnt.forum.html" == fcPROGRAM
         return({"mnt.forum.html","text/html",.t.})
      elseif "mnt.ftr.replace.html" == fcPROGRAM
         return({"mnt.ftr.replace.html","text/html",.t.})
      elseif "mnt.ftr.universal.html" == fcPROGRAM
         return({"mnt.ftr.universal.html","text/html",.t.})
      elseif "mnt.gasto.html" == fcPROGRAM
         return({"mnt.gasto.html","text/html",.t.})
      elseif "mnt.gcont.html" == fcPROGRAM
         return({"mnt.gcont.html","text/html",.t.})
      elseif "mnt.groupanda.html" == fcPROGRAM
         return({"mnt.groupanda.html","text/html",.t.})
      elseif "mnt.grupo_economico.html" == fcPROGRAM
         return({"mnt.grupo_economico.html","text/html",.t.})
      elseif "mnt.imposto.html" == fcPROGRAM
         return({"mnt.imposto.html","text/html",.t.})
      elseif "mnt.indice.reajuste.html" == fcPROGRAM
         return({"mnt.indice.reajuste.html","text/html",.t.})
      elseif "mnt.diario.indice.html" == fcPROGRAM
         return({"mnt.diario.indice.html","text/html",.t.})
      elseif "mvt.indice.diario.html" == fcPROGRAM
         return({"mvt.indice.diario.html","text/html",.t.})
      elseif "mnt.instancia.html" == fcPROGRAM
         return({"mnt.instancia.html","text/html",.t.})
      elseif "mnt.interfaces_pendentes.html" == fcPROGRAM
         return({"mnt.interfaces_pendentes.html","text/html",.t.})
      elseif "mnt.juridico.html" == fcPROGRAM
         return({"mnt.juridico.html","text/html",.t.})
      elseif "mnt.label.html" == fcPROGRAM
         return({"mnt.label.html","text/html",.t.})
      elseif "mnt.landesp.html" == fcPROGRAM
         return({"mnt.landesp.html","text/html",.t.})
      elseif "mnt.manlotedes.html" == fcPROGRAM
         return({"mnt.manlotedes.html","text/html",.t.})
      elseif "mnt.margem.html" == fcPROGRAM
         return({"mnt.margem.html","text/html",.t.})
      elseif "mnt.mat.proc.html" == fcPROGRAM
         return({"mnt.mat.proc.html","text/html",.t.})
      elseif "mnt.mcontratac.html" == fcPROGRAM
         return({"mnt.mcontratac.html","text/html",.t.})
      elseif "mnt.moeda.html" == fcPROGRAM
         return({"mnt.moeda.html","text/html",.t.})
      elseif "mnt.motivo_infracao.html" == fcPROGRAM
         return({"mnt.motivo_infracao.html","text/html",.t.})
      elseif "mnt.mov.ped.html" == fcPROGRAM
         return({"mnt.mov.ped.html","text/html",.t.})
      elseif "mnt.movsaldoscontratos.html" == fcPROGRAM
         return({"mnt.movsaldoscontratos.html","text/html",.t.})
      elseif "mnt.mvt.despesa.html" == fcPROGRAM
         return({"mnt.mvt.despesa.html","text/html",.t.})
      elseif "mnt.mvt.indice.html" == fcPROGRAM
         return({"mnt.mvt.indice.html","text/html",.t.})
      elseif "mnt.mvt.juros.html" == fcPROGRAM
         return({"mnt.mvt.juros.html","text/html",.t.})
      elseif "mnt.mvt.moeda.html" == fcPROGRAM
         return({"mnt.mvt.moeda.html","text/html",.t.})
      elseif "mnt.mvt.servico.html" == fcPROGRAM
         return({"mnt.mvt.servico.html","text/html",.t.})
      elseif "mnt.natureza_operacao.html" == fcPROGRAM
         return({"mnt.natureza_operacao.html","text/html",.t.})
      elseif "mnt.nf_tp_servico.html" == fcPROGRAM
         return({"mnt.nf_tp_servico.html","text/html",.t.})
      elseif "mnt.nivelaprovacao.html" == fcPROGRAM
         return({"mnt.nivelaprovacao.html","text/html",.t.})
      elseif "mnt.nomeprojeto.html" == fcPROGRAM
         return({"mnt.nomeprojeto.html","text/html",.t.})
      elseif "mnt.numero_parcela.html" == fcPROGRAM
         return({"mnt.numero_parcela.html","text/html",.t.})
      elseif "mnt.ocor.cpedido.html" == fcPROGRAM
         return({"mnt.ocor.cpedido.html","text/html",.t.})
      elseif "mnt.ocorrencia.pedido.html" == fcPROGRAM
         return({"mnt.ocorrencia.pedido.html","text/html",.t.})
      elseif "mnt.orgaos.html" == fcPROGRAM
         return({"mnt.orgaos.html","text/html",.t.})
      elseif "mnt.pagnet_ocorrencias.html" == fcPROGRAM
         return({"mnt.pagnet_ocorrencias.html","text/html",.t.})
      elseif "mnt.parceiros.html" == fcPROGRAM
         return({"mnt.parceiros.html","text/html",.t.})
      elseif "mnt.pasta.ambiental.html" == fcPROGRAM
         return({"mnt.pasta.ambiental.html","text/html",.t.})
      elseif "mnt.pasta.ambiental_cont.html" == fcPROGRAM
         return({"mnt.pasta.ambiental_cont.html","text/html",.t.})
      elseif "mnt.pasta.auto_infracao.html" == fcPROGRAM
         return({"mnt.pasta.auto_infracao.html","text/html",.t.})
      elseif "mnt.pasta.auto_infracao.seguro.html" == fcPROGRAM
         return({"mnt.pasta.auto_infracao.seguro.html","text/html",.t.})
      elseif "mnt.pasta.bacen.html" == fcPROGRAM
         return({"mnt.pasta.bacen.html","text/html",.t.})
      elseif "mnt.pasta.certidoes.html" == fcPROGRAM
         return({"mnt.pasta.certidoes.html","text/html",.t.})
      elseif "mnt.pasta.civel.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel.html" == fcPROGRAM
         return({"mnt.pasta.civel.html","text/html",.t.})
      elseif "mnt.pasta.civel2.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel2.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel2.html" == fcPROGRAM
         return({"mnt.pasta.civel2.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo_cont.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo_cont.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans_cont.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans_cont.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade_cont.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade_cont.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_procon.desc_reclama.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_procon.desc_reclama.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_procon.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_procon.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_procon.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_procon.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_susep.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_susep.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_susep.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_susep.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_susep_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_susep_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_susep_cont.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_susep_cont.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo.consultor_externo.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo.consultor_externo.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo.interno.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo.interno.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo2.consultor_externo.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo2.consultor_externo.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo2.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo2.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo2.interno.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo2.interno.html","text/html",.t.})
      elseif "mnt.pasta.civel_consultivo3.html" == fcPROGRAM
         return({"mnt.pasta.civel_consultivo3.html","text/html",.t.})
      elseif "mnt.pasta.civel_cont.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_cont.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_loja.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_loja.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja.html","text/html",.t.})
      elseif "mnt.pasta.civel_loja_cont.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja_cont.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_loja_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_recupera.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_recupera.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_recupera.html" == fcPROGRAM
         return({"mnt.pasta.civel_recupera.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_com_sinistro.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_com_sinistro.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_com_sin_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_com_sin_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_exp.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_exp.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_sem_sinistro.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_sem_sinistro.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_sem_sin_cont.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_sem_sin_cont.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_sin_cob_ramo.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_sin_cob_ramo.html","text/html",.t.})
      elseif "mnt.pasta.comunicacao_corporativa.html" == fcPROGRAM
         return({"mnt.pasta.comunicacao_corporativa.html","text/html",.t.})
      elseif "mnt.pasta.consignacao.html" == fcPROGRAM
         return({"mnt.pasta.consignacao.html","text/html",.t.})
      elseif "mnt.pasta.consignacao_cont.html" == fcPROGRAM
         return({"mnt.pasta.consignacao_cont.html","text/html",.t.})
      elseif "mnt.pasta.consultivo.html" == fcPROGRAM
         return({"mnt.pasta.consultivo.html","text/html",.t.})
      elseif "mnt.pasta.consultivo_seguro.html" == fcPROGRAM
         return({"mnt.pasta.consultivo_seguro.html","text/html",.t.})
      elseif "mnt.pasta.consultoria.html" == fcPROGRAM
         return({"mnt.pasta.consultoria.html","text/html",.t.})
      elseif "mnt.pasta.contrato.html" == fcPROGRAM
         return({"mnt.pasta.contrato.html","text/html",.t.})
      elseif "mnt.pasta.contrato2.html" == fcPROGRAM
         return({"mnt.pasta.contrato2.html","text/html",.t.})
      elseif "mnt.pasta.contrato3.html" == fcPROGRAM
         return({"mnt.pasta.contrato3.html","text/html",.t.})
      elseif "mnt.pasta.contrato4.html" == fcPROGRAM
         return({"mnt.pasta.contrato4.html","text/html",.t.})
      elseif "mnt.pasta.contrato5.html" == fcPROGRAM
         return({"mnt.pasta.contrato5.html","text/html",.t.})
      elseif "mnt.pasta.contrato6.html" == fcPROGRAM
         return({"mnt.pasta.contrato6.html","text/html",.t.})
      elseif "mnt.pasta.contrato_contra.html" == fcPROGRAM
         return({"mnt.pasta.contrato_contra.html","text/html",.t.})
      elseif "mnt.pasta.contrato_contra2.html" == fcPROGRAM
         return({"mnt.pasta.contrato_contra2.html","text/html",.t.})
      elseif "mnt.pasta.contrato_locacao.html" == fcPROGRAM
         return({"mnt.pasta.contrato_locacao.html","text/html",.t.})
      elseif "mnt.pasta.contrato_locacao_contra.html" == fcPROGRAM
         return({"mnt.pasta.contrato_locacao_contra.html","text/html",.t.})
      elseif "mnt.pasta.contrato_locacao_imovel.html" == fcPROGRAM
         return({"mnt.pasta.contrato_locacao_imovel.html","text/html",.t.})
      elseif "mnt.pasta.contrato_prestacao_servico.html" == fcPROGRAM
         return({"mnt.pasta.contrato_prestacao_servico.html","text/html",.t.})
      elseif "mnt.pasta.contrato_tce.html" == fcPROGRAM
         return({"mnt.pasta.contrato_tce.html","text/html",.t.})
      elseif "mnt.pasta.criminal.html" == fcPROGRAM
         return({"mnt.pasta.criminal.html","text/html",.t.})
      elseif "mnt.pasta.dpvat.html" == fcPROGRAM
         return({"mnt.pasta.dpvat.html","text/html",.t.})
      elseif "mnt.pasta.dpvat_cont.html" == fcPROGRAM
         return({"mnt.pasta.dpvat_cont.html","text/html",.t.})
      elseif "mnt.pasta.email.html" == fcPROGRAM
         return({"mnt.pasta.email.html","text/html",.t.})
      elseif "mnt.pasta.empreendimento.html" == fcPROGRAM
         return({"mnt.pasta.empreendimento.html","text/html",.t.})
      elseif "mnt.pasta.html" == fcPROGRAM
         return({"mnt.pasta.html","text/html",.t.})
      elseif "mnt.pasta.imobiliario.html" == fcPROGRAM
         return({"mnt.pasta.imobiliario.html","text/html",.t.})
      elseif "mnt.pasta.imprensa.html" == fcPROGRAM
         return({"mnt.pasta.imprensa.html","text/html",.t.})
      elseif "mnt.pasta.juizo_filial.html" == fcPROGRAM
         return({"mnt.pasta.juizo_filial.html","text/html",.t.})
      elseif "mnt.pasta.juizo_filial_cont.html" == fcPROGRAM
         return({"mnt.pasta.juizo_filial_cont.html","text/html",.t.})
      elseif "mnt.pasta.juridico_operacional.html" == fcPROGRAM
         return({"mnt.pasta.juridico_operacional.html","text/html",.t.})
      elseif "mnt.pasta.jurisprudencia.html" == fcPROGRAM
         return({"mnt.pasta.jurisprudencia.html","text/html",.t.})
      elseif "mnt.pasta.jurisprudencia_cont.html" == fcPROGRAM
         return({"mnt.pasta.jurisprudencia_cont.html","text/html",.t.})
      elseif "mnt.pasta.jurisprudencia_seguro.html" == fcPROGRAM
         return({"mnt.pasta.jurisprudencia_seguro.html","text/html",.t.})
      elseif "mnt.pasta.marcas.html" == fcPROGRAM
         return({"mnt.pasta.marcas.html","text/html",.t.})
      elseif "mnt.pasta.notificacao.html" == fcPROGRAM
         return({"mnt.pasta.notificacao.html","text/html",.t.})
      elseif "mnt.pasta.ocorrencias.html" == fcPROGRAM
         return({"mnt.pasta.ocorrencias.html","text/html",.t.})
      elseif "mnt.pasta.oficio.html" == fcPROGRAM
         return({"mnt.pasta.oficio.html","text/html",.t.})
      elseif "mnt.pasta.oficio2.html" == fcPROGRAM
         return({"mnt.pasta.oficio2.html","text/html",.t.})
      elseif "mnt.pasta.ouvidoria.html" == fcPROGRAM
         return({"mnt.pasta.ouvidoria.html","text/html",.t.})
      elseif "mnt.pasta.ouvidoria2.html" == fcPROGRAM
         return({"mnt.pasta.ouvidoria2.html","text/html",.t.})
      elseif "mnt.pasta.ouvidoria3.html" == fcPROGRAM
         return({"mnt.pasta.ouvidoria3.html","text/html",.t.})
      elseif "mnt.pasta.ouvidoria4.html" == fcPROGRAM
         return({"mnt.pasta.ouvidoria4.html","text/html",.t.})
      elseif "mnt.pasta.ouvidoria5.html" == fcPROGRAM
         return({"mnt.pasta.ouvidoria5.html","text/html",.t.})
      elseif "mnt.pasta.pac.html" == fcPROGRAM
         return({"mnt.pasta.pac.html","text/html",.t.})
      elseif "mnt.pasta.padrao.html" == fcPROGRAM
         return({"mnt.pasta.padrao.html","text/html",.t.})
      elseif "mnt.pasta.pas.html" == fcPROGRAM
         return({"mnt.pasta.pas.html","text/html",.t.})
      elseif "mnt.pasta.pasta_pfpj.html" == fcPROGRAM
         return({"mnt.pasta.pasta_pfpj.html","text/html",.t.})
      elseif "mnt.pasta.patentes.html" == fcPROGRAM
         return({"mnt.pasta.patentes.html","text/html",.t.})
      elseif "mnt.pasta.plano_acao.html" == fcPROGRAM
         return({"mnt.pasta.plano_acao.html","text/html",.t.})
      elseif "mnt.pasta.poderes.html" == fcPROGRAM
         return({"mnt.pasta.poderes.html","text/html",.t.})
      elseif "mnt.pasta.procon.html" == fcPROGRAM
         return({"mnt.pasta.procon.html","text/html",.t.})
      elseif "mnt.pasta.procon2.html" == fcPROGRAM
         return({"mnt.pasta.procon2.html","text/html",.t.})
      elseif "mnt.pasta.procuracao.html" == fcPROGRAM
         return({"mnt.pasta.procuracao.html","text/html",.t.})
      elseif "mnt.pasta.procuracao2.html" == fcPROGRAM
         return({"mnt.pasta.procuracao2.html","text/html",.t.})
      elseif "mnt.pasta.procuracao3.html" == fcPROGRAM
         return({"mnt.pasta.procuracao3.html","text/html",.t.})
      elseif "mnt.pasta.projetos.html" == fcPROGRAM
         return({"mnt.pasta.projetos.html","text/html",.t.})
      elseif "mnt.pasta.recativos.execucao.html" == fcPROGRAM
         return({"mnt.pasta.recativos.execucao.html","text/html",.t.})
      elseif "mnt.pasta.recativos.html" == fcPROGRAM
         return({"mnt.pasta.recativos.html","text/html",.t.})
      elseif "mnt.pasta.recativos_cont.execucao.html" == fcPROGRAM
         return({"mnt.pasta.recativos_cont.execucao.html","text/html",.t.})
      elseif "mnt.pasta.recativos_cont.html" == fcPROGRAM
         return({"mnt.pasta.recativos_cont.html","text/html",.t.})
      elseif "mnt.pasta.representacao.html" == fcPROGRAM
         return({"mnt.pasta.representacao.html","text/html",.t.})
      elseif "mnt.pasta.ressarcimento.html" == fcPROGRAM
         return({"mnt.pasta.ressarcimento.html","text/html",.t.})
      elseif "mnt.pasta.ressarcimento_exp.html" == fcPROGRAM
         return({"mnt.pasta.ressarcimento_exp.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel.seguro.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel.seguro.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel_cont.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel_cont.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel_cont.seguro.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel_cont.seguro.html","text/html",.t.})
      elseif "mnt.pasta.seguro_cobranca_adm.html" == fcPROGRAM
         return({"mnt.pasta.seguro_cobranca_adm.html","text/html",.t.})
      elseif "mnt.pasta.seguro_consultoria.html" == fcPROGRAM
         return({"mnt.pasta.seguro_consultoria.html","text/html",.t.})
      elseif "mnt.pasta.seguro_ressarc_adm.html" == fcPROGRAM
         return({"mnt.pasta.seguro_ressarc_adm.html","text/html",.t.})
      elseif "mnt.pasta.seguro_ressarc_adm.ocorrido.html" == fcPROGRAM
         return({"mnt.pasta.seguro_ressarc_adm.ocorrido.html","text/html",.t.})
      elseif "mnt.pasta.seguro_ressarc_adm.parte_passiva.html" == fcPROGRAM
         return({"mnt.pasta.seguro_ressarc_adm.parte_passiva.html","text/html",.t.})
      elseif "mnt.pasta.societario.html" == fcPROGRAM
         return({"mnt.pasta.societario.html","text/html",.t.})
      elseif "mnt.pasta.societario2.html" == fcPROGRAM
         return({"mnt.pasta.societario2.html","text/html",.t.})
      elseif "mnt.pasta.societario3.html" == fcPROGRAM
         return({"mnt.pasta.societario3.html","text/html",.t.})
      elseif "mnt.pasta.societario4.html" == fcPROGRAM
         return({"mnt.pasta.societario4.html","text/html",.t.})
      elseif "mnt.pasta.termos_int_fiscal.html" == fcPROGRAM
         return({"mnt.pasta.termos_int_fiscal.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista.execucao.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista.execucao.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista2_cont.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista2_cont.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista_cont.execucao.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista_cont.execucao.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista_cont.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario2_adm_contra_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario2_adm_contra_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario2_exec_fisc_con_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario2_exec_fisc_con_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario2_judicial_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario2_judicial_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_adm2_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_adm2_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_administrativo.html" == fcPROGRAM
         return({"mnt.pasta.tributario_administrativo.html","text/html",.t.})
      elseif "mnt.pasta.tributario_administrativo2.html" == fcPROGRAM
         return({"mnt.pasta.tributario_administrativo2.html","text/html",.t.})
      elseif "mnt.pasta.tributario_adm_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_adm_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_adm_contra.html" == fcPROGRAM
         return({"mnt.pasta.tributario_adm_contra.html","text/html",.t.})
      elseif "mnt.pasta.tributario_adm_contra_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_adm_contra_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fiscais.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fiscais.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fiscais_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fiscais_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fisc_contra.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fisc_contra.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fisc_con_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fisc_con_cont.html","text/html",.t.})
      elseif "mnt.pasta.tributario_judicial.html" == fcPROGRAM
         return({"mnt.pasta.tributario_judicial.html","text/html",.t.})
      elseif "mnt.pasta.tributario_judicial_cont.html" == fcPROGRAM
         return({"mnt.pasta.tributario_judicial_cont.html","text/html",.t.})
      elseif "mnt.pat.natureza.html" == fcPROGRAM
         return({"mnt.pat.natureza.html","text/html",.t.})
      elseif "mnt.pedexcontabil.html" == fcPROGRAM
         return({"mnt.pedexcontabil.html","text/html",.t.})
      elseif "mnt.pend_sinistros.html" == fcPROGRAM
         return({"mnt.pend_sinistros.html","text/html",.t.})
      elseif "mnt.perfilcampos.html" == fcPROGRAM
         return({"mnt.perfilcampos.html","text/html",.t.})
      elseif "mnt.pericia.html" == fcPROGRAM
         return({"mnt.pericia.html","text/html",.t.})
      elseif "mnt.phonorario.html" == fcPROGRAM
         return({"mnt.phonorario.html","text/html",.t.})
      elseif "mnt.plataforma.html" == fcPROGRAM
         return({"mnt.plataforma.html","text/html",.t.})
      elseif "mnt.plct.html" == fcPROGRAM
         return({"mnt.plct.html","text/html",.t.})
      elseif "mnt.pos.parte.html" == fcPROGRAM
         return({"mnt.pos.parte.html","text/html",.t.})
      elseif "mnt.prc.clausula.html" == fcPROGRAM
         return({"mnt.prc.clausula.html","text/html",.t.})
      elseif "mnt.prc.poder.html" == fcPROGRAM
         return({"mnt.prc.poder.html","text/html",.t.})
      elseif "mnt.prioridade.html" == fcPROGRAM
         return({"mnt.prioridade.html","text/html",.t.})
      elseif "mnt.procedimento.html" == fcPROGRAM
         return({"mnt.procedimento.html","text/html",.t.})
      elseif "mnt.provisao.html" == fcPROGRAM
         return({"mnt.provisao.html","text/html",.t.})
      elseif "mnt.pst.1andamento.html" == fcPROGRAM
         return({"mnt.pst.1andamento.html","text/html",.t.})
      elseif "mnt.pst.andamento.html" == fcPROGRAM
         return({"mnt.pst.andamento.html","text/html",.t.})
      elseif "mnt.pst.civel.html" == fcPROGRAM
         return({"mnt.pst.civel.html","text/html",.t.})
      elseif "mnt.pst.classifica.html" == fcPROGRAM
         return({"mnt.pst.classifica.html","text/html",.t.})
      elseif "mnt.pst.contingencia.html" == fcPROGRAM
         return({"mnt.pst.contingencia.html","text/html",.t.})
      elseif "mnt.pst.docrtf.html" == fcPROGRAM
         return({"mnt.pst.docrtf.html","text/html",.t.})
      elseif "mnt.pst.natureza.html" == fcPROGRAM
         return({"mnt.pst.natureza.html","text/html",.t.})
      elseif "mnt.pst.objeto.html" == fcPROGRAM
         return({"mnt.pst.objeto.html","text/html",.t.})
      elseif "mnt.pst.partes.html" == fcPROGRAM
         return({"mnt.pst.partes.html","text/html",.t.})
      elseif "mnt.pst.pre.contrato_locacao_imovel.html" == fcPROGRAM
         return({"mnt.pst.pre.contrato_locacao_imovel.html","text/html",.t.})
      elseif "mnt.pst.pre.contrato_prestacao_servico.html" == fcPROGRAM
         return({"mnt.pst.pre.contrato_prestacao_servico.html","text/html",.t.})
      elseif "mnt.pst.pre.pasta_pfpj.html" == fcPROGRAM
         return({"mnt.pst.pre.pasta_pfpj.html","text/html",.t.})
      elseif "mnt.pst.status.html" == fcPROGRAM
         return({"mnt.pst.status.html","text/html",.t.})
      elseif "mnt.pst.trabalhista.html" == fcPROGRAM
         return({"mnt.pst.trabalhista.html","text/html",.t.})
      elseif "mnt.pst.vendor.html" == fcPROGRAM
         return({"mnt.pst.vendor.html","text/html",.t.})
      elseif "mnt.ramosrsn.html" == fcPROGRAM
         return({"mnt.ramosrsn.html","text/html",.t.})
      elseif "mnt.rbschedule.html" == fcPROGRAM
         return({"mnt.rbschedule.html","text/html",.t.})
      elseif "mnt.receb.html" == fcPROGRAM
         return({"mnt.receb.html","text/html",.t.})
      elseif "mnt.reclamacao.html" == fcPROGRAM
         return({"mnt.reclamacao.html","text/html",.t.})
      elseif "mnt.registro.html" == fcPROGRAM
         return({"mnt.registro.html","text/html",.t.})
      elseif "mnt.ressarcimento.html" == fcPROGRAM
         return({"mnt.ressarcimento.html","text/html",.t.})
      elseif "mnt.resultado_processo.html" == fcPROGRAM
         return({"mnt.resultado_processo.html","text/html",.t.})
      elseif "mnt.resumomargem.html" == fcPROGRAM
         return({"mnt.resumomargem.html","text/html",.t.})
      elseif "mnt.res_pedido.html" == fcPROGRAM
         return({"mnt.res_pedido.html","text/html",.t.})
      elseif "mnt.retorno_efinance.html" == fcPROGRAM
         return({"mnt.retorno_efinance.html","text/html",.t.})
      elseif "mnt.risco.html" == fcPROGRAM
         return({"mnt.risco.html","text/html",.t.})
      elseif "mnt.saldoscontratos.html" == fcPROGRAM
         return({"mnt.saldoscontratos.html","text/html",.t.})
      elseif "mnt.schedule.filtros.html" == fcPROGRAM
         return({"mnt.schedule.filtros.html","text/html",.t.})
      elseif "mnt.sct.ato.html" == fcPROGRAM
         return({"mnt.sct.ato.html","text/html",.t.})
      elseif "mnt.sct.conselho.html" == fcPROGRAM
         return({"mnt.sct.conselho.html","text/html",.t.})
      elseif "mnt.segsituacaopagamento.html" == fcPROGRAM
         return({"mnt.segsituacaopagamento.html","text/html",.t.})
      elseif "mnt.seq.analitico.html" == fcPROGRAM
         return({"mnt.seq.analitico.html","text/html",.t.})
      elseif "mnt.seq_interfaces.html" == fcPROGRAM
         return({"mnt.seq_interfaces.html","text/html",.t.})
      elseif "mnt.serv.corp.html" == fcPROGRAM
         return({"mnt.serv.corp.html","text/html",.t.})
      elseif "mnt.servico.html" == fcPROGRAM
         return({"mnt.servico.html","text/html",.t.})
      elseif "mnt.sin.causa.html" == fcPROGRAM
         return({"mnt.sin.causa.html","text/html",.t.})
      elseif "mnt.sinistro_web.html" == fcPROGRAM
         return({"mnt.sinistro_web.html","text/html",.t.})
      elseif "mnt.sla.html" == fcPROGRAM
         return({"mnt.sla.html","text/html",.t.})
      elseif "mnt.st.apolice.html" == fcPROGRAM
         return({"mnt.st.apolice.html","text/html",.t.})
      elseif "mnt.st.sinistro.html" == fcPROGRAM
         return({"mnt.st.sinistro.html","text/html",.t.})
      elseif "mnt.status_batch.html" == fcPROGRAM
         return({"mnt.status_batch.html","text/html",.t.})
      elseif "mnt.st_lote.html" == fcPROGRAM
         return({"mnt.st_lote.html","text/html",.t.})
      elseif "mnt.subdivsolicita.html" == fcPROGRAM
         return({"mnt.subdivsolicita.html","text/html",.t.})
      elseif "mnt.sus.exig.html" == fcPROGRAM
         return({"mnt.sus.exig.html","text/html",.t.})
      elseif "mnt.tb.despesa.html" == fcPROGRAM
         return({"mnt.tb.despesa.html","text/html",.t.})
      elseif "mnt.tb.honorario.html" == fcPROGRAM
         return({"mnt.tb.honorario.html","text/html",.t.})
      elseif "mnt.tb.servico.html" == fcPROGRAM
         return({"mnt.tb.servico.html","text/html",.t.})
      elseif "mnt.tipo.deposito.html" == fcPROGRAM
         return({"mnt.tipo.deposito.html","text/html",.t.})
      elseif "mnt.tipo.vara.html" == fcPROGRAM
         return({"mnt.tipo.vara.html","text/html",.t.})
      elseif "mnt.tipoacao.html" == fcPROGRAM
         return({"mnt.tipoacao.html","text/html",.t.})
      elseif "mnt.tipocontratacao.html" == fcPROGRAM
         return({"mnt.tipocontratacao.html","text/html",.t.})
      elseif "mnt.tipogarantia.html" == fcPROGRAM
         return({"mnt.tipogarantia.html","text/html",.t.})
      elseif "mnt.tipomarca.html" == fcPROGRAM
         return({"mnt.tipomarca.html","text/html",.t.})
      elseif "mnt.tipomovsaldoscontratos.html" == fcPROGRAM
         return({"mnt.tipomovsaldoscontratos.html","text/html",.t.})
      elseif "mnt.tipoparticipacao.html" == fcPROGRAM
         return({"mnt.tipoparticipacao.html","text/html",.t.})
      elseif "mnt.tipo_ar.html" == fcPROGRAM
         return({"mnt.tipo_ar.html","text/html",.t.})
      elseif "mnt.tipo_credito.html" == fcPROGRAM
         return({"mnt.tipo_credito.html","text/html",.t.})
      elseif "mnt.tipo_poder.html" == fcPROGRAM
         return({"mnt.tipo_poder.html","text/html",.t.})
      elseif "mnt.tmovdep.html" == fcPROGRAM
         return({"mnt.tmovdep.html","text/html",.t.})
      elseif "mnt.tp.andamento.html" == fcPROGRAM
         return({"mnt.tp.andamento.html","text/html",.t.})
      elseif "mnt.tp.apolice.html" == fcPROGRAM
         return({"mnt.tp.apolice.html","text/html",.t.})
      elseif "mnt.tp.baixa.html" == fcPROGRAM
         return({"mnt.tp.baixa.html","text/html",.t.})
      elseif "mnt.tp.garantia_deposito.html" == fcPROGRAM
         return({"mnt.tp.garantia_deposito.html","text/html",.t.})
      elseif "mnt.tp_contrato.html" == fcPROGRAM
         return({"mnt.tp_contrato.html","text/html",.t.})
      elseif "mnt.transacao.contabil.html" == fcPROGRAM
         return({"mnt.transacao.contabil.html","text/html",.t.})
      elseif "mnt.transcrito_livro.html" == fcPROGRAM
         return({"mnt.transcrito_livro.html","text/html",.t.})
      elseif "mnt.trct.html" == fcPROGRAM
         return({"mnt.trct.html","text/html",.t.})
      elseif "mnt.tribunal.html" == fcPROGRAM
         return({"mnt.tribunal.html","text/html",.t.})
      elseif "mnt.tributo.html" == fcPROGRAM
         return({"mnt.tributo.html","text/html",.t.})
      elseif "mnt.ts.cp.preventivo.html" == fcPROGRAM
         return({"mnt.ts.cp.preventivo.html","text/html",.t.})
      elseif "mnt.ts.ct.revisao.html" == fcPROGRAM
         return({"mnt.ts.ct.revisao.html","text/html",.t.})
      elseif "mnt.ts.pr.revisao.html" == fcPROGRAM
         return({"mnt.ts.pr.revisao.html","text/html",.t.})
      elseif "mnt.tsht.preventivo.html" == fcPROGRAM
         return({"mnt.tsht.preventivo.html","text/html",.t.})
      elseif "mnt.uf.html" == fcPROGRAM
         return({"mnt.uf.html","text/html",.t.})
      elseif "mnt.unidadecontrato.html" == fcPROGRAM
         return({"mnt.unidadecontrato.html","text/html",.t.})
      elseif "mnt.usrxgrupo.html" == fcPROGRAM
         return({"mnt.usrxgrupo.html","text/html",.t.})
      elseif "mnt.vendor.html" == fcPROGRAM
         return({"mnt.vendor.html","text/html",.t.})
      elseif "mnt.vigencia.html" == fcPROGRAM
         return({"mnt.vigencia.html","text/html",.t.})
      elseif "mnt.wf.aprova.html" == fcPROGRAM
         return({"mnt.wf.aprova.html","text/html",.t.})
      elseif "mnt.workgroup.html" == fcPROGRAM
         return({"mnt.workgroup.html","text/html",.t.})
      elseif "mnt.wprofile.html" == fcPROGRAM
         return({"mnt.wprofile.html","text/html",.t.})
      elseif "mnt.xdepartarea.html" == fcPROGRAM
         return({"mnt.xdepartarea.html","text/html",.t.})
      elseif "mnt.xstatus.proposta.html" == fcPROGRAM
         return({"mnt.xstatus.proposta.html","text/html",.t.})
      elseif "motivo_encerramento.mnt.html" == fcPROGRAM
         return({"motivo_encerramento.mnt.html","text/html",.t.})
      elseif "motivo_irregularidade.mnt.html" == fcPROGRAM
         return({"motivo_irregularidade.mnt.html","text/html",.t.})
      elseif "motivo_operacao.mnt.html" == fcPROGRAM
         return({"motivo_operacao.mnt.html","text/html",.t.})
      elseif "motivo_vendor.mnt.html" == fcPROGRAM
         return({"motivo_vendor.mnt.html","text/html",.t.})
      elseif "movped.js.sbhtml" == fcPROGRAM
         return({"movped.js.sbhtml","text/html",.t.})
      elseif "multa_encerramento.mnt.html" == fcPROGRAM
         return({"multa_encerramento.mnt.html","text/html",.t.})
      elseif "new_ressarc" == fcPROGRAM
         return({"new_ressarc","text/html",.f.})
      elseif "ocorrencia_tipo.mnt.html" == fcPROGRAM
         return({"ocorrencia_tipo.mnt.html","text/html",.t.})
      elseif "orgao.julgador.mnt.html" == fcPROGRAM
         return({"orgao.julgador.mnt.html","text/html",.t.})
      elseif "orgao_autarquia.mnt.html" == fcPROGRAM
         return({"orgao_autarquia.mnt.html","text/html",.t.})
      elseif "orientacao.mnt.html" == fcPROGRAM
         return({"orientacao.mnt.html","text/html",.t.})
      elseif "origem.reclamacao.mnt.html" == fcPROGRAM
         return({"origem.reclamacao.mnt.html","text/html",.t.})
      elseif "pagamento_tipo.mnt.html" == fcPROGRAM
         return({"pagamento_tipo.mnt.html","text/html",.t.})
      elseif "pagnet_alfa.html" == fcPROGRAM
         return({"pagnet_alfa.html","text/html",.f.})
      elseif "pagnet_export.html" == fcPROGRAM
         return({"pagnet_export.html","text/html",.f.})
      elseif "pagsias_import.html" == fcPROGRAM
         return({"pagsias_import.html","text/html",.f.})
      elseif "paises.mnt.html" == fcPROGRAM
         return({"paises.mnt.html","text/html",.t.})
      elseif "parceiro1.mnt.html" == fcPROGRAM
         return({"parceiro1.mnt.html","text/html",.t.})
      elseif "parecer.mnt.html" == fcPROGRAM
         return({"parecer.mnt.html","text/html",.t.})
      elseif "pass.change.html" == fcPROGRAM
         return({"pass.change.html","text/html",.t.})
      elseif "pasta.abas.sbhtml" == fcPROGRAM
         return({"pasta.abas.sbhtml","text/html",.t.})
      elseif "pasta.pre.html" == fcPROGRAM
         return({"pasta.pre.html","text/html",.t.})
      elseif "pastadetal" == fcPROGRAM
         return({"pastadetal","text/html",.f.})
      elseif "pastaencerra" == fcPROGRAM
         return({"pastaencerra","text/html",.f.})
      elseif "penalidade_tipo.mnt.html" == fcPROGRAM
         return({"penalidade_tipo.mnt.html","text/html",.t.})
      elseif "pendencias_interface.html" == fcPROGRAM
         return({"pendencias_interface.html","text/html",.f.})
      elseif "perftool.class" == fcPROGRAM
         return({"perftool.class","text/html",.f.})
      elseif "pfpj.abas.sbhtml" == fcPROGRAM
         return({"pfpj.abas.sbhtml","text/html",.t.})
      elseif "pfpj.atividade.html" == fcPROGRAM
         return({"pfpj.atividade.html","text/html",.t.})
      elseif "pfpj.cargo.html" == fcPROGRAM
         return({"pfpj.cargo.html","text/html",.t.})
      elseif "pfpj.cf.tipo_campo.html" == fcPROGRAM
         return({"pfpj.cf.tipo_campo.html","text/html",.t.})
      elseif "pfpj.log.alteracao.html" == fcPROGRAM
         return({"pfpj.log.alteracao.html","text/html",.t.})
      elseif "pfpj.lst.html" == fcPROGRAM
         return({"pfpj.lst.html","text/html",.t.})
      elseif "pfpj.mnt.html" == fcPROGRAM
         return({"pfpj.mnt.html","text/html",.t.})
      elseif "pfpj.pre.html" == fcPROGRAM
         return({"pfpj.pre.html","text/html",.t.})
      elseif "pfpj.table_field.html" == fcPROGRAM
         return({"pfpj.table_field.html","text/html",.t.})
      elseif "pfpj.tipo.html" == fcPROGRAM
         return({"pfpj.tipo.html","text/html",.t.})
      elseif "pfpj_char" == fcPROGRAM
         return({"pfpj_char","text/html",.f.})
      elseif "pict.mark.html" == fcPROGRAM
         return({"pict.mark.html","text/html",.f.})
      elseif "plano_conta.mnt.html" == fcPROGRAM
         return({"plano_conta.mnt.html","text/html",.t.})
      elseif "plataforma_import" == fcPROGRAM
         return({"plataforma_import","text/html",.f.})
      elseif "pontualidade.mnt.html" == fcPROGRAM
         return({"pontualidade.mnt.html","text/html",.t.})
      elseif "pop.agenda.html" == fcPROGRAM
         return({"pop.agenda.html","text/html",.t.})
      elseif "pop.ts.pr.revisao.html" == fcPROGRAM
         return({"pop.ts.pr.revisao.html","text/html",.t.})
      elseif "portal.html" == fcPROGRAM
         return({"portal.html","text/html",.t.})
      elseif "portalteste" == fcPROGRAM
         return({"portalteste","text/html",.t.})
      elseif "posicao_imovel.mnt.html" == fcPROGRAM
         return({"posicao_imovel.mnt.html","text/html",.t.})
      elseif "probabilidade.tipo.mnt.html" == fcPROGRAM
         return({"probabilidade.tipo.mnt.html","text/html",.t.})
      elseif "produto.assistencia.mnt.html" == fcPROGRAM
         return({"produto.assistencia.mnt.html","text/html",.t.})
      elseif "produto.causa.mnt.html" == fcPROGRAM
         return({"produto.causa.mnt.html","text/html",.t.})
      elseif "produto.linha.mnt.html" == fcPROGRAM
         return({"produto.linha.mnt.html","text/html",.t.})
      elseif "produto.marca.mnt.html" == fcPROGRAM
         return({"produto.marca.mnt.html","text/html",.t.})
      elseif "produto.mnt.html" == fcPROGRAM
         return({"produto.mnt.html","text/html",.t.})
      elseif "deliberacao.mnt.html" == fcPROGRAM
         return({"deliberacao.mnt.html","text/html",.t.})
      elseif "produto.solucao.mnt.html" == fcPROGRAM
         return({"produto.solucao.mnt.html","text/html",.t.})
      elseif "produto1.mnt.html" == fcPROGRAM
         return({"produto1.mnt.html","text/html",.t.})
      elseif "ps.ata.deliberacao.html" == fcPROGRAM
         return({"ps.ata.deliberacao.html","text/html",.t.})
      elseif "ps.ata2.deliberacao.html" == fcPROGRAM
         return({"ps.ata2.deliberacao.html","text/html",.t.})
      elseif "ps.cap.alteracao.html" == fcPROGRAM
         return({"ps.cap.alteracao.html","text/html",.t.})
      elseif "ps.esc.despesa.html" == fcPROGRAM
         return({"ps.esc.despesa.html","text/html",.t.})
      elseif "ps.log.alteracao.html" == fcPROGRAM
         return({"ps.log.alteracao.html","text/html",.t.})


      elseif "ps.lst.2assembleia.html" == fcPROGRAM
         return({"ps.lst.2assembleia.html","text/html",.t.})
      elseif "ps.lst.4assembleia.html" == fcPROGRAM
         return({"ps.lst.4assembleia.html","text/html",.t.})
      elseif "ps.lst.assembleia.html" == fcPROGRAM
         return({"ps.lst.assembleia.html","text/html",.t.})
      elseif "ps.mnt.2assembleia.html" == fcPROGRAM
         return({"ps.mnt.2assembleia.html","text/html",.t.})
      elseif "ps.mnt.4assembleia.html" == fcPROGRAM
         return({"ps.mnt.4assembleia.html","text/html",.t.})
      elseif "ps.mnt.assembleia.html" == fcPROGRAM
         return({"ps.mnt.assembleia.html","text/html",.t.})


      elseif "ps.mvt.despesa.html" == fcPROGRAM
         return({"ps.mvt.despesa.html","text/html",.t.})
      elseif "ps.otgados.html" == fcPROGRAM
         return({"ps.otgados.html","text/html",.t.})
      elseif "ps.otgantes.html" == fcPROGRAM
         return({"ps.otgantes.html","text/html",.t.})
      elseif "ps.poderes.html" == fcPROGRAM
         return({"ps.poderes.html","text/html",.t.})
      elseif "ps.prc.poderes.html" == fcPROGRAM
         return({"ps.prc.poderes.html","text/html",.t.})
      elseif "ps.sct.4atas.html" == fcPROGRAM
         return({"ps.sct.4atas.html","text/html",.t.})
      elseif "ps.sct.4procedimento.html" == fcPROGRAM
         return({"ps.sct.4procedimento.html","text/html",.t.})
      elseif "ps.sct.4socios.html" == fcPROGRAM
         return({"ps.sct.4socios.html","text/html",.t.})
      elseif "ps.sct.atas.html" == fcPROGRAM
         return({"ps.sct.atas.html","text/html",.t.})
      elseif "ps.sct.conselhos.html" == fcPROGRAM
         return({"ps.sct.conselhos.html","text/html",.t.})
      elseif "ps.sct.diretoria.html" == fcPROGRAM
         return({"ps.sct.diretoria.html","text/html",.t.})
      elseif "ps.sct.participacao.html" == fcPROGRAM
         return({"ps.sct.participacao.html","text/html",.t.})
      elseif "ps.sct.procedimento.html" == fcPROGRAM
         return({"ps.sct.procedimento.html","text/html",.t.})
      elseif "ps.sct.socios.html" == fcPROGRAM
         return({"ps.sct.socios.html","text/html",.t.})
      elseif "ps.sct.superintendencia.html" == fcPROGRAM
         return({"ps.sct.superintendencia.html","text/html",.t.})
      elseif "ps.tipo.relacionamento.mnt.html" == fcPROGRAM
         return({"ps.tipo.relacionamento.mnt.html","text/html",.t.})
      elseif "psab.2despesa.html" == fcPROGRAM
         return({"psab.2despesa.html","text/html",.t.})
      elseif "psab.abatimentos.html" == fcPROGRAM
         return({"psab.abatimentos.html","text/html",.t.})
      elseif "psab.acao.html" == fcPROGRAM
         return({"psab.acao.html","text/html",.t.})
      elseif "psab.acordo.html" == fcPROGRAM
         return({"psab.acordo.html","text/html",.t.})
      elseif "psab.adv.avaliacoes.html" == fcPROGRAM
         return({"psab.adv.avaliacoes.html","text/html",.t.})
      elseif "psab.agenda.html" == fcPROGRAM
         return({"psab.agenda.html","text/html",.t.})
      elseif "psab.analise.causa.html" == fcPROGRAM
         return({"psab.analise.causa.html","text/html",.t.})
      elseif "psab.auto.html" == fcPROGRAM
         return({"psab.auto.html","text/html",.t.})
      elseif "psab.autoaprova.html" == fcPROGRAM
         return({"psab.autoaprova.html","text/html",.t.})
      elseif "psab.avaliacoes.html" == fcPROGRAM
         return({"psab.avaliacoes.html","text/html",.t.})
      elseif "psab.causaraiz.html" == fcPROGRAM
         return({"psab.causaraiz.html","text/html",.t.})
      elseif "psab.comercial.html" == fcPROGRAM
         return({"psab.comercial.html","text/html",.t.})
      elseif "psab.consultor_interno.html" == fcPROGRAM
         return({"psab.consultor_interno.html","text/html",.t.})
      elseif "psab.cont_hono.html" == fcPROGRAM
         return({"psab.cont_hono.html","text/html",.t.})
      elseif "psab.corporativo.html" == fcPROGRAM
         return({"psab.corporativo.html","text/html",.t.})
      elseif "psab.cped2.html" == fcPROGRAM
         return({"psab.cped2.html","text/html",.t.})
      elseif "psab.credito.html" == fcPROGRAM
         return({"psab.credito.html","text/html",.t.})
      elseif "psab.dep.cont.html" == fcPROGRAM
         return({"psab.dep.cont.html","text/html",.t.})
      elseif "psab.deposito.html" == fcPROGRAM
         return({"psab.deposito.html","text/html",.t.})
      elseif "psab.designar.escritorio.html" == fcPROGRAM
         return({"psab.designar.escritorio.html","text/html",.t.})
      elseif "psab.desp.adicionais.html" == fcPROGRAM
         return({"psab.desp.adicionais.html","text/html",.t.})
      elseif "psab.despesa.html" == fcPROGRAM
         return({"psab.despesa.html","text/html",.t.})
      elseif "psab.div.responsabilidade.html" == fcPROGRAM
         return({"psab.div.responsabilidade.html","text/html",.t.})
      elseif "psab.docs_contratos.html" == fcPROGRAM
         return({"psab.docs_contratos.html","text/html",.t.})
      elseif "psab.documentos.html" == fcPROGRAM
         return({"psab.documentos.html","text/html",.t.})
      elseif "psab.embargo.html" == fcPROGRAM
         return({"psab.embargo.html","text/html",.t.})
      elseif "psab.encerramento.contrato.html" == fcPROGRAM
         return({"psab.encerramento.contrato.html","text/html",.t.})
      elseif "psab.escritorio.html" == fcPROGRAM
         return({"psab.escritorio.html","text/html",.t.})
      elseif "psab.esocial.html" == fcPROGRAM
         return({"psab.esocial.html","text/html",.t.})
      elseif "psab.fcpa.html" == fcPROGRAM
         return({"psab.fcpa.html","text/html",.t.})
      elseif "psab.filiais.html" == fcPROGRAM
         return({"psab.filiais.html","text/html",.t.})
      elseif "psab.garantia.html" == fcPROGRAM
         return({"psab.garantia.html","text/html",.t.})
      elseif "psab.gr.despesa.html" == fcPROGRAM
         return({"psab.gr.despesa.html","text/html",.t.})
      elseif "psab.honorario.html" == fcPROGRAM
         return({"psab.honorario.html","text/html",.t.})
      elseif "psab.incorporacao.html" == fcPROGRAM
         return({"psab.incorporacao.html","text/html",.t.})
      elseif "psab.inf.comerciais.html" == fcPROGRAM
         return({"psab.inf.comerciais.html","text/html",.t.})
      elseif "psab.investimentos.html" == fcPROGRAM
         return({"psab.investimentos.html","text/html",.t.})
      elseif "psab.itens.html" == fcPROGRAM
         return({"psab.itens.html","text/html",.t.})
      elseif "psab.jurisprudencia.html" == fcPROGRAM
         return({"psab.jurisprudencia.html","text/html",.t.})
      elseif "psab.lic_certificado.html" == fcPROGRAM
         return({"psab.lic_certificado.html","text/html",.t.})
      elseif "psab.locador.html" == fcPROGRAM
         return({"psab.locador.html","text/html",.t.})
      elseif "psab.mvt_contabil.html" == fcPROGRAM
         return({"psab.mvt_contabil.html","text/html",.t.})
      elseif "psab.notificacao.html" == fcPROGRAM
         return({"psab.notificacao.html","text/html",.t.})
      elseif "psab.nuloresultado.html" == fcPROGRAM
         return({"psab.nuloresultado.html","text/html",.t.})
      elseif "psab.ocorecur.html" == fcPROGRAM
         return({"psab.ocorecur.html","text/html",.t.})
      elseif "psab.ped2.html" == fcPROGRAM
         return({"psab.ped2.html","text/html",.t.})
      elseif "psab.ped3.html" == fcPROGRAM
         return({"psab.ped3.html","text/html",.t.})
      elseif "psab.pedido.html" == fcPROGRAM
         return({"psab.pedido.html","text/html",.t.})
      elseif "psab.ped_indenizatorio.html" == fcPROGRAM
         return({"psab.ped_indenizatorio.html","text/html",.t.})
      elseif "psab.pesquisa.html" == fcPROGRAM
         return({"psab.pesquisa.html","text/html",.t.})
      elseif "psab.propostacom.html" == fcPROGRAM
         return({"psab.propostacom.html","text/html",.t.})
      elseif "psab.ra.contratos.html" == fcPROGRAM
         return({"psab.ra.contratos.html","text/html",.t.})
      elseif "psab.ra.ocorrencias.html" == fcPROGRAM
         return({"psab.ra.ocorrencias.html","text/html",.t.})
      elseif "psab.ra.recupera.html" == fcPROGRAM
         return({"psab.ra.recupera.html","text/html",.t.})
      elseif "psab.rateio.ccusto.html" == fcPROGRAM
         return({"psab.rateio.ccusto.html","text/html",.t.})
      elseif "psab.receb_ressarc.html" == fcPROGRAM
         return({"psab.receb_ressarc.html","text/html",.t.})
      elseif "psab.reclamante.html" == fcPROGRAM
         return({"psab.reclamante.html","text/html",.t.})
      elseif "psab.recurso.html" == fcPROGRAM
         return({"psab.recurso.html","text/html",.t.})
      elseif "psab.relacionamento.html" == fcPROGRAM
         return({"psab.relacionamento.html","text/html",.t.})
      elseif "psab.renovacao.html" == fcPROGRAM
         return({"psab.renovacao.html","text/html",.t.})
      elseif "psab.res.contrato3.html" == fcPROGRAM
         return({"psab.res.contrato3.html","text/html",.t.})
      elseif "psab.res.sin.html" == fcPROGRAM
         return({"psab.res.sin.html","text/html",.t.})
      elseif "psab.res2.html" == fcPROGRAM
         return({"psab.res2.html","text/html",.t.})
      elseif "psab.resultado.html" == fcPROGRAM
         return({"psab.resultado.html","text/html",.t.})
      elseif "psab.risco_atividade.html" == fcPROGRAM
         return({"psab.risco_atividade.html","text/html",.t.})
      elseif "psab.se.cont.html" == fcPROGRAM
         return({"psab.se.cont.html","text/html",.t.})
      elseif "psab.seg.1cont.sinistro.html" == fcPROGRAM
         return({"psab.seg.1cont.sinistro.html","text/html",.t.})
      elseif "psab.seg.2cont.sinistro.html" == fcPROGRAM
         return({"psab.seg.2cont.sinistro.html","text/html",.t.})
      elseif "psab.seg.cont.sinistro.html" == fcPROGRAM
         return({"psab.seg.cont.sinistro.html","text/html",.t.})
      elseif "psab.seg.sinistro.html" == fcPROGRAM
         return({"psab.seg.sinistro.html","text/html",.t.})
      elseif "psab.seguro.html" == fcPROGRAM
         return({"psab.seguro.html","text/html",.t.})
      elseif "psab.sindicancia.html" == fcPROGRAM
         return({"psab.sindicancia.html","text/html",.t.})
      elseif "psab.susep.html" == fcPROGRAM
         return({"psab.susep.html","text/html",.t.})
      elseif "psab.timesheet.html" == fcPROGRAM
         return({"psab.timesheet.html","text/html",.t.})
      elseif "psab.trab.analise.interna.html" == fcPROGRAM
         return({"psab.trab.analise.interna.html","text/html",.t.})
      elseif "psab.unifica.pasta.html" == fcPROGRAM
         return({"psab.unifica.pasta.html","text/html",.t.})
      elseif "psab.valor.html" == fcPROGRAM
         return({"psab.valor.html","text/html",.t.})
      elseif "pst.1aditivo.contrato.html" == fcPROGRAM
         return({"pst.1aditivo.contrato.html","text/html",.t.})
      elseif "pst.2anexo.html" == fcPROGRAM
         return({"pst.2anexo.html","text/html",.t.})
      elseif "pst.aditivo.contrato.html" == fcPROGRAM
         return({"pst.aditivo.contrato.html","text/html",.t.})
      elseif "pst.anexo.contrato.html" == fcPROGRAM
         return({"pst.anexo.contrato.html","text/html",.t.})
      elseif "pst.cabecalho.sbhtml" == fcPROGRAM
         return({"pst.cabecalho.sbhtml","text/html",.t.})
      elseif "pst.consultor_externo.html" == fcPROGRAM
         return({"pst.consultor_externo.html","text/html",.t.})
      elseif "pst.descr.poderes.html" == fcPROGRAM
         return({"pst.descr.poderes.html","text/html",.t.})
      elseif "pst.desc_reclama.html" == fcPROGRAM
         return({"pst.desc_reclama.html","text/html",.t.})
      elseif "pst.distribuicao_externa.html" == fcPROGRAM
         return({"pst.distribuicao_externa.html","text/html",.t.})
      elseif "pst.dist_interna.html" == fcPROGRAM
         return({"pst.dist_interna.html","text/html",.t.})
      elseif "pst.execucao.html" == fcPROGRAM
         return({"pst.execucao.html","text/html",.t.})
      elseif "pst.interno.html" == fcPROGRAM
         return({"pst.interno.html","text/html",.t.})
      elseif "pst.ocorrido.html" == fcPROGRAM
         return({"pst.ocorrido.html","text/html",.t.})
      elseif "pst.parte_passiva.html" == fcPROGRAM
         return({"pst.parte_passiva.html","text/html",.t.})
      elseif "pst.penhora.html" == fcPROGRAM
         return({"pst.penhora.html","text/html",.t.})
      elseif "pst.seguro.html" == fcPROGRAM
         return({"pst.seguro.html","text/html",.t.})
      elseif "pst.transf.html" == fcPROGRAM
         return({"pst.transf.html","text/html",.t.})
      elseif "qtde.dias.mnt.html" == fcPROGRAM
         return({"qtde.dias.mnt.html","text/html",.t.})
      elseif "qualidade.mnt.html" == fcPROGRAM
         return({"qualidade.mnt.html","text/html",.t.})
      elseif "query.1ajx" == fcPROGRAM
         return({"query.1ajx","text/html",.f.})
      elseif "query.ajx" == fcPROGRAM
         return({"query.ajx","text/html",.f.})
      elseif "query.ajx1" == fcPROGRAM
         return({"query.ajx1","text/html",.f.})
      elseif "query.gajx" == fcPROGRAM
         return({"query.gajx","text/html",.f.})
      elseif "questionamento_motivo.mnt.html" == fcPROGRAM
         return({"questionamento_motivo.mnt.html","text/html",.t.})
      elseif "rb3" == fcPROGRAM
         return({"rb3","text/html",.t.})
      elseif "redirect.wic" == fcPROGRAM
         return({"redirect.wic","text/html",.t.})
      elseif "regiao.mnt.html" == fcPROGRAM
         return({"regiao.mnt.html","text/html",.t.})
      elseif "regional.mnt.html" == fcPROGRAM
         return({"regional.mnt.html","text/html",.t.})
      elseif "rel.alfa.fipe.analitico.html" == fcPROGRAM
         return({"rel.alfa.fipe.analitico.html","text/html",.t.})
      elseif "rel.alfa.memorando.html" == fcPROGRAM
         return({"rel.alfa.memorando.html","text/html",.t.})
      elseif "rel.alfa.previdencia.html" == fcPROGRAM
         return({"rel.alfa.previdencia.html","text/html",.t.})
      elseif "rel.alfa.seguradora.html" == fcPROGRAM
         return({"rel.alfa.seguradora.html","text/html",.t.})
      elseif "rel.geral.processos.html" == fcPROGRAM
         return({"rel.geral.processos.html","text/html",.t.})
      elseif "rel.memorando.html" == fcPROGRAM
         return({"rel.memorando.html","text/html",.t.})
      elseif "rel.vpar.societarios.html" == fcPROGRAM
         return({"rel.vpar.societarios.html","text/html",.t.})
      elseif "remessa_tipo.mnt.html" == fcPROGRAM
         return({"remessa_tipo.mnt.html","text/html",.t.})
      elseif "reskeyvendor.mnt.html" == fcPROGRAM
         return({"reskeyvendor.mnt.html","text/html",.t.})
      elseif "resp_dano.mnt.html" == fcPROGRAM
         return({"resp_dano.mnt.html","text/html",.t.})
      elseif "restructgr5" == fcPROGRAM
         return({"restructgr5","text/html",.t.})
      elseif "resultado_contrato.mnt.html" == fcPROGRAM
         return({"resultado_contrato.mnt.html","text/html",.t.})
      elseif "riscoperda_pedido.mnt.html" == fcPROGRAM
         return({"riscoperda_pedido.mnt.html","text/html",.t.})
      elseif "roda.xup.mnt.html" == fcPROGRAM
         return({"roda.xup.mnt.html","text/html",.t.})
      elseif "ro_judicial.html" == fcPROGRAM
         return({"ro_judicial.html","text/html",.f.})
      elseif "sch.ac.group.html" == fcPROGRAM
         return({"sch.ac.group.html","text/html",.t.})
      elseif "sch.afastamento.html" == fcPROGRAM
         return({"sch.afastamento.html","text/html",.t.})
      elseif "sch.alcada.html" == fcPROGRAM
         return({"sch.alcada.html","text/html",.t.})
      elseif "sch.all.abas.html" == fcPROGRAM
         return({"sch.all.abas.html","text/html",.t.})
      elseif "sch.all.fields.html" == fcPROGRAM
         return({"sch.all.fields.html","text/html",.t.})
      elseif "sch.all.objeto.html" == fcPROGRAM
         return({"sch.all.objeto.html","text/html",.t.})
      elseif "sch.all.pasta.html" == fcPROGRAM
         return({"sch.all.pasta.html","text/html",.t.})
      elseif "sch.all.pedido.html" == fcPROGRAM
         return({"sch.all.pedido.html","text/html",.t.})
      elseif "sch.andamentos_envio.html" == fcPROGRAM
         return({"sch.andamentos_envio.html","text/html",.t.})
      elseif "sch.atividade.recurso.html" == fcPROGRAM
         return({"sch.atividade.recurso.html","text/html",.t.})
      elseif "sch.atuacao_poder.html" == fcPROGRAM
         return({"sch.atuacao_poder.html","text/html",.t.})
      elseif "sch.bodespesa.html" == fcPROGRAM
         return({"sch.bodespesa.html","text/html",.t.})
      elseif "sch.canal_produto.html" == fcPROGRAM
         return({"sch.canal_produto.html","text/html",.t.})
      elseif "sch.cargo.html" == fcPROGRAM
         return({"sch.cargo.html","text/html",.t.})
      elseif "sch.causanis.html" == fcPROGRAM
         return({"sch.causanis.html","text/html",.t.})
      elseif "sch.ccusto.html" == fcPROGRAM
         return({"sch.ccusto.html","text/html",.t.})
      elseif "sch.cidade.html" == fcPROGRAM
         return({"sch.cidade.html","text/html",.t.})
      elseif "sch.clas_doenca.html" == fcPROGRAM
         return({"sch.clas_doenca.html","text/html",.t.})
      elseif "sch.coberturas_ramos.html" == fcPROGRAM
         return({"sch.coberturas_ramos.html","text/html",.t.})
      elseif "sch.cobranca.html" == fcPROGRAM
         return({"sch.cobranca.html","text/html",.t.})
      elseif "sch.comarca_regiao.html" == fcPROGRAM
         return({"sch.comarca_regiao.html","text/html",.t.})
      elseif "sch.combinacao_poder.html" == fcPROGRAM
         return({"sch.combinacao_poder.html","text/html",.t.})
      elseif "sch.conjunto.poder.html" == fcPROGRAM
         return({"sch.conjunto.poder.html","text/html",.t.})
      elseif "sch.conta.debito.html" == fcPROGRAM
         return({"sch.conta.debito.html","text/html",.t.})
      elseif "sch.convencao.html" == fcPROGRAM
         return({"sch.convencao.html","text/html",.t.})
      elseif "sch.cor.html" == fcPROGRAM
         return({"sch.cor.html","text/html",.t.})
      elseif "sch.corp.despesa.html" == fcPROGRAM
         return({"sch.corp.despesa.html","text/html",.t.})
      elseif "sch.corp.servico.html" == fcPROGRAM
         return({"sch.corp.servico.html","text/html",.t.})
      elseif "sch.ctrdo.html" == fcPROGRAM
         return({"sch.ctrdo.html","text/html",.t.})
      elseif "sch.ctrte.html" == fcPROGRAM
         return({"sch.ctrte.html","text/html",.t.})
      elseif "sch.dc_envio.html" == fcPROGRAM
         return({"sch.dc_envio.html","text/html",.t.})
      elseif "sch.departarea.html" == fcPROGRAM
         return({"sch.departarea.html","text/html",.t.})
      elseif "sch.depto.resp.html" == fcPROGRAM
         return({"sch.depto.resp.html","text/html",.t.})
      elseif "sch.desligamento.html" == fcPROGRAM
         return({"sch.desligamento.html","text/html",.t.})
      elseif "sch.despesa.html" == fcPROGRAM
         return({"sch.despesa.html","text/html",.t.})
      elseif "sch.documento.html" == fcPROGRAM
         return({"sch.documento.html","text/html",.t.})
      elseif "sch.doenca.html" == fcPROGRAM
         return({"sch.doenca.html","text/html",.t.})
      elseif "sch.estimativas.html" == fcPROGRAM
         return({"sch.estimativas.html","text/html",.t.})
      elseif "sch.exito_riscoperda.html" == fcPROGRAM
         return({"sch.exito_riscoperda.html","text/html",.t.})
      elseif "sch.field.html" == fcPROGRAM
         return({"sch.field.html","text/html",.t.})
      elseif "sch.fields.pscalc.html" == fcPROGRAM
         return({"sch.fields.pscalc.html","text/html",.t.})
      elseif "sch.geocidade.html" == fcPROGRAM
         return({"sch.geocidade.html","text/html",.t.})
      elseif "sch.gestor.html" == fcPROGRAM
         return({"sch.gestor.html","text/html",.t.})
      elseif "sch.groups.html" == fcPROGRAM
         return({"sch.groups.html","text/html",.t.})
      elseif "sch.grp_despesa.html" == fcPROGRAM
         return({"sch.grp_despesa.html","text/html",.t.})
      elseif "sch.grupo_economico.html" == fcPROGRAM
         return({"sch.grupo_economico.html","text/html",.t.})
      elseif "sch.honorarios.html" == fcPROGRAM
         return({"sch.honorarios.html","text/html",.t.})
      elseif "sch.incorporacao.html" == fcPROGRAM
         return({"sch.incorporacao.html","text/html",.t.})
      elseif "sch.indice.reajuste.html" == fcPROGRAM
         return({"sch.indice.reajuste.html","text/html",.t.})
      elseif "sch.jurcc.html" == fcPROGRAM
         return({"sch.jurcc.html","text/html",.t.})
      elseif "sch.keyvendor.html" == fcPROGRAM
         return({"sch.keyvendor.html","text/html",.t.})
      elseif "sch.lg_resp.html" == fcPROGRAM
         return({"sch.lg_resp.html","text/html",.t.})
      elseif "sch.login.html" == fcPROGRAM
         return({"sch.login.html","text/html",.t.})
      elseif "sch.loja.html" == fcPROGRAM
         return({"sch.loja.html","text/html",.t.})
      elseif "sch.lojap.html" == fcPROGRAM
         return({"sch.lojap.html","text/html",.t.})
      elseif "sch.loteamento.html" == fcPROGRAM
         return({"sch.loteamento.html","text/html",.t.})
      elseif "sch.moeda.html" == fcPROGRAM
         return({"sch.moeda.html","text/html",.t.})
      elseif "sch.motivo_operacao.html" == fcPROGRAM
         return({"sch.motivo_operacao.html","text/html",.t.})
      elseif "sch.objeto.html" == fcPROGRAM
         return({"sch.objeto.html","text/html",.t.})
      elseif "sch.ocorrencia_pedido.html" == fcPROGRAM
         return({"sch.ocorrencia_pedido.html","text/html",.t.})
      elseif "sch.ocor_pedido.html" == fcPROGRAM
         return({"sch.ocor_pedido.html","text/html",.t.})
      elseif "sch.parceiro1.html" == fcPROGRAM
         return({"sch.parceiro1.html","text/html",.t.})
      elseif "sch.pasta.html" == fcPROGRAM
         return({"sch.pasta.html","text/html",.t.})
      elseif "sch.pastaseguro.html" == fcPROGRAM
         return({"sch.pastaseguro.html","text/html",.t.})
      elseif "sch.pedido.html" == fcPROGRAM
         return({"sch.pedido.html","text/html",.t.})
      elseif "sch.ped_despesa.html" == fcPROGRAM
         return({"sch.ped_despesa.html","text/html",.t.})
      elseif "sch.ped_seguro.html" == fcPROGRAM
         return({"sch.ped_seguro.html","text/html",.t.})
      elseif "sch.pfpj.atividade.html" == fcPROGRAM
         return({"sch.pfpj.atividade.html","text/html",.t.})
      elseif "sch.pfpj.cargo.html" == fcPROGRAM
         return({"sch.pfpj.cargo.html","text/html",.t.})
      elseif "sch.pfpj.html" == fcPROGRAM
         return({"sch.pfpj.html","text/html",.t.})
      elseif "sch.pfpj.tipos.html" == fcPROGRAM
         return({"sch.pfpj.tipos.html","text/html",.t.})
      elseif "sch.plct.html" == fcPROGRAM
         return({"sch.plct.html","text/html",.t.})
      elseif "sch.poder.tipo.html" == fcPROGRAM
         return({"sch.poder.tipo.html","text/html",.t.})
      elseif "sch.pproduto.html" == fcPROGRAM
         return({"sch.pproduto.html","text/html",.t.})
      elseif "sch.prc.poder.html" == fcPROGRAM
         return({"sch.prc.poder.html","text/html",.t.})
      elseif "sch.procuracao.clausula.html" == fcPROGRAM
         return({"sch.procuracao.clausula.html","text/html",.t.})
      elseif "sch.produto.html" == fcPROGRAM
         return({"sch.produto.html","text/html",.t.})
      elseif "sch.pst.contrato.html" == fcPROGRAM
         return({"sch.pst.contrato.html","text/html",.t.})
      elseif "sch.pst.origem.html" == fcPROGRAM
         return({"sch.pst.origem.html","text/html",.t.})
      elseif "sch.ramosrsn.html" == fcPROGRAM
         return({"sch.ramosrsn.html","text/html",.t.})
      elseif "sch.recurso.status.html" == fcPROGRAM
         return({"sch.recurso.status.html","text/html",.t.})
      elseif "sch.riscoperda_pedido.html" == fcPROGRAM
         return({"sch.riscoperda_pedido.html","text/html",.t.})
      elseif "sch.sct.atas.html" == fcPROGRAM
         return({"sch.sct.atas.html","text/html",.t.})
      elseif "sch.seguro.html" == fcPROGRAM
         return({"sch.seguro.html","text/html",.t.})
      elseif "sch.servico.html" == fcPROGRAM
         return({"sch.servico.html","text/html",.t.})
      elseif "sch.sin.causa.html" == fcPROGRAM
         return({"sch.sin.causa.html","text/html",.t.})
      elseif "sch.status.proposta.html" == fcPROGRAM
         return({"sch.status.proposta.html","text/html",.t.})
      elseif "sch.tab.despesa.html" == fcPROGRAM
         return({"sch.tab.despesa.html","text/html",.t.})
      elseif "sch.tab.honorario.html" == fcPROGRAM
         return({"sch.tab.honorario.html","text/html",.t.})
      elseif "sch.tab.servico.html" == fcPROGRAM
         return({"sch.tab.servico.html","text/html",.t.})
      elseif "sch.table.html" == fcPROGRAM
         return({"sch.table.html","text/html",.t.})
      elseif "sch.tb_fields.html" == fcPROGRAM
         return({"sch.tb_fields.html","text/html",.t.})
      elseif "sch.tipo.pfpj.html" == fcPROGRAM
         return({"sch.tipo.pfpj.html","text/html",.t.})
      elseif "sch.tipo_recebe.html" == fcPROGRAM
         return({"sch.tipo_recebe.html","text/html",.t.})
      elseif "sch.tp.emissao.html" == fcPROGRAM
         return({"sch.tp.emissao.html","text/html",.t.})
      elseif "sch.tp.poder.html" == fcPROGRAM
         return({"sch.tp.poder.html","text/html",.t.})
      elseif "sch.tp_expediente.html" == fcPROGRAM
         return({"sch.tp_expediente.html","text/html",.t.})
      elseif "sch.transacao.contabil.html" == fcPROGRAM
         return({"sch.transacao.contabil.html","text/html",.t.})
      elseif "sch.tributos.html" == fcPROGRAM
         return({"sch.tributos.html","text/html",.t.})
      elseif "sch.ts.pt.pasta.html" == fcPROGRAM
         return({"sch.ts.pt.pasta.html","text/html",.t.})
      elseif "sch.uf.html" == fcPROGRAM
         return({"sch.uf.html","text/html",.t.})
      elseif "sch.unidade_medida.html" == fcPROGRAM
         return({"sch.unidade_medida.html","text/html",.t.})
      elseif "sch.users.html" == fcPROGRAM
         return({"sch.users.html","text/html",.t.})
      elseif "sch.users2.html" == fcPROGRAM
         return({"sch.users2.html","text/html",.t.})
      elseif "sch.wprgroup.html" == fcPROGRAM
         return({"sch.wprgroup.html","text/html",.t.})
      elseif "sch.wprogram.html" == fcPROGRAM
         return({"sch.wprogram.html","text/html",.t.})
      elseif "sch.xstatus.proposta.html" == fcPROGRAM
         return({"sch.xstatus.proposta.html","text/html",.t.})
      elseif "seguro_responsabilidade.mnt.html" == fcPROGRAM
         return({"seguro_responsabilidade.mnt.html","text/html",.t.})
      elseif "seg_habit_export.html" == fcPROGRAM
         return({"seg_habit_export.html","text/html",.f.})
      elseif "selecao.js.sbhtml" == fcPROGRAM
         return({"selecao.js.sbhtml","text/html",.t.})
      elseif "sendemail.wic" == fcPROGRAM
         return({"sendemail.wic","text/html",.t.})
      elseif "sendsms.wic" == fcPROGRAM
         return({"sendsms.wic","text/html",.t.})
      elseif "servconf.mnt.html" == fcPROGRAM
         return({"servconf.mnt.html","text/html",.t.})
      elseif "servico.mnt.html" == fcPROGRAM
         return({"servico.mnt.html","text/html",.t.})
      elseif "servlog.mnt.html" == fcPROGRAM
         return({"servlog.mnt.html","text/html",.t.})
      elseif "setup.html" == fcPROGRAM
         return({"setup.html","text/html",.t.})
      elseif "sias_caixa.html" == fcPROGRAM
         return({"sias_caixa.html","text/html",.f.})
      elseif "sios_cosesp.html" == fcPROGRAM
         return({"sios_cosesp.html","text/html",.f.})
      elseif "siscodida" == fcPROGRAM
         return({"siscodida","text/html",.f.})
      elseif "siscodvolta" == fcPROGRAM
         return({"siscodvolta","text/html",.f.})
      elseif "sitconsulta.mnt.html" == fcPROGRAM
         return({"sitconsulta.mnt.html","text/html",.t.})
      elseif "sla.analitico.html" == fcPROGRAM
         return({"sla.analitico.html","text/html",.t.})
      elseif "snt" == fcPROGRAM
         return({"snt","text/html",.f.})
      elseif "sql.atack.cfg.html" == fcPROGRAM
         return({"sql.atack.cfg.html","text/html",.t.})
      elseif "status.recurso.mnt.html" == fcPROGRAM
         return({"status.recurso.mnt.html","text/html",.t.})
      elseif "statusinterface.mnt.html" == fcPROGRAM
         return({"statusinterface.mnt.html","text/html",.t.})
      elseif "status_notificacao.mnt.html" == fcPROGRAM
         return({"status_notificacao.mnt.html","text/html",.t.})
      elseif "status_penhora.mnt.html" == fcPROGRAM
         return({"status_penhora.mnt.html","text/html",.t.})
      elseif "status_procuracao.mnt.html" == fcPROGRAM
         return({"status_procuracao.mnt.html","text/html",.t.})
      elseif "st_lote.mnt.html" == fcPROGRAM
         return({"st_lote.mnt.html","text/html",.t.})
      elseif "sunsystem_export_html" == fcPROGRAM
         return({"sunsystem_export_html","text/html",.f.})
      elseif "sun_export.html" == fcPROGRAM
         return({"sun_export.html","text/html",.f.})
      elseif "sysopcarga" == fcPROGRAM
         return({"sysopcarga","text/html",.f.})
      elseif "tabela_autoinc.mnt.html" == fcPROGRAM
         return({"tabela_autoinc.mnt.html","text/html",.t.})
      elseif "task.category.html" == fcPROGRAM
         return({"task.category.html","text/html",.t.})
      elseif "task.group.html" == fcPROGRAM
         return({"task.group.html","text/html",.t.})
      elseif "task.status.html" == fcPROGRAM
         return({"task.status.html","text/html",.t.})
      elseif "teclado.virtual.sbhtml" == fcPROGRAM
         return({"teclado.virtual.sbhtml","text/html",.t.})
      elseif "tec_pontual.mnt.html" == fcPROGRAM
         return({"tec_pontual.mnt.html","text/html",.t.})
      elseif "testemunhano.mnt.html" == fcPROGRAM
         return({"testemunhano.mnt.html","text/html",.t.})
      elseif "tipocapital.mnt.html" == fcPROGRAM
         return({"tipocapital.mnt.html","text/html",.t.})
      elseif "tipoconta.mnt.html" == fcPROGRAM
         return({"tipoconta.mnt.html","text/html",.t.})
      elseif "tipoempresa.mnt.html" == fcPROGRAM
         return({"tipoempresa.mnt.html","text/html",.t.})
      elseif "tipo_carta.mnt.html" == fcPROGRAM
         return({"tipo_carta.mnt.html","text/html",.t.})
      elseif "tipo_consulta.mnt.html" == fcPROGRAM
         return({"tipo_consulta.mnt.html","text/html",.t.})
      elseif "tipo_docfiscal.mnt.html" == fcPROGRAM
         return({"tipo_docfiscal.mnt.html","text/html",.t.})
      elseif "tipo_favorecido.mnt.html" == fcPROGRAM
         return({"tipo_favorecido.mnt.html","text/html",.t.})
      elseif "tipo_notificacao.mnt.html" == fcPROGRAM
         return({"tipo_notificacao.mnt.html","text/html",.t.})
      elseif "tipo_pagto.mnt.html" == fcPROGRAM
         return({"tipo_pagto.mnt.html","text/html",.t.})
      elseif "tipo_pessoa.mnt.html" == fcPROGRAM
         return({"tipo_pessoa.mnt.html","text/html",.t.})
      elseif "tipo_providencia.mnt.html" == fcPROGRAM
         return({"tipo_providencia.mnt.html","text/html",.t.})
      elseif "tipo_sinistro.mnt.html" == fcPROGRAM
         return({"tipo_sinistro.mnt.html","text/html",.t.})
      elseif "tokiosin" == fcPROGRAM
         return({"tokiosin","text/html",.f.})
      elseif "tooltip.js.sbhtml" == fcPROGRAM
         return({"tooltip.js.sbhtml","text/html",.t.})
      elseif "tp_expediente.mnt.html" == fcPROGRAM
         return({"tp_expediente.mnt.html","text/html",.t.})
      elseif "tp_lancto.mnt.html" == fcPROGRAM
         return({"tp_lancto.mnt.html","text/html",.t.})
      elseif "tp_procuracao.mnt.html" == fcPROGRAM
         return({"tp_procuracao.mnt.html","text/html",.t.})
      elseif "tp_registro.mnt.html" == fcPROGRAM
         return({"tp_registro.mnt.html","text/html",.t.})
      elseif "tp_ressarc.mnt.html" == fcPROGRAM
         return({"tp_ressarc.mnt.html","text/html",.t.})
      elseif "tp_segmento.mnt.html" == fcPROGRAM
         return({"tp_segmento.mnt.html","text/html",.t.})
      elseif "transf.incorporacao.mnt.html" == fcPROGRAM
         return({"transf.incorporacao.mnt.html","text/html",.t.})
      elseif "transf.responsabilidade.bat.html" == fcPROGRAM
         return({"transf.responsabilidade.bat.html","text/html",.t.})
      elseif "turma.mnt.html" == fcPROGRAM
         return({"turma.mnt.html","text/html",.t.})
      elseif "uas_fnet" == fcPROGRAM
         return({"uas_fnet","text/html",.f.})
      elseif "unidade_medida.mnt.html" == fcPROGRAM
         return({"unidade_medida.mnt.html","text/html",.t.})
      elseif "validainterface.html" == fcPROGRAM
         return({"validainterface.html","text/html",.t.})
      elseif "view.markup.html" == fcPROGRAM
         return({"view.markup.html","text/html",.t.})
      elseif "webmail.wic" == fcPROGRAM
         return({"webmail.wic","text/html",.t.})
      elseif "werror.wic" == fcPROGRAM
         return({"werror.wic","text/html",.t.})
      elseif "werror_access.wic" == fcPROGRAM
         return({"werror_access.wic","text/html",.t.})
      elseif "wfp.sbhtml" == fcPROGRAM
         return({"wfp.sbhtml","text/html",.t.})
      elseif "wprofile" == fcPROGRAM
         return({"wprofile","text/html",.f.})
      elseif "xexecsql" == fcPROGRAM
         return({"xexecsql","text/html",.t.})
      elseif "xmark" == fcPROGRAM
         return({"xmark","text/html",.f.})
      elseif "xrb2" == fcPROGRAM
         return({"xrb2","text/html",.t.})
      elseif "xrb2a" == fcPROGRAM
         return({"xrb2a","text/html",.t.})
      elseif "xrb3" == fcPROGRAM
         return({"xrb3","text/html",.t.})
      elseif "xupddep" == fcPROGRAM
         return({"xupddep","text/html",.f.})
      elseif "xupdval" == fcPROGRAM
         return({"xupdval","text/html",.f.})
      else
         error_sys("Program not defined: "+transform(fcPROGRAM))
      endif
   return({})


/* programs only templates */

function cryptwprof()
return

function old_db_que()
return

function old_db_fin()
return

function mysinit()
return

function pgsinit()
return

function getmacaddr()
return('ok')

function run_cmd()
return(0)

function xrb3()
return(0)


function old_db_rep()
return

function atoa()  // so pra chamar as func
   odbinit()
   od3init()
return
/*
      elseif "xrb2" == fcPROGRAM
         return({"xrb2","text/html",.t.})
      elseif "xrb3" == fcPROGRAM
         return({"xrb3","text/html",.t.})
         
*/

// Glauber 16/08
// Solicitação do Alfa

Static Function CheckDbIsj()

local lcBuffer := "" as String
local lnArq := 0,;
      lnRes := 0 as int
local laRes := {} as Array      

   lcBuffer := replicate('',80) + chr(13) + chr(10) +;
               'Conectado na Instancia:'+WSet("INSTANCE_GR5") + chr(13) + chr(10) +;
               'Host..................:'+WSet("HOST_GR5") + chr(13) + chr(10) +;
               'Porta.................:'+WSet("PORT_GR5") + chr(13) + chr(10) +;
               'Usuario...............:'+WSet("USER_GR5") + chr(13) + chr(10) +;
               replicate('',80) + chr(13) + chr(10) +;
               'Conteudo da tela de login:' + chr(13) + chr(10) + chr(13) + chr(10)

   if db_select({'UISRC'},'dbui',,;
      {"program = 'login.html' and project = 'gr5'"}) = -1
      lcBuffer += db_error()
   else
      laRES := db_fetchall()
      if len(laRES) > 1
         lcBuffer += laRES[2,1]
      endif   
   endif
   
   lnArq := fcreate('checkdb.txt')
   fwrite(lnArq,lcBuffer)
   fclose(lnArq)
   
return   
   





// Glauber 03/2017 - Pasta 10560

Static Function  cleanTmpFiles()


   if file("IsjClean.exe")
      ! "IsjClean.exe"
   endif


return
