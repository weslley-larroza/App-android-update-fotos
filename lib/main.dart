import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envio de Fotos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 115, 139, 216),
        ),
      ),
      home: const MyHomePage(title: 'Envio de Fotos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _orderController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma imagem tirada')),
      );
    }
  }

  Future<void> _uploadImages() async {
    final orderNumber = _orderController.text.trim();

    if (orderNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o número do pedido.')),
      );
      return;
    }

    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma imagem selecionada para enviar.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    final tempDir = await getTemporaryDirectory();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.110.198:5000/upload'),
    );

    request.fields['orderNumber'] = orderNumber;

    for (var i = 0; i < _images.length; i++) {
      final imageBytes = await _images[i].readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        //final compressedImage = decodedImage;  // Sem redimensionar
        final compressedImage = img.copyResize(decodedImage, width: decodedImage.width ~/ 3);// com redimensionar
        final compressedPath = '${tempDir.path}/${orderNumber}_${i+1}.jpg';
        final compressedFile = File(compressedPath)..writeAsBytesSync(img.encodeJpg(compressedImage));

        request.files.add(
          await http.MultipartFile.fromPath('image_$i', compressedFile.path),
        );
      }
    }

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagens enviadas com sucesso!')),
        );
        setState(() {
          _images.clear();
          _orderController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao enviar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _orderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _orderController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número do Pedido',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _images.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _images.map((image) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        )
                      : const Text('Nenhuma imagem selecionada'),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Selecionar da Galeria'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _uploadImages,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Enviar Imagens'),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        tooltip: 'Tirar Foto',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
