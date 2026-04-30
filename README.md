## Descrição do Projeto
Aplicativo Flutter para encurtamento de URLs, mantendo um histórico somente em memória das últimas conversões. O projeto foca em iOS e Android, utiliza `flutter_bloc` para gerenciamento de estado, integrações HTTP com `dio`, injeção de dependências via `get_it`/`injectable`, internacionalização com `gen_l10n` (EN/PT-BR) e tema próprio inspirado no design Nubank.

## Estrutura do Projeto
- `lib/main.dart`: bootstrap do app, configuração de tema, orientação e rotas.
- `lib/app/di/`: configuração do `GetIt` (`injection.dart`, `injection.config.dart`).
- `lib/core/`: utilitários compartilhados (tema, serviços, erros, result, endpoints).
- `lib/l10n/`: arb e classes geradas para internacionalização.
- `lib/features/link_shortener/`
  - `domain/`: entidades (`short_link.dart`), value objects (`alias.dart`, `url_to_shorten.dart`), contratos (`alias_repository.dart`) e casos de uso (`shorten_url.dart`, `get_alias.dart`).
  - `data/`: DTO (`short_link_dto.dart`) e repositório (`alias_repository_impl.dart`) que consome a API REST.
  - `presentation/`: página principal (`link_shortener_page.dart`), Cubit (`link_shortener_controller.dart`, `link_shortener_state.dart`) e widgets reutilizáveis.
- `android/` e `ios/`: projetos nativos.
- `test/`: cenário de testes organizado espelhando camadas (core, data, domain, presentation) e utilitários em `test_utils/`.

## Arquitetura
- Clean Architecture com separação clara por camadas:
  - **Domínio** puro, sem dependências externas, encapsulando regras de validação com value objects e `Either`.
  - **Dados** implementando `IAliasRepository` com `dio`, DTOs e `DioErrorHandler` convertendo erros em `Failure`.
  - **Apresentação** baseada em `Cubit` (`LinkShortenerController`) e `BlocBuilder/BlocSelector` para atualizar a UI de forma reativa.
- Inversão de dependência garantida por:
  - Interfaces no domínio (`IAliasRepository`) e pela abstração `LinkOpener`, permitindo testes com mocks.
  - Injeção via `injectable` gerando `injection.config.dart`.
- Internacionalização integrada ao MaterialApp com suporte a inglês e português (Brasil).

 ## 🏛️ Decisões Arquiteturais e Trade-Offs

Para este desafio, a arquitetura foi desenhada com foco em **escalabilidade, testabilidade e manutenibilidade**, simulando um ambiente de produção real. Abaixo estão as principais decisões e os compromissos (*trade-offs*) assumidos:

#### 1. Clean Architecture & Feature First
Optei por uma estrutura baseada em **Clean Architecture**, combinada com a organização de pastas por *Feature*.
* **Decisão:** Separar o projeto em camadas lógicas bem definidas (*Data*, *Domain* e *Presentation*).
* **Trade-off:** Em um aplicativo de apenas uma tela, essa estrutura pode parecer um pouco densa inicialmente. No entanto, como o objetivo do desafio é justamente avaliar a capacidade arquitetural, utilizei essa abordagem para demonstrar a minha visão de como um projeto sólido deve ser estruturado. O maior ganho é garantir que a regra de negócio fique totalmente isolada e agnóstica em relação a frameworks (UI) ou APIs externas.

#### 2. Value Objects para Validação de Domínio
Em vez de tratar URLs e Aliases como simples `Strings`, utilizei **Value Objects** (`UrlToShorten` e `Alias`).
* **Decisão:** A validação ocorre no momento da criação do objeto de domínio, impedindo que dados inválidos fluam para as camadas de Repositório ou Caso de Uso.
* **Trade-off:** Isto aumenta a verbosidade inicial (mais classes), mas garante o princípio de *Always Valid Domain Model*, reduzindo drasticamente a necessidade de verificações (`if/else`) espalhadas pela UI ou controladores.

#### 3. Tratamento Funcional de Erros (Pattern Either)
Utilizei o padrão de **Programação Funcional** através da estrutura `Either` para lidar com fluxos de erro.
* **Decisão:** Em vez de utilizar o padrão `try/catch` tradicional, que se baseia em efeitos colaterais e exceções que podem não ser capturadas, o erro é tratado como um valor de retorno explícito.
* **Trade-off:** Exige uma curva de aprendizagem levemente maior, mas torna as falhas explícitas na assinatura dos métodos, obrigando o desenvolvedor a lidar com o cenário de erro na camada de apresentação de forma segura.

