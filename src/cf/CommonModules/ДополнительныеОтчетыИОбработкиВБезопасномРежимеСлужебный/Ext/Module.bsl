﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает шаблон имени профиля безопасности для внешнего модуля.
// Функция должна возвращать одно и то же значение при многократном вызове.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка, ссылка на внешний модуль.
//
// Возвращаемое значение - Строка - шаблон имя профиля безопасности, содержащий символы
//  "%1", вместо которых в дальнейшем будет подставлен уникальный идентификатор.
//
Функция ШаблонИмениПрофиляБезопасности(Знач ВнешнийМодуль) Экспорт
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийМодуль, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		Возврат "AdditionalReport_%1"; // Не локализуется
		
	Иначе
		
		Возврат "AdditionalDataProcessor_%1"; // Не локализуется
		
	КонецЕсли;
	
КонецФункции

// Возвращает пиктограмму, отображающую внешний модуль.
//
//  ВнешнийМодуль - ЛюбаяСсылка, ссылка на внешний модуль,
//
// Возвращаемое значение - Картинка.
//
Функция ПиктограммаВнешнегоМодуля(Знач ВнешнийМодуль) Экспорт
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийМодуль, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		Возврат БиблиотекаКартинок.Отчет;
		
	Иначе
		
		Возврат БиблиотекаКартинок.Обработка;
		
	КонецЕсли;
	
КонецФункции

// Возвращает словарь представлений для внешних модулей контейнера.
//
// Возвращаемое значение - Структура:
//  * Именительный - Строка, представление типа внешнего модуля в именительном падеже,
//  * Родительный - Строка, представление типа внешнего модуля в родительном падеже.
//
Функция СловарьКонтейнераВнешнегоМодуля() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru = 'Дополнительный отчет или обработка'"));
	Результат.Вставить("Родительный", НСтр("ru = 'Дополнительного отчета или обработки'"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив ссылочных объектов метаданных, которые могут использоваться в
//  качестве контейнера внешних модулей.
//
// Возвращаемое значение - Массив(ОбъектМетаданных).
//
Функция КонтейнерыВнешнихМодулей() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки);
	Возврат Результат;
	
КонецФункции

Функция ЗапросыРазрешенийДополнительныхОбработок(Знач ЗначениеФО = Неопределено) Экспорт
	
	Если ЗначениеФО = Неопределено Тогда
		ЗначениеФО = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Результат = Новый Массив();
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
		|ГДЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка.Публикация <> &Публикация";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Публикация", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		НовыеЗапросы = ЗапросыРазрешенийДополнительнойОбработки(Объект, Объект.Разрешения.Выгрузить(), ЗначениеФО);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, НовыеЗапросы);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗапросыРазрешенийДополнительнойОбработки(Знач Объект, Знач РазрешенияВДанных, Знач ЗначениеФО = Неопределено, Знач ПометкаУдаления = Неопределено) Экспорт
	
	ЗапрашиваемыеРазрешения = Новый Массив();
	
	Если ЗначениеФО = Неопределено Тогда
		ЗначениеФО = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Если ПометкаУдаления = Неопределено Тогда
		ПометкаУдаления = Объект.ПометкаУдаления;
	КонецЕсли;
	
	ОчиститьРазрешения = Ложь;
	
	Если Не ЗначениеФО Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	Если Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	МодульРаботаВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежимеСлужебный");
	
	Если Не ОчиститьРазрешения Тогда
		
		БылиРазрешения = МодульРаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Объект.Ссылка) <> Неопределено;
		ЕстьРазрешения = Объект.Разрешения.Количество() > 0;
		
		Если БылиРазрешения Или ЕстьРазрешения Тогда
			
			Если Объект.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2 Тогда
				
				ЗапрашиваемыеРазрешения = Новый Массив();
				Для Каждого РазрешениеВДанных Из РазрешенияВДанных Цикл
					Разрешение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(МодульРаботаВБезопасномРежимеСлужебный.Пакет(), РазрешениеВДанных.ВидРазрешения));
					СвойстваВДанных = РазрешениеВДанных.Параметры.Получить();
					ЗаполнитьЗначенияСвойств(Разрешение, СвойстваВДанных);
					ЗапрашиваемыеРазрешения.Добавить(Разрешение);
				КонецЦикла;
				
			Иначе
				
				СтарыеРазрешения = Новый Массив();
				Для Каждого РазрешениеВДанных Из РазрешенияВДанных Цикл
					Разрешение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/ApplicationExtensions/Permissions/1.0.0.1", РазрешениеВДанных.ВидРазрешения));
					СвойстваВДанных = РазрешениеВДанных.Параметры.Получить();
					ЗаполнитьЗначенияСвойств(Разрешение, СвойстваВДанных);
					СтарыеРазрешения.Добавить(Разрешение);
				КонецЦикла;
				
				ЗапрашиваемыеРазрешения = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ПреобразоватьРазрешенияВерсии_2_1_3_ВРазрешенияВерсии_2_2_2(Объект, СтарыеРазрешения);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат МодульРаботаВБезопасномРежимеСлужебный.ЗапросРазрешенийДляВнешнегоМодуля(Объект.Ссылка, ЗапрашиваемыеРазрешения);
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьКлючСессииРасширенияБезопасногоРежима(Знач Обработка) Экспорт
	
	Возврат Обработка.УникальныйИдентификатор();
	
