Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C548120F4
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 06:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657866373; x=1689402373;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S5a3PGV/30b+Wi+/xP9UhWhcgDtUE+LkL1rNQ9TXhIA=;
  b=NRjHFj19FIdkHZdEaCX+4PULJXHUeWCKo/kFrE8FNsCSMekUKFUEGab4
   wkW03V1IoJwFKBN6KBX5Pq6Jp+skiqKQVXFkzlwNXAb5KW+Mwhmz6VjWy
   wXHTv/1iMaHnZIkucJPG3PDAjTjUtd/TYowp8Hr5edN3H77SeOjIxjG37
   THYLQQv1zXSi112i0w558kyz591WXzcC+mhY0FZRGtF0EpS7NL2TvRndn
   B05NBFSitdxYiCioi1dioEWW8lIC4w+nmCHVG3UXMCQbRF0uxlxvhPlsb
   CrV9/YGoY1/uwyVSrQXQTLndD+ZRO10EZwitDmLrS5muwnLenxbbmwmSD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266125547"
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="266125547"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:12 -0700
X-IronPort-AV: E=Sophos;i="5.92,273,1650956400"; 
   d="scan'208";a="546544629"
Received: from saseiper-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.71.32])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:26:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 7/8] cxl: add commands to {enable,disable,destroy}-region
Date: Fri, 15 Jul 2022 00:25:49 -0600
Message-Id: <20220715062550.789736-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715062550.789736-1-vishal.l.verma@intel.com>
References: <20220715062550.789736-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11383; h=from:subject; bh=S5a3PGV/30b+Wi+/xP9UhWhcgDtUE+LkL1rNQ9TXhIA=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkXOfJU9Q4eeOqUOu9dg7DvPHUe2Zqwdy/l7ZdoNUUfzBK7 xZreUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgImYGDP8d3GwZTCT3XJhr6TsHsH28o XXl8glenqaX3rtPudq+q2XsowM/Y3cv7tuBVjtaZfMU/X2jvwzayH/+h0v7+5n2Gv5LF6RDQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

With a template from cxl-create-region in place, add its friends:

  cxl enable-region
  cxl disable-region
  cxl destroy-region

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-destroy-region.txt |  39 +++++
 Documentation/cxl/cxl-disable-region.txt |  34 +++++
 Documentation/cxl/cxl-enable-region.txt  |  34 +++++
 Documentation/cxl/decoder-option.txt     |   6 +
 cxl/builtin.h                            |   3 +
 cxl/cxl.c                                |   3 +
 cxl/region.c                             | 172 +++++++++++++++++++++++
 Documentation/cxl/meson.build            |   4 +
 8 files changed, 295 insertions(+)
 create mode 100644 Documentation/cxl/cxl-destroy-region.txt
 create mode 100644 Documentation/cxl/cxl-disable-region.txt
 create mode 100644 Documentation/cxl/cxl-enable-region.txt
 create mode 100644 Documentation/cxl/decoder-option.txt

