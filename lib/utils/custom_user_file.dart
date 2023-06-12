import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomUserFile extends StatefulWidget {
  final String fileName;
  final String fileSize;

  const CustomUserFile({Key? key, required this.fileName, required this.fileSize}) : super(key: key);

  @override
  CustomUserFileState createState() => CustomUserFileState();
}

class CustomUserFileState extends State<CustomUserFile> {
  bool isSelected = false;

  // icon dictionary
  final Map<String, IconData> iconDict = {
    "pdf": Icons.picture_as_pdf,
    "docx": Icons.description,
    "doc": Icons.description,
    "pptx": Icons.description,
    "ppt": Icons.description,
    "xlsx": Icons.description,
    "xls": Icons.description,
    "txt": Icons.description,
    "png": Icons.image,
    "jpg": Icons.image,
    "jpeg": Icons.image,
    "gif": Icons.image,
    "mp4": Icons.movie,
    "mp3": Icons.music_note,
    "wav": Icons.music_note,
    "aac": Icons.music_note,
    "flac": Icons.music_note,
    "zip": Icons.archive,
    "rar": Icons.archive,
    "tar": Icons.archive,
    "gz": Icons.archive,
    "7z": Icons.archive,
    "iso": Icons.archive,
    "exe": Icons.app_registration,
    "apk": Icons.android,
    "dmg": Icons.desktop_windows,
    "psd": Icons.image,
    "ai": Icons.image,
    "svg": Icons.image,
    "json": Icons.code,
    "xml": Icons.code,
    "html": Icons.code,
    "css": Icons.code,
    "js": Icons.code,
    "php": Icons.code,
    "c": Icons.code,
    "cpp": Icons.code,
    "h": Icons.code,
    "hpp": Icons.code,
    "java": Icons.code,
    "py": Icons.code,
    "md": Icons.code,
    "gitignore": Icons.code,
    "lock": Icons.lock,
    "key": Icons.lock,
    "": Icons.insert_drive_file,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected = true;
          });

          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              isSelected = false;
            });
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: ListTile(
            onLongPress: () {},
            contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  // get extension from file name
                  iconDict[widget.fileName.split(".").last.toLowerCase()] ??
                      iconDict[""],
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fileName,
                        style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.fileSize} bytes",
                        style: GoogleFonts.raleway(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
