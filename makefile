#
# Compila e gera o binario gr5 e gr5tasks
# - no Linux/Unix rodar : make  [compile|clean]
# - no MS-Windows/MS-VC6: nmake [compile|clean]
# Para abortar a execução pressiona Ctrl+C
#

EXEFILES= \
	gr5$(EXE) \
  gr5tasks$(EXE)         

FSDEBUG =
# FSDEBUG = -d -g

FS 	 = FlagShip
FS_STD = $(FS) -c -m 
FS_NA  = $(FS) -c -nc -nd -na -q -I "c:\wictrixglauber\libextra" -I "c:\wictrixglauber\lib\include" 
FS_LIB = LIB 
FS_LINK = link
FS_LINK_OPT = /opt:NOREF /incremental:yes /subsystem:CONSOLE  /NODEFAULTLIB:libcd.lib
FS_LIB_PATH = -libpath:"c:/program files/microsoft sdk/lib" -libpath:"c:/program files/microsoft visual studio/vc98/lib" -libpath:"c:/program files/microsoft visual studio/vc98/mfc/lib" -libpath:"c:/program files/flagship/lib"
DIRWICTRIX =
LIBFILES = d:/wictrixglauber/libwictrix.lib d:/wictrixglauber/libwicplugins.lib d:/wictrixglauber/lib/MailNovo/libwictools.lib d:/wictrixglauber/libextra/libblowfish.lib d:/wictrixglauber/libextra/CppLayer.lib d:/wictrixglauber/libwdi.lib FlagShip6.lib oldnames.lib libc.lib libcp.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib imm32.lib winmm.lib winspool.lib wsock32.lib odbc32.lib odbccp32.lib comsupp.lib

# --- MS-Windows (MS-VC6 or BCC32) part
.SUFFIXES: .obj .prg
EXE	= .exe
LIB = .lib
OBJ	= obj
RM 	= del
DIR	= dir
TERM  = 
CURDIR =
WAIT	=
# for Unix/Linux, enable:
# EXE 	= 
# OBJ 	= o
# RM  	= rm
# DIR 	= ls -l
# TERM  = newfswin
# CURDIR = ./
# WAIT	= echo -e "Press any key to continue ... \c" ; read
# ADD	= "via newfswin"

#-- [n]make w/o arguments
all: $(EXEFILES)
               
#-- [n]make compile
compile: $(EXEFILES)
 
gr5$(EXE) : gr5.prg 
	echo --- criando gr5$(EXE)
	$(RM) $(EXEFILES)	
  cd compile  
  $(FS) -c  aba_administracao_pfpj_html.prg
  $(FS) -c  aba_contas_pfpj_html.prg
  $(FS) -c  aba_contato_pfpj_html.prg
  $(FS) -c  aba_socios_pfpj_html.prg
  $(FS) -c  abat_autorizado_mnt_html.prg
  $(FS) -c  abat_fixo_mnt_html.prg
  $(FS) -c  ac_field_redef_html.prg
  $(FS) -c  acordo_mnt_html.prg
#    $(FS) -c  acsel_import.prg
#   $(FS) -c  acsel_tokio_html.prg
  $(FS) -c  aditivo_tipo_mnt_html.prg
  $(FS) -c  afastamento_mnt_html.prg
  $(FS) -c  ajuste_monetario_html.prg
  $(FS) -c  alcada_aprovacao_html.prg
  $(FS) -c  alt_capacidadeescritorio_html.prg
  $(FS) -c  ambito_mnt_html.prg
  $(FS) -c  andamento_par_mnt_html.prg
  $(FS) -c  apresentacao_mnt_html.prg
  $(FS) -c  ar_solicitada_mnt_html.prg
  $(FS) -c  area_mnt_html.prg
  $(FS) -c  area_solicitante_mnt_html.prg
  $(FS) -c  assedio_mnt_html.prg
  $(FS) -c  ato_registrado_mnt_html.prg
#   $(FS) -c  atualiza_full_sinistro_isj_html.prg
#   $(FS) -c  atualiza_sinistro_isj_html.prg
  $(FS) -c  autosch_wic.prg
  $(FS) -c  banco_mnt_html.prg
  $(FS) -c  bat_markup_html.prg
  $(FS) -c  bloqueio_tipo_mnt_html.prg
  $(FS) -c  boleto_aprovacao_html.prg
  $(FS) -c  build_program.prg
  $(FS) -c  canais_relacionamento_mnt_html.prg
  $(FS) -c  canal_mnt_html.prg
  $(FS) -c  canal_produto_mnt_html.prg
  $(FS) -c  canal_venda_mnt_html.prg
  $(FS) -c  carregaindicesvpar_html.prg
  $(FS) -c  causa_mnt_html.prg
  $(FS) -c  ccwsdiario.prg
  $(FS) -c  cfg_pst_juros_html.prg
  $(FS) -c  cfg_pst_valores_html.prg
  $(FS) -c  check_fields_html.prg
  $(FS) -c  cidade_mnt_html.prg
  $(FS) -c  clas_contabil_mnt_html.prg
  $(FS) -c  clas_doenca_mnt_html.prg
  $(FS) -c  classificacao_pessoas_mnt_html.prg
  $(FS) -c  complexidade_mnt_html.prg
  $(FS) -c  conclusao_contrato_mnt_html.prg
  $(FS) -c  confidenc_abrangencia_mnt_html.prg
  $(FS) -c  config_ressarcimento_mnt_html.prg
  $(FS) -c  conhecimento_mnt_html.prg
  $(FS) -c  consequencia_mnt_html.prg
  $(FS) -c  cont_renovacao_mnt_html.prg
  $(FS) -c  cont2valor.prg
  $(FS) -c  contrato_situacao_mnt_html.prg
  $(FS) -c  contribuiu_mnt_html.prg
  $(FS) -c  conv_snt.prg
  $(FS) -c  convencao_mnt_html.prg
  $(FS) -c  corrige_andamentos_html.prg
  $(FS) -c  cosesp_sios1503_html.prg
  $(FS) -c  cosesp1504_html.prg
  $(FS) -c  credito_cfg_etapas_html.prg
  $(FS) -c  custo_mnt_html.prg
  $(FS) -c  daemon_defdb.prg
  $(FS) -c  daemon_wic.prg
  $(FS) -c  deleta_pedidos_mnt_html.prg
  $(FS) -c  deliberacao_mnt_html.prg
  $(FS) -c  desenvoltura_mnt_html.prg
  $(FS) -c  desligamento_mnt_html.prg
  $(FS) -c  desp_aprovacao_html.prg
  $(FS) -c  desp_cfg_etapas_html.prg
  $(FS) -c  desp_imp_revisao_html.prg
  $(FS) -c  desp_rej_aprovacao_html.prg
  $(FS) -c  desp_rej_imp_revisao_html.prg
  $(FS) -c  desp_rej_revisao_html.prg
  $(FS) -c  desp_revisao_html.prg
