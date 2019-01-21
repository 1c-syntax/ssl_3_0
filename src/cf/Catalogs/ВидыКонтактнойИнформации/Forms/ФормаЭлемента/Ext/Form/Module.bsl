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
	
	Если Объект.Предопределенный Или Объект.ЗапретитьРедактированиеПользователем Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.Тип.ТолькоПросмотр          = Истина;
		Элементы.ГруппаТипОбщиеДляВсех.ТолькоПросмотр = Объект.ЗапретитьРедактированиеПользователем;
	Иначе
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект,, НСтр("ru = 'Разрешить редактирование типа и группы'"));
			
		Иначе
			Элементы.Родитель.ТолькоПросмотр = Истина;
			Элементы.Тип.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	СсылкаРодителя = Объект.Родитель;
	Элементы.ХранитьИсториюИзменений.Доступность         = Объект.РедактированиеТолькоВДиалоге;
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = НЕ Объект.ХранитьИсториюИзменений;
	
	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		Элементы.РедактированиеТолькоВДиалоге.Доступность       = Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность    = Ложь;
		Элементы.ГруппаНаименованиеНастройкиПоТипам.Доступность = Ложь;
		Элементы.ХранитьИсториюИзменений.Доступность            = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
	
	Если Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес
		ИЛИ НЕ СсылкаРодителя.Пустая()
		ИЛИ СсылкаРодителя.Уровень() = 0 Тогда
		ТабличнаяЧасть = Неопределено;
		Если СтрНачинаетсяС(СсылкаРодителя.ИмяПредопределенныхДанных, "Справочник") Тогда
			ИмяОбъекта = Сред(СсылкаРодителя.ИмяПредопределенныхДанных, 11);
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Справочники[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		ИначеЕсли СтрНачинаетсяС(СсылкаРодителя.ИмяПредопределенныхДанных, "Документ") Тогда
			ИмяОбъекта = Сред(СсылкаРодителя.ИмяПредопределенныхДанных, 9);
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Документы[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		КонецЕсли;
		
		Если ТабличнаяЧасть <> Неопределено Тогда
			Если ТабличнаяЧасть.Реквизиты.Найти("ДействуетС") <> Неопределено Тогда
				Элементы.ГруппаХранитьИсториюИзменений.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДоступныДополнительныеНастройкиАдреса = (Метаданные.Обработки.Найти("РасширенныйВводКонтактнойИнформации") <> Неопределено
		И Метаданные.Обработки["РасширенныйВводКонтактнойИнформации"].Формы.Найти("НастройкиАдреса") <> Неопределено);
		
	ЛокализацияСервер.ПриСозданииНаСервере(Элементы.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьОтображениеПриИзмененииТипа();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЛокализацияСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	ЛокализацияСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ТекущийОбъект.Предопределенный Тогда
		// Обработчик подсистемы запрета редактирования реквизитов объектов.
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектов = ОбщегоНазначения.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектов");
			МодульЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ЛокализацияСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ИзменитьРеквизитыПриИзмененииТипа();
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеТолькоВДиалогеПриИзменении(Элемент)
	
	Если Объект.РедактированиеТолькоВДиалоге Тогда
		Элементы.ХранитьИсториюИзменений.Доступность = Истина;
	Иначе
		Элементы.ХранитьИсториюИзменений.Доступность = Ложь;
		Объект.ХранитьИсториюИзменений               = Ложь;
	КонецЕсли;
	
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = НЕ Объект.ХранитьИсториюИзменений;
	
КонецПроцедуры

&НаКлиенте
Процедура ХранитьИсториюИзмененийПриИзменении(Элемент)
	
	Если Объект.ХранитьИсториюИзменений Тогда
		Объект.РазрешитьВводНесколькихЗначений = Ложь;
	КонецЕсли;
	
	Элементы.РазрешитьВводНесколькихЗначений.Доступность = Не Объект.ХранитьИсториюИзменений;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВводНесколькихЗначенийПриИзменении(Элемент)
	
	Если Объект.РазрешитьВводНесколькихЗначений Тогда
		Объект.ХранитьИсториюИзменений = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РодительОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура МеждународныйФорматАдресаПриИзменении(Элемент)
	
	ИзменитьОтображениеПриИзмененииТипа();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеОткрытие(Элемент, СтандартнаяОбработка)
	
	ЛокализацияКлиент.ПриОткрытии(Объект, Элемент, "Наименование", СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Предопределенный Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов") Тогда
			МодульЗапретРедактированияРеквизитовОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗапретРедактированияРеквизитовОбъектовКлиент");
			МодульЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеНастройкиАдреса(Команда)
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыНастроекАдреса", ЭтотОбъект);
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Объект", Объект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтотОбъект.ТолькоПросмотр);
	ИмяФормыНастройкиАдреса = "Обработка.РасширенныйВводКонтактнойИнформации.Форма.НастройкиАдреса";
	ОткрытьФорму(ИмяФормыНастройкиАдреса, ПараметрыФормы,,,,, ОповещениеОЗакрытие);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Адрес;
		Элементы.РедактированиеТолькоВДиалоге.Доступность  = Объект.МожноИзменятьСпособРедактирования;
		Элементы.ДополнительныеНастройкиАдреса.Видимость   = ДоступныДополнительныеНастройкиАдреса;
		Элементы.ДополнительныеНастройкиАдреса.Доступность = Не Объект.МеждународныйФорматАдреса;
	Иначе
		Элементы.ДополнительныеНастройкиАдреса.Видимость = Ложь;
		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.АдресЭлектроннойПочты;
			Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Skype;
			Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
			Элементы.РазрешитьВводНесколькихЗначений.Доступность = Истина;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
			Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Телефон;
			Элементы.РедактированиеТолькоВДиалоге.Доступность = Объект.МожноИзменятьСпособРедактирования;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Другое;
			Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.РедактированиеТолькоВДиалоге.Видимость  = Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;
		Иначе
			Элементы.Проверки.ТекущаяСтраница = Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТипа()
	
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.ХранитьИсториюИзменений.Доступность = Истина;
	Иначе
		
		Объект.ХранитьИсториюИзменений               = Ложь;
		Элементы.ХранитьИсториюИзменений.Доступность = Ложь;
		
		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Объект.РедактированиеТолькоВДиалоге = Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
			Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			// Нет изменений
		Иначе
			Объект.РедактированиеТолькоВДиалоге = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыНастроекАдреса(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

