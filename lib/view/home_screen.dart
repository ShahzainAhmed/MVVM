import 'package:flutter/material.dart';
import 'package:mvvm/data/response/status.dart';
import 'package:mvvm/model/movies_model.dart';
import 'package:mvvm/utils/routes/routes_names.dart';
import 'package:mvvm/view_model/home_view_model.dart';
import 'package:mvvm/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    // TODO: implement initState
    homeViewModel.fetchMoviesListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPreferences = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        // removes back button
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              userPreferences.removeUser().then((value) {
                Navigator.pushNamed(context, RoutesNames.login);
              });
            },
            child: const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
            )),
          ),
          const SizedBox(height: 20)
        ],
      ),
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (BuildContext context) => homeViewModel,
        child: Consumer<HomeViewModel>(
          builder: ((context, value, _) {
            switch (value.moviesList.status) {
              case Status.LOADING:
                return const Center(child: CircularProgressIndicator());
              case Status.ERROR:
                return Text(value.moviesList.message.toString());
              case Status.COMPLETED:
                return ListView.builder(
                  // itemCount: value.moviesList.data?.movies?.length,
                  itemCount: value.moviesList.data?.products?.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      child: ListTile(
                          leading: Image.network(
                            "${value.moviesList.data?.products?[index].thumbnail}",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                          title: Text(
                              "${value.moviesList.data?.products?[index].title}"),
                          subtitle: Text(
                              "${value.moviesList.data?.products?[index].brand}"),
                          trailing: SizedBox(
                            // height: 100,
                            width: 70,
                            child: Row(
                              children: [
                                Text(
                                    "${value.moviesList.data?.products?[index].rating}" +
                                        "    "),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )
                              ],
                            ),
                          )

                          // title: Text("${value.moviesList.data?.products?[index].title}"),
                          ),
                    );
                  }),
                );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
