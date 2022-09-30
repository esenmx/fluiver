part of fluiver;

extension AxisX on Axis {
  Axis get reverse {
    return this == Axis.vertical ? Axis.horizontal : Axis.vertical;
  }
}

extension TextDirectionX on TextDirection {
  TextDirection get reverse {
    return this == TextDirection.ltr ? TextDirection.rtl : TextDirection.ltr;
  }
}
