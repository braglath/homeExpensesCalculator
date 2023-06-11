import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homeexpensecalculator/data/models/individual_service_model.dart';
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
import 'package:homeexpensecalculator/utils/app_constants.dart';
import 'package:homeexpensecalculator/utils/app_enum.dart';
import 'package:homeexpensecalculator/utils/app_icons.dart';
import 'package:homeexpensecalculator/utils/asset_paths.dart';
import 'package:homeexpensecalculator/widgets/common_elevated_button.dart';
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

  final ScrollController scrollController = ScrollController();
  final DropdownController dropDownController = DropdownController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        context.read<ServicesProvider>().setIsAppBarExpanded(true);
      } else {
        context.read<ServicesProvider>().setIsAppBarExpanded(false);
      }
    });
    // ignore: discarded_futures
    context.read<ServicesProvider>().viewModelInitState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleTextController.dispose();
    amountTextController.dispose();
    startDateTextController.dispose();
    endDateTextController.dispose();
    dropDownController.dispose();
    context.read<ServicesProvider>().viewModelDisposeState();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            leading: IconButton(
                onPressed: () {
                  //TODO: implement back press
                },
                icon: AppIcons.backIcon),
            expandedHeight: 225,
            elevation: 8,
            scrolledUnderElevation: 8,
            title: const Text("Balance"),
            actions: <Widget>[
              _participantsDropDown(),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedCrossFade(
                  firstChild: _balanceCard(context),
                  secondChild: SizedBox.fromSize(),
                  crossFadeState:
                      context.watch<ServicesProvider>().isAppBarExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 500)),

              centerTitle: true,
              // _topEarningCard(),
              background: Image.asset(
                AssetPaths.homeSetup,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Consumer<ServicesProvider>(
                builder: (_, ServicesProvider viewModel, __) => _section(
                    serviceType: ServiceType.expense,
                    amount: viewModel.totalExpenses)),
          ),
          // ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: Consumer<ServicesProvider>(
                builder: (_, ServicesProvider viewModel, __) => _section(
                    serviceType: ServiceType.savings,
                    amount: viewModel.totalSavings)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 25)),
        ],
      );

  Padding _participantsDropDown() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: CoolDropdown<int>(
          controller: dropDownController,
          dropdownList:
              context.watch<ServicesProvider>().participantsDropDownList,
          defaultItem:
              context.watch<ServicesProvider>().participantsDropDownList[0],
          onChange: (int value) async {
            if (dropDownController.isError) {
              await dropDownController.resetError();
            }
            dropDownController.close();
          },
          onOpen: null,
          resultOptions: ResultOptions(
            boxDecoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Color(0x1a9E9E9E),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 1))
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            icon: const SizedBox(
              width: 10,
              height: 10,
              child: CustomPaint(
                painter: DropdownArrowPainter(color: Colors.blue),
              ),
            ),
            render: ResultRender.all,
          ),
          dropdownOptions: const DropdownOptions(
              gap: DropdownGap.all(5),
              borderSide: BorderSide(width: 1, color: Colors.blueAccent),
              padding: EdgeInsets.symmetric(horizontal: 10),
              align: DropdownAlign.left,
              animationType: DropdownAnimationType.size),
          dropdownItemOptions: DropdownItemOptions(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              render: DropdownItemRender.all,
              height: 50,
              selectedBoxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.blue),
              selectedPadding: const EdgeInsets.symmetric(horizontal: 12),
              selectedTextStyle: const TextStyle(color: Colors.white)),
        ),
      );

  Container _balanceCard(BuildContext context) {
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[400]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
              text: TextSpan(children: <TextSpan>[
            const TextSpan(text: "Earning: "),
            TextSpan(
              text: earnings.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ])),
          AppConstants.height10,
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
                const TextSpan(text: "Balance: "),
                TextSpan(
                  text: balance.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
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
    final List<IndividualServiceModel> expensesList =
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
        final IndividualServiceModel service = expensesList[index];

        return SlidableWidget(
          key: Key('$index'),
          leftBtnOnPressed: (_) async {
            await _editExpensesService(service, index);
          },
          rightBtnOnPressed: (_) async => context
              .read<ServicesProvider>()
              .deleteServiceFromExpensesList(service),
          child: Column(
            children: <Widget>[
              if (index != expensesList.length && index != 0) const Divider(),
              _individualService(
                  service: service,
                  index: index,
                  tileColor:
                      context.read<ServicesProvider>().reOrderExpensesListStatus
                          ? Colors.grey[200]
                          : null,
                  onLongPressStart:
                      context.read<ServicesProvider>().reOrderExpensesListStatus
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
                                  Future<void>.delayed(
                                      Duration.zero,
                                      () async =>
                                          _editExpensesService(service, index));
                                },
                                commentOnTap: () {
                                  // TODO: implement add comment functionality
                                },
                                moveToOnTap: () {
                                  FocusScope.of(context).unfocus();
                                  Future<void>.delayed(
                                      Duration.zero,
                                      () async => context
                                          .read<ServicesProvider>()
                                          .moveServiceToSavingsList(service));
                                },
                                deleteOnTap: () async => context
                                    .read<ServicesProvider>()
                                    .deleteServiceFromExpensesList(service),
                              );
                            }),
            ],
          ),
        );
      },
    );
  }

  Widget _savingsListView() {
    final List<IndividualServiceModel> savingsList =
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
        final IndividualServiceModel service = savingsList[index];
        return SlidableWidget(
            key: Key('$index'),
            leftBtnOnPressed: (_) async {
              await _editSavingsService(service, index);
            },
            rightBtnOnPressed: (_) async => context
                .read<ServicesProvider>()
                .deleteServiceFromSavingsList(service),
            child: Column(
              children: <Widget>[
                if (index != savingsList.length && index != 0) const Divider(),
                _individualService(
                    service: service,
                    index: index,
                    tileColor: context
                            .read<ServicesProvider>()
                            .reOrderSavingsListStatus
                        ? Colors.grey[200]
                        : null,
                    onLongPressStart: context
                            .read<ServicesProvider>()
                            .reOrderSavingsListStatus
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
                              moveToOnTap: () async {
                                FocusScope.of(context).unfocus();
                                Future<void>.delayed(
                                    Duration.zero,
                                    () async => context
                                        .read<ServicesProvider>()
                                        .moveServiceToExpensesList(service));
                              },
                              deleteOnTap: () async => context
                                  .read<ServicesProvider>()
                                  .deleteServiceFromSavingsList(service),
                            );
                          }),
              ],
            ));
      },
    );
  }

  Future<void> _showAddDialogue(
          {required bool isExpenses,
          bool isEdit = false,
          int? index,
          int? id}) async =>
      Dialogue.showAlertDialogue(
        context,
        title:
            "${isEdit ? "Edit" : "Add"} ${isExpenses ? 'Expenses' : 'Savings'}",
        mainContent: _addItemsWidget(isEdit),
        onCancel: (BuildContext ctx) {
          ctx.pop();
          _clearAllValues();
        },
        actionBtnTitle: isEdit ? "Save" : "Add",
        onAction: (BuildContext ctx) async {
          if (!_allFieldsValidationStatus()) return;
          // else all fields are valid
          final IndividualServiceModel service = IndividualServiceModel(
            id: id ?? 0,
            type: isExpenses ? 1 : 2,
            name: titleTextController.text,
            cost: amountTextController.text.toInt,
            startDate: startDate!,
            endDate: endDate!,
            comment: '',
          );
          if (isEdit) {
            if (isExpenses) {
              await context
                  .read<ServicesProvider>()
                  .updateExpensesService(service, index!);
            } else {
              await context
                  .read<ServicesProvider>()
                  .updateSavingsService(service, index!);
            }
          } else {
            // else adding new service
            await context.read<ServicesProvider>().addService(service);
          }
          if (mounted) await ctx.pop();

          Future<dynamic>.delayed(
              const Duration(milliseconds: 200), () => _clearAllValues());
        },
      );

  Widget _addItemsWidget(bool isEditService) => Column(
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
              validator: (String? title) => isEditService
                  ? emptyValidation(title)
                  : checkServiceAlreadyExists(
                      title,
                      List<IndividualServiceModel>.from(<
                          IndividualServiceModel>[
                        ...context.read<ServicesProvider>().expensesList,
                        ...context.read<ServicesProvider>().savingsList
                      ])),
            ),
          ),
          AppConstants.height10,
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
          AppConstants.height10,
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
                            await _setEndDate(firstDate: startDate);
                          },
                          icon: AppIcons.date,
                        )),
                    onTap: () async {
                      await _setEndDate(firstDate: startDate);
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

  Widget _individualService(
          {required IndividualServiceModel service,
          required int index,
          required Function(LongPressStartDetails)? onLongPressStart,
          required Color? tileColor}) =>
      GestureDetector(
        onLongPressStart: onLongPressStart,
        child: ListTile(
          tileColor: tileColor,
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
  Widget? bottomNavBar() => SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(width: 20),
            CommonElevatedButton(
              text: 'Cancel',
              color: Colors.deepOrange,
              onTap: () {},
            ),
            const SizedBox(width: 20),
            CommonElevatedButton(
              text: 'Save',
              onTap: () {},
            ),
            const SizedBox(width: 20),
          ],
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

  Future<void> _setEndDate({required DateTime? firstDate}) async {
    FocusScope.of(context).unfocus();
    final DateTime? pickedDate =
        await DatePickerHelper.selectDate(context, firstDate);
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

  Future<void> _editExpensesService(
      IndividualServiceModel service, int index) async {
    _setValues(service);
    await _showAddDialogue(
        isExpenses: true, isEdit: true, index: index, id: service.id);
  }

  Future<void> _editSavingsService(
      IndividualServiceModel service, int index) async {
    _setValues(service);
    await _showAddDialogue(isExpenses: false, isEdit: true, index: index);
  }

  void _setValues(IndividualServiceModel service) {
    titleTextController.text = service.name;
    amountTextController.text = service.cost.toString();
    startDateTextController.text = service.startDate.formattedMonth;
    endDateTextController.text = service.endDate.formattedMonth;
    startDate = service.startDate;
    endDate = service.endDate;
  }
}
