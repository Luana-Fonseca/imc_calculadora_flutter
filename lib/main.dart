import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      home: const BMICalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String _category = '';
  Color _categoryColor = Colors.grey;
  String _recommendation = '';

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira valores válidos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);

    String category;
    Color color;
    String recommendation;

    if (bmi < 18.5) {
      category = 'Abaixo do Peso';
      color = const Color(0xFF3B82F6);
      recommendation = 'Procure um nutricionista para ganhar peso de forma saudável';
    } else if (bmi < 25) {
      category = 'Peso Normal';
      color = const Color(0xFF10B981);
      recommendation = 'Mantenha seus hábitos saudáveis e continue se exercitando';
    } else if (bmi < 30) {
      category = 'Sobrepeso';
      color = const Color(0xFFF59E0B);
      recommendation = 'Aumente a atividade física e revise sua alimentação';
    } else {
      category = 'Obesidade';
      color = const Color(0xFFEF4444);
      recommendation = 'Consulte um médico para orientação profissional';
    }

    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(1));
      _category = category;
      _categoryColor = color;
      _recommendation = recommendation;
    });
  }

  void _reset() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _bmi = null;
      _category = '';
      _categoryColor = Colors.grey;
      _recommendation = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isMobile
              ? Column(
                  children: [
                    _buildInputSection(),
                    const SizedBox(height: 24),
                    if (_bmi != null) _buildResultSection(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildInputSection(),
                    ),
                    const SizedBox(width: 24),
                    if (_bmi != null)
                      Expanded(
                        flex: 1,
                        child: _buildResultSection(),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seus Dados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _heightController,
              label: 'Altura',
              hint: 'Ex: 175',
              suffix: 'cm',
              icon: Icons.height,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _weightController,
              label: 'Peso',
              hint: 'Ex: 70',
              suffix: 'kg',
              icon: Icons.scale,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calculateBMI,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular IMC'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Limpar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFFE2E8F0),
                    foregroundColor: const Color(0xFF475569),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF6366F1),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
          ),
        ),
      ],
    );
  }

  Widget _buildResultSection() {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: _categoryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          color: _categoryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Seu IMC',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _bmi.toString(),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _categoryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _categoryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildBodyIllustration(),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recomendação',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _recommendation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildBMIChart(),
      ],
    );
  }

  Widget _buildBodyIllustration() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomPaint(
              painter: BodyIllustrationPainter(
                category: _category,
                color: _categoryColor,
              ),
              size: const Size(150, 250),
            ),
            const SizedBox(height: 16),
            Text(
              _getBodyDescription(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIChart() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escala de IMC',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            _buildBMIRange('Abaixo do Peso', '< 18,5', const Color(0xFF3B82F6)),
            _buildBMIRange('Peso Normal', '18,5 - 24,9', const Color(0xFF10B981)),
            _buildBMIRange('Sobrepeso', '25 - 29,9', const Color(0xFFF59E0B)),
            _buildBMIRange('Obesidade', '≥ 30', const Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }

  Widget _buildBMIRange(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
              ),
            ),
          ),
          Text(
            range,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  String _getBodyDescription() {
    switch (_category) {
      case 'Abaixo do Peso':
        return 'Corpo magro e delgado. Aumente a ingestão calórica.';
      case 'Peso Normal':
        return 'Corpo saudável e bem proporcionado. Continue assim!';
      case 'Sobrepeso':
        return 'Corpo com excesso de peso. Atividade física é importante.';
      case 'Obesidade':
        return 'Corpo com obesidade. Procure orientação profissional.';
      default:
        return '';
    }
  }
}

class BodyIllustrationPainter extends CustomPainter {
  final String category;
  final Color color;

