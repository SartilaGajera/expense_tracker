# Expense Tracker App

Expense Tracker App is a Flutter application designed to allow users to view, add, edit and delete expense and it's details. It utilizes the flutter_bloc state management library for efficient state handling and hive for store expenses..

## Features

- View a list of expenses 
- Add, edit and update expense
- Schedule notification for reminder
- Filter expense by weekly and monthly
- Unit testing


## Requirements

- Flutter SDK : 3.22.2

## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/SartilaGajera/expense_tracker.git
    ```

2. **Navigate to the project directory:**

    ```bash
    cd expense_tracker
    ```

3. **Install dependencies:**

    ```bash
    flutter pub get
    ```

5. **Run the app:**

    ```bash
    flutter run
    ```

## Usage

- Upon launching the app, you'll be presented with expenses list.
- Tap on a to add new expense
- Tap on filter icon to filter expense by weekly
- Tap on dropdown to filter monthly expense

## State Management

This app uses flutter_bloc for state management, which provides a simple and efficient way to manage state and update UI components.