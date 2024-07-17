
import 'package:bloc/bloc.dart';
import 'package:expense_tracker_task/src/data/models/expense_model.dart';
import 'package:hive/hive.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
   Box<Expense> expenseBox;

  List<Expense> _allExpenses = [];

  ExpenseBloc()
      : expenseBox = Hive.box<Expense>('expenses'),
        super(ExpensesLoading()) {
    on<LoadExpensesEvent>((event, emit) async {
      emit(ExpensesLoading());
      try {
        final expenses = expenseBox.values.toList();

        _allExpenses = expenses; // Store the original data
        _sortExpensesByDate();
        emit(ExpensesLoaded(expenses));
      } catch (e) {
        emit(ExpensesLoadFailure(e.toString()));
      }
    });

    on<AddExpenseEvent>((event, emit) async {
      try {
        await expenseBox.add(event.expense);
        final expenses = expenseBox.values.toList();
        _allExpenses = expenses; 
        _sortExpensesByDate();
        emit(ExpensesLoaded(expenses));
      } catch (e) {
        emit(ExpensesLoadFailure(e.toString()));
      }
    });

    on<EditExpenseEvent>((event, emit) async {
      try {
        await expenseBox.put(event.expense.key, event.expense);
        final expenses = expenseBox.values.toList();
        _allExpenses = expenses; 
        _sortExpensesByDate();
        emit(ExpensesLoaded(expenses));
      } catch (e) {
        emit(ExpensesLoadFailure(e.toString()));
      }
    });

    on<DeleteExpenseEvent>((event, emit) async {
      try {
        await expenseBox.delete(event.key);
        final expenses = expenseBox.values.toList();
        _allExpenses = expenses; 
        _sortExpensesByDate();
        emit(ExpensesLoaded(expenses));
      } catch (e) {
        emit(ExpensesLoadFailure(e.toString()));
      }
    });

    on<FilterExpensesByDateEvent>((event, emit) {
      final currentState = state;
      if (currentState is ExpensesLoaded) {
        final filteredExpenses = _allExpenses.where((expense) {
          return expense.date.isAfter(event.startDate) && expense.date.isBefore(event.endDate);
        }).toList();
        emit(ExpensesLoaded(filteredExpenses));
      }
    });
    on<FilterExpensesByMonthEvent>((event, emit) {
       final filteredExpenses = _allExpenses.where((expense) {
      return expense.date.month == event.month && expense.date.year == event.year;
    }).toList();
    emit(ExpensesLoaded(filteredExpenses));
    });
  }
  void _sortExpensesByDate() {
    _allExpenses.sort((a, b) => b.date.compareTo(a.date));
  }

  List<double> getWeeklySummary(List<Expense> expenses) {
    List<double> weeklySummary = List<double>.filled(7, 0.0);
    DateTime now = DateTime.now();

    for (var expense in expenses) {
      int daysDifference = now.difference(expense.date).inDays;
      if (daysDifference < 7) {
        weeklySummary[daysDifference] += expense.amount;
      }
    }
    return weeklySummary.reversed.toList();
  }

  List<double> getMonthlySummary(List<Expense> expenses) {
    List<double> monthlySummary = List<double>.filled(30, 0.0);
    DateTime now = DateTime.now();

    for (var expense in expenses) {
      int daysDifference = now.difference(expense.date).inDays;
      if (daysDifference < 30) {
        monthlySummary[daysDifference] += expense.amount;
      }
    }
    return monthlySummary.reversed.toList();
  }
}
