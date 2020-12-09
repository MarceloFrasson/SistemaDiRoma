
CREATE TABLE Clientes (
       ID_Clientes          INTEGER NOT NULL,
       Cli_Nome             VARCHAR(200),
       Cli_RG               VARCHAR(20),
       Cli_CPF              VARCHAR(20),
       Cli_DataCadastro     DATE,
       Cli_Endereco         VARCHAR(200),
       Cli_Bairro           VARCHAR(40),
       Cli_CEP              VARCHAR(8),
       Cli_Telefone         VARCHAR(18),
       Cli_Celular          VARCHAR(18),
       Cli_NomeEmpresa      VARCHAR(200),
       Cli_TelefoneEmpresa  VARCHAR(18),
       Cli_ResponsavelEmpresa VARCHAR(35),
       Cli_Ativado          INTEGER,
       Cli_Observacao       VARCHAR(250),
       Cli_Email            VARCHAR(100),
       Cli_DataAtualizacao  DATE,
       Cli_Sexo             VARCHAR(10),
       Cli_EstadoCivil      VARCHAR(12),
       Cli_DataNascimento   DATE
);

CREATE UNIQUE INDEX XPKClientes ON Clientes
(
       ID_Clientes
);


ALTER TABLE Clientes
       ADD PRIMARY KEY (ID_Clientes);


CREATE TABLE Login (
       ID_Login             INTEGER NOT NULL,
       Login_Nome           VARCHAR(30),
       Login_NomeCompleto   VARCHAR(200),
       Login_Senha          VARCHAR(15),
       Login_Endereco       VARCHAR(200),
       Login_Telefone       VARCHAR(18),
       Login_Celular        VARCHAR(18),
       Login_TelefoneRecado VARCHAR(18),
       Login_Observacao     VARCHAR(250),
       Login_Data_Alteracao DATE,
       Login_Cep            VARCHAR(9)
);

CREATE UNIQUE INDEX XPKLogin ON Login
(
       ID_Login
);


ALTER TABLE Login
       ADD PRIMARY KEY (ID_Login);


CREATE TABLE Produtos (
       ID_Produtos          INTEGER NOT NULL,
       ID_Unidades          INTEGER NOT NULL,
       Prod_CodBarra        VARCHAR(30),
       Prod_Descricao       VARCHAR(80),
       Prod_UltimaVenda_Data DATE,
       Prod_UltimaCompra_Data DATE,
       Prod_Preco_Venda     NUMERIC(10,2),
       Prod_Preco_Custo     NUMERIC(10,2),
       Prod_Quantidade      NUMERIC(10,2),
       Prod_QuantidadeMinima NUMERIC(10,2),
       Prod_Observacao      VARCHAR(250)
);

CREATE UNIQUE INDEX XPKProdutos ON Produtos
(
       ID_Produtos,
       ID_Unidades
);


ALTER TABLE Produtos
       ADD PRIMARY KEY (ID_Produtos, ID_Unidades);


CREATE TABLE Unidades (
       ID_Unidades          INTEGER NOT NULL,
       Unid_Descricao       VARCHAR(80)
);

CREATE UNIQUE INDEX XPKUnidades ON Unidades
(
       ID_Unidades
);


ALTER TABLE Unidades
       ADD PRIMARY KEY (ID_Unidades);


CREATE TABLE Venda (
       ID_Venda             INTEGER NOT NULL,
       ID_Login             INTEGER NOT NULL,
       ID_Clientes          INTEGER NOT NULL,
       Venda_Data           DATE,
       Venda_Hora           TIME,
       Venda_Quantidade     NUMERIC(10,2),
       Venda_Observacao     VARCHAR(250),
       Venda_Valor          NUMERIC(10,2),
       Venda_Tipo           VARCHAR(5)
);

CREATE UNIQUE INDEX XPKVenda ON Venda
(
       ID_Venda,
       ID_Login,
       ID_Clientes
);


ALTER TABLE Venda
       ADD PRIMARY KEY (ID_Venda, ID_Login, ID_Clientes);


CREATE TABLE Venda_Itens (
       ID_Venda_Itens       INTEGER NOT NULL,
       ID_Venda             INTEGER NOT NULL,
       ID_Produtos          INTEGER NOT NULL,
       ID_Unidades          INTEGER NOT NULL,
       ID_Login             INTEGER NOT NULL,
       ID_Clientes          INTEGER NOT NULL
);

