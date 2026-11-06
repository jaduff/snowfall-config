{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.services.ollama;
in {
  options.${namespace}.services.ollama = with types; {
    enable = mkBoolOpt false "Whether or not to enable ollama.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ oterm ];
	services.ollama = {
	  package = pkgs.ollama-cuda;
	  enable = true;
          port = 11434;
	  environmentVariables = {
	    OLLAMA_NOHISTORY = "1";
	    OLLAMA_FLASH_ATTENTION = "1";   # also a prerequisite for KV quantisation
	      OLLAMA_KV_CACHE_TYPE   = "q8_0";  # ~½ the KV cache of f16, negligible quality loss
	      OLLAMA_CONTEXT_LENGTH  = "32768";  # don't pay for 32k you won't use

	      # --- avoid CPU/GPU memory thrashing ---
	      OLLAMA_MAX_LOADED_MODELS = "1";
	      OLLAMA_KEEP_ALIVE        = "5m";
	      LLAMA_ARG_CPU_MOE="1";
# on CUDA this is often needed so experts don't get pinned in host memory
              GGML_CUDA_NO_PINNED="1";
	  };
    };
    networking.firewall.allowedTCPPorts = [ 4430 ];
};
}
