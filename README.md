# База данных хоккейного клуба

## Описание проекта
Спроектировать БД хоккейного клуба. В БД должна храниться информация об игроках (фамилия, имя, отчество, паспортные
данные, дата рождения, номер игрока, рост, вес, телефон, национальность, позиция, размер оплаты хоккеисту). С хоккеистом заключается контракт. У контракта есть номер, дата заключения,
указывается период действия контракта. У игрока может быть
спонсор, тогда в контракте указываются название спонсора и ежегодный платеж.
Кроме того, в БД необходимо фиксировать информацию о
руководстве: фамилию, имя, отчество, паспортные данные, дату
рождения, телефон.
Информация о тренере включает фамилию, имя, отчество,
паспортные данные, дату рождения, телефон, лицензию. Тренерский состав утверждается руководителем. В БД фиксируется дата
принятия тренерского состава.
Общий состав игроков и тренерского состава имеют результаты участия в соревнованиях. Для каждой сыгранной игры указываются название противника, количество забитых, количество
пропущенных шайб, проданных билетов, тактика и схема. По результатам соревнования: место в лиге, полученный призовой
фонд, контракт со спонсором (название спонсора, ежегодный платеж, период действия контракта).
![image](https://github.com/user-attachments/assets/d45ec5c5-6440-4e8f-82b6-89503ba74a38)
![image](https://github.com/user-attachments/assets/58b28f81-1bbe-4ad5-bdf1-6f001fea0d7d)

## SQL-запросы
1. Выбрать все данные об игроках.
2. Выбрать имена игроков без повторений.
3. Выбрать данные об игроках старше 30 лет. Результат отсортировать по фамилии в лексикографическом порядке.
4. Выбрать фамилию, имя, отчество, дату рождения игрока.
В результат должны войти игроки с фамилией, начинающейся на
«К» или «М» и состоящей из 4 букв. Результат отсортировать по
убыванию возраста и по фамилии, имени, отчеству в порядке обратом лексикографическому.
5. Выбрать спонсоров, в названии которых есть символы
«?», «_», «*», «&» и нет символов «%» и «?».
6. Выбрать фамилии, имена, отчества игроков в возрасте от
18 до 21 года.
7. Выбрать все данные о тренерах с id = 1, 3, 4, 7, 10.
8. Выбрать id тренера, у которого не указан телефон.
9. Выбрать максимальный возраст тренера.
10. Выбрать минимальный и средний сроки заключения контрактов в текущем году.
11. Выбрать фамилию, имя, отчество игрока, дату рождения,
пол, национальность. Результат отсортировать по национальности
в лексикографическом порядке, возрасту в убывающем порядке,
фамилии в порядке обратном лексикографическому и имени отчеству в лексикографическом порядке.
12. Выбрать фамилию и инициалы игроков, национальность,
дату принятия состава, фамилию и имя (в одном столбце) тренера,
фамилию руководителя, дату начала и окончания контракта, название спонсора.
13. Выбрать общую сумму, которую вложил спонсор с каким-то конкретным названием (конкретное значение подставьте
сами).
14. Выбрать фамилию, имя, отчество руководителя и общее
количество утвержденных тренеров. Результат отсортировать по
количеству.
15. Выбрать среднюю стоимость российских игроков.
16. Для каждого игрока выбрать количество контрактов.
17. Выбрать все данные об игроках, с которыми заключен
только один контракт.
18. Выбрать спонсоров, потративших на игроков более
1000 000 и заключивших контракт как минимум с 3 игроками.
19. Выбрать для каждого игрока дату начала последнего заключенного контракта.
20. Выбрать названия спонсоров, которые спонсируют только одного игрока.
21. Вывести в первом столбце фамилии, имена, отчества
тренеров, во втором – название биологического возраста по классификации Всемирной организации здравоохранения (от 25 до
44 лет – молодой возраст, 44–60 лет – средний возраст, 60–
75 лет – пожилой возраст, 75–90 лет – старческий возраст, после
90 – долгожители.).
22. Для каждого состава (выбрать id, дату принятия, схему)
вывести в разных столбцах количество игроков до 23 лет, количество игроков от 24 до 28 лет и количество игроков старше 28, а
также вывести средний возраст игроков.
23. Выбрать фамилии и национальность игроков, имеющих
более трех контрактов и тренирующихся у Иванова Ивана Ивановича.
24. Выбрать id и фамилии, имена, отчества игроков, у которых срок завершения контракта истекает в течение ближайшего
месяца.
25. Для каждого года заключения контрактов вывести количество контрактов, заключенных с российскими игроками. В результат должны войти только года, в которые заключено более 2
контрактов.
26. Выбрать название спонсоров, которые заключают договора как минимум на три года.
27. Выбрать все данные о самом старшем тренере.
28. Выбрать id и фамилию, имя, отчество спонсора, который
оплачивает только одного русского игрока.
29. Выбрать данные состава, который имеет наибольшее количество забитых голов.
30. Выбрать фамилию и инициалы тренеров, которые в составе, имеющем более 5 тренеров.
31. Выбрать название спонсора, который заключил договоры
с наибольшим количеством игроков из Германии.
32. Выбрать спонсора, у которого наибольшее количество
договоров с одним и тем же игроком.
33. Выбрать фамилии и инициалы руководителей, в чьем составе есть игроки, дата завершения контракта с которыми истекает в текущем месяце.
34. Выбрать тройку игроков, с которыми заключены последние контракты.
35. Выбрать названия спонсоров, которые не заключали контракты последние полгода.
36. Выбрать данные обо всех игроках и для тех, у кого истекает контракт в этом году, в отдельном столбце указать сообщение «продлить контракт».
37. Выбрать для каждого игрока прибыль по контракту актуальному на 12 апреля 2019 года.
38. Выбрать однофамильцев-тезок среди тренеров и игроков.
39. Выбрать всех однофамильцев по всей базе данных.
40. Выбрать общее количество однофамильцев по всей БД.
41. Выбрать id и фамилии, имена, отчества тренеров, которые тренировали 2 и более состава, у которых не было пропущенных шайб.
42. Выбрать в одном столбце названия спонсоров и фамилии
и инициалы руководителей. Результат отсортировать в лексикографическом порядке.
43. Вывести сообщение «Есть игроки с просроченным контрактом», если есть игроки, у которых действие контракта закончилось и новый контракт не заключен.
44. Для каждого спонсора выбрать всех руководителей и,
если были контракты с игроками, то количество игроков.
45. Выбрать фамилию, имя, отчество игрока, который заключал контракты со всеми спонсорами, имеющимися в БД.
46. Выбрать название спонсора, который последние три года
не заключал новых контрактов с игроками и имеет наибольший
ежегодный платеж среди всех спонсоров, не заключавших контракты последние три года.
47. Выбрать фамилии, имена, отчества игроков, играющих в
наиболее успешном составе.
48. Выбрать название национальности, игроки которой играют в составе, включающем игроков только одной национальности.
49. Выбрать фамилии, имена, отчества, дату рождения и телефон тренеров, которые тренируют межнациональные команды
на данный момент (учтите даты контрактов).
50. Выбрать самого дорогого игрока, играющего в составе,
тренируемом Ивановым Иваном Ивановичем
51. Выбрать фамилии, имена, отчества игроков, которые в
своей карьере имели перерывы более года (учитывать даты контрактов).
