class AddFormData {
  String? heading;
  String? subheading;
  String? doc;
  String? earlycamp;
  String? trails;
  String? carousel;
  String? options;

  AddFormData({this.heading, this.subheading, this.doc, this.earlycamp,this.carousel,this.options,this.trails});

  Map<String, dynamic> toJson() {
    return {
      "heading": this.heading,
      "subheading": this.subheading,
      "doc": this.doc,
      "earlycamp": this.earlycamp,
      "trails": this.trails,
      "carousel": this.carousel,
      "options": this.options,
    };
  }

  factory AddFormData.fromJson(Map<String, dynamic> json) {
    return AddFormData(
        heading: json["heading"] ?? "",
        subheading: json["subheading"] ?? "",
        doc: json["doc"] ?? "",
        earlycamp: json["earlycamp"] ?? "",
         trails: json["trails"] ?? "",
          carousel: json["carousel"] ?? "",
           options: json["options"] ?? "",
        );
  }
}
