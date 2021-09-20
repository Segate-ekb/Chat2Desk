
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Оповестить("C2D_ОбновитьСписокЧатов");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.Клиент.ОграничениеТипа = РегистрыСведений.C2D_ТипыКлиентов.ПолучитьТипыДанных();
	Клиент = РегистрыСведений.C2D_Клиенты.НайтиСсылкуПоID(Запись.ID);
КонецПроцедуры

&НаСервере
Процедура КлиентПриИзмененииНаСервере()
	Запись.Клиент = Клиент.уникальныйИдентификатор();
	Запись.ПолноеИмяТипаДанных = клиент.метаданные().ПолноеИмя();
	Запись.Представление = РегистрыСведений.C2D_Клиенты.СформироватьПредставление(запись);
КонецПроцедуры

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	КлиентПриИзмененииНаСервере();
КонецПроцедуры



