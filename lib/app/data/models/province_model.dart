class Province {
  String? provinceId;
  String? province;

  Province({this.provinceId, this.province});

  Province.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province_id'] = provinceId;
    data['province'] = province;
    return data;
  }

  // Supaya bisa menampilkan data list
  static List<Province> fromJsonList(List? data) {
    if (data == null || data.length == 0) return [];
    return data.map((e) => Province.fromJson(e)).toList();
  }

  // Supaya pencarian dropdown_search bisa berfungsi
  @override
  String toString() => province!;
}