#   $(FS) -c  detalhes_sinistro_html.prg
  $(FS) -c  diretoria_resp_mnt_html.prg
  $(FS) -c  doc_assunto_mnt_html.prg
  $(FS) -c  doc_contratos_mnt_html.prg
  $(FS) -c  doc_mnt_html.prg
  $(FS) -c  doc_necessario_mnt_html.prg
  $(FS) -c  doc_rh_mnt_html.prg
#   $(FS) -c  docrtf_mnt_html.prg
  $(FS) -c  documento_tipo_mnt_html.prg
  $(FS) -c  doenca_mnt_html.prg
#   $(FS) -c  e_finance_html.prg
  $(FS) -c  edificacao_mnt_html.prg
#   $(FS) -c  efinance_import_html.prg
  $(FS) -c  envio_mnt_html.prg
  $(FS) -c  escalonamento_honorarios_mnt_html.prg
  $(FS) -c  escritorio_mnt_html.prg
  $(FS) -c  exclusiv_abrangencia_mnt_html.prg
  $(FS) -c  exito_riscoperda_mnt_html.prg
  $(FS) -c  familia_mnt_html.prg
  $(FS) -c  fat_emite_html.prg
  $(FS) -c  fat_gera_html.prg
  $(FS) -c  fat_honorario_revisa_html.prg
  $(FS) -c  fat_lst_revisa_html.prg
  $(FS) -c  fat_revisa_html.prg
  $(FS) -c  fat_servico_revisa_html.prg
  $(FS) -c  forma_contato_mnt_html.prg
  $(FS) -c  forma_realizacao_mnt_html.prg
  $(FS) -c  fr_cfg_gerais_html.prg
  $(FS) -c  func_calculo_wic.prg
  $(FS) -c  func_wic.prg
  $(FS) -c  funcgroupware_wic.prg
  $(FS) -c  gasto_mnt_html.prg
#   $(FS) -c  gem_export_html.prg
#   $(FS) -c  gem_import.prg
#   $(FS) -c  gem_isj_cont_provisoes_html.prg
#   $(FS) -c  gem_isj_despesas_html.prg
#   $(FS) -c  gem_isj_indenizacoes_html.prg
#   $(FS) -c  gem_tokio_html.prg
  $(FS) -c  gera_honorarios_html.prg
  $(FS) -c  gerar_saldos_mnt_html.prg
  $(FS) -c  grau_parentesco_mnt_html.prg
  $(FS) -c  grpman_lst_html.prg
  $(FS) -c  grpman_mnt_html.prg
  $(FS) -c  grupo_despesa_mnt_html.prg
  $(FS) -c  helponline.prg
  $(FS) -c  imovel_tipo_mnt_html.prg
  $(FS) -c  imp_andamentos_html.prg
  $(FS) -c  imp_dersaxrayes_html.prg
  $(FS) -c  imp_pend_andamentos_html.prg
  $(FS) -c  incorporacao_mnt_html.prg
  $(FS) -c  indices_web_mnt_html.prg
  $(FS) -c  inter_andamentos_mnt_html.prg
  $(FS) -c  investimento_propriedade_mnt_html.prg
  $(FS) -c  jsongridcomp_html.prg
  $(FS) -c  lic_certificado_mnt_html.prg
  $(FS) -c  lmi_cobertura_mnt_html.prg
  $(FS) -c  local_mnt_html.prg
  $(FS) -c  login_html.prg
  $(FS) -c  logout_wic.prg
  $(FS) -c  loja_lst_html.prg
  $(FS) -c  loja_mnt_html.prg
  $(FS) -c  lojap_lst_html.prg
  $(FS) -c  lojap_mnt_html.prg
  $(FS) -c  loteamento_mnt_html.prg
  $(FS) -c  lst_acgroup_html.prg
  $(FS) -c  lst_acuser_html.prg
  $(FS) -c  lst_can_a.prg
  $(FS) -c  lst_canc_andamento_html.prg
  $(FS) -c  lst_cfg_pasta_html.prg
  $(FS) -c  lst_cob_cliente_html.prg
  $(FS) -c  lst_cob_pasta_html.prg
  $(FS) -c  lst_desp_corp_html.prg
  $(FS) -c  lst_ext_andamento_html.prg
  $(FS) -c  lst_fase_processual_html.prg
  $(FS) -c  lst_faturamento_html.prg
  $(FS) -c  lst_mvt_despesa_html.prg
  $(FS) -c  lst_mvt_indice_html.prg
  $(FS) -c  lst_mvt_moeda_html.prg
  $(FS) -c  lst_mvt_servico_html.prg
  $(FS) -c  lst_ouvidoria_html.prg
  $(FS) -c  lst_pasta_html.prg
  $(FS) -c  lst_plct_html.prg
  $(FS) -c  lst_provisao_html.prg
  $(FS) -c  lst_pst_andamento_html.prg
  $(FS) -c  lst_resultado_processo_html.prg
  $(FS) -c  lst_serv_corp_html.prg
  $(FS) -c  lst_tb_despesa_html.prg
  $(FS) -c  lst_tb_honorario_html.prg
  $(FS) -c  lst_tb_servico_html.prg
  $(FS) -c  lst_timesheet_html.prg
  $(FS) -c  lst_tp_contrato_html.prg
  $(FS) -c  lst_trct_html.prg
  $(FS) -c  lst_ts_cp_preventivo_html.prg
  $(FS) -c  lst_ts_ct_revisao_html.prg
  $(FS) -c  lst_ts_pr_revisao_html.prg
  $(FS) -c  lst_tsht_preventivo_html.prg
  $(FS) -c  lst_usuario_html.prg
  $(FS) -c  main_aftdb.prg
  $(FS) -c  main_aftmain.prg
  $(FS) -c  main_befdb.prg
  $(FS) -c  make_lst_html.prg
  $(FS) -c  melhoria_tipo_mnt_html.prg
  $(FS) -c  menu_cfg_gerais_html.prg
  $(FS) -c  menu_pendencias_html.prg
  $(FS) -c  menu_pop_html.prg
  $(FS) -c  mkcips.prg
  $(FS) -c  mkgrpdesp_wh.prg
  $(FS) -c  mnt_1codaux_html.prg
  $(FS) -c  mnt_2codaux_html.prg
  $(FS) -c  mnt_3codaux_html.prg
  $(FS) -c  mnt_ac_grp_program_html.prg
  $(FS) -c  mnt_acgroup_html.prg
  $(FS) -c  mnt_acprogram_html.prg
  $(FS) -c  mnt_acuser_html.prg
  $(FS) -c  mnt_alocadas_html.prg
  $(FS) -c  mnt_andamentos_pendentes_html.prg
  $(FS) -c  mnt_andpossiveis_html.prg
  $(FS) -c  mnt_anexo_html.prg
  $(FS) -c  mnt_aprova_con_html.prg
  $(FS) -c  mnt_aprova_fast_html.prg
  $(FS) -c  mnt_aprova_wf_html.prg
  $(FS) -c  mnt_aprovdiretor_html.prg
  $(FS) -c  mnt_assunto_html.prg
  $(FS) -c  mnt_atividades_html.prg
  $(FS) -c  mnt_atuacao_poder_html.prg
  $(FS) -c  mnt_autoproc_html.prg
  $(FS) -c  mnt_autoresultado_html.prg
  $(FS) -c  mnt_aux_filtro_andam_html.prg
  $(FS) -c  mnt_avaliacao_html.prg
  $(FS) -c  mnt_boleto_html.prg
  $(FS) -c  mnt_budget_html.prg
  $(FS) -c  mnt_canal2_html.prg
  $(FS) -c  mnt_canc_andamento_html.prg
  $(FS) -c  mnt_capacidadeescritorio_html.prg
  $(FS) -c  mnt_cargo_html.prg
  $(FS) -c  mnt_categoria_html.prg
  $(FS) -c  mnt_causaacao_html.prg
  $(FS) -c  mnt_causanis_html.prg
  $(FS) -c  mnt_causaraiz_html.prg
  $(FS) -c  mnt_ccusto_html.prg
  $(FS) -c  mnt_cf_and_retorno_html.prg
  $(FS) -c  mnt_cf_docs_envio_html.prg
  $(FS) -c  mnt_cf_envio_and_html.prg
  $(FS) -c  mnt_cf_siscod_html.prg
  $(FS) -c  mnt_cfg_aprov_html.prg
  $(FS) -c  mnt_cfg_pasta_html.prg
  $(FS) -c  mnt_class_poder_html.prg
  $(FS) -c  mnt_cli2_html.prg
  $(FS) -c  mnt_cob_cliente_html.prg
  $(FS) -c  mnt_cob_pasta_html.prg
#   $(FS) -c  mnt_coberturas_ramos_html.prg
  $(FS) -c  mnt_cobranca_html.prg
  $(FS) -c  mnt_comarca_html.prg
  $(FS) -c  mnt_combinacao_poder_html.prg
  $(FS) -c  mnt_concluitc_html.prg
  $(FS) -c  mnt_confidenc_para_html.prg
  $(FS) -c  mnt_config_html.prg
  $(FS) -c  mnt_cossegtipo_html.prg
  $(FS) -c  mnt_ctr_reajuste_period_html.prg
  $(FS) -c  mnt_ctr_tipo_html.prg
  $(FS) -c  mnt_ctr_valor_period_html.prg
  $(FS) -c  mnt_ctrdo_html.prg
  $(FS) -c  mnt_ctrte_html.prg
  $(FS) -c  mnt_cumprimento_html.prg
  $(FS) -c  mnt_decisao_html.prg
  $(FS) -c  mnt_delegacia_html.prg
  $(FS) -c  mnt_deliberacao_html.prg
  $(FS) -c  mnt_departamento_html.prg
  $(FS) -c  mnt_deposito_status_html.prg
  $(FS) -c  mnt_desp_corp_html.prg
  $(FS) -c  mnt_despesa_html.prg
  $(FS) -c  mnt_det_reclamacao_html.prg
  $(FS) -c  mnt_detal_pedido_html.prg
  $(FS) -c  mnt_diario_indice_html.prg
  $(FS) -c  mnt_diretoria_html.prg
  $(FS) -c  mnt_emissao_acoes_html.prg
  $(FS) -c  mnt_empresa_usuaria_html.prg
  $(FS) -c  mnt_endosso_html.prg
  $(FS) -c  mnt_estipulacao_html.prg
  $(FS) -c  mnt_excl_desp_html.prg
