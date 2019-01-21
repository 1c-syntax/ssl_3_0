﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий = Неопределено, Разделитель = ".") Экспорт
    
    УстановитьПривилегированныйРежим(Истина);
	
	ПериодИдентификатораУдаления = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга("ПериодАгрегацииМалый");

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		Если МодульРаботаВМоделиСервиса.ИспользованиеРазделителяСеанса() Тогда
			ОбластьДанных = Формат(МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧН=0; ЧГ=0");
		Иначе
			ОбластьДанных = Формат(0, "ЧН=0; ЧГ=0");
		КонецЕсли;
	Иначе
		ОбластьДанных = Формат(0, "ЧН=0; ЧГ=0");
	КонецЕсли;
	
	ТекДата = ТекущаяУниверсальнаяДатаВМиллисекундах();
		
	Если Разделитель <> "." Тогда
		ИмяОперации = СтрЗаменить(ИмяОперации, ".", "☼");
		ИмяОперации = СтрЗаменить(ИмяОперации, Разделитель, ".");
	КонецЕсли;
	
	ОперацияСсылка = ЦентрМониторингаПовтИсп.ПолучитьСсылкуОперацииСтатистики(ИмяОперации);
	КомментарийСсылка = РегистрыСведений.КомментарииСтатистики.ПолучитьСсылку(Комментарий, ОперацияСсылка);
	ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанных);
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДатаЗаписи = ТекДата;
	МенеджерЗаписи.ИдентификаторУдаления = Цел(Цел(ТекДата/1000)/ПериодИдентификатораУдаления)*ПериодИдентификатораУдаления;
	МенеджерЗаписи.ИдентификаторЗаписи = Новый УникальныйИдентификатор();
	МенеджерЗаписи.ОперацияСтатистики = ОперацияСсылка;
	МенеджерЗаписи.КомментарийСтатистики = КомментарийСсылка;
	МенеджерЗаписи.ОбластьСтатистики = ОбластьДанныхСсылка;
	МенеджерЗаписи.Значение = Значение;
	
	МенеджерЗаписи.Записать(Ложь);
    
КонецПроцедуры

Процедура ЗаписатьОперацииБизнесСтатистики(Операции) Экспорт
    
    УстановитьПривилегированныйРежим(Истина);
    
    ПериодИдентификатораУдаления = ЦентрМониторингаСлужебный.ПолучитьПараметрыЦентраМониторинга("ПериодАгрегацииМалый");
    
    ТекДата = ТекущаяУниверсальнаяДатаВМиллисекундах();
    ИдентификаторУдаления = Цел(Цел(ТекДата/1000)/ПериодИдентификатораУдаления)*ПериодИдентификатораУдаления; 
    КомментарийСсылка = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку("0");
    
    НаборЗаписей = СоздатьНаборЗаписей();
    МаксимальноеКоличествоЗаписей = 1000;
    
    Для Каждого Операция Из Операции Цикл
        
        НовЗапись = НаборЗаписей.Добавить();
        НовЗапись.ДатаЗаписи = ТекДата;
        НовЗапись.ИдентификаторУдаления = ИдентификаторУдаления;
        НовЗапись.ИдентификаторЗаписи = Новый УникальныйИдентификатор();
        НовЗапись.ОперацияСтатистики = ЦентрМониторингаПовтИсп.ПолучитьСсылкуОперацииСтатистики(Операция.ОперацияСтатистики);
        НовЗапись.КомментарийСтатистики = КомментарийСсылка;
        НовЗапись.ОбластьСтатистики = ОбластьДанныхСсылка;
        НовЗапись.Значение = Операция.Значение;
        
        Если НаборЗаписей.Количество() >= МаксимальноеКоличествоЗаписей Тогда
            НаборЗаписей.Записать(Ложь);
            НаборЗаписей.Очистить();
        КонецЕсли;
                
    КонецЦикла;
    
    Если НаборЗаписей.Количество() > 0 Тогда
        НаборЗаписей.Записать(Ложь);
        НаборЗаписей.Очистить();
    КонецЕсли;
            
КонецПроцедуры

