import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quantum_it_assignment/constants.dart';
import 'package:quantum_it_assignment/models/userdata.dart';
import 'package:quantum_it_assignment/screens/profile.dart';
import 'package:quantum_it_assignment/screens/search.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool load = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var data = Provider.of<UserData>(context, listen: false);
    await data.loadData();
    setState(() {
      load = false;
    });
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) {
      showToast('No link to source');
      return;
    }
    if (!await launchUrl(Uri.parse(url))) {
      showToast('Could not launch');
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Quantum News'),
        actions: [
          IconButton(
              onPressed: () {
                gotoScreen(context, const Search());
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                gotoScreen(context, const Profile());
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: SafeArea(
        child: load
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 50.h),
                child: ListView(
                  children: [
                    Text('Top Articles',
                        style: TextStyle(
                          fontSize: 70.sp,
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 70.h,
                    ),
                    ListView.builder(
                        itemCount: data.newsData.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () => _launchUrl(data.newsData[index].url),
                              child: Card(
                                margin: EdgeInsets.only(bottom: 50.h),
                                elevation: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (data.newsData[index].urlToImage != null)
                                      Image.network(data
                                          .newsData[index].urlToImage
                                          .toString()),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50.w, vertical: 30.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data.newsData[index].source?.name}',
                                            style: TextStyle(
                                              fontSize: 35.sp,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            data.newsData[index].title ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.openSans(
                                              fontSize: 43.sp,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            data.newsData[index].description ??
                                                "",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.openSans(
                                              fontSize: 35.sp,
                                              color: Colors.grey.shade800,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50.h,
                                          ),
                                          Text(
                                            '${data.newsData[index].publishedAt?.day}/${data.newsData[index].publishedAt?.month}/${data.newsData[index].publishedAt?.year}',
                                            style: TextStyle(
                                              fontSize: 35.sp,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                    SizedBox(
                      height: 70.h,
                    ),
                    Center(
                      child: Text("You're All Caught Up",
                          style: TextStyle(
                            fontSize: 60.sp,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Text("You've seen all the top articles",
                          style: TextStyle(
                            fontSize: 45.sp,
                            color: Colors.grey.shade700,
                          )),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextButton(
                        onPressed: () {
                          gotoScreen(context, const Search());
                        },
                        child: const Text('Search an article')),
                    SizedBox(
                      height: 70.h,
                    ),
                  ],
                )),
      ),
    );
  }
}
