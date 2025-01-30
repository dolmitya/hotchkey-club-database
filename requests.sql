--1. Выбрать все данные об игроках. 
SELECT * FROM Player;

--2. Выбрать имена игроков без повторений. 
SELECT DISTINCT name FROM Player;

--3. Выбрать данные об игроках старше 30 лет. Результат отсортировать по фамилии в лексикографическом порядке. 
SELECT * FROM Player
WHERE age(date_of_birth) > interval '30 years'
ORDER BY surname ASC;

--4. Выбрать фамилию, имя, отчество, дату рождения игрока.
--В результат должны войти игроки с фамилией, начинающейся на
--«К» или «М» и состоящей из 4 букв. Результат отсортировать по
--убыванию возраста и по фамилии, имени, отчеству в порядке обратом лексикографическому. 
SELECT surname, name, patronymic, date_of_birth FROM Player
WHERE (surname LIKE 'К___' OR surname LIKE 'М___')
ORDER BY age(date_of_birth) DESC, surname DESC, name DESC, patronymic DESC;

--5. Выбрать спонсоров, в названии которых есть символы
--«?», «_», «*», «&» и нет символов «%» и «?».
SELECT * FROM Sponsor
WHERE name_sponsor ~ '[?_*&]' AND name_sponsor NOT LIKE '#?' AND name_sponsor NOT LIKE '#%' ESCAPE '#';

--6. Выбрать фамилии, имена, отчества игроков в возрасте от 18 до 21 года. 
SELECT surname, name, patronymic FROM Player
WHERE age(date_of_birth) BETWEEN interval '18 years' AND interval '21 years';

--7. Выбрать все данные о тренерах с id = 1, 3, 4, 7, 10. 
SELECT * FROM Coach
WHERE id_coach IN (1, 3, 4, 7, 10);

--8. Выбрать id тренера, у которого не указан телефон. 
SELECT id_coach FROM Coach
WHERE telephone IS NULL;

--9. Выбрать максимальный возраст тренера. 
SELECT MAX(age(date_of_birth)) AS max_age
FROM Coach;

--10. Выбрать минимальный и средний сроки заключения контрактов в текущем году.
SELECT MIN(period_of_validity), AVG(period_of_validity) 
FROM Contract 
WHERE EXTRACT(YEAR FROM date_of_conclusion) = EXTRACT(YEAR FROM CURRENT_DATE);

--11. Выбрать фамилию, имя, отчество игрока, дату рождения,
--пол, национальность. Результат отсортировать по национальности
--в лексикографическом порядке, возрасту в убывающем порядке,
--фамилии в порядке обратном лексикографическому и имени отчеству в лексикографическом порядке. 
SELECT surname, name, patronymic, date_of_birth, gender, name_nationality FROM Player
JOIN Nationality ON Player.id_nationality = Nationality.id_nationality
ORDER BY name_nationality ASC, age(date_of_birth) DESC, surname DESC, name ASC, patronymic ASC;

--12. Выбрать фамилию и инициалы игроков, национальность,
--дату принятия состава, фамилию и имя (в одном столбце) тренера,
--фамилию руководителя, дату начала и окончания контракта, название спонсора
SELECT 
    p.surname || ' ' || SUBSTRING(p.name FROM 1 FOR 1) || '.' || SUBSTRING(p.patronymic FROM 1 FOR 1) || '.' AS "Player",
    n.name_nationality AS "Nationality",
    s.date_of_conclusion AS "Date of Acceptance",
    c.surname || ' ' || c.name AS "Coach",
    g.surname AS "Guide",
    con.date_of_conclusion AS "Contract Start",
    (con.date_of_conclusion + INTERVAL '1 year' * con.period_of_validity) AS "Contract End",
    sp.name_sponsor AS "Sponsor"
FROM Player p
JOIN Nationality n ON p.id_nationality = n.id_nationality
JOIN Player_Staff ps ON p.id_player = ps.id_player
JOIN Staff s ON ps.id_staff = s.id_staff
JOIN Coaching_staff_Staff css ON s.id_staff = css.id_staff
JOIN Guide g ON s.id_guide = g.id_guide
JOIN Contract con ON p.id_player = con.id_player
LEFT JOIN Coach c ON c.id_coach_staff = css.id_staff
JOIN Sponsor sp ON con.id_sponsor = sp.id_sponsor

