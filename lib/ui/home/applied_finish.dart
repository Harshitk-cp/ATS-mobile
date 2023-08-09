import 'package:flutter/material.dart';

class AppliedFinishPage extends StatelessWidget {
  const AppliedFinishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/success_icon.png',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "All Done!",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF1F4C77),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Successfully applied for the job.",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF1F4C77),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (Route<dynamic> route) => false,
                );
              },
              child: _buildButton(
                text: "Explore Jobs",
                color: const Color(0xFF3967C1),
              ),
            ),
            const SizedBox(height: 40),
            // InkWell(
            //   onTap: () {},
            //   child: _buildButton(
            //     text: "Get preparation Tips",
            //     color: const Color(0xFF3967C1),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
