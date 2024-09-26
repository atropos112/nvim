local M = {}

M.yaml_schemas = function()
	if _G._yaml_schemas then
		return _G._yaml_schemas
	end

	_G._yaml_schemas = require("schemastore").yaml.schemas({
		extra = {
			-- INFO: Can find more schemas here:
			-- https://www.schemastore.org/json/
			-- and here:
			-- https://github.com/atropos112/crd-schemas
			-- Often have to add filematch to "discover" the schema.
			{
				name = "Argo Events",
				description = "Argo Events Event Sources and Sensors",
				url = "https://raw.githubusercontent.com/argoproj/argo-events/master/api/jsonschema/schema.json",
				fileMatch = { "*.ae.yaml", "*.ae.yml" },
			},
			{
				name = "Argo Workflow",
				description = "Argo Workflow configuration file",
				url = "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json",
				fileMatch = { "*.awf.yaml", "*.awf.yml" },
			},
			{
				name = "Docker Compose",
				description = "Docker Compose configuration file",
				url = "https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json",
				fileMatch = { "docker-compose.yaml", "docker-compose.yml" },
			},
			{
				name = "Cnpg-Cluster",
				description = "CNPG Cluster configuration file",
				url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/postgresql.cnpg.io/cluster_v1.json",
				fileMatch = { "*.cnpg.cluster.yml", "*.cnpg.cluster.yaml" },
			},
			{
				name = "Cnpg-ScheduledBackup",
				description = "CNPG ScheduledBackup configuration file",
				url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/postgresql.cnpg.io/scheduledbackup_v1.json",
				fileMatch = { "*.cnpg.backup.yml", "*.cnpg.backup.yaml" },
			},
			{
				name = "VM-PodScrape",
				description = "VictoriaMetrics PodScrape configuration file",
				url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/operator.victoriametrics.com/vmpodscrape_v1beta1.json",
				fileMatch = { "*.vm.podscrape.yml", "*.vm.podscrape.yaml" },
			},
			{
				name = "ExtSecrets-SecretStore",
				description = "External Secrets SecretStore configuration file",
				url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/external-secrets.io/secretstore_v1beta1.json",
				fileMatch = { "*.secretstore.yml", "*.secretstore.yaml" },
			},
		},
	})

	-- All yaml files in k3s/ recursively
	_G._yaml_schemas.kubernetes = { "*.k8s.yml", "*.k8s.yaml" }

	return _G._yaml_schemas
end

return M