CREATE UNIQUE INDEX XPKVenda_Itens ON Venda_Itens
(
       ID_Venda_Itens,
       ID_Venda,
       ID_Produtos,
       ID_Unidades,
       ID_Login,
       ID_Clientes
);


ALTER TABLE Venda_Itens
       ADD PRIMARY KEY (ID_Venda_Itens, ID_Venda, ID_Produtos, 
              ID_Unidades, ID_Login, ID_Clientes);


ALTER TABLE Produtos
       ADD FOREIGN KEY (ID_Unidades)
                             REFERENCES Unidades;


ALTER TABLE Venda
       ADD FOREIGN KEY (ID_Login)
                             REFERENCES Login;


ALTER TABLE Venda
       ADD FOREIGN KEY (ID_Clientes)
                             REFERENCES Clientes;


ALTER TABLE Venda_Itens
       ADD FOREIGN KEY (ID_Venda, ID_Login, ID_Clientes)
                             REFERENCES Venda;


ALTER TABLE Venda_Itens
       ADD FOREIGN KEY (ID_Produtos, ID_Unidades)
                             REFERENCES Produtos;



CREATE EXCEPTION ERWIN_PARENT_INSERT_RESTRICT 'Cannot INSERT Parent table because Child table exists.';
CREATE EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT 'Cannot UPDATE Parent table because Child table exists.';
CREATE EXCEPTION ERWIN_PARENT_DELETE_RESTRICT 'Cannot DELETE Parent table because Child table exists.';
CREATE EXCEPTION ERWIN_CHILD_INSERT_RESTRICT 'Cannot INSERT Child table because Parent table does not exist.';
CREATE EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT 'Cannot UPDATE Child table because Parent table does not exist.';
CREATE EXCEPTION ERWIN_CHILD_DELETE_RESTRICT 'Cannot DELETE Child table because Parent table does not exist.';


