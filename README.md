# FlutterFaro Quest Arena — Cliente Flutter + Flame

Quest Arena é um jogo 2D de **multijogador em tempo real** construído em Flutter com o game engine Flame.  
O objetivo é conectar um cliente Flutter à infraestrutura de servidor já existente e criar uma experiência jogável com mapa em grid, jogadores, NPCs, itens, quests e salas de tesouro.

Este projeto foi desenvolvido numa atividade organizada pelos **Google Developers / GDG Faro**, focada em jogos com Flutter e Flame e em arquiteturas cliente-servidor em tempo real.

---

## Índice

- [Descrição do Jogo](#descrição-do-jogo)
- [Requisitos](#requisitos)
- [Como Executar](#como-executar)
- [Mecânicas de Jogo](#mecânicas-de-jogo)
  - [Mapa e Tiles](#mapa-e-tiles)
  - [Jogadores](#jogadores)
  - [NPCs](#npcs)
  - [Itens e Efeitos](#itens-e-efeitos)
  - [Quests e Enigmas](#quests-e-enigmas)
  - [Salas de Tesouro](#salas-de-tesouro)
- [Implementação Técnica](#implementação-técnica)
  - [Networking e Modelos de Dados](#networking-e-modelos-de-dados)
  - [Estado com Riverpod](#estado-com-riverpod)
  - [FlameGame, Worlds e Câmara](#flamegame-worlds-e-câmara)
  - [Componentes Principais do Jogo](#componentes-principais-do-jogo)
  - [UI e Overlays em Flutter](#ui-e-overlays-em-flutter)
- [Protocolo de Comunicação com o Servidor](#protocolo-de-comunicação-com-o-servidor)
- [O que Aprendi a Construir este Jogo](#o-que-aprendi-a-construir-este-jogo)
- [Recursos e Links Úteis](#recursos-e-links-úteis)
- [Licença](#licença)

---

## Descrição do Jogo

Quest Arena é um jogo de **aventura multiplayer em grelha 20x20**, em tempo real, onde equipas competem e colaboram para:

- Explorar um mapa com **paredes, portas, gemas, hazards e armadilhas**.
- Falar com **NPCs** (guards, hunters, etc.) para obter dicas, quests e diálogos.
- Apanhar e **usar itens** (poções, chaves douradas, scrolls, compass, traps).
- Resolver **quests e enigmas (riddles)** para ganhar score.
- Entrar em **salas de tesouro** temporárias para obter recompensas extra.

O servidor é **autoritativo**: envia “snapshots” periódicos com o estado completo do jogo, e o cliente Flutter/Flame apenas renderiza o estado e envia ações do jogador (movimento, interação com NPCs, resposta a quests, uso de itens).

---

## Requisitos

- Flutter SDK instalado  
  - Guia oficial: https://docs.flutter.dev/get-started/install
- Dart SDK (incluído com Flutter).
- Navegador moderno (para correr com `-d chrome`) ou dispositivo/emulador suportado.
- URL do servidor Quest Arena (fornecido na atividade / workshop).

