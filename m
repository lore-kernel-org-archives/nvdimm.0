Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B2E0211F35D4
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 18:35:22 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: add a 'clear-errors' command
Date: Thu, 11 Apr 2019 19:35:15 -0600
Message-Id: <20190412013515.31330-1-vishal.l.verma@intel.com>
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

Add a nre command, ndctl-clear-errors, to clear any errors (badblocks)
on a namespace. This is in preparation for a 'system-ram' mode for
devdax devices using the kernel's 'kmem' facility. Since the device is
being used as volatile RAM, we can take the opportunity to clear any
badblocks on the device before reconfiguration, so that the user doesn't
come across one unexpectedly.

Make this error clearing facility generic to all namespace types (i.e.
devdax, fsdax, and raw; sector mode namespaces are not supported). To
clear errors, use the "Clear Uncorrectable Errors" ACPI DSM command via
the helpers provided by libndctl.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/ndctl/Makefile.am            |   1 +
 Documentation/ndctl/ndctl-clear-errors.txt | 106 ++++++++
 contrib/ndctl                              |   3 +
 ndctl/action.h                             |   1 +
 ndctl/builtin.h                            |   1 +
 ndctl/namespace.c                          | 279 +++++++++++++++++++++
 ndctl/ndctl.c                              |   1 +
 7 files changed, 392 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-clear-errors.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index 2593dbd..fb46d7c 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -43,6 +43,7 @@ man1_MANS = \
 	ndctl-create-namespace.1 \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
+	ndctl-clear-errors.1 \
 	ndctl-inject-error.1 \
 	ndctl-inject-smart.1 \
 	ndctl-update-firmware.1 \
diff --git a/Documentation/ndctl/ndctl-clear-errors.txt b/Documentation/ndctl/ndctl-clear-errors.txt
new file mode 100644
index 0000000..206ab58
--- /dev/null
+++ b/Documentation/ndctl/ndctl-clear-errors.txt
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-clear-errors(1)
+=====================
+
+NAME
+----
+ndctl-clear-errors - clear all errors (badblocks) on the given namespace
+
+SYNOPSIS
+--------
+[verse]
+'ndctl clear-errors' <namespace> [<options>]
+
+DESCRIPTION
+-----------
+
+A namespace may have one or more 'media errors', either known to the kernel
+or in a latent state. These error locations, or 'badblocks' can cause poison
+consumption events if read in an unsafe manner.
+
+Moreover, these badblocks also indicate that due to media corruption, any data
+that may have been in these locations has been unrecoverably lost.
+
+Normally, in the presence of such errors, the administrator is expected to
+recover the data from out of band means (such as backups), destroy the
+namespace, recreate it, and then restore the data. When the data is re-written,
+the writes will allow any errors to be cleared as they are encountered. In such
+a workflow, one should *never* need to use the 'clear-errors' command.
+
+However, there may be special use cases, where the data currently on the
+namespace does not matter - for example, if a 'devdax' mode namespace is being
+prepared for use as 'system-ram'. In such cases, it may be desirable to clear
+any errors on the namespace prior to switching its mode to prevent disruptive
+machine checks due to poison consumption.
+
+NOTE: *Only* use this command when the data on the namespace is immaterial.
+For any blocks that are cleared via this command, any data on the blocks in
+question will be lost, and replaced with content that is implementation
+(platform) defined, and unpredictable.
+
+WARNING: This is a DANGEROUS command, and should only be used after fully
+understanding its implications and consequences. This WILL erase your data.
+
+For namespaces in one of 'fsdax' or 'davdax' modes, this command will
+only consider the 'data' area for error clearing. Namespace metadata, such as
+info-blocks, will not be touched. For namespaces in 'raw' mode, the full
+available capacity of the namespace is considered for error clearing.
+Namespaces that are in 'sector' mode are not supported, and will be skipped.
+
+NOTE: It is expected that the command is run with the namespace 'enabled'.
+A namespace in the 'disabled' state will appear as, and will be treated as a
+'raw' namespace, and error clearing will be performed for the full available
+capacity of the namespace, including any potential metadata areas. If there
+happen to be errors in the metadata area, clearing them may result in
+unpredictable outcomes. You have been warned!
+
+Known errors are ones that the kernel has encountered before, either via a
+previous scrub, or by an attempted read from those locations. These can be
+listed by running 'ndctl list --media-errors' for a given namespace. Latent
+errors, as the name indicates, are unknown to the kernel. These can be found
+by running a scrub operation on the NVDIMMs in question. By default, the
+ndctl-clear-errors command only clears known errors. This can be overridden
+using the '--scrub' option to clear *all* errors.
+
+NOTE: If a scrub is in progress when the command is called, it will
+unconditionally wait for it to complete.
+
+EXAMPLES
+--------
+
+Clear errors on namespace 0.0
+[verse]
+    ndctl clear-errors namespace0.0
+
+Clear errors on all namespaces belonging to region1, including scrubbing for
+latent errors
+[verse]
+    ndctl clear-errors --scrub --region=region1 all
+
+OPTIONS
+-------
+
+-s::
+--scrub::
+	Perform a 'scrub' on the bus prior to clearing errors. This allows
+	for the clearing of any latent media errors in addition to errors
+	the kernel already knows about.
+
+NOTE: This will cause the command to start and wait for a full scrub, and this
+can potentially be a very long-running operation.
+
+-v::
+--verbose::
+	Emit debug messages.
+
+-r::
+--region=::
+include::xable-region-options.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-start-scrub[1],
+linkndctl:ndctl-list[1]
diff --git a/contrib/ndctl b/contrib/ndctl
index e17fb0b..396a344 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -328,6 +328,9 @@ __ndctl_comp_non_option_args()
 	check-namespace)
 		opts="$(__ndctl_get_ns -i) all"
 		;;
+	clear-errors)
+		opts="$(__ndctl_get_ns) all"
+		;;
 	enable-region)
 		opts="$(__ndctl_get_regions -i) all"
 		;;
diff --git a/ndctl/action.h b/ndctl/action.h
index 1ecad49..50da010 100644
--- a/ndctl/action.h
+++ b/ndctl/action.h
@@ -13,5 +13,6 @@ enum device_action {
 	ACTION_CHECK,
 	ACTION_WAIT,
 	ACTION_START,
+	ACTION_CLEAR,
 };
 #endif /* __NDCTL_ACTION_H__ */
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 681a69f..94ab317 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -10,6 +10,7 @@ int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_check_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_clear_errors(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 03d805a..c7abcbf 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -36,6 +36,7 @@ static bool verbose;
 static bool force;
 static bool repair;
 static bool logfix;
+static bool scrub;
 static struct parameters {
 	bool do_scan;
 	bool mode_default;
@@ -120,6 +121,9 @@ OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
 OPT_BOOLEAN('L', "rewrite-log", &logfix, "regenerate the log"), \
 OPT_BOOLEAN('f', "force", &force, "check namespace even if currently active")
 
+#define CLEAR_OPTIONS() \
+OPT_BOOLEAN('s', "scrub", &scrub, "run a scrub to find latent errors")
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -144,6 +148,12 @@ static const struct option check_options[] = {
 	OPT_END(),
 };
 
+static const struct option clear_options[] = {
+	BASE_OPTIONS(),
+	CLEAR_OPTIONS(),
+	OPT_END(),
+};
+
 static int set_defaults(enum device_action mode)
 {
 	int rc = 0;
@@ -285,6 +295,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
 			case ACTION_CHECK:
 				action_string = "check";
 				break;
+			case ACTION_CLEAR:
+				action_string = "clear errors for";
+				break;
 			default:
 				action_string = "<>";
 				break;
@@ -1051,6 +1064,251 @@ static int namespace_reconfig(struct ndctl_region *region,
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair, bool logfix);
 
+static int bus_send_clear(struct ndctl_bus *bus, unsigned long long start,
+		unsigned long long size)
+{
+	const char *busname = ndctl_bus_get_provider(bus);
+	struct ndctl_cmd *cmd_cap, *cmd_clear;
+	unsigned long long cleared;
+	struct ndctl_range range;
+	int rc;
+
+	/* get ars_cap */
+	cmd_cap = ndctl_bus_cmd_new_ars_cap(bus, start, size);
+	if (!cmd_cap) {
+		debug("bus: %s failed to create cmd\n", busname);
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit_xlat(cmd_cap);
+	if (rc < 0) {
+		debug("bus: %s failed to submit cmd: %d\n", busname, rc);
+		ndctl_cmd_unref(cmd_cap);
+		return rc;
+	}
+
+	/* send clear_error */
+	if (ndctl_cmd_ars_cap_get_range(cmd_cap, &range)) {
+		debug("bus: %s failed to get ars_cap range\n", busname);
+		return -ENXIO;
+	}
+
+	cmd_clear = ndctl_bus_cmd_new_clear_error(range.address,
+					range.length, cmd_cap);
+	if (!cmd_clear) {
+		debug("bus: %s failed to create cmd\n", busname);
+		return -ENOTTY;
+	}
+
+	rc = ndctl_cmd_submit_xlat(cmd_clear);
+	if (rc < 0) {
+		debug("bus: %s failed to submit cmd: %d\n", busname, rc);
+		ndctl_cmd_unref(cmd_clear);
+		return rc;
+	}
+
+	cleared = ndctl_cmd_clear_error_get_cleared(cmd_clear);
+	if (cleared != range.length) {
+		debug("bus: %s expected to clear: %lld actual: %lld\n",
+				busname, range.length, cleared);
+		return -ENXIO;
+	}
+
+	ndctl_cmd_unref(cmd_cap);
+	ndctl_cmd_unref(cmd_clear);
+	return 0;
+}
+
+static int nstype_clear_badblocks(struct ndctl_namespace *ndns,
+		const char *devname, unsigned long long dev_begin,
+		unsigned long long dev_size)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndctl_bus *bus = ndctl_region_get_bus(region);
+	unsigned long long region_begin, dev_end;
+	unsigned int cleared = 0;
+	struct badblock *bb;
+	int rc = 0;
+
+	region_begin = ndctl_region_get_resource(region);
+	if (region_begin == ULLONG_MAX) {
+		ndctl_namespace_enable(ndns);
+		return -errno;
+	}
+
+	dev_end = dev_begin + dev_size - 1;
+
+	ndctl_region_badblock_foreach(region, bb) {
+		unsigned long long bb_begin, bb_end, bb_len;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_len = bb->len << 9;
+		bb_end = bb_begin + bb_len - 1;
+
+		/* bb is not fully contained in the usable area */
+		if (bb_begin < dev_begin || bb_end > dev_end)
+			continue;
+
+		rc = bus_send_clear(bus, bb_begin, bb_len);
+		if (rc) {
+			error("%s: failed to clear badblock at {%lld, %u}\n",
+				devname, bb->offset, bb->len);
+			break;
+		}
+		cleared += bb->len;
+	}
+	debug("%s: cleared %u badblocks\n", devname, cleared);
+
+	rc = ndctl_namespace_enable(ndns);
+	if (rc < 0)
+		return rc;
+	return 0;
+}
+
+static int dax_clear_badblocks(struct ndctl_dax *dax)
+{
+	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
+	const char *devname = ndctl_dax_get_devname(dax);
+	unsigned long long begin, size;
+	int rc;
+
+	begin = ndctl_dax_get_resource(dax);
+	if (begin == ULLONG_MAX)
+		return -ENXIO;
+
+	size = ndctl_dax_get_size(dax);
+	if (size == ULLONG_MAX)
+		return -ENXIO;
+
+	rc = ndctl_namespace_disable_safe(ndns);
+	if (rc) {
+		error("%s: unable to disable namespace: %s\n", devname,
+			strerror(-rc));
+		return rc;
+	}
+	return nstype_clear_badblocks(ndns, devname, begin, size);
+}
+
+static int pfn_clear_badblocks(struct ndctl_pfn *pfn)
+{
+	struct ndctl_namespace *ndns = ndctl_pfn_get_namespace(pfn);
+	const char *devname = ndctl_pfn_get_devname(pfn);
+	unsigned long long begin, size;
+	int rc;
+
+	begin = ndctl_pfn_get_resource(pfn);
+	if (begin == ULLONG_MAX)
+		return -ENXIO;
+
+	size = ndctl_pfn_get_size(pfn);
+	if (size == ULLONG_MAX)
+		return -ENXIO;
+
+	rc = ndctl_namespace_disable_safe(ndns);
+	if (rc) {
+		error("%s: unable to disable namespace: %s\n", devname,
+			strerror(-rc));
+		return rc;
+	}
+	return nstype_clear_badblocks(ndns, devname, begin, size);
+}
+
+static int raw_clear_badblocks(struct ndctl_namespace *ndns)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	unsigned long long begin, size;
+	int rc;
+
+	begin = ndctl_namespace_get_resource(ndns);
+	if (begin == ULLONG_MAX)
+		return -ENXIO;
+
+	size = ndctl_namespace_get_size(ndns);
+	if (size == ULLONG_MAX)
+		return -ENXIO;
+
+	rc = ndctl_namespace_disable_safe(ndns);
+	if (rc) {
+		error("%s: unable to disable namespace: %s\n", devname,
+			strerror(-rc));
+		return rc;
+	}
+	return nstype_clear_badblocks(ndns, devname, begin, size);
+}
+
+static int namespace_wait_scrub(struct ndctl_namespace *ndns)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_bus *bus = ndctl_namespace_get_bus(ndns);
+	int in_progress, rc;
+
+	in_progress = ndctl_bus_get_scrub_state(bus);
+	if (in_progress < 0) {
+		error("%s: Unable to determine scrub state: %s\n", devname,
+				strerror(-in_progress));
+		return in_progress;
+	}
+
+	/* start a scrub if asked and if one isn't in progress */
+	if (scrub && (!in_progress)) {
+		rc = ndctl_bus_start_scrub(bus);
+		if (rc) {
+			error("%s: Unable to start scrub: %s\n", devname,
+					strerror(-rc));
+			return rc;
+		}
+	}
+
+	/*
+	 * wait for any in-progress scrub, whether started above, or
+	 * started automatically at boot time
+	 */
+	rc = ndctl_bus_wait_for_scrub_completion(bus);
+	if (rc) {
+		error("%s: Error waiting for scrub: %s\n", devname,
+				strerror(-rc));
+		return rc;
+	}
+
+	return 0;
+}
+
+static int namespace_clear_bb(struct ndctl_namespace *ndns)
+{
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
+	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	struct json_object *jndns;
+	int rc;
+
+	if (btt) {
+		/* skip btt error clearing for now */
+		debug("%s: skip error clearing for btt\n",
+				ndctl_btt_get_devname(btt));
+		return 1;
+	}
+
+	rc = namespace_wait_scrub(ndns);
+	if (rc)
+		return rc;
+
+	if (dax)
+		rc = dax_clear_badblocks(dax);
+	else if (pfn)
+		rc = pfn_clear_badblocks(pfn);
+	else
+		rc = raw_clear_badblocks(ndns);
+
+	if (rc)
+		return rc;
+
+	jndns = util_namespace_to_json(ndns, UTIL_JSON_MEDIA_ERRORS);
+	if (jndns)
+		printf("%s\n", json_object_to_json_string_ext(jndns,
+				JSON_C_TO_STRING_PRETTY));
+	return 0;
+}
+
 static int do_xaction_namespace(const char *namespace,
 		enum device_action action, struct ndctl_ctx *ctx,
 		int *processed)
@@ -1131,6 +1389,11 @@ static int do_xaction_namespace(const char *namespace,
 					if (rc == 0)
 						(*processed)++;
 					break;
+				case ACTION_CLEAR:
+					rc = namespace_clear_bb(ndns);
+					if (rc == 0)
+						(*processed)++;
+					break;
 				case ACTION_CREATE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc == 0)
@@ -1240,3 +1503,19 @@ int cmd_check_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
 			checked == 1 ? "" : "s");
 	return rc;
 }
+
+int cmd_clear_errors(int argc , const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl clear_errors <namespace> [<options>]";
+	const char *namespace = parse_namespace_options(argc, argv,
+			ACTION_CLEAR, clear_options, xable_usage);
+	int cleared, rc;
+
+	rc = do_xaction_namespace(namespace, ACTION_CLEAR, ctx, &cleared);
+	if (rc < 0)
+		fprintf(stderr, "error clearing namespaces: %s\n",
+				strerror(-rc));
+	fprintf(stderr, "cleared %d namespace%s\n", cleared,
+			cleared == 1 ? "" : "s");
+	return rc;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index bd333b2..6c4975c 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -74,6 +74,7 @@ static struct cmd_struct commands[] = {
 	{ "create-namespace", { cmd_create_namespace } },
 	{ "destroy-namespace", { cmd_destroy_namespace } },
 	{ "check-namespace", { cmd_check_namespace } },
+	{ "clear-errors", { cmd_clear_errors } },
 	{ "enable-region", { cmd_enable_region } },
 	{ "disable-region", { cmd_disable_region } },
 	{ "enable-dimm", { cmd_enable_dimm } },
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
