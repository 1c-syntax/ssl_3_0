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

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта_Горизонталь = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта_Горизонталь.Описание = НСтр("ru = 'Горизонтальное размещение колонок с измерениями, ресурсами и реквизитами регистров.'");
	НастройкиВарианта_Горизонталь.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Движения документа'");
	
	НастройкиВарианта_Вертикаль = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Дополнительный");
	НастройкиВарианта_Вертикаль.Описание = НСтр("ru = 'Вертикальное размещение колонок с измерениями, ресурсами и реквизитами позволяет расположить данные более компактно, для просмотра регистров с большим количеством колонок.'");
	НастройкиВарианта_Вертикаль.НастройкиДляПоиска.КлючевыеСлова = НСтр("ru = 'Движения документа'");
	
КонецПроцедуры

// Для вызова из процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
// 
// Параметры:
//   КомандыОтчетов              - ТаблицаЗначений - таблица команд для вывода в подменю.
//                                 (См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов).
//   Параметры                   - Структура - структура, содержащая параметры подключения команды.
//   ДокументыСОтчетомОДвижениях - Массив, Неопределено - массив документов, в которых будет выводится
//                                 команда открытия отчета. Неопределено в том случае когда отчет выводится
//                                 для всех документов со свойством "Проведение" установленным в "Разрешить"
//                                 и непустой коллекцией движений.
//
// Возвращаемое значение:
//   СтрокаТаблицыЗначений, Неопределено - добавленная команда или Неопределено, если нет прав на просмотр отчета.
//
Функция ДобавитьКомандуОтчетОДвиженияхДокумента(КомандыОтчетов, Параметры, ДокументыСОтчетомОДвижениях = Неопределено) Экспорт
	
	Если Не ПравоДоступа("Просмотр", Метаданные.Отчеты.ДвиженияДокумента) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеТипаПараметраКоманды = ОписаниеТипаПараметраКоманды(КомандыОтчетов, Параметры, ДокументыСОтчетомОДвижениях);
	Если ОписаниеТипаПараметраКоманды = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Команда                    = КомандыОтчетов.Добавить();
	Команда.Представление      = НСтр("ru = 'Движения документа'");
	Команда.МножественныйВыбор = Ложь;
	Команда.ИмяПараметраФормы  = "";
	Команда.Важность           = "СмТакже";
	Команда.ТипПараметра       = ОписаниеТипаПараметраКоманды;
	Команда.Менеджер           = "Отчет.ДвиженияДокумента";
	Команда.СочетаниеКлавиш    = Новый СочетаниеКлавиш(Клавиша.L, Ложь, Истина, Истина);
	
	Возврат Команда;
	
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ДвиженияДокумента);
	ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДвиженияДокумента).Включен = Ложь;
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, НастройкиФормы, СтандартнаяОбработка) Экспорт
	
	ДобавитьКомандуОтчетОДвиженияхДокумента(КомандыОтчетов, НастройкиФормы);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОписаниеТипаПараметраКоманды(Знач КомандыОтчетов, Знач Параметры, Знач ДокументыСОтчетомОДвижениях)
	
	Если Не Параметры.Свойство("Источники") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокиИсточников = Параметры.Источники.Строки;
	
	Если ДокументыСОтчетомОДвижениях <> Неопределено Тогда
		ОтключитьОтчетОтДокументов(КомандыОтчетов);
		ДокументыСОтчетом = Новый Соответствие;
		Для каждого ДокументСОтчетом Из ДокументыСОтчетомОДвижениях Цикл
			ДокументыСОтчетом[ДокументСОтчетом] = Истина;
		КонецЦикла;	
	Иначе	
		ДокументыСОтчетом = Неопределено;
	КонецЕсли;
	
	ТипыДокументовСДвижениями = Новый Массив;
	Для Каждого СтрокаИсточника Из СтрокиИсточников Цикл
		
		ТипСсылкиДанных = СтрокаИсточника.ТипСсылкиДанных;
		
		Если ТипЗнч(ТипСсылкиДанных) = Тип("Тип") Тогда
			ТипыДокументовСДвижениями.Добавить(ТипСсылкиДанных);
		ИначеЕсли ТипЗнч(ТипСсылкиДанных) = Тип("ОписаниеТипов") Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ТипыДокументовСДвижениями, ТипСсылкиДанных.Типы());
		КонецЕсли;
		
	КонецЦикла;
	
	ТипыДокументовСДвижениями = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ТипыДокументовСДвижениями);
	
	Индекс = ТипыДокументовСДвижениями.Количество() - 1;
	Пока Индекс >= 0 Цикл
		Если Не ЭтоПодключаемыйТип(ТипыДокументовСДвижениями[Индекс], ДокументыСОтчетом) Тогда
			ТипыДокументовСДвижениями.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;	
	
	Возврат ?(ТипыДокументовСДвижениями.Количество() > 0, Новый ОписаниеТипов(ТипыДокументовСДвижениями), Неопределено);
	
КонецФункции

Процедура ОтключитьОтчетОтДокументов(КомандыОтчетов)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Менеджер", "Отчет.ДвиженияДокумента");
	НайденныеСтроки = КомандыОтчетов.НайтиСтроки(СтруктураПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		КомандыОтчетов.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоПодключаемыйТип(ПроверяемыйТип, ДокументыСОтчетомОДвижениях)
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ПроверяемыйТип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ДокументыСОтчетомОДвижениях <> Неопределено И ДокументыСОтчетомОДвижениях[ОбъектМетаданных] = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ОбъектМетаданных.Проведение <> Метаданные.СвойстваОбъектов.Проведение.Разрешить
		Или ОбъектМетаданных.Движения.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецЕсли