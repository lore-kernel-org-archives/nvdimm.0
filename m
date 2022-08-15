Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7515392
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591344; x=1692127344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kWdpWopw0zYMnyW3Hpoy0cThHlwGFMQI8KBEr1SCr0g=;
  b=NA58aVvp0Tt8aNTpKDA6QlhUZ6aq1K9ZdfDgkXtnJvSukHcT3eHu8nkS
   UTTmMUIwwtNqJauuBuNiinXYf5b0npj2uHue4AZqgDZnaq1dYlVu3YSCu
   5W18bx6ZdYVlnpytSe0cb6nue5Aa3dqMME/TcyHWqBp8LBM7qyya907KP
   6uM7OBDp0Ye3ZWpZB1cHOydJ11h1tIvZzaXu8qzJ/uf1WHxr7QjFeHCdR
   ENNchenf3G3bzgDmhcbeVqwQDXTwiABP5gAWGYxI18vZQS4M1ZpH6HfM9
   9VjUZedsU9oUNPCsnJpufLxPzt/y7A7HhU1bwcl+xrOVIgitFG/cFKLQb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038724"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038724"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758261"
Received: from smadiset-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.5.99])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:20 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 08/11] cxl: add commands to {enable,disable,destroy}-region
Date: Mon, 15 Aug 2022 13:22:11 -0600
Message-Id: <20220815192214.545800-9-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12123; h=from:subject; bh=kWdpWopw0zYMnyW3Hpoy0cThHlwGFMQI8KBEr1SCr0g=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jyz+mJe3DE147J0nF2YjefLDcGzz5rKyDcb17B15Z3l Xv64o5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABOpC2P4w3EgmnXJzf1HFnLVqSd8uG RyT/HXmQeVV3Ya+GpfXCnDcZmR4f2W8gRO//nze/zWJHnM3G/k8OziZhMF4UXKBxRnG7h95QIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

With a template from cxl-create-region in place, add its friends:

  cxl enable-region
  cxl disable-region
  cxl destroy-region

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-destroy-region.txt |  41 +++++
 Documentation/cxl/cxl-disable-region.txt |  36 +++++
 Documentation/cxl/cxl-enable-region.txt  |  36 +++++
 Documentation/cxl/decoder-option.txt     |   6 +
 cxl/builtin.h                            |   3 +
 cxl/cxl.c                                |   3 +
 cxl/region.c                             | 193 ++++++++++++++++++++++-
 Documentation/cxl/meson.build            |   4 +
 8 files changed, 321 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-destroy-region.txt
 create mode 100644 Documentation/cxl/cxl-disable-region.txt
 create mode 100644 Documentation/cxl/cxl-enable-region.txt
 create mode 100644 Documentation/cxl/decoder-option.txt

diff --git a/Documentation/cxl/cxl-destroy-region.txt b/Documentation/cxl/cxl-destroy-region.txt
new file mode 100644
index 0000000..74f4093
--- /dev/null
+++ b/Documentation/cxl/cxl-destroy-region.txt
@@ -0,0 +1,41 @@
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
+include::bus-option.txt[]
+
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
index 0000000..6a39aee
--- /dev/null
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -0,0 +1,36 @@
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
+include::bus-option.txt[]
+
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
index 0000000..f6ef00f
--- /dev/null
+++ b/Documentation/cxl/cxl-enable-region.txt
@@ -0,0 +1,36 @@
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
+include::bus-option.txt[]
+
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
index 2791ac9..b22d3c8 100644
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
@@ -519,12 +537,122 @@ err_delete:
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
+	/* Reset the region decode in preparation for removal */
+	rc = cxl_region_decode_reset(region);
+	if (rc) {
+		log_err(&rl, "%s: failed to reset decode: %s\n", devname,
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
+static int decoder_region_action(struct parsed_params *p,
+				 struct cxl_decoder *decoder,
+				 enum region_actions action, int *count)
+{
+	struct cxl_region *region, *_r;
+	int rc = 0, err_rc = 0;
+
+	cxl_region_foreach_safe (decoder, region, _r) {
+		int i, match = 0;
+
+		for (i = 0; i < p->num_targets; i++) {
+			if (util_cxl_region_filter(region, p->targets[i])) {
+				match = 1;
+				break;
+			}
+		}
+		if (!match)
+			continue;
+
+		rc = do_region_xable(region, action);
+		if (rc == 0) {
+			*count += 1;
+		} else {
+			log_err(&rl, "%s: failed: %s\n",
+				cxl_region_get_devname(region), strerror(-rc));
+			err_rc = rc;
+		}
+	}
+	return err_rc ? err_rc : rc;
+}
+
 static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			 enum region_actions action,
 			 const struct option *options, struct parsed_params *p,
 			 int *count, const char *u)
 {
-	int rc = -ENXIO;
+	int rc = 0, err_rc = 0;
+	struct cxl_bus *bus;
 
 	log_init(&rl, "cxl region", "CXL_REGION_LOG");
 	rc = parse_region_options(argc, argv, ctx, action, options, p, u);
@@ -534,6 +662,33 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	if (action == ACTION_CREATE)
 		return create_region(ctx, count, p);
 
+	cxl_bus_foreach(ctx, bus) {
+		struct cxl_decoder *decoder;
+		struct cxl_port *port;
+
+		if (!util_cxl_bus_filter(bus, param.bus))
+			continue;
+
+		port = cxl_bus_get_port(bus);
+		if (!cxl_port_is_root(port))
+			continue;
+
+		cxl_decoder_foreach (port, decoder) {
+			decoder = util_cxl_decoder_filter(decoder,
+							  param.root_decoder);
+			if (!decoder)
+				continue;
+			rc = decoder_region_action(p, decoder, action, count);
+			if (rc)
+				err_rc = rc;
+		}
+	}
+
+	if (err_rc) {
+		log_err(&rl, "one or more failures, last failure: %s\n",
+			strerror(-err_rc));
+		return err_rc;
+	}
 	return rc;
 }
 
@@ -548,3 +703,39 @@ int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx)
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
2.37.1