#### 4. Gestão de Estado com Cubit
Escolhi o **Cubit** (do ecossistema `flutter_bloc`) para a gestão de estado.
* **Decisão:** O Cubit oferece a reatividade necessária para uma interface dinâmica com menos *boilerplate* que o Bloc tradicional.
* **Trade-off:** Para fluxos extremamente complexos com muitas transformações de eventos, o Bloc seria superior. Para este escopo, o Cubit oferece o equilíbrio perfeito entre simplicidade, performance e separação de lógica.

#### 5. Inversão de Dependência e Testabilidade
Todas as dependências externas (Dio, LinkOpener, Repositories) são injetadas através de interfaces (abstrações).
* **Decisão:** Utilizei o `get_it` com `injectable` para garantir que o código dependa de contratos e não de implementações concretas.
* **Trade-off:** Adiciona uma etapa de geração de código ao processo de desenvolvimento, mas em troca, permite uma cobertura de testes unitários e de UI de 100%, já que qualquer componente pode ser facilmente substituído por um *Mock* ou *Fake*.

#### 6. UX: Promoção de Duplicados (Product Mindset)
Implementei uma lógica de verificação de duplicados diretamente no controlador (`_checkDuplicateAndPromote`).
* **Decisão:** Se o utilizador tentar encurtar uma URL que já consta na sua lista histórica, a aplicação não gera um erro nem faz uma nova chamada à API; apenas move o item existente para o topo da lista.
* **Trade-off:** Adiciona uma pequena complexidade lógica no Cubit, mas melhora significativamente a experiência do utilizador e economiza recursos de rede e processamento no servidor.

## Objetivo
Fornecer uma experiência simples e responsiva para encurtar URLs, copiar/abrir os links gerados e gerenciar o histórico recente diretamente no dispositivo móvel.

## Testes
- **Cobertura atual**:
  - Domínio: validação de URLs (`url_to_shorten_test.dart`) e aliases (`alias_test.dart`).
  - Core: mapeamento de `DioException` em `Failure` (`dio_error_handler_test.dart`).
  - Dados: DTO e repositório (`short_link_dto_test.dart`, `alias_repository_impl_test.dart`).
  - Casos de uso: `ShortenUrl` (`shorten_url_test.dart`).
  - Apresentação: Cubit (`link_shortener_controller_test.dart`) e widget principal (`link_shortener_page_test.dart`).
- **Execução**:
  ```bash
  flutter pub get
  flutter test --reporter expanded
  ```
  > Observação: em ambientes restritos (como sandboxes), o Flutter pode exigir permissões extras para atualizar o cache (`engine.stamp`). Execute os testes localmente se necessário.

## 🧩 Como executar o projeto

Esta seção descreve o processo completo de configuração e execução do projeto **URL Shortener**, incluindo limpeza de cache, geração de código, internacionalização e análise estática.

### 🔧 1. Limpeza do projeto
Antes de iniciar, é recomendado limpar artefatos antigos e dependências locais:

```bash
flutter clean
flutter pub cache clean
```

💡 O segundo comando (`flutter pub cache clean`) remove **todas as dependências** salvas globalmente. Você precisará rodar `flutter pub get` novamente em cada projeto depois disso.

### 📦 2. Instalar dependências
Após a limpeza, reinstale as dependências do projeto:

```bash
flutter pub get
```

### ⚙️ 3. Gerar código com build_runner
O projeto utiliza **injeção de dependências (Injectable)** e **anotações automáticas**, portanto é necessário gerar os arquivos auxiliares:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

🔄 Esse comando executa o gerador de código e remove automaticamente arquivos antigos conflitantes.

### 🌍 4. Gerar arquivos de internacionalização (l10n)
O projeto possui suporte a múltiplos idiomas (localização automática via `flutter gen-l10n`):

```bash
flutter gen-l10n
```

### 🧹 5. Verificar qualidade do código
Rode o analisador estático para garantir que não há violações de lint ou problemas de estilo:

```bash
flutter analyze
```

✅ Se tudo estiver correto, você verá a mensagem:
```
Analyzing url_shortener...
No issues found!
```

### 🧪 6. Executar testes automatizados
Para validar a funcionalidade e a estabilidade do código, execute todos os testes unitários e de interface:

```bash
flutter test --reporter expanded
```

🧠 O parâmetro `--reporter expanded` fornece uma saída detalhada, útil para depuração durante o desenvolvimento.

### 🏁 Resumo rápido
```bash
flutter clean
flutter pub cache clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test --reporter expanded
```

### 💡 Dica adicional
Caso o projeto esteja sendo preparado para submissão (por exemplo, em um desafio técnico), você pode reduzir o tamanho da pasta com segurança executando:

```bash
rm -rf build .dart_tool ios/Pods ios/.symlinks android/.gradle
```

Assim, o tamanho final do projeto fica entre **40 MB e 90 MB**, sem afetar o funcionamento.
