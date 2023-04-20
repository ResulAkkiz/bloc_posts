import 'package:bloc_posts/blocs/post_bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context) {
        return PostBloc()..add(PostFetchEvent());
      },
      child: const MaterialApp(
        home: Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void addMethod() {}

  void _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(PostFetchEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.98);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostFailureState) {
              return Center(
                child: Text(state.error),
              );
            } else if (state is PostValueState) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  return index >= state.posts.length
                      ? const IndicatorWidget()
                      : ListTile(
                          leading: Text(state.posts[index].id.toString()),
                          title: Text(state.posts[index].title.toString()),
                          subtitle: Text(state.posts[index].body.toString()),
                          isThreeLine: true,
                        );
                },
              );
            } else {
              return const Center(
                child: Text('Lütfen Bekleyiniz...'),
              );
            }
          },
        ),
      ),
    );
  }
}

class IndicatorWidget extends StatefulWidget {
  const IndicatorWidget({super.key});

  @override
  State<IndicatorWidget> createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
      ),
    );
  }
}
