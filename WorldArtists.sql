USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'WorldArtists')
BEGIN
    ALTER DATABASE WorldArtists SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE WorldArtists;
END
GO

CREATE DATABASE WorldArtists;
GO

USE WorldArtists;
GO

-- 1. Создание таблиц узлов
CREATE TABLE Artist (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    birth_year INT,
    death_year INT,
    description NVARCHAR(200)
) AS NODE;

CREATE TABLE ArtStyle (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(30) NOT NULL,
    description NVARCHAR(200)
) AS NODE;

CREATE TABLE Country (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    continent NVARCHAR(30)
) AS NODE;

CREATE TABLE Gallery (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50),
    description NVARCHAR(200)
) AS NODE;

-- 2. Создание таблиц рёбер
CREATE TABLE PaintsInStyle AS EDGE;
CREATE TABLE ExhibitsInGallery AS EDGE;
CREATE TABLE LivedInCountry AS EDGE;
CREATE TABLE GalleryLocatedIn AS EDGE;

-- Добавление ограничений для таблиц рёбер

-- Ограничение для связи "Художник работает в стиле"
ALTER TABLE PaintsInStyle 
ADD CONSTRAINT EC_PaintsInStyle 
CONNECTION (Artist TO ArtStyle);

-- Ограничение для связи "Художник выставляется в галерее"
ALTER TABLE ExhibitsInGallery 
ADD CONSTRAINT EC_ExhibitsInGallery 
CONNECTION (Artist TO Gallery);

-- Ограничение для связи "Художник жил в стране"
ALTER TABLE LivedInCountry 
ADD CONSTRAINT EC_LivedInCountry 
CONNECTION (Artist TO Country);

-- Ограничение для связи "Галерея расположена в стране"
ALTER TABLE GalleryLocatedIn 
ADD CONSTRAINT EC_GalleryLocatedIn 
CONNECTION (Gallery TO Country);

-- 3. Заполнение таблиц узлов
-- Художники
INSERT INTO Artist (id, name, birth_year, death_year, description)
VALUES 
(1, N'Леонардо да Винчи', 1452, 1519, N'Итальянский художник, изобретатель'),
(2, N'Винсент ван Гог', 1853, 1890, N'Нидерландский художник-постимпрессионист'),
(3, N'Пабло Пикассо', 1881, 1973, N'Испанский художник, основатель кубизма'),
(4, N'Клод Моне', 1840, 1926, N'Французский художник, импрессионист'),
(5, N'Сальвадор Дали', 1904, 1989, N'Испанский художник, сюрреалист'),
(6, N'Рембрандт', 1606, 1669, N'Нидерландский художник Золотого века'),
(7, N'Микеланджело', 1475, 1564, N'Итальянский скульптор и художник'),
(8, N'Эдвард Мунк', 1863, 1944, N'Норвежский художник-экспрессионист'),
(9, N'Казимир Малевич', 1879, 1935, N'Русский авангардист, основатель супрематизма'),
(10, N'Иван Шишкин', 1832, 1898, N'Русский художник-пейзажист, передвижник');

-- Стили 
INSERT INTO ArtStyle (id, name, description)
VALUES
(1, N'Ренессанс', N'Искусство эпохи Возрождения'),
(2, N'Постимпрессионизм', N'Развитие импрессионизма'),
(3, N'Кубизм', N'Авангардное направление с геометрическими формами'),
(4, N'Импрессионизм', N'Направление с акцентом на свет и цвет'),
(5, N'Сюрреализм', N'Направление с элементами подсознательного'),
(6, N'Барокко', N'Пышное искусство XVII-XVIII веков'),
(7, N'Экспрессионизм', N'Акцент на эмоциональное восприятие'),
(8, N'Супрематизм', N'Абстрактное искусство с геометрическими формами'),
(9, N'Реализм', N'Изображение действительности без прикрас'),
(10, N'Символизм', N'Использование символов для выражения идей');

-- Страны 
INSERT INTO Country (id, name, continent)
VALUES
(1, N'Италия', N'Европа'),
(2, N'Нидерланды', N'Европа'),
(3, N'Испания', N'Европа'),
(4, N'Франция', N'Европа'),
(5, N'Норвегия', N'Европа'),
(6, N'Россия', N'Европа'),
(7, N'Австрия', N'Европа'), 
(8, N'Германия', N'Европа'),
(9, N'США', N'Америка'),
(10, N'Великобритания', N'Европа');

