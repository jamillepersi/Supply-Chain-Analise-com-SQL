# 📦 Supply Chain Analytics com SQL

## 📌 Sobre o projeto

Projeto desenvolvido para analisar dados de uma cadeia de suprimentos utilizando SQL e transformar dados operacionais em informações relevantes para tomada de decisão.

A análise aborda diferentes etapas da operação, incluindo vendas, produção, estoque, fornecedores, custos, logística e qualidade.

O principal objetivo foi avançar meus conhecimentos em SQL, saindo de consultas básicas de agregação para recursos de SQL analítico, como CTEs, subqueries, Window Functions, rankings e funções de comparação entre registros.

---

## 🎯 Objetivo do projeto

Investigar a eficiência da cadeia de suprimentos e identificar:

- Produtos com maior faturamento e volume de vendas;
- Fornecedores com maior produção;
- Fornecedores acima da média de produção;
- Relação entre produção e custos de fabricação;
- Desempenho das transportadoras;
- Diferenças entre registros;
- Indicadores de qualidade;
- Produtos classificados de acordo com desempenho operacional;
- Principais indicadores estratégicos da operação.

---

## 🗂️ Base de dados

Dataset: **Supply Chain Dataset**

A base contém informações relacionadas a:

- Produtos
- Vendas
- Estoque
- Fornecedores
- Produção
- Fabricação
- Transporte
- Custos
- Qualidade

### Principais campos utilizados

| Campo | Descrição |
|---|---|
| `product_type` | Tipo de produto |
| `sku` | Código do produto |
| `price` | Preço |
| `number_of_products_sold` | Quantidade de produtos vendidos |
| `revenue_generated` | Receita gerada |
| `stock_levels` | Nível de estoque |
| `supplier_name` | Fornecedor |
| `production_volumes` | Volume de produção |
| `manufacturing_costs` | Custo de fabricação |
| `shipping_times` | Tempo de transporte |
| `shipping_costs` | Custo de transporte |
| `lead_time` | Tempo de produção/abastecimento |
| `defect_rates` | Taxa de defeitos |
| `transportation_modes` | Modal de transporte |
| `shipping_carriers` | Transportadora |

---

## 🔎 EDA — Análise Exploratória

Antes das análises de negócio, foram realizadas consultas para compreender a estrutura e a qualidade dos dados.

Foram analisados:

- Total de registros;
- Quantidade de fornecedores;
- Quantidade de produtos;
- Quantidade de locais;
- Existência de valores nulos;
- Produtos sem estoque;
- Registros com tempo de transporte acima do lead time;
- Receita total;
- Lucro estimado;
- Custos totais.

---

## 📊 Análises realizadas

### 1. Produtos que mais faturam
Identificação dos produtos com maior receita.

### 2. Produtos mais vendidos
Identificação dos produtos com maior volume de vendas.

### 3. Ranking de produtos por receita
Aplicação de `RANK()` para posicionar os produtos de acordo com a receita.

### 4. Ranking sem empates
Aplicação de `ROW_NUMBER()` para compreender a diferença entre ranking e numeração sequencial.

### 5. Ranking por fornecedor
Classificação dos fornecedores de acordo com o volume total produzido.

### 6. Análise de fornecedores acima da média
Utilização de `HAVING` e subquery para identificar fornecedores cuja produção supera a média.

### 7. Desempenho dos fornecedores
Utilização de CTE para comparar produção e custo médio de fabricação.

### 8. Eficiência logística
Comparação do tempo médio de transporte entre as transportadoras.

### 9. Comparação entre registros
Utilização de `LAG()` para comparar a produção atual com o registro anterior.

### 10. Próximo registro
Utilização de `LEAD()` para analisar o valor do registro seguinte.

### 11. Segmentação operacional
Aplicação de `CASE` para classificar produtos de acordo com volume de produção e taxa de defeitos.

A classificação foi construída utilizando a média da própria base como referência.

### 12. Distribuição da classificação
Utilização de CTE e `GROUP BY` para identificar a quantidade de produtos em cada categoria operacional.

### 13. Média móvel e acumulado
Aplicação de Window Functions para calcular:

- Média móvel de produção;
- Custo acumulado da operação.

### 14. Visão estratégica
Consolidação de indicadores relacionados a:

- Receita;
- Lucro estimado;
- Custos;
- Produtos;
- Fornecedores;
- Estoque;
- Produção;
- Lead time;
- Transporte;
- Custos logísticos;
- Taxa de defeitos.

---

## 🧠 Conceitos de SQL praticados

Durante o projeto foram utilizados:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `DISTINCT`
- `CASE`
- `LIMIT`
- Subqueries
- CTEs (`WITH`)
- Window Functions
- `RANK()`
- `ROW_NUMBER()`
- `LAG()`
- `LEAD()`
- `ROWS BETWEEN`
- `UNBOUNDED PRECEDING`

---

## 🛠️ Ferramentas

- MySQL
- MySQL Workbench
- SQL

---

## 💡 Aprendizados

Este projeto representou uma nova etapa na minha evolução em SQL.

Além de praticar a sintaxe, comecei a trabalhar com recursos utilizados em análises mais complexas, principalmente CTEs, subqueries e Window Functions.

O projeto também reforçou uma habilidade que considero fundamental para um Analista de Dados: partir de uma pergunta de negócio, escolher a técnica adequada e transformar o resultado da consulta em informação.

---

## 👩🏻‍💻 Autora

**Jamille Silva**

Estudante de Sistemas de Informação e em desenvolvimento na área de Dados, com foco em SQL e análise de dados.

Tecnologias em desenvolvimento:
**SQL | Python | Power BI | Excel**
