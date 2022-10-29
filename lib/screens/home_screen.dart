import 'package:flutter/material.dart';
import 'package:mocktest/screens/second_screen.dart';

import '../database/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size mediasize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: mediasize.height * 0.05,
            ),
            const Text(
              "Mock Test App",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Center(
              child: Container(
                height: mediasize.height * 0.3,
                width: mediasize.width * 0.65,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/mocktest.jpg"))),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SecondScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(9)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          "Create New Test",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.blueAccent,
              thickness: 3,
            ),
            Expanded(child: savedMockTest(context))
          ],
        ),
      ),
    );
  }
}

Widget savedMockTest(BuildContext context) {
  return FutureBuilder(
      future: LocalDataBase.getDataFromLocalStorage(),
      builder: (context, snaphot) {
        if (!snaphot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<FetchedDataModel> list = snaphot.data != null ? snaphot.data! : [];

        if(list.isEmpty){
          return Center(child: Text("Nothing To Show"),);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Scrollbar(
            radius: const Radius.circular(10),
            thickness: 15,
            thumbVisibility: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0,bottom: 20),
              child: SingleChildScrollView(
                reverse: true,
                child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      List<String> monthName = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                      int month = DateTime.parse(list[index].timeStamp).month;
                      int year = DateTime.parse(list[index].timeStamp).year;
                      int day = DateTime.parse(list[index].timeStamp).day;
                      int hour = DateTime.parse(list[index].timeStamp).hour;
                      int min = DateTime.parse(list[index].timeStamp).minute;
                      String amOrPm = "Am";

                      void setAmorPm(){
                        if(hour>12 || hour ==12){
                          amOrPm = " PM";
                          hour = hour-12;
                        }else{
                          amOrPm = " AM";
                        }
                      }
                      setAmorPm();



                      String timeOfCreated = monthName[month-1].toString()+" "+day.toString()+", "+year.toString()+" "+ hour.toString()+":"+min.toString()+amOrPm;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.blueAccent, width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                                child: Text(
                                  list[index].topicName,
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Spacer(flex:5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text("Created on : ",style: TextStyle(fontSize:13,fontWeight: FontWeight.w500),),
                                  ),
                                  Padding(
                                    padding:const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(timeOfCreated),
                                  ),
                                  Spacer(flex: 1,)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        );
      });
}
