import 'package:flutter/material.dart';
import 'package:flutter_paint_web_app/controllers/paint_controller.dart';
import 'package:flutter_paint_web_app/responsive.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class Palette extends StatelessWidget {
  Palette({
    Key? key,
  }) : super(key: key);

  final PaintController controller = Get.find<PaintController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      width: Get.width * (Responsive.isDesktop(context) ? 0.2 : 0.6),
      color: kColorDark,
      child: Column(
        children: [
          Text(
            'PALETTE',
            style: Theme.of(context).textTheme.headline5!.copyWith(color: kColorGray),
          ),
          const SizedBox(height: defaultPadding),
          Expanded(
            child: ColorWidgets(),
          ),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => Slider(
                    thumbColor: paletteColorList[controller.colorIdx.value],
                    inactiveColor: Colors.white.withOpacity(0.1),
                    activeColor: paletteColorList[controller.colorIdx.value].withOpacity(0.4),
                    value: controller.size.value,
                    max: 10,
                    onChanged: (size) => controller.size(size),
                  ),
                ),
              ),
              InkWell(
                onTap: () => controller.changeEraseMode(!controller.eraseMode.value),
                child: Obx(() => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: controller.eraseMode.value ? kColorOrange : const Color(0xFF2D3748),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '지우개',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white, fontSize: 12),
                      ),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ColorWidgets extends StatelessWidget {
  ColorWidgets({Key? key}) : super(key: key);

  final PaintController controller = Get.find<PaintController>();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: defaultPadding / 2,
      runSpacing: defaultPadding / 2,
      children: List.generate(paletteColorList.length, (index) => colorCircle(index)),
    );
  }

  Widget colorCircle(int index) {
    final Color color = paletteColorList[index];

    return InkWell(
      onTap: () {
        controller.changeColor(index, color);
        controller.changeEraseMode(false);
      },
      child: Obx(
        () => Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: controller.colorIdx.value == index
                ? Border.all(
                    color: color == Colors.white ? kColorOrange : Colors.white,
                    width: 4,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
