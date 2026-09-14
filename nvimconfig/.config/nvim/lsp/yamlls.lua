local schemas = require("schemastore").yaml.schemas()
schemas = vim.tbl_extend("force",
	schemas,
	{
		kubernetes = {
			"k8s/*.yaml",
			"k8s/*.yml",
			"kubernetes/*.yaml",
			"kubernetes/*.yml",
			"manifests/*.yaml",
			"manifests/*.yml",
			"k8s-*.yaml",
			"k8s-*.yml",
		},
		["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
		["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
		["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
		["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
		["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",

		["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
		["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
		["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
		["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
		["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
		["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
		["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
})
return {
	settings = {
		yaml = {
			validate = true,
			hover = true,
			completion = true,
			format = {
				enable = false,
			},
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = schemas,
		},
	},
}
