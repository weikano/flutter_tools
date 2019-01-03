import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';

class ReloadButton extends StatelessWidget {
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton.icon(
          onPressed: _onPressed,
          icon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          label: Text('RELOAD')),
    );
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

///简单的ListView
class NormalListPage<T> extends StatefulWidget {
  final Future<ApiResponse<List<T>>> future;
  final ItemWidgetBuilder builder;
  bool dividerWithPadding;

  NormalListPage(this.builder, this.future, {this.dividerWithPadding = false});

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
                  if (widget.dividerWithPadding) {
                    return _dividerWithPadding;
                  } else {
                    return _divider;
                  }
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

var _divider = Divider(
  height: 1,
  color: Colors.grey,
);

var _dividerWithPadding = Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12),
  child: _divider,
);

var padding = const EdgeInsets.all(12);

///简单的GridView
class NormalGridPage<T> extends StatefulWidget {
  final Future<ApiResponse<List<T>>> future;
  final ItemWidgetBuilder builder;
  final SliverGridDelegate gridDelegate;

  NormalGridPage({this.future, this.builder, this.gridDelegate});

  @override
  State<StatefulWidget> createState() {
    return _NormalGridPageState();
  }
}

class _NormalGridPageState<T> extends State<NormalGridPage<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      initialData: ApiResponse<List<T>>.ofLoading(),
      builder: (_, AsyncSnapshot<ApiResponse<List<T>>> data) {
        if (data.hasError) {
          return Center(
            child: ReloadButton(),
          );
        } else if (data.hasData) {
          var d = data.data;
          if (d.fail()) {
            return Center(
              child: ReloadButton(),
            );
          } else if (d.success()) {
            return GridView.builder(
              gridDelegate: widget.gridDelegate,
              itemBuilder: (_, index) {
                return widget.builder(
                    _,
                    d.response[index],
                    d.response.isEmpty || index == 0
                        ? null
                        : d.response[index - 1]);
              },
              itemCount: d.response.length,
            );
          }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
