////////////////////////////////////////////////////////////////////////////////
// Взаимодействие с api Chat2Desk
// Результатом обращения к api всегда является десериализованный объект json Возвращаемый api. 
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс
// Функция - Clients
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция GET_clients(СтруктураПараметров = неопределено) экспорт
	ИспользоватьКэш = Ложь;
	ТекстЗапроса = "/v1/clients/";
	Если СтруктураПараметров = Неопределено Тогда
		//Тогда просто делаем полный запрос к апи
	ИначеЕсли СтруктураПараметров.Свойство("id") и ЗначениеЗаполнено(СтруктураПараметров.id) Тогда
		//Данные о клиенте меняются редко. Можно использовать кэширование и сократить число запросов к api.
		ИспользоватьКэш = Истина; 
		ТекстЗапроса = ТекстЗапроса+Формат(СтруктураПараметров.id,"ЧГ=0")+"/";
	Иначе
		Если не СтруктураПараметров.свойство("order") Тогда
			СтруктураПараметров.Вставить("order", "desc");
		КонецЕсли; 
		ТекстЗапроса = ТекстЗапроса + СформироватьСтрокуПараметровЗапроса(СтруктураПараметров);
	КонецЕсли;
	
	ВозвращаемоеЗначение =  ПолучитьРезультатЗапроса(ТекстЗапроса, "GET", ИспользоватьКЭШ);
	
	Возврат ВозвращаемоеЗначение;
КонецФункции

// Функция - POST_Clients
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция POST_clients(СтруктураПараметров) экспорт
	ТекстЗапроса = "/v1/clients/";
		ТекстЗапроса = ТекстЗапроса + СформироватьСтрокуПараметровЗапроса(СтруктураПараметров);
	
	ВозвращаемоеЗначение =  ПолучитьРезультатЗапроса(ТекстЗапроса, "POST");
	
	Возврат ВозвращаемоеЗначение;
КонецФункции

// Функция - operators
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция operators(СтруктураПараметров = Неопределено) экспорт
	ТекстЗапроса = "/v1/operators/";
	Если СтруктураПараметров = Неопределено Тогда
		//Тогда просто делаем полный запрос к апи
	Иначе
		ТекстЗапроса = ТекстЗапроса + СформироватьСтрокуПараметровЗапроса(СтруктураПараметров);
	КонецЕсли;

	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "GET");
КонецФункции

// Функция - Dialogs
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция GET_dialogs(СтруктураПараметров = неопределено) экспорт
	ТекстЗапроса = "/v1/dialogs/";
	
	Если СтруктураПараметров = Неопределено Тогда
		СтруктураПараметров = новый структура;
	КонецЕсли;	
	Если СтруктураПараметров.Свойство("ClientID") и ЗначениеЗаполнено(СтруктураПараметров.ClientID) Тогда
		//Тут все плохо, потому что получить диалоги по клиенту можно только если дергать через айди клиента.
		ТекстЗапроса = "/v1/clients/"+Формат(СтруктураПараметров.ClientID,"ЧГ=0")+"/dialogs/";
	Иначе
		Если не СтруктураПараметров.свойство("order") Тогда
			СтруктураПараметров.Вставить("order", "desc");
		КонецЕсли;
		Если не СтруктураПараметров.свойство("limit") Тогда
			СтруктураПараметров.Вставить("limit", 20);
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + СформироватьСтрокуПараметровЗапроса(СтруктураПараметров);
	КонецЕсли;
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "GET");
КонецФункции

// Функция - PUT_dialogs
//
// Параметры:
// ID - число - id диалога
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция PUT_dialogs(id, СтруктураПараметров) экспорт
	ТекстЗапроса = "/v1/dialogs/"+Формат(id,"ЧГ=0");
	ТелоЗапроса = C2D_ВзаимодействиеСApiСлужебный.СериализоватьВJSON(СтруктураПараметров);

	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "PUT", ложь,ТелоЗапроса);
КонецФункции

// Функция - Messages
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция GET_messages(СтруктураПараметров = неопределено) экспорт
	ТекстЗапроса = "/v1/messages/";
	Если СтруктураПараметров = Неопределено Тогда
		//Тогда просто делаем полный запрос к апи
	Иначе
		ТекстЗапроса = ТекстЗапроса + СформироватьСтрокуПараметровЗапроса(СтруктураПараметров);
	КонецЕсли;
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "GET");
КонецФункции

Функция POST_messages(СтруктураПараметров) Экспорт 
	ТекстЗапроса = "/v1/messages/";
	Если СтруктураПараметров = Неопределено Тогда
		ВызватьИсключение "Незаполнены параметры отправляемого сообщения";
	Иначе
		ТелоЗапроса =  C2D_ВзаимодействиеСApiСлужебный.СериализоватьВJSON(СтруктураПараметров);
	КонецЕсли;
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "POST",,ТелоЗапроса);
	
КонецФункции

// Функция - Webhooks
//
// Параметры:
// СтруктураПараметров - Структура - Параметры для формирования запроса к api;
//
// 
// Возвращаемое значение:
// 	СтруктураJson - 
//
Функция webhooks(СтруктураПараметров = неопределено, ТипЗапроса = "GET", ID = "") экспорт
	ТекстЗапроса = "/v1/webhooks/"+ID;
	Если ТипЗапроса = "GET" Тогда
		ТелоЗапроса = СтруктураПараметров;
	Иначе 
		Если СтруктураПараметров = Неопределено Тогда
			ВызватьИсключение "Незаполнены параметры отправляемого сообщения";
		Иначе
			ТелоЗапроса = C2D_ВзаимодействиеСApiСлужебный.СериализоватьВJSON(СтруктураПараметров);
		КонецЕсли;
		Если ТипЗапроса = "PUT" Тогда
			Если не ЗначениеЗаполнено(ID) Тогда
				ВызватьИсключение "Не задан ID обновляемого хука";
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, ТипЗапроса, , ТелоЗапроса);
КонецФункции

Функция api_info() Экспорт
	ТекстЗапроса = "/v1/companies/api_info";
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "GET", Истина);	
КонецФункции

Функция GET_channels() Экспорт
	ТекстЗапроса = "/v1/channels";
	Возврат ПолучитьРезультатЗапроса(ТекстЗапроса, "GET", Истина);	
КонецФункции




// Процедура - Получить результат обращения к api в фоне
//
// Параметры:
//  СтруктураПараметров	 - Структура - ИмяМетода 	- строка 	- Имя метода обращения к api c2d(Обязательный)
//									 - Параметры	- Структура	- Структура параметров для передачи в вызываемый метод. (Не обязательно)
//  АдресХранилища		 - Строка	 - Адрес ВХ куда помещается результат выполнения процедуры.
//
Процедура ПолучитьРезультатОбращенияКApiВФоне(СтруктураПараметров, АдресХранилища) Экспорт
		Если не СтруктураПараметров.Свойство("ИмяМетода") Тогда
			ВызватьИсключение "Не задано имя метода";
		КонецЕсли; 
		ИмяМетода = СтруктураПараметров.ИмяМетода;
		СтруктураПараметровВызываемойФункции = Неопределено;
		СтруктураПараметров.Свойство("Параметры", СтруктураПараметровВызываемойФункции); 
		Результат = Новый структура;
		Выполнить "Результат = "+ИмяМетода+"(СтруктураПараметровВызываемойФункции)";
		ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Возвращает результат запроса к системе Chat2Desk
//  При коде ответа 200 ответ читается как JSON в соответствие
//
// Параметры:
//  Сервис		 - Строка	 - метод api (напр. "/v1/dialogs/")
//  ТипЗапроса	 - Строка	 - Может принимать значения "GET", "POST", "PUT"
// 
// Возвращаемое значение:
//  Структура - десериализованый json
//
Функция ПолучитьРезультатЗапроса(Сервис, ТипЗапроса, ИспользоватьКэш = ложь, ТелоЗапроса = неопределено) Экспорт 
	СтруктураОтвета = Неопределено;
	ОбновитьКэш = Ложь;
	Если ИспользоватьКэш Тогда
		ХэшСумма = C2D_ВзаимодействиеСКэшированиемПовтИсп.ПолучитьХэш(Новый структура("Сервис, ТипЗапроса", Сервис, ТипЗапроса));
		СтруктураОтвета = РегистрыСведений.C2D_Кэш.ВернутьДанныеКэша(ХэшСумма);
	КонецЕсли;

	Если СтруктураОтвета = Неопределено Тогда
		СтруктураАдресаApi = C2D_ВзаимодействиеСApiПовтИсп.АдресСервераИПортаApi();
		СтруктураСервера = C2D_ВзаимодействиеСApiСлужебный.РазобратьАдресСайта(СтруктураАдресаApi.сервер);
		СоединениеHTTP = Новый HTTPСоединение(СтруктураСервера.HTTPСервер, СтруктураАдресаApi.Порт, "", "",,,?(СтруктураСервера.HTTPЗащищенноеСоединение, Новый ЗащищенноеСоединениеOpenSSL(),неопределено));		
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Authorization", C2D_ВзаимодействиеСApiПовтИсп.ТокенАвторизации());
		Заголовки.Вставить("Source", "X-1C");
		
		ЗапросHTTP = Новый HTTPЗапрос(СтруктураСервера.HTTPАдресСкрипта+Сервис, Заголовки);
		Если не ТелоЗапроса = Неопределено Тогда
			ЗапросHTTP.УстановитьТелоИзСтроки(ТелоЗапроса);
			ЗапросHTTP.Заголовки.Вставить("Content-Type", "application/json");
		КонецЕсли; 
		Результат = неопределено;
		Выполнить "Результат = СоединениеHTTP."+ТипЗапроса+"(ЗапросHTTP)";
		РезультатСтрокой = Результат.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
		Если Результат.КодСостояния <> 200 Тогда
			ОписаниеОшибки = СтрШаблон("Ошибка работы с Chat2Desk.
			|Код состояния: %1
			|Тело: %2"
			, Результат.КодСостояния
			, РезультатСтрокой
			);
			ЗаписьЖурналаРегистрации("Chat2Desk", , , , ОписаниеОшибки);  	
		КонецЕсли;
		СтруктураОтвета = C2D_ВзаимодействиеСApiСлужебный.ДесериализоватьJSON(РезультатСтрокой);
		ОбновитьКэш = ИспользоватьКэш; 
	КонецЕсли; 
	
	Если ОбновитьКэш Тогда
		РегистрыСведений.C2D_Кэш.КэшироватьДанные(СтруктураОтвета, ХэшСумма);
	КонецЕсли; 
	Возврат СтруктураОтвета;
КонецФункции

Функция СформироватьСтрокуПараметровЗапроса(СтруктураПараметров)
	ТекстПараметровЗапроса = "";
	первыйРаз = Истина;
	Для каждого ЭлементСтруктуры Из СтруктураПараметров Цикл
		Если Не ЗначениеЗаполнено(ЭлементСтруктуры.Значение) Тогда
			Продолжить;
		КонецЕсли; 
		ТекстПараметровЗапроса=ТекстПараметровЗапроса+?(первыйРаз, "?", "&")+ЭлементСтруктуры.Ключ+"="+Формат(ЭлементСтруктуры.Значение,"ЧГ=0");
		первыйРаз = ложь;
	КонецЦикла; 
	Возврат ТекстПараметровЗапроса;
КонецФункции

#КонецОбласти