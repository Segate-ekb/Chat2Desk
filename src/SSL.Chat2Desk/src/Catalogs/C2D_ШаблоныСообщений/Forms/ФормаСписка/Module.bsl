///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ИнициализироватьОтборы();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		ВключенаОтправкаSMS = Истина;
		ВключенаРаботаСПочтовымиСообщениями = Истина;
	Иначе
		ВключенаРаботаСПочтовымиСообщениями = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями");
		ВключенаОтправкаSMS = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS");
	КонецЕсли;
	
	// кнопки в группе, если одна кнопка, то группа не нужна
	//Элементы.ФормаСоздатьШаблонСообщенияSMS.Видимость = ВключенаОтправкаSMS;
	//Элементы.ФормаСоздатьШаблонЭлектронногоПисьма.Видимость = ВключенаРаботаСПочтовымиСообщениями;
	
	Элементы.ФормаПоказыватьКонтекстныеШаблоны.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_C2D_ШаблоныСообщений" Тогда
		ИнициализироватьОтборы();
		УстановитьФильтрНазначение(Назначение);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначениеФильтрПриИзменении(Элемент)
	УстановитьФильтрНазначение(Назначение);
КонецПроцедуры

&НаКлиенте
Процедура ШаблонДляФильтрОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = "SMS" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ШаблонДля", НСтр("ru = 'Сообщения SMS'"), ВидСравненияКомпоновкиДанных.Равно);
	ИначеЕсли ВыбранноеЗначение = "Email" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "ШаблонДля", НСтр("ru = 'Электронного письма'"), ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "ШаблонДля");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	C2D_ШаблоныСообщенийПечатныеФормыИВложения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.C2D_ШаблоныСообщений.ПечатныеФормыИВложения КАК C2D_ШаблоныСообщенийПечатныеФормыИВложения
		|ГДЕ
		|	C2D_ШаблоныСообщенийПечатныеФормыИВложения.Ссылка В(&C2D_ШаблоныСообщений)
		|
		|СГРУППИРОВАТЬ ПО
		|	C2D_ШаблоныСообщенийПечатныеФормыИВложения.Ссылка";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	C2D_ШаблоныСообщенийПрисоединенныеФайлы.ВладелецФайла КАК Ссылка
		|ИЗ
		|	Справочник.C2D_ШаблоныСообщенийПрисоединенныеФайлы КАК C2D_ШаблоныСообщенийПрисоединенныеФайлы
		|ГДЕ
		|	C2D_ШаблоныСообщенийПрисоединенныеФайлы.ВладелецФайла В(&C2D_ШаблоныСообщений)
		|
		|СГРУППИРОВАТЬ ПО
		|	C2D_ШаблоныСообщенийПрисоединенныеФайлы.ВладелецФайла";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("C2D_ШаблоныСообщений", Строки.ПолучитьКлючи());
	
	ШаблоныСВложениями = Запрос.Выполнить().Выгрузить();
	ШаблоныСВложениями.Свернуть("Ссылка");
	Для каждого ШаблонСообщений Из ШаблоныСВложениями Цикл
		СтрокаСписка = Строки[ШаблонСообщений.Ссылка];
		СтрокаСписка.Данные["ЕстьФайлы"] = 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьШаблонЭлектронногоПисьма(Команда)
	СоздатьШаблон("ЭлектронноеПисьмо");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонСообщенияSMS(Команда)
	СоздатьШаблон("СообщениеSMS");
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьКонтекстныеШаблоны(Команда)
	Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка = Не Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка;
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьКонтекстныеШаблоны", Элементы.ФормаПоказыватьКонтекстныеШаблоны.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьШаблонChat2Desk(Команда)
	СоздатьШаблон("Chat2Desk");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьШаблон(ТипСообщения)
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидСообщения",           ТипСообщения);
	ПараметрыФормы.Вставить("ПолноеИмяТипаОснования", Назначение);
	ПараметрыФормы.Вставить("МожноМенятьНазначение",  Истина);
	ОткрытьФорму("Справочник.C2D_ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФильтрНазначение(Знач ВыбранноеЗначение)
	
	Если ПустаяСтрока(ВыбранноеЗначение) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Назначение");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Назначение", ВыбранноеЗначение, ВидСравненияКомпоновкиДанных.Равно);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьОтборы()
	
	Элементы.НазначениеФильтр.СписокВыбора.Очистить();
	//Элементы.ШаблонДляФильтр.СписокВыбора.Очистить();
	
	Список.Параметры.УстановитьЗначениеПараметра("Назначение", "");
	
	ВидыШаблонов = C2D_ШаблоныСообщенийСлужебный.ВидыШаблонов();
	//ВидыШаблонов.Вставить(0, НСтр("ru = 'Электронных писем и SMS'"), НСтр("ru = 'Электронных писем и SMS'"));
	
	//Список.Параметры.УстановитьЗначениеПараметра("СообщениеSMS", ВидыШаблонов.НайтиПоЗначению("SMS").Представление);
	//Список.Параметры.УстановитьЗначениеПараметра("ЭлектроннаяПочта", ВидыШаблонов.НайтиПоЗначению("Email").Представление);
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьКонтекстныеШаблоны", Ложь);
	//
	Для каждого ВидШаблона Из ВидыШаблонов Цикл
		Элементы.ШаблонДляФильтр.СписокВыбора.Добавить(ВидШаблона.Значение, ВидШаблона.Представление);
	КонецЦикла;
	
	Элементы.НазначениеФильтр.СписокВыбора.Добавить("", НСтр("ru = 'Все'"));
	
	Список.Параметры.УстановитьЗначениеПараметра(C2D_ШаблоныСообщенийКлиентСервер.ИдентификаторОбщий(),
		C2D_ШаблоныСообщенийКлиентСервер.ИдентификаторОбщий());
	Элементы.НазначениеФильтр.СписокВыбора.Добавить(C2D_ШаблоныСообщенийКлиентСервер.ИдентификаторОбщий(), 
		C2D_ШаблоныСообщенийКлиентСервер.ОбщийПредставление());
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	C2D_ШаблоныСообщений.Назначение КАК Назначение,
		|	C2D_ШаблоныСообщений.ПолноеИмяТипаПараметраВводаНаОсновании КАК ПолноеИмяТипаПараметраВводаНаОсновании
		|ИЗ
		|	Справочник.C2D_ШаблоныСообщений КАК C2D_ШаблоныСообщений
		|ГДЕ
		|	C2D_ШаблоныСообщений.Назначение <> """" И C2D_ШаблоныСообщений.Назначение <> ""Служебный""
		|	И C2D_ШаблоныСообщений.Назначение <> &Общий
		|
		|СГРУППИРОВАТЬ ПО
		|	C2D_ШаблоныСообщений.Назначение, C2D_ШаблоныСообщений.ПолноеИмяТипаПараметраВводаНаОсновании
		|
		|УПОРЯДОЧИТЬ ПО
		|	Назначение";
	
	Запрос.УстановитьПараметр("Общий", C2D_ШаблоныСообщенийКлиентСервер.ИдентификаторОбщий());
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	ПриОпределенииНастроек =  C2D_ШаблоныСообщенийСлужебныйПовтИсп.ПриОпределенииНастроек();
	ПредметыШаблонов = ПриОпределенииНастроек.ПредметыШаблонов;
	Пока РезультатЗапроса.Следующий() Цикл
		НайденнаяСтрока = ПредметыШаблонов.Найти(РезультатЗапроса.ПолноеИмяТипаПараметраВводаНаОсновании, "Имя");
		Представление = ?( НайденнаяСтрока <> Неопределено, НайденнаяСтрока.Представление, РезультатЗапроса.Назначение);
		
		Элементы.НазначениеФильтр.СписокВыбора.Добавить(РезультатЗапроса.ПолноеИмяТипаПараметраВводаНаОсновании, Представление);
	КонецЦикла;
	
	Назначение = "";
	ШаблонДля = НСтр("ru = 'Электронных писем и SMS'");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.ВладелецШаблона");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Назначение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Назначение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = C2D_ШаблоныСообщенийКлиентСервер.ИдентификаторОбщий();
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", C2D_ШаблоныСообщенийКлиентСервер.ОбщийПредставление());
	
	//
	ПриОпределенииНастроек =  C2D_ШаблоныСообщенийСлужебныйПовтИсп.ПриОпределенииНастроек();
	ПредметыШаблонов = ПриОпределенииНастроек.ПредметыШаблонов;
	
	Для каждого ПредметШаблона Из ПредметыШаблонов Цикл
	
		Элемент = Список.УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Назначение.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Назначение");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ПредметШаблона.Имя;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ПредметШаблона.Представление);
	
	КонецЦикла;
	
КонецПроцедуры


#КонецОбласти
