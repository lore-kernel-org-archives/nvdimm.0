Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644695385
	for <nvdimm@lists.linux.dev>; Mon, 15 Aug 2022 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660591344; x=1692127344;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QCN9NP5pTAHuTKN2JVgW3vlfKGrx2QsnmrCfpoAXji8=;
  b=TtUmJHxAaA4bxRzPJT4da2Sc/8Yv49FvseNqKhqEtx2yUQWfknkUwYje
   obZvgiZfcmq7rmj0ybXgsiLOtq5WmT3GOoc45pyxoDgmr4nYjN3T48sek
   ON4YW4eQh95wZJJTd0xRTBzZOP4EAdIZ1haH/o0XkU/fMh9Xp06aNPx+m
   6ZOGHjy6CKWdGvvl4C8Qcwh7iLHXravjigHjUQSolKxgabznPqY7aDCoU
   DeEqnrMSZIhE6IzaYeQyiQSqdr6YG8KYC9e4ntFOPBuJj4dfs4OKEnUt3
   SSdgV7oMkZrPf3uU1JN+7WQT6iiI3DEFj0I2mFdGL7kA7FSM6Qti3lu21
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="292038721"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="292038721"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 12:22:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="606758258"
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
Subject: [ndctl PATCH v3 07/11] cxl: add a 'create-region' command
Date: Mon, 15 Aug 2022 13:22:10 -0600
Message-Id: <20220815192214.545800-8-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220815192214.545800-1-vishal.l.verma@intel.com>
References: <20220815192214.545800-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=23444; h=from:subject; bh=QCN9NP5pTAHuTKN2JVgW3vlfKGrx2QsnmrCfpoAXji8=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm/5jzdaTjR1KP7gfWKg4JLt4a/NmFR2uqyUybCyVGbK/X0 +nS/jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzkaz8jQ0dI/Vth82s3J9fO7DuZsy joyaZF2gc5Xk3OmZ/LquRcYMnwT1tsl9Fh5+VnZlu76cvcKntetWebRpv27BWuD/c8etn9kBcA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a 'create-region' command to cxl-cli that walks the platform's CXL
hierarchy to find an appropriate root decoder based on any options
provided, and uses libcxl APIs to create a 'region' that is comprehended
by libnvdimm and ndctl.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/bus-option.txt         |   5 +
 Documentation/cxl/cxl-create-region.txt  | 112 +++++
 Documentation/cxl/region-description.txt |   7 +
 cxl/builtin.h                            |   1 +
 cxl/filter.h                             |   4 +-
 cxl/cxl.c                                |   1 +
 cxl/json.c                               |   9 +
 cxl/region.c                             | 550 +++++++++++++++++++++++
 Documentation/cxl/meson.build            |   2 +
 cxl/meson.build                          |   1 +
 10 files changed, 691 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/bus-option.txt
 create mode 100644 Documentation/cxl/cxl-create-region.txt
 create mode 100644 Documentation/cxl/region-description.txt
 create mode 100644 cxl/region.c

