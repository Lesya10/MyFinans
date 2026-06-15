

-- Проверить текущую базу данных
SELECT DATABASE();
-- Таблица категорий
-- =============================================
-- 1. СОЗДАНИЕ БАЗЫ ДАННЫХ
-- =============================================
CREATE DATABASE IF NOT EXISTS finance_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE finance_db;

-- =============================================
-- 2. УДАЛЕНИЕ СТАРОЙ ТАБЛИЦЫ (если есть)
-- =============================================
DROP TABLE IF EXISTS transactions;

-- =============================================
-- 3. СОЗДАНИЕ ПРОСТОЙ ТАБЛИЦЫ ТРАНЗАКЦИЙ
-- =============================================
CREATE TABLE transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10, 2) NOT NULL,
    type VARCHAR(10) NOT NULL CHECK (type IN ('income', 'expense')),
    category VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 4. ДОБАВЛЕНИЕ ТЕСТОВЫХ ДАННЫХ
-- =============================================

-- Начальный баланс 10000
INSERT INTO transactions (amount, type, category, description, date) VALUES
(10000.00, 'income', 'Начальный баланс', 'Начальный баланс счета', CURDATE());

-- Тестовые транзакции на русском языке
INSERT INTO transactions (amount, type, category, description, date) VALUES
(50000.00, 'income', 'Зарплата', 'Зарплата за январь 2026', '2026-01-15'),
(3500.00, 'expense', 'Продукты', 'Покупка продуктов в супермаркете', '2026-01-16'),
(1200.00, 'expense', 'Транспорт', 'Проездной на месяц', '2026-01-17'),
(2500.00, 'expense', 'Ресторан', 'Ужин с друзьями', '2026-01-18'),
(15000.00, 'income', 'Фриланс', 'Оплата за проект', '2026-01-20'),
(800.00, 'expense', 'Развлечения', 'Кино и попкорн', '2026-01-22'),
(3000.00, 'expense', 'Одежда', 'Покупка зимней куртки', '2026-01-25'),
(2000.00, 'expense', 'Коммунальные услуги', 'Оплата за электричество', '2026-01-28'),
(2500.00, 'expense', 'Здоровье', 'Витамины и лекарства', '2026-01-30'),
(45000.00, 'income', 'Зарплата', 'Зарплата за февраль 2026', '2026-02-15');

-- =============================================
-- 5. ПРОСМОТР ВСЕХ ТРАНЗАКЦИЙ
-- =============================================
SELECT 
    id,
    DATE_FORMAT(date, '%d.%m.%Y') AS дата,
    CASE 
        WHEN type = 'income' THEN 'Доход'
        ELSE 'Расход'
    END AS тип,
    category AS категория,
    description AS описание,
    CONCAT(FORMAT(amount, 2), ' ₽') AS сумма
FROM transactions
ORDER BY date DESC, id DESC;

-- =============================================
-- 6. ПРОСМОТР СТАТИСТИКИ
-- =============================================
SELECT 
    'Общая статистика' AS показатели,
    CONCAT(FORMAT(SUM(CASE WHEN type = 'income' THEN amount ELSE 0 END), 2), ' ₽') AS доходы,
    CONCAT(FORMAT(SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END), 2), ' ₽') AS расходы,
    CONCAT(FORMAT(SUM(CASE WHEN type = 'income' THEN amount ELSE -amount END), 2), ' ₽') AS баланс
FROM transactions;

-- =============================================
-- 7. РАСХОДЫ ПО КАТЕГОРИЯМ
-- =============================================
SELECT 
    category AS категория,
    COUNT(*) AS количество,
    CONCAT(FORMAT(SUM(amount), 2), ' ₽') AS сумма,
    CONCAT(FORMAT(AVG(amount), 2), ' ₽') AS средний_чек
FROM transactions
WHERE type = 'expense'
GROUP BY category
ORDER BY SUM(amount) DESC;

-- =============================================
-- 8. ДОХОДЫ ПО КАТЕГОРИЯМ
-- =============================================
SELECT 
    category AS категория,
    COUNT(*) AS количество,
    CONCAT(FORMAT(SUM(amount), 2), ' ₽') AS сумма
FROM transactions
WHERE type = 'income'
GROUP BY category
ORDER BY SUM(amount) DESC;

-- =============================================
-- 9. ПОСЛЕДНИЕ 10 ТРАНЗАКЦИЙ
-- =============================================
SELECT 
    DATE_FORMAT(date, '%d.%m.%Y') AS дата,
    CASE WHEN type = 'income' THEN '+' ELSE '-' END AS знак,
    category AS категория,
    CONCAT(FORMAT(amount, 2), ' ₽') AS сумма,
    description AS описание
FROM transactions
ORDER BY date DESC, id DESC
LIMIT 10;

-- =============================================
-- 10. ПРИМЕРЫ ДЛЯ ТЕСТИРОВАНИЯ
-- =============================================

-- Добавить новую транзакцию (пример)
-- INSERT INTO transactions (amount, type, category, description, date) 
-- VALUES (1500.00, 'expense', 'Кафе', 'Обед в кафе', CURDATE());

-- Удалить транзакцию по ID (пример)
-- DELETE FROM transactions WHERE id = 1;

-- Обновить транзакцию (пример)
-- UPDATE transactions SET description = 'Новое описание' WHERE id = 1;

-- =============================================
-- 11. ПРОВЕРКА ЦЕЛОСТНОСТИ ДАННЫХ
-- =============================================
SELECT 
    'Проверка данных:' AS '',
    COUNT(*) AS всего_транзакций,
    MIN(date) AS самая_ранняя_дата,
    MAX(date) AS самая_поздняя_дата,
    ROUND(AVG(amount), 2) AS средняя_сумма
FROM transactions;