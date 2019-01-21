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
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
	Элементы.Ссылка.ОграничениеТипа  = Параметры.ТипЗначения;
	СтрокаСсылочногоТипа             = Параметры.СтрокаСсылочногоТипа;
	Элементы.Представление.Видимость = СтрокаСсылочногоТипа;
	Элементы.Ссылка.Заголовок        = Параметры.НаименованиеРеквизита;
	
	КлючИспользования = ?(СтрокаСсылочногоТипа, "РедактированиеСтроки", "РедактированиеСсылочногоОбъекта");
	СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, КлючИспользования);
	
	Если Не Параметры.СтрокаСсылочногоТипа
		И УправлениеСвойствамиСлужебный.ТипЗначенияСодержитЗначенияСвойств(Параметры.ТипЗначения) Тогда
		ПараметрВыбора = ?(ЗначениеЗаполнено(Параметры.ВладелецДополнительныхЗначений),
			Параметры.ВладелецДополнительныхЗначений, Параметры.Свойство);
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ИмяРеквизита", Параметры.ИмяРеквизита);
	ВозвращаемоеЗначение.Вставить("СтрокаСсылочногоТипа", СтрокаСсылочногоТипа);
	Если Параметры.СтрокаСсылочногоТипа Тогда
		ВозвращаемоеЗначение.Вставить("ИмяРеквизитаСсылки", Параметры.ИмяРеквизитаСсылки);
		
		СсылкаИПредставление = УправлениеСвойствамиСлужебный.АдресИПредставление(Параметры.ЗначениеРеквизита);
		Ссылка        = СсылкаИПредставление.Ссылка;
		Представление = СсылкаИПредставление.Представление;
	Иначе
		Ссылка = Параметры.ЗначениеРеквизита;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
		Элементы.ФормаКнопкаОк.Отображение = ОтображениеКнопки.Картинка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПараметрВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбораМассив = Новый Массив;
	ПараметрыВыбораМассив.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ПараметрВыбора));
	
	Элементы.Ссылка.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораМассив);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОк(Команда)
	Если СтрокаСсылочногоТипа Тогда
		Шаблон = "<a href = ""%1"">%2</a>";
		Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = Ссылка;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Ссылка) Тогда
			Значение = "";
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", ПустаяФорматированнаяСтрока());
		Иначе
			Значение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Ссылка, Представление);
			ВозвращаемоеЗначение.Вставить("ФорматированнаяСтрока", СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Значение));
		КонецЕсли;
	Иначе
		Значение = Ссылка;
	КонецЕсли;
	
	ВозвращаемоеЗначение.Вставить("Значение", Значение);
	Закрыть(ВозвращаемоеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПустаяФорматированнаяСтрока()
	ПредставлениеЗначения= НСтр("ru = 'не задано'");
	СсылкаРедактирования = "НеЗадано";
	Результат            = Новый ФорматированнаяСтрока(ПредставлениеЗначения,, ЦветаСтиля.ЦветПустойГиперссылки,, СсылкаРедактирования);
	
	Возврат Результат;
КонецФункции

#КонецОбласти