Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A72CB9
	for <nvdimm@lists.linux.dev>; Mon,  6 Dec 2021 22:28:47 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="300804842"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300804842"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:46 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="502310467"
Received: from ponufryk-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:28:45 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 11/12] daxctl/device.c: add an option for getting params from a config file
Date: Mon,  6 Dec 2021 15:28:29 -0700
Message-Id: <20211206222830.2266018-12-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211206222830.2266018-1-vishal.l.verma@intel.com>
References: <20211206222830.2266018-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8367; h=from:subject; bh=3b2qu3lmsUEaf0aRs+BtN0ZeNtvEclZjg+cBmGvc8F0=; b=owGbwMvMwCXGf25diOft7jLG02pJDInr+vrMl5Tyrb224XxTimByRuj2zLzP2xqNuM8LMptpdodu CNzWUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIk4rmL4n/13RoNUgP/5mcEyPiG+bS saN6+/sfbmIssVd1Pr4pT79RgZ7ty9osI3+3SD2f6iH2v2xra3/fnMbJf1n1/42hVW/UtneAE=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a new option to daxctl-reconfigure-device that allows it to
comprehend the new global config system in ndctl/daxctl. With this, the
reconfigure-device command can query the config to match a specific
device UUID, and operate using the parameters supplied in that INI
section.

This is in preparation to make daxctl device reconfiguration (usually
as system-ram) policy based, so that reconfiguration can happen
automatically on boot.

Cc: QI Fuli <qi.fuli@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/daxctl.c    |   1 +
 daxctl/device.c    | 174 ++++++++++++++++++++++++++++++++++++++++++++-
 daxctl/Makefile.am |   1 +
 3 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 928814c..41b35e5 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -95,6 +95,7 @@ int main(int argc, const char **argv)
 	rc = daxctl_new(&ctx);
 	if (rc)
 		goto out;
+	daxctl_set_configs_dir(&ctx, DAXCTL_CONF_DIR);
 	main_handle_internal_command(argc, argv, ctx, commands,
 			ARRAY_SIZE(commands), PROG_DAXCTL);
 	daxctl_unref(ctx);
diff --git a/daxctl/device.c b/daxctl/device.c
index a427b7d..7b02420 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -14,8 +14,10 @@
 #include <util/filter.h>
 #include <json-c/json.h>
 #include <json-c/json_util.h>
+#include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
 #include <util/parse-options.h>
+#include <util/parse-configs.h>
 #include <ccan/array_size/array_size.h>
 
 static struct {
@@ -25,6 +27,7 @@ static struct {
 	const char *size;
 	const char *align;
 	const char *input;
+	bool check_config;
 	bool no_online;
 	bool no_movable;
 	bool force;
@@ -65,6 +68,9 @@ enum device_action {
 	ACTION_DESTROY,
 };
 
+#define CONF_SECTION		"reconfigure-device"
+#define CONF_NVDIMM_UUID_STR	"nvdimm.uuid"
+
 #define BASE_OPTIONS() \
 OPT_STRING('r', "region", &param.region, "region-id", "filter by region"), \
 OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
@@ -75,7 +81,9 @@ OPT_STRING('m', "mode", &param.mode, "mode", "mode to switch the device to"), \
 OPT_BOOLEAN('N', "no-online", &param.no_online, \
 	"don't auto-online memory sections"), \
 OPT_BOOLEAN('f', "force", &param.force, \
-		"attempt to offline memory sections before reconfiguration")
+		"attempt to offline memory sections before reconfiguration"), \
+OPT_BOOLEAN('C', "check-config", &param.check_config, \
+		"use config files to determine parameters for the operation")
 
 #define CREATE_OPTIONS() \
 OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
@@ -218,6 +226,137 @@ err:
 	return rc;
 }
 
+static int conf_string_to_bool(const char *str)
+{
+	if (!str)
+		return INT_MAX;
+	if (strncmp(str, "t", 1) == 0 ||
+			strncmp(str, "T", 1) == 0 ||
+			strncmp(str, "y", 1) == 0 ||
+			strncmp(str, "Y", 1) == 0 ||
+			strncmp(str, "1", 1) == 0)
+		return true;
+	if (strncmp(str, "f", 1) == 0 ||
+			strncmp(str, "F", 1) == 0 ||
+			strncmp(str, "n", 1) == 0 ||
+			strncmp(str, "N", 1) == 0 ||
+			strncmp(str, "0", 1) == 0)
+		return false;
+	return INT_MAX;
+}
+
+#define conf_assign_inverted_bool(p, conf_var) \
+do { \
+	if (conf_string_to_bool(conf_var) != INT_MAX) \
+		param.p = !conf_string_to_bool(conf_var); \
+} while(0)
+
+static int parse_config_reconfig_set_params(struct daxctl_ctx *ctx, const char *device,
+					    const char *uuid)
+{
+	const char *conf_online = NULL, *conf_movable = NULL;
+	const struct config configs[] = {
+		CONF_SEARCH(CONF_SECTION, CONF_NVDIMM_UUID_STR, uuid,
+			    "mode", &param.mode, NULL),
+		CONF_SEARCH(CONF_SECTION, CONF_NVDIMM_UUID_STR, uuid,
+			    "online", &conf_online, NULL),
+		CONF_SEARCH(CONF_SECTION, CONF_NVDIMM_UUID_STR, uuid,
+			    "movable", &conf_movable, NULL),
+		CONF_END(),
+	};
+	const char *prefix = "./", *daxctl_configs;
+	int rc;
+
+	daxctl_configs = daxctl_get_configs_dir(ctx);
+	if (daxctl_configs == NULL)
+		return 0;
+
+	rc = parse_configs_prefix(daxctl_configs, prefix, configs);
+	if (rc < 0)
+		return rc;
+
+	conf_assign_inverted_bool(no_online, conf_online);
+	conf_assign_inverted_bool(no_movable, conf_movable);
+
+	return 0;
+}
+
+static bool daxctl_ndns_has_device(struct ndctl_namespace *ndns,
+				    const char *device)
+{
+	struct daxctl_region *dax_region;
+	struct ndctl_dax *dax;
+
+	dax = ndctl_namespace_get_dax(ndns);
+	if (!dax)
+		return false;
+
+	dax_region = ndctl_dax_get_daxctl_region(dax);
+	if (dax_region) {
+		struct daxctl_dev *dev;
+
+		dev = daxctl_dev_get_first(dax_region);
+		if (dev) {
+			if (strcmp(daxctl_dev_get_devname(dev), device) == 0)
+				return true;
+		}
+	}
+	return false;
+}
+
+static int parse_config_reconfig(struct daxctl_ctx *ctx, const char *device)
+{
+	struct ndctl_namespace *ndns;
+	struct ndctl_ctx *ndctl_ctx;
+	struct ndctl_region *region;
+	struct ndctl_bus *bus;
+	struct ndctl_dax *dax;
+	int rc, found = 0;
+	char uuid_buf[40];
+	uuid_t uuid;
+
+	if (strcmp(device, "all") == 0)
+		return 0;
+
+	rc = ndctl_new(&ndctl_ctx);
+	if (rc < 0)
+		return rc;
+
+        ndctl_bus_foreach(ndctl_ctx, bus) {
+		ndctl_region_foreach(bus, region) {
+			ndctl_namespace_foreach(region, ndns) {
+				if (daxctl_ndns_has_device(ndns, device)) {
+					dax = ndctl_namespace_get_dax(ndns);
+					if (!dax)
+						continue;
+					ndctl_dax_get_uuid(dax, uuid);
+					found = 1;
+				}
+			}
+		}
+	}
+
+	if (!found) {
+		fprintf(stderr, "no UUID match for %s found in config files\n",
+			device);
+		return 0;
+	}
+
+	uuid_unparse(uuid, uuid_buf);
+	return parse_config_reconfig_set_params(ctx, device, uuid_buf);
+}
+
+static int parse_device_config(struct daxctl_ctx *ctx, const char *device,
+			       enum device_action action)
+{
+	switch (action) {
+	case ACTION_RECONFIG:
+		return parse_config_reconfig(ctx, device);
+	default:
+		return 0;
+	}
+}
+
 static const char *parse_device_options(int argc, const char **argv,
 		enum device_action action, const struct option *options,
 		const char *usage, struct daxctl_ctx *ctx)
@@ -228,8 +367,11 @@ static const char *parse_device_options(int argc, const char **argv,
 	};
 	unsigned long long units = 1;
 	int i, rc = 0;
+	char *device;
 
 	argc = parse_options(argc, argv, options, u, 0);
+	device = basename(argv[0]);
+
 
 	/* Handle action-agnostic non-option arguments */
 	if (argc == 0 &&
@@ -279,6 +421,34 @@ static const char *parse_device_options(int argc, const char **argv,
 	if (param.human)
 		flags |= UTIL_JSON_HUMAN;
 
+	/* Scan config file(s) for options. This sets param.foo accordingly */
+	if (param.check_config) {
+		if (param.mode || param.no_online || param.no_movable) {
+			fprintf(stderr,
+				"%s: -C cannot be used with --mode, --(no-)movable, or --(no-)online\n",
+				device);
+				usage_with_options(u, options);
+		}
+		rc = parse_device_config(ctx, device, action);
+		if (rc) {
+			fprintf(stderr, "error parsing config file: %s\n",
+				strerror(-rc));
+			return NULL;
+		}
+		if (!param.mode && !param.no_online && !param.no_movable) {
+			fprintf(stderr, "%s: missing or malformed config section\n",
+				device);
+			/*
+			 * Exit with success since the most common case is there is
+			 * no config defined for this device, and we don't want to
+			 * treat that as an error. There isn't an easy way currently
+			 * to distinguish between a malformed config entry from a
+			 * completely missing config section.
+			 */
+			exit(0);
+		}
+	}
+
 	/* Handle action-specific options */
 	switch (action) {
 	case ACTION_RECONFIG:
@@ -336,7 +506,7 @@ static const char *parse_device_options(int argc, const char **argv,
 		return NULL;
 	}
 
-	return argv[0];
+	return device;
 }
 
 static int dev_online_memory(struct daxctl_dev *dev)
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index a5c6de1..ac97cd1 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -23,6 +23,7 @@ daxctl_SOURCES =\
 
 daxctl_LDADD =\
 	lib/libdaxctl.la \
+	../ndctl/lib/libndctl.la \
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
-- 
2.33.1

