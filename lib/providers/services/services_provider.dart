import 'package:flutter/material.dart';
import 'package:homeexpensecalculator/data/models/services_model.dart';
import 'package:homeexpensecalculator/data/storage/expenses_storage_operations.dart';
import 'package:homeexpensecalculator/data/storage/individual_service_model_storage.dart';
import 'package:homeexpensecalculator/data/storage/storage_operations.dart';
import 'package:homeexpensecalculator/utils/app_enum.dart';
import 'package:sqflite/sqlite_api.dart';

class ServicesProvider extends ChangeNotifier {
  final List<ServicesModel> _savingsList = <ServicesModel>[
    ServicesModel(
      id: 0,
      serviceType: ServiceType.savings,
      name: "Saravana Stores Gold Savings",
      cost: 5000,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      comment: '',
    ),
    ServicesModel(
      id: 0,
      serviceType: ServiceType.savings,
      name: "RD",
      cost: 10000,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      comment: '',
    ),
    ServicesModel(
      id: 0,
      serviceType: ServiceType.savings,
      name: "Stocks",
      cost: 200,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      comment: '',
    ),
  ];
  List<ServicesModel> get savingsList => _savingsList;

  final List<ServicesModel> _expensesList = <ServicesModel>[];

  List<ServicesModel> get expensesList => _expensesList;

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
    database = await DatabaseOperations.db();
    await getExpensesListFromStorage();
    addAmount();
  }

  Future<void> getExpensesListFromStorage() async {
    final List<IndividualServiceModel> listFromStorage =
        await ExpensesStorageOperations.getAllExpenses();
    final List<ServicesModel> valueList = listFromStorage
        .map((IndividualServiceModel e) => ServicesModel(
            id: e.id ?? 0,
            serviceType: ServiceType.expense,
            name: e.name,
            cost: e.cost,
            startDate: e.startDate,
            endDate: e.endDate,
            comment: e.comment))
        .toList();
    _expensesList.addAll(valueList);
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
    final List<ServicesModel> expensesList = _expensesList;

    final List<ServicesModel> savingsList = _savingsList;
    _totalExpenses = 0;
    _balance = 0;
    for (ServicesModel service in expensesList) {
      _totalExpenses += service.cost;
    }
    _totalSavings = 0;
    for (ServicesModel service in savingsList) {
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

  Future<void> addService(ServicesModel service) async {
    if (service.serviceType == ServiceType.expense) {
      _expensesList.add(service);
      addTotalExpenses(service.cost);
      await ExpensesStorageOperations.addExpenses(IndividualServiceModel(
        type: 1,
        name: service.name,
        startDate: service.startDate,
        endDate: service.endDate,
        comment: service.comment,
        cost: service.cost,
      ));
    } else {
      _savingsList.add(service);
      addTotalSavings(service.cost);
    }
    notifyListeners();
  }

  void reOrderExpensesList(int oldIndex, int newIndex) {
    final ServicesModel service = _expensesList.removeAt(oldIndex);
    _expensesList.insert(newIndex, service);
    notifyListeners();
  }

  void reOrderSavingsList(int oldIndex, int newIndex) {
    final ServicesModel service = _savingsList.removeAt(oldIndex);
    _savingsList.insert(newIndex, service);
    notifyListeners();
  }

  Future<void> deleteServiceFromExpensesList(ServicesModel service) async {
    _expensesList.remove(service);
    await ExpensesStorageOperations.deleteExpense(service.id);
    addAmount();
    notifyListeners();
  }

  void deleteServiceFromSavingsList(ServicesModel service) {
    _savingsList.remove(service);
    addAmount();
    notifyListeners();
  }

  Future<void> updateExpensesService(ServicesModel service, int index) async {
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

  void updateSavingsService(ServicesModel service, int index) {
    _savingsList
      ..removeAt(index)
      ..insert(index, service);
    addAmount();
    notifyListeners();
  }

  Future<void> addServiceToExpensesList(ServicesModel service) async {
    _savingsList.remove(service);
    _expensesList.insert(0, service);
    addAmount();
    notifyListeners();
  }

  void addServiceToSavingsList(ServicesModel service) {
    _expensesList.remove(service);
    _savingsList.insert(0, service);
    addAmount();
    notifyListeners();
  }
}
