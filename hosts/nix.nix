{
  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    gc.dates = "weekly";
    optimise.automatic = true;
  };
}
