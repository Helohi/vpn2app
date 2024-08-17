import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';

enum Language { english, russian, turkmen }

class Texts {
  late Language currentLanguage;

  Texts() {
    currentLanguage = Language.values
        .byName(GetIt.I.get<SharedPreferences>().getString(savedLanguage)!);
  }

  void setNewCurrentLanguage(Language newLanguage) {
    GetIt.I.get<SharedPreferences>().setString(savedLanguage, newLanguage.name);
    currentLanguage = newLanguage;
  }

  String textLanguage() {
    switch (currentLanguage) {
      case Language.english:
        return 'Language';
      case Language.russian:
        return 'Язык';
      case Language.turkmen:
        return 'Dili';
    }
  }

  String textSettings() {
    switch (currentLanguage) {
      case Language.english:
        return 'Settings';
      case Language.russian:
        return 'Настройки';
      case Language.turkmen:
        return 'Düzme';
    }
  }

  String textInfo() {
    switch (currentLanguage) {
      case Language.english:
        return 'Info';
      case Language.russian:
        return 'Информация';
      case Language.turkmen:
        return 'Maglumat';
    }
  }

  String textCreatedBy() {
    switch (currentLanguage) {
      case Language.english:
        return 'Created by';
      case Language.russian:
        return 'Создано';
      case Language.turkmen:
        return 'Düzen';
    }
  }

  String textWithAHelpOfAPG() {
    switch (currentLanguage) {
      case Language.english:
        return 'with a help of APG (Association of Public Geeks)';
      case Language.russian:
        return 'С помощью APG (Association of Public Geeks)';
      case Language.turkmen:
        return 'APG (Association of Public Geeks) kömegi bilen';
    }
  }

  String textThisApplicationIsFree() {
    switch (currentLanguage) {
      case Language.english:
        return 'This application is free to use and is not officially sold by anyone. If you bought this application, then know that you were scamed. Please inform us and share this application with your friends.';
      case Language.russian:
        return 'Это приложение бесплатно для использования и никем официально не продается. Если вы купили это приложение, то знайте что вы были обмануты. Пожалуйста, проинформируйте нас и поделитесь этим приложением со своими знакомыми.';
      case Language.turkmen:
        return 'Bu goşundy mugt. Eger ony size satsalar diýmek sizi aldaýandyrlar. Şeýle ýagdaýlarda haýal etmän bize ýüz tutuñ. Mobil goşundyny öz dostlaryñyz we maşgalañyz bilen paýlašyñ';
    }
  }

  String textShare() {
    switch (currentLanguage) {
      case Language.english:
        return "Share";
      case Language.russian:
        return "Поделиться";
      case Language.turkmen:
        return "Paýlaşmak";
    }
  }

  String textVpnKeys() {
    switch (currentLanguage) {
      case Language.english:
        return "VPN keys";
      case Language.russian:
        return "VPN ключи";
      case Language.turkmen:
        return "VPN açarlar";
    }
  }

  String textToContinueSwipe() {
    switch (currentLanguage) {
      case Language.english:
        return 'To contiinue swipe';
      case Language.russian:
        return 'Что бы продолжить свайпните';
      case Language.turkmen:
        return 'Dowam etmek geçiriň';
    }
  }

  String textLoadMore() {
    switch (currentLanguage) {
      case Language.english:
        return "Load more";
      case Language.russian:
        return "Загрузить ещё";
      case Language.turkmen:
        return "Ýene ýüklemek";
    }
  }

  String textNotEnoughCoins() {
    switch (currentLanguage) {
      case Language.english:
        return "Not enough coins. Press button at top right.";
      case Language.russian:
        return "Недостаточно монет. Нажмите на кнопку справа сверху.";
      case Language.turkmen:
        return "Teňe ýetenok. Sag ýokardaky düwmä basyň.";
    }
  }

  String textErrorWhileLoadingKeys() {
    switch (currentLanguage) {
      case Language.english:
        return "Error while loading keys";
      case Language.russian:
        return "Ошибка во время загрузки ключей";
      case Language.turkmen:
        return "Açarlary yüklemede näsazlyk";
    }
  }

  String textNoMoreKeys() {
    switch (currentLanguage) {
      case Language.english:
        return "No more keys";
      case Language.russian:
        return "Больше ключей нет";
      case Language.turkmen:
        return "Başga açar ýok";
    }
  }

  String textGetCoins() {
    switch (currentLanguage) {
      case Language.english:
        return "Get coins";
      case Language.russian:
        return "Получить монеты";
      case Language.turkmen:
        return "Teňňe almak";
    }
  }

  String textYourCoins() {
    switch (currentLanguage) {
      case Language.english:
        return "Your coins";
      case Language.russian:
        return "Ваши монеты";
      case Language.turkmen:
        return "Siziň teňeleriňiz";
    }
  }

