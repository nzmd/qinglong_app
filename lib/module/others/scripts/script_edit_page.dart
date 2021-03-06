import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/config/config_viewmodel.dart';
import 'package:qinglong_app/utils/extension.dart';

class ScriptEditPage extends ConsumerStatefulWidget {
  final String content;
  final String title;
  final String path;

  const ScriptEditPage(this.title, this.path, this.content, {Key? key}) : super(key: key);

  @override
  _ScriptEditPageState createState() => _ScriptEditPageState();
}

class _ScriptEditPageState extends ConsumerState<ScriptEditPage> {
  late TextEditingController _controller;
  FocusNode node = FocusNode();

  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        node.requestFocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: '编辑${widget.title}',
        actions: [
          InkWell(
            onTap: () async {
              HttpResponse<NullResponse> response = await Api.updateScript(widget.title, widget.path, _controller.text);
              if (response.success) {
                "提交成功".toast();
                Navigator.of(context).pop(true);
              } else {
                (response.message ?? "").toast();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: SingleChildScrollView(
          child: TextField(
            focusNode: node,
            style: TextStyle(
              color: ref.read(themeProvider).themeColor.descColor(),
              fontSize: 14,
            ),
            controller: _controller,
            minLines: 1,
            maxLines: 100,
          ),
        ),
      ),
    );
  }
}
