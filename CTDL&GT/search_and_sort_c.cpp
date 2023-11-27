#include <stdio.h>

void printArr(int arr[], int n) {
    printf("\nMang sau khi sap xep: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

// Hàm linear search
int linearSearch(const int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;
        }
    }
    return -1;
}

// Hàm binary search
int binarySearch(const int arr[], int left, int right, int target) {
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) {
            return mid;
        }
        if (arr[mid] > target) {
            right = mid - 1;
        } else {
            left = mid + 1;
        }
    }
    return -1;
}

// Selection sort
int selectionSort(int arr[], int n) {
    int cnt = 0;
    for (int i = 0; i < n - 1; i++) {
        int minIndex = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
        printArr(arr, n);
        cnt++;
    }
    return cnt; // So lan sap xep
}

// Interchange sort
int interchangeSort(int arr[], int n) {
    int cnt = 0;
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (arr[i] > arr[j]) {
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
                printArr(arr, n);
                cnt++;
            }
        }
    }
    return cnt; // So lan sap xep
}

// Insertion sort
int insertionSort(int arr[], int n) {
    int cnt = 0;
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }

        arr[j + 1] = key;
        printArr(arr, n);
        cnt++;
    }
    return cnt; // So lan sap xep
}

// Bubble sort
int bubbleSort(int arr[], int n) {
    int cnt = 0;
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                printArr(arr, n);
                cnt++;
            }
        }
    }
    return cnt; // So lan sap xep
}

int main() {
    int arr[] = {12, 11, 13, 5, 6};
    int n = sizeof(arr) / sizeof(arr[0]);

    printf("Mang truoc khi sap xep: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }

    int target = 11;
    int result = binarySearch(arr, 0, n - 1, target);
    // result = linearSearch(arr, n, target);

    if (result != -1) {
        printf("Phan tu %d duoc tim thay tai chi so %d\n", target, result);
    } else {
        printf("Phan tu %d khong duoc tim thay trong mang\n", target);
    }

    int cnt = 0;

    cnt = selectionSort(arr, n);
    // cnt = interchangeSort(arr, n);
    // cnt = insertionSort(arr, n);
    // cnt = bubbleSort(arr, n);
    printf("\nSo lan sap xep: %d\n", cnt);

    // printArr(arr, n);

    return 0;
}