#   $(FS) -c  mnt_excl_gem_html.prg
#   $(FS) -c  mnt_excl_plataforma_html.prg
  $(FS) -c  mnt_ext_andamento_html.prg
  $(FS) -c  mnt_fase_processual_html.prg
  $(FS) -c  mnt_filtro_aux_desp_html.prg
  $(FS) -c  mnt_fnp_html.prg
  $(FS) -c  mnt_forma_pagamento_html.prg
  $(FS) -c  mnt_forum_html.prg
  $(FS) -c  mnt_ftr_replace_html.prg
  $(FS) -c  mnt_ftr_universal_html.prg
  $(FS) -c  mnt_gasto_html.prg
  $(FS) -c  mnt_groupanda_html.prg
  $(FS) -c  mnt_grupo_economico_html.prg
  $(FS) -c  mnt_imposto_html.prg
  $(FS) -c  mnt_indice_reajuste_html.prg
  $(FS) -c  mnt_instancia_html.prg
  $(FS) -c  mnt_interfaces_pendentes_html.prg
  $(FS) -c  mnt_juridico_html.prg
  $(FS) -c  mnt_label_html.prg
  $(FS) -c  mnt_margem_html.prg
  $(FS) -c  mnt_moeda_html.prg
  $(FS) -c  mnt_motivo_infracao_html.prg
  $(FS) -c  mnt_mov_ped_html.prg
  $(FS) -c  mnt_movsaldoscontratos_html.prg
  $(FS) -c  mnt_mvt_despesa_html.prg
  $(FS) -c  mnt_mvt_indice_html.prg
  $(FS) -c  mnt_mvt_juros_html.prg
  $(FS) -c  mnt_mvt_moeda_html.prg
  $(FS) -c  mnt_mvt_servico_html.prg
  $(FS) -c  mnt_natureza_operacao_html.prg
  $(FS) -c  mnt_nf_tp_servico_html.prg
  $(FS) -c  mnt_numero_parcela_html.prg
  $(FS) -c  mnt_ocorrencia_pedido_html.prg
  $(FS) -c  mnt_orgaos_html.prg
  $(FS) -c  mnt_pagnet_ocorrencias_html.prg
  $(FS) -c  mnt_parceiros_html.prg
  $(FS) -c  mnt_pasta_html.prg
  $(FS) -c  mnt_pat_natureza_html.prg
  $(FS) -c  mnt_pend_sinistros_html.prg
  $(FS) -c  mnt_perfilcampos_html.prg
  $(FS) -c  mnt_pericia_html.prg
  $(FS) -c  mnt_plataforma_html.prg
  $(FS) -c  mnt_plct_html.prg
  $(FS) -c  mnt_pos_parte_html.prg
  $(FS) -c  mnt_prc_clausula_html.prg
  $(FS) -c  mnt_prc_poder_html.prg
  $(FS) -c  mnt_prioridade_html.prg
  $(FS) -c  mnt_procedimento_html.prg
  $(FS) -c  mnt_provisao_html.prg
  $(FS) -c  mnt_pst_1andamento_html.prg
  $(FS) -c  mnt_pst_andamento_html.prg
  $(FS) -c  mnt_pst_classifica_html.prg
  $(FS) -c  mnt_pst_contingencia_html.prg
#   $(FS) -c  mnt_pst_docrtf_html.prg
  $(FS) -c  mnt_pst_natureza_html.prg
  $(FS) -c  mnt_pst_objeto_html.prg
  $(FS) -c  mnt_pst_partes_html.prg
  $(FS) -c  mnt_pst_status_html.prg
  $(FS) -c  mnt_pst_vendor_html.prg
  $(FS) -c  mnt_ramosrsn_html.prg
  $(FS) -c  mnt_receb_html.prg
  $(FS) -c  mnt_reclamacao_html.prg
  $(FS) -c  mnt_registro_html.prg
  $(FS) -c  mnt_res_pedido_html.prg
  $(FS) -c  mnt_ressarcimento_html.prg
  $(FS) -c  mnt_resultado_processo_html.prg
  $(FS) -c  mnt_resumomargem_html.prg
#   $(FS) -c  mnt_retorno_efinance_html.prg
  $(FS) -c  mnt_risco_html.prg
  $(FS) -c  mnt_saldoscontratos_html.prg
  $(FS) -c  mnt_sct_ato_html.prg
  $(FS) -c  mnt_sct_conselho_html.prg
  $(FS) -c  mnt_segsituacaopagamento_html.prg
  $(FS) -c  mnt_seq_interfaces_html.prg
  $(FS) -c  mnt_serv_corp_html.prg
  $(FS) -c  mnt_servico_html.prg
  $(FS) -c  mnt_sin_causa_html.prg
  $(FS) -c  mnt_sinistro_web_html.prg
  $(FS) -c  mnt_sla_html.prg
  $(FS) -c  mnt_st_apolice_html.prg
  $(FS) -c  mnt_st_lote_html.prg
  $(FS) -c  mnt_st_sinistro_html.prg
  $(FS) -c  mnt_status_batch_html.prg
  $(FS) -c  mnt_tb_despesa_html.prg
  $(FS) -c  mnt_tb_honorario_html.prg
  $(FS) -c  mnt_tb_servico_html.prg
  $(FS) -c  mnt_tipo_ar_html.prg
  $(FS) -c  mnt_tipo_credito_html.prg
  $(FS) -c  mnt_tipo_deposito_html.prg
  $(FS) -c  mnt_tipo_poder_html.prg
  $(FS) -c  mnt_tipo_vara_html.prg
  $(FS) -c  mnt_tipoacao_html.prg
  $(FS) -c  mnt_tipogarantia_html.prg
  $(FS) -c  mnt_tipomarca_html.prg
  $(FS) -c  mnt_tipomovsaldoscontratos_html.prg
  $(FS) -c  mnt_tipoparticipacao_html.prg
  $(FS) -c  mnt_tmovdep_html.prg
  $(FS) -c  mnt_tp_andamento_html.prg
  $(FS) -c  mnt_tp_apolice_html.prg
  $(FS) -c  mnt_tp_baixa_html.prg
  $(FS) -c  mnt_tp_contrato_html.prg
  $(FS) -c  mnt_tp_garantia_deposito_html.prg
  $(FS) -c  mnt_transacao_contabil_html.prg
  $(FS) -c  mnt_transcrito_livro_html.prg
  $(FS) -c  mnt_trct_html.prg
  $(FS) -c  mnt_tribunal_html.prg
  $(FS) -c  mnt_tributo_html.prg
  $(FS) -c  mnt_ts_cp_preventivo_html.prg
  $(FS) -c  mnt_ts_ct_revisao_html.prg
  $(FS) -c  mnt_ts_pr_revisao_html.prg
  $(FS) -c  mnt_tsht_preventivo_html.prg
  $(FS) -c  mnt_uf_html.prg
  $(FS) -c  mnt_vendor_html.prg
  $(FS) -c  mnt_vicioinsanavel_html.prg
  $(FS) -c  mnt_vigencia_html.prg
  $(FS) -c  mnt_wf_aprova_html.prg
  $(FS) -c  mnt_workgroup_html.prg
  $(FS) -c  mnt_wprofile_html.prg
  $(FS) -c  mnt_xdepartarea_html.prg
  $(FS) -c  mnt_xstatus_proposta_html.prg
  $(FS) -c  motivo_encerramento_mnt_html.prg
  $(FS) -c  motivo_irregularidade_mnt_html.prg
