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
	
	Если Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование и восстановление данных необходимо настроить средствами операционной системы или другими сторонними средствами.'");
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоВебКлиент()
		Или ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте и мобильном клиенте.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ВызватьИсключение НСтр("ru = 'В клиент-серверном варианте работы резервное копирование следует выполнять сторонними средствами (средствами СУБД).'");
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	ПарольАдминистратораИБ = НастройкиРезервногоКопирования.ПарольАдминистратораИБ;
	Объект.КаталогСРезервнымиКопиями = НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	
	Если КоличествоСеансовИнформационнойБазы() > 1 Тогда
		
		Элементы.СтраницыСтатусаВосстановления.ТекущаяСтраница = Элементы.СтраницаАктивныеПользователи;
		
	КонецЕсли;
	
	ИнформацияОПользователе = РезервноеКопированиеИБСервер.ИнформацияОПользователе();
	ТребуетсяВводПароля = ИнформацияОПользователе.ТребуетсяВводПароля;
	Если ТребуетсяВводПароля Тогда
		АдминистраторИБ = ИнформацияОПользователе.Имя;
	Иначе
		Элементы.ГруппаАвторизации.Видимость = Ложь;
		ПарольАдминистратораИБ = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Элементы.ГруппаComcntrФайловыйРежим.Видимость = Ложь;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекущаяСтраница = Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница;
	Если ТекущаяСтраница <> Элементы.СтраницыЗагрузкиДанных.ПодчиненныеЭлементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
		Возврат;
	КонецЕсли;
		
	ТекстПредупреждения = НСтр("ru = 'Прервать подготовку к восстановлению данных?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(ЭтотОбъект,
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СоединенияИБКлиент.УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Ложь);
	СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Ложь);
	СоединенияИБВызовСервера.РазрешитьРаботуПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗавершениеРаботыПользователей" И Параметр.КоличествоСеансов <= 1
		И Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования Тогда
			НачатьРезервноеКопирование();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьФайлРезервнойКопии();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейНажатие(Элемент)
	
	СтандартныеПодсистемыКлиент.ОткрытьСписокАктивныхПользователей(, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьОбновитьВерсиюКомпонентыОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФормаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнениеРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ГотовоПослеПроверкиДоступаКИнформационнойБазе", ЭтотОбъект);
	
	РезервноеКопированиеИБКлиент.ПроверитьДоступКИнформационнойБазе(ПарольАдминистратораИБ, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГотовоПослеПроверкиДоступаКИнформационнойБазе(РезультатПодключения, Контекст) Экспорт
	
	Если РезультатПодключения.ОшибкаПодключенияКомпоненты Тогда
		Элементы.СтраницыСтатусаВосстановления.ТекущаяСтраница = Элементы.СтраницаОшибкаПодключения;
		ОбнаруженнаяОшибкаПодключения = РезультатПодключения.КраткоеОписаниеОшибки;
	Иначе
		УстановитьПараметрыРезервногоКопирования();
		
		Страницы = Элементы.СтраницыЗагрузкиДанных;
		
		Страницы.ТекущаяСтраница = Элементы.СтраницаИнформацииИВыполненияРезервногоКопирования; 
		Элементы.Закрыть.Доступность = Истина;
		Элементы.Готово.Доступность = Ложь;
		
		КоличествоСеансовИнформационнойБазы = КоличествоСеансовИнформационнойБазы();
		Элементы.КоличествоАктивныхПользователей.Заголовок = КоличествоСеансовИнформационнойБазы;
		
		СоединенияИБВызовСервера.УстановитьБлокировкуСоединений(НСтр("ru = 'Выполняется восстановление информационной базы.'"), "РезервноеКопирование");
		
		Если КоличествоСеансовИнформационнойБазы = 1 Тогда
			СоединенияИБКлиент.УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Истина);
			СоединенияИБКлиент.УстановитьПризнакРаботаПользователейЗавершается(Истина);
			НачатьРезервноеКопирование();
		Иначе
			СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Истина);
			УстановитьОбработчикОжиданияНачалаРезервногоКопирования();
			УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВЖурналРегистрации(Команда)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", , ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Подключает обработчик ожидания истечения таймаута перед принудительным стартом резервного копирования/восстановления
// данных.
&НаКлиенте
Процедура УстановитьОбработчикОжиданияИстеченияТаймаутаРезервногоКопирования()
	
	ПодключитьОбработчикОжидания("ИстечениеВремениОжидания", 300, Истина);
	
КонецПроцедуры

// Подключает обработчик ожидания при отложенном резервном копировании.
&НаКлиенте
Процедура УстановитьОбработчикОжиданияНачалаРезервногоКопирования() 
	
	ПодключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения", 5);
	
КонецПроцедуры

// Функция запрашивает у пользователя и возвращает путь к файлу или каталогу.
&НаКлиенте
Процедура ВыбратьФайлРезервнойКопии()
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Резервная копия базы (*.zip, *.1CD)|*.zip;*.1cd'");
	ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите файл резервной копии'");
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла = Истина;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		Объект.ФайлЗагрузкиРезервнойКопии = ДиалогОткрытияФайла.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
#Если ВебКлиент Или МобильныйКлиент Тогда
	ТекстСообщения = НСтр("ru = 'Восстановление не доступно в веб-клиенте и мобильном клиенте.'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Возврат Ложь;
#Иначе
	
	Если ТребуетсяВводПароля И ПустаяСтрока(ПарольАдминистратораИБ) Тогда
		ТекстСообщения = НСтр("ru = 'Не задан пароль администратора.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПарольАдминистратораИБ");
		Возврат Ложь;
	КонецЕсли;
	
	Объект.ФайлЗагрузкиРезервнойКопии = СокрЛП(Объект.ФайлЗагрузкиРезервнойКопии);
	ИмяФайла = СокрЛП(Объект.ФайлЗагрузкиРезервнойКопии);
	
	Если ПустаяСтрока(ИмяФайла) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран файл с резервной копией.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
	КонецЕсли;
	
	ФайлАрхива = Новый Файл(ИмяФайла);
	Если ВРег(ФайлАрхива.Расширение) <> ".ZIP" И ВРег(ФайлАрхива.Расширение) <> ".1CD"  Тогда
		
		ТекстСообщения = НСтр("ru = 'Выбранный файл не является архивом с резервной копией.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ВРег(ФайлАрхива.Расширение) = ".1CD" Тогда
		
		Если ВРег(ФайлАрхива.ИмяБезРасширения) <> "1CV8" Тогда
			ТекстСообщения = НСтр("ru = 'Выбранный файл не является резервной копией (неправильное имя файла информационной базы).'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
			Возврат Ложь;
		КонецЕсли;
		
	Иначе 
		
		ZipФайл = Новый ЧтениеZipФайла(ИмяФайла);
		Если ZipФайл.Элементы.Количество() <> 1 Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный файл не является архивом с резервной копией (содержит более одного файла).'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
			Возврат Ложь;
			
		КонецЕсли;
		
		ФайлВАрхиве = ZipФайл.Элементы[0];
		
		Если ВРег(ФайлВАрхиве.Расширение) <> "1CD" Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный файл не является архивом с резервной копией (не содержит файл информационной базы).'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
			Возврат Ложь;
			
		КонецЕсли;
		
		Если ВРег(ФайлВАрхиве.ИмяБезРасширения) <> "1CV8" Тогда
			
			ТекстСообщения = НСтр("ru = 'Выбранный файл не является архивом с резервной копией (неправильное имя файла информационной базы).'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ФайлЗагрузкиРезервнойКопии");
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
#КонецЕсли
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры обработчиков ожидания.

&НаКлиенте
Процедура ИстечениеВремениОжидания()
	
	ОтключитьОбработчикОжидания("ПроверкаНаЕдинственностьПодключения");
	ОтменитьПодготовку();
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодготовку()
	
	Элементы.НадписьНеУдалось.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
		|Подготовка к восстановлению данных из резервной копии отменена. Информационная база разблокирована.'"),
		СоединенияИБ.СообщениеОНеотключенныхСеансах());
	Элементы.СтраницыЗагрузкиДанных.ТекущаяСтраница = Элементы.СтраницаОшибокПриКопировании;
	Элементы.Готово.Видимость = Ложь;
	Элементы.Закрыть.Заголовок = НСтр("ru = 'Закрыть'");
	Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
	
	СоединенияИБ.РазрешитьРаботуПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаНаЕдинственностьПодключения()
	
	Если КоличествоСеансовИнформационнойБазы() = 1 Тогда
		НачатьРезервноеКопирование();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРезервноеКопирование() 
	
#Если Не ВебКлиент И Не МобильныйКлиент Тогда
	
	ИмяГлавногоФайлаСкрипта = СформироватьФайлыСкриптаОбновления();
	ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(
		РезервноеКопированиеИБКлиент.СобытиеЖурналаРегистрации(), 
		"Информация",
		НСтр("ru = 'Выполняется восстановление данных информационной базы:'") + " " + ИмяГлавногоФайлаСкрипта);
	
	ЗакрытьФормуБезусловно = Истина;
	Закрыть();
	
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы", Истина);
	
	ПутьКПрограммеЗапуска = СтандартныеПодсистемыКлиент.ПапкаСистемныхПриложений() + "mshta.exe";
	
	СтрокаЗапуска = """%1"" ""%2"" [p1]%3[/p1]";
	СтрокаЗапуска = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		СтрокаЗапуска,
		ПутьКПрограммеЗапуска, 
		ИмяГлавногоФайлаСкрипта, 
		РезервноеКопированиеИБКлиент.СтрокаUnicode(ПарольАдминистратораИБ));
	
	ПараметрыЗапускаПрограммы = ФайловаяСистемаКлиент.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.Оповещение = Новый ОписаниеОповещения("ПослеЗапускаСкрипта", ЭтотОбъект);
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Ложь;
	
	ФайловаяСистемаКлиент.ЗапуститьПрограмму(СтрокаЗапуска, ПараметрыЗапускаПрограммы);
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗапускаСкрипта(Результат, Контекст) Экспорт
	
	Если Результат.ПриложениеЗапущено Тогда 
		ЗавершитьРаботуСистемы(Ложь);
	Иначе 
		ПоказатьПредупреждение(, Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции подготовки восстановления данных.

#Если Не ВебКлиент И Не МобильныйКлиент Тогда

&НаКлиенте
Функция СформироватьФайлыСкриптаОбновления() 
	
	ПараметрыКопирования = РезервноеКопированиеИБКлиент.КлиентскиеПараметрыРезервногоКопирования();
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	СоздатьКаталог(ПараметрыКопирования.КаталогВременныхФайловОбновления);
	
	// Структура параметров необходима для их определения на клиенте и передачи на сервер.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИмяФайлаПрограммы"           , ПараметрыКопирования.ИмяФайлаПрограммы);
	СтруктураПараметров.Вставить("СобытиеЖурналаРегистрации"   , ПараметрыКопирования.СобытиеЖурналаРегистрации);
	СтруктураПараметров.Вставить("ИмяCOMСоединителя"           , ПараметрыРаботыКлиента.ИмяCOMСоединителя);
	СтруктураПараметров.Вставить("ЭтоБазоваяВерсияКонфигурации", ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации);
	СтруктураПараметров.Вставить("ИнформационнаяБазаФайловая"  , ПараметрыРаботыКлиента.ИнформационнаяБазаФайловая);
	СтруктураПараметров.Вставить("ПараметрыСкрипта"            , РезервноеКопированиеИБКлиент.ПараметрыАутентификацииАдминистратораОбновления(ПарольАдминистратораИБ));
	СтруктураПараметров.Вставить("ПараметрыЗапускаПредприятия" , ОбщегоНазначенияСлужебныйКлиент.ПараметрыЗапускаПредприятияИзСкрипта());
	
	ИменаМакетов = "ДопФайлРезервногоКопирования";
	ИменаМакетов = ИменаМакетов + ",ЗаставкаВосстановления";
	
	ТекстыМакетов = ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[0]);
	
	ИмяФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "main.js";
	ФайлСкрипта.Записать(ИмяФайлаСкрипта, РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	// Вспомогательный файл: helpers.js.
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[1]);
	ФайлСкрипта.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "helpers.js", РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	ИмяГлавногоФайлаСкрипта = Неопределено;
	// Вспомогательный файл: splash.png.
	БиблиотекаКартинок.ЗаставкаВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.png");
	// Вспомогательный файл: splash.ico.
	БиблиотекаКартинок.ЗначокЗаставкиВнешнейОперации.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.ico");
	// Вспомогательный файл: progress.gif.
	БиблиотекаКартинок.ДлительнаяОперация48.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "progress.gif");
	// Главный файл заставки: splash.hta.
	ИмяГлавногоФайлаСкрипта = ПараметрыКопирования.КаталогВременныхФайловОбновления + "splash.hta";
	ФайлСкрипта = Новый ТекстовыйДокумент;
	ФайлСкрипта.Вывод = ИспользованиеВывода.Разрешить;
	ФайлСкрипта.УстановитьТекст(ТекстыМакетов[2]);
	ФайлСкрипта.Записать(ИмяГлавногоФайлаСкрипта, РезервноеКопированиеИБКлиент.КодировкаФайловПрограммыРезервногоКопированияИБ());
	
	ФайлЛога = Новый ТекстовыйДокумент;
	ФайлЛога.Вывод = ИспользованиеВывода.Разрешить;
	ФайлЛога.УстановитьТекст(СтандартныеПодсистемыКлиент.ИнформацияДляПоддержки());
	ФайлЛога.Записать(ПараметрыКопирования.КаталогВременныхФайловОбновления + "templog.txt", КодировкаТекста.Системная);
	
	Возврат ИмяГлавногоФайлаСкрипта;
	
КонецФункции

#КонецЕсли

&НаСервере
Функция ПолучитьТекстыМакетов(ИменаМакетов, СтруктураПараметров, СообщенияДляЖурналаРегистрации)
	
	// Запись накопленных событий ЖР.
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Результат = Новый Массив();
	Результат.Добавить(ПолучитьТекстСкрипта(СтруктураПараметров));
	
	ИменаМакетовМассив = СтрРазделить(ИменаМакетов, ",");
	Для каждого ИмяМакета Из ИменаМакетовМассив Цикл
		Результат.Добавить(Обработки.РезервноеКопированиеИБ.ПолучитьМакет(ИмяМакета).ПолучитьТекст());
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТекстСкрипта(СтруктураПараметров)
	
	// Файл обновления конфигурации: main.js.
	ШаблонСкрипта = Обработки.РезервноеКопированиеИБ.ПолучитьМакет("МакетФайлаЗагрузкаИБ");
	
	Скрипт = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	Скрипт.УдалитьСтроку(1);
	Скрипт.УдалитьСтроку(Скрипт.КоличествоСтрок());
	
	Текст = ШаблонСкрипта.ПолучитьОбласть("ОбластьРезервногоКопирования");
	Текст.УдалитьСтроку(1);
	Текст.УдалитьСтроку(Текст.КоличествоСтрок());
	
	Возврат ВставитьПараметрыСкрипта(Скрипт.ПолучитьТекст(), СтруктураПараметров) + Текст.ПолучитьТекст();
	
КонецФункции

&НаСервере
Функция ВставитьПараметрыСкрипта(Знач Текст, Знач СтруктураПараметров)
	
	Результат = Текст;
	
	ПараметрыСкрипта = СтруктураПараметров.ПараметрыСкрипта;
	СтрокаСоединенияИнформационнойБазы = ПараметрыСкрипта.СтрокаСоединенияИнформационнойБазы + ПараметрыСкрипта.СтрокаПодключения;
	
	Если СтрЗаканчиваетсяНа(СтрокаСоединенияИнформационнойБазы, ";") Тогда
		СтрокаСоединенияИнформационнойБазы = Лев(СтрокаСоединенияИнформационнойБазы, СтрДлина(СтрокаСоединенияИнформационнойБазы) - 1);
	КонецЕсли;
	
	ИмяИсполняемогоФайлаПрограммы = КаталогПрограммы() + СтруктураПараметров.ИмяФайлаПрограммы;
	
	// Определение пути к информационной базе.
	ПризнакФайловогоРежима = Неопределено;
	ПутьКИнформационнойБазе = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 0);
	
	ПараметрПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, "/F", "/S") + ПутьКИнформационнойБазе; 
	СтрокаПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима, ПутьКИнформационнойБазе, "");
	
	Результат = СтрЗаменить(Результат, "[ИмяИсполняемогоФайлаПрограммы]"     , ПодготовитьТекст(ИмяИсполняемогоФайлаПрограммы));
	Результат = СтрЗаменить(Результат, "[ПараметрПутиКИнформационнойБазе]"   , ПодготовитьТекст(ПараметрПутиКИнформационнойБазе));
	Результат = СтрЗаменить(Результат, "[СтрокаПутиКФайлуИнформационнойБазы]", ПодготовитьТекст(ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(СтрЗаменить(СтрокаПутиКИнформационнойБазе, """", ""))));
	Результат = СтрЗаменить(Результат, "[СтрокаСоединенияИнформационнойБазы]", ПодготовитьТекст(СтрокаСоединенияИнформационнойБазы));
	Результат = СтрЗаменить(Результат, "[ИмяАдминистратораОбновления]"       , ПодготовитьТекст(ИмяПользователя()));
	Результат = СтрЗаменить(Результат, "[СобытиеЖурналаРегистрации]"         , ПодготовитьТекст(СтруктураПараметров.СобытиеЖурналаРегистрации));
	Результат = СтрЗаменить(Результат, "[ФайлРезервнойКопии]"                , ПодготовитьТекст(Объект.ФайлЗагрузкиРезервнойКопии));
	Результат = СтрЗаменить(Результат, "[ИмяCOMСоединителя]"                 , ПодготовитьТекст(СтруктураПараметров.ИмяCOMСоединителя));
	Результат = СтрЗаменить(Результат, "[ИспользоватьCOMСоединитель]"        , ?(СтруктураПараметров.ЭтоБазоваяВерсияКонфигурации, "false", "true"));
	// Используется КаталогВременныхФайлов, т.к. автоматическое удаление временного каталога не допустимо.
	Результат = СтрЗаменить(Результат, "[КаталогВременныхФайлов]"            , ПодготовитьТекст(КаталогВременныхФайлов()));
	Результат = СтрЗаменить(Результат, "[ПараметрыЗапускаПредприятия]"       , ПодготовитьТекст(СтруктураПараметров.ПараметрыЗапускаПредприятия));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПодготовитьТекст(Знач Текст)
	
	Строка = СтрЗаменить(Текст, "\", "\\");
	Строка = СтрЗаменить(Строка, "'", "\'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("'%1'", Строка);
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыРезервногоКопирования()
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
	ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ?(ТребуетсяВводПароля, ПарольАдминистратораИБ, ""));
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоСеансовИнформационнойБазы()
	
	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь, Ложь);
	
КонецФункции

#КонецОбласти
