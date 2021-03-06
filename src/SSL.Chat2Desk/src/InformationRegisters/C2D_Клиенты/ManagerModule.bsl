#Область ПрограммныйИнтерфейс
Функция НайтиСсылкуПоID(id) экспорт
	УстановитьПривилегированныйРежим(Истина);
	Клиент = неопределено;
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	C2D_Клиенты.Клиент КАК Клиент,
	               |	C2D_Клиенты.ПолноеИмяТипаДанных КАК ПолноеИмяТипаДанных
	               |ИЗ
	               |	РегистрСведений.C2D_Клиенты КАК C2D_Клиенты
	               |ГДЕ
	               |	C2D_Клиенты.ID = &ID";
	Запрос.УстановитьПараметр("ID", id);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Клиент = НайтиСсылкуПоGUID(Выборка.Клиент, Выборка.ПолноеИмяТипаДанных);
	КонецЕсли; 
	Возврат Клиент;
КонецФункции

Функция НайтиIDПоСсылке(Ссылка, транспорт= неопределено) Экспорт
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	C2D_Клиенты.ID КАК ID
	               |ИЗ
	               |	РегистрСведений.C2D_Клиенты КАК C2D_Клиенты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.C2D_ТранспортыКлиентов КАК C2D_ТранспортыКлиентов
	               |		ПО C2D_Клиенты.ID = C2D_ТранспортыКлиентов.client_id
	               |ГДЕ
	               |	C2D_Клиенты.Клиент = &Ссылка
	               |    %1
	               |СГРУППИРОВАТЬ ПО
	               |	C2D_Клиенты.ID";
	Запрос.УстановитьПараметр("Ссылка", Ссылка.УникальныйИдентификатор());

	Запрос.Текст = СтрШаблон(запрос.Текст, ?(не транспорт = Неопределено, " И C2D_ТранспортыКлиентов.transport = &transport",""));
	Запрос.УстановитьПараметр("transport", транспорт);

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ID");
КонецФункции

Процедура ОбновитьСписокКлиентовВФоне(ДополнительныеПараметры, адресВременногоХранилища) Экспорт
	ОбновитьСписокКлиентов();		
КонецПроцедуры

//Полное обновление - это либо первоначальное заполнение, либо внеплановое действие. так что оно не должно быть часто.
Процедура ОбновитьСписокКлиентов() Экспорт
	Офсет = 0;
	Лимит = 100;
	Тотал = 999;  //Первый прогон цикла
	Пока офсет+лимит < Тотал цикл
		СтруктураПараметров = Новый структура("offset, limit", Офсет, лимит);	
		ОтветАпи = C2D_ВзаимодействиеСApi.GET_clients(СтруктураПараметров);
		Для каждого ДанныеКлиента Из ОтветАпи.Получить("data") Цикл
			ОбновитьДанныеКлиентаПоСоответствию(ДанныеКлиента);			
		КонецЦикла;
		
		//Если не вошло в пачку, то запросим следующую порцию 
		Тотал = ОтветАпи.получить("meta").получить("total");
		Офсет = Офсет+Лимит;
	КонецЦикла;	
	
КонецПроцедуры

Процедура СоздатьИлиОбновитьДанныеОКлиенте(Соответствие) Экспорт 
		ОбновитьДанныеКлиентаПоСоответствию(Соответствие);
КонецПроцедуры

