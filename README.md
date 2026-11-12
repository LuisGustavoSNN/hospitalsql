# Banco de Dados do Hospital

Atividade de SQL com um banco de hospital. O trabalho tem 10 consultas, cada uma baseada em uma situação do dia a dia do hospital.

## Como rodar

Abra o MySQL Workbench e execute os arquivos nesta ordem:

1. `01_criar_tabelas.sql` (cria o banco `hospital_db` e as tabelas)
2. `02_inserir_dados.sql` (insere 10 registros em cada tabela)
3. `03_consultas.sql` (as 10 consultas)

O primeiro script apaga e recria as tabelas, então dá pra rodar mais de uma vez sem problema.

## Tabelas

- pacientes (id_paciente, nome_paciente, cpf, data_nascimento, telefone_paciente, convenio)
- medicos (id_medico, nome_medico, crm, especialidade)
- quartos (id_quarto, numero_quarto, andar, tipo_quarto, status_quarto)
- internacoes (id_internacao, id_paciente, id_quarto, data_entrada, data_saida, valor_diaria)
- consultas (id_consulta, data_consulta, status_consulta, valor_consulta, id_paciente, id_medico)
- prescricoes (id_prescricao, id_consulta, medicamento, dosagem, quantidade)

Um paciente pode ter várias consultas e internações, um médico atende várias consultas, um quarto recebe várias internações e uma consulta pode ter várias prescrições.

## Consultas

### 1. Faturamento por convênio com "Saúde" no nome
O financeiro quer saber quanto cada convênio desse tipo pagou em consultas.

```sql
SELECT p.convenio, SUM(c.valor_consulta) AS total_arrecadado
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Saúde%'
GROUP BY p.convenio;
```
Resultado: Bradesco Saúde, 400.00

### 2. Média do valor das consultas de Cardiologia
A coordenação clínica quer a média por especialidade ligada à Cardiologia.

```sql
SELECT m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardiologia%'
GROUP BY m.especialidade;
```
Resultado: Cardiologia 350.00 e Cardiologia Pediatrica 400.00

### 3. Média das diárias em Apartamento e UTI
A gerência quer comparar o valor médio da diária nesses dois tipos de quarto.

```sql
SELECT q.tipo_quarto, AVG(i.valor_diaria) AS media_diaria
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE q.tipo_quarto = 'Apartamento' OR q.tipo_quarto = 'UTI'
GROUP BY q.tipo_quarto;
```
Resultado: Apartamento 323.33 e UTI 466.67

### 4. Total de consultas por médico (Realizada ou Finalizada)
A diretoria quer um relatório com a soma dos valores das consultas de cada médico.

```sql
SELECT m.nome_medico, SUM(c.valor_consulta) AS total_consultas
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada' OR c.status_consulta = 'Finalizada'
GROUP BY m.nome_medico;
```
Resultado: retorna 8 médicos. O maior total é da Dra. Camila Rocha (1000.00) e o menor é da Dra. Patricia Lima (280.00).

### 5. Soma das diárias dos pacientes com sobrenome "Silva"
O setor de cobrança precisa do total acumulado de diárias desses pacientes.

```sql
SELECT p.nome_paciente, SUM(i.valor_diaria) AS total_diarias
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE '% Silva%'
GROUP BY p.nome_paciente;
```
Resultado: Ana Silva 450.00 e João Pedro Silva 200.00

### 6. Prescrições de Dipirona ou Paracetamol por status da consulta
A farmácia quer saber quantas vezes esses dois remédios foram prescritos.

```sql
SELECT c.status_consulta, COUNT(pr.id_prescricao) AS quantidade_prescricoes
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
WHERE pr.medicamento LIKE '%Dipirona%' OR pr.medicamento LIKE '%Paracetamol%'
GROUP BY c.status_consulta;
```
Resultado: Realizada, 2 prescrições

### 7. Média das consultas dos convênios Unimed por especialidade
A auditoria quer o valor médio pago em cada especialidade para negociar contrato.

```sql
SELECT p.convenio, m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.convenio, m.especialidade;
```
Resultado: retorna 4 linhas, de 280.00 (Pediatria) até 600.00 (Cirurgia Plástica, Unimed Pleno).

### 8. Média de diária em UTI por convênio
A regulação quer saber o gasto médio com diárias de UTI em cada convênio.

```sql
SELECT p.convenio, AVG(i.valor_diaria) AS media_diaria_uti
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE q.tipo_quarto = 'UTI'
GROUP BY p.convenio;
```
Resultado: Bradesco Saúde 450.00 e Unimed 475.00

### 9. Itens prescritos por médico em consultas realizadas
A comissão de farmácia quer a quantidade de itens prescritos por cada médico.

```sql
SELECT m.nome_medico, COUNT(pr.id_prescricao) AS total_itens_prescritos
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada'
GROUP BY m.nome_medico;
```
Resultado: retorna 7 médicos. O Dr. Marcos Andrade prescreveu mais (3 itens) e a Dra. Camila Rocha vem depois (2).

### 10. Total e média gastos em consultas por pacientes com nome começando em "M"
O atendimento quer um extrato simples desses pacientes.

```sql
SELECT p.nome_paciente, SUM(c.valor_consulta) AS total_gasto, AVG(c.valor_consulta) AS media_gasta
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE 'M%'
GROUP BY p.nome_paciente;
```
Resultado: Maria Santos, total 280.00 e média 280.00
