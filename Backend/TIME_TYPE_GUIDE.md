# Time Type Handling Guide: Flutter ↔ Spring Boot

## Quick Reference

| Component | Type | Format | Example |
|-----------|------|--------|---------|
| **Backend (Java)** | `LocalDateTime` | ISO 8601 | `"2026-01-29T12:25:00"` |
| **Backend (Java)** | `LocalDate` | ISO 8601 | `"2026-01-29"` |
| **Frontend (Dart)** | `DateTime` | ISO 8601 | `"2026-01-29T12:25:00.123456"` |

---

## Backend (Spring Boot)

### Global Configuration

**File**: `JacksonConfig.java`

All `LocalDateTime` and `LocalDate` fields are automatically serialized/deserialized using ISO 8601 format:
- **Timezone**: `Asia/Seoul` (configured in `application.properties`)
- **Format**: ISO 8601 without milliseconds (`yyyy-MM-dd'T'HH:mm:ss`)
- **No timestamps**: `write-dates-as-timestamps=false`

### Usage in DTOs

```java
// ✅ Recommended: Plain LocalDateTime (uses global config)
public record PartyDetailResponse(
    Long partyId,
    LocalDateTime createdAt,
    LocalDateTime startedAt
) {}

// ❌ Not needed: @JsonFormat annotation (redundant with global config)
@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
private LocalDateTime createdAt;
```

### Entity Classes

Use `@CreationTimestamp` and `@UpdateTimestamp` for automatic timestamp management:

```java
@CreationTimestamp
@Column(name = "created_at", nullable = false, updatable = false)
private LocalDateTime createdAt;

@UpdateTimestamp
@Column(name = "updated_at")
private LocalDateTime updatedAt;
```

### Special Case: Elapsed Time

Some fields represent **elapsed time** (duration), not timestamps:

```java
// ✅ Use Integer for elapsed seconds
public record PloggingEndRequest(
    Integer endTime  // 소요 시간 (초 단위) - NOT a timestamp!
) {}

// Entity stores elapsed time
@Entity
public class Plogging {
    private Integer times;  // 소요 시간 (초)
}
```

---

## Frontend (Flutter)

### Receiving Data (Backend → Flutter)

```dart
// Model class fromJson
class Party {
  final DateTime? createdAt;
  
  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
```

### Sending Data (Flutter → Backend)

**For timestamp fields** (rare - most APIs use server-side timestamps):

```dart
import 'package:jupddang/utils/datetime_utils.dart';

// When sending DateTime to server
final requestBody = {
  'startTime': DateTimeUtils.toApiFormat(startTime),
  'endTime': DateTimeUtils.toApiFormat(endTime),
};
```

**For elapsed time** (common pattern):

```dart
// Calculate elapsed seconds
final startTime = DateTime.now();
// ... user activity ...
final endTime = DateTime.now();
final elapsedSeconds = endTime.difference(startTime).inSeconds;

final requestBody = {
  'endTime': elapsedSeconds,  // Integer, not DateTime!
};
```

### DateTimeUtils Helper

**File**: `lib/utils/datetime_utils.dart`

```dart
class DateTimeUtils {
  /// Convert DateTime to ISO 8601 string for API requests
  /// Removes milliseconds for cleaner format matching backend
  static String toApiFormat(DateTime dateTime) {
    return dateTime.toIso8601String().split('.')[0]; // "2026-01-29T12:25:00"
  }
  
  /// Parse ISO 8601 string from API response
  static DateTime? fromApiFormat(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;
    return DateTime.tryParse(dateTimeString);
  }
  
  /// Convert UTC to local time
  static DateTime utcToLocal(DateTime utc) => utc.toLocal();
  
  /// Convert local time to UTC
  static DateTime localToUtc(DateTime local) => local.toUtc();
}
```

---

## Timezone Handling

### Backend Strategy
- **Store**: All times in `Asia/Seoul` timezone
- **Database**: PostgreSQL connection initialized with `SET TIME ZONE 'Asia/Seoul'`
- **API**: Send times in `Asia/Seoul` timezone (no UTC conversion)

