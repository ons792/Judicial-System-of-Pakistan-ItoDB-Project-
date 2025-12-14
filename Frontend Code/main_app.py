
import sys
import sqlite3
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, 
    QTabWidget, QTableWidget, QTableWidgetItem, QPushButton, 
    QHBoxLayout, QLabel, QMessageBox, QHeaderView
)
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QFont, QIcon

# --- Modern Dark Theme Stylesheet ---
DARK_THEME = """
QMainWindow {
    background-color: #2b2b2b;
}
QTabWidget::pane {
    border: 1px solid #444;
    background: #3c3f41;
}
QTabBar::tab {
    background: #3c3f41;
    color: #b0b0b0;
    padding: 10px 20px;
    border: 1px solid #444;
    border-bottom: none;
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
}
QTabBar::tab:selected {
    background: #4e5254;
    color: white;
}
QTabBar::tab:hover {
    background: #45494b;
}
QTableWidget {
    background-color: #3c3f41;
    color: #dcdcdc;
    gridline-color: #555;
    border: none;
}
QHeaderView::section {
    background-color: #4e5254;
    color: white;
    padding: 5px;
    border: 1px solid #555;
    font-weight: bold;
}
QPushButton {
    background-color: #007acc;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: bold;
}
QPushButton:hover {
    background-color: #0098ff;
}
QPushButton:pressed {
    background-color: #005c99;
}
QLineEdit, QComboBox {
    padding: 5px;
    border: 1px solid #555;
    border-radius: 3px;
    background-color: #4e5254;
    color: white;
}
QLabel {
    color: #dcdcdc;
    font-size: 14px;
}
"""

class JudiciaryApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Judicial System of Pakistan - DB Interface")
        self.setGeometry(100, 100, 1000, 700)
        self.setStyleSheet(DARK_THEME)

        self.tables_config = {
            "Cases": "Case_",    # Tab Name : DB Table Name
            "Courts": "Court",
            "Hearings": "Hearing",
            "Judges": "Judge",
            "Lawyers": "Lawyer",
            "Parties": "Party"
        }
        
        # Store references to table widgets
        self.table_widgets = {}

        self.initUI()
        self.load_data()

    def initUI(self):
        # Main Layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(10, 10, 10, 10)
        main_layout.setSpacing(10)

        # Header Title
        title_label = QLabel("Judicial Database Management System")
        title_label.setAlignment(Qt.AlignCenter)
        title_label.setStyleSheet("font-size: 24px; font-weight: bold; color: #ffffff; margin-bottom: 10px;")
        main_layout.addWidget(title_label)

        # Tabs
        self.tabs = QTabWidget()
        main_layout.addWidget(self.tabs)

        for tab_name, table_db_name in self.tables_config.items():
            self.create_tab(tab_name, table_db_name)

        # Action Buttons Area
        button_layout = QHBoxLayout()
        button_layout.addStretch()

        self.btn_refresh = QPushButton("Refresh Data")
        self.btn_refresh.setCursor(Qt.PointingHandCursor)
        self.btn_refresh.clicked.connect(self.load_data)
        button_layout.addWidget(self.btn_refresh)

        self.btn_save = QPushButton("Save New Entry")
        self.btn_save.setCursor(Qt.PointingHandCursor)
        self.btn_save.clicked.connect(self.insert_data)
        self.btn_save.setStyleSheet("background-color: #28a745;")  # Green for save
        button_layout.addWidget(self.btn_save)

        main_layout.addLayout(button_layout)

    def create_tab(self, tab_name, table_db_name):
        tab = QWidget()
        layout = QVBoxLayout(tab)
        
        table_widget = QTableWidget()
        table_widget.setAlternatingRowColors(True)
        table_widget.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        
        layout.addWidget(table_widget)
        self.tabs.addTab(tab, tab_name)
        
        # Store reference
        self.table_widgets[tab_name] = table_widget

    def get_db_connection(self):
        try:
            # Using the exact name from the user's directory
            return sqlite3.connect("Project.db")
        except sqlite3.Error as e:
            QMessageBox.critical(self, "Database Error", f"Could not connect to database: {e}")
            return None

    def load_data(self):
        conn = self.get_db_connection()
        if not conn:
            return

        cursor = conn.cursor()

        for tab_name, table_db_name in self.tables_config.items():
            table_widget = self.table_widgets.get(tab_name)
            if not table_widget:
                continue
            
            try:
                cursor.execute(f"SELECT * FROM {table_db_name}")
                rows = cursor.fetchall()
                
                if cursor.description:
                    columns = [desc[0] for desc in cursor.description]
                    table_widget.setColumnCount(len(columns))
                    table_widget.setHorizontalHeaderLabels(columns)
                
                # +1 empty row for new data entry
                table_widget.setRowCount(len(rows) + 1)

                for i, row in enumerate(rows):
                    for j, val in enumerate(row):
                        item = QTableWidgetItem(str(val) if val is not None else "")
                        # Make existing data read-only if desired, or editable. 
                        # Let's keep it editable for now or just standard.
                        table_widget.setItem(i, j, item)
                
                # Mark the last row as empty for input
                last_row = len(rows)
                for j in range(table_widget.columnCount()):
                    table_widget.setItem(last_row, j, QTableWidgetItem(""))

            except sqlite3.Error as e:
                print(f"Error loading table {table_db_name}: {e}")
        
        conn.close()

    def insert_data(self):
        current_tab_index = self.tabs.currentIndex()
        current_tab_name = self.tabs.tabText(current_tab_index)
        table_db_name = self.tables_config.get(current_tab_name)
        table_widget = self.table_widgets.get(current_tab_name)

        if not table_widget or not table_db_name:
            return

        # Generally, we assume the user filled the LAST row
        row_count = table_widget.rowCount()
        if row_count == 0:
            return
        
        last_row_index = row_count - 1
        col_count = table_widget.columnCount()
        
        new_data = []
        is_empty = True
        
        for col in range(col_count):
            item = table_widget.item(last_row_index, col)
            text = item.text().strip() if item else ""
            new_data.append(text)
            if text:
                is_empty = False
        
        if is_empty:
            QMessageBox.warning(self, "No Data", "Please fill in the last row to insert data.")
            return

        conn = self.get_db_connection()
        if not conn:
            return
        
        cursor = conn.cursor()
        placeholders = ",".join(["?"] * col_count)
        query = f"INSERT INTO {table_db_name} VALUES ({placeholders})"
        
        try:
            cursor.execute(query, tuple(new_data))
            conn.commit()
            QMessageBox.information(self, "Success", f"Data inserted into {current_tab_name} successfully!")
            self.load_data() # Refresh
        except sqlite3.Error as e:
            QMessageBox.critical(self, "Database Error", f"Failed to insert data:\n{e}")
        finally:
            conn.close()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    
    # Set default font
    font = QFont("Segoe UI", 10)
    app.setFont(font)

    window = JudiciaryApp()
    window.show()
    sys.exit(app.exec_())
