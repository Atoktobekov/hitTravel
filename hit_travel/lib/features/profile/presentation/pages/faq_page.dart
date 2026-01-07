import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_travel/core/network/dio_client.dart';
import 'package:hit_travel/core/theme/theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hit_travel/core/di/locator.dart';
import 'package:talker_flutter/talker_flutter.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> _faqItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFaq();
  }

  Future<void> _fetchFaq() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _apiService.getFaq();

      setState(() {
        _faqItems = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось загрузить вопросы. Проверьте интернет-соединение.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Вопросы/Ответы',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            TextButton(
              onPressed: _fetchFaq,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_faqItems.isEmpty) {
      return const Center(child: Text('Список вопросов пока пуст'));
    }

    return RefreshIndicator(
      onRefresh: _fetchFaq,
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: _faqItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = _faqItems[index];
          return _FaqTile(
            question: item['question'] ?? '',
            answer: item['answer'] ?? '',
          );
        },
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias, // Чтобы содержимое не вылезало за границы обводки
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.blueColor),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          minTileHeight: 36,
          iconColor: AppTheme.blueColor,
          collapsedIconColor: AppTheme.blueColor,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          title: Text(
            question,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.1.h
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: HtmlWidget(
                answer,
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                  height: 1.4,
                ),
                // setting styles
                customStylesBuilder: (element) {
                  if (element.localName == 'strong') {
                    return {'color': '#000000', 'font-weight': 'bold'};
                  }
                  if (element.localName == 'a') {
                    return {'color': '#0066CC', 'text-decoration': 'none'};
                  }
                  return null;
                },
                onTapUrl: (url) async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                    return true;
                  } else {
                    serviceLocator<Talker>().error('Could not launch $url');
                    return false;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}