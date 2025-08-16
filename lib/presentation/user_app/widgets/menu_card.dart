import 'package:flutter/material.dart';
import 'package:mini_zomato_platform/models/menu_item_model.dart';

class MenuItemCard extends StatefulWidget {
  final MenuItemModel menuItem;
  final Function(int) onAddToCart;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int quantity = 1;

  void _incrementQuantity() {
    if (quantity < 10) {
      // Add max limit
      setState(() {
        quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with better error handling and loading
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
                child:
                    widget.menuItem.imageUrl != null
                        ? Image.network(
                          widget.menuItem.imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.restaurant,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.restaurant,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        ),
              ),
            ),
            const SizedBox(width: 16),

            // Content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and veg indicator row
                  Row(
                    children: [
                      // Veg/Non-veg indicator with proper design
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                widget.menuItem.isVegetarian
                                    ? Colors.green
                                    : Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color:
                                  widget.menuItem.isVegetarian
                                      ? Colors.green
                                      : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.menuItem.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Description
                  if (widget.menuItem.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        widget.menuItem.description,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Price and controls row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '₹${widget.menuItem.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepOrange,
                        ),
                      ),

                      // Add to cart controls or out of stock
                      if (!widget.menuItem.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quantity selector
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      onTap:
                                          quantity > 1
                                              ? _decrementQuantity
                                              : null,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        child: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color:
                                              quantity > 1
                                                  ? Colors.deepOrange
                                                  : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      border: Border.symmetric(
                                        vertical: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      onTap: _incrementQuantity,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Add to cart button
                            ElevatedButton(
                              onPressed: () => widget.onAddToCart(quantity),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.deepOrange.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'ADD',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