CREATE TRIGGER tD_Clientes FOR Clientes AFTER DELETE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* DELETE trigger on Clientes */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Clientes R/5 Venda ON PARENT DELETE RESTRICT */
    select count(*)
      from Venda
      where
        /*  Venda.ID_Clientes = OLD.ID_Clientes */
        Venda.ID_Clientes = OLD.ID_Clientes into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_DELETE_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Clientes FOR Clientes AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Clientes */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Clientes R/5 Venda ON PARENT UPDATE RESTRICT */
  IF
    /* OLD.ID_Clientes <> NEW.ID_Clientes */
    (OLD.ID_Clientes <> NEW.ID_Clientes) THEN
  BEGIN
    select count(*)
      from Venda
      where
        /*  Venda.ID_Clientes = OLD.ID_Clientes */
        Venda.ID_Clientes = OLD.ID_Clientes into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT;
    END
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tD_Login FOR Login AFTER DELETE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* DELETE trigger on Login */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Login R/4 Venda ON PARENT DELETE RESTRICT */
    select count(*)
      from Venda
      where
        /*  Venda.ID_Login = OLD.ID_Login */
        Venda.ID_Login = OLD.ID_Login into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_DELETE_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Login FOR Login AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Login */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Login R/4 Venda ON PARENT UPDATE RESTRICT */
  IF
    /* OLD.ID_Login <> NEW.ID_Login */
    (OLD.ID_Login <> NEW.ID_Login) THEN
  BEGIN
    select count(*)
      from Venda
      where
        /*  Venda.ID_Login = OLD.ID_Login */
        Venda.ID_Login = OLD.ID_Login into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT;
    END
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tD_Produtos FOR Produtos AFTER DELETE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* DELETE trigger on Produtos */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Produtos R/7 Venda_Itens ON PARENT DELETE RESTRICT */
    select count(*)
      from Venda_Itens
      where
        /*  Venda_Itens.ID_Produtos = OLD.ID_Produtos and
            Venda_Itens.ID_Unidades = OLD.ID_Unidades */
        Venda_Itens.ID_Produtos = OLD.ID_Produtos and
        Venda_Itens.ID_Unidades = OLD.ID_Unidades into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_DELETE_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tI_Produtos FOR Produtos AFTER INSERT AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* INSERT trigger on Produtos */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Unidades R/2 Produtos ON CHILD INSERT RESTRICT */
    select count(*)
      from Unidades
      where
        /* NEW.ID_Unidades = Unidades.ID_Unidades */
        NEW.ID_Unidades = Unidades.ID_Unidades into numrows;
    IF (
      /*  */
      
      numrows = 0
    ) THEN
    BEGIN
      EXCEPTION ERWIN_CHILD_INSERT_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Produtos FOR Produtos AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Produtos */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Produtos R/7 Venda_Itens ON PARENT UPDATE RESTRICT */
  IF
    /* OLD.ID_Produtos <> NEW.ID_Produtos or 
       OLD.ID_Unidades <> NEW.ID_Unidades */
    (OLD.ID_Produtos <> NEW.ID_Produtos or 
     OLD.ID_Unidades <> NEW.ID_Unidades) THEN
  BEGIN
    select count(*)
      from Venda_Itens
      where
        /*  Venda_Itens.ID_Produtos = OLD.ID_Produtos and
            Venda_Itens.ID_Unidades = OLD.ID_Unidades */
        Venda_Itens.ID_Produtos = OLD.ID_Produtos and
        Venda_Itens.ID_Unidades = OLD.ID_Unidades into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT;
    END
  END

  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Unidades R/2 Produtos ON CHILD UPDATE RESTRICT */
  select count(*)
    from Unidades
    where
      /* NEW.ID_Unidades = Unidades.ID_Unidades */
      NEW.ID_Unidades = Unidades.ID_Unidades into numrows;
  IF (
    /*  */
    
    numrows = 0
  ) THEN
  BEGIN
    EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT;
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tD_Unidades FOR Unidades AFTER DELETE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* DELETE trigger on Unidades */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Unidades R/2 Produtos ON PARENT DELETE RESTRICT */
    select count(*)
      from Produtos
      where
        /*  Produtos.ID_Unidades = OLD.ID_Unidades */
        Produtos.ID_Unidades = OLD.ID_Unidades into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_DELETE_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Unidades FOR Unidades AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Unidades */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Unidades R/2 Produtos ON PARENT UPDATE RESTRICT */
  IF
    /* OLD.ID_Unidades <> NEW.ID_Unidades */
    (OLD.ID_Unidades <> NEW.ID_Unidades) THEN
  BEGIN
    select count(*)
      from Produtos
      where
        /*  Produtos.ID_Unidades = OLD.ID_Unidades */
        Produtos.ID_Unidades = OLD.ID_Unidades into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT;
    END
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tD_Venda FOR Venda AFTER DELETE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* DELETE trigger on Venda */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Venda R/6 Venda_Itens ON PARENT DELETE RESTRICT */
    select count(*)
      from Venda_Itens
      where
        /*  Venda_Itens.ID_Venda = OLD.ID_Venda and
            Venda_Itens.ID_Login = OLD.ID_Login and
            Venda_Itens.ID_Clientes = OLD.ID_Clientes */
        Venda_Itens.ID_Venda = OLD.ID_Venda and
        Venda_Itens.ID_Login = OLD.ID_Login and
        Venda_Itens.ID_Clientes = OLD.ID_Clientes into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_DELETE_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tI_Venda FOR Venda AFTER INSERT AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* INSERT trigger on Venda */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Login R/4 Venda ON CHILD INSERT RESTRICT */
    select count(*)
      from Login
      where
        /* NEW.ID_Login = Login.ID_Login */
        NEW.ID_Login = Login.ID_Login into numrows;
    IF (
      /*  */
      
      numrows = 0
    ) THEN
    BEGIN
      EXCEPTION ERWIN_CHILD_INSERT_RESTRICT;
    END

    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Clientes R/5 Venda ON CHILD INSERT RESTRICT */
    select count(*)
      from Clientes
      where
        /* NEW.ID_Clientes = Clientes.ID_Clientes */
        NEW.ID_Clientes = Clientes.ID_Clientes into numrows;
    IF (
      /*  */
      
      numrows = 0
    ) THEN
    BEGIN
      EXCEPTION ERWIN_CHILD_INSERT_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Venda FOR Venda AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Venda */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Venda R/6 Venda_Itens ON PARENT UPDATE RESTRICT */
  IF
    /* OLD.ID_Venda <> NEW.ID_Venda or 
       OLD.ID_Login <> NEW.ID_Login or 
       OLD.ID_Clientes <> NEW.ID_Clientes */
    (OLD.ID_Venda <> NEW.ID_Venda or 
     OLD.ID_Login <> NEW.ID_Login or 
     OLD.ID_Clientes <> NEW.ID_Clientes) THEN
  BEGIN
    select count(*)
      from Venda_Itens
      where
        /*  Venda_Itens.ID_Venda = OLD.ID_Venda and
            Venda_Itens.ID_Login = OLD.ID_Login and
            Venda_Itens.ID_Clientes = OLD.ID_Clientes */
        Venda_Itens.ID_Venda = OLD.ID_Venda and
        Venda_Itens.ID_Login = OLD.ID_Login and
        Venda_Itens.ID_Clientes = OLD.ID_Clientes into numrows;
    IF (numrows > 0) THEN
    BEGIN
      EXCEPTION ERWIN_PARENT_UPDATE_RESTRICT;
    END
  END

  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Login R/4 Venda ON CHILD UPDATE RESTRICT */
  select count(*)
    from Login
    where
      /* NEW.ID_Login = Login.ID_Login */
      NEW.ID_Login = Login.ID_Login into numrows;
  IF (
    /*  */
    
    numrows = 0
  ) THEN
  BEGIN
    EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT;
  END

  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Clientes R/5 Venda ON CHILD UPDATE RESTRICT */
  select count(*)
    from Clientes
    where
      /* NEW.ID_Clientes = Clientes.ID_Clientes */
      NEW.ID_Clientes = Clientes.ID_Clientes into numrows;
  IF (
    /*  */
    
    numrows = 0
  ) THEN
  BEGIN
    EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT;
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tI_Venda_Itens FOR Venda_Itens AFTER INSERT AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* INSERT trigger on Venda_Itens */
DECLARE VARIABLE numrows INTEGER;
BEGIN
    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Venda R/6 Venda_Itens ON CHILD INSERT RESTRICT */
    select count(*)
      from Venda
      where
        /* NEW.ID_Venda = Venda.ID_Venda and
           NEW.ID_Login = Venda.ID_Login and
           NEW.ID_Clientes = Venda.ID_Clientes */
        NEW.ID_Venda = Venda.ID_Venda and
        NEW.ID_Login = Venda.ID_Login and
        NEW.ID_Clientes = Venda.ID_Clientes into numrows;
    IF (
      /*  */
      
      numrows = 0
    ) THEN
    BEGIN
      EXCEPTION ERWIN_CHILD_INSERT_RESTRICT;
    END

    /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
    /* Produtos R/7 Venda_Itens ON CHILD INSERT RESTRICT */
    select count(*)
      from Produtos
      where
        /* NEW.ID_Produtos = Produtos.ID_Produtos and
           NEW.ID_Unidades = Produtos.ID_Unidades */
        NEW.ID_Produtos = Produtos.ID_Produtos and
        NEW.ID_Unidades = Produtos.ID_Unidades into numrows;
    IF (
      /*  */
      
      numrows = 0
    ) THEN
    BEGIN
      EXCEPTION ERWIN_CHILD_INSERT_RESTRICT;
    END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

