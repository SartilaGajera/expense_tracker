import 'package:hive/hive.dart';
import 'package:expense_tracker_task/src/data/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(int id);
  Future<void> editExpense(Expense expense);
  Future<List<Expense>> getExpenses();
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Box<Expense> expenseBox;

  ExpenseRepositoryImpl() : expenseBox = Hive.box('expenses');

  @override
  Future<void> addExpense(Expense expense) async {
    await expenseBox.add(expense);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await expenseBox.delete(id);
  }

  @override
  Future<void> editExpense(Expense expense) async {
    await expense.save();
  }

  @override
  Future<List<Expense>> getExpenses() async {
    return expenseBox.values.toList();
  }
}
