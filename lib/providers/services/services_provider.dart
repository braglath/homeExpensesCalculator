import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/data/models/participant_model.dart';
import 'package:homeexpensecalculator/data/storage/expenses_storage_operations.dart';
import 'package:homeexpensecalculator/data/models/individual_service_model.dart';
import 'package:homeexpensecalculator/data/storage/savings_storage_operations.dart';
import 'package:homeexpensecalculator/data/storage/storage_operations.dart';
import 'package:sqflite/sqlite_api.dart';

class ServicesProvider extends ChangeNotifier {
  final List<IndividualServiceModel> _savingsList = <IndividualServiceModel>[];
  List<IndividualServiceModel> get savingsList => _savingsList;

  final List<IndividualServiceModel> _expensesList = <IndividualServiceModel>[];
  List<IndividualServiceModel> get expensesList => _expensesList;

  final List<ParticipantModel> _participantsList = <ParticipantModel>[
    ParticipantModel(
      homeCode: 'testHome',
      id: 0,
      isAdmin: 0,
      name: 'Braglath',
      image:
          'https://cdn.pixabay.com/photo/2014/04/03/10/32/businessman-310819_1280.png',
      phonenumber: '8939243462',
      income: 74000,
      addedOn: DateTime.now(),
    ),
    ParticipantModel(
      homeCode: 'testHome',
      id: 1,
      isAdmin: 1,
      name: 'Santhiya',
      image:
          'https://cdn.pixabay.com/photo/2021/07/19/04/36/woman-6477171_1280.jpg',
      phonenumber: '9840620323',
      income: 19000,
      addedOn: DateTime.now(),
    ),
    ParticipantModel(
      homeCode: 'testHome',
      id: 2,
      isAdmin: 1,
      name: 'Aarush Anjan',
      image: '',
      phonenumber: '9840620323',
      income: 0,
      addedOn: DateTime.now(),
    ),
  ];
  List<ParticipantModel> get participantsList => _participantsList;

  List<CoolDropdownItem<int>> participantsDropDownList =
      <CoolDropdownItem<int>>[];

  bool _isAppBarExpanded = true;
  bool get isAppBarExpanded => _isAppBarExpanded;

  final int _earnings = 74000;
  int get earnings => _earnings;
  int _balance = 0;
  int get balance => _balance;

  int _totalExpenses = 0;
  int get totalExpenses => _totalExpenses;

  int _totalSavings = 0;
  int get totalSavings => _totalSavings;

  bool _reOrderExpensesListStatus = false;
  bool get reOrderExpensesListStatus => _reOrderExpensesListStatus;

  bool _reOrderSavingsListStatus = false;
  bool get reOrderSavingsListStatus => _reOrderSavingsListStatus;

  bool _expensesListExpanded = true;
  bool get expensesListExpanded => _expensesListExpanded;
  bool _savingsListExpanded = true;
  bool get savingsListExpanded => _savingsListExpanded;

  Database? database;

  Future<void> viewModelInitState() async {
    addParticipantsToDropDownList();
    database = await DatabaseOperations.db();
    await getExpensesListFromStorage();
    await getSavingsListFromStorage();
    addAmount();
  }

  void addParticipantsToDropDownList() {
    for (ParticipantModel participant in _participantsList) {
      participantsDropDownList.add(
        CoolDropdownItem<int>(
            label: participant.name,
            icon: SizedBox(
              height: 25,
              width: 25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  participant.image,
                  errorBuilder: (_, __, ___) => CircleAvatar(
                    backgroundColor: Colors.grey[300],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            value: participant.id),
      );
    }
  }

  void setIsAppBarExpanded(bool status) {
    _isAppBarExpanded = status;
    notifyListeners();
  }

  Future<void> getExpensesListFromStorage() async {
    final List<IndividualServiceModel> listFromStorage =
        await ExpensesStorageOperations.getAllExpenses();
    final List<IndividualServiceModel> valueList = listFromStorage;
    _expensesList.addAll(valueList);
    notifyListeners();
  }

  Future<void> getSavingsListFromStorage() async {
    final List<IndividualServiceModel> listFromStorage =
        await SavingsStorageOperations.getAllSavings();
    final List<IndividualServiceModel> valueList = listFromStorage;
    _savingsList.addAll(valueList);
    notifyListeners();
  }

  void setExpensesListExpandedStatus(bool isExpanded) {
    _expensesListExpanded = isExpanded;
    notifyListeners();
  }

  void setSavingsListExpandedStatus(bool isExpanded) {
    _savingsListExpanded = isExpanded;
    notifyListeners();
  }

  void setReOrderExpensesListStatus(bool status) {
    _reOrderExpensesListStatus = status;
    notifyListeners();
  }

  void setReOrderSavingsListStatus(bool status) {
    _reOrderSavingsListStatus = status;
    notifyListeners();
  }

  void viewModelDisposeState() {
    _totalExpenses = 0;
    _totalSavings = 0;
  }

  void addAmount() {
    final List<IndividualServiceModel> expensesList = _expensesList;

    final List<IndividualServiceModel> savingsList = _savingsList;
    _totalExpenses = 0;
    _balance = 0;
    for (IndividualServiceModel service in expensesList) {
      _totalExpenses += service.cost;
    }
    _totalSavings = 0;
    for (IndividualServiceModel service in savingsList) {
      _totalSavings += service.cost;
    }
    _balance = earnings - (_totalExpenses + _totalSavings);
  }

  void addTotalExpenses(int amount) {
    _totalExpenses += amount;
    notifyListeners();
  }

  void minusTotalExpenses(int amount) {
    _totalExpenses -= amount;
    notifyListeners();
  }

  void addTotalSavings(int amount) {
    _totalSavings += amount;
    notifyListeners();
  }

  void minusTotalSavings(int amount) {
    _totalSavings -= amount;
    notifyListeners();
  }

  Future<void> addService(IndividualServiceModel service) async {
    final IndividualServiceModel newService = IndividualServiceModel(
      type: service.type,
      name: service.name,
      startDate: service.startDate,
      endDate: service.endDate,
      comment: service.comment,
      cost: service.cost,
    );
    if (service.type == 1) {
      await ExpensesStorageOperations.addExpenses(newService);
      _expensesList.add(service);
      addTotalExpenses(service.cost);
    } else {
      await SavingsStorageOperations.addSaving(newService);
      _savingsList.add(service);
      addTotalSavings(service.cost);
    }
    notifyListeners();
  }

  void reOrderExpensesList(int oldIndex, int newIndex) {
    final IndividualServiceModel service = _expensesList.removeAt(oldIndex);
    _expensesList.insert(newIndex, service);
    notifyListeners();
  }

  void reOrderSavingsList(int oldIndex, int newIndex) {
    final IndividualServiceModel service = _savingsList.removeAt(oldIndex);
    _savingsList.insert(newIndex, service);
    notifyListeners();
  }

  Future<void> deleteServiceFromExpensesList(
      IndividualServiceModel service) async {
    _expensesList.remove(service);
    if (service.id == null) return;
    await ExpensesStorageOperations.deleteExpense(service.id!);
    addAmount();
    notifyListeners();
  }

  Future<void> deleteServiceFromSavingsList(
      IndividualServiceModel service) async {
    if (service.id == null) return;
    final bool isDeleted =
        await SavingsStorageOperations.deleteSaving(service.id!);
    if (!isDeleted) return;
    _savingsList.remove(service);
    addAmount();
    notifyListeners();
  }

  Future<void> updateExpensesService(
      IndividualServiceModel service, int index) async {
    _expensesList
      ..removeAt(index)
      ..insert(index, service);
    await ExpensesStorageOperations.updateExpense(IndividualServiceModel(
      id: service.id,
      type: 1,
      name: service.name,
      startDate: service.startDate,
      endDate: service.endDate,
      comment: service.comment,
      cost: service.cost,
    ));
    addAmount();
    notifyListeners();
  }

  Future<void> updateSavingsService(
      IndividualServiceModel service, int index) async {
    if (service.id == null) return;
    await SavingsStorageOperations.updateSavings(service);
    _savingsList
      ..removeAt(index)
      ..insert(index, service);
    addAmount();
    notifyListeners();
  }

  Future<void> moveServiceToExpensesList(IndividualServiceModel service) async {
    if (service.id == null) return;
    final bool isDeleted =
        await SavingsStorageOperations.deleteSaving(service.id!);
    if (!isDeleted) return;
    await ExpensesStorageOperations.addExpenses(service);
    _savingsList.remove(service);
    _expensesList.insert(0, service);
    addAmount();
    notifyListeners();
  }

  Future<void> moveServiceToSavingsList(IndividualServiceModel service) async {
    if (service.id == null) return;
    final bool isDeleted =
        await ExpensesStorageOperations.deleteExpense(service.id!);
    if (!isDeleted) return;
    await SavingsStorageOperations.addSaving(service);
    _expensesList.remove(service);
    _savingsList.insert(0, service);
    addAmount();
    notifyListeners();
  }
}
