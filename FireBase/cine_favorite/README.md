# CineFavorite (Formativa)

### Briefing
Construir um Aplicativo do Zero - O CineFavorite que permitirá criar uma conta e buscar filmes em uma API, montar uma galeria pessoal de filmes favoritos, com poster (capa) e nota avaliativa do usuário para o filme.

## Objetivos
- Criar uma Galeria Personalizada por Usuário de Filmes Favoritos
- Buscar Filmes em uma API e Listar para Selecionar Filmes Favoritos
- Criação de Contas por Usuário
- listar Filmes por Palavra-Chave

## Levantamento de Requisitos
- ### Requisitos Funcionais
- ### Requisitos Não-Funcionais

## Recursos do projeto
- Linguagem de Programação: Flutter/Dart
- API TMDB : Base de Dados para Filmes
- Figma para Prototipagem
- GitHub para Armazenamento e Versionamento do Código 
- FireBase: Authentication / FireStore DB
- VScode: Codificação / Teste

## Diagramas
1. ### Classe:
Demonstrar o Funcionamento das Entidades do Sistema
- Usuário (user): Classe já Modelada pelo FireBaseAuth
    - Atributos: email, senha, uid
    - Métodos: login, registrar, logout

- Filmes Favoritos (movie): Classe Modelada pelo DEV - baseada na API TMDB
    - Atributos: id, título, PosterPath, Nota
    - Métodos: Adicionar, Remover, Listar e AtualizarNota (CRUD)

```mermaid

classDiagram

    class User{
        +String uid,
        +String email,
        +String password
        +login()
        +logout()
        +register()
    }

    class Movie {
        +int id
        +String title
        +String posterPath
        +double rating
        +addFavorite()
        +removeFavorite()
        +updateMovieRating()
        +getFavoriteMovies()
    }

    User "1"--"1+" Movie : "select"

```

2. ### Uso
Ação que os Atores podem Fazer
- Usuário: 
    - Registrar
    - Login
    - Logout
    - Procurar Filmes na API
    - Salvar Filmes aos Favoritos
    - Dar Nota aos Filmes Favoritos
    - Remover Filmes dos Favoritos

```mermaid

graph TD
    subgraph "Ações"
    ac1([registrar])
    ac2([login])
    ac3([logout])
    ac4([SearchMovie])
    ac5([AddFavoriteMovie])
    ac6([UpdateMovieRating])
    ac7([RemoveFavoriteMovie])
end

user([Usuário])

user --> ac1
user --> ac2

ac1 --> ac2
ac2 --> ac3
ac2 --> ac4
ac2 --> ac5
ac2 --> ac6
ac2 --> ac7

```

3. ### Fluxo
Determinar o Caminho Percorrido pelo Ator para executar uma Ação

- Fluxo da Ação de Login

```mermaid

    A[Início] --> B{Tela de Login}
    B --> C[Inserir Email e Senha]
    C --> D{Validar as Credenciais}
    D --> Sim --> G[FavoriteView]
    D --> Não --> B

```

## Prototipagem

Link dos Protótipos: 