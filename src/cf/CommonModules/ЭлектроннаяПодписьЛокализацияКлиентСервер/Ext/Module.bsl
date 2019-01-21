﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеСертификата(Сертификат, ДобавкаВремени) Экспорт
	
	ДатыСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.ДатыСертификата(Сертификат, ДобавкаВремени);
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1, до %2'"),
		ПредставлениеСубъекта(Сертификат, Ложь),
		Формат(ДатыСертификата.ДатаОкончания, "ДФ=MM.yyyy"));
	
КонецФункции

Функция ПредставлениеСубъекта(Сертификат, Отчество = Истина) Экспорт
	
	Субъект = ЭлектроннаяПодписьКлиентСервер.СвойстваСубъектаСертификата(Сертификат);
	
	Представление = "";
	
	Если ЗначениеЗаполнено(Субъект.Фамилия)
	   И ЗначениеЗаполнено(Субъект.Имя) Тогда
		
		Представление = Субъект.Фамилия + " " + Субъект.Имя;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.Фамилия) Тогда
		Представление = Субъект.Фамилия;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.Имя) Тогда
		Представление = Субъект.Имя;
	КонецЕсли;
	
	Если Отчество И ЗначениеЗаполнено(Субъект.Отчество) Тогда
		Представление = Представление + " " + Субъект.Отчество;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представление) Тогда
		Если ЗначениеЗаполнено(Субъект.Организация) Тогда
			Представление = Представление + ", " + Субъект.Организация;
		КонецЕсли;
		Если ЗначениеЗаполнено(Субъект.Подразделение) Тогда
			Представление = Представление + ", " + Субъект.Подразделение;
		КонецЕсли;
		Если ЗначениеЗаполнено(Субъект.Должность) Тогда
			Представление = Представление + ", " + Субъект.Должность;
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(Субъект.ОбщееИмя) Тогда
		Представление = Субъект.ОбщееИмя;
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция РасширенныеСвойстваСубъектаСертификата(Субъект) Экспорт
	
	Свойства = Новый Структура;
	Свойства.Вставить("ОГРН");
	Свойства.Вставить("ОГРНИП");
	Свойства.Вставить("СНИЛС");
	Свойства.Вставить("ИНН");
	Свойства.Вставить("Фамилия");
	Свойства.Вставить("Имя");
	Свойства.Вставить("Отчество");
	Свойства.Вставить("Должность");
	
	Если Субъект.Свойство("OGRN")Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Субъект.OGRN);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_1") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Субъект.OID1_2_643_100_1);
	КонецЕсли;
	
	Если Субъект.Свойство("OGRNIP") Тогда
		Свойства.ОГРНИП = ПодготовитьСтроку(Субъект.OGRNIP);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_5") Тогда
		Свойства.ОГРНИП = ПодготовитьСтроку(Субъект.OID1_2_643_100_5);
	КонецЕсли;
	
	Если Субъект.Свойство("SNILS") Тогда
		Свойства.СНИЛС = ПодготовитьСтроку(Субъект.SNILS);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_100_3") Тогда
		Свойства.СНИЛС = ПодготовитьСтроку(Субъект.OID1_2_643_100_3);
	КонецЕсли;
	
	Если Субъект.Свойство("INN") Тогда
		Свойства.ИНН = ПодготовитьСтроку(Субъект.INN);
		
	ИначеЕсли Субъект.Свойство("OID1_2_643_3_131_1_1")Тогда
		Свойства.ИНН = ПодготовитьСтроку(Субъект.OID1_2_643_3_131_1_1);
	КонецЕсли;
	
	Если Субъект.Свойство("SN") Тогда // Наличие фамилии (обычно для должностного лица).
		
		// Извлечение ФИО из поля SN и GN.
		Свойства.Фамилия = ПодготовитьСтроку(Субъект.SN);
		
		Если Субъект.Свойство("GN") Тогда
			GivenName = ПодготовитьСтроку(Субъект.GN);
			Позиция = СтрНайти(GivenName, " ");
			Если Позиция = 0 Тогда
				Свойства.Имя = GivenName;
			Иначе
				Свойства.Имя = Лев(GivenName, Позиция - 1);
				Свойства.Отчество = ПодготовитьСтроку(Сред(GivenName, Позиция + 1));
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли Субъект.Свойство("OGRNIP")            // Признак индивидуального предпринимателя.
	      Или Субъект.Свойство("OID1_2_643_100_5")  // Признак индивидуального предпринимателя.
	      Или Субъект.Свойство("T")                 // Признак должностного лица.
	      Или Субъект.Свойство("OID2_5_4_12")       // Признак должностного лица.
	      Или Субъект.Свойство("SNILS")                                     // Признак физического лица.
	      Или Субъект.Свойство("OID1_2_643_100_3")                          // Признак физического лица.
	      Или ЭтоИННФизЛица(Субъект.Свойство("INN"))                        // Признак физического лица.
	      Или ЭтоИННФизЛица(Субъект.Свойство("OID1_2_643_3_131_1_1")) Тогда // Признак физического лица.
		
		Если Свойства.ОбщееИмя <> Свойства.Организация
		   И Не (Субъект.Свойство("T")           И Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.T))
		   И Не (Субъект.Свойство("OID2_5_4_12") И Свойства.ОбщееИмя = ПодготовитьСтроку(Субъект.OID2_5_4_12)) Тогда
			
			// Извлечение ФИО из поля CN.
			Массив = СтрРазделить(Свойства.ОбщееИмя, " ", Ложь);
			
			Если Массив.Количество() < 4 Тогда
				Если Массив.Количество() > 0 Тогда
					Свойства.Фамилия = СокрЛП(Массив[0]);
				КонецЕсли;
				Если Массив.Количество() > 1 Тогда
					Свойства.Имя = СокрЛП(Массив[1]);
				КонецЕсли;
				Если Массив.Количество() > 2 Тогда
					Свойства.Отчество = СокрЛП(Массив[2]);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Свойства.Фамилия) Или ЗначениеЗаполнено(Свойства.Имя) Тогда
		Если Субъект.Свойство("T") Тогда
			Свойства.Должность = ПодготовитьСтроку(Субъект.T);
			
		ИначеЕсли Субъект.Свойство("OID2_5_4_12") Тогда
			Свойства.Должность = ПодготовитьСтроку(Субъект.OID2_5_4_12);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

Функция ПредставленияСвойствСубъектаСертификата() Экспорт
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["Должность"] = НСтр("ru = 'Должность'");
	ПредставленияСвойств["ОГРН"] = НСтр("ru = 'ОГРН'");
	ПредставленияСвойств["ОГРНИП"] = НСтр("ru = 'ОГРНИП'");
	ПредставленияСвойств["СНИЛС"] = НСтр("ru = 'СНИЛС'");
	ПредставленияСвойств["ИНН"] = НСтр("ru = 'ИНН'");
	ПредставленияСвойств["Фамилия"] = НСтр("ru = 'Фамилия'");
	ПредставленияСвойств["Имя"] = НСтр("ru = 'Имя'");
	ПредставленияСвойств["Отчество"] = НСтр("ru = 'Отчество'");
	Возврат ПредставленияСвойств;
	
КонецФункции

Функция РасширенныеСвойстваИздателяСертификата(Издатель) Экспорт
	
	Свойства = Новый Структура;
	Свойства.Вставить("ОГРН");
	Свойства.Вставить("ИНН");
	
	Если Издатель.Свойство("OGRN") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Издатель.OGRN);
		
	ИначеЕсли Издатель.Свойство("OID1_2_643_100_1") Тогда
		Свойства.ОГРН = ПодготовитьСтроку(Издатель.OID1_2_643_100_1);
	КонецЕсли;
	
	Если Издатель.Свойство("INN") Тогда
		Свойства.ИНН = ПодготовитьСтроку(Издатель.INN);
		
	ИначеЕсли Издатель.Свойство("OID1_2_643_3_131_1_1")Тогда
		Свойства.ИНН = ПодготовитьСтроку(Издатель.OID1_2_643_3_131_1_1);
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

Функция ПредставленияСвойствИздателяСертификата() Экспорт
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОГРН"] = НСтр("ru = 'ОГРН'");
	ПредставленияСвойств["ИНН"] = НСтр("ru = 'ИНН'");
	Возврат ПредставленияСвойств;
	
КонецФункции

Функция ПодготовитьСтроку(СтрокаИзСертификата)
	Возврат СокрЛП(ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(СтрокаИзСертификата));
КонецФункции

Функция ЭтоИННФизЛица(ИНН)
	
	Если СтрДлина(ИНН) <> 12 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для НомерСимвола = 1 По 12 Цикл
		Если СтрНайти("0123456789", Сред(ИНН,НомерСимвола,1)) = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрНачинаетсяС(ИНН, "00") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
