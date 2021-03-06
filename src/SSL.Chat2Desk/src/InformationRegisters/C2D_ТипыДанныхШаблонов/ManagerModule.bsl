Процедура ПерезаписатьИспользуемыеТипы (ОписаниеТипов) Экспорт
	Запись = РегистрыСведений.C2D_ТипыДанныхШаблонов.СоздатьМенеджерЗаписи();	
	Запись.Идентификатор = "Идентификатор";
	Запись.Типы = Новый ХранилищеЗначения(ОписаниеТипов);
	Запись.Записать();
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Функция ПолучитьТипыДанных() Экспорт
	Типы = новый ОписаниеТипов;
	выборка = РегистрыСведений.C2D_ТипыДанныхШаблонов.Выбрать();
	Если выборка.следующий() Тогда
		Типы = выборка.типы.получить();
	КонецЕсли;
	Возврат Типы;
КонецФункции

Функция ОтрисовыватьКнопку(ИмяФормы) Экспорт
	МетаданныеФормы = Метаданные.НайтиПоПолномуИмени(ИмяФормы);
	ОбъектМетаданных = МетаданныеФормы.Родитель();
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	Вид  = ВРег(СтрРазделить(ПолноеИмя, ".")[0]);
	Если Вид = "ЖУРНАЛДОКУМЕНТОВ" или Вид = "ОБРАБОТКА" Тогда
		Возврат ложь;
	КонецЕсли; 
	Возврат ПолучитьТипыДанных().содержитТип(Тип(Вид + "Ссылка." + ОбъектМетаданных.Имя));	
КонецФункции