diff --git a/Documentation/cxl/bus-option.txt b/Documentation/cxl/bus-option.txt
new file mode 100644
index 0000000..02e2f08
--- /dev/null
+++ b/Documentation/cxl/bus-option.txt
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
+-b::
+--bus=::
+	Restrict the operation to the specified bus.
diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
new file mode 100644
index 0000000..6b740d5
--- /dev/null
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-create-region(1)
+====================
+
+NAME
+----
+cxl-create-region - Assemble a CXL region by setting up attributes of its
+constituent CXL memdevs.
+
+SYNOPSIS
+--------
+[verse]
+'cxl create-region [<options>]'
+
+include::region-description.txt[]
+
+For create-region, a size can optionally be specified, but if not, the maximum
+possible size for each memdev will be used up to the available decode capacity
+in the system for the given memory type. For persistent regions a UUID can
+optionally be specified, but if not, one will be generated.
+
+If the region-creation operation is successful, a region object will be
+emitted on stdout in JSON format (see examples). If the specified arguments
+cannot be satisfied with a legal configuration, then an appropriate error will
+be emitted on stderr.
+
+EXAMPLE
+-------
+----
+#cxl create - region - m - d decoder0 .1 - w 2 - g 1024 mem0 mem1
+{
+  "region":"region0",
+  "resource":"0xc90000000",
+  "size":"512.00 MiB (536.87 MB)",
+  "interleave_ways":2,
+  "interleave_granularity":1024,
+  "mappings":[
+    {
+      "position":1,
+      "decoder":"decoder4.0"
+    },
+    {
+      "position":0,
+      "decoder":"decoder3.0"
+    }
+  ]
+}
+created 1 region
+----
+
+OPTIONS
+-------
+<target(s)>::
+The CXL targets that should be used to form the region. The number of
+'target' arguments must match the '--ways' option (if provided). The
+targets are memdev names such as 'mem0', 'mem1' etc.
+
+include::bus-option.txt[]
+
+-m::
+--memdevs::
+	Indicate that the non-option arguments for 'target(s)' refer to memdev
+	names. Currently this is the only option supported, and must be
+	specified.
+
+-s::
+--size=::
+	Specify the total size for the new region. This is optional, and by
+	default, the maximum possible size will be used. The maximum possible
+	size is gated by both the contiguous free HPA space remaining in the
+	root decoder, and the available DPA space in the component memdevs.
+
+-t::
+--type=::
+	Specify the region type - 'pmem' or 'ram'. Defaults to 'pmem'.
+
+-U::
+--uuid=::
+	Specify a UUID for the new region. This shouldn't usually need to be
+	specified, as one will be generated by default.
+
+-w::
+--ways=::
+	The number of interleave ways for the new region's interleave. This
+	should be equal to the number of memdevs specified in --memdevs, if
+	--memdevs is being supplied. If --ways is not specified, it will be
+	determined based on the number of memdev targets provided.
+
+-g::
+--granularity=::
+	The interleave granularity for the new region. Must match the selected
+	root decoder's (if provided) granularity. If the root decoder is
+	interleaved across more than one host-bridge then this value must match
+	that granularity. Otherwise, for non-interleaved decode windows, any
+	granularity can be specified as long as all devices support that setting.
+
+-d::
+--decoder=::
+	The root decoder that the region should be created under. If not
+	supplied, the first cross-host bridge (if available), decoder that
+	supports the largest interleave will be chosen.
+
+include::human-option.txt[]
+
+include::debug-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1],
diff --git a/Documentation/cxl/region-description.txt b/Documentation/cxl/region-description.txt
new file mode 100644
index 0000000..d7e3077
--- /dev/null
+++ b/Documentation/cxl/region-description.txt
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+
+DESCRIPTION
+-----------
+A CXL region is composed of one or more slices of CXL memdevs, with configurable
+interleave settings - both the number of interleave ways, and the interleave
+granularity.
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 9e6fc62..843bada 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -18,4 +18,5 @@ int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/filter.h b/cxl/filter.h
index 609433c..d22d8b1 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -35,8 +35,10 @@ struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
 						const char *ident,
 						const char *serial);
-struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
+struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
 					    const char *__ident);
