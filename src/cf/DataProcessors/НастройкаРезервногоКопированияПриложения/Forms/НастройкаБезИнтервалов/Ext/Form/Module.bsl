﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОтветПередЗакрытием;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Для корректной работы необходим режим толстого, тонкого или ВЕБ-клиента.'");
		
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРезервногоКопирования);
	
	Для НомерМесяца = 1 По 12 Цикл
		Элементы.МесяцФормированияЕжегодныхКопий.СписокВыбора.Добавить(НомерМесяца, 
			Формат(Дата(2, НомерМесяца, 1), "ДФ=MMMM"));
	КонецЦикла;
	
	ЧасовойПояс = ЧасовойПоясСеанса();
	ЧасовойПоясОбласти = ЧасовойПояс + " (" + ПредставлениеЧасовогоПояса(ЧасовойПояс) + ")";
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтветПередЗакрытием = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Настройки были изменены. Сохранить изменения?'"), 
		РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
КонецПроцедуры
		
&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт	
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ЗаписатьНастройкиРезервногоКопирования();
	КонецЕсли;
	ОтветПередЗакрытием = Истина;
    Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПоУмолчанию(Команда)
	
	УстановитьПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНастройкиРезервногоКопирования();
	Модифицированность = Ложь;
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПоУмолчаниюНаСервере()
	
	НастройкиРезервногоКопирования = РезервноеКопированиеОбластейДанных.ПолучитьНастройкиРезервногоКопированияОбласти();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиРезервногоКопирования);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиРезервногоКопирования()

	СоответствиеНастроек = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	
	НастройкиРезервногоКопирования = Новый Структура;
	Для Каждого КлючИЗначение Из СоответствиеНастроек Цикл
		НастройкиРезервногоКопирования.Вставить(КлючИЗначение.Значение, ЭтотОбъект[КлючИЗначение.Значение]);
	КонецЦикла;
	
	РезервноеКопированиеОбластейДанных.УстановитьНастройкиРезервногоКопированияОбласти(
		РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), НастройкиРезервногоКопирования);
		
КонецПроцедуры

#КонецОбласти
