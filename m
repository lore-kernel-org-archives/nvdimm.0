Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0907A1A1ED1
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:33 -0700 (PDT)
Subject: [ndctl PATCH 8/8] ndctl: check-labels command
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:30 -0700
Message-ID: <147689571091.11015.20601949856550850.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Attempt to parse the namespace index block on a DIMM and return success
if it validates.

Running this command in verbose mode will report errors in the index
block.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am            |    1 +
 Documentation/ndctl-check-labels.txt |   25 +++++++++++++++++++++++++
 ndctl/builtin-dimm.c                 |   33 ++++++++++++++++++++++++++++++---
 ndctl/builtin.h                      |    1 +
 ndctl/ndctl.c                        |    1 +
 5 files changed, 58 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ndctl-check-labels.txt

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 4448064dd1b9..adcc9e7dde8e 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -3,6 +3,7 @@ man1_MANS = \
 	ndctl-zero-labels.1 \
 	ndctl-read-labels.1 \
 	ndctl-init-labels.1 \
+	ndctl-check-labels.1 \
 	ndctl-enable-region.1 \
 	ndctl-disable-region.1 \
 	ndctl-enable-dimm.1 \
diff --git a/Documentation/ndctl-check-labels.txt b/Documentation/ndctl-check-labels.txt
new file mode 100644
index 000000000000..22d219cc9afd
--- /dev/null
+++ b/Documentation/ndctl-check-labels.txt
@@ -0,0 +1,25 @@
+ndctl-check-labels(1)
+====================
+
+NAME
+----
+ndctl-check-labels - determine if the given dimms have a valid namespace index block
+
+SYNOPSIS
+--------
+[verse]
+'ndctl check-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+include::labels-description.txt[]
+In addition to checking if a label area has a valid index block, running
+this command in verbose mode reports the reason the index block is
+deemed invalid.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]
diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 399f0c32b816..304bd83a33da 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -652,7 +652,7 @@ static struct parameters {
 	bool verbose;
 } param;
 
-static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
+static int __action_init(struct ndctl_dimm *dimm, int chk_only)
 {
 	struct nvdimm_data __ndd, *ndd = &__ndd;
 	struct ndctl_cmd *cmd_read;
@@ -686,13 +686,19 @@ static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
 	 * another administrative action, the kernel will fail writes to
 	 * the label area.
 	 */
-	if (ndctl_dimm_is_active(dimm)) {
+	if (!chk_only && ndctl_dimm_is_active(dimm)) {
 		err(ndd, "regions active, abort label write\n");
 		rc = -EBUSY;
 		goto out;
 	}
 
-	if (label_validate(ndd) >= 0 && !param.force) {
+	rc = label_validate(ndd);
+	if (chk_only) {
+		rc = rc >= 0 ? 0 : -ENXIO;
+		goto out;
+	}
+
+	if (rc >= 0 && !param.force) {
 		err(ndd, "error: labels already initialized\n");
 		rc = -EBUSY;
 		goto out;
@@ -722,6 +728,17 @@ static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
+static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	return __action_init(dimm, 0);
+}
+
+static int action_check(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	return __action_init(dimm, 1);
+}
+
+
 #define BASE_OPTIONS() \
 OPT_STRING('b', "bus", &param.bus, "bus-id", \
 	"<nmem> must be on a bus with an id/provider of <bus-id>"), \
@@ -927,6 +944,16 @@ int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
+int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_check, base_options,
+			"ndctl check-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "successfully verified %d nmem%s\n",
+			count >= 0 ? count : 0, count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
 int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_disable, base_options,
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index efa90c0146ee..0293335c127e 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -21,6 +21,7 @@ int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_check_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx);
 #ifdef ENABLE_TEST
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index bdb17226f834..4f000fe51fae 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -37,6 +37,7 @@ static struct cmd_struct commands[] = {
 	{ "zero-labels", cmd_zero_labels },
 	{ "read-labels", cmd_read_labels },
 	{ "init-labels", cmd_init_labels },
+	{ "check-labels", cmd_check_labels },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
