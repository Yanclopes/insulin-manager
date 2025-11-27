# InsuGuia

InsuGuia é um aplicativo desenvolvido para auxiliar médicos no cálculo de doses de insulina para pacientes diabéticos, oferecendo um fluxo rápido, seguro e acessível de consulta e registro. O objetivo principal é agilizar o processo de prescrição e garantir precisão nas decisões clínicas.

## 🩺 Funcionalidades Principais

* **Cálculo automatizado de doses de insulina** com base em parâmetros captados dos pacientes pelo médico.
* **Persistência de dados via Firebase**, garantindo segurança, escalabilidade e sincronização em tempo real.
* **Cache local nativo do Firebase**, permitindo que o app funcione mesmo sem conexão à internet.
* **Sincronização automática** dos dados assim que o dispositivo volta a ficar online.
* **Interface moderna e responsiva**.

## 📱 Tecnologias Utilizadas

* **Flutter**: Framework principal utilizado para o desenvolvimento multiplataforma.
* **Firebase Authentication**: Gerenciamento de usuários e login seguro.
* **Firebase Firestore**: Banco de dados NoSQL para armazenamento dos dados da aplicação.
* **Firebase Offline Persistence**: Cache nativo do Firestore para operação offline.

## 🔌 Funcionamento do Cache Offline

O Firestore conta com um sistema nativo de **persistência offline**, que foi habilitado na aplicação. Isso permite:

* Acesso local aos dados anteriormente carregados, mesmo sem internet.
* Escrita de novos dados offline, com armazenamento no cache.
* Envio automático das alterações ao servidor Firebase quando a conexão for restaurada.

Essa funcionalidade proporciona maior confiabilidade em ambientes clínicos, onde a conexão pode ser limitada ou instável.

## 🚀 Instalação e Execução

1. Clone este repositório:

```bash
git clone https://github.com/Yanclopes/insulin-manager.git
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Configure o Firebase no aplicativo (Android/iOS/Web) seguindo a documentação oficial.
4. Execute o projeto:

```bash
flutter run
```