#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Employee {
    char employeeID[20];
    char employeeName[50];
    float salary;
    struct Employee* next;
};

typedef struct Employee Employee;

Employee* createNode(char employeeID[], char employeeName[], float salary) {
    Employee* newEmployee = (Employee*)malloc(sizeof(Employee));
    strcpy(newEmployee->employeeID, employeeID);
    strcpy(newEmployee->employeeName, employeeName);
    newEmployee->salary = salary;
    newEmployee->next = NULL;
    return newEmployee;
}

void addEmployee(Employee** head, char employeeID[], char employeeName[], float salary) {
    Employee* newEmployee = createNode(employeeID, employeeName, salary);
    if (*head == NULL) {
        *head = newEmployee;
    } else {
        Employee* current = *head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = newEmployee;
    }
}

void printEmployee(Employee* employee) {
    printf("Ma nhan vien: %s\n", employee->employeeID);
    printf("Ten nhan vien: %s\n", employee->employeeName);
    printf("Luong: %.2f\n", employee->salary);
    printf("------------------------------\n");
}

void printEmployeeList(Employee* head) {
    if (head == NULL) {
        printf("Danh sach nhan vien rong.\n");
        return;
    }
    Employee* current = head;
    while (current != NULL) {
        printEmployee(current);
        current = current->next;
    }
}

float findMaxSalary(Employee* head) {
    float maxSalary = 0;
    Employee* current = head;
    while (current != NULL) {
        if (current->salary > maxSalary) {
            maxSalary = current->salary;
        }
        current = current->next;
    }
    return maxSalary;
}

void searchEmployeeByID(Employee* head, char searchID[]) {
    Employee* current = head;
    while (current != NULL) {
        if (strcmp(current->employeeID, searchID) == 0) {
            printf("Tim thay nhan vien:\n");
            printEmployee(current);
            return;
        }
        current = current->next;
    }
    printf("Khong tim thay nhan vien co ma %s.\n", searchID);
}

// Insertion sort
void sortEmployeeList(Employee** head) {
    if (*head == NULL || (*head)->next == NULL) {
        return; // Danh sách rỗng hoặc chỉ có một phần tử, không cần sắp xếp
    }

    Employee* sortedList = NULL;
    Employee* current = *head;

    while (current != NULL) {
        Employee* next = current->next;

        if (sortedList == NULL || current->salary < sortedList->salary) {
            current->next = sortedList;
            sortedList = current;
        } else {
            Employee* temp = sortedList;
            while (temp->next != NULL && temp->next->salary < current->salary) {
                temp = temp->next;
            }
            current->next = temp->next;
            temp->next = current;
        }

        current = next;
    }

    *head = sortedList;
}

int main() {
    Employee* employeeList = NULL;

    addEmployee(&employeeList, "NV001", "Nguyen Van A", 5000.50);
    addEmployee(&employeeList, "NV002", "Tran Thi B", 6000.75);
    addEmployee(&employeeList, "NV003", "Le Van C", 4500.25);
    addEmployee(&employeeList, "NV004", "Pham Thi D", 7000.00);

    printf("Danh sach nhan vien truoc khi sap xep:\n");
    printEmployeeList(employeeList);

    float maxSalary = findMaxSalary(employeeList);
    printf("\nMuc luong cao nhat trong cong ty: %.2f\n", maxSalary);

    searchEmployeeByID(employeeList, "NV002");
    searchEmployeeByID(employeeList, "NV005");

    sortEmployeeList(&employeeList);
    printf("\nDanh sach nhan vien sau khi sap xep theo muc luong tang dan:\n");
    printEmployeeList(employeeList);

    while (employeeList != NULL) {
        Employee* temp = employeeList;
        employeeList = employeeList->next;
        free(temp);
    }

    return 0;
}
