# Kustomize.nvim

Kustomize user command integrations in neovim

### Current User Commands

| Command | Example | Description |
|:--------|:--------|:------------|
| KustomizeBuild | KustomizeBuild dev | build kustomize overlay manifest and view in floating window w/ overlay autocompletion |

### Install & Configuration

#### Lazy.vim

```lua
{
  "DavidRR-F/kustomize.nvim",
  opts = {
    -- extension providers "default" | "snacks"
    -- snacks requires installing snacks.nvim
    provider = "default",
    -- default pwd of kustomize directory in projects
    path = ".",
    -- command flag arguments (supports boolean|string|string[] atributes)
    -- Ex: --enable-helm -> enable_helm = true
    -- Ex: --helm-kube-version -> helm_kube_version = "1.21"
    -- Ex: --env -> env = {"FOO", "BAR"}
    commands = {
      build = {
        enable_helm = true
      }
    }
  }
}
```

### TODO
  - [x] `KustomizeBuild` user command w/ autocompletion
  - [ ] `KustomizeBuildRepo` user command w/ autocompletion
  - [ ] `KustomizeCreate` user command
  - [ ] `KustomizeCreateTemplate` user command
  - [ ] Picker extensions snacks/telescope