#   $(FS) -c  motivo_operacao_mnt_html.prg
  $(FS) -c  motivo_vendor_mnt_html.prg
#   $(FS) -c  new_ressarc.prg
  $(FS) -c  ocorrencia_tipo_mnt_html.prg
  $(FS) -c  orgao_autarquia_mnt_html.prg
  $(FS) -c  orgao_julgador_mnt_html.prg
  $(FS) -c  orientacao_mnt_html.prg
  $(FS) -c  origem_reclamacao_mnt_html.prg
  $(FS) -c  pagamento_tipo_mnt_html.prg
  $(FS) -c  pagnet_alfa_html.prg
  $(FS) -c  pagnet_export_html.prg
  $(FS) -c  pagsias_import_html.prg
  $(FS) -c  parecer_mnt_html.prg
  $(FS) -c  pass_change_html.prg
  $(FS) -c  pasta_pre_html.prg
  $(FS) -c  pastadetal.prg
  $(FS) -c  pastaencerra.prg
  $(FS) -c  penalidade_tipo_mnt_html.prg
  $(FS) -c  pfpj_atividade_html.prg
  $(FS) -c  pfpj_cargo_html.prg
  $(FS) -c  pfpj_cf_tipo_campo_html.prg
  $(FS) -c  pfpj_char.prg
  $(FS) -c  pfpj_log_alteracao_html.prg
  $(FS) -c  pfpj_lst_html.prg
  $(FS) -c  pfpj_mnt_html.prg
  $(FS) -c  pfpj_pre_html.prg
  $(FS) -c  pfpj_table_field_html.prg
  $(FS) -c  pfpj_tipo_html.prg
  $(FS) -c  pict_mark_html.prg
  $(FS) -c  plano_conta_mnt_html.prg
