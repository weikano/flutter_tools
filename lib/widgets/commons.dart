import 'package:flutter/material.dart';
import 'package:flutter_tools/basic.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';

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

class EmptyWidget extends StatelessWidget {
  String message;

  EmptyWidget.factory({this.message = '空空如也'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/icons/empty.png",
          ),
          Divider(
            height: 8,
            color: Colors.transparent,
          ),
          Text(message)
        ],
      ),
    );
  }
}

typedef OnItemClickListener = Function(BuildContext context, dynamic data);
typedef ItemWidgetBuilder = Widget Function(
    BuildContext context, dynamic data, dynamic prev);

class _NormalListNoMoreItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('NO MORE DATA'),
        ),
      ),
    );
  }
}

///加载更多的item，只用于NormalListPage
class _NormalListMoreItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          ),
          SizedBox(
            width: 12,
          ),
          Text('Loading'),
        ],
      ),
    );
  }
}

///简单的ListView
class NormalListPage<T> extends StatefulWidget {
  final Future<ApiResponse<List<T>>> future;
  final ItemWidgetBuilder builder;
  final OnItemClickListener onItemClick;
  bool dividerWithPadding;

  NormalListPage(this.builder, this.future,
      {this.dividerWithPadding = false, this.onItemClick});

  @override
  State<StatefulWidget> createState() {
    return _NormalListPageState();
  }
}

class _NormalListPageState<T> extends State<NormalListPage<T>>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext _context) {
    var controller = ScrollController();
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
            if (d.response.isEmpty) {
              return EmptyWidget.factory();
            }
            return DraggableScrollbar.semicircle(
              controller: controller,
              child: ListView.separated(
                  controller: controller,
                  itemBuilder: (_, index) {
                    if (index == d.response.length) {
                      return _NormalListNoMoreItem();
                    }
                    return InkWell(
                      onTap: () {
                        if (widget.onItemClick != null) {
                          widget.onItemClick(context, data);
                        }
                      },
                      child: widget.builder(
                          _,
                          d.response[index],
                          d.response.isEmpty || index == 0
                              ? null
                              : d.response[index - 1]),
                    );
                  },
                  separatorBuilder: (_, index) {
                    if (widget.dividerWithPadding) {
                      return _dividerWithPadding;
                    } else {
                      return _divider;
                    }
                  },
                  itemCount: d.response.length + 1),
            );
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
    var controller = ScrollController();
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
            if (d.response.isEmpty) {
              return EmptyWidget.factory();
            }
            return DraggableScrollbar.semicircle(
              controller: controller,
              child: GridView.builder(
                controller: controller,
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
              ),
            );
          }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