+struct cxl_region *util_cxl_region_filter(struct cxl_region *region,
+					  const char *__ident);
 
 enum cxl_port_filter_mode {
 	CXL_PF_SINGLE,
diff --git a/cxl/cxl.c b/cxl/cxl.c
index ef4cda9..f0afcfe 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -72,6 +72,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-port", .c_fn = cmd_enable_port },
 	{ "set-partition", .c_fn = cmd_set_partition },
 	{ "disable-bus", .c_fn = cmd_disable_bus },
+	{ "create-region", .c_fn = cmd_create_region },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/json.c b/cxl/json.c
index 70cf286..9dc99df 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -547,6 +547,7 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 	cxl_mapping_foreach(region, mapping) {
 		struct json_object *jmapping;
 		struct cxl_decoder *decoder;
+		struct cxl_memdev *memdev;
 
 		jmapping = json_object_new_object();
 		if (!jmapping)
@@ -564,6 +565,14 @@ void util_cxl_mappings_append_json(struct json_object *jregion,
 		if (!decoder)
 			continue;
 
+		memdev = cxl_decoder_get_memdev(decoder);
+		if (memdev) {
+			devname = cxl_memdev_get_devname(memdev);
+			jobj = json_object_new_string(devname);
+			if (jobj)
+				json_object_object_add(jmapping, "memdev", jobj);
+		}
+
 		devname = cxl_decoder_get_devname(decoder);
 		jobj = json_object_new_string(devname);
 		if (jobj)
diff --git a/cxl/region.c b/cxl/region.c
new file mode 100644
index 0000000..2791ac9
--- /dev/null
+++ b/cxl/region.c
@@ -0,0 +1,550 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2020-2022 Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <util/log.h>
+#include <uuid/uuid.h>
+#include <util/json.h>
+#include <util/size.h>
+#include <cxl/libcxl.h>
+#include <json-c/json.h>
+#include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/short_types/short_types.h>
+
+#include "filter.h"
+#include "json.h"
+
+static struct region_params {
+	const char *bus;
+	const char *size;
+	const char *ways;
+	const char *granularity;
+	const char *type;
+	const char *root_decoder;
+	const char *region;
+	bool memdevs;
+	bool force;
+	bool human;
+	bool debug;
+} param;
+
+struct parsed_params {
+	u64 size;
+	u64 ep_min_size;
+	unsigned int ways;
+	unsigned int granularity;
+	const char **targets;
+	int num_targets;
+	struct cxl_decoder *root_decoder;
+	enum cxl_decoder_mode mode;
+};
+
+enum region_actions {
+	ACTION_CREATE,
+};
+
+static struct log_ctx rl;
+
+#define BASE_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus name", \
+	   "Limit operation to the specified bus"), \
+OPT_STRING('d', "decoder", &param.root_decoder, "root decoder name", \
+	   "Limit to / use the specified root decoder"), \
+OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug")
+
+#define CREATE_OPTIONS() \
+OPT_STRING('s', "size", &param.size, \
+	   "size in bytes or with a K/M/G etc. suffix", \
+	   "total size desired for the resulting region."), \
+OPT_STRING('w', "ways", &param.ways, \
+	   "number of interleave ways", \
+	   "number of memdevs participating in the regions interleave set"), \
+OPT_STRING('g', "granularity", \
+	   &param.granularity, "interleave granularity", \
+	   "granularity of the interleave set"), \
+OPT_STRING('t', "type", &param.type, \
+	   "region type", "region type - 'pmem' or 'ram'"), \
+OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
+	    "non-option arguments are memdevs"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
+
+static const struct option create_options[] = {
+	BASE_OPTIONS(),
+	CREATE_OPTIONS(),
+	OPT_END(),
+};
+
+
+
+static int parse_create_options(int argc, const char **argv,
+				struct parsed_params *p)
+{
+	int i;
+
+	if (!param.root_decoder) {
+		log_err(&rl, "no root decoder specified\n");
+		return -EINVAL;
+	}
+
+	if (param.type) {
+		p->mode = cxl_decoder_mode_from_ident(param.type);
+		if (p->mode == CXL_DECODER_MODE_NONE) {
+			log_err(&rl, "unsupported type: %s\n", param.type);
+			return -EINVAL;
+		}
+	} else {
+		p->mode = CXL_DECODER_MODE_PMEM;
+	}
+
+	if (param.size) {
+		p->size = parse_size64(param.size);
+		if (p->size == ULLONG_MAX) {
+			log_err(&rl, "Invalid size: %s\n", param.size);
+			return -EINVAL;
+		}
+	}
+
+	if (param.ways) {
+		unsigned long ways = strtoul(param.ways, NULL, 0);
+
+		if (ways == ULONG_MAX || (int)ways <= 0) {
+			log_err(&rl, "Invalid interleave ways: %s\n",
+				param.ways);
+			return -EINVAL;
+		}
+		p->ways = ways;
+	} else if (argc) {
+		p->ways = argc;
+	} else {
+		log_err(&rl,
+			"couldn't determine interleave ways from options or arguments\n");
+		return -EINVAL;
+	}
+
+	if (param.granularity) {
+		unsigned long granularity = strtoul(param.granularity, NULL, 0);
+
+		if (granularity == ULONG_MAX || (int)granularity <= 0) {
+			log_err(&rl, "Invalid interleave granularity: %s\n",
+				param.granularity);
+			return -EINVAL;
+		}
+		p->granularity = granularity;
+	}
+
+
+	if (argc > (int)p->ways) {
+		for (i = p->ways; i < argc; i++)
+			log_err(&rl, "extra argument: %s\n", p->targets[i]);
+		return -EINVAL;
+	}
+
+	if (argc < (int)p->ways) {
+		log_err(&rl,
+			"too few target arguments (%d) for interleave ways (%u)\n",
+			argc, p->ways);
+		return -EINVAL;
+	}
+
+	if (p->size && p->ways) {
+		if (p->size % p->ways) {
+			log_err(&rl,
+				"size (%lu) is not an integral multiple of interleave-ways (%u)\n",
+				p->size, p->ways);
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * For all practical purposes, -m is the default target type, but
+	 * hold off on actively making that decision until a second target
+	 * option is available.
+	 */
+	if (!param.memdevs) {
+		log_err(&rl,
+			"must specify option for target object types (-m)\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int parse_region_options(int argc, const char **argv,
+				struct cxl_ctx *ctx, enum region_actions action,
+				const struct option *options,
+				struct parsed_params *p, const char *usage)
+{
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+
+	argc = parse_options(argc, argv, options, u, 0);
+	p->targets = argv;
+	p->num_targets = argc;
+
+	if (param.debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		rl.log_priority = LOG_DEBUG;
+	} else
+		rl.log_priority = LOG_INFO;
+
+	switch(action) {
+	case ACTION_CREATE:
+		return parse_create_options(argc, argv, p);
+	default:
+		return 0;
+	}
+}
+
+/**
+ * validate_memdev() - match memdev with the target provided,
+ *                     and determine its size contribution
+ * @memdev: cxl_memdev being tested for a match against the named target
+ * @target: target memdev
+ * @p:      params structure
+ *
+ * This is called for each memdev in the system, and only returns 'true' if
+ * the memdev name matches the target argument being tested. Additionally,
+ * it sets an ep_min_size attribute that always contains the size of the
+ * smallest target in the provided list. This is used during the automatic
+ * size determination later, to ensure that all targets contribute equally
+ * to the region in case of unevenly sized memdevs.
+ */
+static bool validate_memdev(struct cxl_memdev *memdev, const char *target,
+			    struct parsed_params *p)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	u64 size;
+
+	if (strcmp(devname, target) != 0)
+		return false;
+
+	size = cxl_memdev_get_pmem_size(memdev);
+	if (!p->ep_min_size)
+		p->ep_min_size = size;
+	else
+		p->ep_min_size = min(p->ep_min_size, size);
+
+	return true;
+}
+
+static int validate_config_memdevs(struct cxl_ctx *ctx, struct parsed_params *p)
+{
+	unsigned int i, matched = 0;
+
+	for (i = 0; i < p->ways; i++) {
+		struct cxl_memdev *memdev;
+
+		cxl_memdev_foreach(ctx, memdev)
+			if (validate_memdev(memdev, p->targets[i], p))
+				matched++;
+	}
+	if (matched != p->ways) {
+		log_err(&rl,
+			"one or more memdevs not found in CXL topology\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int validate_decoder(struct cxl_decoder *decoder,
+			    struct parsed_params *p)
+{
+	const char *devname = cxl_decoder_get_devname(decoder);
+
+	switch(p->mode) {
+	case CXL_DECODER_MODE_RAM:
+		if (!cxl_decoder_is_volatile_capable(decoder)) {
+			log_err(&rl, "%s is not volatile capable\n", devname);
+			return -EINVAL;
+		}
+		break;
+	case CXL_DECODER_MODE_PMEM:
+		if (!cxl_decoder_is_pmem_capable(decoder)) {
+			log_err(&rl, "%s is not pmem capable\n", devname);
+			return -EINVAL;
+		}
+		break;
+	default:
+		log_err(&rl, "unknown type: %s\n", param.type);
+		return -EINVAL;
+	}
+
+	/* TODO check if the interleave config is possible under this decoder */
+
+	return 0;
+}
+
+static int create_region_validate_config(struct cxl_ctx *ctx,
+					 struct parsed_params *p)
+{
+	struct cxl_bus *bus;
+	int rc;
+
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
+			if (util_cxl_decoder_filter(decoder,
+						    param.root_decoder)) {
+				p->root_decoder = decoder;
+				goto found;
+			}
+		}
+	}
+
+found:
+	if (p->root_decoder == NULL) {
+		log_err(&rl, "%s not found in CXL topology\n",
+			param.root_decoder);
+		return -ENXIO;
+	}
+
+	rc = validate_decoder(p->root_decoder, p);
+	if (rc)
+		return rc;
+
+	return validate_config_memdevs(ctx, p);
+}
+
+static struct cxl_decoder *
+cxl_memdev_target_find_decoder(struct cxl_ctx *ctx, const char *memdev_name)
+{
+	struct cxl_endpoint *ep = NULL;
+	struct cxl_decoder *decoder;
+	struct cxl_memdev *memdev;
+	struct cxl_port *port;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		const char *devname = cxl_memdev_get_devname(memdev);
+
+		if (strcmp(devname, memdev_name) != 0)
+			continue;
+
+		ep = cxl_memdev_get_endpoint(memdev);
+	}
+
+	if (!ep) {
+		log_err(&rl, "could not get an endpoint for %s\n",
+			memdev_name);
+		return NULL;
+	}
+
+	port = cxl_endpoint_get_port(ep);
+	if (!port) {
+		log_err(&rl, "could not get a port for %s\n",
+			memdev_name);
+		return NULL;
+	}
+
+	cxl_decoder_foreach(port, decoder)
+		if (cxl_decoder_get_size(decoder) == 0)
+			return decoder;
+
+	log_err(&rl, "could not get a free decoder for %s\n", memdev_name);
+	return NULL;
+}
+
+#define try(prefix, op, dev, p) \
+do { \
+	int __rc = prefix##_##op(dev, p); \
+	if (__rc) { \
+		log_err(&rl, "%s: " #op " failed: %s\n", \
+				prefix##_get_devname(dev), \
+				strerror(abs(__rc))); \
+		rc = __rc; \
+		goto err_delete; \
+	} \
+} while (0)
+
+static int cxl_region_determine_granularity(struct cxl_region *region,
+					    struct parsed_params *p)
+{
+	const char *devname = cxl_region_get_devname(region);
+	unsigned int granularity, ways;
+
+	/* Default granularity will be the root decoder's granularity */
+	granularity = cxl_decoder_get_interleave_granularity(p->root_decoder);
+	if (granularity == 0 || granularity == UINT_MAX) {
+		log_err(&rl, "%s: unable to determine root decoder granularity\n",
+			devname);
+		return -ENXIO;
+	}
+
+	/* If no user-supplied granularity, just use the default */
+	if (!p->granularity)
+		return granularity;
+
+	ways = cxl_decoder_get_interleave_ways(p->root_decoder);
+	if (ways == 0 || ways == UINT_MAX) {
+		log_err(&rl, "%s: unable to determine root decoder ways\n",
+			devname);
+		return -ENXIO;
+	}
+
+	/* For ways == 1, any user-supplied granularity is fine */
+	if (ways == 1)
+		return p->granularity;
+
+	/*
+	 * For ways > 1, only allow the same granularity as the selected
+	 * root decoder
+	 */
+	if (p->granularity == granularity)
+		return granularity;
+
+	log_err(&rl,
+		"%s: For an x%d root, only root decoder granularity (%d) permitted\n",
+		devname, ways, granularity);
+	return -EINVAL;
+}
+
+static int create_region(struct cxl_ctx *ctx, int *count,
+			 struct parsed_params *p)
+{
+	unsigned long flags = UTIL_JSON_TARGETS;
+	struct json_object *jregion;
+	unsigned int i, granularity;
+	struct cxl_region *region;
+	const char *devname;
+	uuid_t uuid;
+	u64 size;
+	int rc;
+
+	rc = create_region_validate_config(ctx, p);
+	if (rc)
+		return rc;
+
+	if (p->size) {
+		size = p->size;
+	} else if (p->ep_min_size) {
+		size = p->ep_min_size * p->ways;
+	} else {
+		log_err(&rl, "%s: unable to determine region size\n", __func__);
+		return -ENXIO;
+	}
+
+	if (p->mode == CXL_DECODER_MODE_PMEM) {
+		region = cxl_decoder_create_pmem_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
+	} else {
+		log_err(&rl, "region type '%s' not supported yet\n",
+			param.type);
+		return -EOPNOTSUPP;
+	}
+
+	devname = cxl_region_get_devname(region);
+
+	rc = cxl_region_determine_granularity(region, p);
+	if (rc < 0)
+		goto err_delete;
+	granularity = rc;
+
+	uuid_generate(uuid);
+	try(cxl_region, set_interleave_granularity, region, granularity);
+	try(cxl_region, set_interleave_ways, region, p->ways);
+	try(cxl_region, set_uuid, region, uuid);
+	try(cxl_region, set_size, region, size);
+
+	for (i = 0; i < p->ways; i++) {
+		struct cxl_decoder *ep_decoder = NULL;
+
+		ep_decoder = cxl_memdev_target_find_decoder(ctx, p->targets[i]);
+		if (!ep_decoder) {
+			rc = -ENXIO;
+			goto err_delete;
+		}
+		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {
+			/*
+			 * The memdev_target_find_decoder() helper returns a free
+			 * decoder whose size has been checked for 0.
+			 * Thus it is safe to change the mode here if needed.
+			 */
+			try(cxl_decoder, set_dpa_size, ep_decoder, 0);
+			try(cxl_decoder, set_mode, ep_decoder, p->mode);
+		}
+		try(cxl_decoder, set_dpa_size, ep_decoder, size/p->ways);
+		rc = cxl_region_set_target(region, i, ep_decoder);
+		if (rc) {
+			log_err(&rl, "%s: failed to set target%d to %s\n",
+				devname, i, p->targets[i]);
+			goto err_delete;
+		}
+	}
+
+	rc = cxl_region_decode_commit(region);
+	if (rc) {
+		log_err(&rl, "%s: failed to commit decode: %s\n", devname,
+			strerror(-rc));
+		goto err_delete;
+	}
+
+	rc = cxl_region_enable(region);
+	if (rc) {
+		log_err(&rl, "%s: failed to enable: %s\n", devname,
+			strerror(-rc));
+		goto err_delete;
+	}
+	*count = 1;
+
+	if (isatty(1))
+		flags |= UTIL_JSON_HUMAN;
+	jregion = util_cxl_region_to_json(region, flags);
+	if (jregion)
+		printf("%s\n", json_object_to_json_string_ext(jregion,
+					JSON_C_TO_STRING_PRETTY));
+
+	return 0;
+
+err_delete:
+	cxl_region_delete(region);
+	return rc;
+}
+
+static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
+			 enum region_actions action,
+			 const struct option *options, struct parsed_params *p,
+			 int *count, const char *u)
+{
+	int rc = -ENXIO;
+
+	log_init(&rl, "cxl region", "CXL_REGION_LOG");
+	rc = parse_region_options(argc, argv, ctx, action, options, p, u);
+	if (rc)
+		return rc;
+
+	if (action == ACTION_CREATE)
+		return create_region(ctx, count, p);
+
+	return rc;
+}
+
+int cmd_create_region(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	const char *u = "cxl create-region <target0> ... [<options>]";
+	struct parsed_params p = { 0 };
+	int rc, count = 0;
+
+	rc = region_action(argc, argv, ctx, ACTION_CREATE, create_options, &p,
+			   &count, u);
+	log_info(&rl, "created %d region%s\n", count, count == 1 ? "" : "s");
+	return rc == 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 423be90..340cdee 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -23,6 +23,7 @@ filedeps = [
   'memdev-option.txt',
   'labels-options.txt',
   'debug-option.txt',
+  'region-description.txt',
 ]
 
 cxl_manpages = [
@@ -39,6 +40,7 @@ cxl_manpages = [
   'cxl-set-partition.txt',
   'cxl-reserve-dpa.txt',
   'cxl-free-dpa.txt',
+  'cxl-create-region.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/meson.build b/cxl/meson.build
index d63dcb1..f2474aa 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -3,6 +3,7 @@ cxl_src = [
   'list.c',
   'port.c',
   'bus.c',
+  'region.c',
   'memdev.c',
   'json.c',
   'filter.c',
-- 
2.37.1

