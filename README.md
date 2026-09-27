# Gerenciador de Tarefas (Flutter)

Aplicativo mobile simples para gerenciamento de tarefas pendentes, desenvolvido para a
atividade prática de Desenvolvimento Mobile. As tarefas são mantidas apenas em memória
durante a execução (sem persistência).

## Funcionalidades

- Cadastrar tarefas com título e descrição.
- Listar todas as tarefas, com indicação visual clara de status (checkbox + texto riscado
  para tarefas concluídas).
- Marcar tarefa como concluída e voltar para pendente (checkbox).
- Excluir tarefa, com confirmação antes da exclusão.
- Validação: não permite cadastrar tarefa com título ou descrição vazios, exibindo uma
  mensagem orientando o preenchimento.

## Requisito extra implementado

Foram implementados dois requisitos extras:

- **Filtrar tarefas pendentes/concluídas**: barra de segmentos (Todas / Pendentes / Concluídas)
  logo abaixo do topo da tela.
- **Contador de tarefas**: contagem de pendentes e concluídas exibida no topo da lista.
- **Confirmação antes de excluir**: diálogo de confirmação ao tentar excluir uma tarefa.

## Como executar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e
configurado (`flutter doctor` sem erros).

```bash
# 1. Clonar o repositório
git clone <URL_DO_REPOSITORIO>
cd task_manager

# 2. Instalar as dependências
flutter pub get

# 3. Executar (com um emulador/dispositivo conectado)
flutter run
```

## Estrutura do projeto

```
task_manager/
├── lib/
│   └── main.dart      # Toda a lógica e interface do app
├── pubspec.yaml        # Dependências e configuração do projeto
└── README.md
```
