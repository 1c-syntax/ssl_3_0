﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СмешаннаяВажность = НСтр("ru = 'Различная'");
	
	// Контроль количества вариантов осуществляется до открытия формы.
	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.Варианты);
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	ЗаполнитьРазделы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СообщенияОбОшибках <> Неопределено Тогда
		Отказ = Истина;
		ОчиститьСообщения();
		СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Неопределено, 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1
				|Подробности:
				|%2'"), СообщенияОбОшибках.Текст, СообщенияОбОшибках.Подробно), РежимДиалогаВопрос.ОК);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Разместить(Команда)
	ЗаписатьНаСервере();
	ТекстОповещения = НСтр("ru = 'Изменены настройки вариантов отчетов (%1 шт.).'");
	ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, Формат(ИзменяемыеВарианты.Количество(), "ЧН=0; ЧГ=0"));
	ПоказатьОповещениеПользователя(, , ТекстОповещения);
	ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	СнятьФлажкиРазделов();
	Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоПодсистемВажность.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПодсистем.Важность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("СмешаннаяВажность");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗаблокированныйРеквизитЦвет);
	
	ВариантыОтчетов.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура СнятьФлажкиРазделов()
	
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
	Для Каждого СтрокаДерева Из Найденные Цикл
		СтрокаДерева.Использование = 0;
		СтрокаДерева.Модифицированность = Истина;
	КонецЦикла;
	
	Найденные = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 2), Истина);
	Для Каждого СтрокаДерева Из Найденные Цикл
		СтрокаДерева.Использование = 0;
		СтрокаДерева.Модифицированность = Истина;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры
	
