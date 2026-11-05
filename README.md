# Banco de Dados do Hospital — 10 Consultas SQL

Atividade individual: criar um banco de dados de hospital (`hospital_db`) e responder a 10 situações-problema com consultas SQL, usando `INNER JOIN`, `WHERE`, `LIKE`, `GROUP BY`, `SUM`, `AVG` e `COUNT`.

## Arquivos

| Arquivo | O que faz |
|---|---|
| `01_criar_tabelas.sql` | Cria o banco `hospital_db`, as 6 tabelas e os índices |
| `02_inserir_dados.sql` | Insere 10 registros em cada tabela |
| `03_consultas.sql` | As 10 consultas |

## Como executar

1. Abra o MySQL Workbench (ou outro cliente MySQL)
2. Rode o `01_criar_tabelas.sql`
3. Rode o `02_inserir_dados.sql`
4. Rode o `03_consultas.sql`

O script 01 apaga e recria as tabelas, então pode ser executado mais de uma vez.

## Modelo do banco

- `pacientes` (id_paciente, nome_paciente, cpf, data_nascimento, telefone_paciente, convenio)
- `medicos` (id_medico, nome_medico, crm, especialidade)
- `quartos` (id_quarto, numero_quarto, andar, tipo_quarto, status_quarto)
- `internacoes` (id_internacao, id_paciente, id_quarto, data_entrada, data_saida, valor_diaria)
- `consultas` (id_consulta, data_consulta, status_consulta, valor_consulta, id_paciente, id_medico)
- `prescricoes` (id_prescricao, id_consulta, medicamento, dosagem, quantidade)

Relacionamentos:

- Um paciente tem várias internações e várias consultas
- Um quarto recebe várias internações
- Um médico atende várias consultas
- Uma consulta tem várias prescrições

---

## Consultas e respostas

### 1. Faturamento total de consultas por convênio com "Saúde" no nome

**Situação:** o setor financeiro precisa saber o total arrecadado em consultas pelos convênios que têm "Saúde" no nome, para acompanhar o faturamento por parceiro

```sql
SELECT p.convenio, SUM(c.valor_consulta) AS total_arrecadado
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Saúde%'
GROUP BY p.convenio;
```

**Resposta:**

| convenio | total_arrecadado |
|---|---|
| Bradesco Saúde | 400.00 |

### 2. Média do valor de consulta nas especialidades de Cardiologia

**Situação:** a coordenação clínica quer a média do valor das consultas nas especialidades ligadas à Cardiologia

```sql
SELECT m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardiologia%'
GROUP BY m.especialidade;
```

**Resposta:**

| especialidade | media_valor |
|---|---|
| Cardiologia | 350.00 |
| Cardiologia Pediatrica | 400.00 |

### 3. Valor médio das diárias por tipo de quarto (Apartamento ou UTI)

**Situação:** a gerência de infraestrutura quer analisar o valor médio da diária nas internações em Apartamento ou UTI

```sql
SELECT q.tipo_quarto, AVG(i.valor_diaria) AS media_diaria
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE q.tipo_quarto = 'Apartamento' OR q.tipo_quarto = 'UTI'
GROUP BY q.tipo_quarto;
```

**Resposta:**

| tipo_quarto | media_diaria |
|---|---|
| Apartamento | 323.33 |
| UTI | 466.67 |

### 4. Total de consultas por médico (status Realizada ou Finalizada)

**Situação:** a diretoria de atendimento quer um relatório com o nome dos médicos e a soma dos valores das consultas realizadas ou finalizadas

```sql
SELECT m.nome_medico, SUM(c.valor_consulta) AS total_consultas
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada' OR c.status_consulta = 'Finalizada'
GROUP BY m.nome_medico;
```

**Resposta:**

