Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 44FDD1A1E2F
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:17:57 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: provide a method to invalidate the bus list
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:16:53 -0700
Message-ID: <20160324011653.20651.27454.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Consider the following scenario:

    ndctl_new()
    ndctl_bus_foreach()
    <install a new nvdimm-bus provider>
    ndctl_bus_foreach()

...the second ndctl_bus_foreach() will not see any new buses because the
bus results are cached.  When the holder of the context knows that it
has invalidated the bus list it needs to call ndctl_invalidate() so that
subsequent ndctl_bus_foreach() scans are guaranteed to see new buses.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c          |   22 ++++++++++++++++++----
 lib/libndctl.sym        |    1 +
 lib/ndctl/libndctl.h.in |    1 +
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index 6728508024b0..b628243df651 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -584,7 +584,7 @@ static void free_region(struct ndctl_region *region)
 	free(region);
 }
 
-static void free_bus(struct ndctl_bus *bus)
+static void free_bus(struct ndctl_bus *bus, struct list_head *head)
 {
 	struct ndctl_dimm *dimm, *_d;
 	struct ndctl_region *region, *_r;
@@ -598,7 +598,8 @@ static void free_bus(struct ndctl_bus *bus)
 	}
 	list_for_each_safe(&bus->regions, region, _r, list)
 		free_region(region);
-	list_del_from(&bus->ctx->busses, &bus->list);
+	if (head)
+		list_del_from(head, &bus->list);
 	free(bus->provider);
 	free(bus->bus_path);
 	free(bus->bus_buf);
@@ -611,7 +612,7 @@ static void free_context(struct ndctl_ctx *ctx)
 	struct ndctl_bus *bus, *_b;
 
 	list_for_each_safe(&ctx->busses, bus, _b, list)
-		free_bus(bus);
+		free_bus(bus, &ctx->busses);
 	free(ctx);
 }
 
@@ -869,9 +870,9 @@ static void parse_nfit_mem_flags(struct ndctl_dimm *dimm, char *flags)
 static int add_bus(void *parent, int id, const char *ctl_base)
 {
 	int rc = -ENOMEM;
-	struct ndctl_bus *bus;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_ctx *ctx = parent;
+	struct ndctl_bus *bus, *bus_dup;
 	char *path = calloc(1, strlen(ctl_base) + 100);
 
 	if (!path)
@@ -928,6 +929,14 @@ static int add_bus(void *parent, int id, const char *ctl_base)
 		goto err_read;
 	bus->buf_len = strlen(bus->bus_path) + 50;
 
+	ndctl_bus_foreach(ctx, bus_dup)
+		if (strcmp(ndctl_bus_get_provider(bus_dup),
+					ndctl_bus_get_provider(bus)) == 0) {
+			free_bus(bus, NULL);
+			free(path);
+			return 1;
+		}
+
 	list_add(&ctx->busses, &bus->list);
 
 	rc = 0;
@@ -954,6 +963,11 @@ static void busses_init(struct ndctl_ctx *ctx)
 	device_parse(ctx, NULL, "/sys/class/nd", "ndctl", ctx, add_bus);
 }
 
+NDCTL_EXPORT void ndctl_invalidate(struct ndctl_ctx *ctx)
+{
+	ctx->busses_init = 0;
+}
+
 /**
  * ndctl_bus_get_first - retrieve first "nd bus" in the system
  * @ctx: context established by ndctl_new
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 25d7b982ecb1..9df2b5a6e89d 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -11,6 +11,7 @@ global:
 	ndctl_unref;
 	ndctl_set_log_priority;
 	ndctl_new;
+	ndctl_invalidate;
 local:
         *;
 };
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index b16f26dae535..831f7822e91f 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -77,6 +77,7 @@ struct ndctl_ctx;
 struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx);
 struct ndctl_ctx *ndctl_unref(struct ndctl_ctx *ctx);
 int ndctl_new(struct ndctl_ctx **ctx);
+void ndctl_invalidate(struct ndctl_ctx *ctx);
 void ndctl_set_log_fn(struct ndctl_ctx *ctx,
                   void (*log_fn)(struct ndctl_ctx *ctx,
                                  int priority, const char *file, int line, const char *fn,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
