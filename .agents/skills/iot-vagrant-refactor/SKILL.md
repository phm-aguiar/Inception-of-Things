---
name: iot-vagrant-refactor
description: Analisa e refatora os Vagrantfiles das pastas p1 e p2 do Inception-of-Things para garantir que sigam práticas modernas. Use quando o projeto já estiver feito e o usuário pedir para revisar ou modernizar o código do Vagrant.
---

# Auditoria e Refatoração de Práticas Modernas no Vagrant

Você é um engenheiro de DevOps sênior revisando o projeto Inception-of-Things (IoT). O usuário já concluiu as partes p1, p2 e p3. [cite_start]Sua tarefa é auditar os arquivos `p1/Vagrantfile` e `p2/Vagrantfile` [cite: 618, 622] [cite_start]para garantir a regra: "You will set up your Vagrantfile according to modern practices.".

## O que constitui "Práticas Modernas" neste contexto:
Ao avaliar e reescrever o `Vagrantfile`, aplique as seguintes correções sem quebrar a lógica de funcionamento:

1. [cite_start]**Separação de Preocupações (No Inline Shell):** * Verifique se há scripts grandes no formato `config.vm.provision "shell", inline: <<-SHELL`[cite: 95].
   * [cite_start]Se houver, extraia todo o código bash para scripts separados e mova-os para a pasta correspondente `p1/scripts/` ou `p2/scripts/`[cite: 619, 627, 658].
   * Atualize o Vagrantfile para chamar o arquivo externo usando `path:`.

2. **Otimização e DRY (Don't Repeat Yourself):**
   * Se as duas máquinas (Server e Server Worker) compartilharem configurações idênticas (como a box do SO ou configurações do VirtualBox), agrupe-as num bloco comum ou use laços de repetição em Ruby (`each`) caso seja aplicável e limpo.

3. **Restrição de Recursos Clara:**
   * [cite_start]Certifique-se de que a alocação do mínimo necessário (1 CPU e 512 MB ou 1024 MB de RAM) [cite: 48] esteja configurada explicitamente no provider do VirtualBox/Libvirt e não via hacks no shell.

## Passos para Execução:
1. [cite_start]Leia o arquivo `p1/Vagrantfile`[cite: 618].
2. [cite_start]Leia o arquivo `p2/Vagrantfile`[cite: 622].
3. Leia o guia completo de práticas em `references/modern-vagrant-guidelines.md` para base de conhecimento adicional.
4. Refatore os arquivos `Vagrantfile`.
5. Valide com `vagrant validate` na pasta correta para garantir que a sintaxe Ruby não foi quebrada.
6. Apresente ao usuário o "Antes" e o "Depois" com a justificativa de por que o novo código é mais moderno.