CREATE TRIGGER tU_Venda_Itens FOR Venda_Itens AFTER UPDATE AS
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* UPDATE trigger on Venda_Itens */
DECLARE VARIABLE numrows INTEGER;
BEGIN
  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Venda R/6 Venda_Itens ON CHILD UPDATE RESTRICT */
  select count(*)
    from Venda
    where
      /* NEW.ID_Venda = Venda.ID_Venda and
         NEW.ID_Login = Venda.ID_Login and
         NEW.ID_Clientes = Venda.ID_Clientes */
      NEW.ID_Venda = Venda.ID_Venda and
      NEW.ID_Login = Venda.ID_Login and
      NEW.ID_Clientes = Venda.ID_Clientes into numrows;
  IF (
    /*  */
    
    numrows = 0
  ) THEN
  BEGIN
    EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT;
  END

  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
  /* Produtos R/7 Venda_Itens ON CHILD UPDATE RESTRICT */
  select count(*)
    from Produtos
    where
      /* NEW.ID_Produtos = Produtos.ID_Produtos and
         NEW.ID_Unidades = Produtos.ID_Unidades */
      NEW.ID_Produtos = Produtos.ID_Produtos and
      NEW.ID_Unidades = Produtos.ID_Unidades into numrows;
  IF (
    /*  */
    
    numrows = 0
  ) THEN
  BEGIN
    EXCEPTION ERWIN_CHILD_UPDATE_RESTRICT;
  END


  /* ERwin Builtin Mon Sep 18 21:58:43 2006 */
END 

