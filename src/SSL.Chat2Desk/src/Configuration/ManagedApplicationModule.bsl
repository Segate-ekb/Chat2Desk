
&После("ПриНачалеРаботыСистемы")
Процедура C2D_ПриНачалеРаботыСистемы()
	ПодключитьОбработчикОжидания("ОповеститьОператораОНовыхСообщениях", 5, Ложь);
	Если не C2D_ВзаимодействиеСChat2DeskВызовСервера.C2D_НастройкаЗавершена() Тогда
		ОткрытьФорму("Обработка.C2D_ПомошникНастройки.Форма.Форма");
	КонецЕсли; 
КонецПроцедуры
