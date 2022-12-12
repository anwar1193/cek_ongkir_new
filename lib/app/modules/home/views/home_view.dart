import 'package:cek_ongkir_new/app/data/models/city_model.dart';

import '../../../data/models/province_model.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cek Ongkir JNE, TIKI, POS'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            DropdownSearch<Province>(
              showSearchBox: true,
              popupItemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi Asal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
              onFind: (text) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {
                    "key": "b4a17c5ab4ec8196e29f63b00ae95bc6",
                  },
                );

                return Province.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              // Saat dropdown dipilih, ambil value-nya
              onChanged: (value) =>
                  controller.provinsiAsalId.value = value?.provinceId ?? "0",
            ),
            SizedBox(
              height: 10,
            ),
            DropdownSearch<City>(
              showSearchBox: true,
              popupItemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.type} ${item.cityName}"),
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/Kabupaten Asal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
              onFind: (text) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city?province=${controller.provinsiAsalId}",
                  queryParameters: {
                    "key": "b4a17c5ab4ec8196e29f63b00ae95bc6",
                  },
                );

                return City.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              // Saat dropdown dipilih, ambil value-nya
              onChanged: (value) =>
                  controller.kotaAsalId.value = value?.cityId ?? "0",
            ),
            SizedBox(
              height: 20,
            ),
            DropdownSearch<Province>(
              showSearchBox: true,
              popupItemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi Tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
              onFind: (text) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {
                    "key": "b4a17c5ab4ec8196e29f63b00ae95bc6",
                  },
                );

                return Province.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              // Saat dropdown dipilih, ambil value-nya
              onChanged: (value) =>
                  controller.provinsiTujuanId.value = value?.provinceId ?? "0",
            ),
            SizedBox(
              height: 10,
            ),
            DropdownSearch<City>(
              showSearchBox: true,
              popupItemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.type} ${item.cityName}"),
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/Kabupaten Tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
              onFind: (text) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city?province=${controller.provinsiTujuanId}",
                  queryParameters: {
                    "key": "b4a17c5ab4ec8196e29f63b00ae95bc6",
                  },
                );

                return City.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              // Saat dropdown dipilih, ambil value-nya
              onChanged: (value) =>
                  controller.kotaTujuanId.value = value?.cityId ?? "0",
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.beratC,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Berat (Gram)",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownSearch<Map<String, dynamic>>(
              items: [
                {
                  "code": "jne",
                  "name": "JNE",
                },
                {
                  "code": "pos",
                  "name": "POS Indonesia",
                },
                {
                  "code": "tiki",
                  "name": "TIKI",
                },
              ],
              showSearchBox: true,
              popupItemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item['name']}"),
              ),
              dropdownSearchDecoration: InputDecoration(
                labelText: "Pilih Kurir",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
              dropdownBuilder: (context, selectedItem) => Text(
                "${selectedItem?['name'] ?? "Pilih Kurir"}",
              ),
              onChanged: (value) =>
                  controller.kodeKurir.value = value?['code'] ?? '',
            ),
            SizedBox(
              height: 30,
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  // Jika tidak loading baru tampilkan data
                  if (controller.isLoading.isFalse) {
                    controller.cekOngkir();
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "CEK ONGKIR" : "Loading.."),
              ),
            )
          ],
        ));
  }
}
