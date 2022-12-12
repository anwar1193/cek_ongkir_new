import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as myhttp;
import '../../../data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkosKirim = [];

  RxBool isLoading = false.obs;

  RxString provinsiAsalId = "0".obs;
  RxString kotaAsalId = "0".obs;
  RxString provinsiTujuanId = "0".obs;
  RxString kotaTujuanId = "0".obs;
  RxString kodeKurir = ''.obs;

  void cekOngkir() async {
    if (provinsiAsalId != '0' &&
        provinsiTujuanId != '0' &&
        kotaAsalId != '0' &&
        kotaTujuanId != '0' &&
        kodeKurir != '' &&
        beratC.text != '') {
      try {
        isLoading.value = true;
        var response = await myhttp.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": "b4a17c5ab4ec8196e29f63b00ae95bc6",
            "content-type": "application/x-www-form-urlencoded",
          },
          body: {
            "origin": kotaAsalId.value,
            "destination": kotaTujuanId.value,
            "weight": beratC.text,
            "courier": kodeKurir.value,
          },
        );

        isLoading.value = false;

        List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;

        ongkosKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
          title: "Ongkos Kirim",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkosKirim
                .map(
                  (e) => ListTile(
                    title: Text("${e.service!.toUpperCase()}"),
                    subtitle: Text("Rp ${e.cost![0].value}"),
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak Dapat Mengecek Ongkos Kirim",
        );
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi Kesalahan", middleText: "Data Input Belum Lengkap");
    }
  }
}
