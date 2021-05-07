/*
Project      : gr5_305
Product      : gr5
Module       : gr5
Created on   : 05-Jul-2006
 Autor       : Mahler Informática / Wictrix 2.0
*/


#define CRLF chr(13)+chr(10)
#define LF chr(10)
#define DLMT chr(34)                  // delimited ( " )
#define DLAP chr(39)                  // delimited ( ' )
#define DLCM chr(34)+chr(44)+chr(34)  // delimited and coma ( "," )

function main()
   local ii := 0 as int
   local lntmpage := 0.000 ,;
         lntmfunc := 0.000 as float
   local lePROG := '' as string
   local lcCONTENTTYPE := {} as array

   public gaPAGE       := {} ,;
          gaWSET       := {} ,;
          gaWGET       := {} ,;
          gaWGET_FILE  := {} ,;
          gaWPUT       := {} ,;
          ga2WPUT      := {} ,;
          gaDBS        := {'GR5'} ,;
          gaERROR_SYS  := {} ,;
          gaWDATAURL   := {} ,;
          gaWDATAGLOBAL := {}
   public gcDB_ACTIVE      := '' ,;
          gcDB_DRV_ACTIVE  := ''
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

   public gnWN_ACS      := 0 ,;
          gnWN_ACS_FILE := 0 ,;
          gnTIME_TASK   := 0 ,;
          gnUID         := 0 ,;
          gnGID         := 0

   public gaWDATAURL := {}
   public aDb  := {} // Database names
   public aObj := {} // Database objects
   public oWic

   public gcLOGIN       := ''
   public gcAC_RESTRICT := ''


   set century on
   set date british
   set epoch to 1990

   lntmfunc := wic_time()

   readWSysProfile()
   readWGet()
   wSet("_PROJECT","gr5")
   wSet("_BUILD_SRC_PROJECT",        44)
   wSet("_BUILD_SRC_MODULE",      4647)
   wSet("_BUILD_UI",        35)
   wSet("_BUILD_DB",        30)
   wSet("_PROJECT_VERSION","3.5")
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
      wOut('db_active: not defined database: GR5')
      quit
   endif

   #include "/home/wproject/wictrix/gr5_305/wh/main_befdb.wh"


   db_init('GR5')
   if db_connect('GR5',;
           WSet("INSTANCE_GR5"),;
           WSet("HOST_GR5"),;
           WSet("PORT_GR5"),;
           WSet("USER_GR5"),;
           WSet("PASS_GR5")) != 0
      error_sys("db_connect -> "+db_error('GR5'))
   endif

   if gbWFL_AC    //  access control
      wAccess_control()
      if ! gbWAC_EXEC
         error_sys('Acesso não liberado ao programa '+gmPAGE)
      endif
   endif

   ReadDataGlobal()
   reTypeWget()

   #include "/home/wproject/wictrix/gr5_305/wh/main_aftdb.wh"

   lePROG := strtran(wSet("_USER_INTERFACE"),'.','_')
   if isfunction(lePROG)
      lePROG := lePROG+'()'
      eval({||&lePROG})

     #include "/home/wproject/wictrix/gr5_305/wh/main_aftmain.wh"

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

   lntmpage := wic_time()
   lntmfunc := wic_time() - lntmfunc

   if ! (gmPAGE_OLD == wSet("_USER_INTERFACE"))
      gmPAGE := wSet("_USER_INTERFACE")
   endif
   if gbFL_UI_DYN .and. gmPAGE != 'none.wic'
      if gmPAGE != gmPAGE_OLD
         if gbWFL_AC
            wAccess_control()

            if ! gbWAC_EXEC
               error_sys('Acesso não liberado ao programa '+wSet("_USER_INTERFACE"))
            endif
         endif
      endif
      exec_page(gmPAGE,gmLANGUAGE)
   endif

   if wSet("_WDEBUG") = "ENABLE" .and. len(gaERROR_SYS) > 0 .and. WSet("scCONTENT_TYPE") = "text/html"
      wOut(' ')
      wOut('  <!-- # error debug list # ')
      for ii := 1 to len(gaERROR_SYS)
         wOut('  <!-- ' + gaERROR_SYS[ii] + '  ')
      next  ii
      wOut('  -->')
   endif

   lntmpage := wic_time() - lntmpage
   wAccess_File(lntmfunc,lntmpage)

   db_disconnect()

   quit
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
      elseif "ac.field.redef.html" == fcPROGRAM
         return({"ac.field.redef.html","text/html",.t.})
      elseif "aditivo_tipo.mnt.html" == fcPROGRAM
         return({"aditivo_tipo.mnt.html","text/html",.t.})
      elseif "area.mnt.html" == fcPROGRAM
         return({"area.mnt.html","text/html",.t.})
      elseif "autosch.wic" == fcPROGRAM
         return({"autosch.wic","text/html",.t.})
      elseif "auto_search.sbhtml" == fcPROGRAM
         return({"auto_search.sbhtml","text/html",.t.})
      elseif "bat.markup.html" == fcPROGRAM
         return({"bat.markup.html","text/html",.t.})
      elseif "bat.rb.export.html" == fcPROGRAM
         return({"bat.rb.export.html","text/html",.f.})
      elseif "build_program" == fcPROGRAM
         return({"build_program","text/html",.t.})
      elseif "canais.relacionamento.mnt.html" == fcPROGRAM
         return({"canais.relacionamento.mnt.html","text/html",.t.})
      elseif "cfg.pst.juros.html" == fcPROGRAM
         return({"cfg.pst.juros.html","text/html",.t.})
      elseif "cfg.pst.valores.html" == fcPROGRAM
         return({"cfg.pst.valores.html","text/html",.t.})
      elseif "check_fields.html" == fcPROGRAM
         return({"check_fields.html","text/html",.f.})
      elseif "close.reload.wic" == fcPROGRAM
         return({"close.reload.wic","text/html",.t.})
      elseif "close.wic" == fcPROGRAM
         return({"close.wic","text/html",.t.})
      elseif "conclusao_contrato.mnt.html" == fcPROGRAM
         return({"conclusao_contrato.mnt.html","text/html",.t.})
      elseif "contrato_situacao.mnt.html" == fcPROGRAM
         return({"contrato_situacao.mnt.html","text/html",.t.})
      elseif "conv_snt" == fcPROGRAM
         return({"conv_snt","text/html",.f.})
      elseif "daemon.defdb" == fcPROGRAM
         return({"daemon.defdb","text/html",.f.})
      elseif "daemon.wic" == fcPROGRAM
         return({"daemon.wic","text/plain",.f.})
      elseif "desp.aprovacao.html" == fcPROGRAM
         return({"desp.aprovacao.html","text/html",.t.})
      elseif "desp.cfg.etapas.html" == fcPROGRAM
         return({"desp.cfg.etapas.html","text/html",.t.})
      elseif "desp.revisao.html" == fcPROGRAM
         return({"desp.revisao.html","text/html",.t.})
      elseif "dynamicui" == fcPROGRAM
         return({"dynamicui","text/html",.t.})
      elseif "exito_riscoperda.mnt.html" == fcPROGRAM
         return({"exito_riscoperda.mnt.html","text/html",.t.})
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
      elseif "helponline" == fcPROGRAM
         return({"helponline","text/html",.t.})
      elseif "imovel_tipo.mnt.html" == fcPROGRAM
         return({"imovel_tipo.mnt.html","text/html",.t.})
      elseif "imp_dersaxrayes.html" == fcPROGRAM
         return({"imp_dersaxrayes.html","text/html",.f.})
      elseif "investimento_propriedade.mnt.html" == fcPROGRAM
         return({"investimento_propriedade.mnt.html","text/html",.t.})
      elseif "lic_certificado.mnt.html" == fcPROGRAM
         return({"lic_certificado.mnt.html","text/html",.t.})
      elseif "login.html" == fcPROGRAM
         return({"login.html","text/html",.t.})
      elseif "logout.wic" == fcPROGRAM
         return({"logout.wic","text/html",.t.})
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
      elseif "lst.pasta.html" == fcPROGRAM
         return({"lst.pasta.html","text/html",.t.})
      elseif "lst.plct.html" == fcPROGRAM
         return({"lst.plct.html","text/html",.t.})
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
      elseif "menu.cfg.gerais.html" == fcPROGRAM
         return({"menu.cfg.gerais.html","text/html",.t.})
      elseif "menu.pop.html" == fcPROGRAM
         return({"menu.pop.html","text/html",.t.})
      elseif "mkcips" == fcPROGRAM
         return({"mkcips","text/html",.f.})
      elseif "mnt.ac.grp_program.html" == fcPROGRAM
         return({"mnt.ac.grp_program.html","text/html",.t.})
      elseif "mnt.acgroup.html" == fcPROGRAM
         return({"mnt.acgroup.html","text/html",.t.})
      elseif "mnt.acprogram.html" == fcPROGRAM
         return({"mnt.acprogram.html","text/html",.t.})
      elseif "mnt.acuser.html" == fcPROGRAM
         return({"mnt.acuser.html","text/html",.t.})
      elseif "mnt.assunto.html" == fcPROGRAM
         return({"mnt.assunto.html","text/html",.t.})
      elseif "mnt.autoproc.html" == fcPROGRAM
         return({"mnt.autoproc.html","text/html",.t.})
      elseif "mnt.autoresultado.html" == fcPROGRAM
         return({"mnt.autoresultado.html","text/html",.t.})
      elseif "mnt.canc.andamento.html" == fcPROGRAM
         return({"mnt.canc.andamento.html","text/html",.t.})
      elseif "mnt.cargo.html" == fcPROGRAM
         return({"mnt.cargo.html","text/html",.t.})
      elseif "mnt.categoria.html" == fcPROGRAM
         return({"mnt.categoria.html","text/html",.t.})
      elseif "mnt.causaacao.html" == fcPROGRAM
         return({"mnt.causaacao.html","text/html",.t.})
      elseif "mnt.causanis.html" == fcPROGRAM
         return({"mnt.causanis.html","text/html",.t.})
      elseif "mnt.ccusto.html" == fcPROGRAM
         return({"mnt.ccusto.html","text/html",.t.})
      elseif "mnt.cfg.pasta.html" == fcPROGRAM
         return({"mnt.cfg.pasta.html","text/html",.t.})
      elseif "mnt.class_poder.html" == fcPROGRAM
         return({"mnt.class_poder.html","text/html",.t.})
      elseif "mnt.cli2.html" == fcPROGRAM
         return({"mnt.cli2.html","text/html",.t.})
      elseif "mnt.cob.cliente.html" == fcPROGRAM
         return({"mnt.cob.cliente.html","text/html",.t.})
      elseif "mnt.cob.pasta.html" == fcPROGRAM
         return({"mnt.cob.pasta.html","text/html",.t.})
      elseif "mnt.cobranca.html" == fcPROGRAM
         return({"mnt.cobranca.html","text/html",.t.})
      elseif "mnt.comarca.html" == fcPROGRAM
         return({"mnt.comarca.html","text/html",.t.})
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
      elseif "mnt.delegacia.html" == fcPROGRAM
         return({"mnt.delegacia.html","text/html",.t.})
      elseif "mnt.departamento.html" == fcPROGRAM
         return({"mnt.departamento.html","text/html",.t.})
      elseif "mnt.deposito.status.html" == fcPROGRAM
         return({"mnt.deposito.status.html","text/html",.t.})
      elseif "mnt.desp.corp.html" == fcPROGRAM
         return({"mnt.desp.corp.html","text/html",.t.})
      elseif "mnt.despesa.html" == fcPROGRAM
         return({"mnt.despesa.html","text/html",.t.})
      elseif "mnt.empresa_usuaria.html" == fcPROGRAM
         return({"mnt.empresa_usuaria.html","text/html",.t.})
      elseif "mnt.fase_processual.html" == fcPROGRAM
         return({"mnt.fase_processual.html","text/html",.t.})
      elseif "mnt.forma_pagamento.html" == fcPROGRAM
         return({"mnt.forma_pagamento.html","text/html",.t.})
      elseif "mnt.forum.html" == fcPROGRAM
         return({"mnt.forum.html","text/html",.t.})
      elseif "mnt.ftr.universal.html" == fcPROGRAM
         return({"mnt.ftr.universal.html","text/html",.t.})
      elseif "mnt.grupo_economico.html" == fcPROGRAM
         return({"mnt.grupo_economico.html","text/html",.t.})
      elseif "mnt.imposto.html" == fcPROGRAM
         return({"mnt.imposto.html","text/html",.t.})
      elseif "mnt.indice.reajuste.html" == fcPROGRAM
         return({"mnt.indice.reajuste.html","text/html",.t.})
      elseif "mnt.instancia.html" == fcPROGRAM
         return({"mnt.instancia.html","text/html",.t.})
      elseif "mnt.moeda.html" == fcPROGRAM
         return({"mnt.moeda.html","text/html",.t.})
      elseif "mnt.motivo_infracao.html" == fcPROGRAM
         return({"mnt.motivo_infracao.html","text/html",.t.})
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
      elseif "mnt.numero_parcela.html" == fcPROGRAM
         return({"mnt.numero_parcela.html","text/html",.t.})
      elseif "mnt.orgaos.html" == fcPROGRAM
         return({"mnt.orgaos.html","text/html",.t.})
      elseif "mnt.pasta.ambiental.html" == fcPROGRAM
         return({"mnt.pasta.ambiental.html","text/html",.t.})
      elseif "mnt.pasta.bacen.html" == fcPROGRAM
         return({"mnt.pasta.bacen.html","text/html",.t.})
      elseif "mnt.pasta.certidoes.html" == fcPROGRAM
         return({"mnt.pasta.certidoes.html","text/html",.t.})
      elseif "mnt.pasta.civel.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel.html" == fcPROGRAM
         return({"mnt.pasta.civel.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_administrativo.html" == fcPROGRAM
         return({"mnt.pasta.civel_administrativo.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_ans.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_ans.seguro.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade.html","text/html",.t.})
      elseif "mnt.pasta.civel_adm_cade.seguro.html" == fcPROGRAM
         return({"mnt.pasta.civel_adm_cade.seguro.html","text/html",.t.})
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
      elseif "mnt.pasta.civel_loja.execucao.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja.execucao.html","text/html",.t.})
      elseif "mnt.pasta.civel_loja.html" == fcPROGRAM
         return({"mnt.pasta.civel_loja.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_com_sinistro.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_com_sinistro.html","text/html",.t.})
      elseif "mnt.pasta.civel_securit_sem_sinistro.html" == fcPROGRAM
         return({"mnt.pasta.civel_securit_sem_sinistro.html","text/html",.t.})
      elseif "mnt.pasta.consignacao.html" == fcPROGRAM
         return({"mnt.pasta.consignacao.html","text/html",.t.})
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
      elseif "mnt.pasta.contrato_contra.html" == fcPROGRAM
         return({"mnt.pasta.contrato_contra.html","text/html",.t.})
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
      elseif "mnt.pasta.email.html" == fcPROGRAM
         return({"mnt.pasta.email.html","text/html",.t.})
      elseif "mnt.pasta.html" == fcPROGRAM
         return({"mnt.pasta.html","text/html",.t.})
      elseif "mnt.pasta.imobiliario.html" == fcPROGRAM
         return({"mnt.pasta.imobiliario.html","text/html",.t.})
      elseif "mnt.pasta.imprensa.html" == fcPROGRAM
         return({"mnt.pasta.imprensa.html","text/html",.t.})
      elseif "mnt.pasta.juizo_filial.html" == fcPROGRAM
         return({"mnt.pasta.juizo_filial.html","text/html",.t.})
      elseif "mnt.pasta.juridico_operacional.html" == fcPROGRAM
         return({"mnt.pasta.juridico_operacional.html","text/html",.t.})
      elseif "mnt.pasta.jurisprudencia.html" == fcPROGRAM
         return({"mnt.pasta.jurisprudencia.html","text/html",.t.})
      elseif "mnt.pasta.jurisprudencia_seguro.html" == fcPROGRAM
         return({"mnt.pasta.jurisprudencia_seguro.html","text/html",.t.})
      elseif "mnt.pasta.marcas.html" == fcPROGRAM
         return({"mnt.pasta.marcas.html","text/html",.t.})
      elseif "mnt.pasta.notificacao.html" == fcPROGRAM
         return({"mnt.pasta.notificacao.html","text/html",.t.})
      elseif "mnt.pasta.oficio.html" == fcPROGRAM
         return({"mnt.pasta.oficio.html","text/html",.t.})
      elseif "mnt.pasta.padrao.html" == fcPROGRAM
         return({"mnt.pasta.padrao.html","text/html",.t.})
      elseif "mnt.pasta.pasta_pfpj.html" == fcPROGRAM
         return({"mnt.pasta.pasta_pfpj.html","text/html",.t.})
      elseif "mnt.pasta.patentes.html" == fcPROGRAM
         return({"mnt.pasta.patentes.html","text/html",.t.})
      elseif "mnt.pasta.poderes.html" == fcPROGRAM
         return({"mnt.pasta.poderes.html","text/html",.t.})
      elseif "mnt.pasta.procon.html" == fcPROGRAM
         return({"mnt.pasta.procon.html","text/html",.t.})
      elseif "mnt.pasta.procuracao.html" == fcPROGRAM
         return({"mnt.pasta.procuracao.html","text/html",.t.})
      elseif "mnt.pasta.recativos.execucao.html" == fcPROGRAM
         return({"mnt.pasta.recativos.execucao.html","text/html",.t.})
      elseif "mnt.pasta.recativos.html" == fcPROGRAM
         return({"mnt.pasta.recativos.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel.html","text/html",.t.})
      elseif "mnt.pasta.seguro_civel.seguro.html" == fcPROGRAM
         return({"mnt.pasta.seguro_civel.seguro.html","text/html",.t.})
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
      elseif "mnt.pasta.termos_int_fiscal.html" == fcPROGRAM
         return({"mnt.pasta.termos_int_fiscal.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista.execucao.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista.execucao.html","text/html",.t.})
      elseif "mnt.pasta.trabalhista.html" == fcPROGRAM
         return({"mnt.pasta.trabalhista.html","text/html",.t.})
      elseif "mnt.pasta.tributario_administrativo.html" == fcPROGRAM
         return({"mnt.pasta.tributario_administrativo.html","text/html",.t.})
      elseif "mnt.pasta.tributario_administrativo2.html" == fcPROGRAM
         return({"mnt.pasta.tributario_administrativo2.html","text/html",.t.})
      elseif "mnt.pasta.tributario_adm_contra.html" == fcPROGRAM
         return({"mnt.pasta.tributario_adm_contra.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fiscais.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fiscais.html","text/html",.t.})
      elseif "mnt.pasta.tributario_exec_fisc_contra.html" == fcPROGRAM
         return({"mnt.pasta.tributario_exec_fisc_contra.html","text/html",.t.})
      elseif "mnt.pasta.tributario_judicial.html" == fcPROGRAM
         return({"mnt.pasta.tributario_judicial.html","text/html",.t.})
      elseif "mnt.pat.natureza.html" == fcPROGRAM
         return({"mnt.pat.natureza.html","text/html",.t.})
      elseif "mnt.pericia.html" == fcPROGRAM
         return({"mnt.pericia.html","text/html",.t.})
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
      elseif "mnt.pst.andamento.html" == fcPROGRAM
         return({"mnt.pst.andamento.html","text/html",.t.})
      elseif "mnt.pst.civel.html" == fcPROGRAM
         return({"mnt.pst.civel.html","text/html",.t.})
      elseif "mnt.pst.classifica.html" == fcPROGRAM
         return({"mnt.pst.classifica.html","text/html",.t.})
      elseif "mnt.pst.contingencia.html" == fcPROGRAM
         return({"mnt.pst.contingencia.html","text/html",.t.})
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
      elseif "mnt.ramosrsn.html" == fcPROGRAM
         return({"mnt.ramosrsn.html","text/html",.t.})
      elseif "mnt.resultado_processo.html" == fcPROGRAM
         return({"mnt.resultado_processo.html","text/html",.t.})
      elseif "mnt.res_pedido.html" == fcPROGRAM
         return({"mnt.res_pedido.html","text/html",.t.})
      elseif "mnt.sct.ato.html" == fcPROGRAM
         return({"mnt.sct.ato.html","text/html",.t.})
      elseif "mnt.sct.conselho.html" == fcPROGRAM
         return({"mnt.sct.conselho.html","text/html",.t.})
      elseif "mnt.segsituacaopagamento.html" == fcPROGRAM
         return({"mnt.segsituacaopagamento.html","text/html",.t.})
      elseif "mnt.serv.corp.html" == fcPROGRAM
         return({"mnt.serv.corp.html","text/html",.t.})
      elseif "mnt.servico.html" == fcPROGRAM
         return({"mnt.servico.html","text/html",.t.})
      elseif "mnt.sin.causa.html" == fcPROGRAM
         return({"mnt.sin.causa.html","text/html",.t.})
      elseif "mnt.st.apolice.html" == fcPROGRAM
         return({"mnt.st.apolice.html","text/html",.t.})
      elseif "mnt.st.sinistro.html" == fcPROGRAM
         return({"mnt.st.sinistro.html","text/html",.t.})
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
      elseif "mnt.tipogarantia.html" == fcPROGRAM
         return({"mnt.tipogarantia.html","text/html",.t.})
      elseif "mnt.tipomarca.html" == fcPROGRAM
         return({"mnt.tipomarca.html","text/html",.t.})
      elseif "mnt.tipoparticipacao.html" == fcPROGRAM
         return({"mnt.tipoparticipacao.html","text/html",.t.})
      elseif "mnt.tipo_ar.html" == fcPROGRAM
         return({"mnt.tipo_ar.html","text/html",.t.})
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
      elseif "mnt.workgroup.html" == fcPROGRAM
         return({"mnt.workgroup.html","text/html",.t.})
      elseif "motivo_irregularidade.mnt.html" == fcPROGRAM
         return({"motivo_irregularidade.mnt.html","text/html",.t.})
      elseif "orgao.julgador.mnt.html" == fcPROGRAM
         return({"orgao.julgador.mnt.html","text/html",.t.})
      elseif "origem.reclamacao.mnt.html" == fcPROGRAM
         return({"origem.reclamacao.mnt.html","text/html",.t.})
      elseif "pass.change.html" == fcPROGRAM
         return({"pass.change.html","text/html",.t.})
      elseif "pasta.abas.sbhtml" == fcPROGRAM
         return({"pasta.abas.sbhtml","text/html",.t.})
      elseif "pasta.pre.html" == fcPROGRAM
         return({"pasta.pre.html","text/html",.t.})
      elseif "penalidade_tipo.mnt.html" == fcPROGRAM
         return({"penalidade_tipo.mnt.html","text/html",.t.})
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
      elseif "ps.ata.deliberacao.html" == fcPROGRAM
         return({"ps.ata.deliberacao.html","text/html",.t.})
      elseif "ps.esc.despesa.html" == fcPROGRAM
         return({"ps.esc.despesa.html","text/html",.t.})
      elseif "ps.log.alteracao.html" == fcPROGRAM
         return({"ps.log.alteracao.html","text/html",.t.})
      elseif "ps.lst.assembleia.html" == fcPROGRAM
         return({"ps.lst.assembleia.html","text/html",.t.})
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
      elseif "psab.agenda.html" == fcPROGRAM
         return({"psab.agenda.html","text/html",.t.})
      elseif "psab.analise.causa.html" == fcPROGRAM
         return({"psab.analise.causa.html","text/html",.t.})
      elseif "psab.auto.html" == fcPROGRAM
         return({"psab.auto.html","text/html",.t.})
      elseif "psab.autoaprova.html" == fcPROGRAM
         return({"psab.autoaprova.html","text/html",.t.})
      elseif "psab.corporativo.html" == fcPROGRAM
         return({"psab.corporativo.html","text/html",.t.})
      elseif "psab.deposito.html" == fcPROGRAM
         return({"psab.deposito.html","text/html",.t.})
      elseif "psab.div.responsabilidade.html" == fcPROGRAM
         return({"psab.div.responsabilidade.html","text/html",.t.})
      elseif "psab.escritorio.html" == fcPROGRAM
         return({"psab.escritorio.html","text/html",.t.})
      elseif "psab.garantia.html" == fcPROGRAM
         return({"psab.garantia.html","text/html",.t.})
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
      elseif "psab.ra.contratos.html" == fcPROGRAM
         return({"psab.ra.contratos.html","text/html",.t.})
      elseif "psab.ra.ocorrencias.html" == fcPROGRAM
         return({"psab.ra.ocorrencias.html","text/html",.t.})
      elseif "psab.ra.recupera.html" == fcPROGRAM
         return({"psab.ra.recupera.html","text/html",.t.})
      elseif "psab.rateio.ccusto.html" == fcPROGRAM
         return({"psab.rateio.ccusto.html","text/html",.t.})
      elseif "psab.relacionamento.html" == fcPROGRAM
         return({"psab.relacionamento.html","text/html",.t.})
      elseif "psab.resultado.html" == fcPROGRAM
         return({"psab.resultado.html","text/html",.t.})
      elseif "psab.risco_atividade.html" == fcPROGRAM
         return({"psab.risco_atividade.html","text/html",.t.})
      elseif "psab.seg.sinistro.html" == fcPROGRAM
         return({"psab.seg.sinistro.html","text/html",.t.})
      elseif "psab.seguro.html" == fcPROGRAM
         return({"psab.seguro.html","text/html",.t.})
      elseif "psab.sindicancia.html" == fcPROGRAM
         return({"psab.sindicancia.html","text/html",.t.})
      elseif "psab.valores.html" == fcPROGRAM
         return({"psab.valores.html","text/html",.t.})
      elseif "pst.aditivo.contrato.html" == fcPROGRAM
         return({"pst.aditivo.contrato.html","text/html",.t.})
      elseif "pst.anexo.contrato.html" == fcPROGRAM
         return({"pst.anexo.contrato.html","text/html",.t.})
      elseif "pst.cabecalho.sbhtml" == fcPROGRAM
         return({"pst.cabecalho.sbhtml","text/html",.t.})
      elseif "pst.descr.poderes.html" == fcPROGRAM
         return({"pst.descr.poderes.html","text/html",.t.})
      elseif "pst.desc_reclama.html" == fcPROGRAM
         return({"pst.desc_reclama.html","text/html",.t.})
      elseif "pst.execucao.html" == fcPROGRAM
         return({"pst.execucao.html","text/html",.t.})
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
      elseif "query.ajx" == fcPROGRAM
         return({"query.ajx","text/html",.f.})
      elseif "rb3" == fcPROGRAM
         return({"rb3","text/html",.t.})
      elseif "redirect.wic" == fcPROGRAM
         return({"redirect.wic","text/html",.t.})
      elseif "remessa_tipo.mnt.html" == fcPROGRAM
         return({"remessa_tipo.mnt.html","text/html",.t.})
      elseif "resp_dano.mnt.html" == fcPROGRAM
         return({"resp_dano.mnt.html","text/html",.t.})
      elseif "restructgr5" == fcPROGRAM
         return({"restructgr5","text/html",.t.})
      elseif "sch.ac.group.html" == fcPROGRAM
         return({"sch.ac.group.html","text/html",.t.})
      elseif "sch.all.fields.html" == fcPROGRAM
         return({"sch.all.fields.html","text/html",.t.})
      elseif "sch.all.objeto.html" == fcPROGRAM
         return({"sch.all.objeto.html","text/html",.t.})
      elseif "sch.all.pasta.html" == fcPROGRAM
         return({"sch.all.pasta.html","text/html",.t.})
      elseif "sch.cargo.html" == fcPROGRAM
         return({"sch.cargo.html","text/html",.t.})
      elseif "sch.causanis.html" == fcPROGRAM
         return({"sch.causanis.html","text/html",.t.})
      elseif "sch.ccusto.html" == fcPROGRAM
         return({"sch.ccusto.html","text/html",.t.})
      elseif "sch.cobranca.html" == fcPROGRAM
         return({"sch.cobranca.html","text/html",.t.})
      elseif "sch.comarca_regiao.html" == fcPROGRAM
         return({"sch.comarca_regiao.html","text/html",.t.})
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
      elseif "sch.depto.resp.html" == fcPROGRAM
         return({"sch.depto.resp.html","text/html",.t.})
      elseif "sch.despesa.html" == fcPROGRAM
         return({"sch.despesa.html","text/html",.t.})
      elseif "sch.exito_riscoperda.html" == fcPROGRAM
         return({"sch.exito_riscoperda.html","text/html",.t.})
      elseif "sch.field.html" == fcPROGRAM
         return({"sch.field.html","text/html",.t.})
      elseif "sch.fields.pscalc.html" == fcPROGRAM
         return({"sch.fields.pscalc.html","text/html",.t.})
      elseif "sch.groups.html" == fcPROGRAM
         return({"sch.groups.html","text/html",.t.})
      elseif "sch.grupo_economico.html" == fcPROGRAM
         return({"sch.grupo_economico.html","text/html",.t.})
      elseif "sch.indice.reajuste.html" == fcPROGRAM
         return({"sch.indice.reajuste.html","text/html",.t.})
      elseif "sch.lg_resp.html" == fcPROGRAM
         return({"sch.lg_resp.html","text/html",.t.})
      elseif "sch.login.html" == fcPROGRAM
         return({"sch.login.html","text/html",.t.})
      elseif "sch.moeda.html" == fcPROGRAM
         return({"sch.moeda.html","text/html",.t.})
      elseif "sch.pasta.html" == fcPROGRAM
         return({"sch.pasta.html","text/html",.t.})
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
      elseif "sch.prc.poder.html" == fcPROGRAM
         return({"sch.prc.poder.html","text/html",.t.})
      elseif "sch.pst.contrato.html" == fcPROGRAM
         return({"sch.pst.contrato.html","text/html",.t.})
      elseif "sch.pst.origem.html" == fcPROGRAM
         return({"sch.pst.origem.html","text/html",.t.})
      elseif "sch.ramosrsn.html" == fcPROGRAM
         return({"sch.ramosrsn.html","text/html",.t.})
      elseif "sch.sct.atas.html" == fcPROGRAM
         return({"sch.sct.atas.html","text/html",.t.})
      elseif "sch.servico.html" == fcPROGRAM
         return({"sch.servico.html","text/html",.t.})
      elseif "sch.sin.causa.html" == fcPROGRAM
         return({"sch.sin.causa.html","text/html",.t.})
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
      elseif "sch.tributos.html" == fcPROGRAM
         return({"sch.tributos.html","text/html",.t.})
      elseif "sch.ts.pt.pasta.html" == fcPROGRAM
         return({"sch.ts.pt.pasta.html","text/html",.t.})
      elseif "sch.users.html" == fcPROGRAM
         return({"sch.users.html","text/html",.t.})
      elseif "sch.wprgroup.html" == fcPROGRAM
         return({"sch.wprgroup.html","text/html",.t.})
      elseif "sch.wprogram.html" == fcPROGRAM
         return({"sch.wprogram.html","text/html",.t.})
      elseif "seguro_responsabilidade.mnt.html" == fcPROGRAM
         return({"seguro_responsabilidade.mnt.html","text/html",.t.})
      elseif "sendemail.wic" == fcPROGRAM
         return({"sendemail.wic","text/html",.t.})
      elseif "sendsms.wic" == fcPROGRAM
         return({"sendsms.wic","text/html",.t.})
      elseif "sysopcarga" == fcPROGRAM
         return({"sysopcarga","text/html",.f.})
      elseif "task.category.html" == fcPROGRAM
         return({"task.category.html","text/html",.t.})
      elseif "task.group.html" == fcPROGRAM
         return({"task.group.html","text/html",.t.})
      elseif "task.status.html" == fcPROGRAM
         return({"task.status.html","text/html",.t.})
      elseif "tipocapital.mnt.html" == fcPROGRAM
         return({"tipocapital.mnt.html","text/html",.t.})
      elseif "tipoconta.mnt.html" == fcPROGRAM
         return({"tipoconta.mnt.html","text/html",.t.})
      elseif "tipoempresa.mnt.html" == fcPROGRAM
         return({"tipoempresa.mnt.html","text/html",.t.})
      elseif "tooltip.js.sbhtml" == fcPROGRAM
         return({"tooltip.js.sbhtml","text/html",.t.})
      elseif "transf.responsabilidade.bat.html" == fcPROGRAM
         return({"transf.responsabilidade.bat.html","text/html",.t.})
      elseif "uas_fnet" == fcPROGRAM
         return({"uas_fnet","text/html",.f.})
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
      elseif "xexecsql" == fcPROGRAM
         return({"xexecsql","text/html",.t.})
      elseif "xrb2" == fcPROGRAM
         return({"xrb2","text/html",.t.})
      elseif "xrb3" == fcPROGRAM
         return({"xrb3","text/html",.t.})
      else
         error_sys("Program not defined: "+transform(fcPROGRAM))
      endif
   return({})

/* programs only templates */

