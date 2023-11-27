part of '../home_screen.dart';

mixin HomeScreenMixin on State<HomeScreen> {
  List items = [];
  List filteredItems = [];

  final searchController = TextEditingController();

  // BottomNavigationBar items
  List<BottomNavigationBarItem> bottomBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Icon(Icons.home_filled, size: 30),
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Icon(Icons.build_outlined, size: 30),
      ),
      label: "Settings",
    ),
  ];

  // BottomNavigationBar's tapped index
  final int _selectedIndex = 0;

  // GridDelegate for GridView
  final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1,
  );

  @override
  void initState() {
    super.initState();
    fetchBreedNames();
  }

  void fetchBreedNames() async {
    await getBreedNames();
  }

  Future<void> getBreedNames() async {
    var url = Uri.parse("https://dog.ceo/api/breeds/list/all");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var breeds = jsonData["message"] as Map<String, dynamic>;

      List<BreedModel> tempItems = [];
      for (var breed in breeds.keys) {
        var imageUrl = await _fetchBreedImageUrl(breed);
        tempItems.add(BreedModel(
          name: breed,
          subBreeds: List<String>.from(breeds[breed]),
          imageUrl: imageUrl,
        ));
      }

      setState(() {
        items = tempItems;
      });
    } else {
      print('Failed to load breeds');
    }
  }

  Future<String> _fetchBreedImageUrl(String breed) async {
    var response = await http
        .get(Uri.parse("https://dog.ceo/api/breed/$breed/images/random"));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return jsonData["message"];
    } else {
      debugPrint('Failed to load image for breed: $breed');
      return ''; // Varsayılan bir resim URL'si veya boş bir string dönebilirsiniz.
    }
  }

  Widget _buildSearchBar() {
    return Positioned(
      bottom: standartPadding,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,right:16,left:16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  border: textFieldBorder(),
                  enabledBorder: textFieldBorder(),
                  focusedBorder: textFieldBorder(),
                  disabledBorder: textFieldBorder(),
                  contentPadding: const EdgeInsets.only(left: 16),
                  fillColor: kSecondarySystemBackgroundGray,
                  filled: true,
                  hintText: "Search",
                  hintStyle: body.copyWith(color: kSecondaryLabelLight)),
              onChanged: (searchQuery) {
                //Bazen çalışıyor bazen exception veriyor

                // searchQuery = searchQuery.toLowerCase();
                // setState(() {
                //   filteredItems = items.where((breed) {
                //     return breed.name.toLowerCase().contains(searchQuery);
                //   }).toList();                
                // });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridView(List<BreedModel> breeds) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
                child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount:
                  filteredItems.isEmpty ? breeds.length : filteredItems.length,
              itemBuilder: (context, index) {
                BreedModel breed = filteredItems.isEmpty
                    ? breeds[index]
                    : filteredItems[index];
                return _buildGridItem(breed);
              },
            )),
          ],
        ),
        _buildSearchBar()
      ],
    );
  }

  OutlineInputBorder textFieldBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: kSecondarySystemBackgroundGray),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: toolbarHeight,
      centerTitle: true,
      backgroundColor: kSecondarySystemBackgroundGray,
      title: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          "Doggy App",
          style: title3,
        ),
      ),
      elevation: 0,
    );
  }

  Future<void> _showDetails(BreedModel breed) async {
    await showDialog(
        context: context, builder: (context) => CustomModal(breed: breed));
  }

  Widget _buildGridItem(BreedModel breed) {
    return InkWell(
      onTap: () {
        _showDetails(breed);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: 163,
          width: 163,
          decoration: const BoxDecoration(
              color: kSystemGray,
              borderRadius: BorderRadius.all(Radius.circular(kBorder))),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned.fill(
                child: breed.imageUrl != null
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(kBorder)),
                        child: Image.network(
                          breed.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons.broken_image));
                          },
                        ),
                      )
                    : const Center(child: Icon(Icons.image_not_supported)),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 38,
                  width: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: kBlackColor.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(kBorder),
                          bottomLeft: Radius.circular(kBorder))),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(kBorder),
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        breed.name,
                        style: body,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
borderRadius:
                        const BorderRadius.only(topRight:  Radius.circular(80),topLeft: Radius.circular(80) ),
      child: Container(
        height: 98,
        decoration: BoxDecoration(
          border: Border.all(color: kSystemGray, width: 2),
          color: kSecondarySystemBackgroundGray,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildBottomBarItem(Icons.home_filled, "Home", 0),
            _buildDivider(),
            _buildBottomBarItem(Icons.build_outlined, "Settings", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, String label, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon,
                size: 30,
                color: index == _selectedIndex ? kPrimaryColor : kBlackColor),
            const SizedBox(height: 3),
            Text(label,
                style: index == _selectedIndex
                    ? caption2.copyWith(color: kPrimaryColor)
                    : caption2),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return  Container(
      height: 24,
      width:3,
      color:kSystemGray
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 1) {
      Navigator.of(context).push(_createRoute());
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SettingsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