#   $(FS) -c  plataforma_import.prg
  $(FS) -c  pontualidade_mnt_html.prg
  $(FS) -c  pop_agenda_html.prg
  $(FS) -c  pop_ts_pr_revisao_html.prg
  $(FS) -c  portal_html.prg
  $(FS) -c  portalteste.prg
  $(FS) -c  posicao_imovel_mnt_html.prg
  $(FS) -c  probabilidade_tipo_mnt_html.prg
  $(FS) -c  produto_mnt_html.prg
  $(FS) -c  ps_ata_deliberacao_html.prg
  $(FS) -c  ps_ata2_deliberacao_html.prg
  $(FS) -c  ps_cap_alteracao_html.prg
  $(FS) -c  ps_esc_despesa_html.prg
  $(FS) -c  ps_log_alteracao_html.prg
  $(FS) -c  ps_lst_2assembleia_html.prg
  $(FS) -c  ps_lst_4assembleia_html.prg
  $(FS) -c  ps_lst_assembleia_html.prg
  $(FS) -c  ps_mnt_2assembleia_html.prg
  $(FS) -c  ps_mnt_4assembleia_html.prg
  $(FS) -c  ps_mnt_assembleia_html.prg
  $(FS) -c  ps_mvt_despesa_html.prg
  $(FS) -c  ps_otgados_html.prg
  $(FS) -c  ps_otgantes_html.prg
  $(FS) -c  ps_poderes_html.prg
  $(FS) -c  ps_prc_poderes_html.prg
  $(FS) -c  ps_sct_4atas_html.prg
  $(FS) -c  ps_sct_4procedimento_html.prg
  $(FS) -c  ps_sct_4socios_html.prg
  $(FS) -c  ps_sct_atas_html.prg
  $(FS) -c  ps_sct_conselhos_html.prg
  $(FS) -c  ps_sct_diretoria_html.prg
  $(FS) -c  ps_sct_participacao_html.prg
  $(FS) -c  ps_sct_procedimento_html.prg
  $(FS) -c  ps_sct_socios_html.prg
  $(FS) -c  ps_sct_superintendencia_html.prg
  $(FS) -c  ps_tipo_relacionamento_mnt_html.prg
  $(FS) -c  psab_abatimentos_html.prg
  $(FS) -c  psab_acordo_html.prg
  $(FS) -c  psab_adv_avaliacoes_html.prg
  $(FS) -c  psab_agenda_html.prg
  $(FS) -c  psab_analise_causa_html.prg
  $(FS) -c  psab_auto_html.prg
  $(FS) -c  psab_autoaprova_html.prg
  $(FS) -c  psab_avaliacoes_html.prg
  $(FS) -c  psab_causaraiz_html.prg
  $(FS) -c  psab_comercial_html.prg
  $(FS) -c  psab_consultor_interno_html.prg
  $(FS) -c  psab_corporativo_html.prg
  $(FS) -c  psab_credito_html.prg
  $(FS) -c  psab_dep_cont_html.prg
  $(FS) -c  psab_deposito_html.prg
  $(FS) -c  psab_designar_escritorio_html.prg
  $(FS) -c  psab_desp_adicionais_html.prg
  $(FS) -c  psab_despesa_html.prg
  $(FS) -c  psab_div_responsabilidade_html.prg
  $(FS) -c  psab_docs_contratos_html.prg
  $(FS) -c  psab_documentos_html.prg
  $(FS) -c  psab_escritorio_html.prg
  $(FS) -c  psab_filiais_html.prg
  $(FS) -c  psab_garantia_html.prg
  $(FS) -c  psab_gr_despesa_html.prg
  $(FS) -c  psab_honorario_html.prg
  $(FS) -c  psab_incorporacao_html.prg
  $(FS) -c  psab_inf_comerciais_html.prg
  $(FS) -c  psab_investimentos_html.prg
  $(FS) -c  psab_itens_html.prg
  $(FS) -c  psab_jurisprudencia_html.prg
  $(FS) -c  psab_lic_certificado_html.prg
  $(FS) -c  psab_locador_html.prg
  $(FS) -c  psab_mvt_contabil_html.prg
  $(FS) -c  psab_notificacao_html.prg
  $(FS) -c  psab_nuloresultado_html.prg
  $(FS) -c  psab_ocorecur_html.prg
  $(FS) -c  psab_ped_indenizatorio_html.prg
  $(FS) -c  psab_ped2_html.prg
  $(FS) -c  psab_ped3_html.prg
  $(FS) -c  psab_pedido_html.prg
  $(FS) -c  psab_pesquisa_html.prg
  $(FS) -c  psab_propostacom_html.prg
  $(FS) -c  psab_ra_contratos_html.prg
  $(FS) -c  psab_ra_ocorrencias_html.prg
  $(FS) -c  psab_ra_recupera_html.prg
  $(FS) -c  psab_rateio_ccusto_html.prg
  $(FS) -c  psab_receb_ressarc_html.prg
  $(FS) -c  psab_reclamante_html.prg
  $(FS) -c  psab_recurso_html.prg
  $(FS) -c  psab_relacionamento_html.prg
  $(FS) -c  psab_renovacao_html.prg
  $(FS) -c  psab_res_contrato3_html.prg
  $(FS) -c  psab_res_sin_html.prg
  $(FS) -c  psab_res2_html.prg
  $(FS) -c  psab_resultado_html.prg
  $(FS) -c  psab_risco_atividade_html.prg
  $(FS) -c  psab_se_cont_html.prg
  $(FS) -c  psab_seg_1cont_sinistro_html.prg
  $(FS) -c  psab_seg_2cont_sinistro_html.prg
  $(FS) -c  psab_seg_cont_sinistro_html.prg
  $(FS) -c  psab_seg_sinistro_html.prg
  $(FS) -c  psab_seguro_html.prg
  $(FS) -c  psab_sindicancia_html.prg
  $(FS) -c  psab_timesheet_html.prg
  $(FS) -c  psab_valor_html.prg
  $(FS) -c  pst_2anexo_html.prg
  $(FS) -c  pst_aditivo_contrato_html.prg
  $(FS) -c  pst_anexo_contrato_html.prg
  $(FS) -c  pst_consultor_externo_html.prg
  $(FS) -c  pst_desc_reclama_html.prg
  $(FS) -c  pst_descr_poderes_html.prg
  $(FS) -c  pst_dist_interna_html.prg
  $(FS) -c  pst_distribuicao_externa_html.prg
  $(FS) -c  pst_execucao_html.prg
  $(FS) -c  pst_interno_html.prg
  $(FS) -c  pst_ocorrido_html.prg
  $(FS) -c  pst_parte_passiva_html.prg
  $(FS) -c  pst_penhora_html.prg
  $(FS) -c  pst_seguro_html.prg
  $(FS) -c  pst_transf_html.prg
  $(FS) -c  qualidade_mnt_html.prg
  $(FS) -c  query_1ajx.prg
  $(FS) -c  query_ajx.prg
  $(FS) -c  query_ajx1.prg
  $(FS) -c  query_gajx.prg
  $(FS) -c  questionamento_motivo_mnt_html.prg
  $(FS) -c  regiao_mnt_html.prg
  $(FS) -c  regional_mnt_html.prg
