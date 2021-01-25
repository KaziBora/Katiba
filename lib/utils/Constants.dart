//This file declares the strings used throughout the app

/// Shared Preference Keys for this app
class SharedPreferenceKeys {
  static const String AppDb_loaded = "app_database_loaded";
  static const String User = "app_user";
  static const String DarkMode = "app_dark_mode";
}

/// General language strings that are used throught the application majoryly in Kiswahili language
class LangStrings {
  static const String appName = "Katiba Ya Kenya";
  static const String inProgress = "In Progress ...";
  static const String gettingReady = "Getting ready ...";
  static const String somePatience = "Eish! ... A little patience ...";
  static const String records = 'artciles';
  static const String record_type1 = 'preamble';
  static const String record_type2 = 'schedules';
  static const String record_type3 = 'chapters';
  static const String record_type4 = 'articles';
  static const String searches = 'searches';

  static const String campaign = "\n\n#KatibaYaKenya #KenyanConstitution \n\nhttps://play.google.com/store/apps/details?id=com.kazibora.katiba ";
  static const String synonyms_for = "\n\nVisawe (synonyms) vya neno ";
  static const String searchNow = "Search ";
  static const String searchHint = "Search Katiba Ya Kenya";
  static const String favourited = "Favourited Content";

  static const String recordsTable = 'records';
  static const String historyTable = 'history';
  static const String searchesTable = 'searches';

  static const String id = 'id';
  static const String created = 'created';
  static const String type = 'type';
  static const String refid = 'refid';
  static const String recordid = 'recordid';
  static const String number = 'number';
  static const String title = 'title';
  static const String body = 'body';
  static const String isfav = 'isfav';
  static const String views = 'views';
  static const String notes = 'notes';

  static const String time = 'time';
  static const String category = 'category';
  static const String level = 'level';
  static const String questions = 'questions';
  static const String score = 'score';

  static const String nothing = 'Oops! You mean there is nothing here ...';

  static const String copyThis = "Copied to Clipboard";
  static const String shareThis = "Share";

  static const String recordCopied = "Content copied clipboard!";
  static const String recordLiked = " liked!";
  static const String recordDisliked = " disliked!";

  static const String mandhariMeusi = "Dark Mode";

  static const String donateActionButton = "DONATE";
  static const String laterActionButton = "LATER";
  
  static const String donateTabPage = "Support us, Donate";

  static const String donateTab1Title = "M-Pesa";
  static const String donateTab1Content = "PAYBILL: 891300\n\nACCOUNT: 34489";

  static const String donateTab2Title = "Equitel";
  static const String donateTab2Content = "BUSINESS NUMBER:\n\t891300\n\nAKAUNTI: 34489";

  static const String donateTab3Title = "Airtel";
  static const String donateTab3Content =
      "BUSINESS NAME:\n\tMCHANGA\n\nACCCOUNT: 34489";

  static const String donateTab4Title = "PayPal";
  static const String donateTab4Content =
      "ADDRESS:\n\ttunaboresha [at] gmail.com";

  static const String helpTabPage = "HelpDesk";

  static const String helpTab1Title = "Contacts";
  static const String helpTab1Content =
      "<p>PHONE: +2547 - </p><hr><p>EMAIL: tunaboresha [at] gmail.com </p><hr> <p>WEBSITE: <a href=\"https://kazibora.github.io\">kazibora.github.io</a></p>";

  static const String helpTab2Title = "Reviews";
  static const String helpTab2Content =
      "If you enjoy our app or don't like it please let us know by leaving your review on the <a href=\"https://play.google.com/store/apps/details?id=com.kazibora.katiba\">Google Play Store</a>";

  static const String helpTab3Title = "Open Source";
  static const String helpTab3Content =
      "If you are an App Developer, the source code for this app is freely available on GitHub:</br></br> <a href=\"https://github.com/kazibora/katiba\">github.com/kazibora/katiba</a>";

      
  static const String howToUse = "How it Works";
  static const String howToSearch1 = "Searching content";
  static const String howToSearch2 = "Guza sehemu nyeupe iliyoonyeshwa kwa mstari mwekundu ili kufungua skrini ya kutafuta records. " +
  "Tafadhali zingatia kuwa utafutaji ni wa records pekee";
  static const String aboutApp = "Kuhusu Kitumizi";

  static const String favoritesTab = "Vipendwa";
  static const String searchTab = "Tafuta";
  static const String triviaTab = "TriviaScreen";

  static const String triviaPage = "Chemsha Bongo";
  static const String triviaPageInstruction = "Chagua kundi ili kuanza";
  static const String triviaQuizInstruction = "Chagua Idadi ya Maswali";
  static const String triviaLevelInstruction = "Chagua Kiwango cha Ugumu";
  static const String triviaStart = "Anza!";
  static const String triviaCategory = "Kundi: ";
  static const String triviaEasy = "Rahisi";
  static const String triviaMedium = "Wastani";
  static const String triviaHard = "Ngumu";
}

/// Strings used in the database queries
class Queries {
  /// Query string for creating the records table
  static const String createRecordsTable = 'CREATE TABLE IF NOT EXISTS ' + LangStrings.recordsTable +
    '(' +
      LangStrings.id + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      LangStrings.type + ' VARCHAR(20), ' +
      LangStrings.refid + ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.number + ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.title + ' VARCHAR(100), ' +
      LangStrings.body + ' VARCHAR(2000),' +
      LangStrings.notes + ' VARCHAR(500), ' +
      LangStrings.isfav + ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.views + ' INTEGER NOT NULL DEFAULT 0' +
    ');';

  /// Query string for creating the searches table
  static const String createSearchesTable = 'CREATE TABLE IF NOT EXISTS ' + LangStrings.searchesTable +
    '(' + 
      LangStrings.id + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      LangStrings.recordid + ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.created + ' VARCHAR(20)' +
    ');';
 
  /// Query string for creating the history table
  static const String createHistoryTable = 'CREATE TABLE IF NOT EXISTS ' + LangStrings.historyTable +
    '(' + 
      LangStrings.id + ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      LangStrings.recordid + ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.created + ' VARCHAR(20)' +
    ');';
 
}