--13. Выбрать общую сумму, которую вложил спонсор с каким-то конкретным названием (конкретное значение подставьте
--сами). 
SELECT 
    SUM(c.annual_payment) AS "Total Investment"
FROM Contract c
JOIN Sponsor s ON c.id_sponsor = s.id_sponsor
WHERE s.name_sponsor = 'Спонсор 5';

--14. Выбрать фамилию, имя, отчество руководителя и общее
--количество утвержденных тренеров. Результат отсортировать по
--количеству. 
SELECT 
    g.surname, g.name, g.patronymic, COUNT(c.id_coach) AS "Approved Coaches"
FROM Guide g
JOIN Staff s ON g.id_guide = s.id_guide
JOIN Coaching_staff cs ON cs.id_guide = g.id_guide
JOIN Coach c ON cs.id_coach_staff = c.id_coach_staff
GROUP BY g.surname, g.name, g.patronymic
ORDER BY "Approved Coaches" DESC;

--15. Выбрать среднюю стоимость российских игроков. 
SELECT 
    AVG(p.salary) AS "Average Salary"
FROM Player p
JOIN Nationality n ON p.id_nationality = n.id_nationality
WHERE n.name_nationality = 'Русский';

--16. Для каждого игрока выбрать количество контрактов.
SELECT id_player, COUNT(id_contract) AS contract_count
FROM Contract
GROUP BY id_player;

--17 Выбрать все данные об игроках, с которыми заключен только один контракт.
SELECT P.*
FROM Player P
JOIN Contract C ON C.id_player = P.id_player
GROUP BY P.id_player
HAVING COUNT(C.id_contract) = 1;

--18. Выбрать спонсоров, потративших на игроков более 1000000 
--и заключивших контракт как минимум с 3 игроками.
SELECT S.id_sponsor, S.name_sponsor
FROM Sponsor S
JOIN Contract C ON S.id_sponsor = C.id_sponsor
GROUP BY S.id_sponsor, S.name_sponsor
HAVING SUM(C.annual_payment) > 1000000 AND COUNT(DISTINCT C.id_player) >= 3;

--19. Выбрать для каждого игрока дату начала последнего заключенного контракта.
SELECT P.id_player, P.surname, P.name, MAX(date_of_conclusion) AS last_contract_date
FROM Contract C
JOIN Player P ON C.id_player = P.id_player
GROUP BY P.id_player, P.surname, P.name;

--20. Выбрать названия спонсоров, которые спонсируют только одного игрока. 
SELECT S.name_sponsor
FROM Sponsor S
JOIN Contract C ON S.id_sponsor = C.id_sponsor
GROUP BY S.id_sponsor, S.name_sponsor
HAVING COUNT(DISTINCT C.id_player) = 1;

--21. Вывести в первом столбце фамилии, имена, отчества
--тренеров, во втором – название биологического возраста по классификации
--Всемирной организации здравоохранения (от 25 до
--44 лет – молодой возраст, 44–60 лет – средний возраст, 60–
--75 лет – пожилой возраст, 75–90 лет – старческий возраст, после
--90 – долгожители.). 
SELECT surname, name, patronymic,
       CASE
           WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 25 AND 44 THEN 'молодой возраст'
           WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 45 AND 60 THEN 'средний возраст'
           WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 61 AND 75 THEN 'пожилой возраст'
           WHEN EXTRACT(YEAR FROM AGE(date_of_birth)) BETWEEN 76 AND 90 THEN 'старческий возраст'
           ELSE 'долгожители'
       END AS age_category
FROM Coach;

--22. Для каждого состава (выбрать id, дату принятия, схему)
--вывести в разных столбцах количество игроков до 23 лет,
--количество игроков от 24 до 28 лет и количество игроков старше 28, а
--также вывести средний возраст игроков. 
SELECT C.id_staff, 
       SUM(CASE WHEN EXTRACT(YEAR FROM AGE(P.date_of_birth)) < 23 THEN 1 ELSE 0 END) AS players_under_23,
       SUM(CASE WHEN EXTRACT(YEAR FROM AGE(P.date_of_birth)) BETWEEN 24 AND 28 THEN 1 ELSE 0 END) AS players_24_to_28,
       SUM(CASE WHEN EXTRACT(YEAR FROM AGE(P.date_of_birth)) > 28 THEN 1 ELSE 0 END) AS players_above_28,
       AVG(EXTRACT(YEAR FROM AGE(P.date_of_birth))) AS average_age
