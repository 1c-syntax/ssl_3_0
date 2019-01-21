﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Параметры формы:
//     Индекс                            - Число  - Почтовый индекс для поиска вариантов адресов.
//     СкрыватьНеактуальныеАдреса        - Булево - флаг того, что при неактуальные адреса будут скрываться.
//     ФорматАдреса - Строка - вариант классификатора.
//
// Результат выбора:
//     Структура - с полями
//         * Отказ                      - Булево - флаг того, что при обработке произошла ошибка.
//         * КраткоеПредставлениеОшибки - Строка - Описание ошибки.
//         * Идентификатор              - УникальныйИдентификатор - Данные адреса.
//         * Представление              - Строка                  - Данные адреса.
//         * Индекс                     - Число                   - Данные адреса.
//
// ---------------------------------------------------------------------------------------------------------------------
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	
	Параметры.Свойство("Индекс", Индекс);
	ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаКлассификатораПоПочтовомуИндексу(Индекс, ПараметрыПоиска);
	
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис на обслуживании
		КраткоеПредставлениеОшибки = ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Возврат;
		
	ИначеЕсли ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		// Нет данных, функционал выбора не применим.
		КраткоеПредставлениеОшибки = НСтр("ru = 'Индекс не найден в адресном классификаторе.'");
		Возврат;
	КонецЕсли;
	
	ВариантыАдреса.Загрузить(ДанныеКлассификатора.Данные);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
		Элементы.Переместить(Элементы.ВариантыАдресаГруппаКнопокПоиска, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаОбновить, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаВывестиСписок, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаСправка, Элементы.ФормаКоманднаяПанель);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВариантыАдресаВыбрать", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Найти", "ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Авто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
		ОповеститьВладельца(Неопределено, Истина);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантыАдресаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПроизвестиВыбор(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		РаботаСАдресамиКлиент.ПреобразоватьВводАдреса(Текст);
		Элементы.ВариантыАдреса.ОтборСтрок = Новый ФиксированнаяСтруктура("Представление", Текст);
		
	Иначе
		Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НайтиОчистка(Элемент, СтандартнаяОбработка)
	Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Если Элементы.ВариантыАдреса.ТекущаяСтрока <> Неопределено Тогда
		ПроизвестиВыбор(Элементы.ВариантыАдреса.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроизвестиВыбор(Знач НомерСтроки)
	
	Данные = ВариантыАдреса.НайтиПоИдентификатору(НомерСтроки);
	Если Данные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ОповеститьВладельца(Данные);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца(Знач Данные, Отказ = Ложь)
	
	Результат = Новый Структура("Муниципальный, Идентификатор, Индекс");
	Результат.Вставить("КраткоеПредставлениеОшибки", КраткоеПредставлениеОшибки);
	Результат.Вставить("Отказ",                      Отказ);
	Результат.Вставить("Индекс",                     Индекс);
	Если Данные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, Данные);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыАдресаПредставление.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыАдреса.Муниципальный");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти

