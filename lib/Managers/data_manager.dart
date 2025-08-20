import 'package:flutter/material.dart';
import '../Constructors/account.dart';
import '../Constructors/cleaning_item.dart';
import '../Constructors/event_item.dart';
import '../Constructors/house.dart';
import '../Constructors/shopping_item.dart';
import '../Data/sample_data.dart';

extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

class DataManager extends ChangeNotifier {
  final List<Account> _allAccounts = SampleData.allAccount;
  final Map<House, List<Account>> _houseMap = SampleData.houseMap;
  final Map<Account, List<CleaningItem>> _accountCleaningMap = SampleData.accountCleaningMap;
  final Map<Account, List<EventItem>> _accountEventMap = {};
  final Map<Account, List<ShoppingItem>> _accountShoppingMap = {};
  final Map<House, List<ShoppingItem>> _homeShopping = SampleData.homeShopping;

  List<Account> get allAccounts => _allAccounts;

  // settings
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  set darkMode(bool darkMode) {
    _darkMode = darkMode;
    notifyListeners();
  }

  void changeDarkMode() {
    darkMode = !darkMode;
  }

  // login
  Account? loginAccount;
  House? loginHouse;
  List<Account>? housemates;

  void setLoginAccountFromCredentials(String username, String password) {

    Account? loginAccountFromAccounts = _allAccounts.firstWhereOrNull(
          (account) => account.username == username && account.password == password,
    );

    if (loginAccountFromAccounts != null) {

      loginAccount = loginAccountFromAccounts;

      House? house = _houseMap.entries.firstWhereOrNull(
            (entry) => entry.value.contains(loginAccountFromAccounts),
      )?.key;

      loginHouse = house;

      housemates = loginHouse != null ? _houseMap[loginHouse!] ?? [] : [];

      notifyListeners();
    } else {
      throw Exception("Username o password non validi");
    }
  }





  void setLoginAccount(Account account) {
    loginAccount = account;
    loginHouse = _houseMap.entries.firstWhereOrNull(
          (entry) => entry.value.contains(loginAccount),
    )?.key;
    housemates = loginHouse != null ? _houseMap[loginHouse!] ?? [] : [];
    notifyListeners();
  }

  void resetLoginAccount() {
    loginAccount = null;
    loginHouse = null;
    housemates = null;
    notifyListeners();
  }

  void changePassword(String username, String newPassword) {
    Account? account = getAccountByUsername(username);
    if (account != null) {
      account.password = newPassword;
      notifyListeners();
    }
  }

  void changeAccountName(String username, String newName) {
    Account? account = getAccountByUsername(username);
    if (account != null) {
      account.name = newName;
      notifyListeners();
    }
  }

  // Account e case

  void changeHouseName(String username, String newName) {
    House? house = getHouseForAccount(getAccountByUsername(username)!);
    if (house != null) {
      house.title = newName;
      notifyListeners();
    }
  }

  bool addAccount(Account account) {
    if (_allAccounts.any((existingAccount) => existingAccount.username == account.username)) {
      return false;
    }

    _allAccounts.add(account);
    _accountCleaningMap[account] = [];
    notifyListeners();
    return true;
  }

  void addAccountToHouse(Account account, House house) {
    if (_houseMap.containsKey(house)) {
      _houseMap[house]?.add(account);
      notifyListeners();
    }
  }

  void toggleOnlineStatus(String username, bool isOnline) {
    final account = getAccountByUsername(username);
    if (account != null) {
      account.isOnline = isOnline;
      notifyListeners();
    }
  }

  void createHouseWithAccount(String houseName, Account account) {
    if (_allAccounts.contains(account)) {
      House newHouse = House(title: houseName);
      _houseMap[newHouse] = [account];
      notifyListeners();
    }
  }

  void addAccountToExistingHouse(String houseId, Account account) {
    House? house = _houseMap.keys.firstWhereOrNull((h) => h.id == houseId);
    if (house != null && _allAccounts.contains(account)) {
      _houseMap[house]?.add(account);
      notifyListeners();
    }
  }

  List<Account> getHousemates(String username) {
    if (housemates == null || housemates!.isEmpty) {
      return [];
    }

    Account? priorityAccount = housemates!.firstWhereOrNull((account) => account.username == username);

    if (priorityAccount != null) {
      housemates!.remove(priorityAccount);
      housemates!.insert(0, priorityAccount);
    }

    return housemates!;
  }


  House? getHouseForAccount(Account account) {
    return _houseMap.entries.firstWhereOrNull(
          (entry) => entry.value.contains(account),
    )?.key;
  }


  void removeHousemate(String username) {
    Account? account = getAccountByUsername(username);
    if (account != null && loginHouse != null) {
      _houseMap[loginHouse!]?.remove(account);
      notifyListeners();
    }
  }

  List<Account> getAccountsWithPriorityByUsername(String username, List<Account> accounts) {
    Account? priorityAccount = accounts.firstWhereOrNull((account) => account.username == username);

    if (priorityAccount != null) {
      accounts.remove(priorityAccount);
      accounts.insert(0, priorityAccount);
    }

    return accounts;
  }

  Account? getAccountByUsername(String username) {
    return _allAccounts.firstWhereOrNull(
          (account) => account.username == username,
    );
  }

  // cleaning

  List<CleaningItem> getCleaningForAccountByUsername(String username) {
    Account? account = getAccountByUsername(username);
    return _accountCleaningMap[account] ?? [];
  }

  void addCleaningForAccountByUsername(String username, CleaningItem cleaning) {
    Account? account = getAccountByUsername(username);
    if (account != null) {
      if (_accountCleaningMap.containsKey(account)) {
        _accountCleaningMap[account]!.insert(0, cleaning);
      } else {
        _accountCleaningMap[account] = [cleaning];
      }
      notifyListeners();
    }
  }

  void removeCleaningForAccountByUsername(String username, String id) {
    Account? account = getAccountByUsername(username);
    if (account != null && _accountCleaningMap.containsKey(account)) {
      _accountCleaningMap[account]!.removeWhere((cleaning) => cleaning.id == id);
      notifyListeners();
    }
  }

  void toggleCleaningItemCompleteById(String id) {
    var cleaningItem = _accountCleaningMap.values.expand((items) => items).firstWhereOrNull((item) => item.id == id);
    if (cleaningItem != null) {
      cleaningItem.isDone = !cleaningItem.isDone;
      cleaningItem.completeDate = DateTime.now();
      notifyListeners();
    }
  }

  // shopping

  void addShoppingForAccountByUsername(String? username, ShoppingItem shopping) {
    if (username == "Casa") {
      if (loginHouse != null) {
        _homeShopping[loginHouse!] = (_homeShopping[loginHouse!] ?? [])..insert(0, shopping);
      }
    } else {
      Account? account = getAccountByUsername(username!);
      if (account != null) {
        if (_accountShoppingMap.containsKey(account)) {
          _accountShoppingMap[account]!.insert(0, shopping);
        } else {
          _accountShoppingMap[account] = [shopping];
        }
      }
    }
    notifyListeners();
  }

  List<ShoppingItem> getShoppingForAccountByUsername(String username) {
    Account? account = getAccountByUsername(username);
    return _accountShoppingMap[account] ?? [];
  }

  List<ShoppingItem> getShoppingForHouse() {
    if (loginHouse == null) {
      return [];
    }
    return _homeShopping[loginHouse!] ?? [];
  }

  void removeShoppingItemById(String id, String listType) {
    if (listType == 'Lista casa') {
      if (loginHouse != null) {
        _homeShopping[loginHouse!]?.removeWhere((item) => item.id == id);
      }
    } else {
      List<ShoppingItem> items = getShoppingForAccountByUsername(loginAccount?.username ?? "");
      items.removeWhere((item) => item.id == id);
    }
    notifyListeners();
  }

  void toggleShoppingItemCompleteById(String id, String listType) {
    List<ShoppingItem> items;

    if (listType == 'Lista casa') {
      if (loginHouse != null) {
        items = _homeShopping[loginHouse!] ?? [];
      } else {
        items = [];
      }
    } else {
      items = getShoppingForAccountByUsername(loginAccount?.username ?? "");
    }

    var item = items.firstWhereOrNull((item) => item.id == id);
    if (item != null) {
      item.isComplete = !item.isComplete;
      if (loginAccount != null) {
        item.buyer = loginAccount!;
      }
      notifyListeners();
    }
  }

  void removeCompletedShoppingItems() {
    if (loginHouse != null) {
      _homeShopping[loginHouse!]?.removeWhere((item) => item.isComplete);
      notifyListeners();
    }
  }

  void clearAllShoppingLists() {
    if (loginHouse != null) {
      _homeShopping.clear();
    }
    if (loginAccount != null) {
      _accountShoppingMap[loginAccount!]?.clear();
    }
    notifyListeners();
  }


  // event

  List<EventItem> getEventsForAccountByUsername(String username) {
    Account? account = getAccountByUsername(username);
    return _accountEventMap[account] ?? [];
  }

  void addEventForAccountByUsername(String username, EventItem event) {
    Account? account = getAccountByUsername(username);
    if (account != null) {
      if (_accountEventMap.containsKey(account)) {
        _accountEventMap[account]!.insert(0, event);
      } else {
        _accountEventMap[account] = [event];
      }
      notifyListeners();
    }
  }

  void removeEventForAccountByUsername(String username, String id) {
    Account? account = getAccountByUsername(username);
    if (account != null && _accountEventMap.containsKey(account)) {
      _accountEventMap[account]!.removeWhere((event) => event.id == id);
      notifyListeners();
    }
  }
}

