#include <iostream>
#include <cstring>

using namespace std;

struct Employee {
    char employeeID[20];
    char employeeName[50];
    float salary;
    Employee* next;
};

Employee* createNode(char employeeID[], char employeeName[], float salary) {
    Employee* newEmployee = new Employee;
    strcpy(newEmployee->employeeID, employeeID);
    strcpy(newEmployee->employeeName, employeeName);
    newEmployee->salary = salary;
    newEmployee->next = nullptr;
    return newEmployee;
}

void addEmployee(Employee*& head, char employeeID[], char employeeName[], float salary) {
    Employee* newEmployee = createNode(employeeID, employeeName, salary);
    if (head == nullptr) {
        head = newEmployee;
    } else {
        Employee* current = head;
        while (current->next != nullptr) {
            current = current->next;
        }
        current->next = newEmployee;
    }
}

void printEmployee(Employee* employee) {
    cout << "Ma nhan vien: " << employee->employeeID << "\n";
    cout << "Ten nhan vien: " << employee->employeeName << "\n";
    cout << "Luong: " << employee->salary << "\n";
    cout << "------------------------------\n";
}

void printEmployeeList(Employee* head) {
    if (head == nullptr) {
        cout << "Danh sach nhan vien rong.\n";
        return;
    }
    Employee* current = head;
    while (current != nullptr) {
        printEmployee(current);
        current = current->next;
    }
}

float findMaxSalary(Employee* head) {
    float maxSalary = 0;
    Employee* current = head;
    while (current != nullptr) {
        if (current->salary > maxSalary) {
            maxSalary = current->salary;
        }
        current = current->next;
    }
    return maxSalary;
}

void searchEmployeeByID(Employee* head, char searchID[]) {
    Employee* current = head;
    while (current != nullptr) {
        if (strcmp(current->employeeID, searchID) == 0) {
            cout << "Tim thay nhan vien:\n";
            printEmployee(current);
            return;
        }
        current = current->next;
    }
    cout << "Khong tim thay nhan vien co ma " << searchID << ".\n";
}

//Insertion sort
void sortEmployeeList(Employee*& head) {
    if (head == nullptr || head->next == nullptr) {
        return; // Danh sách rỗng hoặc chỉ có một phần tử, không cần sắp xếp
    }

    Employee* sortedList = nullptr;
    Employee* current = head;

    while (current != nullptr) {
        Employee* next = current->next;

        if (sortedList == nullptr || current->salary < sortedList->salary) {
            current->next = sortedList;
            sortedList = current;
        } else {
            Employee* temp = sortedList;
            while (temp->next != nullptr && temp->next->salary < current->salary) {
                temp = temp->next;
            }
            current->next = temp->next;
            temp->next = current;
        }

        current = next;
    }

    head = sortedList;
}

int main() {
    Employee* employeeList = nullptr;

    addEmployee(employeeList, "NV001", "Nguyen Van A", 5000.50);
    addEmployee(employeeList, "NV002", "Tran Thi B", 6000.75);
    addEmployee(employeeList, "NV003", "Le Van C", 4500.25);
    addEmployee(employeeList, "NV004", "Pham Thi D", 7000.00);

    cout << "Danh sach nhan vien truoc khi sap xep:\n";
    printEmployeeList(employeeList);

    float maxSalary = findMaxSalary(employeeList);
    cout << "\nMuc luong cao nhat trong cong ty: " << maxSalary << "\n";

    searchEmployeeByID(employeeList, "NV002");
    searchEmployeeByID(employeeList, "NV005");

    sortEmployeeList(employeeList);
    cout << "\nDanh sach nhan vien sau khi sap xep theo muc luong tang dan:\n";
    printEmployeeList(employeeList);

    while (employeeList != nullptr) {
        Employee* temp = employeeList;
        employeeList = employeeList->next;
        delete temp;
    }

    return 0;
}
