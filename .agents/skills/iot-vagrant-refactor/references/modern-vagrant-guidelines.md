# Diretrizes de Práticas Modernas para Vagrant (IoT 42)

Este documento atua como a fonte de verdade para auditar e refatorar arquivos `Vagrantfile`. Ao revisar os ambientes do projeto Inception-of-Things, você deve garantir que o código cumpra rigorosamente as seguintes arquiteturas modernas:

## 1. Idempotência Obrigatória no Provisionamento
[cite_start]O conceito de idempotência é o divisor de águas entre scripts amadores e infraestruturas industriais modernas[cite: 695]. [cite_start]A execução do comando `vagrant provision` repetidas vezes deve resultar sempre no mesmo estado estável[cite: 697].
* [cite_start]**Abandone o Shell Imperativo Simples:** Scripts que quebram em uma segunda execução (ex: tentando criar um usuário que já existe) são considerados uma prática legada[cite: 710].
* [cite_start]**Implemente "State Guards":** Refatore provisionadores de shell para incluir blocos condicionais que validem a existência de binários ou diretórios antes de executar qualquer mutação no disco[cite: 705, 706]. [cite_start]Por exemplo, antes de baixar um arquivo, teste a ausência dele localmente[cite: 708].
* [cite_start]**Camadas de Provisionamento:** Use múltiplos blocos `config.vm.provision` para orquestrar dependências em fases lógicas sequenciais[cite: 711, 712].

## 2. Abstração Orientada a Objetos para Multi-Nós
[cite_start]Projetos K3s exigem a configuração de nós Controller e Agents[cite: 747].
* [cite_start]**A Armadilha do Loop Básico:** Nunca utilize estruturas de repetição (como laços `for` ou iteradores genéricos em Ruby) injetando a variável do loop diretamente no bloco `config.vm.define`[cite: 728, 730]. [cite_start]O Vagrant sofre de resolução de variáveis diferidas, o que fará com que todas as máquinas assumam o último valor do loop, gerando colisões de IP e nome[cite: 730, 731, 734, 735].
* [cite_start]**Uso de Classes Ruby (POO):** Para mitigar colisões, modele o arquivo declarando uma classe Ruby (ex: `NodeConfig`)[cite: 736, 737]. [cite_start]Instancie as propriedades da máquina (nome, IP) via método construtor (`initialize`) para garantir que o estado seja salvo no momento exato da iteração[cite: 737, 738].

## 3. Gestão Austera de Recursos
[cite_start]A restrição de hardware (ex: 1 CPU e 512 MB ou 1024 MB de RAM) é inegociável[cite: 684].
* [cite_start]**Imagens Enxutas:** Prefira bases minimalistas em vez de sistemas operacionais de uso geral com interface gráfica[cite: 685].
* [cite_start]**Limitação Explícita:** O gerenciamento da alocação de recursos deve ser declarado explicitamente no bloco do provedor (ex: VirtualBox), impedindo que a máquina virtual sature a estação de trabalho[cite: 692].

## 4. Validação Prévia de Dependências (Plugins)
[cite_start]O ambiente não deve quebrar abruptamente se o computador hospedeiro não possuir os plugins necessários[cite: 715, 716].
* [cite_start]**Checagem em Tempo de Carregamento:** Implemente o método `Vagrant.has_plugin?` no topo do arquivo[cite: 718, 719].
* [cite_start]**Mitigação Automática:** Caso o plugin não exista, o script deve interromper com uma mensagem clara (usando `raise`) ou automatizar a instalação em plano de fundo via chamada de sistema (`system`)[cite: 720].

## 5. Bootstrapping Seguro e Transparente do K3s
[cite_start]O provisionamento do cluster não admite intervenções manuais[cite: 743].
* [cite_start]**Distribuição de Tokens:** O nó Controller gera um token em `/var/lib/rancher/k3s/server/node-token`[cite: 750, 751]. [cite_start]Automatize a cópia deste token para a pasta compartilhada (`/vagrant`) para que os nós Workers possam lê-lo e se juntar ao cluster sem a necessidade de intervenção humana (SSH manual)[cite: 752, 753, 754, 756].
* [cite_start]**Chaves SSH:** Integre a geração e distribuição de chaves criptográficas (RSA ou Ed25519) poplando os arquivos `authorized_keys`, garantindo conectividade direta e inviolável entre as máquinas do agrupamento[cite: 759, 760].