-- Галереи 
INSERT INTO Gallery (id, name, city, description)
VALUES
(1, N'Лувр', N'Париж', N'Крупнейший художественный музей мира'),
(2, N'Музей ван Гога', N'Амстердам', N'Коллекция работ ван Гога'),
(3, N'Прадо', N'Мадрид', N'Национальный музей Испании'),
(4, N'Музей Орсе', N'Париж', N'Музей импрессионизма'),
(5, N'Музей Дали', N'Фигерас', N'Театр-музей Сальвадора Дали'),
(6, N'Рейксмюсеум', N'Амстердам', N'Государственный музей Нидерландов'),
(7, N'Альбертина', N'Вена', N'Крупнейшее собрание графики в Европе'), -- В Австрии
(8, N'Музей Мунка', N'Осло', N'Коллекция работ Эдварда Мунка'),
(9, N'Третьяковская галерея', N'Москва', N'Крупнейший музей русского искусства'),
(10, N'Эрмитаж', N'Санкт-Петербург', N'Крупнейший художественный музей России');

-- 4. Заполнение таблиц рёбер
-- Связи художников со стилями
INSERT INTO PaintsInStyle ($from_id, $to_id)
VALUES

((SELECT $node_id FROM Artist WHERE id = 1), (SELECT $node_id FROM ArtStyle WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 2), (SELECT $node_id FROM ArtStyle WHERE id = 2)),
((SELECT $node_id FROM Artist WHERE id = 2), (SELECT $node_id FROM ArtStyle WHERE id = 7)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM ArtStyle WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM ArtStyle WHERE id = 9)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM ArtStyle WHERE id = 5)),
((SELECT $node_id FROM Artist WHERE id = 4), (SELECT $node_id FROM ArtStyle WHERE id = 4)),
((SELECT $node_id FROM Artist WHERE id = 5), (SELECT $node_id FROM ArtStyle WHERE id = 5)),
((SELECT $node_id FROM Artist WHERE id = 5), (SELECT $node_id FROM ArtStyle WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 6), (SELECT $node_id FROM ArtStyle WHERE id = 6)),
((SELECT $node_id FROM Artist WHERE id = 6), (SELECT $node_id FROM ArtStyle WHERE id = 9)),
((SELECT $node_id FROM Artist WHERE id = 7), (SELECT $node_id FROM ArtStyle WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM ArtStyle WHERE id = 7)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM ArtStyle WHERE id = 10)),
((SELECT $node_id FROM Artist WHERE id = 9), (SELECT $node_id FROM ArtStyle WHERE id = 8)),
((SELECT $node_id FROM Artist WHERE id = 9), (SELECT $node_id FROM ArtStyle WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 10), (SELECT $node_id FROM ArtStyle WHERE id = 9));


-- Связи художников с галереями 
INSERT INTO ExhibitsInGallery ($from_id, $to_id)
VALUES

((SELECT $node_id FROM Artist WHERE id = 1), (SELECT $node_id FROM Gallery WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 1), (SELECT $node_id FROM Gallery WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 2), (SELECT $node_id FROM Gallery WHERE id = 2)),
((SELECT $node_id FROM Artist WHERE id = 2), (SELECT $node_id FROM Gallery WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM Gallery WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM Gallery WHERE id = 4)),
((SELECT $node_id FROM Artist WHERE id = 4), (SELECT $node_id FROM Gallery WHERE id = 4)),
((SELECT $node_id FROM Artist WHERE id = 4), (SELECT $node_id FROM Gallery WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 5), (SELECT $node_id FROM Gallery WHERE id = 5)),
((SELECT $node_id FROM Artist WHERE id = 5), (SELECT $node_id FROM Gallery WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 6), (SELECT $node_id FROM Gallery WHERE id = 6)),
((SELECT $node_id FROM Artist WHERE id = 6), (SELECT $node_id FROM Gallery WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 7), (SELECT $node_id FROM Gallery WHERE id = 7)),
((SELECT $node_id FROM Artist WHERE id = 7), (SELECT $node_id FROM Gallery WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM Gallery WHERE id = 8)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM Gallery WHERE id = 9)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM Gallery WHERE id = 4)),
((SELECT $node_id FROM Artist WHERE id = 9), (SELECT $node_id FROM Gallery WHERE id = 9)),
((SELECT $node_id FROM Artist WHERE id = 9), (SELECT $node_id FROM Gallery WHERE id = 10)),
((SELECT $node_id FROM Artist WHERE id = 10), (SELECT $node_id FROM Gallery WHERE id = 9)),
((SELECT $node_id FROM Artist WHERE id = 10), (SELECT $node_id FROM Gallery WHERE id = 10));


-- Связи художников со странами 
INSERT INTO LivedInCountry ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Artist WHERE id = 1), (SELECT $node_id FROM Country WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 2), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Artist WHERE id = 3), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 4), (SELECT $node_id FROM Country WHERE id = 4)),
((SELECT $node_id FROM Artist WHERE id = 5), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Artist WHERE id = 6), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Artist WHERE id = 7), (SELECT $node_id FROM Country WHERE id = 1)),
((SELECT $node_id FROM Artist WHERE id = 8), (SELECT $node_id FROM Country WHERE id = 5)),
((SELECT $node_id FROM Artist WHERE id = 9), (SELECT $node_id FROM Country WHERE id = 6)),
((SELECT $node_id FROM Artist WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 6));

-- Связи галерей со странами 
INSERT INTO GalleryLocatedIn ($from_id, $to_id)
VALUES
((SELECT $node_id FROM Gallery WHERE id = 1), (SELECT $node_id FROM Country WHERE id = 4)),
((SELECT $node_id FROM Gallery WHERE id = 2), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Gallery WHERE id = 3), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Gallery WHERE id = 4), (SELECT $node_id FROM Country WHERE id = 4)),
((SELECT $node_id FROM Gallery WHERE id = 5), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Gallery WHERE id = 6), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Gallery WHERE id = 7), (SELECT $node_id FROM Country WHERE id = 7)), 
((SELECT $node_id FROM Gallery WHERE id = 8), (SELECT $node_id FROM Country WHERE id = 5)),
((SELECT $node_id FROM Gallery WHERE id = 9), (SELECT $node_id FROM Country WHERE id = 6)),
((SELECT $node_id FROM Gallery WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 6));


-- 5. Запросы с использованием MATCH
-- 5.1. Все стили, в которых работал Сальвадор Дали
SELECT s.name AS StyleName
FROM Artist, PaintsInStyle, ArtStyle s
WHERE MATCH(Artist-(PaintsInStyle)->s)
AND Artist.name = N'Сальвадор Дали';

-- 5.2. Все галереи, где выставляется Винсент ван Гог
SELECT g.name AS GalleryName, g.city
FROM Artist, ExhibitsInGallery, Gallery g
WHERE MATCH(Artist-(ExhibitsInGallery)->g)
AND Artist.name = N'Винсент ван Гог';

-- 5.3. Все художники, которые жили в Италии
SELECT a.name AS ArtistName, a.birth_year, a.death_year
FROM Country, LivedInCountry, Artist a
WHERE MATCH(Country<-(LivedInCountry)-a)
AND Country.name = N'Италия';

-- 5.4. Все художники, работавшие в стиле импрессионизм
SELECT a.name AS ArtistName
FROM ArtStyle, PaintsInStyle, Artist a
WHERE MATCH(ArtStyle<-(PaintsInStyle)-a)
AND ArtStyle.name = N'Импрессионизм';

-- 5.5. Все галереи в Испании
SELECT g.name AS GalleryName, g.city
FROM Country, GalleryLocatedIn, Gallery g
WHERE MATCH(Country<-(GalleryLocatedIn)-g)
AND Country.name = N'Испания';

-- 6. Запросы с использованием SHORTEST_PATH
-- 6.1. Найти путь через общие галереи между Леонардо да Винчи и Казимиром Малевичем
DECLARE @ArtistFrom AS NVARCHAR(50) = N'Леонардо да Винчи';
DECLARE @ArtistTo AS NVARCHAR(50) = N'Казимир Малевич';

WITH PathResults AS (
    SELECT
        Artist1.name AS StartArtist,
        LAST_VALUE(Artist2.name) WITHIN GROUP (GRAPH PATH) AS EndArtist,
        STRING_AGG(g.name, ' → ') WITHIN GROUP (GRAPH PATH) AS GalleryPath,
        STRING_AGG(Artist2.name, ' → ') WITHIN GROUP (GRAPH PATH) AS ArtistPath,
        COUNT(Artist2.name) WITHIN GROUP (GRAPH PATH) AS ConnectionSteps
    FROM
        Artist AS Artist1,
        ExhibitsInGallery FOR PATH AS eig,
        Gallery FOR PATH AS g,
        ExhibitsInGallery FOR PATH AS eig2,
        Artist FOR PATH AS Artist2
    WHERE
        MATCH(SHORTEST_PATH(Artist1(-(eig)->g<-(eig2)-Artist2)+))
        AND Artist1.name = @ArtistFrom
)
SELECT
    StartArtist AS [Начальный художник],
    EndArtist AS [Конечный художник],
    GalleryPath AS [Путь через галереи],
    ArtistPath AS [Полная цепочка художников],
    ConnectionSteps AS [Количество шагов]
FROM
    PathResults
WHERE
    EndArtist = @ArtistTo
ORDER BY
    ConnectionSteps;

-- 6.2. Найти все возможные связи между художниками через общие стили
SELECT 
    Artist1.name AS [Исходный художник],
    LAST_VALUE(Artist2.name) WITHIN GROUP (GRAPH PATH) AS [Конечный художник],
    STRING_AGG(Artist2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Цепочка художников],
    STRING_AGG(s.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Использованные стили],
    COUNT(Artist2.name) WITHIN GROUP (GRAPH PATH) AS [Длина цепочки]
FROM 
    Artist AS Artist1,
    PaintsInStyle FOR PATH AS pis,
    ArtStyle FOR PATH AS s,
    PaintsInStyle FOR PATH AS pis2,
    Artist FOR PATH AS Artist2
WHERE 
    MATCH(SHORTEST_PATH(Artist1(-(pis)->s<-(pis2)-Artist2){1,2}))
    AND Artist1.name = N'Пабло Пикассо'
ORDER BY 
    [Длина цепочки], [Конечный художник];


-- 7. Запросы для визуализации в Power BI

SELECT 
    a.id AS ArtistId,
    a.name AS ArtistName,
    CONCAT('Artist', a.id) AS [ArtistImageName],
    s.id AS StyleId,
    s.name AS StyleName,
    CONCAT('Style', s.id) AS [StyleImageName],
    'PaintsInStyle' AS RelationshipType
FROM Artist AS a
    , PaintsInStyle AS pis
    , ArtStyle AS s
WHERE MATCH(a-(pis)->s)


SELECT 
    a.id AS ArtistId,
    a.name AS ArtistName,
    CONCAT('Artist', a.id) AS [ArtistImageName],
    g.id AS GalleryId,
    g.name AS GalleryName,
    CONCAT('Gallery', g.id) AS [GalleryImageName],
    'ExhibitsInGallery' AS RelationshipType
FROM Artist AS a
    , ExhibitsInGallery AS eig
    , Gallery AS g
WHERE MATCH(a-(eig)->g)


SELECT 
    a.id AS ArtistId,
    a.name AS ArtistName,
    CONCAT('Artist', a.id) AS [ArtistImageName],
    c.id AS CountryId,
    c.name AS CountryName,
    CONCAT('Country', c.id) AS [CountryImageName],
    'LivedInCountry' AS RelationshipType
FROM Artist AS a
    , LivedInCountry AS lic
    , Country AS c
WHERE MATCH(a-(lic)->c)


SELECT 
    g.id AS GalleryId,
    g.name AS GalleryName,
    CONCAT('Gallery', g.id) AS [GalleryImageName],
    c.id AS CountryId,
    c.name AS CountryName,
    CONCAT('Country', c.id) AS [CountryImageName],
    'GalleryLocatedIn' AS RelationshipType
FROM Gallery AS g
    , GalleryLocatedIn AS gli
    , Country AS c
WHERE MATCH(g-(gli)->c);

