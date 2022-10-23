import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quantum_it_assignment/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/userdata.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

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

  List<Widget> showCards() {
    List<Widget> res = [];
    var data = Provider.of<UserData>(context);
    for (dynamic news in data.searchResult) {
      res.add(GestureDetector(
        onTap: () => _launchUrl(news.url),
        child: Card(
          margin: EdgeInsets.only(bottom: 50.h),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (news.urlToImage != null)
                Image.network(news.urlToImage.toString()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${news.source?.name}',
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
                      news.title ?? "",
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
                      news.description ?? "",
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
                      '${news.publishedAt?.day}/${news.publishedAt?.month}/${news.publishedAt?.year}',
                      style: TextStyle(
                        fontSize: 35.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return res;
  }

  bool load = false;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey.shade900,
        ),
        backgroundColor: kBackgroundColor,
        title: TextFormField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (val) async {
            setState(() {
              load = true;
            });
            await data.searchNews(_controller.text);
            setState(() {
              load = false;
            });
          },
          style: TextStyle(fontSize: 50.sp, height: 1.3),
          autofocus: true,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () async {
                    setState(() {
                      load = true;
                    });
                    await data.searchNews(_controller.text);
                    setState(() {
                      load = false;
                    });
                  },
                  icon: const Icon(Icons.search)),
              border: InputBorder.none,
              hintText: 'Search in feed'),
        ),
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
                    Text('Showing results for : ${_controller.text}',
                        style: TextStyle(
                          fontSize: 40.sp,
                          color: Colors.grey.shade900,
                        )),
                    SizedBox(
                      height: 70.h,
                    ),
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: showCards(),
                    ),
                    SizedBox(
                      height: 70.h,
                    ),
                    Center(
                      child: Text("Search for an article",
                          style: TextStyle(
                            fontSize: 60.sp,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(
                      height: 300.h,
                    ),
                  ],
                )),
      ),
    );
  }
}
