Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 431B01A1ECD
 for <linux-nvdimm@lists.01.org>; Sat,  9 Apr 2016 12:40:42 -0700 (PDT)
Subject: [ndctl PATCH 4/4] ndctl: new 'destroy-namespace' utility
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Apr 2016 12:39:51 -0700
Message-ID: <20160409193951.2002.44452.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
References: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
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

Undo a create-namespace operation.  Zero any info blocks, revoke all
claims, and unallocate the region capacity.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am                 |    1 
 Documentation/ndctl-destroy-namespace.txt |   27 +++++++++++++
 builtin-xaction-namespace.c               |   61 +++++++++++++++++++++++++----
 builtin.h                                 |    1 
 ndctl.c                                   |    3 +
 5 files changed, 84 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/ndctl-destroy-namespace.txt

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 7fb49b8e4538..470f5d003f6c 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -7,6 +7,7 @@ man1_MANS = \
 	ndctl-enable-namespace.1 \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
+	ndctl-destroy-namespace.1 \
 	ndctl-list.1
 
 CLEANFILES = $(man1_MANS)
diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl-destroy-namespace.txt
new file mode 100644
index 000000000000..623820533cec
--- /dev/null
+++ b/Documentation/ndctl-destroy-namespace.txt
@@ -0,0 +1,27 @@
+ndctl-destroy-namespace(1)
+=========================
+
+NAME
+----
+ndctl-destroy-namespace - destroy the given namespace(s)
+
+SYNOPSIS
+--------
+[verse]
+'ndctl destroy-namespace' <namespace> [<options>]
+
+include::namespace-description.txt[]
+
+OPTIONS
+-------
+include::xable-namespace-options.txt[]
+-f::
+--force::
+	Unless this option is specified the 'destroy namespace'
+	operation will fail if the namespace is presently active.
+	Specifying --force causes the namespace to be disabled before
+	the operation is attempted.
+
+SEE ALSO
+--------
+linkndctl:ndctl-create-namespace[1]
diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index d83ad91a7258..1e1cdb30f4d6 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -98,6 +98,13 @@ static const struct option base_options[] = {
 	OPT_END(),
 };
 
+static const struct option destroy_options[] = {
+	BASE_OPTIONS(),
+	OPT_BOOLEAN('f', "force", &force,
+			"destroy namespace even if currently active"),
+	OPT_END(),
+};
+
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
 	CREATE_OPTIONS(),
@@ -108,6 +115,7 @@ enum namespace_action {
 	ACTION_ENABLE,
 	ACTION_DISABLE,
 	ACTION_CREATE,
+	ACTION_DESTROY,
 };
 
 static int set_defaults(void)
@@ -493,20 +501,16 @@ static int zero_info_block(struct ndctl_namespace *ndns)
 	return rc;
 }
 
-static int namespace_reconfig(struct ndctl_region *region,
+static int namespace_destroy(struct ndctl_region *region,
 		struct ndctl_namespace *ndns)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
-	struct parsed_parameters p;
 	const char *bdev = NULL;
 	char path[50];
 	int fd, rc;
 
-	if (validate_namespace_options(ndns, &p))
-		return -EINVAL;
-
 	if (ndctl_region_get_ro(region)) {
 		error("%s: read-only, re-configuration disabled\n",
 				devname);
@@ -557,9 +561,26 @@ static int namespace_reconfig(struct ndctl_region *region,
 		return rc;
 	}
 
+	return 0;
+}
+
+static int namespace_reconfig(struct ndctl_region *region,
+		struct ndctl_namespace *ndns)
+{
+	struct parsed_parameters p;
+	int rc;
+
+	if (validate_namespace_options(ndns, &p))
+		return -EINVAL;
+
+	rc = namespace_destroy(region, ndns);
+	if (rc)
+		return rc;
+
 	ndns = ndctl_region_get_namespace_seed(region);
 	if (is_namespace_active(ndns)) {
-		debug("%s: no %s namespace seed\n", devname,
+		debug("%s: no %s namespace seed\n",
+				ndctl_region_get_devname(region),
 				ndns ? "idle" : "available");
 		return -ENODEV;
 	}
@@ -570,8 +591,8 @@ static int namespace_reconfig(struct ndctl_region *region,
 static int do_xaction_namespace(const char *namespace,
 		enum namespace_action action)
 {
+	struct ndctl_namespace *ndns, *_n;
 	int rc = -ENXIO, success = 0;
-	struct ndctl_namespace *ndns;
 	struct ndctl_region *region;
 	const char *ndns_name;
 	struct ndctl_ctx *ctx;
@@ -618,7 +639,7 @@ static int do_xaction_namespace(const char *namespace,
 					rc = 1;
 				goto done;
 			}
-			ndctl_namespace_foreach(region, ndns) {
+			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				ndns_name = ndctl_namespace_get_devname(ndns);
 
 				if (strcmp(namespace, "all") != 0
@@ -631,6 +652,9 @@ static int do_xaction_namespace(const char *namespace,
 				case ACTION_ENABLE:
 					rc = ndctl_namespace_enable(ndns);
 					break;
+				case ACTION_DESTROY:
+					rc = namespace_destroy(region, ndns);
+					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
@@ -721,3 +745,24 @@ int cmd_create_namespace(int argc, const char **argv)
 		return created;
 	return 0;
 }
+
+int cmd_destroy_namespace(int argc , const char **argv)
+{
+	char *xable_usage = "ndctl destroy-namespace <namespace> [<options>]";
+	const char *namespace = parse_namespace_options(argc, argv,
+			ACTION_DESTROY, destroy_options, xable_usage);
+	int destroyed = do_xaction_namespace(namespace, ACTION_DESTROY);
+
+	if (destroyed < 0) {
+		fprintf(stderr, "error destroying namespaces: %s\n",
+				strerror(-destroyed));
+		return destroyed;
+	} else if (destroyed == 0) {
+		fprintf(stderr, "destroyed 0 namespaces\n");
+		return 0;
+	} else {
+		fprintf(stderr, "destroyed %d namespace%s\n", destroyed,
+				destroyed > 1 ? "s" : "");
+		return 0;
+	}
+}
diff --git a/builtin.h b/builtin.h
index 9c207552b254..53ec25b8a76a 100644
--- a/builtin.h
+++ b/builtin.h
@@ -11,6 +11,7 @@ struct cmd_struct {
 int cmd_create_nfit(int argc, const char **argv);
 int cmd_enable_namespace(int argc, const char **argv);
 int cmd_create_namespace(int argc, const char **argv);
+int cmd_destroy_namespace(int argc, const char **argv);
 int cmd_disable_namespace(int argc, const char **argv);
 int cmd_enable_region(int argc, const char **argv);
 int cmd_disable_region(int argc, const char **argv);
diff --git a/ndctl.c b/ndctl.c
index bed194979cc0..6db1b2ffa0c0 100644
--- a/ndctl.c
+++ b/ndctl.c
@@ -26,8 +26,9 @@ static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "create-nfit", cmd_create_nfit },
 	{ "enable-namespace", cmd_enable_namespace },
-	{ "create-namespace", cmd_create_namespace },
 	{ "disable-namespace", cmd_disable_namespace },
+	{ "create-namespace", cmd_create_namespace },
+	{ "destroy-namespace", cmd_destroy_namespace },
 	{ "enable-region", cmd_enable_region },
 	{ "disable-region", cmd_disable_region },
 	{ "zero-labels", cmd_zero_labels },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
