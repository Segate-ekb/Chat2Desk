#Область ПрограммныйИнтерфейс
Функция СохранитьВложениеДляОтправки(АдресВоВременномХранилище, Представление) Экспорт
	Идентификатор = новый уникальныйИдентификатор;
	Вложение = Справочники.C2D_Вложения.СоздатьЭлемент();
	Структурафайла = РазбитьИмяФайла(Представление);
	Вложение.Наименование = ЗаменитьСимволыПодчеркиваниями(Строка(Идентификатор)+"_"+Структурафайла.ИмяБезРасширения)+"."+Структурафайла.РасширениеФайла;
	ТипMime = ОпределитьТипMime(Структурафайла.РасширениеФайла);
	Вложение.MimeType = ?(ТипMime = неопределено,"application/octet-stream", ТипMime);
	Вложение.ХранилищеДанных = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресВоВременномХранилище));
	Вложение.Записать();
	Возврат вложение.Ссылка;
КонецФункции

Функция СохранитьВложенияДляОтправки(Вложения) Экспорт
	МассивСсылок = новый массив;
	Для каждого Вложение Из Вложения Цикл
		Ссылка = СохранитьВложениеДляОтправки(Вложение.АдресВоВременномХранилище, Вложение.Представление);
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла; 	
	Возврат МассивСсылок;
КонецФункции

Функция ОбработатьВызовВебСервиса(ИмяФайла) Экспорт
	Ссылка = Справочники.C2D_Вложения.НайтиПоНаименованию(ИмяФайла, Истина);
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Новый HTTPСервисОтвет(404);
	КонецЕсли; 
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type",Ссылка.MimeType+"; charset=utf-8");
	Ответ.УстановитьТелоИзДвоичныхДанных(Ссылка.ХранилищеДанных.Получить());
	Возврат Ответ;
	
	Объект= Ссылка.ПолучитьОбъект();
КонецФункции

Функция ПолучитьСсылкуВложения(ИмяВложения) Экспорт 
	Возврат C2D_ВзаимодействиеСApiПовтИсп.ПолучитьСформированнуюСсылкуНаБазуСАвторизацией()+"hs/c2d_attachments/"+КодироватьСтроку(ИмяВложения, СпособКодированияСтроки.URLВКодировкеURL);	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ЗаменитьСимволыПодчеркиваниями(Строка1)
    	НовСтрока = "";
      	ПравильныеСимволы = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnmЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮйцукенгшщзхъфывапролджэячсмитьбю_1234567890";
      

    	Для Сч = 1 по СтрДлина(Строка1) Цикл
      

    		ТекСимв = Сред(Строка1, Сч, 1);
      

    		Если Найти(ПравильныеСимволы, ТекСимв) > 0 Тогда
      

    			НовСтрока = НовСтрока + ТекСимв;
      
			Иначе
				НовСтрока = НовСтрока +"_";
    		КонецЕсли;
      	КонецЦикла;

    Возврат НовСтрока;
  
КонецФункции

// Функция выделяет из имени файла его расширение
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция РазбитьИмяФайла(ИмяФайла) Экспорт
	РасширениеФайла = "";
	ИмяБезРасширения = "";
	ПозицияПоследнейТочки = СтрНайти(ИмяФайла, ".",НаправлениеПоиска.СКонца);
	Если ПозицияПоследнейТочки<>0 Тогда
		РасширениеФайла = Сред(ИмяФайла, ПозицияПоследнейТочки + 1);
		ИмяБезРасширения  = Лев(ИмяФайла, ПозицияПоследнейТочки - 1);
	КонецЕсли; 
	Возврат Новый структура("РасширениеФайла, ИмяБезРасширения", РасширениеФайла, ИмяБезРасширения);
КонецФункции 

Функция ОпределитьТипMime(Расширение)
	ТипыMime = Новый Соответствие;
ТипыMime.Вставить("123" , "application/vnd.lotus-1-2-3");
ТипыMime.Вставить("3ds" , "image/x-3ds");
ТипыMime.Вставить("669" , "audio/x-mod");
ТипыMime.Вставить("a" , "application/x-archive");
ТипыMime.Вставить("abw" , "application/x-abiword");
ТипыMime.Вставить("ac3" , "audio/ac3");
ТипыMime.Вставить("adb" , "text/x-adasrc");
ТипыMime.Вставить("ads" , "text/x-adasrc");
ТипыMime.Вставить("afm" , "application/x-font-afm");
ТипыMime.Вставить("ag" , "image/x-applix-graphics");
ТипыMime.Вставить("ai" , "application/illustrator");
ТипыMime.Вставить("aif" , "audio/x-aiff");
ТипыMime.Вставить("aifc" , "audio/x-aiff");
ТипыMime.Вставить("aiff" , "audio/x-aiff");
ТипыMime.Вставить("al" , "application/x-perl");
ТипыMime.Вставить("arj" , "application/x-arj");
ТипыMime.Вставить("as" , "application/x-applix-spreadsheet");
ТипыMime.Вставить("asc" , "text/plain");
ТипыMime.Вставить("asf" , "video/x-ms-asf");
ТипыMime.Вставить("asp" , "application/x-asp");
ТипыMime.Вставить("asx" , "video/x-ms-asf");
ТипыMime.Вставить("au" , "audio/basic");
ТипыMime.Вставить("avi" , "video/x-msvideo");
ТипыMime.Вставить("aw" , "application/x-applix-word");
ТипыMime.Вставить("bak" , "application/x-trash");
ТипыMime.Вставить("bcpio" , "application/x-bcpio");
ТипыMime.Вставить("bdf" , "application/x-font-bdf");
ТипыMime.Вставить("bib" , "text/x-bibtex");
ТипыMime.Вставить("bin" , "application/octet-stream");
ТипыMime.Вставить("blend" , "application/x-blender");
ТипыMime.Вставить("blender" , "application/x-blender");
ТипыMime.Вставить("bmp" , "image/bmp");
ТипыMime.Вставить("bz" , "application/x-bzip");
ТипыMime.Вставить("bz2" , "application/x-bzip");
ТипыMime.Вставить("c" , "text/x-csrc");
ТипыMime.Вставить("c++" , "text/x-c++src");
ТипыMime.Вставить("cc" , "text/x-c++src");
ТипыMime.Вставить("cdf" , "application/x-netcdf");
ТипыMime.Вставить("cdr" , "application/vnd.corel-draw");
ТипыMime.Вставить("cer" , "application/x-x509-ca-cert");
ТипыMime.Вставить("cert" , "application/x-x509-ca-cert");
ТипыMime.Вставить("cgi" , "application/x-cgi");
ТипыMime.Вставить("cgm" , "image/cgm");
ТипыMime.Вставить("chrt" , "application/x-kchart");
ТипыMime.Вставить("class" , "application/x-java");
ТипыMime.Вставить("cls" , "text/x-tex");
ТипыMime.Вставить("cpio" , "application/x-cpio");
ТипыMime.Вставить("cpp" , "text/x-c++src");
ТипыMime.Вставить("crt" , "application/x-x509-ca-cert");
ТипыMime.Вставить("cs" , "text/x-csharp");
ТипыMime.Вставить("csh" , "application/x-shellscript");
ТипыMime.Вставить("css" , "text/css");
ТипыMime.Вставить("cssl" , "text/css");
ТипыMime.Вставить("csv" , "text/x-comma-separated-values");
ТипыMime.Вставить("cur" , "image/x-win-bitmap");
ТипыMime.Вставить("cxx" , "text/x-c++src");
ТипыMime.Вставить("dat" , "video/mpeg");
ТипыMime.Вставить("dbf" , "application/x-dbase");
ТипыMime.Вставить("dc" , "application/x-dc-rom");
ТипыMime.Вставить("dcl" , "text/x-dcl");
ТипыMime.Вставить("dcm" , "image/x-dcm");
ТипыMime.Вставить("deb" , "application/x-deb");
ТипыMime.Вставить("der" , "application/x-x509-ca-cert");
ТипыMime.Вставить("desktop" , "application/x-desktop");
ТипыMime.Вставить("dia" , "application/x-dia-diagram");
ТипыMime.Вставить("diff" , "text/x-patch");
ТипыMime.Вставить("djv" , "image/vnd.djvu");
ТипыMime.Вставить("djvu" , "image/vnd.djvu");
ТипыMime.Вставить("doc" , "application/vnd.ms-word");
ТипыMime.Вставить("dsl" , "text/x-dsl");
ТипыMime.Вставить("dtd" , "text/x-dtd");
ТипыMime.Вставить("dvi" , "application/x-dvi");
ТипыMime.Вставить("dwg" , "image/vnd.dwg");
ТипыMime.Вставить("dxf" , "image/vnd.dxf");
ТипыMime.Вставить("egon" , "application/x-egon");
ТипыMime.Вставить("el" , "text/x-emacs-lisp");
ТипыMime.Вставить("eps" , "image/x-eps");
ТипыMime.Вставить("epsf" , "image/x-eps");
ТипыMime.Вставить("epsi" , "image/x-eps");
ТипыMime.Вставить("etheme" , "application/x-e-theme");
ТипыMime.Вставить("etx" , "text/x-setext");
ТипыMime.Вставить("exe" , "application/x-ms-dos-executable");
ТипыMime.Вставить("ez" , "application/andrew-inset");
ТипыMime.Вставить("f" , "text/x-fortran");
ТипыMime.Вставить("fig" , "image/x-xfig");
ТипыMime.Вставить("fits" , "image/x-fits");
ТипыMime.Вставить("flac" , "audio/x-flac");
ТипыMime.Вставить("flc" , "video/x-flic");
ТипыMime.Вставить("fli" , "video/x-flic");
ТипыMime.Вставить("flw" , "application/x-kivio");
ТипыMime.Вставить("fo" , "text/x-xslfo");
ТипыMime.Вставить("g3" , "image/fax-g3");
ТипыMime.Вставить("gb" , "application/x-gameboy-rom");
ТипыMime.Вставить("gcrd" , "text/x-vcard");
ТипыMime.Вставить("gen" , "application/x-genesis-rom");
ТипыMime.Вставить("gg" , "application/x-sms-rom");
ТипыMime.Вставить("gif" , "image/gif");
ТипыMime.Вставить("glade" , "application/x-glade");
ТипыMime.Вставить("gmo" , "application/x-gettext-translation");
ТипыMime.Вставить("gnc" , "application/x-gnucash");
ТипыMime.Вставить("gnucash" , "application/x-gnucash");
ТипыMime.Вставить("gnumeric" , "application/x-gnumeric");
ТипыMime.Вставить("gra" , "application/x-graphite");
ТипыMime.Вставить("gsf" , "application/x-font-type1");
ТипыMime.Вставить("gtar" , "application/x-gtar");
ТипыMime.Вставить("gz" , "application/x-gzip");
ТипыMime.Вставить("h" , "text/x-chdr");
ТипыMime.Вставить("h++" , "text/x-chdr");
ТипыMime.Вставить("hdf" , "application/x-hdf");
ТипыMime.Вставить("hh" , "text/x-c++hdr");
ТипыMime.Вставить("hp" , "text/x-chdr");
ТипыMime.Вставить("hpgl" , "application/vnd.hp-hpgl");
ТипыMime.Вставить("hs" , "text/x-haskell");
ТипыMime.Вставить("htm" , "text/html");
ТипыMime.Вставить("html" , "text/html");
ТипыMime.Вставить("icb" , "image/x-icb");
ТипыMime.Вставить("ico" , "image/x-ico");
ТипыMime.Вставить("ics" , "text/calendar");
ТипыMime.Вставить("idl" , "text/x-idl");
ТипыMime.Вставить("ief" , "image/ief");
ТипыMime.Вставить("iff" , "image/x-iff");
ТипыMime.Вставить("ilbm" , "image/x-ilbm");
ТипыMime.Вставить("iso" , "application/x-cd-image");
ТипыMime.Вставить("it" , "audio/x-it");
ТипыMime.Вставить("jar" , "application/x-jar");
ТипыMime.Вставить("java" , "text/x-java");
ТипыMime.Вставить("jng" , "image/x-jng");
ТипыMime.Вставить("jp2" , "image/jpeg2000");
ТипыMime.Вставить("jpe" , "image/jpeg");
ТипыMime.Вставить("jpeg" , "image/jpeg");
ТипыMime.Вставить("jpg" , "image/jpeg");
ТипыMime.Вставить("jpr" , "application/x-jbuilder-project");
ТипыMime.Вставить("jpx" , "application/x-jbuilder-project");
ТипыMime.Вставить("js" , "application/x-javascript");
ТипыMime.Вставить("karbon" , "application/x-karbon");
ТипыMime.Вставить("kdelnk" , "application/x-desktop");
ТипыMime.Вставить("kfo" , "application/x-kformula");
ТипыMime.Вставить("kil" , "application/x-killustrator");
ТипыMime.Вставить("kon" , "application/x-kontour");
ТипыMime.Вставить("kpm" , "application/x-kpovmodeler");
ТипыMime.Вставить("kpr" , "application/x-kpresenter");
ТипыMime.Вставить("kpt" , "application/x-kpresenter");
ТипыMime.Вставить("kra" , "application/x-krita");
ТипыMime.Вставить("ksp" , "application/x-kspread");
ТипыMime.Вставить("kud" , "application/x-kugar");
ТипыMime.Вставить("kwd" , "application/x-kword");
ТипыMime.Вставить("kwt" , "application/x-kword");
ТипыMime.Вставить("la" , "application/x-shared-library-la");
ТипыMime.Вставить("lha" , "application/x-lha");
ТипыMime.Вставить("lhs" , "text/x-literate-haskell");
ТипыMime.Вставить("lhz" , "application/x-lhz");
ТипыMime.Вставить("log" , "text/x-log");
ТипыMime.Вставить("ltx" , "text/x-tex");
ТипыMime.Вставить("lwo" , "image/x-lwo");
ТипыMime.Вставить("lwob" , "image/x-lwo");
ТипыMime.Вставить("lws" , "image/x-lws");
ТипыMime.Вставить("lyx" , "application/x-lyx");
ТипыMime.Вставить("lzh" , "application/x-lha");
ТипыMime.Вставить("lzo" , "application/x-lzop");
ТипыMime.Вставить("m" , "text/x-objcsrc");
ТипыMime.Вставить("m15" , "audio/x-mod");
ТипыMime.Вставить("m3u" , "audio/x-mpegurl");
ТипыMime.Вставить("man" , "application/x-troff-man");
ТипыMime.Вставить("md" , "application/x-genesis-rom");
ТипыMime.Вставить("me" , "text/x-troff-me");
ТипыMime.Вставить("mgp" , "application/x-magicpoint");
ТипыMime.Вставить("mid" , "audio/midi");
ТипыMime.Вставить("midi" , "audio/midi");
ТипыMime.Вставить("mif" , "application/x-mif");
ТипыMime.Вставить("mkv" , "application/x-matroska");
ТипыMime.Вставить("mm" , "text/x-troff-mm");
ТипыMime.Вставить("mml" , "text/mathml");
ТипыMime.Вставить("mng" , "video/x-mng");
ТипыMime.Вставить("moc" , "text/x-moc");
ТипыMime.Вставить("mod" , "audio/x-mod");
ТипыMime.Вставить("moov" , "video/quicktime");
ТипыMime.Вставить("mov" , "video/quicktime");
ТипыMime.Вставить("movie" , "video/x-sgi-movie");
ТипыMime.Вставить("mp2" , "video/mpeg");
ТипыMime.Вставить("mp3" , "audio/x-mp3");
ТипыMime.Вставить("mpe" , "video/mpeg");
ТипыMime.Вставить("mpeg" , "video/mpeg");
ТипыMime.Вставить("mpg" , "video/mpeg");
ТипыMime.Вставить("ms" , "text/x-troff-ms");
ТипыMime.Вставить("msod" , "image/x-msod");
ТипыMime.Вставить("msx" , "application/x-msx-rom");
ТипыMime.Вставить("mtm" , "audio/x-mod");
ТипыMime.Вставить("n64" , "application/x-n64-rom");
ТипыMime.Вставить("nc" , "application/x-netcdf");
ТипыMime.Вставить("nes" , "application/x-nes-rom");
ТипыMime.Вставить("nsv" , "video/x-nsv");
ТипыMime.Вставить("o" , "application/x-object");
ТипыMime.Вставить("obj" , "application/x-tgif");
ТипыMime.Вставить("oda" , "application/oda");
ТипыMime.Вставить("ogg" , "application/ogg");
ТипыMime.Вставить("old" , "application/x-trash");
ТипыMime.Вставить("oleo" , "application/x-oleo");
ТипыMime.Вставить("p" , "text/x-pascal");
ТипыMime.Вставить("p12" , "application/x-pkcs12");
ТипыMime.Вставить("p7s" , "application/pkcs7-signature");
ТипыMime.Вставить("pas" , "text/x-pascal");
ТипыMime.Вставить("patch" , "text/x-patch");
ТипыMime.Вставить("pbm" , "image/x-portable-bitmap");
ТипыMime.Вставить("pcd" , "image/x-photo-cd");
ТипыMime.Вставить("pcf" , "application/x-font-pcf");
ТипыMime.Вставить("pcl" , "application/vnd.hp-pcl");
ТипыMime.Вставить("pdb" , "application/vnd.palm");
ТипыMime.Вставить("pdf" , "application/pdf");
ТипыMime.Вставить("pem" , "application/x-x509-ca-cert");
ТипыMime.Вставить("perl" , "application/x-perl");
ТипыMime.Вставить("pfa" , "application/x-font-type1");
ТипыMime.Вставить("pfb" , "application/x-font-type1");
ТипыMime.Вставить("pfx" , "application/x-pkcs12");
ТипыMime.Вставить("pgm" , "image/x-portable-graymap");
ТипыMime.Вставить("pgn" , "application/x-chess-pgn");
ТипыMime.Вставить("pgp" , "application/pgp");
ТипыMime.Вставить("php" , "application/x-php");
ТипыMime.Вставить("php3" , "application/x-php");
ТипыMime.Вставить("php4" , "application/x-php");
ТипыMime.Вставить("pict" , "image/x-pict");
ТипыMime.Вставить("pict1" , "image/x-pict");
ТипыMime.Вставить("pict2" , "image/x-pict");
ТипыMime.Вставить("pl" , "application/x-perl");
ТипыMime.Вставить("pls" , "audio/x-scpls");
ТипыMime.Вставить("pm" , "application/x-perl");
ТипыMime.Вставить("png" , "image/png");
ТипыMime.Вставить("pnm" , "image/x-portable-anymap");
ТипыMime.Вставить("po" , "text/x-gettext-translation");
ТипыMime.Вставить("pot" , "text/x-gettext-translation-template");
ТипыMime.Вставить("ppm" , "image/x-portable-pixmap");
ТипыMime.Вставить("pps" , "application/vnd.ms-powerpoint");
ТипыMime.Вставить("ppt" , "application/vnd.ms-powerpoint");
ТипыMime.Вставить("ppz" , "application/vnd.ms-powerpoint");
ТипыMime.Вставить("ps" , "application/postscript");
ТипыMime.Вставить("psd" , "image/x-psd");
ТипыMime.Вставить("psf" , "application/x-font-linux-psf");
ТипыMime.Вставить("psid" , "audio/prs.sid");
ТипыMime.Вставить("pw" , "application/x-pw");
ТипыMime.Вставить("py" , "application/x-python");
ТипыMime.Вставить("pyc" , "application/x-python-bytecode");
ТипыMime.Вставить("pyo" , "application/x-python-bytecode");
ТипыMime.Вставить("qif" , "application/x-qw");
ТипыMime.Вставить("qt" , "video/quicktime");
ТипыMime.Вставить("qtvr" , "video/quicktime");
ТипыMime.Вставить("ra" , "audio/x-pn-realaudio");
ТипыMime.Вставить("ram" , "audio/x-pn-realaudio");
ТипыMime.Вставить("rar" , "application/x-rar");
ТипыMime.Вставить("ras" , "image/x-cmu-raster");
ТипыMime.Вставить("rdf" , "text/rdf");
ТипыMime.Вставить("rej" , "application/x-reject");
ТипыMime.Вставить("rgb" , "image/x-rgb");
ТипыMime.Вставить("rle" , "image/rle");
ТипыMime.Вставить("rm" , "audio/x-pn-realaudio");
ТипыMime.Вставить("roff" , "application/x-troff");
ТипыMime.Вставить("rpm" , "application/x-rpm");
ТипыMime.Вставить("rss" , "text/rss");
ТипыMime.Вставить("rtf" , "application/rtf");
ТипыMime.Вставить("rtx" , "text/richtext");
ТипыMime.Вставить("s3m" , "audio/x-s3m");
ТипыMime.Вставить("sam" , "application/x-amipro");
ТипыMime.Вставить("scm" , "text/x-scheme");
ТипыMime.Вставить("sda" , "application/vnd.stardivision.draw");
ТипыMime.Вставить("sdc" , "application/vnd.stardivision.calc");
ТипыMime.Вставить("sdd" , "application/vnd.stardivision.impress");
ТипыMime.Вставить("sdp" , "application/vnd.stardivision.impress");
ТипыMime.Вставить("sds" , "application/vnd.stardivision.chart");
ТипыMime.Вставить("sdw" , "application/vnd.stardivision.writer");
ТипыMime.Вставить("sgi" , "image/x-sgi");
ТипыMime.Вставить("sgl" , "application/vnd.stardivision.writer");
ТипыMime.Вставить("sgm" , "text/sgml");
ТипыMime.Вставить("sgml" , "text/sgml");
ТипыMime.Вставить("sh" , "application/x-shellscript");
ТипыMime.Вставить("shar" , "application/x-shar");
ТипыMime.Вставить("siag" , "application/x-siag");
ТипыMime.Вставить("sid" , "audio/prs.sid");
ТипыMime.Вставить("sik" , "application/x-trash");
ТипыMime.Вставить("slk" , "text/spreadsheet");
ТипыMime.Вставить("smd" , "application/vnd.stardivision.mail");
ТипыMime.Вставить("smf" , "application/vnd.stardivision.math");
ТипыMime.Вставить("smi" , "application/smil");
ТипыMime.Вставить("smil" , "application/smil");
ТипыMime.Вставить("sml" , "application/smil");
ТипыMime.Вставить("sms" , "application/x-sms-rom");
ТипыMime.Вставить("snd" , "audio/basic");
ТипыMime.Вставить("so" , "application/x-sharedlib");
ТипыMime.Вставить("spd" , "application/x-font-speedo");
ТипыMime.Вставить("sql" , "text/x-sql");
ТипыMime.Вставить("src" , "application/x-wais-source");
ТипыMime.Вставить("stc" , "application/vnd.sun.xml.calc.template");
ТипыMime.Вставить("std" , "application/vnd.sun.xml.draw.template");
ТипыMime.Вставить("sti" , "application/vnd.sun.xml.impress.template");
ТипыMime.Вставить("stm" , "audio/x-stm");
ТипыMime.Вставить("stw" , "application/vnd.sun.xml.writer.template");
ТипыMime.Вставить("sty" , "text/x-tex");
ТипыMime.Вставить("sun" , "image/x-sun-raster");
ТипыMime.Вставить("sv4cpio" , "application/x-sv4cpio");
ТипыMime.Вставить("sv4crc" , "application/x-sv4crc");
ТипыMime.Вставить("svg" , "image/svg+xml");
ТипыMime.Вставить("swf" , "application/x-shockwave-flash");
ТипыMime.Вставить("sxc" , "application/vnd.sun.xml.calc");
ТипыMime.Вставить("sxd" , "application/vnd.sun.xml.draw");
ТипыMime.Вставить("sxg" , "application/vnd.sun.xml.writer.global");
ТипыMime.Вставить("sxi" , "application/vnd.sun.xml.impress");
ТипыMime.Вставить("sxm" , "application/vnd.sun.xml.math");
ТипыMime.Вставить("sxw" , "application/vnd.sun.xml.writer");
ТипыMime.Вставить("sylk" , "text/spreadsheet");
ТипыMime.Вставить("t" , "application/x-troff");
ТипыMime.Вставить("tar" , "application/x-tar");
ТипыMime.Вставить("tcl" , "text/x-tcl");
ТипыMime.Вставить("tcpalette" , "application/x-terminal-color-palette");
ТипыMime.Вставить("tex" , "text/x-tex");
ТипыMime.Вставить("texi" , "text/x-texinfo");
ТипыMime.Вставить("texinfo" , "text/x-texinfo");
ТипыMime.Вставить("tga" , "image/x-tga");
ТипыMime.Вставить("tgz" , "application/x-compressed-tar");
ТипыMime.Вставить("theme" , "application/x-theme");
ТипыMime.Вставить("tif" , "image/tiff");
ТипыMime.Вставить("tiff" , "image/tiff");
ТипыMime.Вставить("tk" , "text/x-tcl");
ТипыMime.Вставить("torrent" , "application/x-bittorrent");
ТипыMime.Вставить("tr" , "application/x-troff");
ТипыMime.Вставить("ts" , "application/x-linguist");
ТипыMime.Вставить("tsv" , "text/tab-separated-values");
ТипыMime.Вставить("ttf" , "application/x-font-ttf");
ТипыMime.Вставить("txt" , "text/plain");
ТипыMime.Вставить("tzo" , "application/x-tzo");
ТипыMime.Вставить("ui" , "application/x-designer");
ТипыMime.Вставить("uil" , "text/x-uil");
ТипыMime.Вставить("ult" , "audio/x-mod");
ТипыMime.Вставить("uni" , "audio/x-mod");
ТипыMime.Вставить("uri" , "text/x-uri");
ТипыMime.Вставить("url" , "text/x-uri");
ТипыMime.Вставить("ustar" , "application/x-ustar");
ТипыMime.Вставить("vcf" , "text/x-vcalendar");
ТипыMime.Вставить("vcs" , "text/x-vcalendar");
ТипыMime.Вставить("vct" , "text/x-vcard");
ТипыMime.Вставить("vob" , "video/mpeg");
ТипыMime.Вставить("voc" , "audio/x-voc");
ТипыMime.Вставить("vor" , "application/vnd.stardivision.writer");
ТипыMime.Вставить("vpp" , "application/x-extension-vpp");
ТипыMime.Вставить("wav" , "audio/x-wav");
ТипыMime.Вставить("wb1" , "application/x-quattropro");
ТипыMime.Вставить("wb2" , "application/x-quattropro");
ТипыMime.Вставить("wb3" , "application/x-quattropro");
ТипыMime.Вставить("wk1" , "application/vnd.lotus-1-2-3");
ТипыMime.Вставить("wk3" , "application/vnd.lotus-1-2-3");
ТипыMime.Вставить("wk4" , "application/vnd.lotus-1-2-3");
ТипыMime.Вставить("wks" , "application/vnd.lotus-1-2-3");
ТипыMime.Вставить("wmf" , "image/x-wmf");
ТипыMime.Вставить("wml" , "text/vnd.wap.wml");
ТипыMime.Вставить("wmv" , "video/x-ms-wmv");
ТипыMime.Вставить("wpd" , "application/vnd.wordperfect");
ТипыMime.Вставить("wpg" , "application/x-wpg");
ТипыMime.Вставить("wri" , "application/x-mswrite");
ТипыMime.Вставить("wrl" , "model/vrml");
ТипыMime.Вставить("xac" , "application/x-gnucash");
ТипыMime.Вставить("xbel" , "application/x-xbel");
ТипыMime.Вставить("xbm" , "image/x-xbitmap");
ТипыMime.Вставить("xcf" , "image/x-xcf");
ТипыMime.Вставить("xhtml" , "application/xhtml+xml");
ТипыMime.Вставить("xi" , "audio/x-xi");
ТипыMime.Вставить("xla" , "application/vnd.ms-excel");
ТипыMime.Вставить("xlc" , "application/vnd.ms-excel");
ТипыMime.Вставить("xld" , "application/vnd.ms-excel");
ТипыMime.Вставить("xll" , "application/vnd.ms-excel");
ТипыMime.Вставить("xlm" , "application/vnd.ms-excel");
ТипыMime.Вставить("xls" , "application/vnd.ms-excel");
ТипыMime.Вставить("xlt" , "application/vnd.ms-excel");
ТипыMime.Вставить("xlw" , "application/vnd.ms-excel");
ТипыMime.Вставить("xm" , "audio/x-xm");
ТипыMime.Вставить("xmi" , "text/x-xmi");
ТипыMime.Вставить("xml" , "text/xml");
ТипыMime.Вставить("xpm" , "image/x-xpixmap");
ТипыMime.Вставить("xsl" , "text/x-xslt");
ТипыMime.Вставить("xslfo" , "text/x-xslfo");
ТипыMime.Вставить("xslt" , "text/x-xslt");
ТипыMime.Вставить("xwd" , "image/x-xwindowdump");
ТипыMime.Вставить("z" , "application/x-compress");
ТипыMime.Вставить("zabw" , "application/x-abiword");
ТипыMime.Вставить("zip" , "application/zip");
ТипыMime.Вставить("zoo" , "application/x-zoo");

Возврат ТипыMime.Получить(Расширение);
КонецФункции

#КонецОбласти