CREATE DATABASE IF NOT EXISTS hospital_db;

USE hospital_db;

DROP TABLE IF EXISTS prescricoes;
DROP TABLE IF EXISTS consultas;
DROP TABLE IF EXISTS internacoes;
DROP TABLE IF EXISTS quartos;
DROP TABLE IF EXISTS medicos;
DROP TABLE IF EXISTS pacientes;

-- Tabela Pacientes
create table if not exists pacientes(
    id_paciente int auto_increment primary key,
    nome_paciente varchar(100) not null,
    cpf char(14) not null unique,
    data_nascimento date not null,
    telefone_paciente char(15),
    convenio char(50) not null
) ENGINE=InnoDB;

-- Tabela Medicos
create table if not exists medicos(
    id_medico int auto_increment primary key,
    nome_medico char(100) not null,
    crm char(12) not null unique,
    especialidade char(50) not null
) ENGINE=InnoDB;

-- Tabela Quartos
create table if not exists quartos(
    id_quarto int auto_increment primary key,
    numero_quarto char(3) not null unique,
    andar char(3) not null,
    tipo_quarto char(30) not null,
    status_quarto char(20) not null default 'Livre'
) ENGINE=InnoDB;

-- Tabela Internacoes Relacionamento com Pacientes e Quartos
create table if not exists internacoes(
    id_internacao int auto_increment primary key,
    id_paciente int not null,
    id_quarto int not null,
    data_entrada date not null,
    data_saida date,
    valor_diaria decimal(10,2) not null,
    foreign key (id_quarto)   references quartos(id_quarto),
    foreign key (id_paciente) references pacientes(id_paciente)
) Engine=InnoDB;

-- Tabela Consultas Relacionamento com Pacientes e Medicos
create table if not exists consultas(
    id_consulta int auto_increment primary key,
    data_consulta datetime not null,
    status_consulta char(20),
    valor_consulta decimal(10,2),
    id_paciente int not null,
    id_medico int not null,
    foreign key (id_paciente) references pacientes(id_paciente),
    foreign key (id_medico) references medicos(id_medico)
) Engine=InnoDB;

-- Tabela Prescricoes Relacionamento com Consultas
create table if not exists prescricoes(
    id_prescricao int auto_increment primary key,
    id_consulta int not null,
    medicamento char(100) not null,
    dosagem char(50) not null,
    quantidade char(30) not null,
    foreign key (id_consulta) references consultas(id_consulta)
) Engine=InnoDB;

-- Criacao de Indices para otimizacao de buscas frequentes
CREATE INDEX idx_pacientes_nome ON pacientes(nome_paciente);
CREATE INDEX idx_medicos_especialidade ON medicos(especialidade);
CREATE INDEX idx_consultas_data ON consultas(data_consulta);
