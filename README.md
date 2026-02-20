# manifest.nvim

> Still In Development

Yaml Manifest user command integrations in neovim

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

### User Commands

| Command | Example | Description |
|:--------|:--------|:------------|
| `KustomizeBuild` | KustomizeBuild dev | build kustomize overlay manifest and view in floating window w/ overlay autocompletion |
| `HelmTemplate` | HelmTemplate release-name repo/chart values.yaml | build helm chart manifest and view in floating window w/ chart and values autocompletion |
| `HelmShowValues` | HelmShowValues repo/chart | build helm chart manifest and view in floating window w/ chart autocompletion |
| `HelmDiffValues` | HelmDiffValues repo/chart | diff helm chart default values with current buffer values w/ chart autocompletion |
| `CueExport` | CueExport schema.cue | build cue export manifest and view in floating window w/ file autocompletion |
| `YqEval` | YqEval deployment.yml | generic yaml manifest and view in floating window w/ file autocompletion |

### Function References

```lua
local manifest = requires("manifest.commands")

--- @param release string release name
--- @param chart string repo/chart or chart dir
--- @param values string values file path
--- @return string[]
manifest.helm.template.cmd(release, chart, values)

--- @param chart string repo/chart or chart dir
--- @return string[]
manifest.helm.show.cmd(chart)

--- @param chart string kustomize overlay dir
--- @param values string values file path
--- @return string[]
manifest.kustomize.build.cmd(overlay)


--- @param query string yq query string
--- @param file string yaml file path
--- @return string[]
manifest.yq.eval.cmd(query, file)
```