&НаСервере
Процедура ЗаполнитьРазделы()
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка,
	|	ВариантыОтчетов.ПредопределенныйВариант,
	|	ВЫБОР
	|		КОГДА ВариантыОтчетов.ПометкаУдаления
	|			ТОГДА 1
	|		КОГДА &ПолныеПраваНаВарианты = ЛОЖЬ
	|				И ВариантыОтчетов.Автор <> &ТекущийПользователь
	|			ТОГДА 2
	|		КОГДА НЕ ВариантыОтчетов.Отчет В (&ОтчетыПользователя)
	|			ТОГДА 3
	|		КОГДА ВариантыОтчетов.Ссылка В (&ОтключенныеВариантыПрограммы)
	|			ТОГДА 4
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Причина
	|ПОМЕСТИТЬ втВарианты
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Ссылка В(&МассивВариантов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втВарианты.Ссылка КАК Ссылка,
	|	РазмещениеКонфигурации.Подсистема КАК Подсистема,
	|	РазмещениеКонфигурации.Важный КАК Важный,
	|	РазмещениеКонфигурации.СмТакже КАК СмТакже
	|ПОМЕСТИТЬ втОбщие
	|ИЗ
	|	втВарианты КАК втВарианты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Размещение КАК РазмещениеКонфигурации
	|		ПО (втВарианты.Причина = 0)
	|			И втВарианты.ПредопределенныйВариант = РазмещениеКонфигурации.Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втВарианты.Ссылка,
	|	РазмещениеРасширений.Подсистема,
	|	РазмещениеРасширений.Важный,
	|	РазмещениеРасширений.СмТакже
	|ИЗ
	|	втВарианты КАК втВарианты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений.Размещение КАК РазмещениеРасширений
	|		ПО (втВарианты.Причина = 0)
	|			И втВарианты.ПредопределенныйВариант = РазмещениеРасширений.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВариантыОтчетовРазмещение.Ссылка КАК Ссылка,
	|	ВариантыОтчетовРазмещение.Использование КАК Использование,
	|	ВариантыОтчетовРазмещение.Подсистема КАК Подсистема,
	|	ВариантыОтчетовРазмещение.Важный КАК Важный,
	|	ВариантыОтчетовРазмещение.СмТакже КАК СмТакже
	|ПОМЕСТИТЬ втРазделенные
	|ИЗ
	|	втВарианты КАК втВарианты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Размещение КАК ВариантыОтчетовРазмещение
	|		ПО (втВарианты.Причина = 0)
	|			И втВарианты.Ссылка = ВариантыОтчетовРазмещение.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втВарианты.Ссылка,
	|	втВарианты.Причина КАК Причина
	|ИЗ
	|	втВарианты КАК втВарианты
	|ГДЕ
	|	втВарианты.Причина <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Причина
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(НастройкиРазделенных.Подсистема, НастройкиОбщих.Подсистема) КАК Ссылка,
	|	СУММА(1) КАК Количество,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.Важный, НастройкиОбщих.Важный) = ИСТИНА
	|			ТОГДА &ПредставлениеВажный
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.СмТакже, НастройкиОбщих.СмТакже) = ИСТИНА
	|			ТОГДА &ПредставлениеСмТакже
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК Важность
	|ИЗ
	|	втОбщие КАК НастройкиОбщих
	|		ПОЛНОЕ СОЕДИНЕНИЕ втРазделенные КАК НастройкиРазделенных
	|		ПО НастройкиОбщих.Ссылка = НастройкиРазделенных.Ссылка
	|			И НастройкиОбщих.Подсистема = НастройкиРазделенных.Подсистема
	|ГДЕ
	|	(НастройкиРазделенных.Использование = ИСТИНА
	|			ИЛИ НастройкиРазделенных.Использование ЕСТЬ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ЕСТЬNULL(НастройкиРазделенных.Подсистема, НастройкиОбщих.Подсистема),
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.Важный, НастройкиОбщих.Важный) = ИСТИНА
	|			ТОГДА &ПредставлениеВажный
	|		КОГДА ЕСТЬNULL(НастройкиРазделенных.СмТакже, НастройкиОбщих.СмТакже) = ИСТИНА
	|			ТОГДА &ПредставлениеСмТакже
	|		ИНАЧЕ """"
	|	КОНЕЦ";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПолныеПраваНаВарианты",        ВариантыОтчетов.ПолныеПраваНаВарианты());
	Запрос.УстановитьПараметр("ТекущийПользователь",          Пользователи.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("МассивВариантов",              ИзменяемыеВарианты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ОтчетыПользователя",           ВариантыОтчетов.ОтчетыТекущегоПользователя());
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	Запрос.УстановитьПараметр("ПредставлениеВажный",          ВариантыОтчетов.ПредставлениеВажный());
	Запрос.УстановитьПараметр("ПредставлениеСмТакже",         ВариантыОтчетов.ПредставлениеСмТакже());
	
	Запрос.Текст = ТекстЗапроса;
	ВременныеТаблицы = Запрос.ВыполнитьПакет();
	
	ОтфильтрованныеВарианты = ВременныеТаблицы[3].Выгрузить();
	КоличествоОшибок = ОтфильтрованныеВарианты.Количество();
	
	Если КоличествоОшибок > 0 Тогда
		СообщенияОбОшибках = Новый Структура("Текст, Подробно");
		ТекущаяПричина = 0;
		СообщенияОбОшибках.Подробно = "";
		Для Каждого СтрокаТаблицы Из ОтфильтрованныеВарианты Цикл
			Если ТекущаяПричина <> СтрокаТаблицы.Причина Тогда
				ТекущаяПричина = СтрокаТаблицы.Причина;
				СообщенияОбОшибках.Подробно = СообщенияОбОшибках.Подробно + Символы.ПС + Символы.ПС;
				Если ТекущаяПричина = 1 Тогда
					СообщенияОбОшибках.Подробно = СообщенияОбОшибках.Подробно + НСтр("ru = 'Помеченные на удаление:'");
				ИначеЕсли ТекущаяПричина = 2 Тогда
					СообщенияОбОшибках.Подробно = СообщенияОбОшибках.Подробно + НСтр("ru = 'Недостаточно прав для изменения:'");
				ИначеЕсли ТекущаяПричина = 3 Тогда
					СообщенияОбОшибках.Подробно = СообщенияОбОшибках.Подробно + НСтр("ru = 'Отчет отключен или недоступен по правам:'");
				ИначеЕсли ТекущаяПричина = 4 Тогда
					СообщенияОбОшибках.Подробно = СообщенияОбОшибках.Подробно + НСтр("ru = 'Вариант отчета отключен по функциональной опции:'");
				КонецЕсли;
			КонецЕсли;
			
			СообщенияОбОшибках.Подробно = СокрЛ(СообщенияОбОшибках.Подробно) + Символы.ПС + "    - " + Строка(СтрокаТаблицы.Ссылка);
			ИзменяемыеВарианты.Удалить(ИзменяемыеВарианты.НайтиПоЗначению(СтрокаТаблицы.Ссылка));
		КонецЦикла;
		
		КоличествоВариантов = ИзменяемыеВарианты.Количество();
		
		Если КоличествоВариантов = 0 Тогда
			СообщенияОбОшибках.Текст = НСтр("ru = 'Недостаточно прав для размещения в разделах выбранных вариантов отчетов.'");
		Иначе
			СообщенияОбОшибках.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Недостаточно прав для размещения в разделах некоторых вариантов отчетов (%1).'"),
				Формат(КоличествоОшибок, "ЧГ="));
		КонецЕсли;
		
		СообщенияОбОшибках = Новый ФиксированнаяСтруктура(СообщенияОбОшибках);
	КонецЕсли;
	
	ВхожденияПодсистем = ВременныеТаблицы[4].Выгрузить();
	
	ДеревоИсточник = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	ДеревоПриемник.Строки.Очистить();
	
	ДобавитьПодсистемыВДерево(ДеревоПриемник, ДеревоИсточник, ВхожденияПодсистем);
	
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Для Каждого ВариантОтчета Из ИзменяемыеВарианты Цикл
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантОтчета.Значение);
		КонецЦикла;
		Блокировка.Заблокировать();
			
		Для Каждого ВариантОтчета Из ИзменяемыеВарианты Цикл
			ВариантОбъект = ВариантОтчета.Значение.ПолучитьОбъект();
			ВариантыОтчетов.ДеревоПодсистемЗаписать(ВариантОбъект, ИзмененныеРазделы);
			ВариантОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодсистемыВДерево(ПриемникРодитель, ИсточникРодитель, ВхожденияПодсистем)
	Для Каждого Источник Из ИсточникРодитель.Строки Цикл
		
		Приемник = ПриемникРодитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Приемник, Источник);
		
		ВхожденияЭтойПодсистемы = ВхожденияПодсистем.Скопировать(Новый Структура("Ссылка", Приемник.Ссылка));
		Если ВхожденияЭтойПодсистемы.Количество() = 1 Тогда
			Приемник.Важность = ВхожденияЭтойПодсистемы[0].Важность;
		ИначеЕсли ВхожденияЭтойПодсистемы.Количество() = 0 Тогда
			Приемник.Важность = "";
		Иначе
			Приемник.Важность = СмешаннаяВажность; // Так же используется для условного оформления.
		КонецЕсли;
		
		ВхожденияВариантов = ВхожденияЭтойПодсистемы.Итог("Количество");
		Если ВхожденияВариантов = КоличествоВариантов Тогда
			Приемник.Использование = 1;
		ИначеЕсли ВхожденияВариантов = 0 Тогда
			Приемник.Использование = 0;
		Иначе
			Приемник.Использование = 2;
		КонецЕсли;
		
		// Рекурсия
		ДобавитьПодсистемыВДерево(Приемник, Источник, ВхожденияПодсистем);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти