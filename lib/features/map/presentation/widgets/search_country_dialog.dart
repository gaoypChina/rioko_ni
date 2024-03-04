import 'package:flutter/material.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';

class SearchCountryDialog extends StatefulWidget {
  final List<Country> countries;

  const SearchCountryDialog({
    required this.countries,
    super.key,
  });

  @override
  State<SearchCountryDialog> createState() => _SearchCountryDialogState();
}

class _SearchCountryDialogState extends State<SearchCountryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late TextEditingController searchController;

  @override
  void initState() {
    isPopping = false;
    searchController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    Future.delayed(const Duration(milliseconds: 200), _controller.forward);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  bool isPopping = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (isPopping) return;
        isPopping = true;
        _controller.reverse();
        Future.delayed(
            const Duration(milliseconds: 600), Navigator.of(context).pop);
      },
      child: Dialog.fullscreen(
        backgroundColor: Colors.black54,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    -50 * (1 - _animation.value),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: AppSizes.paddingDouble,
                  right: AppSizes.paddingDouble,
                  top: size.height * 0.15,
                ),
                height: 60,
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                width: double.infinity,
                child: TextField(
                  controller: searchController,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radius / 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radius / 2),
                    ),
                    labelText: 'Search country',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.8)),
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
