Envio de Fotos 📷

Este projeto Flutter permite aos usuários capturar e enviar imagens para um servidor. Ele foi desenvolvido com foco em praticidade e eficiência no processo de upload de fotos.

🚀 Funcionalidades

Tirar fotos usando a câmera do dispositivo 📸

Selecionar imagens da galeria 🖼️

Redimensionar imagens para reduzir o tamanho antes do envio 📏

Enviar múltiplas imagens para o servidor com um número de pedido associado ☁️

Interface intuitiva e responsiva 🖥️📱

🛠️ Tecnologias Utilizadas

Flutter 🐦 - Framework para desenvolvimento multiplataforma.

image_picker - Para seleção de imagens da galeria e câmera.

http - Para requisições HTTP.

image - Para manipulação e compressão de imagens.

path_provider - Para acessar diretórios do dispositivo.


📝 Como Usar

Insira o número do pedido no campo de texto.

Selecione imagens da galeria ou tire novas fotos com a câmera.

Visualize as imagens selecionadas na tela.

Clique em "Enviar Imagens" para fazer o upload das fotos ao servidor.

🌐 Configuração do Servidor

O aplicativo envia imagens para o seguinte endpoint:

POST http://seu ip servidor:5000/upload

Certifique-se de que o servidor esteja rodando e acessível na mesma rede do dispositivo.

O corpo da requisição inclui:

orderNumber: Número do pedido inserido pelo usuário.

image_0, image_1, ...: Arquivos de imagem compactados e renomeados com base no número do pedido.

📁 Estrutura do Projeto

lib/
├── main.dart            # Arquivo principal com toda a lógica de UI e envio de imagens.
└── ...                  # Outros arquivos e dependências.

🧪 Possíveis Melhorias

Implementação de barra de progresso durante o upload 📊

Suporte a múltiplas seleções simultâneas da galeria 🗂️

Tela de confirmação após o envio ✅

Armazenamento local das últimas imagens enviadas 💾

📜 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

🙌 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

📧 Contato

Para dúvidas ou sugestões, entre em contato:
https://github.com/weslley-larroza
🚀 Vamos enviar algumas fotos! 📤✨
![image](https://github.com/user-attachments/assets/e5434be3-5f68-455f-8e7f-6db2ef3c9e8a)
![image](https://github.com/user-attachments/assets/81f002f1-e42e-4046-8f29-ee208c63cb35)

