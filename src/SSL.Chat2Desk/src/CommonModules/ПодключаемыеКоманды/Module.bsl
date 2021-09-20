#Область ЗаменяемыеФункции

&Вместо("ВидыКоманд")
Функция C2D_ВидыКоманд()
	
	Результат = ПродолжитьВызов();
			
		// Добавляем наше подменю
		
		НовыйВидКоманды = Результат.Добавить();
		НовыйВидКоманды.ВидГруппыФормы = ВидГруппыФормы.подменю;
		НовыйВидКоманды.Имя = "Chat2Desk";
		НовыйВидКоманды.ИмяПодменю = НовыйВидКоманды.Имя;
		НовыйВидКоманды.Заголовок = "Chat2Desk";
		НовыйВидКоманды.Картинка = БиблиотекаКартинок.c2d_Chat2Desk;
		НовыйВидКоманды.Отображение = ОтображениеКнопки.КартинкаИТекст;
		НовыйВидКоманды.Порядок = 1000;
	
	Возврат Результат;
	
КонецФункции

&Вместо("КэшФормы")
Функция C2D_КэшФормы(ИмяФормы, ИсточникиЧерезЗапятую, ЭтоФормаОбъекта)
	
	Результат = ПродолжитьВызов(ИмяФормы, ИсточникиЧерезЗапятую, ЭтоФормаОбъекта);
	
	// Добавляем наши команды
	Если РегистрыСведений.C2D_ТипыДанныхШаблонов.ОтрисовыватьКнопку(ИмяФормы) Тогда
		
		Команды = Результат.Команды;
				
		ДобавитьКоманду(Команды, "Chat2Desk", "Послать сообщение",
									"C2D_ИнтеграцияВКонфигурациюКлиент.ОтослатьУведомлениеЧерезChat2Desk", 1);
				
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьКоманду(Команды, ИдентификаторПодменю, Представление, Обработчик, Порядок, ДополнительныеСвойства = Неопределено)
	
	НоваяКоманда = Команды.Добавить();
	НоваяКоманда.Порядок = Порядок;
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Вид = ИдентификаторПодменю;
	НоваяКоманда.МножественныйВыбор = Ложь;
	НоваяКоманда.РежимЗаписи = "Запись";
	НоваяКоманда.ИзменяетВыбранныеОбъекты = Ложь;
	НоваяКоманда.Обработчик = Обработчик;
	НоваяКоманда.Картинка = БиблиотекаКартинок.c2d_Chat2Desk;
	
	Если ДополнительныеСвойства <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НоваяКоманда, ДополнительныеСвойства);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
