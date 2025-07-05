// lib/views/program/program_detail_page.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/program_controller.dart';
import 'package:provider/provider.dart';

// 1. IMPORT DUA PACKAGE INI
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_unescape/html_unescape.dart';

class ProgramDetailPage extends StatefulWidget {
  final String id;

  const ProgramDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<ProgramDetailPage> createState() => _ProgramDetailPageState();
}

class _ProgramDetailPageState extends State<ProgramDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProgramController>(context, listen: false)
          .fetchProgramById(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Buat instance untuk unescape HTML
    final unescape = HtmlUnescape();

    return Consumer<ProgramController>(
      builder: (context, controller, child) {
        // ... (Bagian loading & error handling tetap sama)
        if (controller.isDetailLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (controller.errorMessage != null && controller.selectedProgram == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  controller.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        
        if (controller.selectedProgram == null) {
             return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
                body: const Center(
                child: Text(
                    'Program tidak ditemukan.',
                    style: TextStyle(color: Colors.white70),
                ),
                ),
            );
        }

        final program = controller.selectedProgram!;

        return Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: 250.0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.only(bottom: 16.0, left: 60.0),
                  title: Text(
                    program.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset( 
                      'assets/images/1.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/1.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // 2. GANTI Text DENGAN HtmlWidget DI SINI
                      HtmlWidget(
                        // Gunakan unescape untuk membersihkan data
                        unescape.convert(program.description),
                        // Atur style default untuk teksnya
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}