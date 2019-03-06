﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ВзаимодействияСобытия.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("ПометкаУдаления", Ложь);
	Иначе
		ДополнительныеСвойства.Вставить("ПометкаУдаления",
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления"));
	КонецЕсли;
		
	Если ПометкаУдаления Тогда
		ЕстьВложения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	УправлениеЭлектроннойПочтой.УстановитьПометкуУдаленияУВложенийПисьма(Ссылка, ПометкаУдаления);
	Взаимодействия.ОтработатьПризнакИзмененияПометкиУдаленияПриЗаписиПисьма(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УправлениеЭлектроннойПочтой.УдалитьВложенияУПисьма(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли