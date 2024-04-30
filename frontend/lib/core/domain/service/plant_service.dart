import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_and_flora/core/exception/ident_limit_exception.dart';
import 'package:me_and_flora/core/exception/plant_exception.dart';

import '../models/models.dart';
import '../models/plant_type.dart';

int count = 0;

class PlantService {

  Future<void> addPlant(Plant plant) async {
    /*
    final response = await Dio().get("path");
    if () {
      throw Exception();
    }
     */
  }

  Future<void> removePlant(Plant plant) async {

  }

  Future<List<Plant>> getUnknownPlants() async {
    /*final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    List<Plant> plantList = [];
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          type: PlantType.unknown,
          imageUrl: "something",
        lat: Random().nextInt(50).toDouble(),
        lon: Random().nextInt(50).toDouble()
      ));
    }
    return plantList;
  }

  Future<List<Plant>> getFlowers() async {
    /*final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    List<Plant> plantList = [];
    //File file = File("C:\\Users\\Work\\Pictures\\Iris.png");
    File file = File('assets/images/Iris.png');
    plantList.add(Plant(
        name: "Ирис",
        type: PlantType.flower,
        description:
        "И́рис, или Каса́тик, или Петушо́к (лат. Íris) — род многолетних "
            "корневищных растений семейства Ирисовые, или Касатиковые "
            "(Iridaceae). Встречаются на всех континентах. Род насчитывает около"
            " 800 видов с богатейшим разнообразием форм и оттенков, за что и "
            "получил своё название (от др.-греч. ἶρῐς — радуга).",
        isTracked: false,
        imageUrl: file.path));
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          name: "Plant${i + 1}",
          type: PlantType.flower,
          description:
          "Цвето́к (множ. цветки́, лат. flos, -oris, др.-греч. ἄνθος, -ου) — "
              "система органов семенного размножения цветковых (покрытосеменных)"
              " растений.",
          isTracked: i % 2 == 0,
          imageUrl: "something"));
    }
    return plantList;
  }

  Future<List<Plant>> getTrees() async {
    /*
    final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    List<Plant> plantList = [];
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          name: "Plant${i + 1}",
          type: PlantType.tree,
          description:
          "Де́рево (лат. árbor) — жизненная форма деревянистых растений с "
              "единственной, отчётливо выраженной, многолетней, в разной степени"
              " одревесневшей, сохраняющейся в течение всей жизни, разветвлённой"
              " (кроме пальм) главной осью — стволом.",
          isTracked: i % 2 == 0,
          imageUrl: "something"));
    }
    return plantList;
  }

  Future<List<Plant>> getGrass() async {
    /*final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    List<Plant> plantList = [];
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          name: "Plant${i + 1}",
          type: PlantType.grass,
          description:
          "Травяни́стые расте́ния, также тра́вы, — жизненная форма высших растений "
              "с недолго живущими надземными побегами. Травы имеют листья и "
              "стебли, отмирающие в конце вегетационного периода на поверхности "
              "почвы. Они не имеют постоянного древесного ствола над землёй. "
              "Травянистые растения бывают как однолетними (терофиты) и "
              "двулетними, так и многолетними.",
          isTracked: i % 2 == 0,
          imageUrl: "something"));
    }
    return plantList;
  }

  Future<List<Plant>> getMoss() async {
    /*
    final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    final dataList = data.entries
        .map((e) => Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']))
        .toList();
    return dataList;*/
    List<Plant> plantList = [];
    for (int i = 0; i < 30; i++) {
      plantList.add(Plant(
          name: "Plant${i + 1}",
          type: PlantType.moss,
          description:
          "Моховидные, или Мхи, или Настоящие мхи, или Бриофиты (лат. Bryophyta),"
              " — отдел высших растений, насчитывающий около 13 тысяч видов, "
              "объединённых в более чем 900 родов и около 100 семейств[1] (общее"
              " число всех мохообразных, включая Печёночные мхи и Антоцеротовые "
              "мхи, составляет около 20 000 видов[2]). Как правило, это мелкие "
              "растения, длина которых лишь изредка превышает 50 мм; исключение "
              "составляют водные мхи, некоторые из которых имеют длину более "
              "полуметра, и эпифиты, которые могут быть ещё более длинными. "
              "Моховидные, как и другие Мохообразные, отличаются от других "
              "высших растений тем, что в их жизненном цикле гаплоидный "
              "гаметофит преобладает над диплоидным спорофитом.",
          isTracked: i % 2 == 0,
          imageUrl: "something"));
    }
    return plantList;
  }

  Future<Plant> findPlantByName(String plantName) async {
    /*
    final response = await Dio().get("path");
    final data = response.data as Map<String, dynamic>;

    return Plant(
        name: e.value['name'],
        type: e.value['type'],
        description: e.value['description'],
        isLiked: e.value['isLiked'],
        imageUrl: e.value['imageUrl']);
        */
    if (plantName == "Error") {
      throw PlantNotFoundException();
    }
    return Plant(
        name: plantName,
        type: PlantType.moss,
        description: "Расте́ния (лат. Plantae, или Vegetabilia) — биологическое "
            "царство, одна из основных групп многоклеточных организмов, "
            "отличительной чертой представителей которой является способность к "
            "фотосинтезу, и включающая в себя мхи, папоротники, хвощи, плауны, "
            "голосеменные и цветковые растения. Нередко к растениям относят "
            "также все водоросли или некоторые их группы. Растения (в первую "
            "очередь, цветковые) представлены многочисленными жизненными формами,"
            " наиболее распространёнными из которых являются деревья, кустарники"
            " и травы.",
        isTracked: true,
        imageUrl: "something");
  }

  Future<Plant> findPlantByPhoto(String imagePath) async {
    count++;
    if (count > 5) {
      throw IdentLimitException();
    }
    return Plant(
        name: "plantName",
        type: PlantType.moss,
        description: "Расте́ния (лат. Plantae, или Vegetabilia) — биологическое "
            "царство, одна из основных групп многоклеточных организмов, "
            "отличительной чертой представителей которой является способность к "
            "фотосинтезу, и включающая в себя мхи, папоротники, хвощи, плауны, "
            "голосеменные и цветковые растения. Нередко к растениям относят "
            "также все водоросли или некоторые их группы. Растения (в первую "
            "очередь, цветковые) представлены многочисленными жизненными формами,"
            " наиболее распространёнными из которых являются деревья, кустарники"
            " и травы.",
        isTracked: true,
        imageUrl: imagePath);
  }

  Future<void> identByBotanic(String imagePath) async {
    //Dio().post("path");
  }
}
