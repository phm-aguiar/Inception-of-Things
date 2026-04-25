# Como Tudo Funciona

Este documento explica a arquitetura e o fluxo operacional de ponta a ponta.

## Visao geral

- p1 cria um cluster K3s com 2 VMs (controller + worker)
- p2 usa uma VM unica com K3s e Ingress para 3 apps
- p3 migra para K3d + Argo CD em abordagem GitOps

## Arquitetura por etapa

```mermaid
flowchart TB
    subgraph P1[Parte 1]
        V1[Vagrant] --> S1[Server K3s]
        V1 --> W1[Worker K3s]
        S1 <--> W1
    end

    subgraph P2[Parte 2]
        V2[Vagrant] --> S2[K3s unico]
        S2 --> I2[Ingress]
        I2 --> A21[app1.com -> app1]
        I2 --> A22[app2.com -> app2]
        I2 --> A23[default -> app3]
    end

    subgraph P3[Parte 3]
        G3[GitHub] --> ARGO[Argo CD]
        ARGO --> K3D[K3d]
        K3D --> DEV[Namespace dev]
    end
```

## Fluxo GitOps da p3

```mermaid
stateDiagram-v2
    [*] --> Commit
    Commit --> Push
    Push --> ArgoDetecta: Webhook/Poll
    ArgoDetecta --> Sync
    Sync --> DeployDev
    DeployDev --> [*]
```

## Relacao entre arquivos importantes

- p1/Vagrantfile: define VMs, recursos e provisioning de server/worker
- p1/scripts/server.sh e p1/scripts/worker.sh: bootstrap do cluster p1
- p2/Vagrantfile: VM unica de p2
- p2/confs/*.yaml: manifests de apps e ingress
- p3/scripts/setup.sh: prepara k3d, namespaces e Argo CD
- p3/confs/app.yaml: Application do Argo CD
- p3/confs/project.yaml: AppProject do Argo CD
- p3/manifests/*.yaml: aplicacao monitorada via GitOps

## Variacoes de rollout por tag

Para testar versoes da imagem no p3:

- versao inicial: ajustar deployment com tag v1
- upgrade: trocar para v2 e enviar commit
- Argo CD deve sincronizar automaticamente no namespace dev

```mermaid
graph LR
    V1[Tag v1] --> Commit1[Commit no repo]
    Commit1 --> Sync1[Argo Sync]
    Sync1 --> Pod1[Pods com v1]
    Pod1 --> V2[Alterar para v2]
    V2 --> Commit2[Commit no repo]
    Commit2 --> Sync2[Argo Sync]
    Sync2 --> Pod2[Pods com v2]
```
