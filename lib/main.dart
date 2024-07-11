import 'dart:convert';
import 'package:flutter_application_1/reorder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter_application_1/task.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Rerderable List',
      theme: ThemeData(
        dividerColor: const Color(0x50000000),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Reorderable List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ItemData {
  ItemData(this.title, this.key);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
}

enum DraggingMode {
  iOS,
  android,
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _items = [];

  _MyHomePageState() {
    _items = [];
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(
        Uri.parse(
            'http://test02.xymbia-dev.com/api/todo/v1/tasks?offset=0&size=200&orderby=customReordering.default desc'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWI4YmM4Zjc0MTVmN2M3OGM4OWE0ODQiLCJ1c2VybmFtZSI6ImFiZHVsbGFoc2hhaGlkYWJiYXNpQGhvdG1haWwuY29tIiwiYXZhdGFyIjoiLzlqLzRBQVFTa1pKUmdBQkFRRUFZQUJnQUFELzJ3QkRBQU1DQWdNQ0FnTURBd01FQXdNRUJRZ0ZCUVFFQlFvSEJ3WUlEQW9NREFzS0N3c05EaElRRFE0UkRnc0xFQllRRVJNVUZSVVZEQThYR0JZVUdCSVVGUlQvMndCREFRTUVCQVVFQlFrRkJRa1VEUXNORkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCVC93QUFSQ0FCZ0FHQURBU0lBQWhFQkF4RUIvOFFBSHdBQUFRVUJBUUVCQVFFQUFBQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkFBQWdFREF3SUVBd1VGQkFRQUFBRjlBUUlEQUFRUkJSSWhNVUVHRTFGaEJ5SnhGREtCa2FFSUkwS3h3UlZTMGZBa00ySnlnZ2tLRmhjWUdSb2xKaWNvS1NvME5UWTNPRGs2UTBSRlJrZElTVXBUVkZWV1YxaFpXbU5rWldabmFHbHFjM1IxZG5kNGVYcURoSVdHaDRpSmlwS1RsSldXbDVpWm1xS2pwS1dtcDZpcHFyS3p0TFcydDdpNXVzTER4TVhHeDhqSnl0TFQxTlhXMTlqWjJ1SGk0K1RsNXVmbzZlcng4dlAwOWZiMytQbjYvOFFBSHdFQUF3RUJBUUVCQVFFQkFRQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkVBQWdFQ0JBUURCQWNGQkFRQUFRSjNBQUVDQXhFRUJTRXhCaEpCVVFkaGNSTWlNb0VJRkVLUm9iSEJDU016VXZBVlluTFJDaFlrTk9FbDhSY1lHUm9tSnlncEtqVTJOemc1T2tORVJVWkhTRWxLVTFSVlZsZFlXVnBqWkdWbVoyaHBhbk4wZFhaM2VIbDZnb09FaFlhSGlJbUtrcE9VbFphWG1KbWFvcU9rcGFhbnFLbXFzck8wdGJhM3VMbTZ3c1BFeGNiSHlNbkswdFBVMWRiWDJObmE0dVBrNWVibjZPbnE4dlAwOWZiMytQbjYvOW9BREFNQkFBSVJBeEVBUHdDV0xVaHFLL2FyUzVhNHRwR0pTUUU0WVp4M3F5c3R4MTgxL3dBNk5NaWl1YkNLZTNqa2p0MmVTSkJLTU5sRzJ0OVFEeG10RkxZVityMEt2dEtVWk8xL0kvUHEwWENvNGxKWnJuUCt0ZjhBT25lYmNmOEFQUi96cTM5bUJOTDluMml0SGJjelVyRlFTejUvMWovblMrYlBuL1d2K2RXaEJubW5DREZUb2FwdGxkSlp5UWZOYkgxcWRKWmYrZWpmblQxaTRxUkl2YXAwSGNWWG14L3JXL09wNG5teHpLMUVjT1FjaXJDUlZOaTFKaXh0SUJuekdxM2F2STF3Zzh4dXZyVFVoUGFyZG5EL0FLUW1SM3JHUzBLVW5jelk5THVFOEpvc1pEdzI5NDVLNCtZRW9wNFBwMTRxVFFkSHQ5WmtGdWJscmU2YjdvWk1vZnh6MXJzdEgwd3phRnE4UXdyUTMwYkFnZE1vQldSWlJwcE9wTDVzSW10eko4OFkrVmxQOTVXN0d2Tm8xV28yWFpma2VwT2pDY3J5WGY4QU10Nng4STlRME5ndDNmV2NETnlqVGJvMGNlcXZncWZ6cmcvaURkV1h3dXM3Szg4UjM5cmEyZDdLME1FOE1ubkk3cU1sZmx6ampubXZycnd4YzNGcllMYnpPdW82ZTZnaUs1UUVnZS9ZMTh4ZjhGRGZobm9PcWZDelJOWXN0UGlzNXJmVjFXVkljeGdpU054bkE0NnFPM2V1RjVsV3AzVDFJcllLbEdtNXJvZWFSZkdMd1JLZWZFVnREMDVuVjR4K1pHSzZDeThUYUhxY1lrdE5aMDY1UThobzd1TTUvd0RIcStMNGZCVmhEdUxxN0Fkdk1KRk1tOE42WS95ckNxZjdxMFJ6YWYyb284RG5pZloxNTR6OE42WUNiclh0T2g5dnRLc2Z5Qk5WTEQ0bmVHTC9BTTAybXBDNldNNFpvbzJJL1VWOFFhaDRiU3kzTXUxa0l6bkdDS3M2ZnAvaUR3N0JIcTl0RGUyTnNEZ1hEUnNzVCszSXcxT2VhVkd2Y2lrTjNrbnlQVSs0RStKZmhoQWZQMVJMTENsdjlLUm84Z2Nrakk1cnpuVi8yc2ZEY0dyaXcwS3huOFFJUHZYTWIrV2c5eGtjaXZJNXZHTW5qand4RnBMb3RwY3lFck81RzdjdmZ5ejJKSEI5QlVlbGVFckxScmNSd3hxQU93L3FlOWN2OXExM3BaR2RQRU5RZnRWcjVIMEI0WS9hTjhNNnhxRVZsZlNQb2wxS2NScGVBS2puMmZwK3RleGFaS2x5OGJ4dXJLY0VFSFBGZkIzalRTN2VmUXBQTVJUZ2dJQ08vdFhWL3MrL0ZmWGZDWGluU05GYTRrMUhSN21ZUk5iWEIzTkZub1VZOGpIcDBycncyUGxOOHRSSFRUcUtjVTdINkcrRTdKWnJMeGNoTzB4eUNSZHZVRlV5UDVWeXVuNlpKNHI4VEpZMm9BZHlyU0VEaU5mNG1OZGg0VXVQc3NYaW81QVkzQVgvQU1odnhYVmZDbnd2Rm9IaG1QVjN0dk50OVJCRnkvVjQxRGtJMlA3aEdQcDFyRjFsU3UvSmZrajZpRVBhTzNtL3pObXpuVFM3aGRMdkI5bHVrVUxFN0g1SmdPaFUvd0JLOFcvYnI4bFAyZXBQTms4aHY3YXRGMzU2SEQ4L3BYMEtkRXRkWnRyalRid0xjUlJrbUdUUHpxUDRTRDMrdGZNdjdhbjJ0ZjJlN3ZTdFFYejdteDFtMFpDM0hteEVPQVFlaDYvblhseWFrcjlUZXVyVVpMeVBnMUlFbGlIbWhaSk8waURCeDdnY1ZZaDhQZmE3ZWFXUGNmTEdTQU1uMndPNXJtSWJXR3p1eE5FeHQxSXdZZDVCVSt1RFh2UDdKZHRGci94MzhKYU5meGllMnVMMVpXVnVRZkxVeUFmUTdLNTdud05uS3BHRjl6MUR3ZjhBczNhYjhIZkEwdmpUeHJhUjNtcncydjI0MjhvM3gyRVlHNVZBNkdVOEE1emduQTVCTmZJM2ozeFhxWHhDMSs0MWJVbjVrWStWYUkzN3EzVHNpRHNNZCtwcjlOLzI3TkdFWHdROFVUVzRNUWtqaGxtSXlGQytjbThuMjcxK1hDeFJXc2hMem93eHhnNXJvOW9wUVNSN2VQaDlWVWFNRWRMOEhQQTF2OFFmSHVsK0daTGk0MDQzNWVLSzVnaU12a3k3U1Zad1A0TWdBbmpHYTlqK0t2d0x1L2dyNEkwU2ZYYjFiL1hkUnZKWTVIdEZiN0xiUW9NTGx5Qm1TUWtISEdBcHhubXZEL0NueGc4US9EazNJOEw2dEpwclhKSG5OQWlicE1kQVNSbkh0bkZlZy9FbjlyanhwNDh1cjdUclhWWmJEdzVkV3NVRW1tTkRHeVNNRUhtTTJWSjVmY1I2Y1lxYkszbWMxS05CMG43UmU5ME9WYU1UZ2g4TUNPUWVheXZoOURGcEh4azhKdElBbHMycHdnZ2pqQk9QNjA3VGRRV2VLTmZNQmxBNmQ2cDM2dkxxK25USmxQczl6RXdZSEJKM2lsQ1hJN25uNGRTVStVL1R2d25wc3VzM1BpU3hoT0paTCtKTjM5M080Wi9uWHZlZ1J4YVhieDJFZkZ1c2FwR0dIb01WNDk4R0NKL0dmaU5DTWdYcU45TUdRWnIxV1RVWTdqVURhV3ltV2VQN3hYcEdQYzF0aXJ1ZHVsbCtTUHU4S3J4NXZOL21XWDAwNmRxRytGVlcyY1laUjJQdFh6biszcnBFZHo4RXIyNFg1TTZoYU0zUEIrZkFQMXI2ZnVaRld6SG1PTUFjazE4bC90eGVKanFYd1AxdXpzdjlWYjNGdEs4bU1uSWxBNC9PdVduelROY1QvQ2t2SS9QbGRKanVHeTZCeU9kemQ2N0w0UytNSS9oaDhXL0J2aUs3THg2WFkzd2E2bGhIekxFeWxUK1c3UDRWNUJkYW5xMFRiazFHVVk5aFZBZU05UXRad2wrd25UczJlYTA1VDRLTk9mT3Byb2Z0M3J1cGFWNHAwUjRMMWwxSFQ5UXQvTExHRVBIY1d6am5hYzRJWlQxcjgzZjJpUDJSTC80WjZoZGE3bzhOL3FuZ1NSLzNVektHazAvUFJaZ0FNcjZTZE9nT0RSK3ozKzJCTDhOOU5qOFA2L0RMckhoQjJKalNOaDU5Z1QxTVdlQ25jcGtleDdWOUdXLzdZSGhjV20ydzhaV045cHNpNE5ucVFNRWdVOVZPOGVucmtWdkNuR2FzdEQ2aVZTampvV3FhU1B6NWJ3cENHOHhMZ09SMENnQVZYc1BEZC9xMnRRMldsMlUrbzNrcmJFZ3QwTHNUK0hiM3I3dGt1UGdMNDRaN3FTMDhOdzN6djVrakxlUjI0SHJ3cmdmamlzalgvd0JvejRRL0FQUWJxTHd4RnBtcitJWlhjUldXaUZaQUJ4dDg2Zm5DNXp3Q1Q3VlhzZVhXVFBPV1hTaTd6cUt4OHdlUFBCa0h3MHV0RTBpOWszYTRMWTNXcU1oNGhkbS9keEQ2S3BKUCsxN1Y1MnVwblVmRmVuc0dQbC9hWXhnSGo3NHB2akw0ZzMvajN4RHFHdDZwTnZ2cjZVeXpiZUI3S1BRQVlBSG9LeHRHdTEvNFNEVFFoQi8wcUwvME1Wenl0ZlF3VUU2bDRyUS9ZTDRNM3pEeFI0dGtUSG1MS0NtVDBPK1FaSDUxNmZvMTlhNlJZU1IyVC9hcG5sTDNGd3BKQmIwM0hyWHo1OE5QRVZ0cDJwK0k1THFYWkhjT0VHR3hrbVJ2bHoyem5xYTdmVVBpNzRmOE9nRzV2RjFTK2c0ZzB2VEltV3p0dnF4KytmZXZTeEZDVTVybFhSZmtmUjBLa1lRZDMxZjVuZCtPOWV1TGJTek84elFvQmhWNlpKL25YekQrMExmeDNId1I4WWVZNGMvWS9NM04vZURxUi9LdGp4YjhXci94ZGVKSmNnbUdQT3lCZmtRVnlHdmFrUEVkaTlsZnd3WEZrNUJhMmRBWTJJT1JrZCtSbm11M0Q1ZlU1TE5XT1hFWXltN3BNK0I3WFROWDF4d05Pc0x1K0I3d3dPNC9NQ3JOejhMUEdGeWdkdkRlcFlIL0FFN05YM0hFNjI4U3hRS3NFU2pDeHhnS29Ib0FLbVM1YkgzaWZ4clpaVEg3VWp3bFpiSDUvTG8rdStIMzJYR21YbHZGazVqbnQyQUg1aXJEWGNqQVp0WlFmUVJIL0N2dnp6eTQrYjV4Nk55S2ZISWdHUWtZK2lpby9zbExhWTJydTdSK2RsM2FyZFM4Mm9ROXl5WXorZFRUNkpiNmRGRVo3aFE3cmxJNGNFbjhCWDZIeUpiM0s0bXRvSlI2UEdyRDlSVWNHbDZiYk9IZzA2eWhrSDhjZHNpbjlCV2Y5a043VC9BR24wWjhHK0dmaFQ0dDhjVHFtajZIY3ZDeC93Q1BtZERGRW85U3pZSDVacjZVK0ZIN0ptamVHNy9UdFU4UjNiYXhxY0VnbCt5Ui9MYUt3NlpHTno0UFBPQjdWN2dKempCWWtEb00xTGF6NHVJOGV0ZHRITDZWUFdXckxVbXRqbWJmV0hUVE5TQTJsTGgwVmdmVGVXNC9FRDhxcC9hL2VzMkZibjdBV01Fbk1pL3duMGFtN2JqL0FKNFArVmV0UVVlU0w2MlJGZFNkUnJ6WnAvYTg5Nlg3WjcxbWlPNC81NFNmbFNsSjhmNmlUOHE2TkRGUmwyTkFYSUxkYWVMckhROFZsaExqcjVEL0FKVW9TNUovMUwvOTgxRHR1YktMTlpidjNxU083QTZpc2NSWEFJeEMvd0NWU3JIYy93RFBKL3lxRzBYWm15dDJLbFc0WG1zWlZ1UCtlTC85ODFJQk9mOEFsbS81Vk4rd3JNMmhjbjYxWXRMa2ZhSStlOVlBODgvOHNuL0tyRm9aeGN4ZnVuKzhPeHFXMFdrZi85az0iLCJlbWFpbCI6ImFiZHVsbGFoc2hhaGlkYWJiYXNpQGhvdG1haWwuY29tIiwiZmlyc3ROYW1lIjoiQWJkdWxsYWgiLCJsYXN0TmFtZSI6IkFiYmFzaSIsInN1YlR5cGUiOiJ1c2VyIiwiaWF0IjoxNzE4MTcxNzU4fQ.18YWoxy2vB5DspqAlaSefg0v_HTGRbMTHKg7Zva9p5s',
        });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _items = data.map((taskJson) => Task.fromJson(taskJson)).toList();
        print(ReorderListUtil.isInitial(_items, 'default'));
      });
    } else {
      print(response.reasonPhrase);
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> sendData(List<Map<String, dynamic>> input, String screen, bool override ) async {
    final data = {
      "list": input,
      'reorderScreen': screen,
      'override': override,
    };

    final response = await http.post(
      Uri.parse(
          'http://test02.xymbia-dev.com/api/todo/v1/tasks/actions/reorder'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWI4YmM4Zjc0MTVmN2M3OGM4OWE0ODQiLCJ1c2VybmFtZSI6ImFiZHVsbGFoc2hhaGlkYWJiYXNpQGhvdG1haWwuY29tIiwiYXZhdGFyIjoiLzlqLzRBQVFTa1pKUmdBQkFRRUFZQUJnQUFELzJ3QkRBQU1DQWdNQ0FnTURBd01FQXdNRUJRZ0ZCUVFFQlFvSEJ3WUlEQW9NREFzS0N3c05EaElRRFE0UkRnc0xFQllRRVJNVUZSVVZEQThYR0JZVUdCSVVGUlQvMndCREFRTUVCQVVFQlFrRkJRa1VEUXNORkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCVC93QUFSQ0FCZ0FHQURBU0lBQWhFQkF4RUIvOFFBSHdBQUFRVUJBUUVCQVFFQUFBQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkFBQWdFREF3SUVBd1VGQkFRQUFBRjlBUUlEQUFRUkJSSWhNVUVHRTFGaEJ5SnhGREtCa2FFSUkwS3h3UlZTMGZBa00ySnlnZ2tLRmhjWUdSb2xKaWNvS1NvME5UWTNPRGs2UTBSRlJrZElTVXBUVkZWV1YxaFpXbU5rWldabmFHbHFjM1IxZG5kNGVYcURoSVdHaDRpSmlwS1RsSldXbDVpWm1xS2pwS1dtcDZpcHFyS3p0TFcydDdpNXVzTER4TVhHeDhqSnl0TFQxTlhXMTlqWjJ1SGk0K1RsNXVmbzZlcng4dlAwOWZiMytQbjYvOFFBSHdFQUF3RUJBUUVCQVFFQkFRQUFBQUFBQUFFQ0F3UUZCZ2NJQ1FvTC84UUF0UkVBQWdFQ0JBUURCQWNGQkFRQUFRSjNBQUVDQXhFRUJTRXhCaEpCVVFkaGNSTWlNb0VJRkVLUm9iSEJDU016VXZBVlluTFJDaFlrTk9FbDhSY1lHUm9tSnlncEtqVTJOemc1T2tORVJVWkhTRWxLVTFSVlZsZFlXVnBqWkdWbVoyaHBhbk4wZFhaM2VIbDZnb09FaFlhSGlJbUtrcE9VbFphWG1KbWFvcU9rcGFhbnFLbXFzck8wdGJhM3VMbTZ3c1BFeGNiSHlNbkswdFBVMWRiWDJObmE0dVBrNWVibjZPbnE4dlAwOWZiMytQbjYvOW9BREFNQkFBSVJBeEVBUHdDV0xVaHFLL2FyUzVhNHRwR0pTUUU0WVp4M3F5c3R4MTgxL3dBNk5NaWl1YkNLZTNqa2p0MmVTSkJLTU5sRzJ0OVFEeG10RkxZVityMEt2dEtVWk8xL0kvUHEwWENvNGxKWnJuUCt0ZjhBT25lYmNmOEFQUi96cTM5bUJOTDluMml0SGJjelVyRlFTejUvMWovblMrYlBuL1d2K2RXaEJubW5DREZUb2FwdGxkSlp5UWZOYkgxcWRKWmYrZWpmblQxaTRxUkl2YXAwSGNWWG14L3JXL09wNG5teHpLMUVjT1FjaXJDUlZOaTFKaXh0SUJuekdxM2F2STF3Zzh4dXZyVFVoUGFyZG5EL0FLUW1SM3JHUzBLVW5jelk5THVFOEpvc1pEdzI5NDVLNCtZRW9wNFBwMTRxVFFkSHQ5WmtGdWJscmU2YjdvWk1vZnh6MXJzdEgwd3phRnE4UXdyUTMwYkFnZE1vQldSWlJwcE9wTDVzSW10eko4OFkrVmxQOTVXN0d2Tm8xV28yWFpma2VwT2pDY3J5WGY4QU10Nng4STlRME5ndDNmV2NETnlqVGJvMGNlcXZncWZ6cmcvaURkV1h3dXM3Szg4UjM5cmEyZDdLME1FOE1ubkk3cU1sZmx6ampubXZycnd4YzNGcllMYnpPdW82ZTZnaUs1UUVnZS9ZMTh4ZjhGRGZobm9PcWZDelJOWXN0UGlzNXJmVjFXVkljeGdpU054bkE0NnFPM2V1RjVsV3AzVDFJcllLbEdtNXJvZWFSZkdMd1JLZWZFVnREMDVuVjR4K1pHSzZDeThUYUhxY1lrdE5aMDY1UThobzd1TTUvd0RIcStMNGZCVmhEdUxxN0Fkdk1KRk1tOE42WS95ckNxZjdxMFJ6YWYyb284RG5pZloxNTR6OE42WUNiclh0T2g5dnRLc2Z5Qk5WTEQ0bmVHTC9BTTAybXBDNldNNFpvbzJJL1VWOFFhaDRiU3kzTXUxa0l6bkdDS3M2ZnAvaUR3N0JIcTl0RGUyTnNEZ1hEUnNzVCszSXcxT2VhVkd2Y2lrTjNrbnlQVSs0RStKZmhoQWZQMVJMTENsdjlLUm84Z2Nrakk1cnpuVi8yc2ZEY0dyaXcwS3huOFFJUHZYTWIrV2c5eGtjaXZJNXZHTW5qand4RnBMb3RwY3lFck81RzdjdmZ5ejJKSEI5QlVlbGVFckxScmNSd3hxQU93L3FlOWN2OXExM3BaR2RQRU5RZnRWcjVIMEI0WS9hTjhNNnhxRVZsZlNQb2wxS2NScGVBS2puMmZwK3RleGFaS2x5OGJ4dXJLY0VFSFBGZkIzalRTN2VmUXBQTVJUZ2dJQ08vdFhWL3MrL0ZmWGZDWGluU05GYTRrMUhSN21ZUk5iWEIzTkZub1VZOGpIcDBycncyUGxOOHRSSFRUcUtjVTdINkcrRTdKWnJMeGNoTzB4eUNSZHZVRlV5UDVWeXVuNlpKNHI4VEpZMm9BZHlyU0VEaU5mNG1OZGg0VXVQc3NYaW81QVkzQVgvQU1odnhYVmZDbnd2Rm9IaG1QVjN0dk50OVJCRnkvVjQxRGtJMlA3aEdQcDFyRjFsU3UvSmZrajZpRVBhTzNtL3pObXpuVFM3aGRMdkI5bHVrVUxFN0g1SmdPaFUvd0JLOFcvYnI4bFAyZXBQTms4aHY3YXRGMzU2SEQ4L3BYMEtkRXRkWnRyalRid0xjUlJrbUdUUHpxUDRTRDMrdGZNdjdhbjJ0ZjJlN3ZTdFFYejdteDFtMFpDM0hteEVPQVFlaDYvblhseWFrcjlUZXVyVVpMeVBnMUlFbGlIbWhaSk8waURCeDdnY1ZZaDhQZmE3ZWFXUGNmTEdTQU1uMndPNXJtSWJXR3p1eE5FeHQxSXdZZDVCVSt1RFh2UDdKZHRGci94MzhKYU5meGllMnVMMVpXVnVRZkxVeUFmUTdLNTdud05uS3BHRjl6MUR3ZjhBczNhYjhIZkEwdmpUeHJhUjNtcncydjI0MjhvM3gyRVlHNVZBNkdVOEE1emduQTVCTmZJM2ozeFhxWHhDMSs0MWJVbjVrWStWYUkzN3EzVHNpRHNNZCtwcjlOLzI3TkdFWHdROFVUVzRNUWtqaGxtSXlGQytjbThuMjcxK1hDeFJXc2hMem93eHhnNXJvOW9wUVNSN2VQaDlWVWFNRWRMOEhQQTF2OFFmSHVsK0daTGk0MDQzNWVLSzVnaU12a3k3U1Zad1A0TWdBbmpHYTlqK0t2d0x1L2dyNEkwU2ZYYjFiL1hkUnZKWTVIdEZiN0xiUW9NTGx5Qm1TUWtISEdBcHhubXZEL0NueGc4US9EazNJOEw2dEpwclhKSG5OQWlicE1kQVNSbkh0bkZlZy9FbjlyanhwNDh1cjdUclhWWmJEdzVkV3NVRW1tTkRHeVNNRUhtTTJWSjVmY1I2Y1lxYkszbWMxS05CMG43UmU5ME9WYU1UZ2g4TUNPUWVheXZoOURGcEh4azhKdElBbHMycHdnZ2pqQk9QNjA3VGRRV2VLTmZNQmxBNmQ2cDM2dkxxK25USmxQczl6RXdZSEJKM2lsQ1hJN25uNGRTVStVL1R2d25wc3VzM1BpU3hoT0paTCtKTjM5M080Wi9uWHZlZ1J4YVhieDJFZkZ1c2FwR0dIb01WNDk4R0NKL0dmaU5DTWdYcU45TUdRWnIxV1RVWTdqVURhV3ltV2VQN3hYcEdQYzF0aXJ1ZHVsbCtTUHU4S3J4NXZOL21XWDAwNmRxRytGVlcyY1laUjJQdFh6biszcnBFZHo4RXIyNFg1TTZoYU0zUEIrZkFQMXI2ZnVaRld6SG1PTUFjazE4bC90eGVKanFYd1AxdXpzdjlWYjNGdEs4bU1uSWxBNC9PdVduelROY1QvQ2t2SS9QbGRKanVHeTZCeU9kemQ2N0w0UytNSS9oaDhXL0J2aUs3THg2WFkzd2E2bGhIekxFeWxUK1c3UDRWNUJkYW5xMFRiazFHVVk5aFZBZU05UXRad2wrd25UczJlYTA1VDRLTk9mT3Byb2Z0M3J1cGFWNHAwUjRMMWwxSFQ5UXQvTExHRVBIY1d6am5hYzRJWlQxcjgzZjJpUDJSTC80WjZoZGE3bzhOL3FuZ1NSLzNVektHazAvUFJaZ0FNcjZTZE9nT0RSK3ozKzJCTDhOOU5qOFA2L0RMckhoQjJKalNOaDU5Z1QxTVdlQ25jcGtleDdWOUdXLzdZSGhjV20ydzhaV045cHNpNE5ucVFNRWdVOVZPOGVucmtWdkNuR2FzdEQ2aVZTampvV3FhU1B6NWJ3cENHOHhMZ09SMENnQVZYc1BEZC9xMnRRMldsMlUrbzNrcmJFZ3QwTHNUK0hiM3I3dGt1UGdMNDRaN3FTMDhOdzN6djVrakxlUjI0SHJ3cmdmamlzalgvd0JvejRRL0FQUWJxTHd4RnBtcitJWlhjUldXaUZaQUJ4dDg2Zm5DNXp3Q1Q3VlhzZVhXVFBPV1hTaTd6cUt4OHdlUFBCa0h3MHV0RTBpOWszYTRMWTNXcU1oNGhkbS9keEQ2S3BKUCsxN1Y1MnVwblVmRmVuc0dQbC9hWXhnSGo3NHB2akw0ZzMvajN4RHFHdDZwTnZ2cjZVeXpiZUI3S1BRQVlBSG9LeHRHdTEvNFNEVFFoQi8wcUwvME1Wenl0ZlF3VUU2bDRyUS9ZTDRNM3pEeFI0dGtUSG1MS0NtVDBPK1FaSDUxNmZvMTlhNlJZU1IyVC9hcG5sTDNGd3BKQmIwM0hyWHo1OE5QRVZ0cDJwK0k1THFYWkhjT0VHR3hrbVJ2bHoyem5xYTdmVVBpNzRmOE9nRzV2RjFTK2c0ZzB2VEltV3p0dnF4KytmZXZTeEZDVTVybFhSZmtmUjBLa1lRZDMxZjVuZCtPOWV1TGJTek84elFvQmhWNlpKL25YekQrMExmeDNId1I4WWVZNGMvWS9NM04vZURxUi9LdGp4YjhXci94ZGVKSmNnbUdQT3lCZmtRVnlHdmFrUEVkaTlsZnd3WEZrNUJhMmRBWTJJT1JrZCtSbm11M0Q1ZlU1TE5XT1hFWXltN3BNK0I3WFROWDF4d05Pc0x1K0I3d3dPNC9NQ3JOejhMUEdGeWdkdkRlcFlIL0FFN05YM0hFNjI4U3hRS3NFU2pDeHhnS29Ib0FLbVM1YkgzaWZ4clpaVEg3VWp3bFpiSDUvTG8rdStIMzJYR21YbHZGazVqbnQyQUg1aXJEWGNqQVp0WlFmUVJIL0N2dnp6eTQrYjV4Nk55S2ZISWdHUWtZK2lpby9zbExhWTJydTdSK2RsM2FyZFM4Mm9ROXl5WXorZFRUNkpiNmRGRVo3aFE3cmxJNGNFbjhCWDZIeUpiM0s0bXRvSlI2UEdyRDlSVWNHbDZiYk9IZzA2eWhrSDhjZHNpbjlCV2Y5a043VC9BR24wWjhHK0dmaFQ0dDhjVHFtajZIY3ZDeC93Q1BtZERGRW85U3pZSDVacjZVK0ZIN0ptamVHNy9UdFU4UjNiYXhxY0VnbCt5Ui9MYUt3NlpHTno0UFBPQjdWN2dKempCWWtEb00xTGF6NHVJOGV0ZHRITDZWUFdXckxVbXRqbWJmV0hUVE5TQTJsTGgwVmdmVGVXNC9FRDhxcC9hL2VzMkZibjdBV01Fbk1pL3duMGFtN2JqL0FKNFArVmV0UVVlU0w2MlJGZFNkUnJ6WnAvYTg5Nlg3WjcxbWlPNC81NFNmbFNsSjhmNmlUOHE2TkRGUmwyTkFYSUxkYWVMckhROFZsaExqcjVEL0FKVW9TNUovMUwvOTgxRHR1YktMTlpidjNxU083QTZpc2NSWEFJeEMvd0NWU3JIYy93RFBKL3lxRzBYWm15dDJLbFc0WG1zWlZ1UCtlTC85ODFJQk9mOEFsbS81Vk4rd3JNMmhjbjYxWXRMa2ZhSStlOVlBODgvOHNuL0tyRm9aeGN4ZnVuKzhPeHFXMFdrZi85az0iLCJlbWFpbCI6ImFiZHVsbGFoc2hhaGlkYWJiYXNpQGhvdG1haWwuY29tIiwiZmlyc3ROYW1lIjoiQWJkdWxsYWgiLCJsYXN0TmFtZSI6IkFiYmFzaSIsInN1YlR5cGUiOiJ1c2VyIiwiaWF0IjoxNzE4MTcxNzU4fQ.18YWoxy2vB5DspqAlaSefg0v_HTGRbMTHKg7Zva9p5s',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      fetchTasks();
    } else {
      print('Failed to send data. Error: ${response.reasonPhrase}');
    }
  }

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((Task d) => Key(d.id) == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      // debugPrint("Reordering $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    int index = _indexOfKey(item);
    bool override = false;
    String screen = 'default';
    var resp = ReorderListUtil.handleReorder(index, _items, screen, override);
    sendData(resp.map((e) => e.toMap()).toList(), screen, override);

    // final draggedItem = _items[index];
    // debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableList(
        onReorder: _reorderCallback,
        onReorderDone: _reorderDone,
        child: CustomScrollView(
          // cacheExtent: 3000,
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                PopupMenuButton<DraggingMode>(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: const Text("Options"),
                  ),
                  initialValue: _draggingMode,
                  onSelected: (DraggingMode mode) {
                    setState(() {
                      _draggingMode = mode;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<DraggingMode>>[
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.iOS,
                        child: Text('iOS-like dragging')),
                    const PopupMenuItem<DraggingMode>(
                        value: DraggingMode.android,
                        child: Text('Android-like dragging')),
                  ],
                ),
              ],
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Demo'),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Item(
                        data: _items[index],
                        // first and tillIndex attributes affect border drawn during dragging
                        isFirst: index == 0,
                        isLast: index == _items.length - 1,
                        draggingMode: _draggingMode,
                      );
                    },
                    childCount: _items.length,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.data,
    required this.isFirst,
    required this.isLast,
    required this.draggingMode,
  }) : super(key: key);

  final Task data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = const BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              color: const Color(0x08000000),
              child: const Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 14.0),
                    child: Text(data.title,
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
                  Text(data.customReordering?['default'].toString() ?? 'null'),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: Key(data.id), //
        childBuilder: _buildChild);
  }
}
