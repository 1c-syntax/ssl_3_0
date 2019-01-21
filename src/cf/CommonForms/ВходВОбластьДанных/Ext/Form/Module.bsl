﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтандартныеПодсистемыСервер.УстановитьПустуюФормуНаПустойРабочийСтол();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнтерфейс = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВойтиВОбластьДанных(Команда)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		
		ПодключитьОбработчикОжидания("ВойтиВОбластьДанныхПослеВыхода", 0.1, Истина);
		УстановитьДоступностьКнопок(Ложь);
	Иначе
		ВойтиВОбластьДанныхПослеВыхода();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыйтиИзОбластиДанных(Команда)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		// Закрытие форм разделенного рабочего стола.
		ОбновитьИнтерфейс();
		ПодключитьОбработчикОжидания("ПродолжениеВыходаИзОбластиДанныхПослеСкрытияФормРабочегоСтола", 0.1, Истина);
		УстановитьДоступностьКнопок(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнтерфейсПриНеобходимости()
	
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВойтиВОбластьДанныхПослеВыхода()
	
	УстановитьДоступностьКнопок(Истина);
	
	Если НЕ УказаннаяОбластьДанныхЗаполнена(ОбластьДанных) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВойтиВОбластьДанныхПослеВыхода2", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Выбранная область данных не используется, продолжить вход?'"),
			РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	ВойтиВОбластьДанныхПослеВыхода2();
	
КонецПроцедуры

&НаКлиенте
Процедура ВойтиВОбластьДанныхПослеВыхода2(Ответ = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		ОбновитьИнтерфейсПриНеобходимости();
		Возврат;
	КонецЕсли;
	
	ВойтиВОбластьДанныхНаСервере(ОбластьДанных);
	
	ОбновитьИнтерфейс = Истина;
	
	ОбработкаЗавершения = Новый ОписаниеОповещения(
		"ПродолжениеВходаВОбластьДанныхПослеДействийПередНачаломРаботыСистемы", ЭтотОбъект);
	
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы(ОбработкаЗавершения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВходаВОбластьДанныхПослеДействийПередНачаломРаботыСистемы(Результат, Контекст) Экспорт
	
	Если Результат.Отказ Тогда
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		ОбновитьИнтерфейсПриНеобходимости();
		Активизировать();
		УстановитьДоступностьКнопок(Ложь);
		ПодключитьОбработчикОжидания("ВключитьДоступностьКнопок", 2, Истина);
	Иначе
		ОбработкаЗавершения = Новый ОписаниеОповещения(
			"ПродолжениеВходаВОбластьДанныхПослеДействийПриНачалеРаботыСистемы", ЭтотОбъект);
		
		СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы(ОбработкаЗавершения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВходаВОбластьДанныхПослеДействийПриНачалеРаботыСистемы(Результат, Контекст) Экспорт
	
	Если Результат.Отказ Тогда
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
	КонецЕсли;
	
	ОбновитьИнтерфейсПриНеобходимости();
	Активизировать();
	
	УстановитьДоступностьКнопок(Ложь);
	ПодключитьОбработчикОжидания("ВключитьДоступностьКнопок", 2, Истина);
	Оповестить("ВыполненВходВОбластьДанных");
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыходаИзОбластиДанныхПослеСкрытияФормРабочегоСтола()
	
	УстановитьДоступностьКнопок(Истина);
	
	ВыйтиИзОбластиДанныхНаСервере();
	
	// Отображение форм неразделенного рабочего стола.
	ОбновитьИнтерфейс();
	
	СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
	
	Активизировать();
	
	УстановитьДоступностьКнопок(Ложь);
	ПодключитьОбработчикОжидания("ВключитьДоступностьКнопок", 2, Истина);
	Оповестить("ВыполненВыходИзОбластиДанных");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция УказаннаяОбластьДанныхЗаполнена(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
	ЭлементБлокировки.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбластиДанных.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|ГДЕ
	|	ОбластиДанных.ОбластьДанныхВспомогательныеДанные = &ОбластьДанных";
	Запрос.УстановитьПараметр("ОбластьДанных", ОбластьДанных);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Статус = Перечисления.СтатусыОбластейДанных.Используется
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВойтиВОбластьДанныхНаСервере(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
	НачатьТранзакцию();
	
	Попытка
		
		КлючОбласти = РаботаВМоделиСервиса.СоздатьКлючЗаписиРегистраСведенийВспомогательныхДанных(
			РегистрыСведений.ОбластиДанных,
			Новый Структура(РаботаВМоделиСервиса.РазделительВспомогательныхДанных(), ОбластьДанных));
		ЗаблокироватьДанныеДляРедактирования(КлючОбласти);
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Элемент.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
		Элемент.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
			МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(КлючОбласти);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВыйтиИзОбластиДанныхНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Восстановление форм разделенного рабочего стола.
	СтандартныеПодсистемыВызовСервера.СкрытьРабочийСтолПриНачалеРаботыСистемы(Ложь);
	
	СтандартныеПодсистемыСервер.УстановитьПустуюФормуНаПустойРабочийСтол();
	
	РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОсуществленВходВОбластьДанных()
	
	УстановитьПривилегированныйРежим(Истина);
	ОсуществленВход = РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса();
	
	// Подготовка к закрытию форм разделенного рабочего стола.
	Если ОсуществленВход Тогда
		СтандартныеПодсистемыВызовСервера.СкрытьРабочийСтолПриНачалеРаботыСистемы(Истина);
	КонецЕсли;
	
	Возврат ОсуществленВход;
	
КонецФункции

&НаКлиенте
Процедура ВключитьДоступностьКнопок()
	
	УстановитьДоступностьКнопок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопок(Доступность)
	
	Элементы.ЗначениеРазделителя.Доступность = Доступность;
	Элементы.ГруппаВходВОбласть.Доступность = Доступность;
	
КонецПроцедуры

#КонецОбласти
