-- PROJETO: Supply Chain Analytics com SQL

/*
Análise de Estoque, Compras e Logística
Objetivo:
Realizar análises operacionais e estratégicas da cadeia de suprimentos,
identificando gargalos logísticos, custos, eficiência de fornecedores,desempenho operacional
e oportunidades de redução de despesas.
*/

-- Passo a passo da criação á importação

CREATE DATABASE supply_chain;
use supply_chain;

CREATE TABLE produtos_supply_chain (
product_type VARCHAR(100),
sku VARCHAR(100),
price DECIMAL(10,2),
availability INT,
number_of_products_sold INT,
revenue_generated DECIMAL(10,2),
customer_demographics VARCHAR(100),
stock_levels INT,
lead_times INT,
order_quantities INT,
shipping_times INT,
shipping_carriers VARCHAR(100),
shipping_costs DECIMAL(10,2),
supplier_name VARCHAR(100),
location VARCHAR(100),
lead_time INT,
production_volumes INT,
manufacturing_lead_time INT,
manufacturing_costs DECIMAL(10,2),
inspection_results VARCHAR(100),
defect_rates DECIMAL(10,2),
transportation_modes VARCHAR(100),
routes VARCHAR(100),
costs DECIMAL(10,2)
);

DESCRIBE produtos_supply_chain; -- conferindo se foi ok

LOAD DATA LOCAL INFILE 'C:/Users/Jamille/Downloads/supply_chain_data.csv'
INTO TABLE produtos_supply_chain
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_type,
sku,
price,
availability,
number_of_products_sold,
revenue_generated,
customer_demographics,
stock_levels,
lead_times,
order_quantities,
shipping_times,
shipping_carriers,
shipping_costs,
supplier_name,
location,
lead_time,
production_volumes,
manufacturing_lead_time,
manufacturing_costs,
inspection_results,
defect_rates,
transportation_modes,
routes,
costs
);

SET GLOBAL local_infile = 1; -- autorizando

SELECT COUNT(*)
FROM produtos_supply_chain; -- checando a base

SELECT *
FROM produtos_supply_chain
limit 10; -- checando a base

-- ETAPA 0 — EDA

-- Conhecendo a base:

-- 1 Quantos registros existem?
SELECT
COUNT(*) AS total_registros
FROM produtos_supply_chain;

-- 2 Quantos fornecedores?
SELECT
COUNT(DISTINCT supplier_name) AS total_fornecedores
FROM produtos_supply_chain;

-- 3 Quantos produtos?
SELECT
COUNT(DISTINCT sku) AS total_produtos
FROM produtos_supply_chain;

-- 4 Quantos países?
SELECT
COUNT(DISTINCT location) AS total_locais
FROM produtos_supply_chain;

-- 5 Existem valores nulos?
SELECT
COUNT(*) AS linhas_com_nulos
FROM produtos_supply_chain
WHERE sku IS NULL OR price IS NULL OR stock_levels IS NULL;

-- 6 Existem produtos sem estoque?
SELECT
COUNT(*) AS produtos_sem_estoque
FROM produtos_supply_chain
WHERE stock_levels = 0;


-- 7 Existem entregas cujo tempo de transporte é maior que o lead time?

SELECT
    COUNT(*) AS entregas_acima_do_lead_time
FROM produtos_supply_chain
WHERE shipping_times > lead_time;

-- 8 Receita total
SELECT
SUM(revenue_generated) AS receita_total
FROM produtos_supply_chain;

-- 9 Lucro estimado
SELECT
    SUM(
        revenue_generated
        - manufacturing_costs
        - shipping_costs
    ) AS lucro_estimado
FROM produtos_supply_chain;

-- 10 Custo total
SELECT
SUM(manufacturing_costs + shipping_costs) AS custo_total
FROM produtos_supply_chain;

-- Análise 1 - Produtos que mais faturam

/* Quais produtos geram maior receita?
Objetivo:
Descobrir os produtos estratégicos.
*/

SELECT
    sku,
    SUM(revenue_generated) AS receita_total
FROM produtos_supply_chain
GROUP BY sku
ORDER BY receita_total DESC
LIMIT 10;

/* insight:

-- Análise 2 - Produtos mais vendidos

/*
Quais produtos possuem maior volume de vendas?
Objetivo:
Identificar produtos de maior saída.
*/

SELECT
sku,
SUM(number_of_products_sold) as total_vendido
FROM produtos_supply_chain
GROUP BY sku
ORDER BY total_vendido DESC
LIMIT 10;


-- ANÁLISE 3 — Ranking de produtos por receita

/*
Qual é a posição de cada produto no ranking de receita?
Objetivo:
Criar um ranking completo dos produtos.
*/

SELECT
    sku AS produto,
    SUM(revenue_generated) AS receita_total,
    RANK() OVER (
        ORDER BY SUM(revenue_generated) DESC
    ) AS ranking
FROM produtos_supply_chain
GROUP BY sku;

-- ANÁLISE 4 — Ranking de produtos sem empates
/*
Como numerar cada produto individualmente no ranking?
Objetivo:
Entender a diferença entre ranking e numeração de linhas.
*/

SELECT
    sku AS produto,
    SUM(revenue_generated) AS receita_total,
    ROW_NUMBER() OVER (
        ORDER BY SUM(revenue_generated) DESC
    ) AS numero_linha
FROM produtos_supply_chain
GROUP BY sku;

-- ANÁLISE 5 — Ranking por fornecedor

/*
Quais fornecedores possuem maior produção?
Objetivo:
Identificar fornecedores mais relevantes para a operação.
*/

SELECT
supplier_name AS fornecedor,
SUM(production_volumes) AS producao_total,
RANK () OVER (ORDER BY SUM(production_volumes) DESC) AS ranking_fornecedor
FROM produtos_supply_chain
GROUP BY supplier_name;

-- ANÁLISE 7 — Fornecedores com desempenho mínimo

/*
Quais fornecedores possuem produção acima de determinado volume?
Objetivo:
Filtrar grupos depois de uma agregação.
*/

SELECT 
    supplier_name AS fornecedor,
    SUM(production_volumes) AS volume_total_produzido
FROM 
    produtos_supply_chain
GROUP BY 
    supplier_name
HAVING 
    SUM(production_volumes) > (
        SELECT AVG(volume_por_fornecedor)
        FROM (
            SELECT SUM(production_volumes) AS volume_por_fornecedor
            FROM produtos_supply_chain
            GROUP BY supplier_name
        ) AS media_global
    )
ORDER BY 
    volume_total_produzido DESC;

-- ANÁLISE 8 — CTE de desempenho dos fornecedores

/*
Quais fornecedores combinam alta produção com baixo custo?
Objetivo:
Criar uma tabela temporária de análise e depois trabalhar sobre ela.
*/

WITH desempenho_fornecedores AS (
    SELECT 
        supplier_name,
        SUM(production_volumes) AS producao_total,
        AVG(manufacturing_costs) AS custo_medio_fabricacao
    FROM produtos_supply_chain
    GROUP BY supplier_name
)

SELECT 
    supplier_name AS fornecedor,
    producao_total,
    ROUND(custo_medio_fabricacao, 2) AS custo_medio
FROM desempenho_fornecedores
WHERE producao_total > (
    SELECT AVG(producao_total)
    FROM desempenho_fornecedores
)
AND custo_medio_fabricacao < (
    SELECT AVG(custo_medio_fabricacao)
    FROM desempenho_fornecedores
)
ORDER BY producao_total DESC;

-- ANÁLISE 9 — Eficiência logística

/*
Quais transportadoras apresentam melhor desempenho de tempo?
Objetivo:
Comparar o tempo médio de transporte entre transportadoras.
*/

SELECT 
    shipping_carriers AS transportadora,
    ROUND(AVG(shipping_times), 2) AS tempo_medio_transporte,
    COUNT(sku) AS total_entregas_realizadas
FROM 
    produtos_supply_chain
GROUP BY 
    shipping_carriers
ORDER BY 
    tempo_medio_transporte ASC;


-- ANÁLISE 10 — Comparação entre registros

/*
Como o desempenho de cada registro se compara ao registro anterior?
Objetivo:
Aprender a comparar uma linha com outra.
*/

SELECT 
    sku AS codigo_produto,
    supplier_name AS fornecedor,
    production_volumes AS producao_atual,
    
    -- 1. Pega o volume de produção do registro anterior
    LAG(production_volumes, 1) OVER(ORDER BY sku) AS producao_anterior,
    
    -- 2. Calcula a diferença bruta entre o atual e o anterior
    production_volumes - LAG(production_volumes, 1) OVER(ORDER BY sku) AS diferenca_bruta
FROM 
    produtos_supply_chain
ORDER BY 
    sku;

-- ANÁLISE 11 — Próximo registro

/*
Qual é o próximo valor/registro associado a cada observação?
Objetivo:
Entender como olhar para a linha seguinte.
*/

SELECT 
    sku AS codigo_produto,
    supplier_name AS fornecedor,
    production_volumes AS producao_atual,
    
    -- 1. Pega o volume de produção do PRÓXIMO registro
    LEAD(production_volumes, 1) OVER(ORDER BY sku) AS proxima_producao,
    
    -- 2. Calcula a diferença entre a linha atual e a próxima
    LEAD(production_volumes, 1) OVER(ORDER BY sku) - production_volumes AS diferenca_para_proxima
FROM 
    produtos_supply_chain
ORDER BY 
    sku;

-- ANÁLISE 12 — Segmentação operacional

/*
Como podemos classificar produtos ou fornecedores de acordo com seu desempenho?
Objetivo:
Criar categorias de negócio.
*/
-- descobrindo mínimo, máximo e média de produção e defeitos.
SELECT
    MIN(production_volumes) AS menor_producao,
    MAX(production_volumes) AS maior_producao,
    AVG(production_volumes) AS media_producao,
    MIN(defect_rates) AS menor_defeito,
    MAX(defect_rates) AS maior_defeito,
    AVG(defect_rates) AS media_defeito
FROM produtos_supply_chain;

SELECT 
    sku AS codigo_produto,
    supplier_name AS fornecedor,
    production_volumes AS volume_producao,
    defect_rates AS taxa_defeito,

    CASE 
        WHEN production_volumes >= 567.84
             AND defect_rates <= 2.2771
            THEN '1. Estrela (Alta Prod / Baixo Defeito)'

        WHEN production_volumes >= 567.84
             AND defect_rates > 2.2771
            THEN '2. Alerta de Qualidade (Alta Prod / Alto Defeito)'

        WHEN production_volumes < 567.84
             AND defect_rates <= 2.2771
            THEN '3. Baixo Volume (Baixo Prod / Baixo Defeito)'

        ELSE '4. Crítico (Baixa Prod / Alto Defeito)'
    END AS classificacao_operacional

FROM produtos_supply_chain

ORDER BY 
    classificacao_operacional ASC,
    production_volumes DESC;

-- casso queira descubrir quantos produtos existem em cada classificação
WITH classificacao AS (
    SELECT 
        sku,
        supplier_name,
        production_volumes,
        defect_rates,

        CASE 
            WHEN production_volumes >= 567.84
                 AND defect_rates <= 2.2771
                THEN 'Estrela'

            WHEN production_volumes >= 567.84
                 AND defect_rates > 2.2771
                THEN 'Alerta de Qualidade'

            WHEN production_volumes < 567.84
                 AND defect_rates <= 2.2771
                THEN 'Baixo Volume'

            ELSE 'Crítico'
        END AS classificacao_operacional

    FROM produtos_supply_chain
)

SELECT
    classificacao_operacional,
    COUNT(*) AS quantidade_produtos
FROM classificacao
GROUP BY classificacao_operacional
ORDER BY quantidade_produtos DESC;

-- ANÁLISE 13 — Evolução temporal

/*
Como a operação se comporta ao longo do tempo?
Objetivo:
Análise de médias móveis e acumulados
*/

SELECT 
    sku AS codigo_produto,
    supplier_name AS fornecedor,
    production_volumes AS volume_producao,
    manufacturing_costs AS custo_fabricacao,
    
    -- 1. Média Móvel de Produção: Calcula a média do produto atual + 2 anteriores
    ROUND(AVG(production_volumes) OVER(
        ORDER BY sku 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS media_movel_producao,
    
    -- 2. Custo Acumulado Progressivo: Soma os custos conforme o tempo/sequência avança
    ROUND(SUM(manufacturing_costs) OVER(
        ORDER BY sku
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS custo_acumulado_operacao

FROM 
    produtos_supply_chain
ORDER BY 
    sku;

-- ANÁLISE 14 — Visão estratégica

/*
Quais são os principais indicadores da cadeia de suprimentos?
Objetivo:
Criar uma visão executiva reunindo:
• Receita
•Lucro estimado
•Custos
•Produtos
•Fornecedores
•Estoque
•Lead time
•Tempo de transporte
•Custos logísticos
•Taxa de defeitos
*/

SELECT 
    -- Indicadores de Escopo (Produtos e Parceiros)
    COUNT(DISTINCT sku) AS total_produtos_ativos,
    COUNT(DISTINCT supplier_name) AS total_fornecedores,
    
    -- Indicadores de Volume e Vendas
    SUM(number_of_products_sold) AS total_unidades_vendidas,
    SUM(production_volumes) AS volume_total_produzido,
    SUM(stock_levels) AS total_produtos_em_estoque,
    
    -- Financeiro: Receita, Custos e Lucro
    ROUND(SUM(revenue_generated), 2) AS receita_total,
    ROUND(
        SUM(manufacturing_costs) + SUM(shipping_costs) + SUM(costs), 2
    ) AS custos_totais_operacao,
    ROUND(
        SUM(revenue_generated) - (SUM(manufacturing_costs) + SUM(shipping_costs) + SUM(costs)), 2
    ) AS lucro_estimado_total,
    
    -- Eficiência Logística (Médias de Tempo e Custo)
    ROUND(AVG(lead_time), 1) AS lead_time_medio_dias,
    ROUND(AVG(shipping_times), 1) AS tempo_medio_transporte_dias,
    ROUND(SUM(shipping_costs), 2) AS custo_total_transporte,
    
    -- Qualidade da Operação
    ROUND(AVG(defect_rates), 2) AS taxa_media_defeitos_percentual

FROM 
    produtos_supply_chain;

