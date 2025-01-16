import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scrollbar(
                thumbVisibility: false,
                child: SingleChildScrollView(
                  child: TextField(
                    maxLines: null,
                    controller: TextEditingController(
                      text:
                          "Once upon a time, in a dense forest, there lived a wise old owl named Oliver. Unlike other owls who slept during the day, Oliver had developed a peculiar habit of watching the forest's daytime activities. Through his observations, he learned about the intricate relationships between different creatures - how squirrels helped plant new trees by forgetting where they buried their acorns, how woodpeckers kept trees healthy by removing harmful insects, and how bees ensured the forest stayed vibrant with their pollination work.\n\nOne particularly hot summer, when the forest faced a severe drought, Oliver noticed something remarkable. The ants, typically busy with their own colony's needs, began creating tiny water channels. They would collect morning dew drops and guide them toward struggling seedlings. This small act of what seemed like kindness helped many young plants survive the harsh season.\n\nOther animals soon noticed this innovative solution. The squirrels began using their tails to sprinkle collected dew on higher branches, while birds started dipping their feathers in nearby streams to shower water on distant plants. The forest had transformed into a community where every creature contributed to its survival.\n\nOliver's daytime observations had revealed a profound truth: the forest wasn't just a collection of trees and animals, but a complex network of beings helping each other thrive. His wisdom grew not from hunting at night like other owls, but from witnessing how cooperation and adaptability could overcome the toughest challenges.",
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 30 * 3.779527559055118, // 3cm in logical pixels
                  width: 30 * 3.779527559055118,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: const SizedBox(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
