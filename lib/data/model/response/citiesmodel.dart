class CitiesModel {
  int? id;
  String? name;
  int? minPrice;
  int? minProduct;

  CitiesModel({
    this.id,
    this.name,
    this.minPrice,
    this.minProduct,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        id: json["id"],
        name: json["name"],
        minPrice: json["min_price"],
        minProduct: json["min_product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "min_price": minPrice,
        "min_product": minProduct,
      };
}
