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
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ИнициализироватьКомпоновщикСервер(Неопределено);
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораНаименования(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СохраненныйКомпоновщикНастроек = ТекущийОбъект.КомпоновщикНастроек.Получить();
	ИнициализироватьКомпоновщикСервер(СохраненныйКомпоновщикНастроек);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.КомпоновщикНастроек = Новый ХранилищеЗначения(КомпоновщикНастроек.ПолучитьНастройки());
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗакладкиВзаимодействий", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораНаименования(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ЗаполнитьСписокВыбораНаименования(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщикСервер(НастройкаКомпоновки)
	
	СхемаКомпоновки = ЖурналыДокументов.Взаимодействия.ПолучитьМакет("СхемаОтборВзаимодействия");
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновки, УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	Если НастройкаКомпоновки = Неопределено Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновки.НастройкиПоУмолчанию);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкаКомпоновки);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораНаименования(Форма)
	
	СписокВыбора = Форма.Элементы.Наименование.СписокВыбора;
	
	СписокВыбора.Очистить();
	Если Не ПустаяСтрока(Форма.Объект.Наименование) Тогда
		СписокВыбора.Добавить(Форма.Объект.Наименование);
	КонецЕсли;
	ПредставлениеОтбора = Строка(Форма.КомпоновщикНастроек.Настройки.Отбор);
	Если Форма.Объект.Наименование <> ПредставлениеОтбора Тогда
		СписокВыбора.Добавить(ПредставлениеОтбора);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
