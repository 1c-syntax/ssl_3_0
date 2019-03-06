﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ЗаписатьНастройки, МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование и восстановление данных необходимо настроить средствами операционной системы или другими сторонними средствами.'");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте.'");
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	Объект.ВариантВыполнения = НастройкиРезервногоКопирования.ВариантВыполнения;
	Объект.ВыполнятьАвтоматическоеРезервноеКопирование = НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование;
	Объект.РезервноеКопированиеНастроено = НастройкиРезервногоКопирования.РезервноеКопированиеНастроено;
	
	Если Не Объект.РезервноеКопированиеНастроено Тогда
		Объект.ВыполнятьАвтоматическоеРезервноеКопирование = Истина;
	КонецЕсли;
	ЭтоБазоваяВерсияКонфигурации = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	Элементы.Обычный.Видимость = Не ЭтоБазоваяВерсияКонфигурации;
	Элементы.Базовый.Видимость = ЭтоБазоваяВерсияКонфигурации;
	
	ПарольАдминистратораИБ = НастройкиРезервногоКопирования.ПарольАдминистратораИБ;
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
	Элементы.ИзменитьРасписание.Заголовок = Строка(Расписание);
	Объект.КаталогСРезервнымиКопиями = НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	
	// Заполнение настроек по хранению старых копий.
	
	ЗаполнитьЗначенияСвойств(Объект, НастройкиРезервногоКопирования.ПараметрыУдаления);
	
	ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(ЭтотОбъект);
	
	ИнформацияОПользователе = РезервноеКопированиеИБСервер.ИнформацияОПользователе();
	ТребуетсяВводПароля = ИнформацияОПользователе.ТребуетсяВводПароля;
	Если ТребуетсяВводПароля Тогда
		АдминистраторИБ = ИнформацияОПользователе.Имя;
	Иначе
		Элементы.ГруппаАвторизации.Видимость = Ложь;
		Элементы.АвторизацияАдминистратораИнформационнойБазы.Видимость = Ложь;
		ПарольАдминистратораИБ = "";
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Настройки = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	Если Настройки = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = Настройки.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	Настройки.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	ЗаписатьНастройки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗаписатьНастройки Тогда
		ИмяПараметра = "РезервноеКопированиеИБПриЗавершенииРаботы";
		ПараметрыПриЗавершении = Новый Структура(СтандартныеПодсистемыКлиент.ПараметрКлиента(ИмяПараметра));
		ПараметрыПриЗавершении.ВыполнятьПриЗавершенииРаботы = Объект.ВыполнятьАвтоматическоеРезервноеКопирование
			И Объект.ВариантВыполнения = "ПриЗавершенииРаботы";
		ПараметрыПриЗавершении = Новый ФиксированнаяСтруктура(ПараметрыПриЗавершении);
		СтандартныеПодсистемыКлиент.УстановитьПараметрКлиента(ИмяПараметра, ПараметрыПриЗавершении);
	Иначе
		ИмяПараметра = "СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ";
		ПараметрыПриложения[ИмяПараметра].МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования
			= МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ЗакрытаФормаНастройкиРезервногоКопирования");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыполнятьАвтоматическоеРезервноеКопированиеПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОграниченияКаталогаСРезервнымиКопиямиПриИзменении(Элемент)
	
	
	ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог для сохранения резервных копий'");
	ДиалогОткрытияФайла.Каталог = Элементы.ПутьККаталогуАрхивов.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.КаталогСРезервнымиКопиями = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьПерейтиВЖурналРегистрацииНажатие(Элемент)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПроведенияРезервногоКопированияПриИзменении(Элемент)
	
	Элементы.ИзменитьРасписание.Доступность = (Объект.ВариантВыполнения = "ПоРасписанию");
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПериодаХраненияРезервныхКопийОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ЗаписатьНастройки = Истина;
	ПерейтиСоСтраницыНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиСоСтраницыНастройки()
	
	ПараметрыРезервногоКопированияИБ = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	ТекущийПользователь = ПользователиКлиент.ТекущийПользователь();
	
	Если Объект.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
		
		Если Не ПроверитьКаталогСРезервнымиКопиями() Тогда
			Возврат;
		КонецЕсли;
		
		Контекст = Новый Структура;
		Контекст.Вставить("ПараметрыРезервногоКопированияИБ", ПараметрыРезервногоКопированияИБ);
		Контекст.Вставить("ТекущийПользователь", ТекущийПользователь);
		
		Оповещение = Новый ОписаниеОповещения(
			"ПерейтиСоСтраницыНастройкиПослеПроверкиДоступаКИнформационнойБазе", ЭтотОбъект, Контекст);
		
		РезервноеКопированиеИБКлиент.ПроверитьДоступКИнформационнойБазе(ПарольАдминистратораИБ, Оповещение);
		Возврат;
	КонецЕсли;
		
	ОстановитьСервисОповещения(ТекущийПользователь);
	РезервноеКопированиеИБКлиент.ОтключитьОбработчикОжиданияРезервногоКопирования();
	ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	ПараметрыРезервногоКопированияИБ.ПараметрОповещения = "НеОповещать";
	
	ОбновитьПовторноИспользуемыеЗначения();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиСоСтраницыНастройкиПослеПроверкиДоступаКИнформационнойБазе(РезультатПодключения, Контекст) Экспорт
	
	ПараметрыРезервногоКопированияИБ = Контекст.ПараметрыРезервногоКопированияИБ;
	ТекущийПользователь = Контекст.ТекущийПользователь;
	
	Если РезультатПодключения.ОшибкаПодключенияКомпоненты Тогда
		Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.ДополнительныеНастройки;
		ОбнаруженнаяОшибкаПодключения = РезультатПодключения.КраткоеОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	ЗаписатьНастройки(ТекущийПользователь);
	
	Если Объект.ВариантВыполнения = "ПоРасписанию" Тогда
		ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
		ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = ТекущаяДата;
		ПараметрыРезервногоКопированияИБ.ДатаПоследнегоРезервногоКопирования = ТекущаяДата;
		ПараметрыРезервногоКопированияИБ.РасписаниеЗначение = Расписание;
	ИначеЕсли Объект.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
		ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	КонецЕсли;
	
	РезервноеКопированиеИБКлиент.ПодключитьОбработчикОжиданияРезервногоКопирования();
	
	ИмяФормыНастроек = "e1cib/app/Обработка.НастройкаРезервногоКопированияИБ/";
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"), ИмяФормыНастроек,
		НСтр("ru = 'Резервное копирование настроено.'"));
	
	ПараметрыРезервногоКопированияИБ.ПараметрОповещения = "НеОповещать";
	
	ОбновитьПовторноИспользуемыеЗначения();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьКаталогСРезервнымиКопиями()
	
