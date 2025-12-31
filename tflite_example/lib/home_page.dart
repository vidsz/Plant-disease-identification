import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_example/more_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  File _image = File("");
  var _output;
  final picker = ImagePicker(); //allows us to pick image from gallery or camera

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 38, //the amout of categories our neural network can predict
      threshold: 0.1,
      imageMean: 127.5,
      imageStd: 255.0,
    );
    setState(() {
      _output = output;
      _loading = false;
      print("output: $_output");
    });
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
        model: 'assets/model_1.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant disease Identifer',
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 6.0,
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _loading == true
                    ? null //show nothing if no picture selected
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _image,
                                height: 256,
                                width: 256,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          _output != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    'The Plant is: ${_output[0]['label']}',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 32,
                          ),
                          _output != null
                              ? ElevatedButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MoreInfo(
                                          url: _output[0]['label'],
                                        ),
                                      )),
                                  child: Text("More Info"))
                              : Container()
                        ],
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 30)),
                          onPressed: pickImage,
                          child: const Text(
                            "Take a Photo",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          )),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 30)),
                          onPressed: pickGalleryImage,
                          child: const Text(
                            "Pick from Gallery",
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
