class Features {
  bool activePremium;
  int numberOfLayers;

  Features._(this.activePremium, this.numberOfLayers);

  Features.loading() : this._(false, 0);

  Features.free() : this._(false, 2);

  Features.premium() : this._(true, 10000);
}