| nome_medico | total_consultas |
|---|---|
| Dr. Gustavo Santos | 320.00 |
| Dr. Marcos Andrade | 700.00 |
| Dr. Roberto Silva | 400.00 |
| Dra. Camila Rocha | 1000.00 |
| Dra. Claudia Castro | 600.00 |
| Dra. Patricia Lima | 280.00 |
| Dra. Renata Mello | 300.00 |
| Dra. Vanessa Martins | 550.00 |

### 5. Soma de diárias por paciente com sobrenome "Silva"

**Situação:** o setor de cobrança precisa da soma acumulada das diárias de internação dos pacientes com sobrenome "Silva".

```sql
SELECT p.nome_paciente, SUM(i.valor_diaria) AS total_diarias
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE '% Silva%'
GROUP BY p.nome_paciente;
```

**Resposta:**

| nome_paciente | total_diarias |
|---|---|
| Ana Silva | 450.00 |
| João Pedro Silva | 200.00 |

### 6. Contagem de prescrições por status da consulta (Dipirona ou Paracetamol)

**Situação:** a farmácia hospitalar quer a quantidade de medicamentos prescritos por status da consulta, só para Dipirona ou Paracetamol

```sql
SELECT c.status_consulta, COUNT(pr.id_prescricao) AS quantidade_prescricoes
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
WHERE pr.medicamento LIKE '%Dipirona%' OR pr.medicamento LIKE '%Paracetamol%'
GROUP BY c.status_consulta;
```

**Resposta:**

| status_consulta | quantidade_prescricoes |
|---|---|
| Realizada | 2 |

### 7. Média do valor de consultas por convênio "Unimed" e especialidade

**Situação:** em uma negociação contratual, a auditoria quer o valor médio pago por consulta, cruzando os convênios "Unimed" com a especialidade do médico

```sql
SELECT p.convenio, m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.convenio, m.especialidade;
```

**Resposta:**

| convenio | especialidade | media_valor |
|---|---|---|
| Unimed | Cardiologia | 350.00 |
| Unimed | Cirurgia Geral | 500.00 |
| Unimed | Pediatria | 280.00 |
| Unimed Pleno | Cirurgia Plastica | 600.00 |

### 8. Média de diária de internação por convênio em quartos de UTI

**Situação:** a regulação hospitalar precisa do valor médio gasto em diárias, por convênio, considerando só quartos de UTI

```sql
SELECT p.convenio, AVG(i.valor_diaria) AS media_diaria_uti
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE q.tipo_quarto = 'UTI'
GROUP BY p.convenio;
```

**Resposta:**

| convenio | media_diaria_uti |
|---|---|
| Bradesco Saúde | 450.00 |
| Unimed | 475.00 |

### 9. Medicamentos prescritos por médico em consultas realizadas

**Situação:** a comissão de farmácia e terapêutica quer a quantidade de itens prescritos por médico nas consultas com status "Realizada"

```sql
SELECT m.nome_medico, COUNT(pr.id_prescricao) AS total_itens_prescritos
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada'
GROUP BY m.nome_medico;
```

**Resposta:**

| nome_medico | total_itens_prescritos |
|---|---|
| Dr. Gustavo Santos | 1 |
| Dr. Marcos Andrade | 3 |
| Dr. Roberto Silva | 1 |
| Dra. Camila Rocha | 2 |
| Dra. Claudia Castro | 1 |
| Dra. Patricia Lima | 1 |
| Dra. Vanessa Martins | 1 |

### 10. Valor total e média de consultas por paciente (nome começando com "M")

**Situação:** o atendimento ao cliente precisa de um extrato financeiro simples, com a soma e a média gastas em consultas, para pacientes cujo nome começa com "M"

```sql
SELECT p.nome_paciente, SUM(c.valor_consulta) AS total_gasto, AVG(c.valor_consulta) AS media_gasta
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE 'M%'
GROUP BY p.nome_paciente;
```

**Resposta:**

| nome_paciente | total_gasto | media_gasta |
|---|---|---|
| Maria Santos | 280.00 | 280.00 |
