(self: super: {
  sumneko-lua-language-server = super.sumneko-lua-language-server.overrideAttrs
    (oa: {
      version = "master";
      src = super.fetchFromGitHub {
        owner = "sumneko";
        repo = "lua-language-server";
        rev = "a1e3bd8acc16563950fd7a90f42d68aefe7ab8b0";
        sha256 = "kK7oQiBA1hBNJhVTsOFEFav1I1Sa7Bqd/U0rlQaJono=";
        fetchSubmodules = true;
      };
    });
})
