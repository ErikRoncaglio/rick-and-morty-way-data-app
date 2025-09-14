# Desafio Técnico Way Data Solution - Rick and Morty App

Aplicativo desenvolvido como parte do processo seletivo para a vaga de Desenvolvedor Flutter Júnior na Way Data Solution.

O projeto consiste em um aplicativo que consome a [Rick and Morty API](https://rickandmortyapi.com/) para exibir informações sobre Personagens, Locais e Episódios da série. Foi construído com foco em arquitetura limpa, boas práticas e uma experiência de usuário rica e resiliente, indo além dos requisitos mínimos solicitados.

## ✨ Funcionalidades Implementadas

- **Navegação por Abas:** Interface principal com `BottomNavigationBar` para explorar as seções de Personagens, Locais e Episódios.
- **Scroll Infinito (Paginação):** Carregamento de dados sob demanda em todas as listas, garantindo performance e uma experiência de usuário fluida.
- **Cache Offline-First:** Após o primeiro carregamento, todos os dados visualizados ficam disponíveis para navegação mesmo sem conexão com a internet, graças ao uso do Hive.
- **Tela de Detalhes:** Navegação para uma tela de detalhes ao selecionar um personagem.
- **Filtro de Personagens:** Filtro por status (Vivo, Morto, Desconhecido) na tela de Personagens.
- **Animações de UI:**
    - Transição com `Hero` ao abrir os detalhes de um personagem.
    - Animações de entrada (`FadeIn` e `Slide`) nos itens das listas para uma interface mais dinâmica.
- **Tema Dinâmico (Claro/Escuro):** Temas claro e escuro personalizados e inspirados no universo de Rick and Morty.
- **Internacionalização (i18n):** Suporte completo para os idiomas Português e Inglês.
- **Tela de Configurações:** Permite que o usuário troque manualmente o tema e o idioma, com as escolhas salvas entre as sessões.
- **Testes Unitários:** Testes para o `CharacterProvider` garantem a confiabilidade da lógica de estado, filtros e paginação.

## 🛠️ Escolhas Técnicas

O projeto foi desenvolvido com base nas seguintes tecnologias e padrões:

- **Arquitetura:** **Clean Architecture**, para garantir um código desacoplado, testável e de fácil manutenção.
- **Gerenciamento de Estado:** **Provider**, escolhido por sua simplicidade e eficiência no gerenciamento reativo do estado da UI.
- **Banco de Dados Local:** **Hive**, selecionado para a funcionalidade de cache offline por sua alta performance.
- **Injeção de Dependência:** **GetIt**, utilizado como Service Locator para gerenciar as dependências de forma centralizada.
- **Requisições HTTP:** **Dio**, para uma comunicação robusta e flexível com a API.
- **Testes:** **Mockito**, para a criação de Mocks nos testes unitários.
- **Animações:** **flutter_animate**, para criação de animações de forma declarativa e simples.

## 🚀 Como Executar o Projeto

Para executar este projeto localmente, siga os passos abaixo:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/ErikRoncaglio/rick-and-morty-way-data-app.git
    ```

2.  **Entre na pasta do projeto:**
    ```bash
    cd rick_and_morty_way_data_app
    ```

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o gerador de código (para Hive e Mockito):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Execute o aplicativo:**
    ```bash
    flutter run
    ```

## 🧪 Executando os Testes

Para executar os testes unitários do projeto:

```bash
flutter test
```

Para executar os testes com cobertura:

```bash
flutter test --coverage
```

## 📱 Screenshots

O aplicativo inclui as seguintes telas principais:

- **Tela de Personagens** com filtro por status e scroll infinito
- **Tela de Detalhes** com animação Hero
- **Tela de Locais** com informações detalhadas
- **Tela de Episódios** organizados por temporadas
- **Tela de Configurações** para tema e idioma

## 🎯 Diferenciais Implementados

Este projeto vai além dos requisitos básicos, incluindo:

- ✅ Cache offline para experiência sem conexão
- ✅ Paginação em todas as listas
- ✅ Animações fluidas e transições
- ✅ Temas claro/escuro personalizados
- ✅ Internacionalização completa
- ✅ Testes unitários robustos
- ✅ UI responsiva e moderna
- ✅ Tratamento de estados de loading e erro

## 📦 Dependências Principais

```yaml
dependencies:
  flutter: ^3.35.3
  provider: ^6.1.2
  dio: ^5.7.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get_it: ^8.0.2
  shared_preferences: ^2.5.3
  flutter_animate: ^4.5.0
  flutter_localizations:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.13
  hive_generator: ^2.0.1
  mockito: ^5.4.4
  flutter_lints: ^5.0.0
```

## 🏗️ Estrutura do Projeto

```
lib/
├── core/
│   ├── injection/          # Injeção de dependências (GetIt)
│   └── theme/             # Temas claro e escuro
├── data/
│   ├── datasources/       # Fontes de dados (API e Cache)
│   ├── models/           # Modelos de dados
│   └── repositories/     # Implementações dos repositórios
├── domain/
│   ├── entities/         # Entidades de domínio
│   ├── repositories/     # Interfaces dos repositórios
│   └── usecases/        # Casos de uso
├── l10n/                # Arquivos de internacionalização
└── presentation/
    ├── pages/           # Telas do aplicativo
    ├── providers/       # Gerenciadores de estado
    └── widgets/         # Componentes reutilizáveis
```

## 🎨 Design System

O aplicativo utiliza um design system inspirado no universo Rick and Morty:

- **Cores:** Paleta baseada no portal interdimensional
- **Tipografia:** Fonte Roboto com hierarquia clara
- **Componentes:** Cards, botões e elementos visuais consistentes
- **Animações:** Transições suaves e feedback visual

## 💡 Próximos Passos

Possíveis melhorias futuras:

- [ ] Implementar busca por nome
- [ ] Adicionar favoritos com persistência local
- [ ] Criar widgets de gráficos para estatísticas
- [ ] Integrar analytics de uso

---

**Desenvolvido por Erik Roncaglio para Way Data Solution**