diff --git a/Documentation/cxl/cxl-destroy-region.txt b/Documentation/cxl/cxl-destroy-region.txt
new file mode 100644
index 0000000..cf1a6fe
--- /dev/null
+++ b/Documentation/cxl/cxl-destroy-region.txt
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-destroy-region(1)
+=====================
+
+NAME
+----
+cxl-destroy-region - destroy specified region(s).
+
+SYNOPSIS
+--------
+[verse]
+'cxl destroy-region <region> [<options>]'
+
+include::region-description.txt[]
+
+EXAMPLE
+-------
+----
+# cxl destroy-region all
+destroyed 2 regions
+----
+
+OPTIONS
+-------
+-f::
+--force::
+	Force a destroy operation even if the region is active.
+	This will attempt to disable the region first.
+
+include::decoder-option.txt[]
+
+include::debug-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1], linkcxl:cxl-create-region[1]
diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
new file mode 100644
index 0000000..2b13a1a
--- /dev/null
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-disable-region(1)
+=====================
+
+NAME
+----
+cxl-disable-region - disable specified region(s).
+
+SYNOPSIS
+--------
+[verse]
+'cxl disable-region <region> [<options>]'
+
+include::region-description.txt[]
+
+EXAMPLE
+-------
+----
+# cxl disable-region all
+disabled 2 regions
+----
+
+OPTIONS
+-------
+include::decoder-option.txt[]
+
+include::debug-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1], linkcxl:cxl-enable-region[1]
diff --git a/Documentation/cxl/cxl-enable-region.txt b/Documentation/cxl/cxl-enable-region.txt
new file mode 100644
index 0000000..86e9aec
--- /dev/null
+++ b/Documentation/cxl/cxl-enable-region.txt
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-enable-region(1)
+=====================
+
+NAME
+----
+cxl-enable-region - enable specified region(s).
+
+SYNOPSIS
+--------
+[verse]
+'cxl enable-region <region> [<options>]'
+
+include::region-description.txt[]
+
+EXAMPLE
+-------
+----
+# cxl enable-region all
+enabled 2 regions
+----
+
+OPTIONS
+-------
+include::decoder-option.txt[]
+
+include::debug-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1], linkcxl:cxl-disable-region[1]
diff --git a/Documentation/cxl/decoder-option.txt b/Documentation/cxl/decoder-option.txt
new file mode 100644
index 0000000..e638d6e
--- /dev/null
+++ b/Documentation/cxl/decoder-option.txt
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+
+-d::
+--decoder=::
+	The root decoder to limit the operation to. Only regions that are
+	children of the specified decoder will be acted upon.
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 843bada..b28c221 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -19,4 +19,7 @@ int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index f0afcfe..dd1be7a 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -73,6 +73,9 @@ static struct cmd_struct commands[] = {
 	{ "set-partition", .c_fn = cmd_set_partition },
 	{ "disable-bus", .c_fn = cmd_disable_bus },
 	{ "create-region", .c_fn = cmd_create_region },
+	{ "enable-region", .c_fn = cmd_enable_region },
+	{ "disable-region", .c_fn = cmd_disable_region },
+	{ "destroy-region", .c_fn = cmd_destroy_region },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/region.c b/cxl/region.c
index 9fe99b2..cb50558 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -45,6 +45,9 @@ struct parsed_params {
 
 enum region_actions {
 	ACTION_CREATE,
+	ACTION_ENABLE,
+	ACTION_DISABLE,
+	ACTION_DESTROY,
 };
 
 static struct log_ctx rl;
@@ -78,7 +81,22 @@ static const struct option create_options[] = {
 	OPT_END(),
 };
 
+static const struct option enable_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
 
+static const struct option disable_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option destroy_options[] = {
+	BASE_OPTIONS(),
+	OPT_BOOLEAN('f', "force", &param.force,
+		    "destroy region even if currently active"),
+	OPT_END(),
+};
 
 static int parse_create_options(int argc, const char **argv,
 				struct parsed_params *p)
@@ -495,11 +513,90 @@ err_delete:
 	return rc;
 }
 
+static int destroy_region(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	unsigned int ways, i;
+	int rc;
+
+	/* First, unbind/disable the region if needed */
+	if (cxl_region_is_enabled(region)) {
+		if (param.force) {
+			rc = cxl_region_disable(region);
+			if (rc) {
+				log_err(&rl, "%s: error disabling region: %s\n",
+					devname, strerror(-rc));
+				return rc;
+			}
+		} else {
+			log_err(&rl, "%s active. Disable it or use --force\n",
+				devname);
+			return -EBUSY;
+		}
+	}
+
+	/* De-commit the region in preparation for removal */
+	rc = cxl_region_decommit(region);
+	if (rc) {
+		log_err(&rl, "%s: failed to decommit: %s\n", devname,
+			strerror(-rc));
+		return rc;
+	}
+
+	/* Reset all endpoint decoders and region targets */
+	ways = cxl_region_get_interleave_ways(region);
+	if (ways == 0 || ways == UINT_MAX) {
+		log_err(&rl, "%s: error getting interleave ways\n", devname);
+		return -ENXIO;
+	}
+
+	for (i = 0; i < ways; i++) {
+		struct cxl_decoder *ep_decoder;
+
+		ep_decoder = cxl_region_get_target_decoder(region, i);
+		if (!ep_decoder)
+			return -ENXIO;
+
+		rc = cxl_region_clear_target(region, i);
+		if (rc) {
+			log_err(&rl, "%s: clearing target%d failed: %s\n",
+				devname, i, strerror(abs(rc)));
+			return rc;
+		}
+
+		rc = cxl_decoder_set_dpa_size(ep_decoder, 0);
+		if (rc) {
+			log_err(&rl, "%s: set_dpa_size failed: %s\n",
+				cxl_decoder_get_devname(ep_decoder),
+				strerror(abs(rc)));
+			return rc;
+		}
+	}
+
+	/* Finally, delete the region */
+	return cxl_region_delete(region);
+}
+
+static int do_region_xable(struct cxl_region *region, enum region_actions action)
+{
+	switch (action) {
+	case ACTION_ENABLE:
+		return cxl_region_enable(region);
+	case ACTION_DISABLE:
+		return cxl_region_disable(region);
+	case ACTION_DESTROY:
+		return destroy_region(region);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			 enum region_actions action,
 			 const struct option *options, struct parsed_params *p,
 			 int *count, const char *u)
 {
+	struct cxl_bus *bus;
 	int rc = -ENXIO;
 
 	log_init(&rl, "cxl region", "CXL_REGION_LOG");
@@ -509,6 +606,45 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 
 	if (action == ACTION_CREATE)
 		return create_region(ctx, count, p);
+
+	cxl_bus_foreach(ctx, bus) {
+		struct cxl_decoder *decoder;
+		struct cxl_port *port;
+
+		port = cxl_bus_get_port(bus);
+		if (!cxl_port_is_root(port))
+			continue;
+
+		cxl_decoder_foreach (port, decoder) {
+			struct cxl_region *region, *_r;
+
+			decoder = util_cxl_decoder_filter(decoder,
+							  param.root_decoder);
+			if (!decoder)
+				continue;
+			cxl_region_foreach_safe(decoder, region, _r)
+			{
+				int i, match = 0;
+
+				for (i = 0; i < p->num_targets; i++) {
+					if (util_cxl_region_filter(
+						    region, p->targets[i])) {
+						match = 1;
+						break;
+					}
+				}
+				if (!match)
+					continue;
+
+				rc = do_region_xable(region, action);
+				if (rc == 0)
+					*count += 1;
+				else
+					log_err(&rl, "%s: failed: %s\n",
+						cxl_region_get_devname(region),
+						strerror(-rc));
+			}
+		}
 	}
 
 	return rc;
@@ -525,3 +661,39 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx)
 	log_info(&rl, "created %d region%s\n", count, count == 1 ? "" : "s");
 	return rc == 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_enable_region(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const char *u = "cxl enable-region <region0> ... [<options>]";
+	struct parsed_params p = { 0 };
+	int rc, count = 0;
+
+	rc = region_action(argc, argv, ctx, ACTION_ENABLE, enable_options, &p,
+			   &count, u);
+	log_info(&rl, "enabled %d region%s\n", count, count == 1 ? "" : "s");
+	return rc == 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_disable_region(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const char *u = "cxl disable-region <region0> ... [<options>]";
+	struct parsed_params p = { 0 };
+	int rc, count = 0;
+
+	rc = region_action(argc, argv, ctx, ACTION_DISABLE, disable_options, &p,
+			   &count, u);
+	log_info(&rl, "disabled %d region%s\n", count, count == 1 ? "" : "s");
+	return rc == 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_destroy_region(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const char *u = "cxl destroy-region <region0> ... [<options>]";
+	struct parsed_params p = { 0 };
+	int rc, count = 0;
+
+	rc = region_action(argc, argv, ctx, ACTION_DESTROY, destroy_options, &p,
+			   &count, u);
+	log_info(&rl, "destroyed %d region%s\n", count, count == 1 ? "" : "s");
+	return rc == 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 340cdee..147ea71 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -24,6 +24,7 @@ filedeps = [
   'labels-options.txt',
   'debug-option.txt',
   'region-description.txt',
+  'decoder-option.txt',
 ]
 
 cxl_manpages = [
@@ -41,6 +42,9 @@ cxl_manpages = [
   'cxl-reserve-dpa.txt',
   'cxl-free-dpa.txt',
   'cxl-create-region.txt',
+  'cxl-disable-region.txt',
+  'cxl-enable-region.txt',
+  'cxl-destroy-region.txt',
 ]
 
 foreach man : cxl_manpages
-- 
2.36.1

