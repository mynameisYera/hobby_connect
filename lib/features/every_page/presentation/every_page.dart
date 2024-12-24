import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hobby/core/app_colors.dart';
import 'package:hobby/core/widgets/custom_app_bar.dart';
import 'package:hobby/core/widgets/custom_button_widget.dart';
import 'package:hobby/core/widgets/news_widget.dart';
import 'package:hobby/features/create_post/create_post_page.dart';
import 'package:hobby/features/main/presentation/bloc/message_bloc/post_bloc.dart';
import 'package:lottie/lottie.dart';

class EveryPage extends StatelessWidget {
  final String collections;
  const EveryPage({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        backgroundColor: Colors.transparent,
        popAble: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreatePostPage(
                            collections: collections,
                          )));
            },
            icon: Icon(Icons.create),
            color: AppColors.mainColor,
          )
        ],
      ),
      backgroundColor: AppColors.notBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocProvider(
                create: (context) =>
                    PostBloc()..add(LoadPostEvent(collections)),
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
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 300,
                        child: Center(
                            child: Lottie.asset(
                                'assets/animations/loading_hamster.json')),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height - 150,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomButtonWidget(
                                onTap: () {
                                  context
                                      .read<PostBloc>()
                                      .add(LoadPostEvent(collections));
                                },
                                widget: Text('try again')),
                          ),
                        ),
                      );
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
