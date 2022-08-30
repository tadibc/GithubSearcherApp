import 'package:flutter/material.dart';
import 'package:github_repo_searcher/api.dart';
import 'package:github_repo_searcher/repo.dart';
import 'package:github_repo_searcher/item.dart';
import 'package:github_repo_searcher/search.dart';

class Home extends StatefulWidget {
  const  Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repo> _repos = [];
  bool _isFetching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    loadTrendingRepos();
  }

  void loadTrendingRepos() async {
    setState(() {
      _isFetching = true;
      _error = null;
    });

    final repos = await Api.getTrendingRepositories();
    setState(() {
      _isFetching = false;
      // ignore: unnecessary_null_comparison
      if (repos != null) {
        _repos = repos;
      } else {
        _error = 'Error fetching repos';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Column(
              children: <Widget>[
                Text('Github Repos',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.apply(color: Colors.white)),
                Text('Trending',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: Colors.white))
              ],
            )),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchList(key: null,),
                    ));
              }),
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_isFetching) {
      return Container(
          alignment: Alignment.center, child: const Icon(Icons.timelapse));
    // ignore: unnecessary_null_comparison
    } else if (_error != null) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            _error!,
            style: Theme.of(context).textTheme.titleLarge,
          ));
    } else {
      return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _repos.length,
          itemBuilder: (BuildContext context, int index) {
            return GithubItem(_repos[index]);
          });
    }
  }
}
