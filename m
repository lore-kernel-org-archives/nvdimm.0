Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4932FAF
	for <nvdimm@lists.linux.dev>; Tue, 31 Aug 2021 09:06:18 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="304009062"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="304009062"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="577063015"
Received: from msgunjal-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.30.4])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:05:08 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	QI Fuli <qi.fuli@jp.fujitsu.com>,
	fenghua.hu@intel.com,
	Vishal Verma <vishal.l.verma@intel.com>,
	QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 6/7] daxctl/device.c: add an option for getting params from a config file
Date: Tue, 31 Aug 2021 03:04:58 -0600
Message-Id: <20210831090459.2306727-7-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210831090459.2306727-1-vishal.l.verma@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6597; h=from:subject; bh=2t/CNKrXMgGmTkp1vvTwmRakYOn+pzKCHvEh/VXrE44=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm6H7aeWZC7eUEyj3/RtkKvyYtratiX39urvujVlg9HD86/ aa+k31HKwiDGwSArpsjyd89HxmNy2/N5AhMcYeawMoEMYeDiFICJ+OcxMuyqXvVsdutM+4Cw37rXS9 2u9+Wti5qa9LCSWWOO+BnRp5sZGeZWltUsnO2XdP289YHvndvlTW58vjoz32uVSMvbxOw8RVYA
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
 daxctl/device.c    | 141 ++++++++++++++++++++++++++++++++++++++++++++-
 daxctl/Makefile.am |   1 +
 3 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 928814c..dc7ac5f 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -95,6 +95,7 @@ int main(int argc, const char **argv)
 	rc = daxctl_new(&ctx);
 	if (rc)
 		goto out;
+	daxctl_set_configs(&ctx, DAXCTL_CONF_DIR);
 	main_handle_internal_command(argc, argv, ctx, commands,
 			ARRAY_SIZE(commands), PROG_DAXCTL);
 	daxctl_unref(ctx);
diff --git a/daxctl/device.c b/daxctl/device.c
index a427b7d..99a4548 100644
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
@@ -75,7 +78,9 @@ OPT_STRING('m', "mode", &param.mode, "mode", "mode to switch the device to"), \
 OPT_BOOLEAN('N', "no-online", &param.no_online, \
 	"don't auto-online memory sections"), \
 OPT_BOOLEAN('f', "force", &param.force, \
-		"attempt to offline memory sections before reconfiguration")
+		"attempt to offline memory sections before reconfiguration"), \
+OPT_BOOLEAN('C', "check-config", &param.check_config, \
+		"use config files to determine parameters for the operation")
 
 #define CREATE_OPTIONS() \
 OPT_STRING('s', "size", &param.size, "size", "size to switch the device to"), \
@@ -218,6 +223,130 @@ err:
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
+		CONF_SEARCH("auto-online", "uuid", uuid, "mode", &param.mode, NULL),
+		CONF_SEARCH("auto-online", "uuid", uuid, "online", &conf_online, NULL),
+		CONF_SEARCH("auto-online", "uuid", uuid, "movable", &conf_movable, NULL),
+		CONF_END(),
+	};
+	const char *prefix = "./";
+	int rc;
+
+	rc = parse_configs_prefix(daxctl_get_configs(ctx), prefix, configs);
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
@@ -279,6 +408,16 @@ static const char *parse_device_options(int argc, const char **argv,
 	if (param.human)
 		flags |= UTIL_JSON_HUMAN;
 
+	/* Scan config file(s) for options. This sets param.foo accordingly */
+	if (param.check_config) {
+		rc = parse_device_config(ctx, argv[0], action);
+		if (rc) {
+			fprintf(stderr, "error parsing config file: %s\n",
+				strerror(-rc));
+			return NULL;
+		}
+	}
+
 	/* Handle action-specific options */
 	switch (action) {
 	case ACTION_RECONFIG:
diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index a9845a0..f30c485 100644
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
2.31.1

