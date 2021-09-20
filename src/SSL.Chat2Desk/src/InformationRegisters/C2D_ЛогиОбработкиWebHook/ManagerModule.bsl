Процедура ЗаписатьСобытиеВЛог(Соответствие, ТипЗапрос = Неопределено, успех=ложь)  экспорт
	Хэш = новый ХешированиеДанных(ХешФункция.SHA256);
	Хэш.Добавить(ЗначениеВСтрокуВнутр(Соответствие));
	СоответствиеХэш = Хэш.ХешСумма;

	
	Запись = РегистрыСведений.C2D_ЛогиОбработкиWebHook.СоздатьМенеджерЗаписи();
	Запись.ХэшПакета = СоответствиеХэш;
	запись.ТипХука = ТипЗапрос;
	Запись.Прочитать();
	Запись.ХэшПакета = СоответствиеХэш;
	запись.ТипХука = ТипЗапрос;
	Если успех Тогда
		 запись.КоличествоУспешныхОбработок = запись.КоличествоУспешныхОбработок+1;
	 Иначе
		 Запись.КоличествоНеудачныхОбработок = запись.КоличествоНеудачныхОбработок+1;
	 КонецЕсли; 
	 Запись.Записать();
КонецПроцедуры
