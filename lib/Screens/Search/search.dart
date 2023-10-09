import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/globalvariable.dart';
import '../../Components/custom_image.dart';
import '../../theme/color.dart';
import '../Product Screen/product_screen.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  String? keyword;

  SearchPage({super.key, this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  //final double _minRating = 0;
  //final double _maxRating = 5;
  //double _selectedMinRating = 0.0;
 // double _selectedMaxRating = 0.0;


  final double _minPrice = 0;
  final double _maxPrice = 100000;
  double _selectedMinPrice = 0.0;
  double _selectedMaxPrice = 0.0;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if(widget.keyword != null){
      filterProductsByKeyword();
    }
    else{
      performSearch('');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Create a text controller and reference it
  final TextEditingController _searchController = TextEditingController();
  String searchedText = '';

  // A list to hold the search results
  List<DocumentSnapshot> _searchResults = [];

  // A flag to determine if the search has completed
  bool _isSearching = false;
  bool isTyping = false;
  bool isFilterOpen = false;

  void performSearch(String searchItem, {double? minPrice, double? maxPrice, double? minRating}) async {
    // Get a reference to the products collection
    var ref = FirebaseFirestore.instance.collection('/Products');
    // Convert the search query to uppercase
    searchItem = searchItem.toUpperCase();
    // Build a query for title filtering
    var titleQuery = ref.where('title', isGreaterThanOrEqualTo: searchItem);

    var titleSnapshot = await titleQuery.get();
    var titleDocs = titleSnapshot.docs;

    // Apply price and rating filtering on the title filtered documents
    var filteredDocs = titleDocs.where((doc) {
      var data = doc.data();
      var price = data['price'].toDouble();
      var rating = data['rating'].toDouble();
      return (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice) &&
          (minRating == null || rating >= minRating);
    }).toList();

    // Update the search results
    setState(() {
      _searchResults = filteredDocs;
      _isSearching = false;
    });
  }

  // Function to filter the products based on selected option
  void filterProductsByKeyword({double? minPrice, double? maxPrice, double? minRating}) async {
    setState(() {
      _isSearching = true;
    });
    // Filter the Firestore collection by 'keywords' field
    var keywordQuery = FirebaseFirestore.instance
        .collection('/Products')
        .where('keywords', arrayContains: widget.keyword?.toLowerCase());

    var keywordSnapshot = await keywordQuery.get();
    var keywordDocs = keywordSnapshot.docs;

    var filteredDocs = keywordDocs.where((doc) {
      var data = doc.data();
      var price = data['price'].toDouble();
      var rating = data['rating'].toDouble();
      return (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice) &&
          (minRating == null || rating >= minRating);
    }).toList();

    setState(() {
      _searchResults = filteredDocs;
      _isSearching = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 0)), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        floatingActionButton: Visibility(
          visible: widget.keyword != null ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.to(
                  BottomBar(bottomIndex: 0),
                  transition: Transition.leftToRight
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              icon: const Icon(
                  Icons.arrow_back_rounded
              ),
              label: const Text('Go Back'),
            ),
          ),
        ),
        body: Padding(
          padding: MediaQuery.of(context).size.width >= 600 ?
          EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05 - 10) :
          const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Space From Top
              SizedBox(
                height: MediaQuery.of(context).size.height*0.045,
              ),
              //Page title
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Search Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist'
                      ),
                    ),
                  ),
                ],
              ),

              // A text field for the user to enter their search query
              Card(
                elevation: 6,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.9 - 24,
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                              fontFamily: 'Urbanist'
                          ),
                          prefixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _searchController.clear();
                                  isTyping = false;
                                  isFilterOpen = false;
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => BottomBar(bottomIndex: 0),),
                                  );

                                });
                              },
                              child: const Icon(Icons.arrow_back_rounded)
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                if(_searchController.text != ''){
                                  setState(() {
                                    _isSearching = true;
                                    performSearch(_searchController.text);
                                    isTyping = false;
                                  });
                                }
                              },
                              child: const Icon(
                                Icons.search_rounded,
                              )
                          ),
                        ),
                        controller: _searchController,
                        onChanged: (value) {
                          // Start the search when the user enters a value in the text field
                          setState(() {
                            widget.keyword = null;
                            keyword = null;
                            isTyping = true;
                            searchedText = _searchController.text;
                            isFilterOpen = false;
                            _selectedMinPrice = 0;
                            _selectedMaxPrice = 1000000;
                            //_selectedMinRating = 0;
                            //_selectedMaxRating = 5;
                          });
                          // Perform the search
                          performSearch(value);
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _isSearching = true;
                            performSearch(value);
                            isTyping = false;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFilterOpen = true;
                        });
                      },
                      child: Icon(
                          Icons.filter_alt_outlined,
                        color: _focusNode.hasFocus ? Colors.blue : Colors.grey ,
                      ),
                    )
                  ],
                ),
              ),

              // A loading indicator while the search is in progress
              _isSearching ? const LinearProgressIndicator()
                  : const SizedBox(
                height: 0,
                width: 0,
              ),

              //Filter
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isFilterOpen ?
                Row(
                  children: [
                    //Rating
                    /*Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10, left: 18),
                            child: Text(
                                'Rating',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist'
                              ),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.45,
                          child: RangeSlider(
                            values: RangeValues(_selectedMinRating, _selectedMaxRating),
                            min: _minRating,
                            max: _maxRating,
                            divisions: 5,
                            labels: RangeLabels(
                              _selectedMinRating.toString(),
                              _selectedMaxRating.toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _selectedMinRating = values.start;
                                _selectedMaxRating = values.end;
                                performSearch(
                                    searchedText,
                                    minRating: _selectedMaxRating,
                                    minPrice: _selectedMinPrice,
                                    maxPrice: _selectedMaxPrice
                                );
                              });
                            },
                          ),
                        )
                      ],
                    ),*/
                    //Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(top: 10, left: 18),
                            child: Text(
                              'Price',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Urbanist'
                              ),
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 30,//0.45
                          child: RangeSlider(
                            values: RangeValues(_selectedMinPrice, _selectedMaxPrice),
                            min: _minPrice,
                            max: _maxPrice,
                            divisions: 100,
                            labels: RangeLabels(
                              _selectedMinPrice.toString(),
                              _selectedMaxPrice.toString(),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _selectedMinPrice = values.start;
                                _selectedMaxPrice = values.end;
                                performSearch(
                                    searchedText,
                                    //minRating: _selectedMaxRating,
                                    minPrice: _selectedMinPrice,
                                    maxPrice: _selectedMaxPrice
                                );
                              });
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ) : const SizedBox(),
              ),

              //Keyword
              if(widget.keyword != null)...[
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        padding: const EdgeInsets.only(top: 5, bottom: 6, left: 10, right: 10),
                        child: Text(
                          widget.keyword!.isNotEmpty ? '${widget.keyword}' : '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Urbanist',
                              fontSize: 20,
                              color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.keyword = null;
                            keyword = null;
                          });

                          performSearch('');
                        },
                        child: const Icon(
                            Icons.cancel_outlined,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ]
              else...[
                const SizedBox(height: 10,)
              ],

              // The search results are displayed in a list view
              if(isTyping == false || widget.keyword != null)...[
                Expanded(
                  child: ResponsiveGridList(
                    horizontalGridSpacing: 0, // Horizontal space between grid items
                    verticalGridSpacing: 0, // Vertical space between grid items
                    horizontalGridMargin: 0, // Horizontal space around the grid
                    verticalGridMargin: 0, // Vertical space around the grid
                    minItemWidth: 300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                    minItemsPerRow: 2, // The minimum items to show in a single row. Takes precedence over minItemWidth
                    maxItemsPerRow: null, // The maximum items to show in a single row. Can be useful on large screens
                    listViewBuilderOptions: ListViewBuilderOptions(
                      //physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                    ), // Options that are getting passed to the ListView.builder() function
                    children: List.generate(
                        _searchResults.length,
                            (index) {
                              var result = _searchResults[index];
                              double discountCal = (result.get('price') / 100) * (100 - result.get('discount'));

                              return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      /*Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductScreen(productId: product.id))
                          );*/
                                      Get.to(
                                        ProductScreen(productId: result.id),
                                        transition: Transition.fade,
                                      );
                                    },
                                    child: SizedBox(
                                      //width: 200,
                                      width: MediaQuery.of(context).size.width*0.48,
                                      height: 300,
                                      child: Stack(
                                        children: [
                                          //Pulls image from variation 1's 1st image
                                          FutureBuilder(
                                            future: FirebaseFirestore
                                                .instance
                                                .collection('/Products/${result.id}/Variations').get(),
                                            builder: (context, snapshot) {
                                              if(snapshot.hasData){
                                                String docID = snapshot.data!.docs.first.id;
                                                return FutureBuilder(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('/Products/${result.id}/Variations').doc(docID).get(),
                                                  builder: (context, imageSnapshot) {
                                                    if(imageSnapshot.hasData){
                                                      return CustomImage(
                                                        imageSnapshot.data?['images'][0],
                                                        radius: 10,
                                                        width: 200,
                                                        height: 210,//210
                                                      );
                                                    }else if(imageSnapshot.connectionState == ConnectionState.waiting){
                                                      return const Center(
                                                        child: LinearProgressIndicator(),
                                                      );
                                                    }
                                                    else{
                                                      return const Center(
                                                        child: Text(
                                                          "Nothings Found",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                              else if(snapshot.connectionState == ConnectionState.waiting){
                                                return const Center(
                                                  child: LinearProgressIndicator(),
                                                );
                                              }
                                              else{
                                                return const Center(
                                                  child: Text(
                                                    "Nothings Found",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),

                                          //Discount %Off
                                          if(result.get('discount') != 0)...[
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade800,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:   const EdgeInsets.all(7),
                                                  child: Text(
                                                    'Discount: ${result.get('discount')}%',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 11
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],

                                          //Title
                                          Positioned(
                                            top: 220,
                                            left: 5,
                                            child: Text(
                                              result.get('title'),
                                              style: const TextStyle(
                                                  overflow: TextOverflow.clip,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.black45//darker
                                              ),
                                            ),
                                          ),

                                          //price
                                          Positioned(
                                              top: 240,
                                              left: 5,
                                              child: Row(
                                                children: [
                                                  /*SvgPicture.asset(
                                        "assets/icons/taka.svg",
                                        width: 17,
                                        height: 17,
                                      ),*/
                                                  Text(
                                                    "Tk ${discountCal.toStringAsFixed(2)}/-",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 16,
                                                        color: textColor),
                                                  ),
                                                ],
                                              )
                                          ),

                                          //Rating & Sold Amount
                                          /*Positioned(
                                top: 260,
                                left: 2,
                                child:  Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 3,),
                                    //Rating
                                    Text(
                                      product.get('rating').toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.grey.shade400//darker
                                      ),
                                    ),
                                    const SizedBox(width: 20,),
                                    //Sold
                                    Text(
                                      "${product.get('sold').toString()} Sold",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.grey.shade400//darker
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                                        ],
                                      ),
                                    ),
                                  )
                              );
                        }
                    ), // The list of widgets in the grid
                  ),
                )
              ]
              else...[
                // The search suggestions are displayed in a list view
                Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore
                          .instance
                          .collection('/Products').get(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return Card(
                            child: ListView.separated(
                              itemCount: _searchResults.length, // _searchResults.length
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: GestureDetector(
                                    onTap: () {
                                      _isSearching = true;
                                      performSearch(_searchResults[index].get('title'));
                                      isTyping = false;
                                      _searchController.clear();
                                    },
                                    child: Text(
                                      _searchResults[index].get('title'),
                                      maxLines: 1,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          fontFamily: 'Urbanist'
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                          );
                        }else if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(
                            child: LinearProgressIndicator(),
                          );
                        }else{
                          return const Center(
                            child: Text('Error Loading Data'),
                          );
                        }
                      }
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