#   $(FS) -c  rel_alfa_fipe_analitico_html.prg
#   $(FS) -c  rel_alfa_memorando_html.prg
#   $(FS) -c  rel_alfa_previdencia_html.prg
#   $(FS) -c  rel_alfa_seguradora_html.prg
#   $(FS) -c  rel_geral_processos_html.prg
#   $(FS) -c  rel_memorando_html.prg
#   $(FS) -c  rel_vpar_societarios_html.prg
  $(FS) -c  remessa_tipo_mnt_html.prg
  $(FS) -c  resp_dano_mnt_html.prg
  $(FS) -c  restructgr5.prg
  $(FS) -c  resultado_contrato_mnt_html.prg
  $(FS) -c  riscoperda_pedido_mnt_html.prg
  $(FS) -c  ro_judicial_html.prg
  $(FS) -c  roda_xup_mnt_html.prg
  $(FS) -c  sch_ac_group_html.prg
  $(FS) -c  sch_afastamento_html.prg
  $(FS) -c  sch_alcada_html.prg
  $(FS) -c  sch_all_abas_html.prg
  $(FS) -c  sch_all_fields_html.prg
  $(FS) -c  sch_all_objeto_html.prg
  $(FS) -c  sch_all_pasta_html.prg
  $(FS) -c  sch_all_pedido_html.prg
  $(FS) -c  sch_andamentos_envio_html.prg
  $(FS) -c  sch_atividade_recurso_html.prg
  $(FS) -c  sch_atuacao_poder_html.prg
  $(FS) -c  sch_bodespesa_html.prg
  $(FS) -c  sch_canal_produto_html.prg
  $(FS) -c  sch_cargo_html.prg
  $(FS) -c  sch_causanis_html.prg
  $(FS) -c  sch_ccusto_html.prg
  $(FS) -c  sch_cidade_html.prg
  $(FS) -c  sch_clas_doenca_html.prg
  $(FS) -c  sch_coberturas_ramos_html.prg
  $(FS) -c  sch_cobranca_html.prg
  $(FS) -c  sch_comarca_regiao_html.prg
  $(FS) -c  sch_combinacao_poder_html.prg
  $(FS) -c  sch_conjunto_poder_html.prg
  $(FS) -c  sch_conta_debito_html.prg
  $(FS) -c  sch_convencao_html.prg
  $(FS) -c  sch_cor_html.prg
  $(FS) -c  sch_corp_despesa_html.prg
  $(FS) -c  sch_corp_servico_html.prg
  $(FS) -c  sch_ctrdo_html.prg
  $(FS) -c  sch_ctrte_html.prg
  $(FS) -c  sch_dc_envio_html.prg
  $(FS) -c  sch_departarea_html.prg
  $(FS) -c  sch_depto_resp_html.prg
  $(FS) -c  sch_desligamento_html.prg
  $(FS) -c  sch_despesa_html.prg
  $(FS) -c  sch_documento_html.prg
  $(FS) -c  sch_doenca_html.prg
  $(FS) -c  sch_estimativas_html.prg
  $(FS) -c  sch_exito_riscoperda_html.prg
  $(FS) -c  sch_field_html.prg
  $(FS) -c  sch_fields_pscalc_html.prg
  $(FS) -c  sch_gestor_html.prg
  $(FS) -c  sch_groups_html.prg
  $(FS) -c  sch_grp_despesa_html.prg
  $(FS) -c  sch_grupo_economico_html.prg
  $(FS) -c  sch_honorarios_html.prg
  $(FS) -c  sch_incorporacao_html.prg
  $(FS) -c  sch_indice_reajuste_html.prg
  $(FS) -c  sch_jurcc_html.prg
  $(FS) -c  sch_lg_resp_html.prg
  $(FS) -c  sch_login_html.prg
  $(FS) -c  sch_loja_html.prg
  $(FS) -c  sch_lojap_html.prg
  $(FS) -c  sch_loteamento_html.prg
  $(FS) -c  sch_moeda_html.prg
  $(FS) -c  sch_motivo_operacao_html.prg
  $(FS) -c  sch_objeto_html.prg
  $(FS) -c  sch_ocor_pedido_html.prg
  $(FS) -c  sch_ocorrencia_pedido_html.prg
  $(FS) -c  sch_pasta_html.prg
  $(FS) -c  sch_pastaseguro_html.prg
  $(FS) -c  sch_ped_despesa_html.prg
  $(FS) -c  sch_ped_seguro_html.prg
  $(FS) -c  sch_pedido_html.prg
  $(FS) -c  sch_pfpj_atividade_html.prg
  $(FS) -c  sch_pfpj_cargo_html.prg
  $(FS) -c  sch_pfpj_html.prg
  $(FS) -c  sch_pfpj_tipos_html.prg
  $(FS) -c  sch_plct_html.prg
  $(FS) -c  sch_poder_tipo_html.prg
  $(FS) -c  sch_prc_poder_html.prg
  $(FS) -c  sch_procuracao_clausula_html.prg
  $(FS) -c  sch_produto_html.prg
  $(FS) -c  sch_pst_contrato_html.prg
  $(FS) -c  sch_pst_origem_html.prg
  $(FS) -c  sch_ramosrsn_html.prg
  $(FS) -c  sch_recurso_status_html.prg
  $(FS) -c  sch_riscoperda_pedido_html.prg
  $(FS) -c  sch_sct_atas_html.prg
  $(FS) -c  sch_seguro_html.prg
  $(FS) -c  sch_servico_html.prg
  $(FS) -c  sch_sin_causa_html.prg
  $(FS) -c  sch_status_proposta_html.prg
  $(FS) -c  sch_tab_despesa_html.prg
  $(FS) -c  sch_tab_honorario_html.prg
  $(FS) -c  sch_tab_servico_html.prg
  $(FS) -c  sch_table_html.prg
  $(FS) -c  sch_tb_fields_html.prg
  $(FS) -c  sch_tipo_pfpj_html.prg
  $(FS) -c  sch_tipo_recebe_html.prg
  $(FS) -c  sch_tp_emissao_html.prg
  $(FS) -c  sch_tp_expediente_html.prg
  $(FS) -c  sch_tp_poder_html.prg
  $(FS) -c  sch_transacao_contabil_html.prg
  $(FS) -c  sch_tributos_html.prg
  $(FS) -c  sch_ts_pt_pasta_html.prg
  $(FS) -c  sch_uf_html.prg
  $(FS) -c  sch_unidade_medida_html.prg
  $(FS) -c  sch_users_html.prg
  $(FS) -c  sch_users2_html.prg
  $(FS) -c  sch_wprgroup_html.prg
  $(FS) -c  sch_wprogram_html.prg
  $(FS) -c  sch_xstatus_proposta_html.prg
  $(FS) -c  seg_habit_export_html.prg
  $(FS) -c  seguro_responsabilidade_mnt_html.prg
  $(FS) -c  sendemail_wic.prg
  $(FS) -c  sendsms_wic.prg
  $(FS) -c  servconf_mnt_html.prg
  $(FS) -c  servico_mnt_html.prg
  $(FS) -c  servlog_mnt_html.prg
  $(FS) -c  setup_html.prg
  $(FS) -c  sias_caixa_html.prg
  $(FS) -c  sios_cosesp_html.prg
  $(FS) -c  siscodida.prg
  $(FS) -c  siscodvolta.prg
  $(FS) -c  sitconsulta_mnt_html.prg
  $(FS) -c  sla_analitico_html.prg
  $(FS) -c  st_lote_mnt_html.prg
  $(FS) -c  status_notificacao_mnt_html.prg
  $(FS) -c  status_penhora_mnt_html.prg
  $(FS) -c  status_procuracao_mnt_html.prg
  $(FS) -c  status_recurso_mnt_html.prg
  $(FS) -c  statusinterface_mnt_html.prg
  $(FS) -c  sun_export_html.prg
  $(FS) -c  sunsystem_export_html.prg
  $(FS) -c  sysopcarga.prg
  $(FS) -c  tabela_autoinc_mnt_html.prg
  $(FS) -c  task_category_html.prg
  $(FS) -c  task_group_html.prg
  $(FS) -c  task_status_html.prg
  $(FS) -c  tec_pontual_mnt_html.prg
  $(FS) -c  testemunhano_mnt_html.prg
  $(FS) -c  tipo_carta_mnt_html.prg
  $(FS) -c  tipo_consulta_mnt_html.prg
  $(FS) -c  tipo_docfiscal_mnt_html.prg
  $(FS) -c  tipo_favorecido_mnt_html.prg
  $(FS) -c  tipo_notificacao_mnt_html.prg
  $(FS) -c  tipo_pagto_mnt_html.prg
  $(FS) -c  tipo_providencia_mnt_html.prg
  $(FS) -c  tipo_sinistro_mnt_html.prg
  $(FS) -c  tipocapital_mnt_html.prg
  $(FS) -c  tipoconta_mnt_html.prg
  $(FS) -c  tipoempresa_mnt_html.prg
