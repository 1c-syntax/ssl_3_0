﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьКурсыКлиент", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, 
		НСтр("ru = 'Будет произведена загрузка файла с полной информацией по курсами всех валют за все время из менеджера сервиса.
              |Курсы валют, помеченных в областях данных для загрузки из сети Интернет, будут заменены в фоновом задании. Продолжить?'"), 
		РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьКурсыКлиент(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКурсы();
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Загрузка запланирована.'"), ,
		НСтр("ru = 'Курсы будут загружены в фоновом режиме через непродолжительное время.'"),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьКурсы()
	
	КурсыВалютСлужебныйВМоделиСервиса.ЗагрузитьКурсы();
	
КонецПроцедуры

#КонецОбласти