FROM Staff C
JOIN Player_Staff PS ON C.id_staff = PS.id_staff
JOIN Player P ON PS.id_player = P.id_player
GROUP BY C.id_staff;

--23. Выбрать фамилии и национальность игроков, имеющих
--более трех контрактов и тренирующихся у Иванова Ивана Ивановича.
SELECT P.surname, N.name_nationality
FROM Player P
	JOIN Contract CON ON CON.id_player = P.id_player
	JOIN Nationality N ON P.id_nationality = N.id_nationality
	JOIN Player_Staff PS ON PS.id_player = P.id_player
    JOIN Staff S ON PS.id_staff = S.id_staff
    JOIN Coaching_staff_Staff CSS ON CSS.id_staff = S.id_staff
	JOIN Coaching_staff CS ON CS.id_coach_staff = CSS.id_coach_staff
	JOIN Coach C ON C.id_coach_staff = CS.id_coach_staff
WHERE C.surname = 'Иванов' AND C.name = 'Иван' AND C.patronymic = 'Иванович'
GROUP BY P.id_player, P.surname, N.name_nationality
HAVING COUNT(CON.id_contract)>=3;--

--24. Выбрать id и фамилии, имена, отчества игроков, у которых срок 
--завершения контракта истекает в течение ближайшего месяца. 
SELECT P.id_player, P.surname, P.name, P.patronymic
FROM Player P
JOIN Contract C ON P.id_player = C.id_player
WHERE (C.date_of_conclusion + INTERVAL '1 year' * C.period_of_validity)
		BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 month';

--25. Для каждого года заключения контрактов вывести количество контрактов, 
--заключенных с российскими игроками. В результат должны войти только года, 
--в которые заключено более 2 контрактов. 
SELECT EXTRACT(YEAR FROM C.date_of_conclusion) AS year, COUNT(C.id_contract) AS contract_count
FROM Contract C
JOIN Player P ON C.id_player = P.id_player
JOIN Nationality N ON P.id_nationality = N.id_nationality
WHERE N.name_nationality = 'Русский'
GROUP BY EXTRACT(YEAR FROM C.date_of_conclusion)
HAVING COUNT(C.id_contract) > 2;

--26. Выбрать название спонсоров, которые заключают договора как минимум на три года.
SELECT s.name_sponsor
FROM Sponsor s
	JOIN Contract c ON s.id_sponsor = c.id_sponsor
GROUP BY s.id_sponsor, s.name_sponsor
HAVING MIN(c.period_of_validity) >= 3;

--27. Выбрать все данные о самом старшем тренере.
SELECT *
FROM Coach
WHERE date_of_birth = (SELECT MIN(date_of_birth) FROM Coach);

--28. Выбрать id и фамилию, имя, отчество спонсора, который
--оплачивает только одного русского игрока.
SELECT s.id_sponsor, s.name_sponsor
FROM Sponsor s
JOIN Contract c ON s.id_sponsor = c.id_sponsor
JOIN Player p ON c.id_player = p.id_player
JOIN Nationality n ON p.id_nationality = n.id_nationality
WHERE n.name_nationality = 'Русский'
GROUP BY s.id_sponsor, s.name_sponsor
HAVING COUNT(DISTINCT p.id_player) = 1;

--29. Выбрать данные состава, который имеет наибольшее количество забитых голов.
SELECT s.*
FROM Staff s
	JOIN Match m ON m.id_staff = s.id_staff    
GROUP BY s.id_staff
HAVING SUM(m.number_goals_scored) >= ALL(SELECT SUM(number_goals_scored) 
									      FROM Match
									      GROUP BY id_staff);

--30. Выбрать фамилию и инициалы тренеров, которые в составе, имеющем более 5 тренеров.
SELECT c.surname, CONCAT(SUBSTRING(c.name, 1, 1), '.', SUBSTRING(c.patronymic, 1, 1), '.') AS initials
FROM Coach c
	JOIN (SELECT id_coach_staff, COUNT(id_coach) AS countCoach
		  FROM Coach
		  GROUP BY id_coach_staff)
	csCount ON csCount.id_coach_staff = c.id_coach_staff
WHERE csCount.countCoach >= 5;

