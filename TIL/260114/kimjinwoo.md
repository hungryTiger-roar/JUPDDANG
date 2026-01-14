# TIL (Today I Learned)

## 2026-01-14

---

## **JPA 기본 개념**

- JPA(Java Persistence API)는 자바 표준 ORM(Object-Relational Mapping) 기술입니다. 객체지향 프로그래밍 방식으로 DB와 상호작용할 수 있도록 설계 되었습니다. JPA를 사용하면 SQL 대신 객체를 통해 데이터를 처리할 수 있습니다.
- 대표 구현체 : Hibernate, EclipseLink, OpenJPA
- 특징
    - DB 테이블과 자바 객체를 매핑하여 객체 지향적으로 데이터를 관리합니다.
    - JPQL(Java Persistenece Query Language)이라는 쿼리 언어를 사용합니다.
    - 영속성 컨텍스트(Persistence Context)를 통해 데이터 변경 사항을 자동으로 추적합니다.
- 예시 코드
    
    ```jsx
    @Entity
    public class User {
        @Id
        @GeneratedValue
        private Long id;
        private String name;
        private String email;
    }
    ```
    

---

## **Mybatis 기본 개념**

- Mybatis는 SQL Mapper 프레임워크로, SQL 쿼리를 직접 작성하면서도 자바 객체와 매핑할 수 있는 기능을 제공합니다. SQL 작성의 자유도를 보장하며, 복잡한 쿼리나 DB 특화 기능을 활용하기에 적합합니다.
- 특징
    - XML 또는 어노테이션 기반으로 SQL을 관리합니다.
    - SQL을 직접 제어할 수 있어 복잡한 쿼리 작성에 유리합니다.
    - 동적 쿼리를 지원하여 조건에 따라 SQL을 유연하게 변경할 수 있습니다.
- 예시 코드

```jsx
<select id="findUserById" parameterType="Long" resultType="User">
    SELECT * FROM users WHERE id = #{id}
</select>
```

---