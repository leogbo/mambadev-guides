/**
 * Classe `EnvironmentUtils`
 * 
 * Esta classe centraliza a leitura e atualização de configurações do ambiente da organização Salesforce
 * através do Custom Setting `ConfiguracaoSistema__c`. Ela permite acessar e manipular informações como 
 * o ambiente (produção ou sandbox), o nível de log, se o log está ativo, a habilitação de mocks, entre 
 * outros parâmetros configuráveis diretamente do Custom Setting. Os valores configurados são carregados e 
 * mantidos em cache para garantir a eficiência e evitar múltiplas consultas.
 * 
 * ### Funcionalidade:
 * - **Leitura dos Valores Configurados:** Os métodos de leitura permitem acessar o valor do ambiente, 
 *   o nível de log, se o log está ativo, e outros parâmetros.
 * - **Atualização das Configurações:** A classe fornece métodos para atualizar as configurações no Custom 
 *   Setting, permitindo alterar o ambiente, o nível de log, e outros valores diretamente na plataforma.
 * - **Cache Interno:** A classe utiliza um cache para armazenar os valores configurados após a leitura 
 *   inicial, evitando consultas repetidas e melhorando a performance das operações subsequentes.
 * - **Acesso a Custom Settings:** A classe interage diretamente com o Custom Setting `ConfiguracaoSistema__c`,
 *   que armazena valores específicos para a organização (como `Ambiente__c`, `Log_Level__c`, `Log_Ativo__c`, 
 *   `Habilita_Mock__c`, `Modo_Teste_Ativo__c`, entre outros).
 * 
 * ### Métodos de Leitura:
 * - `isProduction()`: Retorna `true` se o ambiente configurado for produção.
 * - `isSandbox()`: Retorna `true` se o ambiente configurado for sandbox.
 * - `getRaw()`: Retorna o valor do ambiente como uma string.
 * - `isKnownEnvironment()`: Retorna `true` se o ambiente for conhecido (produção ou sandbox).
 * - `getLogLevel()`: Retorna o nível de log configurado.
 * - `isLogAtivo()`: Retorna se o log está ativo.
 * - `isMockEnabled()`: Retorna se a funcionalidade de mock está habilitada.
 * - `isModoTesteAtivo()`: Retorna se o modo de teste está ativo.
 * - `getTimeoutCallout()`: Retorna o timeout de callout configurado.
 * - `getMaxDebugLength()`: Retorna o máximo de caracteres para trucar o campo de debug.
 * - `isFlowsDisabled()`: Retorna se os flows estão desativados.
 * 
 * ### Métodos de Atualização:
 * - `updateEnvironment(String newEnvironment)`: Atualiza o ambiente configurado (produção ou sandbox).
 * - `updateLogLevel(String newLogLevel)`: Atualiza o nível de log configurado.
 * - `updateLogAtivo(Boolean newLogAtivo)`: Atualiza se o log está ativo.
 * - `updateHabilitaMock(Boolean newHabilitaMock)`: Atualiza se a funcionalidade de mock está habilitada.
 * - `updateModoTesteAtivo(Boolean newModoTesteAtivo)`: Atualiza se o modo de teste está ativo.
 * - `updateTimeoutCallout(Decimal newTimeout)`: Atualiza o timeout de callout configurado.
 * - `updateMaxDebugLength(Decimal newLength)`: Atualiza o max debug length configurado.
 * - `updateDesativarFlows(Boolean newDesativarFlows)`: Atualiza se os flows estão desativados.
 * 
 * ### Uso nas Demais Classes:
 * Esta classe deve ser utilizada em outras classes que necessitam acessar ou modificar as configurações 
 * globais de ambiente. Por exemplo:
 * - **Verificação do ambiente**: Qualquer lógica que dependa de saber se a organização está em ambiente 
 *   de produção ou sandbox pode usar os métodos `isProduction()` ou `isSandbox()`.
 * - **Configuração de logs**: Classes que realizam logging podem utilizar `getLogLevel()` e `isLogAtivo()` 
 *   para ajustar o nível de log dinamicamente.
 * - **Controle de comportamento de mocks e testes**: Métodos como `isMockEnabled()` e `isModoTesteAtivo()` 
 *   podem ser usados para configurar o comportamento de testes e mocks durante a execução de testes unitários.
 * - **Alteração de configurações**: Em cenários onde as configurações precisam ser alteradas (como mudar 
 *   o ambiente de sandbox para produção), os métodos `updateEnvironment()` e outros devem ser utilizados.
 * 
 * ### Considerações:
 * - A classe **carrega as configurações apenas uma vez** quando a aplicação é inicializada ou quando 
 *   ocorre uma atualização das configurações. Isso garante que a leitura e as atualizações subsequentes 
 *   sejam eficientes.
 * - A classe interage diretamente com o **Custom Setting** `ConfiguracaoSistema__c`, que deve estar 
 *   configurado corretamente no Salesforce para armazenar as variáveis de ambiente. Isso permite centralizar 
 *   e gerenciar as configurações de ambiente de maneira mais organizada e flexível.
 * - Certifique-se de **validar as permissões de acesso** para o Custom Setting `ConfiguracaoSistema__c` 
 *   em todos os usuários que possam interagir com a classe.
 */

 public class EnvironmentUtils {

    // 🔒 Cache de leitura
    @TestVisible private static String ENVIRONMENT;
    @TestVisible private static String LOG_LEVEL;
    @TestVisible private static Boolean LOG_ATIVO;
    @TestVisible private static Boolean HABILITA_MOCK;
    @TestVisible private static Boolean MODO_TESTE_ATIVO;
    @TestVisible private static Decimal TIMEOUT_CALLOUT;
    @TestVisible private static Decimal MAX_DEBUG_LENGTH;
    @TestVisible private static Boolean DESATIVAR_FLOWS;

    static {
        loadAllSettings();
    }

    @TestVisible
    private static void loadAllSettings() {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Ambiente__c, Log_Level__c, Log_Ativo__c, 
                                                Habilita_Mock__c, Modo_Teste_Ativo__c, 
                                                Timeout_Callout__c, Max_Debug_Length__c, Desativar_Flows__c 
                                           FROM ConfiguracaoSistema__c
                                           ORDER BY CreatedDate DESC LIMIT 1];

            if (conf != null) {
                ENVIRONMENT = String.isNotBlank(conf.Ambiente__c) ? conf.Ambiente__c.trim().toLowerCase() : null;
                LOG_LEVEL = String.isNotBlank(conf.Log_Level__c) ? conf.Log_Level__c.trim().toLowerCase() : null;
                LOG_ATIVO = conf.Log_Ativo__c;
                HABILITA_MOCK = conf.Habilita_Mock__c;
                MODO_TESTE_ATIVO = conf.Modo_Teste_Ativo__c;
                TIMEOUT_CALLOUT = conf.Timeout_Callout__c;
                MAX_DEBUG_LENGTH = conf.Max_Debug_Length__c;
                DESATIVAR_FLOWS = conf.Desativar_Flows__c;
            }
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao acessar Custom Setting: ' + ex.getMessage());
        }
    }

    // Métodos de leitura dos campos
    @TestVisible
    public static Boolean isProduction() {
        return 'production'.equalsIgnoreCase(ENVIRONMENT);
    }

    @TestVisible
    public static Boolean isSandbox() {
        return 'sandbox'.equalsIgnoreCase(ENVIRONMENT);
    }

    @TestVisible
    public static String getRaw() {
        return ENVIRONMENT;
    }

    @TestVisible
    public static Boolean isKnownEnvironment() {
        return isProduction() || isSandbox();
    }

    @TestVisible
    public static String getLogLevel() {
        return LOG_LEVEL;
    }

    @TestVisible
    public static Boolean isLogAtivo() {
        return LOG_ATIVO;
    }

    @TestVisible
    public static Boolean isMockEnabled() {
        return HABILITA_MOCK;
    }

    @TestVisible
    public static Boolean isModoTesteAtivo() {
        return MODO_TESTE_ATIVO;
    }

    @TestVisible
    public static Decimal getTimeoutCallout() {
        return TIMEOUT_CALLOUT;
    }

    @TestVisible
    public static Decimal getMaxDebugLenght() {
        return MAX_DEBUG_LENGTH;
    }

    @TestVisible
    public static Boolean isFlowsDisabled() {
        return DESATIVAR_FLOWS;
    }

    // Métodos de atualização dos campos

    @TestVisible
    public static void updateEnvironment(String newEnvironment) {
        if (String.isNotBlank(newEnvironment) && (newEnvironment.equalsIgnoreCase('production') || newEnvironment.equalsIgnoreCase('sandbox'))) {
            try {
                // Realiza o SELECT para pegar o último registro criado
                ConfiguracaoSistema__c conf = [SELECT Id, Ambiente__c FROM ConfiguracaoSistema__c 
                                               ORDER BY CreatedDate DESC LIMIT 1];
                if (conf == null) {
                    conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
                }
                conf.Ambiente__c = newEnvironment;
                update conf;

                ENVIRONMENT = newEnvironment.toLowerCase();
            } catch (Exception ex) {
                System.debug('⚠️ Erro ao atualizar Custom Setting Ambiente: ' + ex.getMessage());
            }
        } else {
            throw new IllegalArgumentException('Ambiente inválido. Deve ser "production" ou "sandbox".');
        }
    }

    @TestVisible
    public static void updateLogLevel(String newLogLevel) {
        if (String.isNotBlank(newLogLevel) && (newLogLevel.equalsIgnoreCase('info') || newLogLevel.equalsIgnoreCase('error') || newLogLevel.equalsIgnoreCase('warn'))) {
            try {
                // Realiza o SELECT para pegar o último registro criado
                ConfiguracaoSistema__c conf = [SELECT Id, Log_Level__c FROM ConfiguracaoSistema__c 
                                               ORDER BY CreatedDate DESC LIMIT 1];
                if (conf == null) {
                    conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
                }
                conf.Log_Level__c = newLogLevel;
                update conf;

                LOG_LEVEL = newLogLevel.toLowerCase();
            } catch (Exception ex) {
                System.debug('⚠️ Erro ao atualizar Custom Setting Log Level: ' + ex.getMessage());
            }
        } else {
            throw new IllegalArgumentException('Nível de Log inválido. Deve ser "INFO", "ERROR", ou "WARN".');
        }
    }

    @TestVisible
    public static void updateLogAtivo(Boolean newLogAtivo) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Log_Ativo__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Log_Ativo__c = newLogAtivo;
            update conf;

            LOG_ATIVO = newLogAtivo;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Log Ativo: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateHabilitaMock(Boolean newHabilitaMock) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Habilita_Mock__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Habilita_Mock__c = newHabilitaMock;
            update conf;

            HABILITA_MOCK = newHabilitaMock;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Habilita Mock: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateModoTesteAtivo(Boolean newModoTesteAtivo) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Modo_Teste_Ativo__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Modo_Teste_Ativo__c = newModoTesteAtivo;
            update conf;

            MODO_TESTE_ATIVO = newModoTesteAtivo;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Modo Teste Ativo: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateTimeoutCallout(Decimal newTimeout) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Timeout_Callout__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Timeout_Callout__c = newTimeout;
            update conf;

            TIMEOUT_CALLOUT = newTimeout;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Timeout Callout: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateMaxDebugLength(Decimal newLength) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Max_Debug_Length__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Max_Debug_Length__c = newLength;
            update conf;

            MAX_DEBUG_LENGTH = newLength;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Max Debug Length: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateDesativarFlows(Boolean newDesativarFlows) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Desativar_Flows__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Desativar_Flows__c = newDesativarFlows;
            update conf;

            DESATIVAR_FLOWS = newDesativarFlows;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Desativar Flows: ' + ex.getMessage());
        }
    }
}
