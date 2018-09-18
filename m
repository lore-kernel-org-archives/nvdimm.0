Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3900421139F7E
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 13:12:16 -0700 (PDT)
Subject: [ndctl PATCH v2 1/3] ndctl: Introduce dirty-dimm command
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Sep 2018 13:00:22 -0700
Message-ID: <153730082229.72626.2045831989029219282.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153730081688.72626.14830966608644541641.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153730081688.72626.14830966608644541641.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Some DIMMs provide a facility to track dirty-shutdown events. The
counter only rolls forward after the OS sets a latch. This allows the
agent tracking dirty shutdowns to ignore events that occur while the
capacity has not been written. For these DIMMs dirty-dimm will trigger
the counter to roll to the next state. The shutdown state can be
retrieved with 'ndctl list -DH'

Cc: Keith Busch <keith.busch@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/Makefile.am          |    1 +
 Documentation/ndctl/ndctl-dirty-dimm.txt |   29 ++++++++++++++++++++++++++++
 builtin.h                                |    1 +
 ndctl/dimm.c                             |   31 ++++++++++++++++++++++++++++++
 ndctl/ndctl.c                            |    1 +
 5 files changed, 63 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-dirty-dimm.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a30b139ba3a3..1a826bb001be 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -38,6 +38,7 @@ man1_MANS = \
 	ndctl-disable-region.1 \
 	ndctl-enable-dimm.1 \
 	ndctl-disable-dimm.1 \
+	ndctl-dirty-dimm.1 \
 	ndctl-enable-namespace.1 \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
diff --git a/Documentation/ndctl/ndctl-dirty-dimm.txt b/Documentation/ndctl/ndctl-dirty-dimm.txt
new file mode 100644
index 000000000000..02a30fe85f53
--- /dev/null
+++ b/Documentation/ndctl/ndctl-dirty-dimm.txt
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-dirty-dimm(1)
+===================
+
+NAME
+----
+ndctl-dirty-dimm - set dimm to record the next dirty shutdown event
+
+SYNOPSIS
+--------
+[verse]
+'ndctl dirty-dimm <nmem0> [<nmem1>..<nmemN>]'
+
+Some NVDIMMs have the capability to detect 'flush failed' events whereby
+data that is pending in buffers at the time of system power loss fail to
+be flushed out to media. Some DIMMs go further to count how many times
+such fatal events occur, but only roll the count in response to a latch
+being set. The 'dirty-dimm' command sets this latch on those devices and
+is meant to be called in advance to any writes to media.
+
+OPTIONS
+-------
+<nmem>::
+include::xable-dimm-options.txt[]
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf[NVDIMM DSM Inteface]
diff --git a/builtin.h b/builtin.h
index 675a6ce79b9c..1157243cdf60 100644
--- a/builtin.h
+++ b/builtin.h
@@ -48,4 +48,5 @@ int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 int cmd_update_firmware(int argc, const char **argv, void *ctx);
 int cmd_inject_smart(int argc, const char **argv, void *ctx);
+int cmd_dirty_dimm(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index a4203f354000..32f8cb656d1d 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -61,6 +61,22 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 	return ndctl_dimm_zero_labels(dimm);
 }
 
+static int action_dirty(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	struct ndctl_cmd *cmd;
+
+	cmd = ndctl_dimm_cmd_new_ack_shutdown_count(dimm);
+	if (!cmd) {
+		fprintf(stderr, "%s: 'dirty-dimm' not supported\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EOPNOTSUPP;
+	}
+	ndctl_cmd_submit(cmd);
+	ndctl_cmd_unref(cmd);
+
+	return 0;
+}
+
 static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
 		struct ndctl_cmd *cmd_read, ssize_t size)
 {
@@ -943,6 +959,11 @@ static const struct option update_options[] = {
 	OPT_END(),
 };
 
+static const struct option dirty_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -1181,3 +1202,13 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 			count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_dirty_dimm(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_dirty, dirty_options,
+			"ndctl dirty-dimm <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "dirtied %d nmem%s.\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 73dabfac3908..93d0d88a274c 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -83,6 +83,7 @@ static struct cmd_struct commands[] = {
 	{ "write-labels", cmd_write_labels },
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
+	{ "dirty-dimm", cmd_dirty_dimm },
 	{ "inject-error", cmd_inject_error },
 	{ "update-firmware", cmd_update_firmware },
 	{ "inject-smart", cmd_inject_smart },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
