Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD517184C
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183827; x=1682719827;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gN39W8hJNmHAkE5uIG1rVcKW1lQE+KnARB8xkz+H97Y=;
  b=h3Tr4UonMtvrTMiQazkxOonfvdItFxKtFx4HKAHLYHiP7i7JLwfppKR8
   8Hy5nr6LvNLJQdN2auKhwC/C1/EkR8akbkPrJ+eoDOTO/jW/4sci1BxH2
   ayss6+z8kie2rYfNBlVutGSCeW88AlPTlAwcfV+vqx4FZgErzK7WNFshz
   8sXkjEryduofXpoN7eCeXyfEc39F7WZl6KZdvJS6qT29XRcGqaldumcYu
   he146R4m7XZRb4Em2VGtfJaD7iXF9LxRuE/EWPzPKNvcb6ss/Q6ZtXz6D
   l8CQTpouwz4k5f1h4EXx9PebwIYdv0nLHyP3GzlWDIC1c1TJ+RsFKco5m
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="326933519"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="326933519"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="534122595"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:27 -0700
Subject: [ndctl PATCH 05/10] cxl/bus: Add bus disable support
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:27 -0700
Message-ID: <165118382738.1676208.16851880881648171660.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Route requests to disable the root back to unbinding the platform firmware
device, ACPI0017 for ACPI.CXL platforms.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/cxl/cxl-disable-bus.txt |   37 ++++++++
 Documentation/cxl/lib/libcxl.txt      |   12 ++
 Documentation/cxl/meson.build         |    1 
 cxl/builtin.h                         |    1 
 cxl/bus.c                             |  159 +++++++++++++++++++++++++++++++++
 cxl/cxl.c                             |    1 
 cxl/filter.c                          |    3 -
 cxl/filter.h                          |    1 
 cxl/lib/libcxl.c                      |   15 +++
 cxl/lib/libcxl.sym                    |    1 
 cxl/libcxl.h                          |    1 
 cxl/meson.build                       |    1 
 12 files changed, 231 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/cxl/cxl-disable-bus.txt
 create mode 100644 cxl/bus.c

diff --git a/Documentation/cxl/cxl-disable-bus.txt b/Documentation/cxl/cxl-disable-bus.txt
new file mode 100644
index 000000000000..65f695cd06c8
--- /dev/null
+++ b/Documentation/cxl/cxl-disable-bus.txt
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-disable-bus(1)
+===================
+
+NAME
+----
+cxl-disable-bus - Shutdown an entire tree of CXL devices
+
+SYNOPSIS
+--------
+[verse]
+'cxl disable-bus' <root0> [<root1>..<rootN>] [<options>]
+
+For test and debug scenarios, disable a CXL bus and any associated
+memory devices from CXL.mem operations.
+
+OPTIONS
+-------
+-f::
+--force::
+	DANGEROUS: Override the safety measure that blocks attempts to disable a
+	bus if the tool determines a descendent memdev is in active usage.
+	Recall that CXL memory ranges might have been established by platform
+	firmware and disabling an active device is akin to force removing memory
+	from a running system.
+
+--debug::
+	If the cxl tool was built with debug disabled, turn on debug
+	messages.
+
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-disable-port[1]
diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 7b223cbcac3f..f8f0e668ab59 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -216,6 +216,18 @@ discovery order. The possible provider names are 'ACPI.CXL' and
 the kernel device names that are subject to change based on discovery
 order.
 
