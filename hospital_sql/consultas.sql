USE hospital_db;

--  Faturamento total de consultas por convenio com "Saude" no nome
SELECT p.convenio, SUM(c.valor_consulta) AS total_arrecadado
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.convenio LIKE '%Saúde%'
GROUP BY p.convenio;

--  Media do valor de consulta nas especialidades de Cardiologia
SELECT m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE m.especialidade LIKE '%Cardiologia%'
GROUP BY m.especialidade;

--  Valor medio das diarias por tipo de quarto (Apartamento ou UTI)
SELECT q.tipo_quarto, AVG(i.valor_diaria) AS media_diaria
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
WHERE q.tipo_quarto = 'Apartamento' OR q.tipo_quarto = 'UTI'
GROUP BY q.tipo_quarto;

--  Total de consultas por medico (status Realizada ou Finalizada)
SELECT m.nome_medico, SUM(c.valor_consulta) AS total_consultas
FROM consultas c
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada' OR c.status_consulta = 'Finalizada'
GROUP BY m.nome_medico;

--  Soma de diarias por paciente com sobrenome "Silva"
SELECT p.nome_paciente, SUM(i.valor_diaria) AS total_diarias
FROM internacoes i
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE '% Silva%'
GROUP BY p.nome_paciente;

--  Contagem de prescricoes por status da consulta (Dipirona ou Paracetamol)
SELECT c.status_consulta, COUNT(pr.id_prescricao) AS quantidade_prescricoes
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
WHERE pr.medicamento LIKE '%Dipirona%' OR pr.medicamento LIKE '%Paracetamol%'
GROUP BY c.status_consulta;

--  Media do valor de consultas por convenio "Unimed" e especialidade
SELECT p.convenio, m.especialidade, AVG(c.valor_consulta) AS media_valor
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE p.convenio LIKE '%Unimed%'
GROUP BY p.convenio, m.especialidade;

--  Media de diaria de internacao por convenio em quartos de UTI
SELECT p.convenio, AVG(i.valor_diaria) AS media_diaria_uti
FROM internacoes i
INNER JOIN quartos q ON i.id_quarto = q.id_quarto
INNER JOIN pacientes p ON i.id_paciente = p.id_paciente
WHERE q.tipo_quarto = 'UTI'
GROUP BY p.convenio;

--  Medicamentos prescritos por medico em consultas Realizada
SELECT m.nome_medico, COUNT(pr.id_prescricao) AS total_itens_prescritos
FROM prescricoes pr
INNER JOIN consultas c ON pr.id_consulta = c.id_consulta
INNER JOIN medicos m ON c.id_medico = m.id_medico
WHERE c.status_consulta = 'Realizada'
GROUP BY m.nome_medico;

--  Valor total e media de consultas por paciente nome comecando com "M"
SELECT p.nome_paciente, SUM(c.valor_consulta) AS total_gasto, AVG(c.valor_consulta) AS media_gasta
FROM consultas c
INNER JOIN pacientes p ON c.id_paciente = p.id_paciente
WHERE p.nome_paciente LIKE 'M%'
GROUP BY p.nome_paciente;