  String textYouHaveTooMuchCoins() {
    switch (currentLanguage) {
      case Language.english:
        return "You have too much coins. Spend them first.";
      case Language.russian:
        return "У вас слишком много монет. Сначала потратьте их.";
      case Language.turkmen:
        return "Sizde örän köp teňe var. Sowuň, tazesini almak üçin.";
    }
  }

  String textCoinsForTime(String coinsAmount, String secondsAmount) {
    switch (currentLanguage) {
      case Language.english:
        return "$coinsAmount coins for $secondsAmount second";
      case Language.russian:
        return "$coinsAmount монет(а/ы) за $secondsAmount сек";
      case Language.turkmen:
        return "$coinsAmount teňňe üçin $secondsAmount sek ";
    }
  }

  String textPromocode() {
    switch (currentLanguage) {
      case Language.english:
        return "Promocode";
      case Language.russian:
        return "Промокод";
      case Language.turkmen:
        return "Promokod";
    }
  }

  String textPromocodeExample() {
    switch (currentLanguage) {
      case Language.english:
        return "Example123";
      case Language.russian:
        return "Пример123";
      case Language.turkmen:
        return "Mysal123";
    }
  }

  String textAlreadyWasUsed() {
    // It is meant to be used after promocode name
    switch (currentLanguage) {
      case Language.english:
        return "already was used";
      case Language.russian:
        return "уже использовался";
      case Language.turkmen:
        return "eýýäm ulanyldy";
    }
  }

  String textNoSuchPromocode() {
    switch (currentLanguage) {
      case Language.english:
        return "No Such Promocode";
      case Language.russian:
        return "Такого промокода нет";
      case Language.turkmen:
        return "Bu promokod ýokdir";
    }
  }

  String textErrorWhileCheckingPromocodes() {
    switch (currentLanguage) {
      case Language.english:
        return "Error while checking promocode";
      case Language.russian:
        return "Ошибка во время проверки промокода";
      case Language.turkmen:
        return "Promokodyn barlagynda näsazlyk";
    }
  }

  String textVpnKey() {
    switch (currentLanguage) {
      case Language.english:
        return "VPN key";
      case Language.russian:
        return "VPN ключ";
      case Language.turkmen:
        return "VPN açar";
    }
  }

  String textName() {
    switch (currentLanguage) {
      case Language.english:
        return "Name";
      case Language.russian:
        return "Название";
      case Language.turkmen:
        return "Ady";
    }
  }

  String textChannel() {
    switch (currentLanguage) {
      case Language.english:
        return "Channel";
      case Language.russian:
        return "Канал";
      case Language.turkmen:
        return "Kanal";
    }
  }

  String textDate() {
    switch (currentLanguage) {
      case Language.english:
        return "Date";
      case Language.russian:
        return "Дата";
      case Language.turkmen:
        return "Senesi";
    }
  }

  String textDescription() {
    switch (currentLanguage) {
      case Language.english:
        return "Description";
      case Language.russian:
        return "Описание";
      case Language.turkmen:
        return "Beýany";
    }
  }

  String textMinusCoins(String coinsAmount) {
    switch (currentLanguage) {
      case Language.english:
        return "-$coinsAmount coins";
      case Language.russian:
        return "-$coinsAmount монет";
      case Language.turkmen:
        return "-$coinsAmount teňe";
    }
  }

  String textDownload() {
    switch (currentLanguage) {
      case Language.english:
        return "Download";
      case Language.russian:
        return "Скачать";
      case Language.turkmen:
        return "Ýüklemek";
    }
  }

  String textLoading() {
    switch (currentLanguage) {
      case Language.english:
        return "Loading";
      case Language.russian:
        return "Загрузка";
      case Language.turkmen:
        return "Ýuklenýa";
    }
  }

  String textFileInDownloads(String localFilePath) {
    switch (currentLanguage) {
      case Language.english:
        return "File in '$localFilePath'";
      case Language.russian:
        return "Файл в '$localFilePath'";
      case Language.turkmen:
        return "Faýl '$localFilePath'-de";
    }
  }

  String textAllowExternalStorage() {
    switch (currentLanguage) {
      case Language.english:
        return "ALLOW EXTERNAL STORAGE";
      case Language.russian:
        return "РАЗРЕШИТЕ ПРИЛОЖЕНИЮ ИСПОЛЬЗОВАТЬ ВНЕШНЮЮ ПАМЯТЬ";
      case Language.turkmen:
        return "PROGRAMMA DAŞKY ÝATY ULANMAGA RUHSAT BERIŇ";
    }
  }

  String textErrorWhileDownloadinFile() {
    switch (currentLanguage) {
      case Language.english:
        return "Error while downloading file. Maybe some storage error!";
      case Language.russian:
        return "Ошибка во время скачивания файла. Возможно ошибка в памяти!";
      case Language.turkmen:
        return "Faýly yüklemede näsazlyk çykdy. Telefonyň ýatynda problema bolup biler.";
    }
  }

  String textYourAdvertisementCouldBeHere() {
    switch (currentLanguage) {
      case Language.english:
        return "Your advertisement could be here";
      case Language.russian:
        return "Здесь могла быть ваша реклама";
      case Language.turkmen:
        return "Sizin Relamaňyz şu ýerde bolup bilerdi";
    }
  }

  String textSupportAdvertisement() {
    switch (currentLanguage) {
      case Language.english:
        return "Support/Advertisement";
      case Language.russian:
        return "Помощь/Реклама";
      case Language.turkmen:
        return "Kömek/Reklama";
    }
  }

  String textShareThisApplication(String linkToApp) {
    switch (currentLanguage) {
      case Language.english:
        return "Wow! I found app with a lot of VPN keys! It was created by Helohi(TM_team)! Here is a link:\n$linkToApp";
      case Language.russian:
        return "Ого! Я нашёл приложение с огромным количеством VPN ключей! Он был создан Helohi(TM_team)! Вот ссылка:\n$linkToApp";
      case Language.turkmen:
        return "Wah! Men köp VPN açarlar bilen programmany tapdym! Ony Helohi(TM_team) düzdi! Almak uçin:\n$linkToApp";
    }
  }

  String textOldOpenVpn() {
    switch (currentLanguage) {
      case Language.english:
        return "If you need old Open VPN";
      case Language.russian:
        return "Если вам нужен старый Open VPN";
      case Language.turkmen:
        return "Köne Open VPN gerek bolsa";
    }
  }

  String textApplicationUpdate(String currentVersion, String newestVersion) {
    switch (currentLanguage) {
      case Language.english:
        return "Update an app!\n($currentApplicationVersion -> $newestVersion)";
      case Language.russian:
        return "Обновите приложение!\n($currentVersion -> $newestVersion)";
      case Language.turkmen:
        return "Täze versiýasy bar!\n($currentVersion -> $newestVersion)";
    }
  }

  String textNoAppCanOpenIt() {
    switch (currentLanguage) {
      case Language.english:
        return "You dont have an app to open this file";
      case Language.russian:
        return "У вас нет приложения для открытия этого файла";
      case Language.turkmen:
        return "Bu faýly açmak üçin mobil goşundyny ýok";
    }
  }

  String textCopiedToClipboard() {
    switch (currentLanguage) {
      case Language.english:
        return "Text is copied";
      case Language.russian:
        return "Текст скопирован";
      case Language.turkmen:
        return "Tekst goçürildi";
    }
  }

  String textTheme() {
    switch (currentLanguage) {
      case Language.english:
        return "Theme";
      case Language.russian:
        return "Тема";
      case Language.turkmen:
        return "Tema";
    }
  }

  String textServer() {
    switch (currentLanguage) {
      case Language.english:
        return "Server";
      case Language.russian:
        return "Сервер";
      case Language.turkmen:
        return "Server";
    }
  }

  String textNoAds() {
    switch (currentLanguage) {
      case Language.english:
        return "No Ads for free. Contact us:";
      case Language.russian:
        return "Никакой рекламы за бесплатно. Пишите нам:";
      case Language.turkmen:
        return "Mut Mahabat ýok. Bize ýazyn:";
    }
  }

  String textProfile() {
    switch (currentLanguage) {
      case Language.english:
        return "Profile";
      case Language.russian:
        return "Профиль";
      case Language.turkmen:
        return "Profil";
    }
  }

  String textSubscribed() {
    switch (currentLanguage) {
      case Language.english:
        return "Subscribed";
      case Language.russian:
        return "Подписаны";
      case Language.turkmen:
        return "Ýazylgy";
    }
  }

  String textNotSubscribed() {
    switch (currentLanguage) {
      case Language.english:
        return "Not Subsribed";
      case Language.russian:
        return "Не Подписаны";
      case Language.turkmen:
        return "Ýazylgy Däl";
    }
  }

  String textActivatedTill(DateTime date) {
    switch (currentLanguage) {
      case Language.english:
        return "Activated till: ${date.day}/${date.month}/${date.year}";
      case Language.russian:
        return "Активирован до: ${date.day}/${date.month}/${date.year}";
      case Language.turkmen:
        return "${date.day}/${date.month}/${date.year} çenli";
    }
  }

  String textCheckSubscription() {
    switch (currentLanguage) {
      case Language.english:
        return "Check subscription";
      case Language.russian:
        return "Проверить подписку";
      case Language.turkmen:
        return "Ýazylgyny barlamak";
    }
  }

  String textUpdated() {
    switch (currentLanguage) {
      case Language.english:
        return "Updated";
      case Language.russian:
        return "Обновлено";
      case Language.turkmen:
        return "Tazelendi";
    }
  }

  String textThisisNotYourPromocode() {
    switch (currentLanguage) {
      case Language.english:
        return "This is not your promocode";
      case Language.russian:
        return "Это не ваш промокод.";
      case Language.turkmen:
        return "Bu siziň promocodyňyz däl";
    }
  }
}
