class ReorderListUtil {
  static bool isInitial(List<IReorderableItem> items, String key) {
    return items.every((task) => task.customReordering?[key] == null);
  }

  static List<ReorderedListData> assignIndexes(
      int position, List<IReorderableItem> items, String key, bool override) {
    List<ReorderedListData> reqData = [];
    num prev = items[0].customReordering?[key] ?? 0;
    bool discontinuity = false;
    for (int i = 0; i < items.length && i < position + 2; i++) {
      if (items[i].customReordering?[key] == null ||
          discontinuity ||
          override) {
        discontinuity = true;
        reqData.add(ReorderedListData(id: items[i].id, index: prev - 1));
        prev = prev - 1;
      } else {
        prev = items[i].customReordering?[key];
      }
    }
    return reqData;
  }

  static List<ReorderedListData> handleReorder(
      int position, List<IReorderableItem> items, String key, bool override) {
    List<ReorderedListData> resp = [];
    if (items.isEmpty) {
      resp = [];
    } else if (override || isInitial(items, key)) {
      resp = assignIndexes(items.length - 1, items, key, override);
    } else if (position == 0 && items.length == 1) {
      resp = [ReorderedListData(id: items[position].id, index: 0)];
    } else if (position == 0 &&
        items[position + 1].customReordering?[key] != null) {
      resp = [
        ReorderedListData(
            id: items[position].id,
            index: (items[position + 1].customReordering?[key]) + 1)
      ];
    } else if (position == items.length - 1 &&
        items[position - 1].customReordering?[key] != null) {
      resp = [
        ReorderedListData(
            id: items[position].id,
            index: (items[position - 1].customReordering?[key]) - 1)
      ];
    } else if (position != 0 &&
        position != items.length - 1 &&
        items[position + 1].customReordering?[key] != null &&
        items[position - 1].customReordering?[key] != null) {
      num average = ((items[position - 1].customReordering?[key] +
              items[position + 1].customReordering?[key]) /
          2);
      //prevent 2 items from having same index
      if ((items[position - 1].customReordering?[key] ==
              items[position + 1].customReordering?[key]) ||
          (items[position - 1].customReordering?[key] == average) ||
          (average == items[position + 1].customReordering?[key])) {
        resp = [];
      } else {
        resp = [ReorderedListData(id: items[position].id, index: average)];
      }
    } else {
      resp = assignIndexes(position, items, key, override);
    }
    return resp;
  }
}

class ReorderedListData {
  String? id;
  num? index;

  ReorderedListData({
    this.id,
    this.index,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'index': index,
    };
  }

  @override
  bool operator ==(covariant ReorderedListData other) {
    if (identical(this, other)) return true;

    return other.id == id && other.index == index;
  }
}

abstract class IReorderableItem {
  String? id;
  Map<String, dynamic>? customReordering;
}
