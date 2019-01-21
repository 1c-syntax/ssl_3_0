﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.ДобавитьЗадание().
//
// Параметры:
//   Наименование - Строка - Наименование регламентного задания.
//
// Возвращаемое значение:
//   Неопределено - Следует использовать РегламентныеЗаданияСервер.ДобавитьЗадание().
//
Функция СоздатьНовоеЗадание(Знач Наименование) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.УникальныйИдентификатор().
//
// Параметры:
//   Задание - РегламентноеЗадание - Регламентное задание.
//
// Возвращаемое значение:
//   Неопределено - Следует использовать РегламентныеЗаданияСервер.УникальныйИдентификатор().
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.ИзменитьЗадание().
//
// Параметры:
//   Задание - РегламентноеЗадание - Регламентное задание.
//   Использование - Булево - Флаг использования регламентного задания.
//   Наименование - Строка - Наименование регламентного задания.
//   Параметры - Массив - Параметры регламентного задания.
//   Расписание - РасписаниеРегламентногоЗадания - Расписание регламентного задания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, Наименование, Параметры, Расписание) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устарела. Следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
// Параметры:
//   Задание - РегламентноеЗадание - Регламентное задание.
//
// Возвращаемое значение:
//   Неопределено - Следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.Задание().
//
// Параметры:
//   Идентификатор - УникальныйИдентификатор - Идентификатор регламентного задания.
//
// Возвращаемое значение:
//   Неопределено - Следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.УдалитьЗадание().
//
// Параметры:
//   Задание - РегламентноеЗадание - Регламентное задание.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