--31. Выбрать название спонсора, который заключил договоры
--с наибольшим количеством игроков из Германии.
SELECT s.name_sponsor
FROM Sponsor s
JOIN Contract c ON s.id_sponsor = c.id_sponsor
JOIN Player p ON c.id_player = p.id_player
JOIN Nationality n ON p.id_nationality = n.id_nationality
WHERE n.name_nationality = 'Немец'
GROUP BY s.id_sponsor, s.name_sponsor
HAVING COUNT(c.id_contract) >= ALL(SELECT COUNT(c.id_contract)
									FROM Contract c
									JOIN Player p ON c.id_player = p.id_player
									JOIN Nationality n ON p.id_nationality = n.id_nationality
									WHERE n.name_nationality = 'Немец'
									GROUP BY s.id_sponsor);

--32. Выбрать спонсора, у которого наибольшее количество
--договоров с одним и тем же игроком.
SELECT s.name_sponsor
FROM Sponsor s
JOIN Contract c ON s.id_sponsor = c.id_sponsor
GROUP BY s.id_sponsor, s.name_sponsor, c.id_player
HAVING COUNT(c.id_contract) = (
    SELECT MAX(count_contracts)
    FROM (
        SELECT COUNT(c2.id_contract) AS count_contracts
        FROM Contract c2
        GROUP BY c2.id_sponsor, c2.id_player
    )
);

--33. Выбрать фамилии и инициалы руководителей, в чьем составе есть игроки, 
--дата завершения контракта с которыми истекает в текущем месяце.
SELECT g.surname, CONCAT(SUBSTRING(g.name, 1, 1), '.', SUBSTRING(g.patronymic, 1, 1), '.') AS initials
FROM Guide g
JOIN Coaching_staff cs ON g.id_guide = cs.id_guide
JOIN Staff st ON st.id_guide = g.id_guide
JOIN Player_Staff ps ON st.id_staff = ps.id_staff
JOIN Player p ON ps.id_player = p.id_player
JOIN Contract c ON c.id_player = p.id_player
WHERE EXTRACT(YEAR FROM CURRENT_DATE) = EXTRACT(YEAR FROM c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity)
  AND EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity);

--34. Выбрать тройку игроков, с которыми заключены последние контракты.
SELECT p.surname, p.name, p.patronymic
FROM Player p
JOIN Contract c ON p.id_player = c.id_player
WHERE c.date_of_conclusion IN (
    SELECT DISTINCT date_of_conclusion
    FROM Contract
    ORDER BY date_of_conclusion DESC
    LIMIT 3
);

--35. Выбрать названия спонсоров, которые не заключали контракты последние полгода.
SELECT DISTINCT(s.name_sponsor)
FROM Sponsor s
WHERE NOT EXISTS (SELECT 1 
				  FROM Contract c
				  WHERE s.id_sponsor = c.id_sponsor AND c.date_of_conclusion > CURRENT_DATE - INTERVAL '6 months');

-- 36. Данные обо всех игроках и сообщение для тех, у кого истекает контракт в этом году.
SELECT p.*, s.name_sponsor,  
       CASE 
           WHEN EXTRACT(YEAR FROM c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity) = EXTRACT(YEAR FROM CURRENT_DATE) 
           THEN 'продлить контракт' 
           ELSE NULL 
       END AS contract_status
FROM Player p
LEFT JOIN Contract c ON p.id_player = c.id_player 
						AND CURRENT_DATE BETWEEN c.date_of_conclusion 
										 AND (c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity)  --ПЕРЕДЕЛАЛ!
LEFT JOIN Sponsor s ON c.id_sponsor=s.id_sponsor;

-- 37. Прибыль для каждого игрока по контракту актуальному на 12 апреля 2019 года.
SELECT p.surname, p.name, p.patronymic, 
       c.annual_payment * c.period_of_validity AS total_income
FROM Player p
JOIN Contract c ON p.id_player = c.id_player
WHERE '2019-04-12' BETWEEN c.date_of_conclusion AND (c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity);

-- 38. Однофамильцы-тезки среди тренеров и игроков.
SELECT 
    C.surname, 
    C.name AS coach_name, 
    C.patronymic AS coach_patronymic,
    P.name AS player_name,
    P.patronymic AS player_patronymic
FROM 
    Coach C
JOIN 
    Player P
ON 
    C.surname = P.surname ;--люди вместо фамилий

-- 39. Все однофамильцы по всей базе данных.
SELECT 
    p.role, 
    p.id, 
    p.surname, 
    p.name, 
    p.patronymic
