import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracker_task/src/data/models/expense_model.dart';
import 'package:expense_tracker_task/src/presentation/bloc/expense_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

void main() {
  late ExpenseBloc expenseBloc;
  late Box<Expense> expenseBox;

  setUp(() async {
    await setUpTestHive();

    if (!Hive.isAdapterRegistered(ExpenseAdapter().typeId)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    expenseBox = await Hive.openBox<Expense>('expenses');
    expenseBloc = ExpenseBloc()..expenseBox = expenseBox;
  });

  tearDown(() async {
    await expenseBox.close();
    await tearDownTestHive();
    await expenseBloc.close();
  });

  group('ExpenseBloc', () {
    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpensesLoading, ExpensesLoaded] when LoadExpensesEvent is added and data is loaded successfully',
      build: () {
        return expenseBloc;
      },
      act: (bloc) async {
        await expenseBox.add(Expense(date: DateTime(2024, 7, 25), amount: 10.0, description: 'Test 1'));
        await expenseBox.add(Expense(date: DateTime(2024, 7, 15), amount: 20.0, description: 'Test 2'));
        bloc.add(LoadExpensesEvent());
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ExpensesLoading>(),
        isA<ExpensesLoaded>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpensesLoaded] when AddExpenseEvent is added and expense is added successfully',
      build: () {
        return expenseBloc;
      },
      act: (bloc) async {
        bloc.add(AddExpenseEvent(expense: Expense(date: DateTime(2024, 7, 25), amount: 10.0, description: 'Test 1')));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ExpensesLoaded>(),
      ],
      verify: (bloc) {
        final currentState = bloc.state as ExpensesLoaded;
        expect(currentState.expenses.length, 1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpensesLoaded] when DeleteExpenseEvent is added and expense is deleted successfully',
      build: () {
        return expenseBloc;
      },
      act: (bloc) async {
        final expense1 = Expense(date: DateTime(2024, 7, 25), amount: 10.0, description: 'Test 1');
        final expense2 = Expense(date: DateTime(2024, 7, 15), amount: 20.0, description: 'Test 2');
        final key1 = await expenseBox.add(expense1);
        await expenseBox.add(expense2);
        bloc.add(DeleteExpenseEvent(key: key1));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ExpensesLoaded>(),
      ],
      verify: (bloc) {
        final currentState = bloc.state as ExpensesLoaded;
        expect(currentState.expenses.length, 1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpensesLoaded] when EditExpenseEvent is added and expense is edited successfully',
      build: () {
        return expenseBloc;
      },
      act: (bloc) async {
        final expense = Expense(date: DateTime(2024, 7, 25), amount: 10.0, description: 'Test 1');
        final key = await expenseBox.add(expense);
        final editedExpense = Expense(date: DateTime(2024, 7, 25), amount: 15.0, description: 'Test 1 Edited');
        await expenseBox.put(key, editedExpense);
        bloc.add(EditExpenseEvent(expense: editedExpense));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ExpensesLoaded>(),
      ],
      verify: (bloc) {
        final currentState = bloc.state as ExpensesLoaded;
        expect(currentState.expenses.length, 1);
        expect(currentState.expenses[0].amount, 15.0);
      },
    );
  });
}
