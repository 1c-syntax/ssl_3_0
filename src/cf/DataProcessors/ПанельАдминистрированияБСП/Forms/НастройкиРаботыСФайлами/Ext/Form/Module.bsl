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
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		ВызватьИсключение НСтр("ru = 'Не внедрена подсистема Работа с файлами.
			|Рекомендуется отключить видимость этой панели.'");
	КонецЕсли;
	
	ЭтоАдминистраторСистемы = Пользователи.ЭтоПолноправныйПользователь(, Истина);
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	ЗапрещатьЗагрузкуФайловПоРасширению  = НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению;	
	МаксимальныйРазмерФайла              = МодульРаботаСФайлами.МаксимальныйРазмерФайлаОбщий() / (1024*1024);
	МаксимальныйРазмерФайлаОбластиДанных = МодульРаботаСФайлами.МаксимальныйРазмерФайла() / (1024*1024);
	Если РазделениеВключено Тогда
		Элементы.МаксимальныйРазмерФайла.МаксимальноеЗначение = МаксимальныйРазмерФайла;
	КонецЕсли;

	Элементы.ГруппаХранитьФайлыВТомахНаДиске.Видимость       = ЭтоАдминистраторСистемы;
	Элементы.ГруппаСправочникТомаХраненияФайлов.Видимость    = ЭтоАдминистраторСистемы;
	Элементы.ОбщиеПараметрыДляВсехОбластейДанных.Видимость   = ЭтоАдминистраторСистемы И РазделениеВключено;
	Элементы.ГруппаСписокРасширенийТекстовыхФайлов.Видимость = Не РазделениеВключено;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
	НастройкиПрограммыПереопределяемый.НастройкиРаботыСФайламиПриСозданииНаСервере(ЭтотОбъект);
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.СписокРасширенийТекстовыхФайлов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.СписокРасширенийФайловOpenDocumentОбластиДанных.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХранитьФайлыВТомахНаДискеПриИзменении(Элемент)
	
	СтароеЗначение = Не НаборКонстант.ХранитьФайлыВТомахНаДиске;
	
	Попытка
		ЗапросыНаИспользованиеВнешнихРесурсов = 
			ЗапросыНаИспользованиеВнешнихРесурсовТомовХраненияФайлов(
				НаборКонстант.ХранитьФайлыВТомахНаДиске);
		
		ОбработкаОповещения = Новый ОписаниеОповещения("ХранитьФайлыВТомахНаДискеПриИзмененииЗавершение", ЭтотОбъект, Элемент);
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
				ЗапросыНаИспользованиеВнешнихРесурсов, ЭтотОбъект, ОбработкаОповещения);
		Иначе
			ВыполнитьОбработкуОповещения(ОбработкаОповещения, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Если Не ЕстьТомаХраненияФайлов() И НаборКонстант.ХранитьФайлыВТомахНаДиске Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Включено хранение файлов в томах на диске, но тома еще не настроены.
				|Добавляемые файлы будут сохраняться в информационной базе до тех пор, пока не будет настроен хотя бы один том хранения файлов.'"));
		КонецЕсли;
	Исключение
		НаборКонстант.ХранитьФайлыВТомахНаДиске = СтароеЗначение;
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПриИзменении(Элемент)
	
	Если Не ЗапрещатьЗагрузкуФайловПоРасширению Тогда
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Элемент", Элемент);
		Оповещение = Новый ОписаниеОповещения("ЗапрещатьЗагрузкуФайловПоРасширениюПослеПодтверждения", ЭтотОбъект, ДополнительныеПараметры);
		ПараметрыФормы = Новый Структура("Ключ", "ПриИзмененииСпискаЗапрещенныхРасширений");
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Оповещение);
		Возврат;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьФайлыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаОбластиДанныхПриИзменении(Элемент)
	Если МаксимальныйРазмерФайлаОбластиДанных = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Максимальный размер файла"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ,"МаксимальныйРазмерФайлаОбластиДанных");
		Возврат;
	КонецЕсли;
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийТекстовыхФайловПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Общие параметры для всех областей данных.

&НаКлиенте
Процедура МаксимальныйРазмерФайлаПриИзменении(Элемент)
	Если МаксимальныйРазмерФайла = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Максимальный размер файла"" не заполнено.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, ,"МаксимальныйРазмерФайла");
		Возврат;
	КонецЕсли;
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СправочникТомаХраненияФайлов(Команда)
	ИмяОткрываемойФормы = "Справочник.ТомаХраненияФайлов.ФормаСписка";
	ОткрытьФорму(ИмяОткрываемойФормы, , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСинхронизацииФайлов(Команда)
	ИмяОткрываемойФормы = "РегистрСведений.НастройкиСинхронизацииФайлов.ФормаСписка";
	ОткрытьФорму(ИмяОткрываемойФормы, , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено И Результат = "Продолжить" Тогда
		Подключаемый_ПриИзмененииРеквизита(ДополнительныеПараметры.Элемент);
	Иначе
		ЗапрещатьЗагрузкуФайловПоРасширению = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ХранитьФайлыВТомахНаДискеПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		НаборКонстант.ХранитьФайлыВТомахНаДиске = Не НаборКонстант.ХранитьФайлыВТомахНаДиске;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗапросыНаИспользованиеВнешнихРесурсовТомовХраненияФайлов(Включение)
	
	ЗапросыНаИспользование = Новый Массив;
	ИмяСправочника = "ТомаХраненияФайлов";
	
	Если Включение Тогда
		Справочники[ИмяСправочника].ДобавитьЗапросыНаИспользованиеВнешнихРесурсовВсехТомов(
			ЗапросыНаИспользование);
	Иначе
		Справочники[ИмяСправочника].ДобавитьЗапросыНаОтменуИспользованияВнешнихРесурсовВсехТомов(
			ЗапросыНаИспользование);
	КонецЕсли;
	
	Возврат ЗапросыНаИспользование;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Если РеквизитПутьКДанным = "МаксимальныйРазмерФайла" Тогда
			НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * (1024*1024);
			КонстантаИмя = "МаксимальныйРазмерФайла";
			
		ИначеЕсли РеквизитПутьКДанным = "МаксимальныйРазмерФайлаОбластиДанных" Тогда
			
			Если Не ОбщегоНазначения.РазделениеВключено() Тогда
				НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайла";
			Иначе
				НаборКонстант.МаксимальныйРазмерФайлаОбластиДанных = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайлаОбластиДанных";
			КонецЕсли;
		ИначеЕсли РеквизитПутьКДанным = "ЗапрещатьЗагрузкуФайловПоРасширению" Тогда
			НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению = ЗапрещатьЗагрузкуФайловПоРасширению;
			КонстантаИмя = "ЗапрещатьЗагрузкуФайловПоРасширению";
		КонецЕсли;
	Иначе	
		КонстантаИмя = ЧастиИмени[1];
	КонецЕсли;
	
	Если ПустаяСтрока(КонстантаИмя) Тогда
		Возврат "";
	КонецЕсли;	
	
	КонстантаМенеджер = Константы[КонстантаИмя];
	КонстантаЗначение = НаборКонстант[КонстантаИмя];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ХранитьФайлыВТомахНаДиске" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СправочникТомаХраненияФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	КонецЕсли;

	Если РеквизитПутьКДанным = "ЗапрещатьЗагрузкуФайловПоРасширению" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СписокЗапрещенныхРасширенийОбластиДанных.Доступность = ЗапрещатьЗагрузкуФайловПоРасширению;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.СинхронизироватьФайлы" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.НастройкиСинхронизацииФайлов.Доступность = НаборКонстант.СинхронизироватьФайлы;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьТомаХраненияФайлов()
	
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	Возврат МодульРаботаСФайлами.ЕстьТомаХраненияФайлов();
	
КонецФункции

#КонецОбласти
