import 'package:flutter/material.dart';
import 'package:expense_tracker_task/src/presentation/bloc/expense_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  final List<String> monthYearOptions;

  ExpenseListScreen({super.key})
      : monthYearOptions = List.generate(50,
            (index) => DateFormat('MMMM yyyy').format(DateTime(DateTime.now().year, DateTime.now().month - index, 1)));

  @override
  Widget build(BuildContext context) {
    String selectedMonthYear = monthYearOptions.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text(
          'Expenses Tracker',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpensesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpensesLoaded) {
            double totalPrice = state.expenses.fold(0, (sum, expense) => sum + expense.amount);

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.today_outlined,
                      ),
                      onTap: () async {
                        final DateTimeRange? picked = await showDateRangePicker(
                            context: context, firstDate: DateTime(2000), lastDate: DateTime(2101));
                        if (picked != null) {
                          context
                              .read<ExpenseBloc>()
                              .add(FilterExpensesByDateEvent(startDate: picked.start, endDate: picked.end));
                        } else {
                          context.read<ExpenseBloc>().add(LoadExpensesEvent());
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration:
                          BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadiusDirectional.circular(8)),
                      child: DropdownButton<String>(
                        underline: const SizedBox(),
                        value: selectedMonthYear,
                        items: monthYearOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(option),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final selectedDate = DateFormat('MMMM yyyy').parse(value!);
                          final selectedMonth = selectedDate.month;
                          final selectedYear = selectedDate.year;
                          context.read<ExpenseBloc>().add(FilterExpensesByMonthEvent(
                                month: selectedMonth,
                                year: selectedYear,
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: state.expenses.isEmpty
                      ? Center(child: customText("Please add a task by tapping on below + button"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          shrinkWrap: true,
                          itemCount: state.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = state.expenses[index];
                            return Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              decoration: BoxDecoration(
                                  border: const Border(
                                    left: BorderSide(width: 5.0, color: Color(0xff1E346F)),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffEDF3FF)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(width: 10, color: const Color(0xff1E346F)),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300, borderRadius: BorderRadiusDirectional.circular(8)),
                                    child: Text(
                                      DateFormat("dd MMM yy").format(state.expenses[index].date),
                                      style: const TextStyle(
                                          color: Color(0xff1E346F), fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.expenses[index].description.toString().toUpperCase(),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                        Text('\$${state.expenses[index].amount}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddExpenseScreen(isEdit: true, expense: expense)),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      radius: 12,
                                      child: const Icon(Icons.edit, color: Color(0xff1E346F), size: 15),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      context.read<ExpenseBloc>().add(DeleteExpenseEvent(key: expense.key));
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      radius: 12,
                                      child: const Icon(Icons.delete_rounded, color: Colors.red, size: 15),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          } else if (state is ExpensesLoadFailure) {
            return Center(child: customText('Failed to load expenses: ${state.error}'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1E346F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen(isEdit: false)),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  customText(text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xff1E346F), fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
}
