# Aplicativo de Fluxo de Caixa
Um aplicativo de fluxo de caixa desenvolvido em Flutter. Embora ainda esteja em fase de desenvolvimento e não esteja 100% finalizado, esse projeto foi criado como parte de um estudo aprofundado em Flutter, priorizando o conhecimento nessa tecnologia, bem como no armazenamento local e na estruturação de projetos.

O objetivo principal deste aplicativo é atender às necessidades de empresas de pequeno porte, fornecendo uma ferramenta eficiente para o acompanhamento de despesas e receitas. Com ele, o usuário poderá registrar e monitorar suas transações financeiras de maneira organizada e intuitiva.

A solução oferece recursos personalizáveis, permitindo que o usuário crie categorias e descrições personalizadas para suas transações, adaptando o aplicativo às suas necessidades específicas. Além disso, o aplicativo fornece relatórios abrangentes, oferecendo uma visão detalhada das finanças do usuário e facilitando a análise e a tomada de decisões.

Embora estejamos constantemente aprimorando o aplicativo, a versão atual já oferece uma experiência significativa para o usuário, ajudando-o a manter suas finanças em ordem.

## Funcionalidades
O aplicativo de fluxo de caixa possui as seguintes funcionalidades:
- Tela "Fluxo de caixa", com informações de despesas e receitas cadastradas. Está tela possuí filtros de datas. além de filtro de tipo de categoria.
- Tela "Adicionar movimentação", possuí um formulário bem detalhado para armazenar uma transação.
- Tela "Atualizar movimentação", neste espaço é possível visualizar informações sobre um determinado item, assim como edita-lo.
- Tela "Resumo do fluxo de caixa", todas informações do fluxo de caixa pode ser visualizada nesta tela, as informações são filtradas por ano e detalhadas por mês.
- Tela "Categoria", visão das categorias salvar, também possuí um formulário para adicionar uma nova categoria.
- Tela "Atualizar categoria", editar o nome ou tipo de uma categoria, também é possível excluir uma categoria.
- Tela "Descrições", local onde é adicionado uma descrição, neste processo o mesmo é vinculado a uma categoria.
- Tela "Atualizar descrição", editar ou excluir uma determinada descrição.

## Armazenamento local
O aplicativo usa o armazenamento local para salvar as transações. As transações são armazenadas em um banco de dados local, permitindo que o usuário acesse seus dados mesmo quando estiver offline.

## Próximos passos
Ainda resta um longo caminho para conclusão, seguem lista de funcionalidades a ser acrescentadas:
- Adicionar tela "Home" onde será possível ver o resumo de todas atividades do aplicativo.
- Adicionar tela "Meus pedidos", adicionar um pedido e exporta-lo no formato PDF, assim como a visualização dos mesmos.
- Adicionar tela "Produtos", criar uma lista de produtos que possam ser importados ao gerar um pedido.
- Autenticação de usuários.
- Integração com a nuvem para garantir a acessibilidade dos dados em diversos dispositivos, porém com foco no conceito "offline first", que permite o acesso mesmo em situações em que não há conexão com a internet.

## Instalação
Para executar o aplicativo em sua máquina, siga os passos abaixo:

1. Clone este repositório:
`git clone https://github.com/carloscallejas91/cash_flow.git`

2. Entre no diretório do projeto:
`cd PATH\cash_flow`

3. Instale as dependências:
`flutter pub get`

4. Execute o aplicativo:
`flutter run`

## Visualização
De uma forma resumida o aplicativo funciona desta forma:

https://user-images.githubusercontent.com/55441808/232160568-f0ce6ed1-2c77-43b8-bed0-01596085b196.mp4


![cashflow_plus](https://github.com/carloscallejas91/cash_flow/assets/55441808/81f53fd4-8097-4638-9ad3-124eb93e3b78)
