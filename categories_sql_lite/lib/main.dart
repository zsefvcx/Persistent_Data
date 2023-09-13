import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'categories_app.dart';
import 'core/core.dart';



/// Временно сделаем main async
Future<void> main() async {
  if(Platform.isWindows) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  ///Fake data in memory
  final Set<Group> groups = {
      const Group(gid: 1, group:   'Movies', description: 'Фильмы'),
      const Group(gid: 2, group:   'Series', description:  'Сериалы'),
      const Group(gid: 3, group:    'Games', description:   'Игры'),
      const Group(gid: 4, group: 'TV Shows', description: 'ТВ Шоу'),
    };
  for(var elem in groups) {
    await Categories.instance().group.addEx(value: elem);
  }
  Logger.print('${Categories.instance().group}', name: 'log', level: 0, error: false);
  final Set<Category> category = {
    const Category(id: 1, gid: 1, category: 'Финник (2022)', image: 'https://ithinker.ru/static/images/film/18/318578.jpg', description: 'Мало кто знает, но в каждом доме живет… свой домовой! Это забавное мохнатое существо тайно обитает в мире людей и хранит домашний очаг. Домовой Финник — добрый, озорной, но немного вредный. Он любит подшутить над жильцами своего дома, поэтому ни одна семья не задерживается в его владениях надолго. Но все меняется, когда в дом въезжают находчивая девочка Кристина и ее родители: на них уловки домового совсем не действуют! Вскоре Кристина знакомится с Финником и узнает тайны жизни домовых. Тем временем, в их городке начинают происходить странные и пугающие события… Отважной девочке и домовому придется стать командой, чтобы разобраться в происходящем и спасти город.'),
    const Category(id: 2, gid: 1, category: 'Молодой человек (2022)', image: 'https://ithinker.ru/static/images/film/no-avatar-big.jpg', description: 'Ваня Ревзин к своим 30 годам, несмотря на золотую медаль в школе и красный диплом МГУ, оказался на дне: жена ушла к КМС по боксу, с убогой работы в банке уволили, а до закрытия ипотеки за маленькую студию в человейнике — годы боли и страданий. В момент отчаяния Иван узнает, что его ушлый одноклассник-двоечник Коля стал преуспевающим бизнесменом и объявил конкурс для старшеклассников с многомиллионным призовым фондом. Ваня, который выглядит сильно моложе своих лет, и которому даже алкоголь продают только по паспорту, решается на аферу. Он сбривает бороду, подделывает документы и едет на соревнование с уверенностью, что жизненный опыт легко одолеет молодость.'),
    const Category(id: 3, gid: 1, category: 'Непослушник (2022)', image: 'https://ithinker.ru/static/images/film/9/318538.jpg', description: 'Известный блогер-пранкер Дима в погоне за популярностью в сети устраивает жесткие розыгрыши. Один из пранков он снимает в стенах церкви, где служит его друг детства. Ролик провоцирует возмущение в среде верующих и на Диму заводят дело. Уходя от преследования полиции, Дима укрывается в месте, где его точно не будут искать — в маленьком провинциальном монастыре, выдавая себя за того самого друга-послушника.'),
    const Category(id: 4, gid: 1, category: 'Я краснею (2022)', image: 'https://ithinker.ru/static/images/film/14/318508.jpg', description: 'Торонто, 2002 год. Активная и неунывающая 13-летняя Мэйлинь всеми силами пытается быть первой во всём, чтобы угодить строгой гиперопекающей матери. Семья девочки живёт при храме и поклоняется Богине-прародительнице. Одним прекрасным утром Мэйлинь просыпается и вместо привычного отражения в зеркале видит красную панду — теперь, когда она волнуется, злится или испытывает другие сильные эмоции, превращается большого зверя. Мало того, что это происходит в самые неподходящие моменты, так ещё и посещение концерта обожаемой Мэйлинь и её подружками мальчиковой группы 4-Town оказывается под угрозой.'),
    const Category(id: 5, gid: 2, category: 'Засланец из космоса (2021)', image: 'https://ithinker.ru/static/images/film/1/66558.jpg', description: 'Доктор Гарри Вендершпигль — отшельник в небольшом городке в Колорадо. Ещё он — пришелец, который на самом деле упал на Землю и занял тело врача. Когда же доктора убивают, пришелец вынужден отложить миссию по возвращению домой и занять место убитого. Живя в новом теле, он постепенно начинает задаваться вопросами, стоят люди спасения или нет.'),
    const Category(id: 6, gid: 2, category: 'Аркейн (2021)', image: 'https://ithinker.ru/static/images/film/10/318042.jpg', description: 'История разворачивается в утопическом краю Пилтовере и жестоком подземном мире Зауне и рассказывает о становлении двух легендарных чемпионов Лиги и о той силе, что разведёт их по разные стороны баррикад.'),
    const Category(id: 7, gid: 2, category: 'Неуязвимый (2021)', image: 'https://ithinker.ru/static/images/film/4/81689.jpg', description: '17-летний Марк Грэйсон узнаёт, что его отец является самым могучим супергероем на Земле. Теперь подростку предстоит совладать с силами, которые достались ему по наследству.'),
    const Category(id: 8, gid: 2, category: 'Книга Бобы Фетта (2021)', image: 'https://ithinker.ru/static/images/film/13/318385.jpg', description: 'Боба Фетт вместе с напарницей Феннек Шанд пытается завоевать авторитет в преступном мире, захватив территорию, когда-то принадлежавшую Джаббе Хатту.'),
    const Category(id: 9, gid: 3, category: 'Mass Effect 2', image: 'https://cdn.kanobu.ru/games/46/d0413559fc034463b46e48b628951779', description: 'Mass Effect 2 - мультиплатформенный сиквел, вторая часть космической ролевой оперы. События игры продолжают сюжет оригинала - капитану Шепарду удается отбить атаку чудовищного корабля-"жнеца" на Цитадель, однако на этом его приключения не заканчиваются. Спустя некоторое время после атаки людские колонии в дальнем секторе космоса начинают исчезать одна за другой, и Шепарду вместе с командой предстоит отправиться на самоубийственное задание, цель которой - отыскать причину исчезновения колонистов.'),
    const Category(id: 10, gid: 3, category: 'Max Payne 3', image: 'https://cdn.kanobu.ru/games/8efa292a-2cbd-498c-9dba-445815244fc3.webp', description: 'Max Payne 3 - это шутер с видом от третьего лица, и третья часть сериала Max Payne. Главным героем игры по прежнему будет детектив из Нью-Йорка по имени Макс Пейн, который оказывается в Сан-Пауло, Бразилия, причем он радикально изменился внешне. Теперь Макс щеголяет лысиной и бородой, он потерял всякий вкус к жизни и пристрастился к обезболивающим препаратам. Разработкой игры занималась не финская студия Remedy, создавшая две первых части, а Rockstar Games, которая отступила от своих канонов и создала линейный шутер без открытого мира.'),
    const Category(id: 11, gid: 3, category: 'Half-Life 2: Episode Two', image: 'https://cdn.kanobu.ru/games/42/1f86d367816046f8866daa461d94d53b', description: 'Half-Life 2: Episode Two - это второй эпизод второй части Half-Life, которая вновь повествует о приключениях физика-ядерщика Гордона Фримена, который в конце предыдущего эпизода успел сбежать из обреченного города Сити-17, и теперь направляется на базу повстанцев под названием Белая Роща. Добраться до Рощи на поезде у Гордона и Аликс Вэнс не получается - ударная волна, уничтожившая город, добралась и до их поезда, вынудив их проделать оставшуюся часть пути пешком.'),
    const Category(id: 12, gid: 3, category: 'XCOM: Enemy Unknown', image: 'https://cdn.kanobu.ru/games/10/be6a98ff98094a88996ac733e6bd3047', description: 'XCOM: Enemy Unknown - это ремейк знаменитой тактической стратегии. Игроку вновь предстоит защищать родной мир от нашествия инопланетян, возглавив агентство XCOM, которое занимается уничтожением пришельцев и исследованием их технологии. На протяжении всей сюжетной линии игрокам стараться не допустить выхода стран из Совета Наций, получать как можно больше денег и стараться проводить исследования, которые сделают организацию сильнее.'),
    const Category(id: 13, gid: 4, category: 'КВН – Клуб Веселых и Находчивых', image: 'https://serialochka.ru/images/kvn-klub-veselyh-i-nahodchivyh_serialochka.jpg', description: 'Клуб весёлых и находчивых возродился на отечественном телевидении в 1986-м году. С того времени существует и Высшая лига, являющаяся главным дивизионом этой популярной телеигры. Ведёт игры Высшей лиги сам основатель телепроекта, Александр Васильевич Масляков. В жюри участвуют медийные персоны: актёры, режиссеры, музыканты, спортсмены.'),
    const Category(id: 14, gid: 4, category: 'Своя игра', image: 'https://serialochka.ru/images/svoya-igra_serialochka_627.jpg', description: 'Непростая интеллектуальная игра, что заставит изрядно поднапрячься своих участников. От самого начала и до самого конца ведущий будет задавать вопросы разной степени сложности, на которые предстоит отвечать трем счастливчикам, пробившимся на эфир. Каждому из них на первых порах придется выбирать тематику, в сфере которой они желают блеснуть своими знаниями. Каждый правильный ответ приносит игрокам баллы, что приравниваются к определенной сумме денег. Далее участников ждут более сложные уровни, которые потребуют от них не только ума, но и скорости реакции. Ведущий будет задавать вопросы и придется, используя большие кнопки, буквально вырывать их из зубов противника. Кто первый нажмет – тот и отвечает, но если кнопка была нажата раньше положенного времени, то она блокируется на несколько секунд, лишая игрока возможности ответить, в наказание за свою собственную хитрость и поспешность. В программе всегда бушует накал страстей и эмоций, что не оставит вас равнодушными к тому, что происходит на экране.'),
    const Category(id: 15, gid: 4, category: 'Что? Где? Когда?', image: 'https://serialochka.ru/images/chto-gde-kogda_serialochka.jpg', description: 'Большинство отечественных регулярных телепередач в основе своей имеют западные источники. По пальцам одной руки можно перечислить те, которые являются истинно оригинальными. И среди этих шедевров — плод мысли Владимира Ворошилова и Наталии Стеценко, «Что? Где? Когда?». Это интеллектуальная игра, в которой шестёрка профессиональных «знатоков» состязается в уме и образованности с телезрителями.'),
    const Category(id: 16, gid: 4, category: 'Кто хочет стать миллионером', image: 'https://serialochka.ru/images/kto-hochet-stat-millionerom_serialochka_736.jpg', description: '«Кто хочет стать миллионером» - это невероятно интересная игра, которая позволяет каждому участнику выиграть три миллиона рублей. Необходимо только дать правильный ответ на 15 вопросов. Они идут сначала достаточно простые, затем начинают постепенно усложняться. Каждый из представленных вопросов, которые задает ведущий игры, имеет четыре разных ответа. Игрок должен определиться с правильным ответом и назвать только его. Только один ответ может или, наоборот, не может засчитать ведущий игры «Кто хочет стать миллионером».'),
  };
  for(var elem in category) {
    await Categories.instance().categories.addEx(value: elem);
  }
  Logger.print('${Categories.instance().categories}', name: 'log', level: 0, error: false);
  ///Чистим загруженные данные....
  Categories.instance().group.clear();
  Logger.print('${Categories.instance().group}', name: 'log', level: 0, error: false);
  Categories.instance().categories.clear();
  Logger.print('${Categories.instance().categories}', name: 'log', level: 0, error: false);

  ///Запускаем наше приложение
  runApp(const CategoriesApp());
}

