import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_button_widget.dart';
import 'package:hobby/core/widgets/news_widget.dart';
import 'package:hobby/features/main/presentation/bloc/message_bloc/post_bloc.dart';
import 'package:lottie/lottie.dart';

class ChatHobPage extends StatelessWidget {
  const ChatHobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocProvider(
                create: (context) => PostBloc()..add(LoadPostEvent('')),
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is SuccessPostState) {
                      return SizedBox(
                        height: state.items.length * 530,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            return NewsWidget(
                              description: state.items[index].title,
                              url: [state.items[index].img],
                              name: state.items[index].name,
                            );
                          },
                        ),
                      );
                    } else if (state is LoadingPostState) {
                      return Center(
                          child: Lottie.asset(
                              'assets/animations/loading_hamster.json'));
                    } else {
                      return CustomButtonWidget(
                          onTap: () {
                            context.read<PostBloc>().add(LoadPostEvent(''));
                          },
                          widget: Text('hello'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
