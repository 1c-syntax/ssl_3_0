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
	
	Если Параметры.ЭтоНоваяГруппа Тогда
		
		ОбъектЗначение = Справочники[Параметры.ИмяСправочникаХранилищаФайлов].СоздатьГруппу();
		Если Параметры.Свойство("Родитель")
			И Параметры.Родитель <> Неопределено
			И ТипЗнч(Параметры.Родитель) = ТипЗнч(ОбъектЗначение.Ссылка) Тогда
			
			Если Параметры.Родитель.ЭтоГруппа Тогда
				ОбъектЗначение.Родитель = Параметры.Родитель;
			ИначеЕсли Параметры.Родитель.Родитель <> Неопределено
				И ТипЗнч(Параметры.Родитель.Родитель) = ТипЗнч(ОбъектЗначение.Ссылка) Тогда
				
				ОбъектЗначение.Родитель = Параметры.Родитель.Родитель; // В качестве первого родителя была передана ссылка на элемент.
			КонецЕсли;
			
		Иначе
			ОбъектЗначение.Родитель = Неопределено;
		КонецЕсли;
		
		ОбъектЗначение.ВладелецФайла = Параметры.ВладелецФайла;
		ОбъектЗначение.ДатаСоздания  = ТекущаяУниверсальнаяДата();
		ОбъектЗначение.Автор         = Пользователи.АвторизованныйПользователь();
		ОбъектЗначение.Изменил       = ОбъектЗначение.Автор;
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		КопируемыйОбъект    = Параметры.ЗначениеКопирования.ПолучитьОбъект();
		
		ОбъектЗначение          = Справочники[КопируемыйОбъект.Метаданные().Имя].СоздатьГруппу();
		ОбъектЗначение.Родитель = Параметры.Родитель;
		ЗаполнитьЗначенияСвойств(ОбъектЗначение, КопируемыйОбъект,
			"ВладелецФайла, ДатаСоздания, Описание, Наименование, ДатаМодификацииУниверсальная, Изменил");
		ОбъектЗначение.Автор = Пользователи.АвторизованныйПользователь();
	Иначе
		Если ЗначениеЗаполнено(Параметры.ПрисоединенныйФайл) Тогда
			ОбъектЗначение = Параметры.ПрисоединенныйФайл.ПолучитьОбъект();
		Иначе
			ОбъектЗначение = Параметры.Ключ.ПолучитьОбъект();
		КонецЕсли;
	КонецЕсли;
	ОбъектЗначение.Заполнить(Неопределено);
	
	ИмяСправочника = ОбъектЗначение.Метаданные().Имя;
	
	НастроитьОбъектФормы(ОбъектЗначение);
	
	Если ТолькоПросмотр
		ИЛИ НЕ ПравоДоступа("Изменение", ЭтотОбъект.Объект.ВладелецФайла.Метаданные()) Тогда
		Элементы.ФормаСтандартнаяЗаписать.Доступность                  = Ложь;
		Элементы.ФормаСтандартнаяЗаписатьИЗакрыть.Доступность          = Ложь;
		Элементы.ФормаСтандартнаяУстановитьПометкуУдаления.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ ТолькоПросмотр
		И НЕ ЭтотОбъект.Объект.Ссылка.Пустая() Тогда
		ЗаблокироватьДанныеДляРедактирования(ЭтотОбъект.Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
	ОбновитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		ОповещениеОбОтвете = Новый ОписаниеОповещения("ЗакрытьФормуПослеОтветаНаВопрос", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеОбОтвете, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтандартнаяЗаписать(Команда)
	ОбработатьКомандуЗаписиФайла();
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяЗаписатьИЗакрыть(Команда)
	
	Если ОбработатьКомандуЗаписиФайла() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяПеречитать(Команда)
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Модифицированность Тогда
		ПеречитатьДанныеССервера();
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Данные изменены. Перечитать данные?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтандартнаяПеречитатьОтветПолучен", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяСкопировать(Команда)
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначениеКопирования", ЭтотОбъект.Объект.Ссылка);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ГруппаФайлов", ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура СтандартнаяПоказатьВСписке(Команда)
	
	СтандартныеПодсистемыКлиент.ПоказатьВСписке(ЭтотОбъект["Объект"].Ссылка, Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьОбъектФормы(Знач НовыйОбъект)
	
	ТипНовогоОбъекта = Новый Массив;
	ТипНовогоОбъекта.Добавить(ТипЗнч(НовыйОбъект));
	
	НовыйРеквизит = Новый РеквизитФормы("Объект", Новый ОписаниеТипов(ТипНовогоОбъекта));
	НовыйРеквизит.СохраняемыеДанные = Истина;
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ЗначениеВРеквизитФормы(НовыйОбъект, "Объект");
	
	Для каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы")
			И СтрНачинаетсяС(Элемент.ПутьКДанным, "ОбъектПрототип[0].")
			И СтрЗаканчиваетсяНа(Элемент.Имя, "0") Тогда
			
			ИмяЭлемента = Лев(Элемент.Имя, СтрДлина(Элемент.Имя) -1);
			Если Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйЭлемент = Элементы.Вставить(ИмяЭлемента, ТипЗнч(Элемент), Элемент.Родитель, Элемент);
			НовыйЭлемент.ПутьКДанным = "Объект." + Сред(Элемент.ПутьКДанным, СтрДлина("ОбъектПрототип[0].") + 1);
			
			Если Элемент.Вид = ВидПоляФормы.ПолеНадписи Тогда
				ИсключаемыеСвойства = "Имя, ПутьКДанным";
			Иначе
				ИсключаемыеСвойства = "Имя, ПутьКДанным, ВыделенныйТекст, СвязьПоТипу";
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент, , ИсключаемыеСвойства);
			
			Элемент.Видимость = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(
		Строка(ЭтотОбъект["Объект"].Автор),
		,
		,
		,
		ПолучитьНавигационнуюСсылку(ЭтотОбъект["Объект"].Автор)));
	
	СтатусСоздана = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
	ОбновитьИнформациюОбИзменении();
	
	Если Параметры.Свойство("Родитель") Тогда
		НовыйОбъект.Родитель = Параметры.Родитель;
	КонецЕсли;
	
	Если Не НовыйОбъект.ЭтоНовый() Тогда
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(НовыйОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовок()
	
	Если ЗначениеЗаполнено(ЭтотОбъект.Объект.Ссылка) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (Группа файлов)'"), Строка(ЭтотОбъект.Объект.Ссылка));
	Иначе
		Заголовок = НСтр("ru = 'Группа файлов (Создание)'")
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбработатьКомандуЗаписиФайла()
	
	ОчиститьСообщения();
	
	Если ПустаяСтрока(ЭтотОбъект.Объект.Наименование) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Для продолжения укажите имя файла.'"), , "Наименование", "Объект");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		РаботаСФайламиСлужебныйКлиент.КорректноеИмяФайла(ЭтотОбъект.Объект.Наименование);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,"Наименование", "Объект");
		Возврат Ложь;
	КонецПопытки;
	
	Если НЕ ЗаписатьФайл() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ОтобразитьИзменениеДанных(ЭтотОбъект.Объект.Ссылка, ВидИзмененияДанных.Изменение);
	ОповеститьОбИзменении(ЭтотОбъект.Объект.Ссылка);
	
	Оповестить("Запись_Файл",
				Новый Структура("ЭтоНовый", ФайлБылСоздан),
				ЭтотОбъект.Объект.Ссылка);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Функция ЭтоНовый()
	
	Возврат ЭтотОбъект.Объект.Ссылка.Пустая();
	
КонецФункции

&НаСервере
Функция ЗаписатьФайл(Знач ПараметрОбъект = Неопределено)
	
	Если ПараметрОбъект = Неопределено Тогда
		ЗаписываемыйОбъект = РеквизитФормыВЗначение("Объект");
	Иначе
		ЗаписываемыйОбъект = ПараметрОбъект;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		ЗаписываемыйОбъект.Изменил                      = Пользователи.АвторизованныйПользователь();
		ЗаписываемыйОбъект.ДатаМодификацииУниверсальная = ТекущаяУниверсальнаяДата();
		ЗаписываемыйОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка записи группы присоединенных файлов'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()) );
		ВызватьИсключение;
		
	КонецПопытки;
	
	Если ПараметрОбъект = Неопределено Тогда
		ЗначениеВРеквизитФормы(ЗаписываемыйОбъект, "Объект");
	КонецЕсли;
	
	ОбновитьЗаголовок();
	ОбновитьИнформациюОбИзменении();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура СтандартнаяПеречитатьОтветПолучен(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПеречитатьДанныеССервера();
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеречитатьДанныеССервера()
	
	ФайлОбъект = ЭтотОбъект.Объект.Ссылка.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ФайлОбъект, "Объект");
	
	ОбновитьИнформациюОбИзменении();

КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюОбИзменении()
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока(
		Строка(ЭтотОбъект["Объект"].Изменил),
		,
		,
		,
		ПолучитьНавигационнуюСсылку(ЭтотОбъект["Объект"].Изменил)));
	
	СтатусИзменена = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПослеОтветаНаВопрос(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да
		И ОбработатьКомандуЗаписиФайла() Тогда
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти