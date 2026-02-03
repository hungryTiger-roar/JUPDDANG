# Today I Learnd   

## 2026-01-16   
---   
## Today   
---   
# Flutter

프론트 기술으로는 플러터를 선택
- 책을 기준으로 공부를 진행하기

위를 기준으로 공부를 진행하고, 플러터에 대해 이해를 해보려고 했으나   
Dart에 대한 기초 지식이 부족하여, 문제가 발생!   

주말 내에 Dart에 대해 학습하고, 복습하는 것을 기준으로 진행.
- 교재 내의 Dart 버전은 3.2.X
---
# Dart 언어 학습

# 0. Hello World!

```dart
void main(){
  print('Hello Code Factory');
}
```

---

# 1. 변수 선언

```dart
void main(){
    // variable
    var name = '코드팩토리';
  print(name);
  
  var name2 = '레드벨벳';
  
  print(name2);
  
  name = '플러터 프로그래밍';
  print(name);
}
```


name 을 다시 할당하는 경우 오류

```dart
void main(){
    // variable
    var name = '코드팩토리';
  print(name);
  
  var name2 = '레드벨벳';
  
  print(name2);
  
  name = '플러터 프로그래밍';
  print(name);
  
  var name = '코드팩토리2';
}
```

---

## 1 - 1. 정수

```dart
void main(){
    // 정수
    // integer
    int number1 = 10;
    
    print(number1);
  
  int number2 = 15;
  
  print(number2);
  
  int number3 = -10;
  
  print(number3);
}
```


```dart
void main(){
    // 정수
    // integer
  int number1 = 2;
  int number2 = 4;
  
  print(number1 + number2);
  print(number1 - number2);
  print(number1 / number2);
  print(number1 * number2);
}
```


## 1 - 2. 실수

```dart
void main(){
  // 실수
  // double
  
  double number1 = 2.5;
  double number2 = 0.5;
  
  print(number1 + number2);
  print(number1 - number2);
  print(number1 * number2);
  print(number1 / number2);
}
```

---

## 1 - 3. Boolean

```dart
void main(){
  // 맞다 / 틀리다
  // Boolean
  
  bool isTrue = true;
  bool isFalse = false;
  
  print(isTrue);
  print(isFalse);
}
```


---

## 1 - 4. String

```dart
void main(){
  // 글자 타입
  // String
  
  String name = '레드벨벳';
  String name2 = '코드팩토리';
  
  print(name);
  print(name2);
  
  // var String
  var name3 = '블랙핑크';
  var number = 20;
  
  print(name3.runtimeType);
  print(number.runtimeType);
}
```


왜 var 말고 다른 변수명을 사용할까?

→ 직접 명시하는 편이 눈에 훨씬 보기 좋다

---

```dart
void main(){
  // 글자 타입
  // String
  
  String name = '레드벨벳';
  String name2 = '슬기';
  
  print(name + name2);
  print(name + ' ' + name2);
  
  print('${name} ${name2}');
  print('$name $name2');
  
  print('${name.runtimeType} ${name2}');
  print('$name.runtimeType $name2');
}
```


---

## 1 - 5. Dynamic

```dart
void main(){
  dynamic name = '코드팩토리';
  
  print(name);
  
  dynamic number = 1;
  print(number);
  
  var name2 = '블랙핑크';
  
  print(name2);
  
  print(name.runtimeType);
  print(name2.runtimeType);
  
  name = 2;
  
  print(name);
  
}
```


dynamic 변수는 선언했었던 변수의 값을 바꿀 수 있다는 점!!

---

## 1 - 6. null

```dart
 void main(){
  // nullable - null이 될 수 있다.
  // non-nullable - null이 될 수 없다.
  // null - 아무런 값도 있지 않다
  
  String name = '코드팩토리';
  
  print(name);
  
  String? name2 = '블랙핑크';
  
  print(name2);
  
  // 현재 이 값은 널이 아니다! -> 변수명 뒤에 느낌표
  print(name2!);
}
```

---

## 1 - 7. final

```dart
void main(){
  // String  생략의 경우 var 넣음
  // final name = '코드팩토리'
  final String name = '코드팩토리';
  
  print(name);
  
  const String name2 = '블랙핑크';
  
  print(name2);
}
```

## 1 - 8. DateTime

```dart
void main(){
        //코드가 실행이 되는 순간을 반영
  DateTime now = DateTime.now();
  
  print(now);
}
```

final 과 const의 차이는?

→ 빌드하는 시간에 대한 정보의 차이. final은 빌드 타임에 대한 시간을 몰라도 됨.

const는 알아야함. 코드가 실행이 될 때의 값을 가져 옴

## 1 - 9. Operator

```dart
void main(){
  int number = 2;
  
  print(number);
  print(number + 2);
  print(number - 2);
  print(number * 2);
  print(number / 2);
  
  print('------------------');
  
  print(number%2);
  print(number%3);
  
  print(number);
  number ++;
  print(number);
  number --;
  print(number);
}
```


```dart
void main(){
  double number = 4.0;
  
  print(number);
  
  number += 1;
  
  print(number);
  
  number -= 1;
  
  print(number);
  
  number *= 2;
  
  print(number);
  
  number /= 2;
  
  print(number);
 }
```

```dart
void main(){
  // null
  // ??= (null인 경우 오른쪽 값으로 바꿔라)
  double? number = 4.0;
  print(number);
  
  number = 2.0;
  
  print(number);
  
  number = null;
  
  print(number);
  
  number ??= 3.0;
  
  print(number);
 }
```


```dart
void main(){
  int number1 = 1;
  int number2 = 2;
  
  print(number1 > number2);
  print(number1 > number2);
  print(number1 >= number2);
  print(number1 <= number2);
  print(number1 == number2);
  print(number1 != number2);
 }
```

```dart
void main(){
  int number1 = 1;
  print(number1 is int);
  print(number1 is String);
  
  print(number1 is! int);
  print(number1 is! String);
 }
```


```dart
void main(){
  bool result = 12>10 && 1>0;
  
  print(result);
  
  bool result2 = 12>10 && 0>1;
  
  print(result2);
  
  bool result3 = 12 > 10 || 1 > 0;
  
  print(result3);
  
  bool result4 = 12 > 10 || 0> 1;
  
  print(result4);
  
  bool result5 = 12 < 10 || 0> 1;
  
  print(result5);
 }
```

---

## 2 - 1. List

```dart
void main(){
  // List
  // 리스트
  
  List<String> blackPink = ['제니','지수','로제', '리사'];
  List<int> numbers = [1,2,3,4,5,6];
  
  print(blackPink);
  print(numbers);
  
  // index
  // 순서
  // 0부터
  print(blackPink[0]);
  print(blackPink[1]);
  print(blackPink[2]);
  print(blackPink[3]);
  
  print(blackPink.length);
  
  blackPink.add('코드팩토리');
  print(blackPink);
  
  
  blackPink.remove('코드팩토리');
  print(blackPink);
  
  print(blackPink.indexOf('로제'));
 }
```

## 2 - 2.Map

```dart
void main(){
  // Map
  // Key/ Value
  
  Map<String, String> dictionary={
    'Harry' : '해리포터',
    'Ron' : '론 위즐리',
    'Hermione' : '헤르미온느'
  };
  
  print(dictionary);
  
  Map<String, bool> isHarry = {
    'Harry' : true,
    'Ron' : true,
    'Hermione' : false
  };
  
  print(isHarry);
  
  isHarry.addAll({
    'Spiderman': false,
  });
  
  print(isHarry);
  
  print(isHarry['Ron']);
  
  isHarry['Hulk'] = false;
  
  print(isHarry);
   
 }
```

```dart
void main(){
  // Map
  // Key/ Value
  
  Map<String, bool> isHarry = {
    'Harry' : true,
    'Ron' : true,
    'Hermione' : false
  };
  
  print(isHarry);
  
  isHarry.remove('Harry');
  
  print(isHarry);
  
  print(isHarry.keys);
  
  print(isHarry.values);
  
   
 }
```

## 2 - 3. Set

