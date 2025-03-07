# Projeto de Prática Profissional em ADS

## 1. Diagrama de casos de uso

![image](https://github.com/user-attachments/assets/9c9ddec3-b1f8-4f6e-a022-a4a6c8ee336a)

## 2. Descrições dos casos de uso

### 2.1. Configurar lembretes (CDU001)
**Ator:** Usuário

**Descrição**: O usuário define intervalos para lembretes de alongamento, postura e hidratação.

#### Fluxo principal:

1. Acessa configurações.
2. Define frequência de lembretes.
3. Salva preferências.
4. Sistema armazena e inicia lembretes.

### Fluxo de exceção:

- Em caso de erro, o sistema exibe mensagem solicitando nova tentativa.

### 2.2. Receber e confirmar lembretes (CDU002)
**Atores:** Usuário, API Externa

**Descrição**: O sistema envia notificações conforme a configuração.

#### Fluxo principal:

1. Exibe lembrete.
2. Usuário confirma conclusão.
3. Sistema registra no histórico.

### Fluxo de exceção:

- Se o usuário não interagir, sistema reenvia após intervalo.

### 2.3. Consultar Histórico e Exportar Dados (CDU003)
**Ator:** Usuário

**Descrição**: Usuário visualiza e exporta histórico de hábitos.

#### Fluxo principal:

1. Acessa histórico.
2. Filtra por data ou tipo.
3. Exporta dados (CSV ou PDF).

### Fluxo de exceção:

- Se ocorrer erro, exibe mensagem e sugere tentar novamente.

### 2.4. Gerenciar Lembretes (CDU004)
**Ator:** Usuário

**Descrição**: Usuário altera ou exclui lembretes configurados.

#### Fluxo principal:

1. Acessa configurações.
2. Edita ou remove lembrete.
3. Salva alterações.

### Fluxo de exceção:

- Em caso de erro, exibe mensagem informativa.

### 2.5. Visualizar Estatísticas de Uso (CDU005)
**Atores:** Usuário, API Externa

**Descrição**: Usuário visualiza gráficos com hábitos concluídos.

#### Fluxo principal:

1. Acessa estatísticas.
2. Sistema exibe gráficos e dados.

### Fluxo de exceção:

- Se não houver dados, exibe mensagem informativa.

### 2.6. Visualizar Estatísticas de Uso (CDU006)
**Atores:** Usuário, Administrador

**Descrição**: Atualização de perfil, senha e preferências.

#### Fluxo principal:

1. Acessa gerenciamento de conta.
2. Altera dados necessários.
3. Salva alterações.

### Fluxo de exceção:

- Em caso de erro, exibe mensagem solicitando nova tentativa.

### 2.7. Gerenciar Sistema (CDU007)
**Ator:** Administrador

**Descrição**: Administrador pode ajustar configurações globais, resolver problemas e monitorar desempenho.

#### Fluxo principal:

1. Acessa painel administrativo.
2. Realiza ajustes ou verifica logs.
3. Salva configurações.

### Fluxo de exceção:

- Se ocorrer erro, sistema registra e notifica administrador.

### 2.8. Sincronizar com API Externa (CDU008)
**Ator:** API Externa

**Descrição**: Integração com APIs para dicas de saúde e dados adicionais.

#### Fluxo principal:

1. Solicita dados à API.
2. Recebe e exibe dicas para o usuário.
3. Armazena dados no histórico.

### Fluxo de exceção:

- Se falha na comunicação, exibe mensagem de erro.

## 3. Modelo de domínio

![image](https://github.com/user-attachments/assets/8edad18a-ab83-4df0-a4fe-3516554ef2bb)

## 4. Diagramas de sequência

#### 4.1. Configurar lembretes (CDU001):

![image](https://github.com/user-attachments/assets/19f17c44-2cba-4c64-8f6c-8e74c133614e)

#### 4.2. Receber e confirmar lembretes (CDU002):

![image](https://github.com/user-attachments/assets/69397e38-24f2-4a55-ad74-9684fd1ad25b)

#### 4.3. Consultar Histórico e Exportar Dados (CDU003):

![image](https://github.com/user-attachments/assets/b82e693f-46a8-4fa5-9296-a0a5a628d701)

#### 4.4. Gerenciar Lembretes (CDU004):

![image](https://github.com/user-attachments/assets/ddf466b9-27ba-4ee2-807e-30dbd24eeacb)

#### 4.5. Visualizar Estatísticas de Uso (CDU005):

![image](https://github.com/user-attachments/assets/0c4f090d-fe0a-445f-baf3-a3f510b1be2e)

#### 4.6. Gerenciar Conta do Usuário (CDU006):

![image](https://github.com/user-attachments/assets/657a54e5-b2d2-4df1-9068-1ca0445db043)

#### 4.7. Gerenciar Sistema (CDU007):

![image](https://github.com/user-attachments/assets/b7fdbfc4-6ef3-4543-bae8-ade2ab485d38)

#### 4.8. Sincronizar com API Externa (CDU008):

![image](https://github.com/user-attachments/assets/efbf64d1-fd67-4a87-94b9-31ec4279ace9)

## 5. Diagrama de classes de projeto

![image](https://github.com/user-attachments/assets/c2887624-264c-4e53-882e-1529e7492a49)
