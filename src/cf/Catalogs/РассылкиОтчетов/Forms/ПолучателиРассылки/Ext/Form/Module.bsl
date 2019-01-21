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
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ТипПолучателейРассылки, ВидПочтовогоАдресаПолучателей");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Получатели рассылки (%1)'"),
		Параметры.НаименованиеРассылки);
	
	Для Каждого СтрокаТаблицы Из Параметры.Получатели Цикл
		НоваяСтрока = Получатели.Добавить();
		НоваяСтрока.Получатель = СтрокаТаблицы.Получатель;
		НоваяСтрока.Исключен = СтрокаТаблицы.Исключен;
	КонецЦикла;
	
	Элементы.ПолучателиПолучатель.ОграничениеТипа = ТипПолучателейРассылки;
	
	ЗаполнитьСведенияОТипеПолучателей(Отказ);
	ЗаполнитьПочтовыеАдреса();
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла") Тогда
		Элементы.ВставитьИзБуфераОбмена.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПочтовогоАдресаПолучателейПриИзменении(Элемент)
	ЗаполнитьПочтовыеАдреса();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПолучатели

&НаКлиенте
Процедура ПолучателиПодобрать(Команда)
	ОткрытьФормаДобавленияПолучателей(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормаДобавленияПолучателей(ЭтоПодбор)
	ВыбранныеПользователи = Новый Массив;
	Для Каждого Строка Из Получатели Цикл
		ВыбранныеПользователи.Добавить(Строка.Получатель);
	КонецЦикла;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	// Стандартные реквизиты формы выбора (см. Расширение управляемой формы для динамического списка).
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", ?(ЭтоПодбор, Ложь, Истина));
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", ЭтоПодбор);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	// Предполагаемые реквизиты
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	// Параметры открытия расширенной формы подбора
	// (описание реквизитов см. в форме списка справочника Пользователи).
	Если ЭтоПодбор Тогда
		ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
		ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор получателей рассылки'"));
		ПараметрыФормыВыбора.Вставить("ВыбранныеПользователи", ВыбранныеПользователи);
	КонецЕсли;
	
	ОткрытьФорму(ПутьФормыВыбора, ПараметрыФормыВыбора, Элементы.Получатели);
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДобавитьПеретащитьПолучателя(ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	ОткрытьФормаДобавленияПолучателей(Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Результат = Новый Структура;
	Результат.Вставить("Получатели", Получатели);
	Результат.Вставить("ВидПочтовогоАдресаПолучателей", ВидПочтовогоАдресаПолучателей);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьИзБуфераОбмена(Команда)
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ОписаниеТипов", ТипПолучателейРассылки);
	ПараметрыПоиска.Вставить("ПараметрыВыбора", Неопределено);
	ПараметрыПоиска.Вставить("ПредставлениеПоля", "Получатели");
	ПараметрыПоиска.Вставить("Сценарий", "ПоискСсылок");
	
	ПараметрыВыполнения = Новый Структура;
	Обработчик = Новый ОписаниеОповещения("ВставитьИзБуфераОбменаЗавершение", ЭтотОбъект, ПараметрыВыполнения);
	
	МодульЗагрузкаДанныхИзФайлаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗагрузкаДанныхИзФайлаКлиент");
	МодульЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗаполненияСсылок(ПараметрыПоиска, Обработчик);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	
	Для каждого Получатель Из Получатели Цикл
		Получатель.Исключен = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	
	Для каждого Получатель Из Получатели Цикл
		Получатель.Исключен = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ДобавитьПеретащитьПолучателя(ПолучательИлиНаборПолучателей)
	// Удаление пользователей, которые были удалены в форме подбора или которые уже есть в списке.
	Если ЭтоПодборПользователейИлиГрупп(ПолучательИлиНаборПолучателей) Тогда
		Количество = Получатели.Количество();
		Для Номер = 1 По Количество Цикл
			ОбратныйИндекс = Количество - Номер;
			СтрокаПолучатель = Получатели.Получить(ОбратныйИндекс);
			
			ИндексВМассиве = ПолучательИлиНаборПолучателей.Найти(СтрокаПолучатель.Получатель);
			Если ИндексВМассиве = Неопределено Тогда
				Получатели.Удалить(СтрокаПолучатель); // Пользователь удален в форме подбора.
			Иначе
				ПолучательИлиНаборПолучателей.Удалить(ИндексВМассиве); // Пользователь уже есть в списке.
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Добавление выбранных строк.
	МассивНовыхСтрок = ВыборПодборПеретаскиваниеВТабличнуюЧасть(ПолучательИлиНаборПолучателей);
	
	// Подготовка текста оповещения.
	Если МассивНовыхСтрок.Количество() > 0 Тогда
		Если МассивНовыхСтрок.Количество() = 1 Тогда
			ЗаголовокОповещения = НСтр("ru = 'Получатель добавлен в рассылку'");
		Иначе
			ЗаголовокОповещения = НСтр("ru = 'Получатели добавлены в рассылку'");
		КонецЕсли;
		
		ТекстОповещения = "";
		Для Каждого СтрокаПолучатель Из МассивНовыхСтрок Цикл
			ТекстОповещения = ТекстОповещения + ?(ТекстОповещения = "", "", ", ") + СтрокаПолучатель;
		КонецЦикла;
		ПоказатьОповещениеПользователя(ЗаголовокОповещения,, ТекстОповещения, БиблиотекаКартинок.ВыполнитьЗадачу);
		
		ЗаполнитьПочтовыеАдреса();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ЭтоПодборПользователейИлиГрупп(ПолучательИлиНаборПолучателей)
	Возврат ТипЗнч(ПолучательИлиНаборПолучателей) = Тип("Массив")
		И ТипПолучателейРассылки.СодержитТип(Тип("СправочникСсылка.Пользователи"));
КонецФункции

&НаКлиенте
Функция ВыборПодборПеретаскиваниеВТабличнуюЧасть(ВыбранноеЗначение)
	МассивНовыхСтрок = Новый Массив;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		Для Каждого ЭлементПодбора Из ВыбранноеЗначение Цикл
			Результат = ВыборПодборПеретаскиваниеЭлементаВТабличнуюЧасть(ЭлементПодбора);
			ДобавитьЗначениеВМассивОповещений(Результат, МассивНовыхСтрок);
		КонецЦикла;
	Иначе
		Результат = ВыборПодборПеретаскиваниеЭлементаВТабличнуюЧасть(ВыбранноеЗначение);
		ДобавитьЗначениеВМассивОповещений(Результат, МассивНовыхСтрок);
	КонецЕсли;
	Возврат МассивНовыхСтрок;
КонецФункции

&НаКлиенте
Процедура ДобавитьЗначениеВМассивОповещений(Текст, МассивНовыхСтрок)
	Если ЗначениеЗаполнено(Текст) Тогда
		МассивНовыхСтрок.Добавить(Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ВыборПодборПеретаскиваниеЭлементаВТабличнуюЧасть(ЗначениеРеквизита)
	Отбор = Новый Структура("Получатель", ЗначениеРеквизита);
	НайденныеСтроки = Получатели.НайтиСтроки(Отбор);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Строка = Получатели.Добавить();
	Строка.Получатель = ЗначениеРеквизита;
	
	Возврат ЗначениеРеквизита;
КонецФункции

&НаКлиенте
Процедура ВставитьИзБуфераОбменаЗавершение(Результат, Параметр) Экспорт

	Если Результат <> Неопределено Тогда 
		Для каждого Получатель Из Результат Цикл 
			НоваяСтрока = Получатели.Добавить();
			НоваяСтрока.Получатель = Получатель;
		КонецЦикла;
		
		ЗаполнитьПочтовыеАдреса();
	КонецЕсли;
	

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Процедура ЗаполнитьПочтовыеАдреса()
	НаборПараметров = "Ссылка, ВидПочтовогоАдресаПолучателей, Личная, Получатели, ТипПолучателейРассылки";
	
	ПараметрыПолучателей = Новый Структура(НаборПараметров);
	ЗаполнитьЗначенияСвойств(ПараметрыПолучателей, ЭтотОбъект);
	ПараметрыПолучателей.Личная = Ложь;
	ПараметрыПолучателей.ТипПолучателейРассылки = ИдентификаторОбъектаМетаданных;
	ПараметрыПолучателей.Получатели = Получатели;
	
	РезультатВыполнения = РассылкаОтчетовВызовСервера.СформироватьСписокПолучателейРассылки(ПараметрыПолучателей);
	Если Не РезультатВыполнения.БылиКритичныеОшибки Тогда
		Для каждого Строка Из Получатели Цикл
			ПочтаПолучателя = РезультатВыполнения.Получатели.Получить(Строка.Получатель);
			Если ПочтаПолучателя <> Неопределено Тогда 
				Строка.Адрес = ПочтаПолучателя;
			Иначе
				Строка.Адрес = "";
			КонецЕсли;
			Если Строка.Получатель.ЭтоГруппа ИЛИ ТипЗнч(Строка.Получатель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
				Строка.ИндексКартинки = 3;
			Иначе
				Строка.ИндексКартинки = 1;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Для каждого Строка Из Получатели Цикл
			Если Строка.Получатель <> Неопределено Тогда 
				Если Строка.Получатель.ЭтоГруппа ИЛИ ТипЗнч(Строка.Получатель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
					Строка.ИндексКартинки = 3;
				Иначе
					Строка.ИндексКартинки = 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПолучателиПолучатель.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПолучателиИсключен.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Получатели.Исключен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОТипеПолучателей(Отказ)
	ТаблицаТиповПолучателей = РассылкаОтчетовПовтИсп.ТаблицаТиповПолучателей();
	Найденные = ТаблицаТиповПолучателей.НайтиСтроки(Новый Структура("ТипПолучателей", ТипПолучателейРассылки));
	Если Найденные.Количество() = 1 Тогда
		СтрокаПолучатель = Найденные[0];
		ИдентификаторОбъектаМетаданных            = СтрокаПолучатель.ИдентификаторОбъектаМетаданных;
		ПутьФормыВыбора                           = СтрокаПолучатель.ПутьФормыВыбора;
		ГруппаКонтактнойИнформацииТипаПолучателей = СтрокаПолучатель.ГруппаКИ;
		// ГруппаКИ используется для поля "ВидПочтовогоАдресаПолучателей" в "СвязиПараметровВыбора.Отбор".
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти