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
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Заполнение списка календарей.
	ЗакрыватьПриВыборе = Ложь;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Выбрать",		"Видимость",	Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаПоиск",	"Отображение",	ОтображениеГруппыКнопок.Компактное);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Найти",			"Отображение",	ОтображениеКнопки.Картинка);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтменитьПоиск", "Отображение",	ОтображениеКнопки.Картинка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДлительнаяОперация = ЗагрузитьСписокПоддерживаемыхПроизводственныхКалендарей();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьСписокКалендарейЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВалют

&НаКлиенте
Процедура СписокКалендарейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыборВСпискеКалендарей(СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВыполнить()
	
	ОбработатьВыборВСпискеКалендарей();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗагрузитьСписокПоддерживаемыхПроизводственныхКалендарей()
	
	ПараметрыПроцедуры = Новый Структура;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение списка поддерживаемых календарей'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Справочники.ПроизводственныеКалендари.ЗаполнитьПроизводственныеКалендариПоУмолчаниюДлительнаяОперация", 
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСписокКалендарейЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокКалендарей(Результат.АдресРезультата);
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСписокКалендарей(АдресТаблицы)
	
	ТаблицаКалендарей = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Для Каждого СтрокаТаблицы Из ТаблицаКалендарей Цикл
		НоваяСтрока = Календари.Добавить();
		НоваяСтрока.Код = СтрокаТаблицы.Code;
		НоваяСтрока.Наименование = СтрокаТаблицы.Description;
		НоваяСтрока.БазовыйКалендарь = СтрокаТаблицы.Base;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборВСпискеКалендарей(СтандартнаяОбработка = Неопределено)
	
	// Добавление элемента справочника и вывод результата пользователю.
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСсылка = СохранитьВыбранныеСтроки(Элементы.СписокКалендарей.ВыделенныеСтроки);
	
	ОповеститьОВыборе(ТекущаяСсылка);
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Календари добавлены.'"), , , БиблиотекаКартинок.Информация32);
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция СохранитьВыбранныеСтроки(Знач ВыбранныеСтроки)
	
	ТекущаяСсылка = Неопределено;
	
	КодыДобавленныхКалендарей = Новый Массив;
	Для каждого НомерСтроки Из ВыбранныеСтроки Цикл
		ТекущиеДанные = Календари[НомерСтроки];
		
		СтрокаВБазе = Справочники.ПроизводственныеКалендари.НайтиПоКоду(ТекущиеДанные.Код);
		Если ЗначениеЗаполнено(СтрокаВБазе) Тогда
			Если НомерСтроки = Элементы.СписокКалендарей.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
				ТекущаяСсылка = СтрокаВБазе;
			КонецЕсли;
			КодыДобавленныхКалендарей.Добавить(ТекущиеДанные.Код);
			Продолжить;
		КонецЕсли;
		
		// Проверяем, есть ли базовый календарь.
		БазовыйКалендарь = Неопределено;
		Если ЗначениеЗаполнено(ТекущиеДанные.БазовыйКалендарь) Тогда
			БазовыйКалендарь = БазовыйКалендарь(ТекущиеДанные.БазовыйКалендарь);
		КонецЕсли;
	
		КалендарьСсылка = СоздатьКалендарь(ТекущиеДанные.Код, ТекущиеДанные.Наименование, БазовыйКалендарь);
		КодыДобавленныхКалендарей.Добавить(ТекущиеДанные.Код);
		
		Если НомерСтроки = Элементы.СписокКалендарей.ТекущаяСтрока Или ТекущаяСсылка = Неопределено Тогда
			ТекущаяСсылка = КалендарьСсылка;
		КонецЕсли;
	КонецЦикла;
	
	ЗагрузитьДанныеПроизводственныхКалендарей(КодыДобавленныхКалендарей);
	
	Возврат ТекущаяСсылка;

КонецФункции

&НаСервере
Функция БазовыйКалендарь(КодБазовогоКалендаря)
	
	БазовыйКалендарьСсылка = Справочники.ПроизводственныеКалендари.НайтиПоКоду(КодБазовогоКалендаря);
	Если ЗначениеЗаполнено(БазовыйКалендарьСсылка) Тогда
		Возврат БазовыйКалендарьСсылка;
	КонецЕсли;

	ОтборСтрок = Новый Структура("Код");
	ОтборСтрок.Код = КодБазовогоКалендаря;
	НайденныеСтроки = Календари.НайтиСтроки(ОтборСтрок);
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Календарь с кодом %1, указанный в качестве базового, отсутствует в списке поставляемых.'"),
			КодБазовогоКалендаря);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Возврат СоздатьКалендарь(НайденныеСтроки[0].Код, НайденныеСтроки[0].Наименование);
	
КонецФункции

&НаСервере
Функция СоздатьКалендарь(Код, Наименование, БазовыйКалендарь = Неопределено)
	
	НовыйЭлемент = Справочники.ПроизводственныеКалендари.СоздатьЭлемент();
	НовыйЭлемент.Код = Код;
	НовыйЭлемент.Наименование = Наименование;
	НовыйЭлемент.БазовыйКалендарь = БазовыйКалендарь;
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент.Ссылка;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьДанныеПроизводственныхКалендарей(КодыКалендарей)
	
	ТаблицаДанных = Справочники.ПроизводственныеКалендари.РезультатЗаполненияПроизводственныхКалендарейПоУмолчанию(КодыКалендарей);
	Справочники.ПроизводственныеКалендари.ОбновитьДанныеПроизводственныхКалендарей(ТаблицаДанных);
	
КонецПроцедуры

#КонецОбласти
