﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем АдресХранилища;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресХранилищаНаСервере = Параметры.АдресХранилища;
	РезультатОбработкиЗапросов = ПолучитьИзВременногоХранилища(АдресХранилищаНаСервере);
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") И Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить() Тогда
		Если Параметры.РежимПроверки Тогда
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаТребуетсяОтменитьНеактуальныеРазрешенияВКластере;
		ИначеЕсли Параметры.РежимВосстановления Тогда
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаПриВосстановленииБудутУстановленыСледующиеНастройкиВКластере;
		Иначе
			Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаТребуетсяВнестиИзмененияВКластере;
		КонецЕсли;
	Иначе
		Элементы.СтраницыШапка.ТекущаяСтраница = Элементы.СтраницаШапкаПриВключенииБудутУстановленыСледующиеНастройкиВКластере;
	КонецЕсли;
	
	СценарийПримененияЗапросов = РезультатОбработкиЗапросов.Сценарий;
	
	Если СценарийПримененияЗапросов.Количество() = 0 Тогда
		ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Ложь;
		Возврат;
	КонецЕсли;
	
	ПредставлениеРазрешений = РезультатОбработкиЗапросов.Представление;
	
	ТребуетсяВнесениеИзмененийВПрофиляхБезопасности = Истина;
	ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Ложь;
	Для Каждого ШагСценария Из СценарийПримененияЗапросов Цикл
		Если ШагСценария.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.Назначение
				Или ШагСценария.Операция = Перечисления.ОперацииАдминистрированияПрофилейБезопасности.УдалениеНазначения Тогда
			ТребуютсяПараметрыАдминистрированияИнформационнойБазы = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
		Если ПользовательИБ <> Неопределено Тогда
			ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	ТипПодключения = ПараметрыАдминистрирования.ТипПодключения;
	ПортКластераСерверов = ПараметрыАдминистрирования.ПортКластера;
	
	АдресАгентаСервера = ПараметрыАдминистрирования.АдресАгентаСервера;
	ПортАгентаСервера = ПараметрыАдминистрирования.ПортАгентаСервера;
	
	АдресСервераАдминистрирования = ПараметрыАдминистрирования.АдресСервераАдминистрирования;
	ПортСервераАдминистрирования = ПараметрыАдминистрирования.ПортСервераАдминистрирования;
	
	ИмяВКластере = ПараметрыАдминистрирования.ИмяВКластере;
	ИмяАдминистратораКластера = ПараметрыАдминистрирования.ИмяАдминистратораКластера;
	
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
	Если ПользовательИБ <> Неопределено Тогда
		ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
	КонецЕсли;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторАдминистратораИБ);
	АдминистраторИБ = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ИдентификаторАдминистратораИБ);
	
	Элементы.ГруппаАдминистрирование.Видимость = ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	Элементы.ГруппаПредупреждениеОНеобходимостиПерезапуска.Видимость = ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	
	Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Далее >'");
	Элементы.ФормаНазад.Видимость = Ложь;
	
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если МобильныйКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для корректной работы необходим режим тонкого или толстого клиента.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	#Если ВебКлиент Тогда
		ПоказатьОшибкуОперацияНеПоддерживаетсяВВебКлиенте();
		Возврат;
	#КонецЕсли
	
	Если ТребуетсяВнесениеИзмененийВПрофиляхБезопасности Тогда
		
		АдресХранилища = АдресХранилищаНаСервере;
		
	Иначе
		
		Закрыть(КодВозвратаДиалога.Пропустить);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТребуютсяПараметрыАдминистрированияИнформационнойБазы Тогда
		
		Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		
		ИмяПоля = "АдминистраторИБ";
		ПользовательИБ = ПолучитьАдминистратораИБ();
		Если ПользовательИБ = Неопределено Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Указанный пользователь не имеет доступа к информационной базе.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'У пользователя нет административных прав.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения Тогда
		
		ТекстОшибки = "";
		Элементы.ГруппаОшибка.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Настроить разрешения в кластере серверов'");
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение;
		Элементы.ФормаНазад.Видимость = Истина;
		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		
		ТекстОшибки = "";
		Попытка
			
			ПрименитьРазрешения();
			ЗавершитьПрименениеЗапросов(АдресХранилища);
			ОжидатьПримененияНастроекВКластере();
			
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке()); 
			Элементы.ГруппаОшибка.Видимость = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПодключение Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРазрешения;
		Элементы.ФормаНазад.Видимость = Ложь;
		Элементы.ФормаРазрешить.Заголовок = НСтр("ru = 'Далее >'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеререгистрироватьCOMСоединитель(Команда)
	
	ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостью()
	
	Если ТипПодключения = "COM" Тогда
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруCOM;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Истина;
	Иначе
		Элементы.СтраницыПараметрыПодключенияККластеруПоПротоколам.ТекущаяСтраница = Элементы.СтраницаПараметрыПодключенияККластеруRAS;
		ВидимостьГруппыОшибкиВерсииCOMСоединителя = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаОшибкаВерсииCOMСоединителя.Видимость = ВидимостьГруппыОшибкиВерсииCOMСоединителя;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОшибкуОперацияНеПоддерживаетсяВВебКлиенте()
	
	Элементы.СтраницыГлобальный.ТекущаяСтраница = Элементы.СтраницаОперацияНеПоддерживаетсяВВебКлиенте;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдминистратораИБ()
	
	Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
		АдминистраторИБ.ИдентификаторПользователяИБ);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяПользователяИнформационнойБазы(Знач Пользователь)
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		ИдентификаторПользователяИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователяИБ);
		Возврат ПользовательИБ.Имя;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПрименитьРазрешения()
	
	ПрименитьРазрешенияНаСервере(АдресХранилища);
	
КонецПроцедуры

&НаСервере
Функция НачатьПрименениеЗапросов(Знач АдресХранилища)
	
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	СценарийПримененияЗапросов = Результат.Сценарий;
	
	ВидыОпераций = Новый Структура();
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ОперацииАдминистрированияПрофилейБезопасности.ЗначенияПеречисления Цикл
		ВидыОпераций.Вставить(ЗначениеПеречисления.Имя, Перечисления.ОперацииАдминистрированияПрофилейБезопасности[ЗначениеПеречисления.Имя]);
	КонецЦикла;
	
	Возврат Новый Структура("ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы",
		ВидыОпераций, СценарийПримененияЗапросов, ТребуютсяПараметрыАдминистрированияИнформационнойБазы);
	
КонецФункции

&НаСервере
Процедура ЗавершитьПрименениеЗапросов(Знач АдресХранилища)
	
	Обработки.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.ЗафиксироватьПрименениеЗапросов(ПолучитьИзВременногоХранилища(АдресХранилища).Состояние);
	СохранитьПараметрыАдминистрирования();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыАдминистрирования()
	
	СохраняемыеПараметрыАдминистрирования = Новый Структура();
	
	// Параметры администрирования кластера.
	СохраняемыеПараметрыАдминистрирования.Вставить("ТипПодключения", ТипПодключения);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресАгентаСервера", АдресАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортАгентаСервера", ПортАгентаСервера);
	СохраняемыеПараметрыАдминистрирования.Вставить("АдресСервераАдминистрирования", АдресСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортСервераАдминистрирования", ПортСервераАдминистрирования);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПортКластера", ПортКластераСерверов);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораКластера", ИмяАдминистратораКластера);
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораКластера", "");
	
	// Параметры администрирования информационной базы.
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяВКластере", ИмяВКластере);
	СохраняемыеПараметрыАдминистрирования.Вставить("ИмяАдминистратораИнформационнойБазы", ИмяПользователяИнформационнойБазы(АдминистраторИБ));
	СохраняемыеПараметрыАдминистрирования.Вставить("ПарольАдминистратораИнформационнойБазы", "");
	
	СтандартныеПодсистемыСервер.УстановитьПараметрыАдминистрирования(СохраняемыеПараметрыАдминистрирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьПримененияНастроекВКластере()
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаСервере
Процедура ПрименитьРазрешенияНаСервере(АдресХранилища)
	
	ПараметрыПрименения = НачатьПрименениеЗапросов(АдресХранилища);
	
	ВидыОпераций = ПараметрыПрименения.ВидыОпераций;
	Сценарий = ПараметрыПрименения.СценарийПримененияЗапросов;
	ТребуютсяПараметрыАдминистрированияИБ = ПараметрыПрименения.ТребуютсяПараметрыАдминистрированияИнформационнойБазы;
	
	ПараметрыАдминистрированияКластера = АдминистрированиеКластера.ПараметрыАдминистрированияКластера();
	ПараметрыАдминистрированияКластера.ТипПодключения = ТипПодключения;
	ПараметрыАдминистрированияКластера.АдресАгентаСервера = АдресАгентаСервера;
	ПараметрыАдминистрированияКластера.ПортАгентаСервера = ПортАгентаСервера;
	ПараметрыАдминистрированияКластера.АдресСервераАдминистрирования = АдресСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортСервераАдминистрирования = ПортСервераАдминистрирования;
	ПараметрыАдминистрированияКластера.ПортКластера = ПортКластераСерверов;
	ПараметрыАдминистрированияКластера.ИмяАдминистратораКластера = ИмяАдминистратораКластера;
	ПараметрыАдминистрированияКластера.ПарольАдминистратораКластера = ПарольАдминистратораКластера;
	
	Если ТребуютсяПараметрыАдминистрированияИБ Тогда
		ПараметрыАдминистрированияИБ = АдминистрированиеКластера.ПараметрыАдминистрированияИнформационнойБазыКластера();
		ПараметрыАдминистрированияИБ.ИмяВКластере = ИмяВКластере;
		ПараметрыАдминистрированияИБ.ИмяАдминистратораИнформационнойБазы = ИмяПользователяИнформационнойБазы(АдминистраторИБ);
		ПараметрыАдминистрированияИБ.ПарольАдминистратораИнформационнойБазы = ПарольАдминистратораИБ;
	Иначе
		ПараметрыАдминистрированияИБ = Неопределено;
	КонецЕсли;
	
	ПрименитьИзмененияРазрешенийВПрофиляхБезопасностиВКластереСерверов(
		ВидыОпераций, Сценарий, ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИБ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Применение запросов разрешений на использование внешних ресурсов.
//

// Применяет изменения разрешений в профилях безопасности в кластере серверов по сценарию.
//
// Параметры:
//  ВидыОпераций - Структура, описывающая значения перечисления ОперацииАдминистрированияПрофилейБезопасности:
//                   * Ключ - Строка - имя значения перечисления,
//                   * Значение - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности,
//  СценарийПримененияРазрешений - Массив(Структура) - сценарий применения изменений разрешений на
//    использование профилей безопасности в кластере серверов. Значениями массива являются структуры
//    со следующими полями:
//                   * Операция - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности - операция, которую
//                      требуется выполнить,
//                   * Профиль - Строка, имя профиля безопасности,
//                   * Разрешения - Структура - описание свойств профиля безопасности, см.
//                      АдминистрированиеКластера.СвойстваПрофиляБезопасности(),
//  ПараметрыАдминистрированияКластера - Структура - параметры администрирования кластера серверов, см.
//    АдминистрированиеКластера.ПараметрыАдминистрированияКластера(),
//  ПараметрыАдминистрированияИнформационнойБазы - Структура - параметры администрирования информационной
//    базы, см. АдминистрированиеКластера.ПараметрыАдминистрированияИнформационнойБазыКластера().
//
&НаСервереБезКонтекста
Процедура ПрименитьИзмененияРазрешенийВПрофиляхБезопасностиВКластереСерверов(Знач ВидыОпераций, Знач СценарийПримененияРазрешений, Знач ПараметрыАдминистрированияКластера, Знач ПараметрыАдминистрированияИнформационнойБазы = Неопределено)
	
	ТребуютсяПараметрыАдминистрированияИБ = (ПараметрыАдминистрированияИнформационнойБазы <> Неопределено);
	
	АдминистрированиеКластера.ПроверитьПараметрыАдминистрирования(
		ПараметрыАдминистрированияКластера,
		ПараметрыАдминистрированияИнформационнойБазы,
		Истина,
		ТребуютсяПараметрыАдминистрированияИБ);
	
	Для Каждого ЭлементСценария Из СценарийПримененияРазрешений Цикл
		
		Если ЭлементСценария.Операция = ВидыОпераций.Создание Тогда
			
			Если АдминистрированиеКластера.ПрофильБезопасностиСуществует(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль) Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Профиль безопасности %1 уже присутствует в кластере серверов. Настройки в профиле безопасности будут замещены...'"), ЭлементСценария.Профиль));
				
				АдминистрированиеКластера.УстановитьСвойстваПрофиляБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
				
			Иначе
				
				АдминистрированиеКластера.СоздатьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
				
			КонецЕсли;
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Назначение Тогда
			
			АдминистрированиеКластера.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИнформационнойБазы, ЭлементСценария.Профиль);
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Обновление Тогда
			
			АдминистрированиеКластера.УстановитьСвойстваПрофиляБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Удаление Тогда
			
			Если АдминистрированиеКластера.ПрофильБезопасностиСуществует(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль) Тогда
				
				АдминистрированиеКластера.УдалитьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль);
				
			Иначе
				
				ОбщегоНазначения.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Профиль безопасности %1 отсутствует в кластере серверов. Возможно, профиль безопасности был удален ранее...'"), ЭлементСценария.Профиль));
				
			КонецЕсли;
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.УдалениеНазначения Тогда
			
			АдминистрированиеКластера.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИнформационнойБазы, "");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти