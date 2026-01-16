# TIL (Today I Learned)

## 2026-01-16
---
## JOIN

JOIN은 두 개 이상의 테이블을 연결하여 데이터를 조회하는 방법입니다.

### INNER JOIN

두 테이블에서 조건에 맞는 데이터만 조회합니다.

```jsx
SELECT users.name, orders.order_date, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id;
```

### LEFT JOIN (LEFT OUTER JOIN)

왼쪽 테이블의 모든 데이터와 오른쪽 테이블에서 조건에 맞는 데이터를 조회합니다. 매칭되지 않으면 NULL로 표시됩니다.

```jsx
SELECT users.name, orders.order_date
FROM users
LEFT JOIN orders ON users.id = orders.user_id;
```

### RIGHT JOIN (RIGHT OUTER JOIN)

오른쪽 테이블의 모든 데이터와 왼쪽 테이블에서 조건에 맞는 데이터를 조회합니다.

```jsx
SELECT users.name, orders.order_date
FROM users
RIGHT JOIN orders ON users.id = orders.user_id;
```

### FULL OUTER JOIN

양쪽 테이블의 모든 데이터를 조회합니다. 매칭되지 않는 경우 NULL로 표시됩니다.

```jsx
SELECT users.name, orders.order_date
FROM users
FULL OUTER JOIN orders ON users.id = orders.user_id;
```

### CROSS JOIN

두 테이블의 모든 조합(카르테시안 곱)을 생성합니다.

```jsx
SELECT users.name, products.product_name
FROM users
CROSS JOIN products;
```

### SELF JOIN

같은 테이블을 자기 자신과 조인합니다.

```jsx
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
INNER JOIN employees e2 ON e1.manager_id = e2.id;
```

---

## Subquery (서브쿼리)

서브쿼리는 다른 쿼리 안에 포함된 SELECT 문입니다.

### WHERE 절에서 사용

```jsx
// 단일 값 반환
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);- 여러 값 반환 (IN)SELECT name, department_id
FROM employees
WHERE department_id IN (SELECT id FROM departments WHERE location = 'Seoul');- EXISTSSELECT name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.id);
```

### FROM 절에서 사용 (인라인 뷰)

```jsx
SELECT dept_name, avg_salary
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
INNER JOIN departments ON dept_avg.department_id = departments.id;
```

### SELECT 절에서 사용 (스칼라 서브쿼리)

```jsx
SELECT 
    name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg,
    salary - (SELECT AVG(salary) FROM employees) AS diff
FROM employees;
```

### HAVING 절에서 사용

```jsx
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees);
```

---

## JOIN과 Subquery 함께 사용

```jsx
// Subquery로 필터링한 결과를 JOINSELECT u.name, o.order_date, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE u.id IN (SELECT user_id FROM premium_members);- JOIN 결과를 Subquery로 집계SELECT department_name, (SELECT COUNT() FROM employees e
 WHERE e.department_id = d.id) AS employee_count
FROM departments d;
```