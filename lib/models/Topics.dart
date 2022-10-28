class Topic {
  final String topicName;
  final List<String> topics;

  Topic({required this.topicName, required this.topics});

  static List<Topic> topicJsonToList(List<Map> json) {
    print(json.toString());
    List<Topic> list = [];

    List<String> concepts = [];
    for (int i = 0; i < json.length - 1; i++) {


      for(int j=0;j<json[i]['concepts']?.length;j++){
        concepts.add(json[i]['concepts'][j]);

      }

      list.add(Topic(topicName: json[i]['topicName'], topics: concepts));
      concepts = [];
    }

    return list;

    print(list.toString());

    return [
      Topic(topicName: "Error", topics: ["hello", "fjskg"])
    ];
  }
}
