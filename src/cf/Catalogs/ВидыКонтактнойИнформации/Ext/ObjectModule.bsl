﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Результат = УправлениеКонтактнойИнформациейСлужебный.ПроверитьПараметрыВидаКонтактнойИнформации(ЭтотОбъект);
		Если Результат.ЕстьОшибки Тогда
			Отказ = Истина;
			ВызватьИсключение Результат.ТекстОшибки;
		КонецЕсли;
		ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенногоВида");
		Если ПустаяСтрока(ИмяГруппы) Тогда
			ИмяГруппы = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенныхДанных");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СтрНачинаетсяС(ИмяПредопределенныхДанных, "Удалить") Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("Родитель");
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ИмяПредопределенногоВида = "";
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	
	ЛокализацияСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли