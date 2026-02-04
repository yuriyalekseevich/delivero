import 'dart:developer';

import 'package:delivero/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/delivery_list_cubit.dart';
import 'delivery_card.dart';
import 'search_bar_widget.dart';

class PaginatedDeliveryList extends StatefulWidget {
  final String tab;

  const PaginatedDeliveryList({
    super.key,
    required this.tab,
  });

  @override
  State<PaginatedDeliveryList> createState() => _PaginatedDeliveryListState();
}

class _PaginatedDeliveryListState extends State<PaginatedDeliveryList> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    switch (widget.tab) {
      case 'ready':
        context.read<DeliveryListCubit>().loadReadyDeliveries();
        break;
      case 'active':
        context.read<DeliveryListCubit>().loadActiveDeliveries();
        break;
      case 'completed':
        context.read<DeliveryListCubit>().loadCompletedDeliveries();
        break;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      context.read<DeliveryListCubit>().loadNextPage();
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _loadInitialData();
    } else {
      context.read<DeliveryListCubit>().searchDeliveries(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          onChanged: _onSearch,
          hintText: 'Search by customer name or address...',
        ),
        Expanded(
          child: BlocBuilder<DeliveryListCubit, DeliveryListState>(
            builder: (context, state) {
              if (state is DeliveryListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DeliveryListError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadInitialData,
                        child: Text(S.of(context).retry),
                      ),
                    ],
                  ),
                );
              } else if (state is DeliveryListLoaded) {
                return _buildDeliveryList(state);
              } else if (state is DeliveryListPaginationLoading) {
                return _buildDeliveryListWithPaginationLoading(state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryList(DeliveryListLoaded state) {
    if (state.deliveries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No deliveries found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search terms',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ],
        ),
      );
    }

    state.deliveries.forEach((element) {
      log(element.specialInfo.toString());
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.deliveries.length + (state.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.deliveries.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final delivery = state.deliveries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DeliveryCard(delivery: delivery),
        );
      },
    );
  }

  Widget _buildDeliveryListWithPaginationLoading(DeliveryListPaginationLoading state) {
    if (state.deliveries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.deliveries.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.deliveries.length) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading more deliveries...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        final delivery = state.deliveries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DeliveryCard(delivery: delivery),
        );
      },
    );
  }
}
