import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

enum Filter {
  glutanFree,
  lactoseFree,
  vegiterian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutanFree: false,
          Filter.lactoseFree: false,
          Filter.vegiterian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final availableFilters = ref.watch(filtersProvider);
  final meals = ref.watch(mealsProvider);
  return meals.where((meal) {
    if (availableFilters[Filter.glutanFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (availableFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (availableFilters[Filter.vegiterian]! && !meal.isVegetarian) {
      return false;
    }
    if (availableFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
