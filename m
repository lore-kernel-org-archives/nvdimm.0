Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C26422035D6C8
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 11:00:35 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/4] ndctl, inject-error: add a --saturate option
Date: Tue,  1 May 2018 12:00:23 -0600
Message-Id: <20180501180023.30193-5-vishal.l.verma@intel.com>
In-Reply-To: <20180501180023.30193-1-vishal.l.verma@intel.com>
References: <20180501180023.30193-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that error injection by default injects fewer bytes per block,
provide an option to allow it to behave in the old way, i.e. injecting
the entire block.

The downside of these reworks is that where as the old way injected the
entire address range in one command, this now issues an ndctl command
per block, which can be slower. However, since this command is only for
testing and debugging purposes, it is expected that the user will
perform targeted, small injections rather than expansive ones at a time,
so the one-DSM-per-block change shouldn't be a noticeable hit. If this
changes in the future, we can consider adding an optimization for the
--saturate path.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/ndctl-inject-error.txt |  7 +++++++
 ndctl/inject-error.c                       |  7 ++++++-
 ndctl/lib/inject.c                         | 16 ++++++++++------
 ndctl/libndctl.h                           |  1 +
 4 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/Documentation/ndctl/ndctl-inject-error.txt b/Documentation/ndctl/ndctl-inject-error.txt
index 07c992a..744ea50 100644
--- a/Documentation/ndctl/ndctl-inject-error.txt
+++ b/Documentation/ndctl/ndctl-inject-error.txt
@@ -24,6 +24,8 @@ In other words, we only inject one 'ars_unit' per sector. This is sufficient
 for Linux to mark the whole sector as bad, and will show up as such in the
 various 'badblocks' lists in the kernel. If multiple blocks are being injected,
 only the first 'n' bytes of each block specified will be injected as errors.
+This can be overridden by the --saturate option, which will force the entire
+block to be injected as an error.
 
 WARNING: These commands are DANGEROUS and can cause data loss. They are
 only provided for testing and debugging purposes.
@@ -95,6 +97,11 @@ OPTIONS
 	when the location is accessed. If the platform firmware does not
 	support this feature, this will have no effect.
 
+-S::
+--saturate::
+	This option forces error injection or un-injection to cover the entire
+	address range covered by the specified block(s).
+
 -v::
 --verbose::
 	Emit debug messages for the error injection process
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index e977136..2b2fec0 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -47,6 +47,7 @@ static struct parameters {
 	bool clear;
 	bool status;
 	bool no_notify;
+	bool saturate;
 	bool human;
 } param;
 
@@ -74,6 +75,8 @@ OPT_BOOLEAN('d', "uninject", &param.clear, \
 	"un-inject a previously injected error"), \
 OPT_BOOLEAN('t', "status", &param.status, "get error injection status"), \
 OPT_BOOLEAN('N', "no-notify", &param.no_notify, "firmware should not notify OS"), \
+OPT_BOOLEAN('S', "saturate", &param.saturate, \
+	"inject full sector, not just 'ars_unit' bytes"), \
 OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
 
 static const struct option inject_options[] = {
@@ -104,7 +107,7 @@ static int inject_init(void)
 		ictx.op_mask |= 1 << OP_CLEAR;
 	}
 	if (param.status) {
-		if (param.block || param.count) {
+		if (param.block || param.count || param.saturate) {
 			error("status is invalid with inject or uninject\n");
 			return -EINVAL;
 		}
@@ -145,6 +148,8 @@ static int inject_init(void)
 
 	if (param.human)
 		ictx.json_flags |= UTIL_JSON_HUMAN;
+	if (param.saturate)
+		ictx.inject_flags |= 1 << NDCTL_NS_INJECT_SATURATE;
 
 	return 0;
 }
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 5cffe53..848f8a9 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -135,9 +135,11 @@ static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
 	if (clear_unit < 0)
 		return clear_unit;
 
-	/* clamp injection length per block to the clear_unit */
-	if (length > (unsigned int)clear_unit)
-		length = clear_unit;
+	if (!(flags & (1 << NDCTL_NS_INJECT_SATURATE))) {
+		/* clamp injection length per block to the clear_unit */
+		if (length > (unsigned int)clear_unit)
+			length = clear_unit;
+	}
 
 	cmd = ndctl_bus_cmd_new_err_inj(bus);
 	if (!cmd)
@@ -213,9 +215,11 @@ static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
 	if (clear_unit < 0)
 		return clear_unit;
 
-	/* clamp injection length per block to the clear_unit */
-	if (length > (unsigned int)clear_unit)
-		length = clear_unit;
+	if (!(flags & (1 << NDCTL_NS_INJECT_SATURATE))) {
+		/* clamp injection length per block to the clear_unit */
+		if (length > (unsigned int)clear_unit)
+			length = clear_unit;
+	}
 
 	cmd = ndctl_bus_cmd_new_err_inj_clr(bus);
 	if (!cmd)
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index a001271..be997ac 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -490,6 +490,7 @@ int ndctl_namespace_uninject_error2(struct ndctl_namespace *ndns,
 int ndctl_namespace_injection_status(struct ndctl_namespace *ndns);
 enum ndctl_namespace_inject_flags {
 	NDCTL_NS_INJECT_NOTIFY = 0,
+	NDCTL_NS_INJECT_SATURATE,
 };
 
 struct ndctl_bb;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