### Frontend Strategy
- **Receive**: Parse as-is (assumes server timezone)
- **Display**: Use local device timezone for UI
- **Send**: Send in local timezone (server will interpret as `Asia/Seoul`)

### UTC Conversion (if needed in future)

```dart
// Convert to UTC before sending
DateTime local = DateTime.now();
DateTime utc = local.toUtc();
String utcString = utc.toIso8601String(); // "2026-01-29T03:25:00.000Z"

// Convert from UTC after receiving
DateTime received = DateTime.parse("2026-01-29T03:25:00Z");
DateTime localTime = received.toLocal();
```

---

## Common Patterns

### Pattern 1: Server-Side Timestamps (Recommended)

Most creation/update times should be managed by the server:

```java
// Backend - automatic timestamp
@CreationTimestamp
private LocalDateTime createdAt;
```

```dart
// Flutter - just receive and display
final party = Party.fromJson(json);
print('Created: ${party.createdAt}');
```

### Pattern 2: Elapsed Time (Current Implementation)

For activity duration, send elapsed seconds:

```dart
// Flutter - calculate duration
final elapsed = endTime.difference(startTime).inSeconds;
final requestBody = {'endTime': elapsed};
```

```java
// Backend - store as Integer
public record PloggingEndRequest(Integer endTime) {}
```

### Pattern 3: Client-Side Timestamps (Rare)

Only when client time is specifically needed:

```dart
// Flutter - send timestamp
final requestBody = {
  'clientTimestamp': DateTimeUtils.toApiFormat(DateTime.now())
};
```

```java
// Backend - receive as LocalDateTime
public record SomeRequest(LocalDateTime clientTimestamp) {}
```

---

## API Examples

### Example 1: Party Detail Response

**Backend Response**:
```json
{
  "partyId": 1,
  "name": "플로깅 모임",
  "createdAt": "2026-01-29T12:25:00",
  "startedAt": "2026-01-29T12:30:00"
}
```

**Flutter Parsing**:
```dart
class Party {
  final DateTime? createdAt;
  final DateTime? startedAt;
  
  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      startedAt: DateTime.tryParse(json['startedAt'] ?? ''),
    );
  }
}
```

### Example 2: Plogging End Request

**Flutter Request**:
```dart
final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;

final requestBody = {
  'ploggingId': null,
  'content': '플로깅 완료!',
  'distance': 3.5,
  'LineString': ['...'],
  'trashImages': ['...'],
  'endTime': elapsedSeconds  // Integer: 3600 (1 hour)
};
```

**Backend DTO**:
```java
public record PloggingEndRequest(
    Long ploggingId,
    String content,
    Double distance,
    List<String> LineString,
    List<String> trashImages,
    Integer endTime  // 소요 시간 (초)
) {}
```

---

## Testing

### Backend Unit Test

```java
@Test
void testLocalDateTimeSerialization() throws Exception {
    LocalDateTime testTime = LocalDateTime.of(2026, 1, 29, 12, 25, 0);
    String json = objectMapper.writeValueAsString(testTime);
    assertEquals("\"2026-01-29T12:25:00\"", json);
}
```

### Flutter Test

```dart
test('DateTime serialization matches backend format', () {
  final dateTime = DateTime(2026, 1, 29, 12, 25, 0);
  final formatted = DateTimeUtils.toApiFormat(dateTime);
  expect(formatted, equals('2026-01-29T12:25:00'));
});
```

---

## Summary

✅ **Backend**: Global `JacksonConfig` handles all `LocalDateTime`/`LocalDate` serialization  
✅ **Frontend**: `DateTime.tryParse()` for receiving, `DateTimeUtils.toApiFormat()` for sending  
✅ **Timezone**: `Asia/Seoul` throughout the stack  
✅ **Format**: ISO 8601 (`yyyy-MM-dd'T'HH:mm:ss`)  
✅ **Special**: Use `Integer` for elapsed time, not timestamps  

**No `@JsonFormat` annotations needed** - global configuration handles everything!
