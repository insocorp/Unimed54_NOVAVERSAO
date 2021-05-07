/*
*
* Glauber - 10/2016
*
* Classe...........: ControlTran
*
* Objetivo.........: Classe que gerencia transações abertas.
*
* Atributos........:
*
*
*
* Metodos..........:
*
*    METHOD Init()
*    METHOD Destroy()
*    METHOD Open(cName, nRdd, nErrorLevel)
*    METHOD RollBackAll()
*    METHOD RollBackTran(cName)              
*    METHOD CommitTran(cName)
*    METHOD CommitAll()
*
*
* Classes Ligadas..:
*
*
*
*/

CLASS ControlTran


    // Atributos privado

    INSTANCE Transacoes

    // Metodos publico

    PROTOTYPE METHOD Init()                           CLASS ControlTran
    PROTOTYPE METHOD Destroy()                        CLASS ControlTran
    PROTOTYPE METHOD Open(cName, nRdd, nErrorLevel)   CLASS ControlTran
    PROTOTYPE METHOD RollBackAll()                    CLASS ControlTran
    PROTOTYPE METHOD RollBackTran(cName)              CLASS ControlTran
    PROTOTYPE METHOD CommitTran(cName)                CLASS ControlTran
    PROTOTYPE METHOD CommitAll()                      CLASS ControlTran



/*
*
* Glauber - 10/2016
*
* Metodo....: Init()
* Objetivo..: Construtor padrão
*
* Parâmetros:
*
*
* Retorno...:
*             Self
*
*/

METHOD Init() CLASS ControlTran

    self:Transacoes  := {}

return(self)


/*
*
* Glauber - 10/2016
*
* Metodo....: Destroy()
* Objetivo..: Destruidor padrão
*
* Parâmetros:
*
*
* Retorno...:
*             nil
*
*/

METHOD Destroy() CLASS ControlTran

    self:Transacoes  := nil

return(nil)



/*
*
* Glauber - 10/2016
*
* Metodo....: Open(cName, nRdd, nErrorLevel)
* Objetivo..: Abre uma transação.
*
* Parâmetros:
*
*
* Retorno...:
*             self
*
*/

METHOD Open(cName, nRdd, nErrorLevel)   CLASS ControlTran

   local lnPOS := 0 as Int



   lnPOS := ascan(self:Transacoes, { | pilha | Alltrim(Lower(pilha[1])) == Alltrim(Lower(cName))})

   if (lnPOS == 0)
      IsjBeginTrans(cName, nRdd, nErrorLevel)
      aadd(self:Transacoes,{cName, nRdd, nErrorLevel})
   endif


return (self)



/*
*
* Glauber - 10/2016
*
* Metodo....: RollBackAll()
* Objetivo..: Desfaz todas transações.
*
* Parâmetros:
*
*
* Retorno...:
*             self
*
*/

METHOD RollBackAll()   CLASS ControlTran

   local lnQuantos := 0 as Int

   for lnQuantos := len(self:Transacoes) TO 1 STEP -1
       IsjRollTrans(self:Transacoes[lnQuanto,1], self:Transacoes[lnQuanto,2], self:Transacoes[lnQuanto,3])
   next
   self:Transacoes := {}

return (self)


/*
*
* Glauber - 10/2016
*
* Metodo....: CommitAll()
* Objetivo..: Comita todas transações.
*
* Parâmetros:
*
*
* Retorno...:
*             self
*
*/

METHOD CommitAll()   CLASS ControlTran

   local lnQuantos := 0 as Int

   for lnQuantos := len(self:Transacoes) TO 1 STEP -1
       IsjCommTrans(self:Transacoes[lnQuantos,1], self:Transacoes[lnQuantos,2], self:Transacoes[lnQuantos,3])
   next
   self:Transacoes := {}

return (self)





/*
*
* Glauber - 12/2016
*
* Metodo....: RollBackTran(cName)
* Objetivo..: Desfaz uma determinada transação.
*
* Parâmetros:
*
*    cName..: Nome da transação.
*
* Retorno...:
*             self
*
*/

METHOD RollBackTran(cName)  CLASS ControlTran

   local lnPOS := 0 as Int



   lnPOS := ascan(self:Transacoes, { | pilha | Alltrim(Lower(pilha[1])) == Alltrim(Lower(cName))})

   if (lnPOS > 0)
      IsjRollTrans(cName, self:Transacoes[lnPOS,2] , self:Transacoes[lnPOS,3])
      adel(self:Transacoes,lnPOS)
      asize(self:Transacoes,len(self:Transacoes)-1)
   endif

return (self)







/*
*
* Glauber - 12/2016
*
* Metodo....: CommitTran(cName)
* Objetivo..: Comita uma determinada transação.
*
* Parâmetros:
*
*    cName..: Nome da transação.
*
* Retorno...:
*             self
*
*/

METHOD CommitTran(cName)  CLASS ControlTran

   local lnPOS := 0 as Int



   lnPOS := ascan(self:Transacoes, { | pilha | Alltrim(Lower(pilha[1])) == Alltrim(Lower(cName))})

   if (lnPOS > 0)
      IsjCommTrans(cName, self:Transacoes[lnPOS,2] , self:Transacoes[lnPOS,3])
      adel(self:Transacoes,lnPOS)
      asize(self:Transacoes,len(self:Transacoes)-1)
   endif

return (self)

