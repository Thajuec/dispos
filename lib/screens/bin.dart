import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Bin extends StatefulWidget {
  const Bin({Key key}) : super(key: key);

  @override
  _BinState createState() => _BinState();
}

class _BinState extends State<Bin> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [Padding(
            padding: const EdgeInsets.all(1.0),
            child: CarouselSlider(items: [
              Image.network("https://image.freepik.com/free-vector/trash-pickup-worker-cleaning-dustbin-truck-man-carrying-trash-plastic-bag-flat-vector-illustration-city-service-waste-disposal-concept_74855-10181.jpg"),
              Image.network("https://us.123rf.com/450wm/intararit/intararit1704/intararit170400003/75868077-garbage-truck-driver-with-recycle-bins-.jpg?ver=6"),                  Image.network("https://techbullion.com/wp-content/uploads/2021/06/Smart-Waste-Recycling-System-1-1000x600.jpg"),

              Image.network("https://thumbs.dreamstime.com/b/waste-management-as-garbage-collection-clean-recycling-truck-outline-concept-urban-trash-utility-service-container-226186933.jpg"),



            ], options: CarouselOptions(height: 250,initialPage: 1,autoPlay: true,enlargeCenterPage: true,),),
          ),


            SizedBox(
              width: 360,
              height: 340,
              child: Card(
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                child: Container(decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/manjeri.png'),
                      fit: BoxFit.cover,
                    ),),
                  // child: SafeArea(
                  //     minimum: EdgeInsets.all(15),
                  //     child:  Card(
                  //             child: Container(decoration: BoxDecoration(
                  //               image: DecorationImage(
                  //                 image: AssetImage('assets/images/manjeri.png'),
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //              child: Card(
                  //                child: Container(
                  //                  decoration: BoxDecoration(
                  //                    image: DecorationImage(
                  //                      image: AssetImage('assets/images/manjeri.png'),
                  //                      fit: BoxFit.fill,
                  //                    )
                  //                  ),
                  //                ),
                  //              ),
                  //             ),
                  //           ),
                  //         )),
                ),
              ),
            )
          ]


        ),




    );
  }
}
