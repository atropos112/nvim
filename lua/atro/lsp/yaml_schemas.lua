return {
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
		fileMatch = { "*.psql.yml", "*.psql.yaml", "psql.yaml", "psql.yml" },
	},
	{
		name = "Cnpg-ScheduledBackup",
		description = "CNPG ScheduledBackup configuration file",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/postgresql.cnpg.io/scheduledbackup_v1.json",
		fileMatch = { "*.psql.backup.yml", "*.psql.backup.yaml", "psql.backup.yaml", "psql.backup.yml" },
	},
	{
		name = "VM-PodScrape",
		description = "VictoriaMetrics PodScrape configuration file",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/operator.victoriametrics.com/vmpodscrape_v1beta1.json",
		fileMatch = { "*.vm.ps.yml", "*.vm.ps.yaml" },
	},
	{
		name = "ExtSecrets-SecretStore",
		description = "External Secrets SecretStore configuration file",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/external-secrets.io/secretstore_v1beta1.json",
		fileMatch = { "*.extsec.store.yml", "*extsec.store.yaml", "extsec.store.yaml", "extsec.store.yml" },
	},

	{
		name = "ExtSecrets-ExternalSecret",
		description = "External Secrets ExternalSecret configuration file",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/external-secrets.io/externalsecret_v1beta1.json",
		fileMatch = { "*.extsec.yml", "*extsec.yaml", "extsec.yaml", "extsec.yml" },
	},
	{
		name = "ExtSecrets-ClusterExternalSecret",
		description = "External Secrets ClusterExternalSecret configuration file",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/external-secrets.io/clusterexternalsecret_v1beta1.json",
		fileMatch = { "*.extsec.cluster.yml", "*extsec.cluster.yaml" },
	},

	{
		name = "Atrok AppBundle",
		description = "Atrok App bundle configuration",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/atro.xyz/appbundle_v1alpha1.json",
		fileMatch = { "*.ab.yml", "*.ab.yaml" },
	},

	{
		name = "Atrok AppBundleBase",
		description = "Atrok App bundle base configuration",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/atro.xyz/appbundlebase_v1alpha1.json",
		fileMatch = { "*.abb.yml", "*.abb.yaml" },
	},

	{
		name = "DragonFly",
		description = "DragonFly configuration",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/dragonflydb.io/dragonfly_v1alpha1.json",
		fileMatch = { "dragonfly.yaml", "dragonfly.yml", "*.df.yaml", "*.df.yml" },
	},

	{
		name = "ArgoCD Application",
		description = "ArgoCD Application configuration",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/argoproj.io/application_v1alpha1.json",
		fileMatch = { "*.app.yaml", "*.app.yml" },
	},
	{
		name = "ArgoCD ApplicationSet",
		description = "ArgoCD ApplicationSet configuration",
		url = "https://raw.githubusercontent.com/atropos112/crd-schemas/refs/heads/main/argoproj.io/applicationset_v1alpha1.json",
		fileMatch = { "*.appset.yaml", "*.appset.yml" },
	},
}