FROM (
    SELECT id_player AS id, 'Player' AS role, surname, name, patronymic FROM Player
    UNION ALL
    SELECT id_coach AS id, 'Coach' AS role, surname, name, patronymic FROM Coach
    UNION ALL
    SELECT id_guide AS id, 'Guide' AS role, surname, name, patronymic FROM Guide
) p
WHERE p.surname IN (
    SELECT surname
    FROM (
        SELECT surname FROM Player
        UNION ALL
        SELECT surname FROM Coach
        UNION ALL
        SELECT surname FROM Guide
    ) all_surnames
    GROUP BY surname
    HAVING COUNT(*) > 1
);--люди вместо фамилий

-- 40. Общее количество однофамильцев по всей БД.
SELECT SUM(count_surnames) AS total_surnames
FROM (
    SELECT COUNT(*) AS count_surnames
    FROM (
        SELECT surname FROM Player
        UNION ALL
        SELECT surname FROM Coach
        UNION ALL
        SELECT surname FROM Guide
    ) AS all_surnames
    GROUP BY surname
    HAVING COUNT(*) > 1
) AS surname_counts;

-- 41. id и ФИО тренеров, которые тренировали 2 и более состава без пропущенных шайб.
SELECT t.id_coach, t.surname, t.name, t.patronymic
FROM Coach t
JOIN Coaching_staff cs ON t.id_coach_staff = cs.id_coach_staff
JOIN Coaching_staff_Staff css ON css.id_coach_staff = cs.id_coach_staff
JOIN Match m ON css.id_staff = m.id_staff
WHERE m.number_missed_pucks = 0
GROUP BY t.id_coach, t.surname, t.name, t.patronymic
HAVING COUNT(DISTINCT m.id_staff) >= 2;

-- 42. Названия спонсоров и фамилии с инициалами руководителей, отсортированные лексикографически.
SELECT name_sponsor AS entity 
FROM Sponsor
UNION ALL
SELECT CONCAT(surname, ' ', SUBSTRING(name, 1, 1), '.', SUBSTRING(patronymic, 1, 1), '.') AS entity 
FROM Guide
ORDER BY entity;

-- 43. Сообщение, если есть игроки с просроченным контрактом.
SELECT CASE 
           WHEN EXISTS (
               SELECT 1
               FROM Contract c
               WHERE CURRENT_DATE > (c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity)
                 AND NOT EXISTS (
                     SELECT 1
                     FROM Contract new_c
                     WHERE new_c.id_player = c.id_player
                       AND new_c.date_of_conclusion > (c.date_of_conclusion + INTERVAL '1 year' * c.period_of_validity)
                 )
           ) 
           THEN 'Есть игроки с просроченным контрактом'
           ELSE 'Нет игроков с просроченными контрактами'
       END AS message; --в следующий семестр доделать запрос для каждого игрока макс дату и сравнивать эту дату

-- 44. Для каждого спонсора выбрать всех руководителей и количество игроков по контрактам.
SELECT 
    s.name_sponsor,
    g.surname || ' ' || LEFT(g.name, 1) || '.' || LEFT(g.patronymic, 1) || '.' AS guide_initials,
    COUNT(DISTINCT c.id_player) AS player_count
FROM Sponsor s
LEFT JOIN Contract c ON s.id_sponsor = c.id_sponsor
LEFT JOIN Player p ON c.id_player = p.id_player
LEFT JOIN Player_Staff ps ON ps.id_player = p.id_player
LEFT JOIN Staff st ON ps.id_staff = st.id_staff
LEFT JOIN Guide g ON st.id_guide = g.id_guide --сделать cross join чтобы не терять руководителей
GROUP BY 
    s.name_sponsor, g.surname, g.name, g.patronymic;
	
	
SELECT 
    s.name_sponsor,
    g.surname || ' ' || LEFT(g.name, 1) || '.' || LEFT(g.patronymic, 1) || '.' AS guide_initials,
    COUNT(DISTINCT c.id_player) AS player_count
FROM Sponsor s
CROSS JOIN Guide g
LEFT JOIN Staff st ON g.id_guide = st.id_guide
LEFT JOIN Player_Staff ps ON st.id_staff = ps.id_staff
LEFT JOIN Player p ON ps.id_player = p.id_player
LEFT JOIN Contract c ON s.id_sponsor = c.id_sponsor AND c.id_player = p.id_player
GROUP BY 
    s.name_sponsor, g.surname, g.name, g.patronymic;