```dart
void main(){
  //Set
  
  final Set<String> names = {
    'Code Factory',
    'Flutter'
  };
  
  print(names);
  
  names.add('Jenny');
  
  print(names);
  
  names.remove('Jenny');
  
  print(names);
  
  print(names.contains('Jenny'));
 }
```


## 3 - 1. if문

```dart
void main(){
  //if 문
  
  int number = 3;
  
  if (number % 2 == 0){
    print('값이 짝수입니다.');
  }else {
    print('값이 홀수입니다.');
  }
 }
```



```dart
void main(){
  //if 문
  
  int number = 3;
  
  if (number % 3 == 0){
    print('나머지가 0입니다.');
  }else if(number % 3 == 1) {
    print('나머지가 1입니다.');
  }else{
    print('나머지가 0입니다');
  }
 }
```

## 3 - 2. Switch 문

```dart
void main(){
  //switch 문
  
  int number = 5;
  
  switch(number % 3){
    case 0:
      print('나머지가 0입니다');
      break;
    
    case 1:
      print('나머지가 1입니다.');
      break;
    
    default:
      print('나머지가 2입니다.');
      break;
  }
 }
```

## 3 - 3. loop

### for loop

```dart
void main(){
  // for loop
  
  for(int i = 0; i < 10; i++){
    print(i);
  }
 }
```

```dart
void main(){
  // for loop
  int total = 0;
  
  List<int> numbers = [1,2,3,4,5,6];
  
  for(int i = 0; i< numbers.length; i++){
    total += numbers[i];
  }
  
  print(total);
 }
```


```dart
void main(){
  // for loop
  int total = 0;
  
  List<int> numbers = [1,2,3,4,5,6];
  
  for(int number in numbers){
    print(number);
    total += number;
  }
  
  print(total);
 }
 
```

```dart
void main(){
  for(int i = 0; i < 10; i++){
    if(i == 5){
      continue;
    }
    print(i);
  } 
 }
```

### while loop

```dart
void main(){
  int total = 0;
  
  while(total < 10){
    total += 1;
  }
  print(total);
  
  total = 0;
  
  do {
    total += 1;
  }while (total<10);
  
  print(total);
 }
```

```dart
void main(){
  int total = 0;
  
  while(total < 10){
    total += 1;
    
    if(total == 5){
      break;
    }
  }
  print(total);
  
 }
```

---

## 4 - 1. enum

```dart
enum Status{
  approved,
  pending,
  rejected
}

void main(){
  Status status = Status.approved;
  
  if(status == Status.approved){
    print('승인입니다.');
  }else if(status ==Status.pending){
    print('대기입니다.');
  }else{
    print('거절입니다.');
  }
 }
```


## 4 - 2. 함수 선언

```dart
void main() {
    int result1 = addNumbers(10, y: 20);
    int result2 = addNumbers(10,y: 30,z : 40);
    
    print(result1);
    print('result2 : $result2');
    
    print('sum = ${result1 + result2}');
}

int addNumbers(int x,{
    required int y,
    int z = 30,
}) => x+y+z;
```


```dart
void main() {
  Operation operation = add;

  int result = operation(10, 20, 30);

  print(result);

  operation = subtract;

  int result2 = operation(10, 20, 30);

  print(result2);
}

typedef Operation = int Function(int x, int y, int z);

// 더하기
int add(int x, int y, int z) => x + y + z;

int subtract(int x, int y, int z) => x - y - z;

```
```dart
void main() {
  Idol blackPink = const Idol('블랙핑크', ['지수', '제니', '리사', '로제']);

  blackPink.sayHello();
  blackPink.introduce();

  Idol bigbang = const Idol('빅뱅', ['지디', '대성', '탑', '태양']);

  bigbang.sayHello();
  bigbang.introduce();
}

// 이름 - 변수
// 멤버들 -변수
// 인사 - 함수
// 멤버들 소개 - 함수
class Idol {
  final String name;
  final List<String> members;

  const Idol(this.name, this.members);

  Idol.fromList(List values) 
    : this.members = values[0], 
      this.name = values[1];

  void sayHello() {
    print('안녕하세요 ${this.name} 입니다.');
  }

  void introduce() {
    print('저희 멤버는 ${this.members}가 있습니다.');
  }
}

```

```dart
  Idol blackPink =const Idol('블랙핑크', ['지수', '제니', '리사', '로제']);

  blackPink.sayHello();
  blackPink.introduce();
  Idol blackPink2 = const Idol('블랙핑크', ['지수', '제니', '리사', '로제']);
  
  print(blackPink == blackPink2);
```

```dart
  Idol blackPink =Idol('블랙핑크', ['지수', '제니', '리사', '로제']);

  blackPink.sayHello();
  blackPink.introduce();
  Idol blackPink2 = Idol('블랙핑크', ['지수', '제니', '리사', '로제']);
  
  print(blackPink == blackPink2);
```

const가 있는 경우 true, 없는경우 false

```dart
void main() {
  Idol blackPink =Idol('블랙핑크', ['지수', '제니', '리사', '로제']);

  Idol bigbang = Idol('빅뱅', ['지디', '대성', '탑', '태양']);
  
  print(blackPink.firstMember);
  print(bigbang.firstMember);
  
  blackPink.firstMember = '정수민';
  
  print(blackPink.firstMember);
}

// 이름 - 변수
// 멤버들 -변수
// 인사 - 함수
// 멤버들 소개 - 함수
class Idol {
  String name;
  List<String> members;

  Idol(this.name, this.members);

  Idol.fromList(List values) 
    : this.members = values[0], 
      this.name = values[1];

  void sayHello() {
    print('안녕하세요 ${this.name} 입니다.');
  }

  void introduce() {
    print('저희 멤버는 ${this.members}가 있습니다.');
  }
  
  String get firstMember{
    return this.members[0];
  }
  
  set firstMember(String name){
    this.members[0] = name;
  }
}

```

```dart
void main() {
  _Idol blackPink =_Idol('블랙핑크', ['지수', '제니', '리사', '로제']);

  _Idol bigbang = _Idol('빅뱅', ['지디', '대성', '탑', '태양']);
  
  print(blackPink.firstMember);
  print(bigbang.firstMember);
  
}

// 이름 - 변수
// 멤버들 -변수
// 인사 - 함수
// 멤버들 소개 - 함수
class _Idol {
  final String name;
  final List<String> members;

  _Idol(this.name, this.members);

  _Idol.fromList(List values) 
    : this.members = values[0], 
      this.name = values[1];

  void sayHello() {
    print('안녕하세요 ${this.name} 입니다.');
  }

  void introduce() {
    print('저희 멤버는 ${this.members}가 있습니다.');
  }
  
  String get firstMember{
    return this.members[0];
  }

}

```

_Idol의 경우 해당 파일 안에서만 사용 가능

## 상속

```dart
void main(){
  Idol apink = Idol(name : '에이핑크', membersCount: 5);
  
  apink.sayName();
  apink.sayMembersCount();
  
  BoyGroup bigbang = BoyGroup('bigbang', 4);
  
  bigbang.sayName();
  bigbang.sayMembersCount();
  bigbang.sayMale();
}

class Idol{
  String name;
  
  int membersCount;
  
  Idol({
    required this.name,
    required this.membersCount,
  });
  
  void sayName(){
    print('저는 ${this.name}입니다.');
  }
  
  void sayMembersCount(){
    print('${this.name}은 ${this.membersCount}명의 멤버가 있습니다.');
  }
}

class BoyGroup extends Idol{
  BoyGroup(
    String name,
    int membersCount,
  ): super(
    name : name,
    membersCount : membersCount);
  
  void sayMale(){
    print('남자 아이돌 그룹입니다.');
  }
}
```

```dart
void main(){
 TimesTwo tt = TimesTwo(2);
  
  print(tt.calculate());
  
  TimesFour tf = TimesFour(2);
  
  print(tf.calculate());
}

class TimesTwo{
  final int number;
  
  TimesTwo(
    this.number,
  );
  
  int calculate(){
    return number * 2;
  }
}

class TimesFour extends TimesTwo{
  TimesFour(
    int number,
  ): super(number);
  
  @override
  int calculate(){
    return super.calculate() * 2;
  }
}
```

```dart
class Lecture<T>{
	final T id;
	final String name;
	
	Lecture(this.id, this.name);
}
```