  BodyIllustrationPainter({
    required this.category,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final skinPaint = Paint()
      ..color = const Color(0xFFE8B4A8)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    switch (category) {
      case 'Abaixo do Peso':
        _drawThinBody(canvas, size, centerX, centerY, skinPaint, paint);
        break;
      case 'Peso Normal':
        _drawNormalBody(canvas, size, centerX, centerY, skinPaint, paint);
        break;
      case 'Sobrepeso':
        _drawOverweightBody(canvas, size, centerX, centerY, skinPaint, paint);
        break;
      case 'Obesidade':
        _drawObeseBody(canvas, size, centerX, centerY, skinPaint, paint);
        break;
    }
  }

  void _drawThinBody(Canvas canvas, Size size, double centerX, double centerY,
      Paint skinPaint, Paint paint) {
    // Cabeça
    canvas.drawCircle(Offset(centerX, centerY - 80), 18, skinPaint);

    // Corpo fino
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 20),
        width: 20,
        height: 60,
      ),
      skinPaint,
    );

    // Braços finos
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 35, centerY - 20),
        width: 12,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 35, centerY - 20),
        width: 12,
        height: 50,
      ),
      skinPaint,
    );

    // Pernas finas
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 12, centerY + 50),
        width: 12,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 12, centerY + 50),
        width: 12,
        height: 50,
      ),
      skinPaint,
    );

    // Olhos
    canvas.drawCircle(Offset(centerX - 6, centerY - 85), 2, paint);
    canvas.drawCircle(Offset(centerX + 6, centerY - 85), 2, paint);
  }

  void _drawNormalBody(Canvas canvas, Size size, double centerX, double centerY,
      Paint skinPaint, Paint paint) {
    // Cabeça
    canvas.drawCircle(Offset(centerX, centerY - 80), 18, skinPaint);

    // Corpo proporcionado
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 20),
        width: 32,
        height: 60,
      ),
      skinPaint,
    );

    // Braços proporcionados
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 40, centerY - 20),
        width: 16,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 40, centerY - 20),
        width: 16,
        height: 50,
      ),
      skinPaint,
    );

    // Pernas proporcionadas
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 12, centerY + 50),
        width: 14,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 12, centerY + 50),
        width: 14,
        height: 50,
      ),
      skinPaint,
    );

    // Olhos
    canvas.drawCircle(Offset(centerX - 6, centerY - 85), 2, paint);
    canvas.drawCircle(Offset(centerX + 6, centerY - 85), 2, paint);

    // Sorriso
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 75),
        width: 8,
        height: 4,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  void _drawOverweightBody(Canvas canvas, Size size, double centerX,
      double centerY, Paint skinPaint, Paint paint) {
    // Cabeça
    canvas.drawCircle(Offset(centerX, centerY - 80), 18, skinPaint);

    // Corpo mais largo
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY - 20),
        width: 50,
        height: 60,
      ),
      skinPaint,
    );

    // Braços mais largos
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 45, centerY - 20),
        width: 20,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 45, centerY - 20),
        width: 20,
        height: 50,
      ),
      skinPaint,
    );

    // Pernas mais largas
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 14, centerY + 50),
        width: 18,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 14, centerY + 50),
        width: 18,
        height: 50,
      ),
      skinPaint,
    );

    // Olhos
    canvas.drawCircle(Offset(centerX - 6, centerY - 85), 2, paint);
    canvas.drawCircle(Offset(centerX + 6, centerY - 85), 2, paint);
  }

  void _drawObeseBody(Canvas canvas, Size size, double centerX, double centerY,
      Paint skinPaint, Paint paint) {
    // Cabeça
    canvas.drawCircle(Offset(centerX, centerY - 75), 18, skinPaint);

    // Corpo muito largo (barriga)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(centerX, centerY - 10),
          width: 70,
          height: 70,
        ),
        const Radius.circular(20),
      ),
      skinPaint,
    );

    // Braços muito largos
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 50, centerY - 10),
        width: 24,
        height: 55,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 50, centerY - 10),
        width: 24,
        height: 55,
      ),
      skinPaint,
    );

    // Pernas muito largas
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX - 16, centerY + 60),
        width: 22,
        height: 50,
      ),
      skinPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX + 16, centerY + 60),
        width: 22,
        height: 50,
      ),
      skinPaint,
    );

    // Olhos
    canvas.drawCircle(Offset(centerX - 6, centerY - 80), 2, paint);
    canvas.drawCircle(Offset(centerX + 6, centerY - 80), 2, paint);
  }

  @override
  bool shouldRepaint(BodyIllustrationPainter oldDelegate) {
    return oldDelegate.category != category || oldDelegate.color != color;
  }
}
