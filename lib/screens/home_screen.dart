import 'dart:convert';
import 'dart:io';
import 'package:air_files/screens/about.dart';
import 'package:air_files/screens/login_screen.dart';
import 'package:air_files/utils/api.dart';
import 'package:air_files/utils/custom_list_tile.dart';
import 'package:air_files/utils/custom_user_file.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/toast_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<PlatformFile>? _files;
  bool _isLoading = false;
  List<Map<String, dynamic>> userFiles = [];

  void _logout() async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool("isLoggedIn", false);
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = false;
      _files = null;
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      setState(() {
        _isLoading = true;
      });
      _files = (await FilePicker.platform.pickFiles(
        allowMultiple: true,
      ))
          ?.files;
      setState(() {
        _isLoading = false;
      });
      getUserFiles();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Unsupported operation$e');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void downloadUserFiles() async {
    final dio = Dio();

    final response = await dio.get(
      'http://13.234.59.167:3000/api/userWeb/downloadUserFiles',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Authorization': 'Bearer ${Api().getLoginToken()}',
        },
      ),
    );

    if (kIsWeb) {
      final bytes = response.data;
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final dCodeBytes = file.content as List<int>;
        final dCodeArchive = ZipDecoder().decodeBytes(dCodeBytes);

        for (final f in dCodeArchive) {
          if (f.isFile) {
            await FileSaver.instance
                .saveFile(f.name, f.content, f.name.split(".").last.toString());
          }
        }
      }

      return;
    }

    // read response bytes. extract to a temp dir
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/userFiles.zip');
    await file.writeAsBytes(response.data);

    // extract zip file
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final data = file.content as List<int>;
      final dCoded = ZipDecoder().decodeBytes(data);
      for (final f in dCoded) {
        if (f.isFile) {
          final filename = f.name;
          final data = f.content as List<int>;
          final file = File('${dir.path}/$filename');
          await file.writeAsBytes(data);

          // check if platform is web
          if (Platform.isIOS) {
            final Directory? downloadsDir = await getDownloadsDirectory();
            final String downloadsPath = downloadsDir!.path;

            final newFile = await file.copy('$downloadsPath/$filename');
            showToast('File downloaded!');

          } else if (Platform.isAndroid) {
            final Directory? downloadsDir = await getExternalStorageDirectory();
            final String downloadsPath = downloadsDir!.path;

            final newFile = await file.copy('$downloadsPath/$filename');
            showToast('File downloaded to $downloadsPath/$filename');
          } else {
            await FileSaver.instance.saveFile(filename, file.readAsBytesSync(),
                filename.split(".").last.toString());
          }
        }
      }
    }

    // delete zip file
    file.deleteSync();

    if (response.statusCode == 200) {
      if (response.data == "NO FILES FOUND") {
        showToast('No files found');
        setState(() {
          userFiles = [];
          loadingUserFiles = false;
        });
        return;
      }
    } else if (response.statusCode == 404) {
      showToast('No files found');
      setState(() {
        loadingUserFiles = false;
      });
    } else {
      showToast('Error downloading user files');
    }
  }

  bool loadingUserFiles = false;
  void getUserFiles() async {
    setState(() {
      loadingUserFiles = true;
    });
    final dio = Dio();

    final response = await dio.get(
      'http://13.234.59.167:3000/api/userWeb/getUserFiles',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Api().getLoginToken()}',
        },
      ),
    );

    if (response.statusCode == 200) {
      if (response.data == "NO FILES FOUND") {
        showToast('No files found');
        setState(() {
          userFiles = [];
          loadingUserFiles = false;
        });
        return;
      }
      List<Map<String, dynamic>> responseData = [];
      response.data.forEach((e) => {
            responseData.add({
              'fileName': e['fileName'],
              'fileSize': e['fileSize'],
            })
          });

      setState(() {
        userFiles = responseData;
      });
      setState(() {
        loadingUserFiles = false;
      });
    } else if (response.statusCode == 404) {
      showToast('No files found');
      setState(() {
        loadingUserFiles = false;
      });
    } else {
      showToast('Error getting user files');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserFiles();
  }

  Future<String?> compressAndSendFilesWeb(List<PlatformFile> files) async {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    setState(() {
      _isLoading = true;
    });

    // archive all files into a single archive without using temp dir
    final archive = Archive();
    for (final file in files) {
      archive.addFile(ArchiveFile(file.name, file.size, file.bytes!));
    }

    final compressedFileBytes = ZipEncoder().encode(archive);
    // send as multipart/form-data

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'files': MultipartFile.fromBytes(
          compressedFileBytes!,
          filename: 'compressed.zip',
        ),
        'userFiles': jsonEncode(_files!
            .map((e) => {
                  'fileName': e.name,
                  'fileSize': e.size,
                })
            .toList()),
      });

      final response = await dio.post(
        'http://13.234.59.167:3000/api/userWeb/upload',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${Api().getLoginToken()}',
          },
        ),
        data: formData,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        print(stopwatch.elapsed.inSeconds);
        return "OK";
      } else {
        return response.statusMessage.toString();
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> compressAndSendFiles(List<File> files) async {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    setState(() {
      _isLoading = true;
    });
    // Create a temporary directory to store the compressed file
    final tempDir = await Directory.systemTemp.createTemp();

    // Compress the files into a single archive
    final archive = Archive();
    for (final file in files) {
      final fileContent = await file.readAsBytes();
      archive.addFile(ArchiveFile(
          file.path.split('/').last, fileContent.length, fileContent));
    }

    final compressedFilePath = '${tempDir.path}/compressed.zip';
    final compressedFile = File(compressedFilePath);
    final compressedFileBytes = ZipEncoder().encode(archive);
    await compressedFile.writeAsBytes(compressedFileBytes!);

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'files': await MultipartFile.fromFile(compressedFilePath),
        'userFiles': jsonEncode(_files!
            .map((e) => {
                  'fileName': e.name,
                  'fileSize': e.size,
                })
            .toList()),
      });

      final response = await dio.post(
        'http://13.234.59.167:3000/api/userWeb/upload',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${Api().getLoginToken()}',
          },
        ),
        data: formData,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        print(stopwatch.elapsed.inSeconds);
        return "OK";
      } else {
        return response.statusMessage.toString();
      }
    } finally {
      // Clean up the temporary directory and compressed file
      await compressedFile.delete();
      await tempDir.delete(recursive: true);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer,
        onPressed: () {
          if (_files == null) {
            _pickFiles();
          } else {
            if (kIsWeb) {
              compressAndSendFilesWeb(_files!).then((value) => {
                    if (value == "OK")
                      {
                        showToast("Files Uploaded Successfully"),
                        setState(() {
                          _files = null;
                        }),
                      }
                    else
                      {
                        showToast("Error Uploading Files"),
                        setState(() {
                          _files = null;
                        })
                      }
                  });
            } else {
              compressAndSendFiles(_files!.map((e) => File(e.path!)).toList())
                  .then((value) => {
                        if (value == "OK")
                          {
                            showToast("Files Uploaded Successfully"),
                            setState(() {
                              _files = null;
                            }),
                          }
                        else
                          {
                            showToast("Error Uploading Files"),
                            setState(() {
                              _files = null;
                            })
                          }
                      });
            }
          }
        },
        label: Text(
          _files == null ? "Choose Files" : "Upload Files",
          style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.primaryContainer),
        ),
        icon: Icon(
          _files == null ? Icons.upload_file_rounded : Icons.send_rounded,
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      body: isLoading || loadingUserFiles
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    loadingUserFiles
                        ? "Loading User Files"
                        : "Logging you out...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                      fontSize: 16,
                    )),
                  )
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Air Files",
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : null)),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.temple_hindu_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutScreen()));
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        setState(() {
                          loadingUserFiles = true;
                        });
                        getUserFiles();
                        if (!kIsWeb) {
                          sleep(const Duration(seconds: 2));
                        }
                        setState(() {
                          loadingUserFiles = false;
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          _logout();
                          if (!kIsWeb) {
                            sleep(const Duration(seconds: 2));
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        icon: const Icon(Icons.logout_rounded)),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      if (userFiles.isEmpty && _files == null) ...[
                        Text(
                          "No Files in Air",
                          style: GoogleFonts.raleway(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.merge(TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                      ] else if (userFiles.isNotEmpty && _files == null) ...[
                        Text(
                          "Files in Air",
                          style: GoogleFonts.raleway(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.merge(TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Builder(
                          builder: (BuildContext context) => isLoading
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Text(
                                        "Receiving Files...",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                        )),
                                      )
                                    ],
                                  ),
                                )
                              : userFiles.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No files uploaded yet.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                        )),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: userFiles.length,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CustomUserFile(
                                          fileName: userFiles[index]['fileName']
                                              .toString(),
                                          fileSize: userFiles[index]['fileSize']
                                              .toString(),
                                        );
                                      },
                                    ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            downloadUserFiles();
                          },
                          icon: const Icon(Icons.download_rounded),
                          label: Text(
                            "Download Files",
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ] else if (_files != null) ...[
                        Text(
                          "Chosen Files",
                          style: GoogleFonts.raleway(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.merge(TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Builder(
                          builder: (BuildContext context) => _isLoading
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Text(
                                        "Uploading Files...",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                        )),
                                      )
                                    ],
                                  ),
                                )
                              : _files == null
                                  ? Center(
                                      child: Text(
                                        "No files chosen to upload",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                          fontSize: 16,
                                        )),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _files!.length,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CustomListTile(
                                          file: _files![index],
                                        );
                                      },
                                    ),
                        ),
                      ],
                      const SizedBox(
                        height: 108,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
