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

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.ВнешниеКомпоненты) Тогда
		
		Элементы.ФормаОбновитьИзФайла.Видимость = Ложь;
		Элементы.ФормаСохранитьКак.Видимость = Ложь;
		Элементы.ОбновитьСПортала1СИТС.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюОбновитьИзФайла.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСохранитьКак.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ВнешниеКомпонентыСлужебный.ДоступнаЗагрузкаСПортала() Тогда 
		
		Элементы.ОбновлятьСПортала1СИТС.Видимость = Ложь;
		Элементы.ОбновитьСПортала1СИТС.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользованиеОтборПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда 
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСПортала(Команда)
	
	МассивСсылок = Элементы.Список.ВыделенныеСтроки;
	
	Если МассивСсылок.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПослеОбновленияКомпонентыСПортала", ЭтотОбъект);
	
	ВнешниеКомпонентыСлужебныйКлиент.ОбновитьКомпонентыСПортала(Оповещение, МассивСсылок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайла(Команда)
	
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ДанныеСтроки.Ссылка);
	ПараметрыФормы.Вставить("ПоказатьДиалогЗагрузкиИзФайлаПриОткрытии", Истина);
	
	ОткрытьФорму("Справочник.ВнешниеКомпоненты.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ДанныеСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВнешниеКомпонентыСлужебныйКлиент.СохранитьКомпонентуВФайл(ДанныеСтроки.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеОбновленияКомпонентыСПортала(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

/////////////////////////////////////////////////////////
// Представление данных на форме.

&НаСервере
Процедура УстановитьОтбор()
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ИспользованиеОтбор", ИспользованиеОтбор);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	Если ПараметрыОтбора["ИспользованиеОтбор"] = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Использование",,,, Ложь);
	ИначеЕсли ПараметрыОтбора["ИспользованиеОтбор"] = 1 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Использование", Перечисления.ВариантыИспользованияВнешнихКомпонент.Используется,,, Истина);
	ИначеЕсли ПараметрыОтбора["ИспользованиеОтбор"] = 2 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Использование", Перечисления.ВариантыИспользованияВнешнихКомпонент.Отключена,,, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Использование");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ВариантыИспользованияВнешнихКомпонент.Отключена;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра(
		"TextColor", Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение);
	
КонецПроцедуры

#КонецОбласти