class Language {
  static Map _language = {
    "no_internet": "Nemáte pripojenie na internet.",
    "something_went_wrong": "Nastala neočakávan chyba. Skúste to znova.",
    "successful_registration": "Boli ste úspešne registrovaný.",
    "unsuccessful_login":
        "Vaš email alebo heslo boli nesprávne. Skúste to znova.",
    "all_fields_are_required": "Musíte vyplniť všetky polia.",
    "unsuccessful_registration_email":
        "Zadaný email už je obsadený. Skúste použiť iný.",
    "unsuccessful_registration_group_id": "Zadaný kód skupiny je neplatný.",
    "login": "Prihlásiť sa",
    "registration": "Registrovať sa",
    "error": "Chyba",
    "ok": "OK",
    "great": "Výborne!",
    "home": "Domov",
    "today": "Dnes",
    "prayer_for_today": "Modlitba na dnes",
    "steps": "Kroky",
  };

  static Map _months = {
    "1": "Jan",
    "2": "Feb",
    "3": "Mar",
    "4": "Apr",
    "5": "Máj",
    "6": "Jún",
    "7": "Júl",
    "8": "August",
    "9": "Sep",
    "10": "Okt",
    "11": "Nov",
    "12": "Dec",
  };

  static getMonth(String id) {
    return _months[id];
  }

  static getWord(String id) {
    return _language[id];
  }
}
