# manifest.nvim

> Still In Development

Yaml Manifest Viewer user command integrations in neovim

### Current User Commands

| Command | Example | Description |
|:--------|:--------|:------------|
| KustomizeBuild | KustomizeBuild dev | build kustomize overlay manifest and view in floating window w/ overlay autocompletion |
| HelmTemplate | HelmTemplate release-name argo/argo-workflow values.yaml | build helm chart manifest and view in floating window w/ overlay autocompletion |

### Function References

```lua
local manifest = requires("manifest.commands")

--- @param release string release name
--- @param chart string repo/chart or chart dir
--- @param values string values file path
--- @return string[]
manifest.helm.template(release, chart, values)

--- @param chart string kustomize overlay dir
--- @param values string values file path
--- @return string[]
manifest.kustomize.build(overlay)


--- @param query string yq query string
--- @param file string yaml file path
--- @return string[]
manifest.yq.query(query, file)
```

### Install & Configuration

#### Lazy.vim

```lua
{
  "DavidRR-F/manifest.nvim",
  -- default options
  opts = {
    -- enable yq search for floating buffers
    -- requires yq cli installed when enabled
    yq = {
      enabled = true,
      -- default | diff
      view = "default"
    },
    kustomize = {
      enabled = true,
      -- default pwd of kustomize directory in projects
      path = "./kustomize",
      -- optional command flag arguments (supports boolean|string|string[] atributes)
      -- Ex: --enable-helm -> enable_helm = true
      -- Ex: --helm-kube-version -> helm_kube_version = "1.21"
      -- Ex: --env -> env = {"FOO", "BAR"}
      --   args = {
      --     enable helm requires helm cli when enabled
      --     enable_helm = true,
      --     helm_kube_version = "1.21",
      --     env = {"FOO", "BAR"}
      --   }
      args = {}
    },
    helm = {
      enabled = true,
      -- optional command flag arguments (supports boolean|string|string[] atributes)
      -- Ex: --enable-helm -> enable_helm = true
      -- Ex: --helm-kube-version -> helm_kube_version = "1.21"
      -- Ex: --env -> env = {"FOO", "BAR"}
      --   args = {
      --     enable helm requires helm cli when enabled
      --     enable_helm = true,
      --     helm_kube_version = "1.21",
      --     env = {"FOO", "BAR"}
      --   }
      args = {}
    },
    cue = {
      enabled = true,
      args = {}
    },
    -- default height and width percentage of floating windows
    style = {
      win = { height = 0.6, width = 0.8 }
    }
  }
}
```

### TODO
  - [x] `KustomizeBuild` user command w/ autocompletion
  - [x] `HelmTemplate` user command w/ autocompletion
  - [ ] `CueExport` user command w/ autocompletion
  - [ ] `ManifestView` user command w/ autocompletion
  - [ ] add yq diff floating build buffer option
  - [x] add yq search option to floating build buffer
