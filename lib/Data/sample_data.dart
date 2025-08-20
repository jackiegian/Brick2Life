import '../Constructors/account.dart';
import '../Constructors/cleaning_item.dart';
import '../Constructors/house.dart';
import '../Constructors/shopping_item.dart';

class SampleData {
  // house

  static House house1 = House(title: "Casa", sharedNotes: "Pagare affitto il primo di ogni mese \nPassword Wi-Fi: dhf4FeG45VDx \nChiudere sempre la porta prima di uscire di casa");

  // account

  static Account account1 = Account(
      username: "Gianluca",
      password: "Gianluca",
      imgProfile: "assets/img_profile/profile_1.png",
      isOnline: true,
      name: "Gianluca");
  static Account account2 = Account(
      username: "Flavio",
      password: "Flavio",
      imgProfile: "assets/img_profile/profile_2.png",
      isOnline: false,
      name: "Flavio");

  static List<Account> allAccount = [account1, account2];

  static Map<House, List<Account>> houseMap = {
    house1: [account1, account2]
  };

  // cleaning

  static CleaningItem cleaning1 = CleaningItem(
      title: 'Pulizia cucina',
      expiration: DateTime.now().subtract(Duration(days: 7)),
      isDone: false,
      creationDate: DateTime.now());

  static CleaningItem cleaning2 = CleaningItem(
      title: 'Pulire bagno',
      expiration: DateTime.now(),
      isDone: false,
      creationDate: DateTime.now());

  static CleaningItem cleaning3 = CleaningItem(
      title: 'Pulire soggiorno',
      expiration: DateTime.now(),
      isDone: false,
      creationDate: DateTime.now());

  static Map<Account, List<CleaningItem>> accountCleaningMap = {
    account1: [cleaning1],
    account2: [cleaning1, cleaning2, cleaning3],
  };

  // shopping

  static ShoppingItem shopping1 =
      ShoppingItem(title: "Pane", buyer: Account(), isComplete: false);

  static ShoppingItem shopping2 = ShoppingItem(
      title: "Detersivo piatti", buyer: Account(), isComplete: false);

  static ShoppingItem shopping3 =
      ShoppingItem(title: "Verdura", buyer: Account(), isComplete: false);

  static ShoppingItem shopping4 =
      ShoppingItem(title: "Carne", buyer: Account(), isComplete: false);

  static Map<House, List<ShoppingItem>> homeShopping = {
    house1: [shopping1, shopping2, shopping3, shopping4]
  };
}