#   $(FS) -c  tokiosin.prg
  $(FS) -c  tp_expediente_mnt_html.prg
  $(FS) -c  tp_lancto_mnt_html.prg
  $(FS) -c  tp_procuracao_mnt_html.prg
  $(FS) -c  tp_registro_mnt_html.prg
  $(FS) -c  tp_ressarc_mnt_html.prg
  $(FS) -c  tp_segmento_mnt_html.prg
  $(FS) -c  transf_incorporacao_mnt_html.prg
  $(FS) -c  transf_responsabilidade_bat_html.prg
  $(FS) -c  turma_mnt_html.prg
  $(FS) -c  uas_fnet.prg
  $(FS) -c  unidade_medida_mnt_html.prg
  $(FS) -c  validainterface_html.prg
  $(FS) -c  view_markup_html.prg
  $(FS) -c  webmail_wic.prg
  $(FS) -c  werror_access_wic.prg
  $(FS) -c  werror_wic.prg
  $(FS) -c  wfp_sbhtml.prg
  $(FS) -c  wprofile.prg
  $(FS) -c  xexecsql.prg
  $(FS) -c  xrb2a.prg
  $(FS) -c  xupddep.prg
  $(FS) -c  xupdval.prg
# Interface Ebao
  $(FS) -c  ebaocfg_class.prg
  $(FS) -c  ebaolog_class.prg
  $(FS) -c  ebaoserv_class.prg
  $(FS) -c  ebaoutils_class.prg
  $(FS) -c  ebconreq_class.prg
  $(FS) -c  ebconresp_class.prg
  $(FS) -c  ebmksin_class.prg
  $(FS) -c  eheadreq_class.prg
  $(FS) -c  lst_sinebao_html.prg
  $(FS) -c  mnt_ebaocfg_html.prg
  $(FS) -c  mnt_ebaoconlog_html.prg
  $(FS) -c  mnt_ebaoservices_html.prg
  $(FS) -c  retebao_class.prg
  $(FS) -c  retebaomksin_class.prg
  $(FS) -c  retornoebao_class.prg
  $(FS) -c  sch_sinebao_html.prg      
  cd ..
  $(FS_LINK) gr5.obj gr5_main.obj isjtrans.obj compile/*.obj d:/wictrixglauber/plugins/wf/wfengine.obj d:/wictrixglauber/plugins/wf/wftools.obj d:/wictrixglauber/lib/mailnovo/EnviaMail_Novo.obj d:/wictrixglauber/lib/mailnovo/isjwfmail.obj /out:gr5.exe  $(FS_LIB_PATH) $(LIBFILES) $(FS_LINK_OPT)
  $(FS_LINK) gr5tasks.obj isjtrans.obj gr5tasks_main.obj  gethttp.obj compile/*.obj d:/wictrixglauber/plugins/wf/wfengine.obj d:/wictrixglauber/plugins/wf/wftools.obj d:/wictrixglauber/lib/mailnovo/EnviaMail_Novo.obj d:/wictrixglauber/lib/mailnovo/isjwfmail.obj /out:gr5tasks.exe  $(FS_LIB_PATH) $(LIBFILES) $(FS_LINK_OPT)

#-- [n]make clean
clean:
	$(RM) $(EXEFILES)
  $(RM) compile\*.obj
  $(RM) compile\*.c

#-- [n]make linka
linka:
   $(FS_LINK) gr5.obj gr5_main.obj isjtrans.obj compile/*.obj d:/wictrixglauber/plugins/wf/wfengine.obj d:/wictrixglauber/plugins/wf/wftools.obj d:/wictrixglauber/lib/mailnovo/EnviaMail_Novo.obj d:/wictrixglauber/lib/mailnovo/isjwfmail.obj /out:gr5.exe  $(FS_LIB_PATH) $(LIBFILES) $(FS_LINK_OPT)
   $(FS_LINK) gr5tasks.obj gr5tasks_main.obj  isjtrans.obj   compile/*.obj d:/wictrixglauber/plugins/wf/wfengine.obj d:/wictrixglauber/plugins/wf/wftools.obj d:/wictrixglauber/lib/mailnovo/EnviaMail_Novo.obj d:/wictrixglauber/lib/mailnovo/isjwfmail.obj /out:gr5tasks.exe  $(FS_LIB_PATH) $(LIBFILES) $(FS_LINK_OPT)