#Если ВебКлиент ИЛИ МобильныйКлиент Тогда
	ТекстСообщения = НСтр("ru = 'Для корректной работы необходим режим тонкого или толстого клиента.'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	РеквизитыЗаполнены = Ложь;
#Иначе
	РеквизитыЗаполнены = Истина;
	
	Если ПустаяСтрока(Объект.КаталогСРезервнымиКопиями) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбран каталог для резервной копии.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
		РеквизитыЗаполнены = Ложь;
		
	ИначеЕсли НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Указан несуществующий каталог.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
		РеквизитыЗаполнены = Ложь;
		
	Иначе
		
		Попытка
			ТестовыйФайл = Новый ЗаписьXML;
			ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
			ТестовыйФайл.ЗаписатьОбъявлениеXML();
			ТестовыйФайл.Закрыть();
		Исключение
			ТекстСообщения = НСтр("ru = 'Нет доступа к каталогу с резервными копиями.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
			РеквизитыЗаполнены = Ложь;
		КонецПопытки;
		
		Если РеквизитыЗаполнены Тогда
			
			Попытка
				УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
			Исключение
				// Исключение не обрабатываем т.к. на этом шаге не происходит удаления файлов.
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяВводПароля И ПустаяСтрока(ПарольАдминистратораИБ) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не задан пароль администратора.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПарольАдминистратораИБ");
		РеквизитыЗаполнены = Ложь;
		
	КонецЕсли;

#КонецЕсли
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОстановитьСервисОповещения(ТекущийПользователь)
	// Останавливает оповещения о резервном копировании.
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование = Ложь;
	НастройкиРезервногоКопирования.РезервноеКопированиеНастроено = Истина;
	НастройкиРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиРезервногоКопирования, ТекущийПользователь);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки(ТекущийПользователь)
	
	ЭтоБазоваяВерсияКонфигурации = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	Если ЭтоБазоваяВерсияКонфигурации Тогда
		Объект.ВариантВыполнения = "ПриЗавершенииРаботы";
	КонецЕсли;
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
	ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ?(ТребуетсяВводПароля, ПарольАдминистратораИБ, ""));
	ПараметрыРезервногоКопирования.ДатаПоследнегоОповещения = Дата('29990101');
	ПараметрыРезервногоКопирования.КаталогХраненияРезервныхКопий = Объект.КаталогСРезервнымиКопиями;
	ПараметрыРезервногоКопирования.ВариантВыполнения = Объект.ВариантВыполнения;
	ПараметрыРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование = Объект.ВыполнятьАвтоматическоеРезервноеКопирование;
	ПараметрыРезервногоКопирования.РезервноеКопированиеНастроено = Истина;
	
	ЗаполнитьЗначенияСвойств(ПараметрыРезервногоКопирования.ПараметрыУдаления, Объект);
	
	Если Объект.ВариантВыполнения = "ПоРасписанию" Тогда
		
		РасписаниеСтруктура = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
		ПараметрыРезервногоКопирования.РасписаниеКопирования = РасписаниеСтруктура;
		ПараметрыРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = ТекущаяДатаСеанса();
		ПараметрыРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса();
		
	ИначеЕсли Объект.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
		
		ПараметрыРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
		
	КонецЕсли;
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(Форма)
	
	Форма.Элементы.ГруппаХранитьПоследниеЗаПериод.Доступность = (Форма.Объект.ТипОграничения = "ПоПериоду");
	Форма.Элементы.ГруппаКоличествоКопийВКаталоге.Доступность = (Форма.Объект.ТипОграничения = "ПоКоличеству");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеЗавершение(РасписаниеРезультат, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеРезультат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = РасписаниеРезультат;
	Элементы.ИзменитьРасписание.Заголовок = Строка(Расписание);
	
КонецПроцедуры

/////////////////////////////////////////////////////////
// Представление данных на форме.

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.ИзменитьРасписание.Доступность = (Объект.ВариантВыполнения = "ПоРасписанию");
	
	ДоступноРезервноеКопирование = Объект.ВыполнятьАвтоматическоеРезервноеКопирование;
	Элементы.ГруппаПараметры.Доступность = ДоступноРезервноеКопирование;
	Элементы.ВыборВариантаАвтоматическогоРезервногоКопирования.Доступность = ДоступноРезервноеКопирование;
	
КонецПроцедуры

#КонецОбласти
