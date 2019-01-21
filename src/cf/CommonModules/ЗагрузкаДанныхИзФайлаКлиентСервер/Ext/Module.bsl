﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает структуру описания колонок для макета загрузки данных из файла.
//
// Параметры:
//  Имя        -Строка - имя колонки.
//  Тип       - ОписаниеТипов - тип колонки.
//  Заголовок - Строка - заголовок колонки выводимый в бланке для загрузки.
//  Ширина    - Число - ширина колонки.
//  Подсказка - Строка - подсказка, выводимая в заголовке колонки.
// 
// Возвращаемое значение:
//  Структура - Структура с описание колонки.
//  * Имя                       - Строка - имя колонки.
//  * Тип                       - ОписаниеТипов - тип колонки.
//  * Заголовок                 - Строка - заголовок колонки выводимый в бланке для загрузки.
//  * Ширина -                  - Число - ширина колонки.
//  * Подсказка                 - Строка - подсказка выводимая в заголовке колонки.
//  * ОбязательнаяДляЗаполнения - Булево - истина, если колонка обязательно должна содержать значения.
//  * Группа                    - Строка - имя группы колонок.
//  * Родитель                  - Строка - используется для связи динамической колонки с реквизитом табличной части объекта.
//
Функция ОписаниеКолонкиМакета(Имя, Тип, Заголовок = Неопределено, Ширина = 0, Подсказка = "") Экспорт
	
	КолонкаМакета = Новый Структура("Имя, Тип, Заголовок, Ширина, Позиция, Подсказка, ОбязательнаДляЗаполнения, Группа, Родитель");
	КолонкаМакета.Имя = Имя;
	КолонкаМакета.Тип = Тип;
	КолонкаМакета.Заголовок = ?(ЗначениеЗаполнено(Заголовок), Заголовок, Имя);
	КолонкаМакета.Ширина = ?(Ширина = 0, 30, Ширина);
	КолонкаМакета.Подсказка = Подсказка;
	КолонкаМакета.Родитель = Имя;
	
	Возврат КолонкаМакета;
	
КонецФункции

// Возвращает колонку макета по имени.
//
// Параметры:
//  Имя				 - Строка - Имя колонки.
//  СписокКолонок	 - Массив - Набор колонок макета.
// 
// Возвращаемое значение:
//  Структура - Структура с описание колонки. Состав структуры см. в функции ОписаниеКолонкиМакета.
//              Если колонка не найдена, то Неопределено.
//
Функция КолонкаМакета(Имя, СписокКолонок) Экспорт
	Для каждого Колонка Из  СписокКолонок Цикл
		Если Колонка.Имя = Имя Тогда
			Возврат Колонка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Удаляет колонку макета из массива.
//
// Параметры:
//  Имя				 - Строка - Имя колонки.
//  СписокКолонок	 - Массив - Набор колонок макета.
//
Процедура УдалитьКолонкуМакета(Имя, СписокКолонок) Экспорт
	
	Для Индекс = 0 По СписокКолонок.Количество() -1  Цикл
		Если СписокКолонок[Индекс].Имя = Имя Тогда
			СписокКолонок.Удалить(Индекс);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КолонкиИмеютГруппировку(Знач ИнформацияПоКолонкам) Экспорт
	ГруппыКолонок = Новый Соответствие;
	Для каждого КолонкаТаблицы Из ИнформацияПоКолонкам Цикл
		ГруппыКолонок.Вставить(КолонкаТаблицы.Группа);
	КонецЦикла;
	Возврат ?(ГруппыКолонок.Количество() > 1, Истина, Ложь);
КонецФункции

#КонецОбласти