-- 45. ФИО игрока, который заключал контракты со всеми спонсорами в БД.
SELECT p.surname, p.name, p.patronymic
FROM Player p
WHERE NOT EXISTS (
    SELECT 1
    FROM Sponsor s
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contract c
        WHERE c.id_player = p.id_player AND c.id_sponsor = s.id_sponsor
    )
);--в след семестр сделать вариант 2, для игрока считать кол-во спонсоров и сравнить с общим кол-вом спонсоров

SELECT p.surname, p.name, p.patronymic
FROM Player p
JOIN Contract c ON p.id_player = c.id_player
JOIN Sponsor s ON c.id_sponsor = s.id_sponsor
GROUP BY p.id_player, p.surname, p.name, p.patronymic
HAVING COUNT(DISTINCT s.id_sponsor) = (SELECT COUNT(*) FROM Sponsor);

--46. Выбрать название спонсора, который последние три года
--не заключал новых контрактов с игроками и имеет наибольший
--ежегодный платеж среди всех спонсоров, не заключавших контракты последние три года. 
SELECT s.name_sponsor
FROM Sponsor s
JOIN Contract c ON c.id_sponsor=s.id_sponsor
WHERE s.id_sponsor NOT IN ( --через EXISTS
    SELECT c.id_sponsor
    FROM Contract c
    WHERE c.date_of_conclusion >= CURRENT_DATE - INTERVAL '3 years'
)
GROUP BY s.id_sponsor, s.name_sponsor
HAVING SUM(c.annual_payment) >= ALL (
    SELECT SUM(c.annual_payment)
    FROM Sponsor s2
	JOIN Contract c ON c.id_sponsor=s.id_sponsor
    WHERE s2.id_sponsor NOT IN (
        SELECT c.id_sponsor
        FROM Contract c
        WHERE c.date_of_conclusion >= CURRENT_DATE - INTERVAL '3 years'
    )
	GROUP BY s.id_sponsor
);

SELECT s.name_sponsor
FROM Sponsor s
JOIN Contract c ON c.id_sponsor=s.id_sponsor
WHERE NOT EXISTS ( --сделал
    SELECT 1
    FROM Contract c
    WHERE s.id_sponsor=c.id_sponsor AND c.date_of_conclusion >= CURRENT_DATE - INTERVAL '3 years'
)
GROUP BY s.id_sponsor, s.name_sponsor
HAVING SUM(c.annual_payment) >= ALL (
    SELECT SUM(c.annual_payment)
    FROM Sponsor s2
	JOIN Contract c ON c.id_sponsor=s.id_sponsor
    WHERE s2.id_sponsor NOT IN (
        SELECT c.id_sponsor
        FROM Contract c
        WHERE c.date_of_conclusion >= CURRENT_DATE - INTERVAL '3 years'
    )
	GROUP BY s.id_sponsor
);

--47. Выбрать фамилии, имена, отчества игроков, играющих в
--наиболее успешном составе. 
SELECT p.surname, p.name, p.patronymic, ps.id_staff
FROM Player p
JOIN Player_Staff ps ON p.id_player = ps.id_player
JOIN Staff st ON ps.id_staff = st.id_staff
JOIN Match m ON st.id_staff = m.id_staff
WHERE (m.number_goals_scored > m.number_missed_pucks)
GROUP BY p.surname, p.name, p.patronymic, ps.id_staff
HAVING COUNT(m.id_match) >= ALL (
    SELECT COUNT(m2.id_match)
    FROM Match m2
    WHERE (m2.number_goals_scored > m2.number_missed_pucks)
    GROUP BY m2.id_staff
);

--48. Выбрать название национальности, игроки которой играют в составе, включающем игроков только одной национальности.
SELECT DISTINCT n.name_nationality
FROM Nationality n
JOIN Player p ON n.id_nationality = p.id_nationality
JOIN Player_Staff ps ON p.id_player = ps.id_player
JOIN Staff st ON ps.id_staff = st.id_staff
GROUP BY st.id_staff, n.name_nationality
HAVING COUNT(DISTINCT p.id_nationality) = 1;

--49. Выбрать фамилии, имена, отчества, дату рождения и телефон тренеров, которые тренируют межнациональные команды
--на данный момент (учтите даты контрактов).
SELECT DISTINCT c.surname, c.name, c.patronymic, c.date_of_birth, c.telephone
FROM Coach c
JOIN Coaching_staff cs ON c.id_coach_staff = cs.id_coach_staff
JOIN Coaching_staff_Staff css ON css.id_coach_staff = cs.id_coach_staff
JOIN Staff st ON st.id_staff = css.id_staff
WHERE st.id_guide IN (
    SELECT st2.id_guide --убрать подзапрос
    FROM Staff st2
    JOIN Player_Staff ps2 ON st2.id_staff = ps2.id_staff
    JOIN Player p2 ON ps2.id_player = p2.id_player
    GROUP BY st2.id_guide
    HAVING COUNT(DISTINCT p2.id_nationality) > 1
)
AND CURRENT_DATE BETWEEN st.date_of_conclusion AND (st.date_of_conclusion + INTERVAL '1 year' * st.period_validity);

SELECT DISTINCT c.surname, c.name, c.patronymic, c.date_of_birth, c.telephone
FROM Coach c
JOIN Coaching_staff cs ON c.id_coach_staff = cs.id_coach_staff
JOIN Coaching_staff_Staff css ON css.id_coach_staff = cs.id_coach_staff
JOIN Staff st ON st.id_staff = css.id_staff
JOIN Player_Staff ps ON st.id_staff = ps.id_staff
JOIN Player p ON ps.id_player = p.id_player
AND CURRENT_DATE BETWEEN st.date_of_conclusion AND (st.date_of_conclusion + INTERVAL '1 year' * st.period_validity)
GROUP BY c.surname, c.name, c.patronymic, c.date_of_birth, c.telephone, st.id_guide
HAVING COUNT(DISTINCT p.id_nationality) > 1;

--50. Выбрать самого дорогого игрока, играющего в составе,
--тренируемом Ивановым Иваном Ивановичем
SELECT p.surname, p.name, p.patronymic, SUM(con.annual_payment)
FROM Player p
JOIN Contract con ON p.id_player = con.id_player
JOIN Player_Staff ps ON p.id_player = ps.id_player
JOIN Staff s ON ps.id_staff = s.id_staff
JOIN Coaching_staff_Staff cs ON s.id_staff = cs.id_staff
JOIN Coach c ON cs.id_coach_staff = c.id_coach_staff
WHERE c.surname = 'Иванов'
  AND c.name = 'Иван'
  AND c.patronymic = 'Иванович'
GROUP BY p.id_player, p.surname, p.name, p.patronymic, p.salary, s.id_staff
HAVING SUM(con.annual_payment) >= ALL (
      SELECT SUM(con2.annual_payment)
	  FROM Player p2
      JOIN Contract con2 ON p2.id_player = con2.id_player
	  JOIN Player_Staff ps2 ON p2.id_player = ps2.id_player
	  JOIN Staff s2 ON ps2.id_staff = s2.id_staff
	  JOIN Coaching_staff_Staff cs2 ON s2.id_staff = cs2.id_staff
	  JOIN Coach c2 ON cs2.id_coach_staff = c2.id_coach_staff
	  WHERE c2.surname = 'Иванов'
  		AND c2.name = 'Иван'
  		AND c2.patronymic = 'Иванович'
	  GROUP BY p2.id_player, p2.surname, p2.name, p2.patronymic, p2.salary, s2.id_staff 
  );
  
SELECT p.surname, p.name, p.patronymic, p.salary
FROM Player p
JOIN Player_Staff ps ON p.id_player = ps.id_player
JOIN Staff s ON ps.id_staff = s.id_staff
JOIN Coaching_staff_Staff cs ON s.id_staff = cs.id_staff
JOIN Coach c ON cs.id_coach_staff = c.id_coach_staff
WHERE c.surname = 'Иванов'
  AND c.name = 'Иван'
  AND c.patronymic = 'Иванович'
  AND p.salary >= ALL (
      SELECT p2.salary
	  FROM Player p2
	  JOIN Player_Staff ps2 ON p2.id_player = ps2.id_player
	  JOIN Staff s2 ON ps2.id_staff = s2.id_staff
	  JOIN Coaching_staff_Staff cs2 ON s2.id_staff = cs2.id_staff
	  JOIN Coach c2 ON cs2.id_coach_staff = c2.id_coach_staff
	  WHERE c2.surname = 'Иванов'
  		AND c2.name = 'Иван'
  		AND c2.patronymic = 'Иванович'
  );