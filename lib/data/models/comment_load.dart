import 'dart:convert';

CommentLoad commentLoadFromJson(String str) =>
    CommentLoad.fromJson(json.decode(str));

String commentLoadToJson(CommentLoad data) => json.encode(data.toJson());

class CommentLoad {
  bool isLoadingSingleNewsComments;
  int singleNewsCommentsPageNum;
  int singleNewsCommentsPageSize;
  bool hasMoreSingleNewsComments;

  CommentLoad({
    required this.isLoadingSingleNewsComments,
    required this.singleNewsCommentsPageNum,
    required this.singleNewsCommentsPageSize,
    required this.hasMoreSingleNewsComments,
  });

  factory CommentLoad.fromJson(Map<String, dynamic> json) => CommentLoad(
        isLoadingSingleNewsComments: json["isLoadingSingleNewsComments"],
        singleNewsCommentsPageNum: json["singleNewsCommentsPageNum"],
        singleNewsCommentsPageSize: json["singleNewsCommentsPageSize"],
        hasMoreSingleNewsComments: json["hasMoreSingleNewsComments"],
      );

  Map<String, dynamic> toJson() => {
        "isLoadingSingleNewsComments": isLoadingSingleNewsComments,
        "singleNewsCommentsPageNum": singleNewsCommentsPageNum,
        "singleNewsCommentsPageSize": singleNewsCommentsPageSize,
        "hasMoreSingleNewsComments": hasMoreSingleNewsComments,
      };
}
