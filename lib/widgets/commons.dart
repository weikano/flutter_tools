import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';

class ReloadButton extends StatelessWidget {
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: _onPressed,
        icon: Icon(
          Icons.close,
          color: Colors.red,
        ),
        label: Text('RELOAD'));
  }

  ReloadButton({VoidCallback onPressed}) : _onPressed = onPressed;
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class NormalListPage<T> extends StatefulWidget {
  final Future<ApiResponse<List<T>>> future;
  final ItemWidgetBuilder builder;

  NormalListPage(this.builder, this.future);

  @override
  State<StatefulWidget> createState() {
    return _NormalListPageState();
  }
}

typedef ItemWidgetBuilder = Widget Function(
    BuildContext context, dynamic data, dynamic prev);

class _NormalListPageState<T> extends State<NormalListPage<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (_, AsyncSnapshot<ApiResponse<List<T>>> data) {
        if (data.hasError) {
          return Center(child: ReloadButton());
        } else if (data.hasData) {
          var d = data.data;
          if (d.fail()) {
            return Center(
              child: ReloadButton(),
            );
          } else if (d.success()) {
            return ListView.separated(
                itemBuilder: (_, index) {
                  return widget.builder(
                      _,
                      d.response[index],
                      d.response.isEmpty || index == 0
                          ? null
                          : d.response[index - 1]);
                },
                separatorBuilder: (_, index) {
                  return _divider;
                },
                itemCount: d.response.length);
          }
        }
        return LoadingIndicator();
      },
      future: widget.future,
      initialData: ApiResponse<List<T>>.ofLoading(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

var _divider = SizedBox(
  height: 1,
  child: Container(
    color: Colors.grey,
  ),
);

var padding = const EdgeInsets.all(12);
