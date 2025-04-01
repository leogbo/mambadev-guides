<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# FlowExecutionLog__c - Estrutura e Finalidade de Campos

> Este documento define a estrutura atual do objeto `FlowExecutionLog__c`, com finalidade de logging persistente para:
> - Rastreabilidade de execução de flows, Apex, REST e callouts
> - Armazenamento de entradas/saídas (JSON)
> - Diagnóstico por ambiente, trigger type e log level

---

## Campos principais

| Campo API Name             | Label                    | Tipo              | Descrição                                                                 |
|---------------------------|--------------------------|-------------------|---------------------------------------------------------------------------|
| `Class__c`                | Class                    | string (255)      | Nome da classe responsável pelo log                                       |
| `Origin_Method__c`        | Origin Method            | string (255)      | Método de origem do log                                                   |
| `Method__c`               | Method                   | string (255)      | (redundante com Origin_Method__c - considerar unificar)                   |
| `Log_Level__c`            | Log Level                | string (255)      | Nível do log (DEBUG, INFO, WARNING, ERROR)                                |
| `Log_Category__c`         | Log Category             | picklist (255)    | Agrupamento lógico (ex: Apex, Validation, Flow, Callout)                  |
| `Status__c`               | Status                   | picklist (255)    | Resultado geral (Completed, Failed, Cancelled, etc.)                      |
| `Trigger_Type__c`         | Trigger Type             | picklist (255)    | Tipo de invocação: REST, Batch, Queueable, Trigger, etc                   |
| `Trigger_Record_ID__c`    | Trigger Record ID        | string (255)      | ID do registro relacionado (Account, UC, Lead, etc.)                      |
| `Execution_Timestamp__c`  | Execution Timestamp      | datetime          | Timestamp da execução                                                     |
| `Duration__c`             | Duration                 | double (14,4)     | Duração em segundos                                                       |
| `Error_Message__c`        | Error Message            | textarea (32k)    | Mensagem principal de erro                                                |
| `Stack_Trace__c`          | Stack Trace              | textarea (32k)    | Stack trace completo de exceção                                           |
| `Serialized_Data__c`      | Serialized Data          | textarea (32k)    | JSON de entrada, payload ou contexto relevante                            |
| `Debug_Information__c`    | Debug Information        | textarea (32k)    | JSON de resposta, saída ou trace complementar                             |
| `ValidationErros__c`      | Validation Errors        | string (255)      | Lista de erros de validação internos                                      |
| `Flow_Name__c`            | Flow Name                | string (255)      | Nome do flow (quando aplicável)                                           |
| `Flow_Outcome__c`         | Flow Outcome             | string (255)      | Resultado esperado ou calculado                                           |
| `Execution_ID__c`         | Execution ID             | string (255)      | ID de execução externo (flow interview, external call)                    |
| `Execution_Order__c`      | Execution Order          | double (18,0)     | Sequência (para execuções paralelas ou múltiplas)                         |
| `Related_Flow_Version__c` | Related Flow Version     | double (18,0)     | Versão do flow executado                                                  |
| `Step_Name__c`            | Step Name                | string (255)      | Etapa do flow declarativo                                                 |
| `Environment__c`          | Environment              | picklist (255)    | Ambiente de execução (Production, Sandbox, etc.)                          |
| `FlowExecutionLink__c`    | Flow Execution Link      | string (1300, html)| Link direto para execução do flow                                         |
| `User_ID__c`              | User ID                  | User lookup        | Usuário que iniciou a execução                                            |
| `Integration_Ref__c`      | Integration Ref          | string (255)      | ID da transação externa, externalId, ou trace ref                         |
| `Integration_Direction__c`| Integration Direction    | picklist (255)    | Direção da integração (Inbound, Outbound, Internal)                       |
| `Is_Critical__c`          | Is Critical              | boolean            | Flag para identificar logs sensíveis mesmo sem erro                       |

---

## Considerações adicionais

- Campos `Method__c` e `Origin_Method__c` podem ser unificados
- `Execution_ID__c` + `Integration_Ref__c` permitem rastrear chamadas entre sistemas
- `Integration_Direction__c` será essencial para dashboards de integrações externas
- `Is_Critical__c` permite priorização no suporte e monitoramento por CDI
- Todos os JSONs devem ser serializados com `JSON.serializePretty`

---

> Estrutura pronta para suportar rastreabilidade empresarial de logs e integrações com auditoria e painéis avançados.