Функция ПолучитьАгрегированныеЗаписиОпераций(ДатаЗаписи, ПериодАгрегации, ПериодУдаления) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	) КАК Период,
	|	БуферОперацийСтатистики.ОперацияСтатистики КАК ОперацияСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	) КАК ИдентификаторУдаления,
	|   СУММА(1) КАК КоличествоЗначений, 
	|	СУММА(БуферОперацийСтатистики.Значение) КАК СуммаЗначений,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	) КАК ПериодОкончание
	|ИЗ
	|	РегистрСведений.БуферОперацийСтатистики КАК БуферОперацийСтатистики
	|ГДЕ
	|	БуферОперацийСтатистики.ДатаЗаписи < &ДатаЗаписи
	|СГРУППИРОВАТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	),
	|	БуферОперацийСтатистики.ОперацияСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	),
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	)
	|УПОРЯДОЧИТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	)
	|";
	
	Запрос.УстановитьПараметр("ДатаЗаписи", (ДатаЗаписи - Дата(1, 1, 1)) * 1000);
	Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации * 1000);
	Запрос.УстановитьПараметр("ПериодУдаления", ПериодУдаления * 1000);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;	
КонецФункции

Функция ПолучитьАгрегированныеЗаписиКомментарий(ДатаЗаписи, ПериодАгрегации, ПериодУдаления) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	) КАК Период,
	|	БуферОперацийСтатистики.ОперацияСтатистики КАК ОперацияСтатистики,
	|	БуферОперацийСтатистики.КомментарийСтатистики КАК КомментарийСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	) КАК ИдентификаторУдаления,
	|   СУММА(1) КАК КоличествоЗначений,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	) КАК ПериодОкончание
	|ИЗ
	|	РегистрСведений.БуферОперацийСтатистики КАК БуферОперацийСтатистики
	|ГДЕ
	|	БуферОперацийСтатистики.ДатаЗаписи < &ДатаЗаписи
	|СГРУППИРОВАТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	),
	|	БуферОперацийСтатистики.ОперацияСтатистики,
	|	БуферОперацийСтатистики.КомментарийСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	),
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	)
	|УПОРЯДОЧИТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	)
	|";
	
	Запрос.УстановитьПараметр("ДатаЗаписи", (ДатаЗаписи - Дата(1, 1, 1)) * 1000);
	Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации * 1000);
	Запрос.УстановитьПараметр("ПериодУдаления", ПериодУдаления * 1000);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;	
КонецФункции

Функция ПолучитьАгрегированныеЗаписиОбластиСтатистики(ДатаЗаписи, ПериодАгрегации, ПериодУдаления) Экспорт
	ПериодУдаления = 3600;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	) КАК Период,
	|	БуферОперацийСтатистики.ОперацияСтатистики КАК ОперацияСтатистики,
	|	БуферОперацийСтатистики.ОбластьСтатистики КАК ОбластьСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	) КАК ИдентификаторУдаления,
	|   СУММА(1) КАК КоличествоЗначений,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	) КАК ПериодОкончание
	|ИЗ
	|	РегистрСведений.БуферОперацийСтатистики КАК БуферОперацийСтатистики
	|ГДЕ
	|	БуферОперацийСтатистики.ДатаЗаписи < &ДатаЗаписи
	|СГРУППИРОВАТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	),
	|	БуферОперацийСтатистики.ОперацияСтатистики,
	|	БуферОперацийСтатистики.ОбластьСтатистики,
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодУдаления - 0.5 КАК ЧИСЛО(15,0)) * &ПериодУдаления)/1000  - 63555667200
	|	),
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200 + &ПериодАгрегации/1000 - 1
	|	)
	|УПОРЯДОЧИТЬ ПО
	|	ДОБАВИТЬКДАТЕ(
	|		ДАТАВРЕМЯ(2015,1,1),
	|		СЕКУНДА,
	|		(ВЫРАЗИТЬ(БуферОперацийСтатистики.ДатаЗаписи/&ПериодАгрегации - 0.5 КАК ЧИСЛО(15,0)) * &ПериодАгрегации)/1000  - 63555667200
	|	)
	|";
	
	Запрос.УстановитьПараметр("ДатаЗаписи", (ДатаЗаписи - Дата(1, 1, 1)) * 1000);
	Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации * 1000);
	Запрос.УстановитьПараметр("ПериодУдаления", ПериодУдаления * 1000);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;	
КонецФункции

Процедура УдалитьЗаписи(ДатаЗаписи) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	БуферОперацийСтатистики.ИдентификаторУдаления КАК ИдентификаторУдаления
	|ИЗ
	|	РегистрСведений.БуферОперацийСтатистики КАК БуферОперацийСтатистики
	|ГДЕ
	|	БуферОперацийСтатистики.ДатаЗаписи < &ДатаЗаписи
	|УПОРЯДОЧИТЬ ПО
	|	БуферОперацийСтатистики.ИдентификаторУдаления
	|";
	
	Запрос.УстановитьПараметр("ДатаЗаписи", (ДатаЗаписи - Дата(1, 1, 1)) * 1000);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей.Отбор.ИдентификаторУдаления.Установить(Выборка.ИдентификаторУдаления);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли