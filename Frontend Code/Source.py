import sys
from PyQt5.QtWidgets import QMainWindow, QApplication, QTabWidget, QTableWidget, QPushButton, QWidget, QTableWidgetItem
from PyQt5 import uic
import sqlite3

class ui(QMainWindow):
    def __init__(self):
        super(ui, self).__init__()
        uic.loadUi("Judiciary System.ui", self)
        
        self.tabWidget = self.findChild(QTabWidget, "tabWidget")
        self.tables = {
            "tab_Case_": "Case_",
            "tab_Court": "Court",
            "tab_Hearing": "Hearing",
            "tab_Judge": "Judge",
            "tab_Lawyer": "Lawyer",
            "tab_Party": "Party"
        }
        self.table_names = {
            "tab_Case_": "Case_",
            "tab_Court": "Court",
            "tab_Hearing": "Hearing",
            "tab_Judge": "Judge",
            "tab_Lawyer": "Lawyer",
            "tab_Party": "Party"
        }
        self.buttonGetData = self.findChild(QPushButton, "btn_GetData")
        self.buttonGetData.clicked.connect(self.get_data)

        self.buttonInsertData = self.findChild(QPushButton, "btn_InsertData")
        self.buttonInsertData.clicked.connect(self.insert_data)

        self.show()

    def get_data(self):
        conn = sqlite3.connect("Project.db")  # Replace with your SQLite database file
        cursor = conn.cursor()

        for tab_name, table_name in self.tables.items():
            tab_widget = self.findChild(QWidget, tab_name)
            if tab_widget is not None:
                table_widget = tab_widget.findChild(QTableWidget, table_name)
                if table_widget is not None:
                    cursor.execute(f"SELECT * FROM {table_name}")
                    rows = cursor.fetchall()
                    column_names = [description[0] for description in cursor.description]

                    table_widget.setColumnCount(len(column_names))
                    table_widget.setRowCount(len(rows))
                    table_widget.setHorizontalHeaderLabels(column_names)

                    for i, row in enumerate(rows):
                        for j, value in enumerate(row):
                            item = QTableWidgetItem(str(value))
                            table_widget.setItem(i, j, item)
                else:
                    print(f"Table widget '{table_name}' not found.")
            else:
                print(f"Tab widget '{tab_name}' not found.")

        conn.close()

    def insert_data(self):
        conn = sqlite3.connect("Project.db")  # Replace with your SQLite database file
        cursor = conn.cursor()

        current_tab_index = self.tabWidget.currentIndex()
        current_tab_name = self.tabWidget.tabText(current_tab_index)

        table_name = self.table_names.get(current_tab_name)
        if table_name is not None:
            tab_widget = self.findChild(QWidget, current_tab_name)
            if tab_widget is not None:
                table_widget = tab_widget.findChild(QTableWidget, table_name)
                if table_widget is not None:
                    column_count = table_widget.columnCount()

                    data = []
                    for column in range(column_count):
                        item = table_widget.item(0, column)
                        if item is not None:
                            data.append(item.text())
                        else:
                            data.append("")

                    placeholders = ",".join(["?"] * column_count)
                    insert_query = f"INSERT INTO {table_name} VALUES ({placeholders})"
                    cursor.execute(insert_query, tuple(data))
                    conn.commit()

                    print("Data inserted successfully.")
                else:
                    print(f"Table widget '{table_name}' not found.")
            else:
                print(f"Tab widget '{current_tab_name}' not found.")
        else:
            print(f"Table name not found for tab '{current_tab_name}'.")

        conn.close()


app = QApplication(sys.argv)
UIWindow = ui()
app.exec_()