Функция СоздатьКлиента(Клиент, Транспорт, Канал) экспорт
	МассивID = НайтиIDПоСсылке(Клиент, Транспорт); 
	Если МассивID.Количество()>0 Тогда
		Возврат МассивID;
	КонецЕсли;
	ПисатьПервым = C2D_ВзаимодействиеСApi.api_info().получить("data").Получить("write_first_option");
	Если не ПисатьПервым Тогда
		Сообщение = Новый СообщениеПользователю;  			
	    Сообщение.Текст = "Опция ""Писать первым"" не активна";
		Сообщение.Сообщить();
		Возврат неопределено;
	КонецЕсли; 
	Телефон = ПолучитьТелефонКлиента(Клиент);
	Если телефон = неопределено Тогда
		Возврат неопределено;
	КонецЕсли; 
	
	СтруктураПараметров = новый структура("phone, transport, channel_id", телефон, Транспорт, канал);
	СоответствиеОтвет = C2D_ВзаимодействиеСApi.POST_clients(СтруктураПараметров);
	
	Если СоответствиеОтвет.Получить("status") = "success" Тогда
		ОбновитьДанныеКлиентаПоСоответствию(СоответствиеОтвет.получить("data"), Клиент);
		Возврат НайтиIDПоСсылке(Клиент);
	ИначеЕсли СоответствиеОтвет.Получить("status") = "error" тогда
		Сообщение = Новый СообщениеПользователю;  			
	    Сообщение.Текст = C2D_ВзаимодействиеСApiСлужебный.СформироватьТекстОшибки(СоответствиеОтвет);
		Сообщение.Сообщить();
		Возврат неопределено;
	КонецЕсли;

КонецФункции

Процедура  ВернутьПолучателейДляПредмета(Предмет, Получатели, Транспорт=Неопределено) экспорт
	Реквизит = неопределено;
	Если РегистрыСведений.C2D_ТипыКлиентов.ПолучитьТипыДанных().СодержитТип(ТипЗнч(предмет)) Тогда
		Реквизит = Предмет; 
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Контрагент", Предмет.Метаданные()) Тогда
		Реквизит = Предмет.Контрагент;
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Клиент", Предмет.Метаданные()) Тогда
		Реквизит = Предмет.Клиент;
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("Контакт", Предмет.Метаданные()) Тогда
		Реквизит = Предмет.Контакт;
	КонецЕсли; 
	Если не реквизит = Неопределено Тогда
		Для каждого Id Из СоздатьКлиента(Реквизит, Транспорт) Цикл
			Получатель = Получатели.Добавить();
			Получатель.Представление = Строка(реквизит);
			Получатель.Контакт = реквизит;
			Получатель.Id = id;
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Функция СформироватьПредставление(Запись) Экспорт
	Представление = "";
	Если Не ЗначениеЗаполнено(запись.Клиент) Тогда
		//формируем по данным клиента Chat2desk
		Имя = ?(ЗначениеЗаполнено(Запись.assigned_name),Запись.assigned_name, Запись.name);
		Представление = имя+" tel:("+?(ЗначениеЗаполнено(Запись.client_phone), Запись.client_phone, Запись.phone)+")";
	Иначе
		ПредставлениеОМ = Метаданные.НайтиПоПолномуИмени(запись.ПолноеИмяТипаДанных).ПредставлениеОбъекта;
		Представление = ПредставлениеОМ+": "+НайтиСсылкуПоGUID(Запись.Клиент, Запись.ПолноеИмяТипаДанных);  
	КонецЕсли; 
	Возврат Представление;	
КонецФункции

Функция НайтиСсылкуПоGUID(GUID, ПолноеИмя="") экспорт
	Если ЗначениеЗаполнено(ПолноеИмя) Тогда
		 Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		 Возврат Менеджер.получитьСсылку(GUID);	 
	 КонецЕсли;
	 
	 МассивТипов = РегистрыСведений.C2D_ТипыКлиентов.ПолучитьТипыДанных().типы();
	 Для каждого тип Из МассивТипов Цикл
		 ПустаяСсылка = Новый(тип);
		 Ссылка = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ПустаяСсылка).ПолучитьСсылку(GUID);
		 Если ЗначениеЗаполнено(Ссылка) и Ссылка.ПолучитьОбъект() <> Неопределено Тогда
				Возврат(Ссылка);
		 КонецЕсли; 
	 КонецЦикла;
	 Возврат неопределено;
КонецФункции

Процедура выполнитьПоискКлиентовПоКИВБазе() экспорт
	Если не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не используется стандартная подсистма хранения контактной информации, операция не может быть выполнена.";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	ТекстЗапроса = СформироватьТекстЗапросаККИ();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось найти упоминание о контактной информации ни в одном из выбранных типов ассоциации с клиентом.";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли; 
	запрос = новый запрос;
	Запрос.Текст = ТекстЗапроса;	               
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
			Запись = РегистрыСведений.C2D_Клиенты.СоздатьМенеджерЗаписи();
			Запись.ID = Выборка.ID;
			запись.Прочитать();
			запись.Клиент = Выборка.Ссылка.УникальныйИдентификатор();
			Запись.ПолноеИмяТипаДанных =  Выборка.Ссылка.Метаданные().полноеИмя();
			Запись.Представление = РегистрыСведений.C2D_Клиенты.СформироватьПредставление(Запись);
			запись.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ОбновитьДанныеКлиентаПоСоответствию(Соответствие, Ссылка = неопределено)
 	Запись = РегистрыСведений.C2D_Клиенты.СоздатьМенеджерЗаписи();
	Запись.ID = Соответствие.Получить("id");
	//Не затираем данные о сопоставленных клиентах.
	Запись.Прочитать();
	Запись.ID = Соответствие.Получить("id");
	Запись.name = Соответствие.получить("name");
	Запись.assigned_name = Соответствие.получить("assigned_name");
	Запись.email = Соответствие.получить("email");
	Запись.phone = Соответствие.получить("phone");
	Запись.avatar = Соответствие.получить("avatar");
	Запись.client_phone = Соответствие.получить("client_phone");
	Если не Ссылка = неопределено Тогда
		Запись.Клиент = Ссылка.уникальныйИдентификатор();
		Запись.ПолноеИмяТипаДанных = ссылка.метаданные().ПолноеИмя();
	КонецЕсли;
	Запись.Представление = РегистрыСведений.C2D_Клиенты.СформироватьПредставление(Запись);
	Запись.Записать();
КонецПроцедуры


Функция ПолучитьТелефонКлиента(Клиент)
	ИмяТаблицы = Клиент.метаданные().ПолноеИмя();
	
	Запрос = новый запрос;
	Запрос.Текст =  "ВЫБРАТЬ первые 1
	                |	КонтактнаяИнформация.НомерТелефона КАК НомерТелефона
	                |ИЗ
	                |	"+ИмяТаблицы+".КонтактнаяИнформация КАК КонтактнаяИнформация
	                |ГДЕ
	                |	КонтактнаяИнформация.Ссылка = &Ссылка
	                |	И КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.телефон)";
	Запрос.УстановитьПараметр("Ссылка",клиент);
	Выборка = запрос.Выполнить().Выбрать();
	Если выборка.Следующий() Тогда
		 Возврат выборка.НомерТелефона;
	 Иначе
		 Возврат неопределено;
	КонецЕсли; 
	 
КонецФункции

Функция СформироватьТекстЗапросаККИ()
	ТекстЗапроса = "";
	ШаблонЗапрос = "ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Ссылка,
	|	C2D_Клиенты.ID
	|ИЗ
	|	РегистрСведений.C2D_Клиенты КАК C2D_Клиенты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ %1.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|		ПО C2D_Клиенты.phone = КонтрагентыКонтактнаяИнформация.НомерТелефона";
	ЧастьОбъединить="
	|
	|ОБЪЕДИНИТЬ
	|";
	ТипыДанных = РегистрыСведений.C2D_ТипыКлиентов.ПолучитьТипыДанных();
	Если ЗначениеЗаполнено(ТипыДанных) Тогда
		ЭтоПервый = Истина;
		Для каждого Тип Из ТипыДанных.типы() Цикл
			Ссылка = Новый(Тип);
			ОбъектМетаданных = Ссылка.Метаданные();
			Если не ОбъектМетаданных.ТабличныеЧасти.Найти("КонтактнаяИнформация") = неопределено Тогда
				 ТекстЗапроса = ТекстЗапроса + ?(ЭтоПервый, "", ЧастьОбъединить) + СтрШаблон(ШаблонЗапрос, ОбъектМетаданных.полноеИмя());
				 ЭтоПервый = Ложь;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	
	
	Возврат ТекстЗапроса;
КонецФункции

#КонецОбласти


