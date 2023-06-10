import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeexpensecalculator/data/models/services_model.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_context.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_date_time.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_int.dart';
import 'package:homeexpensecalculator/helpers/extensions/ext_on_string.dart';
import 'package:homeexpensecalculator/helpers/functions/context_menu.dart';
import 'package:homeexpensecalculator/helpers/functions/date_picker.dart';
import 'package:homeexpensecalculator/helpers/functions/dialogues.dart';
import 'package:homeexpensecalculator/helpers/functions/input_formatters.dart';
import 'package:homeexpensecalculator/helpers/mixins/field_validations.dart';
import 'package:homeexpensecalculator/providers/services/services_provider.dart';
import 'package:homeexpensecalculator/utils/app_enum.dart';
import 'package:homeexpensecalculator/utils/app_icons.dart';
import 'package:homeexpensecalculator/widgets/common_scaffold.dart';
import 'package:homeexpensecalculator/widgets/slidable_widget.dart';
import 'package:provider/provider.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends CommonScaffold<ServicesView>
    with FieldValidationMixin {
  final TextEditingController titleTextController = TextEditingController();
  final GlobalKey<FormState> titleFieldFormKey = GlobalKey<FormState>();
  final TextEditingController amountTextController = TextEditingController();
  final GlobalKey<FormState> amountFieldFormKey = GlobalKey<FormState>();
  final TextEditingController startDateTextController = TextEditingController();
  final GlobalKey<FormState> startDateFieldFormKey = GlobalKey<FormState>();
  final TextEditingController endDateTextController = TextEditingController();
  final GlobalKey<FormState> endDateFieldFormKey = GlobalKey<FormState>();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    context.read<ServicesProvider>().viewModelInitState();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    amountTextController.dispose();
    startDateTextController.dispose();
    endDateTextController.dispose();
    context.read<ServicesProvider>().viewModelDisposeState();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => Column(
        children: <Widget>[
          _topEarningCard(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Consumer<ServicesProvider>(
                      builder: (_, ServicesProvider viewModel, __) => _section(
                          serviceType: ServiceType.expense,
                          amount: viewModel.totalExpenses)),
                  const SizedBox(height: 16),
                  Consumer<ServicesProvider>(
                      builder: (_, ServicesProvider viewModel, __) => _section(
                          serviceType: ServiceType.savings,
                          amount: viewModel.totalSavings)),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _topEarningCard() {
    final int earnings = context.read<ServicesProvider>().earnings;
    final int balance = context.read<ServicesProvider>().balance;

    final Color balanceStatusColor = balance < 0
        ? Colors.redAccent
        : balance < earnings.to10Percent
            ? Colors.amberAccent
            : balance < earnings.to15Percent
                ? Colors.yellowAccent
                // above 15 percent
                : Colors.greenAccent;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.blue[800]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: "Earning: ",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            TextSpan(
              text: earnings.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
          ])),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color:
                    balanceStatusColor, // TODO: add green accent and red accent
              ),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: "Balance: ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                TextSpan(
                  text: balance.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({required ServiceType serviceType, required int amount}) =>
      _servicesHeader(
        key: GlobalKey(),
        isExpenses: serviceType == ServiceType.expense,
        title: serviceType == ServiceType.expense ? "Expenses" : "Savings",
        totalAmount: amount,
        addOnPressed: () async {
          await _showAddDialogue(isExpenses: true);
        },
        editListOnPressed: () => _editListOnPressed(serviceType),
        ediListIconColor: _editListIconColor(serviceType),
        child: serviceType == ServiceType.expense
            ? _expensesListView()
            : _savingsListView(),
      );

  Widget _expensesListView() {
    final List<ServicesModel> expensesList =
        context.watch<ServicesProvider>().expensesList;

    return ReorderableListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: expensesList.length,
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) newIndex -= 1;
        context
            .read<ServicesProvider>()
            .reOrderExpensesList(oldIndex, newIndex);
      },
      itemBuilder: (BuildContext context, int index) {
        final ServicesModel service = expensesList[index];
        return SlidableWidget(
          key: Key('$index'),
          leftBtnOnPressed: (_) async {
            await _editExpensesService(service, index);
          },
          rightBtnOnPressed: (_) => context
              .read<ServicesProvider>()
              .deleteServiceFromExpensesList(service),
          child: _individualService(
              service: service,
              index: index,
              onLongPressStart: context
                      .read<ServicesProvider>()
                      .reOrderExpensesListStatus
                  ? null
                  : (LongPressStartDetails longPressPosition) async {
                      await ContextMenu.showServicesContextMenu(
                        context,
                        offset: longPressPosition.globalPosition,
                        isExpenses: true,
                        favOnTap: () {
                          // TODO: implement fav functionality
                        },
                        editOnTap: () async {
                          FocusScope.of(context).unfocus();
                          Future<void>.delayed(Duration.zero,
                              () async => _editExpensesService(service, index));
                        },
                        commentOnTap: () {
                          // TODO: implement add comment functionality
                        },
                        moveToOnTap: () {
                          FocusScope.of(context).unfocus();
                          Future<void>.delayed(
                              Duration.zero,
                              () => context
                                  .read<ServicesProvider>()
                                  .addServiceToSavingsList(service));
                        },
                        deleteOnTap: () => context
                            .read<ServicesProvider>()
                            .deleteServiceFromExpensesList(service),
                      );
                    }),
        );
      },
    );
  }

  Widget _savingsListView() {
    final List<ServicesModel> savingsList =
        context.watch<ServicesProvider>().savingsList;

    return ReorderableListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: savingsList.length,
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) newIndex -= 1;
        context.read<ServicesProvider>().reOrderSavingsList(oldIndex, newIndex);
      },
      itemBuilder: (BuildContext context, int index) {
        final ServicesModel service = savingsList[index];
        return SlidableWidget(
            key: Key('$index'),
            leftBtnOnPressed: (_) async {
              await _editSavingsService(service, index);
            },
            rightBtnOnPressed: (_) => context
                .read<ServicesProvider>()
                .deleteServiceFromSavingsList(service),
            child: _individualService(
                service: service,
                index: index,
                onLongPressStart:
                    context.read<ServicesProvider>().reOrderSavingsListStatus
                        ? null
                        : (LongPressStartDetails longPressPosition) async {
                            await ContextMenu.showServicesContextMenu(
                              context,
                              offset: longPressPosition.globalPosition,
                              isExpenses: false,
                              favOnTap: () {
                                // TODO: implement fav functionality
                              },
                              editOnTap: () async {
                                FocusScope.of(context).unfocus();
                                Future<void>.delayed(
                                    Duration.zero,
                                    () async =>
                                        _editSavingsService(service, index));
                              },
                              commentOnTap: () {
                                // TODO: implement add comment functionality
                              },
                              moveToOnTap: () {
                                FocusScope.of(context).unfocus();
                                Future<void>.delayed(
                                    Duration.zero,
                                    () => context
                                        .read<ServicesProvider>()
                                        .addServiceToExpensesList(service));
                              },
                              deleteOnTap: () => context
                                  .read<ServicesProvider>()
                                  .deleteServiceFromSavingsList(service),
                            );
                          }));
      },
    );
  }

  Future<void> _showAddDialogue(
          {required bool isExpenses, bool isEdit = false, int? index}) async =>
      Dialogue.showAlertDialogue(
        context,
        title:
            "${isEdit ? "Edit" : "Add"} ${isExpenses ? 'Expenses' : 'Savings'}",
        mainContent: _addItemsWidget(),
        onCancel: (BuildContext ctx) {
          ctx.pop();
          _clearAllValues();
        },
        actionBtnTitle: isEdit ? "Save" : "Add",
        onAction: (BuildContext ctx) {
          if (!_allFieldsValidationStatus()) return;
          // else all fields are valid
          final ServicesModel service = ServicesModel(
            serviceType: isExpenses ? ServiceType.expense : ServiceType.savings,
            name: titleTextController.text,
            cost: amountTextController.text.toInt,
            startDate: startDate!,
            endDate: endDate!,
            comment: '',
          );
          if (isEdit) {
            if (isExpenses) {
              context
                  .read<ServicesProvider>()
                  .updateExpensesService(service, index!);
            } else {
              context
                  .read<ServicesProvider>()
                  .updateSavingsService(service, index!);
            }
          } else {
            // else adding new service
            context.read<ServicesProvider>().addService(service);
          }
          ctx.pop();
        },
      );

  Widget _addItemsWidget() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
            key: titleFieldFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: titleTextController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (String? title) => emptyValidation(title),
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: amountFieldFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: amountTextController,
              inputFormatters: <TextInputFormatter>[
                OnlyNumberInputFormatter(),
              ],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Amount'),
              validator: (String? amount) => emptyValidation(amount),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: startDateFieldFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: startDateTextController,
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: 'Start Date',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await _setStartDate();
                          },
                          icon: AppIcons.date,
                        )),
                    onTap: () async {
                      await _setStartDate();
                    },
                    validator: (String? startDate) =>
                        emptyValidation(startDate),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Form(
                  key: endDateFieldFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: endDateTextController,
                    readOnly: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        hintText: 'End Date',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await _setEndDate();
                          },
                          icon: AppIcons.date,
                        )),
                    onTap: () async {
                      await _setEndDate();
                    },
                    validator: (String? endDate) => emptyValidation(endDate),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _servicesHeader({
    required String title,
    required int totalAmount,
    required Function()? addOnPressed,
    required Function()? editListOnPressed,
    required Widget child,
    required bool isExpenses,
    required GlobalKey<State<StatefulWidget>> key,
    Color? ediListIconColor,
  }) {
    final ServicesProvider viewModel = context.watch<ServicesProvider>();
    final bool isExpanded = isExpenses
        ? viewModel.expensesListExpanded
        : viewModel.savingsListExpanded;

    return ExpansionTile(
      key: key,
      controlAffinity: ListTileControlAffinity.trailing,
      initiallyExpanded: isExpanded,
      onExpansionChanged: (bool isExpanded) {
        final ServicesProvider provider = context.read<ServicesProvider>();
        if (isExpenses) {
          provider.setExpensesListExpandedStatus(isExpanded);
        } else {
          provider.setSavingsListExpandedStatus(isExpanded);
        }
      },
      title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // TODO: implement header edit
                    },
                    icon: AppIcons.editGrey300)
              ],
            ),
            RichText(
                text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: "Total: ",
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                    text: totalAmount.toString(),
                    style: Theme.of(context).textTheme.bodyMedium),
                const TextSpan(text: "   "),
              ],
            )),
          ]),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: "Add a service",
            splashRadius: 12,
            onPressed: addOnPressed,
            icon: CircleAvatar(
                backgroundColor: Colors.grey[300], child: AppIcons.add),
          ),
          IconButton(
              tooltip: "Reorder list",
              splashRadius: 12,
              onPressed: editListOnPressed,
              icon: CircleAvatar(
                backgroundColor: ediListIconColor,
                child: AppIcons.list,
              )),
          IconButton(
              tooltip: "show/hide list",
              splashRadius: 12,
              onPressed: () {
                final ServicesProvider provider =
                    context.read<ServicesProvider>();
                if (isExpenses) {
                  provider.setExpensesListExpandedStatus(
                      !provider.expensesListExpanded);
                } else {
                  provider.setSavingsListExpandedStatus(
                      !provider.savingsListExpanded);
                }
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: isExpenses
                    ? viewModel.expensesListExpanded
                        ? AppIcons.up
                        : AppIcons.down
                    : viewModel.savingsListExpanded
                        ? AppIcons.up
                        : AppIcons.down,
              )),
        ],
      ),
      children: <Widget>[child],
    );
  }

  Widget _individualService({
    required ServicesModel service,
    required int index,
    required Function(LongPressStartDetails)? onLongPressStart,
  }) =>
      GestureDetector(
        onLongPressStart: onLongPressStart,
        child: ListTile(
          leading: Text(index.toString()),
          title: Text(
            service.name,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          subtitle: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Start: ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                TextSpan(text: '${service.startDate.formattedMonth}  '),
                const TextSpan(
                  text: 'End: ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                TextSpan(
                  text: service.endDate.formattedMonth,
                ),
              ],
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Amount',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                service.cost.toString(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      );

  @override
  Widget? bottomNavBar() => FractionallySizedBox(
        heightFactor: 0.1,
        widthFactor: 1,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(width: 20),
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {},
                      child: const Text("Cancel"))),
              const SizedBox(width: 20),
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {},
                      child: const Text("Save"))),
              const SizedBox(width: 20),
            ],
          ),
        ),
      );

  void _editListOnPressed(ServiceType serviceType) {
    final ServicesProvider viewModel = context.read<ServicesProvider>();
    // reorder functionality
    if (serviceType == ServiceType.expense) {
      viewModel
          .setReOrderExpensesListStatus(!viewModel.reOrderExpensesListStatus);
    } else {
      // this is for savings
      viewModel
          .setReOrderSavingsListStatus(!viewModel.reOrderSavingsListStatus);
    }
  }

  Color? _editListIconColor(ServiceType serviceType) {
    if (serviceType == ServiceType.expense) {
      return context.watch<ServicesProvider>().reOrderExpensesListStatus
          ? Colors.greenAccent
          : Colors.grey[300];
    } else {
      return context.watch<ServicesProvider>().reOrderSavingsListStatus
          ? Colors.greenAccent
          : Colors.grey[300];
    }
  }

  Future<void> _setStartDate() async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate = await DatePickerHelper.selectDate(context);
    if (pickedDate == null) return;
    // else date picked
    final String formattedDate = pickedDate.formattedMonth;
    startDateTextController.text = formattedDate;
    startDate = pickedDate;
  }

  Future<void> _setEndDate() async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate = await DatePickerHelper.selectDate(context);
    if (pickedDate == null) return;
    // else date picked
    final String formattedDate = pickedDate.formattedMonth;
    endDateTextController.text = formattedDate;
    endDate = pickedDate;
  }

  bool _allFieldsValidationStatus() {
    if (!titleFieldFormKey.currentState!.validate()) return false;
    if (!amountFieldFormKey.currentState!.validate()) return false;
    if (!startDateFieldFormKey.currentState!.validate()) return false;
    if (!endDateFieldFormKey.currentState!.validate()) return false;
    return true;
  }

  void _clearAllValues() {
    titleTextController.clear();
    amountTextController.clear();
    startDateTextController.clear();
    endDateTextController.clear();
    startDate ??= null;
    endDate ??= null;
  }

  Future<void> _editExpensesService(ServicesModel service, int index) async {
    _setValues(service);
    await _showAddDialogue(isExpenses: true, isEdit: true, index: index);
  }

  Future<void> _editSavingsService(ServicesModel service, int index) async {
    _setValues(service);
    await _showAddDialogue(isExpenses: false, isEdit: true, index: index);
  }

  void _setValues(ServicesModel service) {
    titleTextController.text = service.name;
    amountTextController.text = service.cost.toString();
    startDateTextController.text = service.startDate.formattedMonth;
    endDateTextController.text = service.endDate.formattedMonth;
    startDate = service.startDate;
    endDate = service.endDate;
  }
}