+=== BUS: Control
+----
+int cxl_bus_disable_invalidate(struct cxl_bus *bus);
+----
+
+An entire CXL topology can be torn down with this API. Like other
+_invalidate APIs callers must assume that all library objects have been
+freed. This one goes one step further and also frees the @bus argument.
+This may crash the system and is only useful in kernel driver
+development scenarios.
+
+
 PORTS
 -----
 CXL ports track the PCIe hierarchy between a platform firmware CXL root
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index e927644a3826..974a5a41d169 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -34,6 +34,7 @@ cxl_manpages = [
   'cxl-disable-memdev.txt',
   'cxl-enable-port.txt',
   'cxl-disable-port.txt',
+  'cxl-disable-bus.txt',
   'cxl-set-partition.txt',
 ]
 
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 7bbad98f67ac..a437bc314a30 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -15,4 +15,5 @@ int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/bus.c b/cxl/bus.c
new file mode 100644
index 000000000000..33212951a404
--- /dev/null
+++ b/cxl/bus.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2020-2022 Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <util/log.h>
+#include <cxl/libcxl.h>
+#include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/array_size/array_size.h>
+
+#include "filter.h"
+
+static struct parameters {
+	bool debug;
+	bool force;
+} param;
+
+static struct log_ctx bl;
+
+#define BASE_OPTIONS()                                                 \
+OPT_BOOLEAN(0, "debug", &param.debug, "turn on debug")
+
+#define DISABLE_OPTIONS()                                              \
+OPT_BOOLEAN('f', "force", &param.force,                                \
+	    "DANGEROUS: override active memdev safety checks")
+
+static const struct option disable_options[] = {
+	BASE_OPTIONS(),
+	DISABLE_OPTIONS(),
+	OPT_END(),
+};
+
+static int action_disable(struct cxl_bus *bus)
+{
+	const char *devname = cxl_bus_get_devname(bus);
+	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
+	struct cxl_memdev *memdev;
+	int active_memdevs = 0;
+
+	cxl_memdev_foreach(ctx, memdev)
+		if (bus == cxl_memdev_get_bus(memdev))
+			active_memdevs++;
+
+	if (active_memdevs && !param.force) {
+		/*
+		 * TODO: actually detect rather than assume active just
+		 * because the memdev is enabled
+		 */
+		log_err(&bl,
+			"%s hosts %d memdev%s which %s part of an active region\n",
+			devname, active_memdevs, active_memdevs > 1 ? "s" : "",
+			active_memdevs > 1 ? "are" : "is");
+		log_err(&bl,
+			"See 'cxl list -M -b %s' to see impacted device%s\n",
+			devname, active_memdevs > 1 ? "s" : "");
+		return -EBUSY;
+	}
+
+	return cxl_bus_disable_invalidate(bus);
+}
+
+static struct cxl_bus *find_cxl_bus(struct cxl_ctx *ctx, const char *ident)
+{
+	struct cxl_bus *bus;
+
+	cxl_bus_foreach(ctx, bus)
+		if (util_cxl_bus_filter(bus, ident))
+			return bus;
+	return NULL;
+}
+
+static int bus_action(int argc, const char **argv, struct cxl_ctx *ctx,
+		      int (*action)(struct cxl_bus *bus),
+		      const struct option *options, const char *usage)
+{
+	int i, rc = 0, count = 0, err = 0;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	unsigned long id;
+
+	log_init(&bl, "cxl bus", "CXL_PORT_LOG");
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (argc == 0)
+		usage_with_options(u, options);
+	for (i = 0; i < argc; i++) {
+		if (strcmp(argv[i], "all") == 0) {
+			argv[0] = "all";
+			argc = 1;
+			break;
+		}
+
+		if (sscanf(argv[i], "root%lu", &id) == 1)
+			continue;
+		if (sscanf(argv[i], "%lu", &id) == 1)
+			continue;
+
+		log_err(&bl, "'%s' is not a valid bus identifer\n", argv[i]);
+		err++;
+	}
+
+	if (err == argc) {
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	if (param.debug) {
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+		bl.log_priority = LOG_DEBUG;
+	} else
+		bl.log_priority = LOG_INFO;
+
+	rc = 0;
+	err = 0;
+	count = 0;
+
+	for (i = 0; i < argc; i++) {
+		struct cxl_bus *bus;
+
+		bus = find_cxl_bus(ctx, argv[i]);
+		if (!bus) {
+			log_dbg(&bl, "bus: %s not found\n", argv[i]);
+			continue;
+		}
+
+		log_dbg(&bl, "run action on bus: %s\n",
+			cxl_bus_get_devname(bus));
+		rc = action(bus);
+		if (rc == 0)
+			count++;
+		else if (rc && !err)
+			err = rc;
+	}
+	rc = err;
+
+	/*
+	 * count if some actions succeeded, 0 if none were attempted,
+	 * negative error code otherwise.
+	 */
+	if (count > 0)
+		return count;
+	return rc;
+}
+
+ int cmd_disable_bus(int argc, const char **argv, struct cxl_ctx *ctx)
+ {
+	 int count = bus_action(
+		 argc, argv, ctx, action_disable, disable_options,
+		 "cxl disable-bus <bus0> [<bus1>..<busN>] [<options>]");
+
+	 log_info(&bl, "disabled %d bus%s\n", count >= 0 ? count : 0,
+		  count > 1 ? "s" : "");
+	 return count >= 0 ? 0 : EXIT_FAILURE;
+ }
diff --git a/cxl/cxl.c b/cxl/cxl.c
index ab4bbeccaa76..aa4ce61b7c87 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -69,6 +69,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-port", .c_fn = cmd_disable_port },
 	{ "enable-port", .c_fn = cmd_enable_port },
 	{ "set-partition", .c_fn = cmd_set_partition },
+	{ "disable-bus", .c_fn = cmd_disable_bus },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/filter.c b/cxl/filter.c
index b3396426dda8..c6ab9eb58124 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -176,8 +176,7 @@ util_cxl_decoder_filter_by_port(struct cxl_decoder *decoder, const char *ident,
 	return NULL;
 }
 
-static struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus,
-					   const char *__ident)
+struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident)
 {
 	char *ident, *save;
 	const char *arg;
diff --git a/cxl/filter.h b/cxl/filter.h
index 697b7779c08e..955794366d5c 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -41,6 +41,7 @@ enum cxl_port_filter_mode {
 
 struct cxl_port *util_cxl_port_filter(struct cxl_port *port, const char *ident,
 				      enum cxl_port_filter_mode mode);
+struct cxl_bus *util_cxl_bus_filter(struct cxl_bus *bus, const char *__ident);
 struct cxl_endpoint *util_cxl_endpoint_filter(struct cxl_endpoint *endpoint,
 					      const char *__ident);
 struct cxl_target *util_cxl_target_filter_by_memdev(struct cxl_target *target,
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 59e164464987..0e8dd20e3c47 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -556,6 +556,21 @@ static void bus_invalidate(struct cxl_bus *bus)
 	cxl_flush(ctx);
 }
 
+CXL_EXPORT int cxl_bus_disable_invalidate(struct cxl_bus *bus)
+{
+	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
+	struct cxl_port *port = cxl_bus_get_port(bus);
+	int rc;
+
+	rc = util_unbind(port->uport, ctx);
+	if (rc)
+		return rc;
+
+	free_bus(bus, &ctx->buses);
+	cxl_flush(ctx);
+	return 0;
+}
+
 CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
 {
 	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index aab1112a91d8..dffcb60b8dd0 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -86,6 +86,7 @@ global:
 	cxl_bus_get_id;
 	cxl_bus_get_port;
 	cxl_bus_get_ctx;
+	cxl_bus_disable_invalidate;
 	cxl_port_get_first;
 	cxl_port_get_next;
 	cxl_port_get_devname;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0063d31ab398..0007f4d9bcee 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -73,6 +73,7 @@ const char *cxl_bus_get_devname(struct cxl_bus *bus);
 int cxl_bus_get_id(struct cxl_bus *bus);
 struct cxl_port *cxl_bus_get_port(struct cxl_bus *bus);
 struct cxl_ctx *cxl_bus_get_ctx(struct cxl_bus *bus);
+int cxl_bus_disable_invalidate(struct cxl_bus *bus);
 
 #define cxl_bus_foreach(ctx, bus)                                              \
 	for (bus = cxl_bus_get_first(ctx); bus != NULL;                        \
diff --git a/cxl/meson.build b/cxl/meson.build
index 671c8e1626ef..d63dcb12eec2 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -2,6 +2,7 @@ cxl_src = [
   'cxl.c',
   'list.c',
   'port.c',
+  'bus.c',
   'memdev.c',
   'json.c',
   'filter.c',

