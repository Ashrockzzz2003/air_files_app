import 'package:air_files/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
          Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Colors.black
              : Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar.large(
            backgroundColor:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? Colors.black
                    : Theme.of(context).colorScheme.background,
            floating: false,
            pinned: true,
            snap: false,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "About",
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),

          // rest of the UI
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    // border: Border.all(color: const Color(0xffA6C8FF)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromRGBO(27, 28, 28, 1)
                        : Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Air Files",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 32,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Version 1.0.0",
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Team",
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    showToast("Hello from Ashwin Narayanan S");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ashwin Narayanan S",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Text(
                              "Amrita Vishwa Vidyapeetham",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                            ),
                            Text(
                              "Coimbatore, Tamil Nadu",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Chip(
                              padding: const EdgeInsets.all(1),
                              backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.background,
                              elevation: 3,
                              label: Text(
                                "CB.EN.U4CSE21008",
                                style: GoogleFonts.lato(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    showToast("Hello from A S Sreepadh!");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "A S Sreepadh",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Text(
                              "Amrita Vishwa Vidyapeetham",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                            ),
                            Text(
                              "Coimbatore, Tamil Nadu",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Chip(
                              padding: const EdgeInsets.all(1),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .brightness ==
                                  Brightness.dark
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.background,
                              elevation: 3,
                              label: Text(
                                "CB.EN.U4CSE21009",
                                style: GoogleFonts.lato(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    showToast("Hello from Deepak Menan R!");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Deepak Menan R",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Text(
                              "Amrita Vishwa Vidyapeetham",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                            ),
                            Text(
                              "Coimbatore, Tamil Nadu",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Chip(
                              padding: const EdgeInsets.all(1),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .brightness ==
                                  Brightness.dark
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.background,
                              elevation: 3,
                              label: Text(
                                "CB.EN.U4CSE21014",
                                style: GoogleFonts.lato(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    showToast("Hello from Arjun P");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Arjun P",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Text(
                              "Amrita Vishwa Vidyapeetham",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer),
                              ),
                            ),
                            Text(
                              "Coimbatore, Tamil Nadu",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                              ),
                            ),
                            Chip(
                              padding: const EdgeInsets.all(1),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .brightness ==
                                  Brightness.dark
                                  ? Colors.black
                                  : Theme.of(context).colorScheme.background,
                              elevation: 3,
                              label: Text(
                                "CB.EN.U4CSE21007",
                                style: GoogleFonts.lato(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