КонецФункции

// Только для внутреннего использования.
Процедура ВыполнитьСценарийБезопасногоРежима(Знач КлючСессии, Знач Сценарий, Знач ИсполняемыйОбъект, ПараметрыВыполнения, СохраняемыеПараметры = Неопределено, ОбъектыНазначения = Неопределено) Экспорт
	
	Исключения = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.ПолучитьРазрешенныеМетоды();
	
	Если СохраняемыеПараметры = Неопределено Тогда
		СохраняемыеПараметры = Новый Структура();
	КонецЕсли;
	
	Для Каждого ШагСценария Из Сценарий Цикл
		
		ВыполнятьБезопасно = Истина;
		ИсполняемыйФрагмент = "";
		
		Если ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаОбработки() Тогда
			
			ИсполняемыйФрагмент = "ИсполняемыйОбъект." + ШагСценария.ИмяМетода;
			
		ИначеЕсли ШагСценария.ВидДействия = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидДействияВызовМетодаКонфигурации() Тогда
			
			ИсполняемыйФрагмент = ШагСценария.ИмяМетода;
			
			Если Исключения.Найти(ШагСценария.ИмяМетода) <> Неопределено Тогда
				ВыполнятьБезопасно = Ложь;
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный вид действия для этапа сценария: %1'"), ШагСценария.ВидДействия);
			
		КонецЕсли;
		
		НесохраняемыеПараметры = Новый Массив();
		
		ПодстрокаПараметров = "";
		
		ПараметрыМетода = ШагСценария.Параметры;
		Для Каждого ПараметрМетода Из ПараметрыМетода Цикл
			
			Если Не ПустаяСтрока(ПодстрокаПараметров) Тогда
				ПодстрокаПараметров = ПодстрокаПараметров + ", ";
			КонецЕсли;
			
			Если ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраЗначение() Тогда
				
				НесохраняемыеПараметры.Добавить(ПараметрМетода.Значение);
				ПодстрокаПараметров = ПодстрокаПараметров
					+ "НесохраняемыеПараметры.Получить("
					+ НесохраняемыеПараметры.ВГраница()
					+ ")";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКлючСессии() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "КлючСессии";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраКоллекцияСохраняемыхЗначений() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраСохраняемоеЗначение() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "СохраняемыеПараметры." + ПараметрМетода.Значение;
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраОбъектыНазначения() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ОбъектыНазначения";
				
			ИначеЕсли ПараметрМетода.Вид = ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.ВидПараметраПараметрВыполненияКоманды() Тогда
				
				ПодстрокаПараметров = ПодстрокаПараметров + "ПараметрыВыполнения." + ПараметрМетода.Значение;
				
			Иначе
				
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный параметр для этапа сценария: %1'"), ПараметрМетода.Вид);
				
			КонецЕсли;
			
		КонецЦикла;
		
		ИсполняемыйФрагмент = ИсполняемыйФрагмент + "(" + ПодстрокаПараметров + ")";
		
		Если ВыполнятьБезопасно <> (БезопасныйРежим() <> Ложь) Тогда
			УстановитьБезопасныйРежим(ВыполнятьБезопасно);
		КонецЕсли;
		
		Если Не ПустаяСтрока(ШагСценария.СохранениеРезультата) Тогда
			Результат = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ИсполняемыйФрагмент);
			СохраняемыеПараметры.Вставить(ШагСценария.СохранениеРезультата, Результат);
		Иначе
			ОбщегоНазначения.ВыполнитьВБезопасномРежиме(ИсполняемыйФрагмент);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция СформироватьПредставлениеРазрешений(Знач Разрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	Для Каждого Разрешение Из Разрешения Цикл
		
		ВидРазрешения = Разрешение.ВидРазрешения;
		
		ОписаниеРазрешения = ОписанияРазрешений.Получить(
			ФабрикаXDTO.Тип(
				ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
				ВидРазрешения));
		
		ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
		
		ПредставлениеПараметров = "";
		Параметры = Разрешение.Параметры.Получить();
		
		Если Параметры <> Неопределено Тогда
			
			Для Каждого Параметр Из Параметры Цикл
				
				Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
					ПредставлениеПараметров = ПредставлениеПараметров + ", ";
				КонецЕсли;
				
				ПредставлениеПараметров = ПредставлениеПараметров + Строка(Параметр.Значение);
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеПараметров) Тогда
			ПредставлениеРазрешения = ПредставлениеРазрешения + " (" + ПредставлениеПараметров + ")";
		КонецЕсли;
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<LI><FONT size=2>%1 <A href=""%2"">%3</A></FONT>",
			ПредставлениеРазрешения,
			"internal:" + ВидРазрешения,
			НСтр("ru = 'Подробнее...'"));
		
	КонецЦикла;
	
	Результат = Результат + "</LI></BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция СформироватьПодробноеОписаниеРазрешения(Знач ВидРазрешения, Знач ПараметрыРазрешения) Экспорт
	
	ОписанияРазрешений = ДополнительныеОтчетыИОбработкиВБезопасномРежимеПовтИсп.Словарь();
	
	Результат = "<HTML><BODY bgColor=#fcfaeb>";
	
	ОписаниеРазрешения = ОписанияРазрешений.Получить(
		ФабрикаXDTO.Тип(
			ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(),
			ВидРазрешения));
	
	ПредставлениеРазрешения = ОписаниеРазрешения.Представление;
	РасшифровкаРазрешения = ОписаниеРазрешения.Описание;
	
	ОписанияПараметров = Неопределено;
	ЕстьПараметры = ОписаниеРазрешения.Свойство("Параметры", ОписанияПараметров);
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><STRONG><FONT size=4>%1</FONT></STRONG></P>",
		ПредставлениеРазрешения);
	
	Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"<P><FONT size=2>%1%2</FONT></P>", РасшифровкаРазрешения, ?(
			ЕстьПараметры,
			" " + НСтр("ru = 'со следующими ограничениями'") + ":",
			"."));
	
	Если ЕстьПараметры Тогда
		
		Результат = Результат + "<UL>";
		
		Для Каждого Параметр Из ОписанияПараметров Цикл
			
			ИмяПараметра = Параметр.Имя;
			ЗначениеПараметра = ПараметрыРазрешения[ИмяПараметра];
			
			Если ЗначениеЗаполнено(ЗначениеПараметра) Тогда
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Параметр.Описание, ЗначениеПараметра);
				
			Иначе
				
				ОписаниеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("<B>%1</B>", Параметр.ОписаниеЛюбогоЗначения);
				
			КонецЕсли;
			
			Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("<LI><FONT size=2>%1</FONT>", ОписаниеПараметра);
			
		КонецЦикла;
		
		Результат = Результат + "</LI></UL>";
		
	КонецЕсли;
	
	ОписаниеПоследствий = "";
	Если ОписаниеРазрешения.Свойство("Последствия", ОписаниеПоследствий) Тогда
		
		Результат = Результат + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<P><FONT size=2><EM>%1</EM></FONT></P>",
			ОписаниеПоследствий);
		
	КонецЕсли;
	
	Результат = Результат + "<P><FONT size=2><A href=""internal:home"">&lt;&lt; Назад к списку разрешений</A></FONT></P>";
	
	Результат = Результат + "</BODY></HTML>";
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ИнтеграцияПодсистемБСП.ПриРегистрацииМенеджеровВнешнихМодулей.
Процедура ПриРегистрацииМенеджеровВнешнихМодулей(Менеджеры) Экспорт
	
	Менеджеры.Добавить(ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный);
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗапросы = ЗапросыРазрешенийДополнительныхОбработок();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗапросыРазрешений, НовыеЗапросы);
	
КонецПроцедуры

#КонецОбласти
