import 'package:flutter/material.dart';
import 'package:poc/fahrzeug_dashboard/model/vehicle.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class VehicleItem extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleItem({
    required this.vehicle,
    super.key,
  });

  Color getSohColor(int? soh) {
    if (soh == null) return SBBColors.smoke;
    if (soh >= 85) {
      return SBBColors.green;
    } else if (soh >= 70) {
      return SBBColors.lemon;
    } else {
      return SBBColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = getSohColor(vehicle.soh);

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -6,
            left: 16,
            child: _wheel(borderColor),
          ),
          Positioned(
            bottom: -6,
            right: 16,
            child: _wheel(borderColor),
          ),
          Container(
            width: 140,
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.train, size: 28, color: borderColor),
                const SizedBox(height: 8),
                Text(
                  vehicle.uicNumber,
                  style: SBBTextStyles.smallBold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (vehicle.soh != null)
                  Text(
                    'SoH ${vehicle.soh}%',
                    style: SBBTextStyles.extraSmallBold.copyWith(color: borderColor),
                  ),
                if (vehicle.soh == null)
                  Text(
                    'Fehlendes Signal',
                    style: SBBTextStyles.extraSmallBold.copyWith(color: borderColor),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _wheel(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26),
      ),
    );
  }
}
