import 'package:flutter/material.dart';
import 'package:rioko_ni/core/config/app_sizes.dart';
import 'package:rioko_ni/core/injector.dart';
import 'package:rioko_ni/features/map/domain/entities/country.dart';
import 'package:rioko_ni/features/map/presentation/cubit/map_cubit.dart';

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

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late TextEditingController searchController;

  List<Country> searchedCountries = [];

  final _cubit = locator<MapCubit>();

  @override
  void initState() {
    isPopping = false;
    searchedCountries = _cubit.countries;
    _listKey.currentState?.insertAllItems(0, searchedCountries.length);
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
                  onChanged: (value) {
                    final searchedCountries = _cubit.countriesByString(value);
                    final difference = this
                        .searchedCountries
                        .toSet()
                        .difference(searchedCountries.toSet())
                        .toList();
                    for (Country country in difference) {
                      final index = this.searchedCountries.indexOf(country);
                      _listKey.currentState?.removeItem(
                        index,
                        (context, animation) => _buildCountryItem(
                          context,
                          country: country,
                          animation: animation,
                        ),
                      );
                      this.searchedCountries.removeAt(index);
                    }

                    setState(() {});
                  },
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusHalf),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.8),
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusHalf),
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
            Expanded(
              child: AnimatedBuilder(
                key: _listKey,
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      50 * (1 - _animation.value),
                    ),
                    child: Opacity(
                      opacity: _animation.value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.paddingDouble,
                  ),
                  child: AnimatedList(
                    initialItemCount: searchedCountries.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      bottom: AppSizes.paddingQuadruple,
                    ),
                    itemBuilder: (context, i, animation) {
                      final country = searchedCountries[i];
                      return _buildCountryItem(
                        context,
                        country: country,
                        animation: animation,
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCountryItem(
    BuildContext context, {
    required Country country,
    required Animation animation,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            50 * (1 - _animation.value),
            0,
          ),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingDouble,
          vertical: AppSizes.paddingHalf,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusHalf),
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            child: country.flag(scale: 0.5),
          ),
          title: Text(
            country.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            country.region,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}
