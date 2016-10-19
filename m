Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 160541A1E8B
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:28 -0700 (PDT)
Subject: [ndctl PATCH 7/8] ndctl: init-labels command
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:25 -0700
Message-ID: <147689570571.11015.12725297070022330640.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: qemu-devel@nongnu.org
List-ID: <linux-nvdimm@lists.01.org>

For environments like QEMU that have label support, but do not have
aliased BLK capacity the kernel by default will ignore labels and
produce a namespace that matches the boundaries defined in the NFIT.
Kernels starting with v4.10 enabled pmem-subdivision support to be
enabled if the DIMM has a valid namespace label index block.

The 'ndctl init-labels' command writes an empty namespace label index
block to convert the pmem region to labelled mode, or otherwise repair a
label area.

Cc: <qemu-devel@nongnu.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/Makefile.am           |    1 
 Documentation/ndctl-init-labels.txt |   83 +++++++
 ndctl/builtin-dimm.c                |  395 +++++++++++++++++++++++++++++++++++
 ndctl/builtin.h                     |    1 
 ndctl/ndctl.c                       |    1 
 5 files changed, 479 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ndctl-init-labels.txt

diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
index 63ef1ce7f2d7..4448064dd1b9 100644
--- a/Documentation/Makefile.am
+++ b/Documentation/Makefile.am
@@ -2,6 +2,7 @@ man1_MANS = \
 	ndctl.1 \
 	ndctl-zero-labels.1 \
 	ndctl-read-labels.1 \
+	ndctl-init-labels.1 \
 	ndctl-enable-region.1 \
 	ndctl-disable-region.1 \
 	ndctl-enable-dimm.1 \
diff --git a/Documentation/ndctl-init-labels.txt b/Documentation/ndctl-init-labels.txt
new file mode 100644
index 000000000000..c01f31b0532a
--- /dev/null
+++ b/Documentation/ndctl-init-labels.txt
@@ -0,0 +1,83 @@
+ndctl-init-labels(1)
+====================
+
+NAME
+----
+ndctl-init-labels - initialize the label data area on a dimm or set of dimms
+
+SYNOPSIS
+--------
+[verse]
+'ndctl init-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+include::labels-description.txt[]
+By default, and in kernels prior to v4.10, the kernel only honors labels
+when a DIMM aliases PMEM and BLK capacity. Starting with v4.10 the
+kernel will honor labels for sub-dividing PMEM if all the DIMMs in an
+interleave set / region have a valid namespace index block.
+
+This command can be used to initialize the namespace index block if it
+is missing or reinitialize it if it is damaged.  Note that
+reinitialization effectively destroys all existing namespace labels on
+the DIMM.
+
+EXAMPLE
+-------
+Find the DIMMs that comprise a given region:
+[verse]
+# ndctl list -RD --region=region1
+{
+  "dimms":[
+    {
+      "dev":"nmem0",
+      "id":"8680-56341200"
+    }
+  ],
+  "regions":[
+    {
+      "dev":"region1",
+      "size":268435456,
+      "available_size":0,
+      "type":"pmem",
+      "mappings":[
+        {
+          "dimm":"nmem0",
+          "offset":13958643712,
+          "length":268435456
+        }
+      ]
+    }
+  ]
+}
+
+Disable that region so the DIMM label area can be written from
+userspace:
+[verse]
+# ndctl disable-region region1
+
+Initialize labels:
+[verse]
+# ndctl init-labels nmem0
+
+Re-enable the region:
+[verse]
+# ndctl enable-region region1
+
+Create a namespace in that region:
+[verse]
+# ndctl create-namespace --region=region1
+
+OPTIONS
+-------
+include::labels-options.txt[]
+-o::
+	output file
+-f::
+--force::
+	parse the label data into json assuming the 'NVDIMM Namespace
+	Specification' format.
+
+SEE ALSO
+--------
+http://pmem.io/documents/NVDIMM_Namespace_Spec.pdf[NVDIMM Namespace
+Specification]
diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 34ad1d9b47e7..399f0c32b816 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -17,14 +17,15 @@
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+#include <util/log.h>
 #include <uuid/uuid.h>
-#include <util/filter.h>
 #include <util/json.h>
+#include <util/filter.h>
 #include <json-c/json.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
-#define CCAN_SHORT_TYPES_H
+#include <ccan/short_types/short_types.h>
 #include <ccan/endian/endian.h>
 #include <ccan/array_size/array_size.h>
 
@@ -65,6 +66,8 @@ struct namespace_label {
 	le32 unused;
 };
 
+static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
+
 struct action_context {
 	struct json_object *jdimms;
 	FILE *f_out;
@@ -344,13 +347,381 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
+struct nvdimm_data {
+	struct ndctl_dimm *dimm;
+	struct ndctl_cmd *cmd_read;
+	unsigned long config_size;
+	struct log_ctx ctx;
+	void *data;
+	int nsindex_size;
+	int ns_current, ns_next;
+};
+
+/*
+ * Note, best_seq(), inc_seq(), fletcher64(), sizeof_namespace_index()
+ * nvdimm_num_label_slots(), label_validate(), and label_write_index()
+ * are copied from drivers/nvdimm/label.c in the Linux kernel with the
+ * following modifications:
+ * 1/ s,nd_,,gc
+ * 2/ s,ndd->nsarea.config_size,ndd->config_size,gc
+ * 3/ s,dev_dbg(dev,dbg(ndd,gc
+ * 4/ s,__le,le,gc
+ * 5/ s,__cpu_to,cpu_to,gc
+ * 6/ remove flags argument to label_write_index
+ * 7/ dropped clear_bit_le() usage in label_write_index
+ */
+
+static u64 fletcher64(void *addr, size_t len, bool le)
+{
+	u32 *buf = addr;
+	u32 lo32 = 0;
+	u64 hi32 = 0;
+	size_t i;
+
+	for (i = 0; i < len / sizeof(u32); i++) {
+		lo32 += le ? le32_to_cpu((le32) buf[i]) : buf[i];
+		hi32 += lo32;
+	}
+
+	return hi32 << 32 | lo32;
+}
+
+static unsigned inc_seq(unsigned seq)
+{
+	static const unsigned next[] = { 0, 2, 3, 1 };
+
+	return next[seq & 3];
+}
+
+static u32 best_seq(u32 a, u32 b)
+{
+	a &= NSINDEX_SEQ_MASK;
+	b &= NSINDEX_SEQ_MASK;
+
+	if (a == 0 || a == b)
+		return b;
+	else if (b == 0)
+		return a;
+	else if (inc_seq(a) == b)
+		return b;
+	else
+		return a;
+}
+
+static size_t sizeof_namespace_index(struct nvdimm_data *ndd)
+{
+	u32 index_span;
+
+	if (ndd->nsindex_size)
+		return ndd->nsindex_size;
+
+	/*
+	 * The minimum index space is 512 bytes, with that amount of
+	 * index we can describe ~1400 labels which is less than a byte
+	 * of overhead per label.  Round up to a byte of overhead per
+	 * label and determine the size of the index region.  Yes, this
+	 * starts to waste space at larger config_sizes, but it's
+	 * unlikely we'll ever see anything but 128K.
+	 */
+	index_span = ndd->config_size / 129;
+	index_span /= NSINDEX_ALIGN * 2;
+	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
+
+	return ndd->nsindex_size;
+}
+
+static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
+{
+	return ndd->config_size / 129;
+}
+
+static struct namespace_index *to_namespace_index(struct nvdimm_data *ndd,
+		int i)
+{
+	char *index;
+
+	if (i < 0)
+		return NULL;
+
+	index = (char *) ndd->data + sizeof_namespace_index(ndd) * i;
+	return (struct namespace_index *) index;
+}
+
+static int label_validate(struct nvdimm_data *ndd)
+{
+	/*
+	 * On media label format consists of two index blocks followed
+	 * by an array of labels.  None of these structures are ever
+	 * updated in place.  A sequence number tracks the current
+	 * active index and the next one to write, while labels are
+	 * written to free slots.
+	 *
+	 *     +------------+
+	 *     |            |
+	 *     |  nsindex0  |
+	 *     |            |
+	 *     +------------+
+	 *     |            |
+	 *     |  nsindex1  |
+	 *     |            |
+	 *     +------------+
+	 *     |   label0   |
+	 *     +------------+
+	 *     |   label1   |
+	 *     +------------+
+	 *     |            |
+	 *      ....nslot...
+	 *     |            |
+	 *     +------------+
+	 *     |   labelN   |
+	 *     +------------+
+	 */
+	struct namespace_index *nsindex[] = {
+		to_namespace_index(ndd, 0),
+		to_namespace_index(ndd, 1),
+	};
+	const int num_index = ARRAY_SIZE(nsindex);
+	bool valid[2] = { 0 };
+	int i, num_valid = 0;
+	u32 seq;
+
+	for (i = 0; i < num_index; i++) {
+		u32 nslot;
+		u8 sig[NSINDEX_SIG_LEN];
+		u64 sum_save, sum, size;
+
+		memcpy(sig, nsindex[i]->sig, NSINDEX_SIG_LEN);
+		if (memcmp(sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN) != 0) {
+			dbg(ndd, "nsindex%d signature invalid\n", i);
+			continue;
+		}
+		sum_save = le64_to_cpu(nsindex[i]->checksum);
+		nsindex[i]->checksum = cpu_to_le64(0);
+		sum = fletcher64(nsindex[i], sizeof_namespace_index(ndd), 1);
+		nsindex[i]->checksum = cpu_to_le64(sum_save);
+		if (sum != sum_save) {
+			dbg(ndd, "nsindex%d checksum invalid\n", i);
+			continue;
+		}
+
+		seq = le32_to_cpu(nsindex[i]->seq);
+		if ((seq & NSINDEX_SEQ_MASK) == 0) {
+			dbg(ndd, "nsindex%d sequence: %#x invalid\n", i, seq);
+			continue;
+		}
+
+		/* sanity check the index against expected values */
+		if (le64_to_cpu(nsindex[i]->myoff)
+				!= i * sizeof_namespace_index(ndd)) {
+			dbg(ndd, "nsindex%d myoff: %#llx invalid\n",
+					i, (unsigned long long)
+					le64_to_cpu(nsindex[i]->myoff));
+			continue;
+		}
+		if (le64_to_cpu(nsindex[i]->otheroff)
+				!= (!i) * sizeof_namespace_index(ndd)) {
+			dbg(ndd, "nsindex%d otheroff: %#llx invalid\n",
+					i, (unsigned long long)
+					le64_to_cpu(nsindex[i]->otheroff));
+			continue;
+		}
+
+		size = le64_to_cpu(nsindex[i]->mysize);
+		if (size > sizeof_namespace_index(ndd)
+				|| size < sizeof(struct namespace_index)) {
+			dbg(ndd, "nsindex%d mysize: %#zx invalid\n", i, size);
+			continue;
+		}
+
+		nslot = le32_to_cpu(nsindex[i]->nslot);
+		if (nslot * sizeof(struct namespace_label)
+				+ 2 * sizeof_namespace_index(ndd)
+				> ndd->config_size) {
+			dbg(ndd, "nsindex%d nslot: %u invalid, config_size: %#zx\n",
+					i, nslot, ndd->config_size);
+			continue;
+		}
+		valid[i] = true;
+		num_valid++;
+	}
+
+	switch (num_valid) {
+	case 0:
+		break;
+	case 1:
+		for (i = 0; i < num_index; i++)
+			if (valid[i])
+				return i;
+		/* can't have num_valid > 0 but valid[] = { false, false } */
+		err(ndd, "unexpected index-block parse error\n");
+		break;
+	default:
+		/* pick the best index... */
+		seq = best_seq(le32_to_cpu(nsindex[0]->seq),
+				le32_to_cpu(nsindex[1]->seq));
+		if (seq == (le32_to_cpu(nsindex[1]->seq) & NSINDEX_SEQ_MASK))
+			return 1;
+		else
+			return 0;
+		break;
+	}
+
+	return -1;
+}
+
+static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
+		void *buf, size_t len)
+{
+	struct ndctl_cmd *cmd_write;
+	int rc;
+
+	cmd_write = ndctl_dimm_cmd_new_cfg_write(ndd->cmd_read);
+	if (!cmd_write)
+		return -ENXIO;
+
+	rc = ndctl_cmd_cfg_write_set_data(cmd_write, buf, len, offset);
+	if (rc < 0)
+		goto out;
+
+	rc = ndctl_cmd_submit(cmd_write);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
+		rc = -ENXIO;
+ out:
+	ndctl_cmd_unref(cmd_write);
+	return rc;
+}
+
+static int label_next_nsindex(int index)
+{
+	if (index < 0)
+		return -1;
+	return (index + 1) % 2;
+}
+
+static struct namespace_label *label_base(struct nvdimm_data *ndd)
+{
+	char *base = (char *) to_namespace_index(ndd, 0);
+
+	base += 2 * sizeof_namespace_index(ndd);
+	return (struct namespace_label *) base;
+}
+
+#define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
+#define BITS_PER_LONG (sizeof(unsigned long) * 8)
+static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
+{
+	struct namespace_index *nsindex;
+	unsigned long offset;
+	u64 checksum;
+	u32 nslot;
+
+	nsindex = to_namespace_index(ndd, index);
+	nslot = nvdimm_num_label_slots(ndd);
+
+	memcpy(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
+	nsindex->flags = cpu_to_le32(0);
+	nsindex->seq = cpu_to_le32(seq);
+	offset = (unsigned long) nsindex
+		- (unsigned long) to_namespace_index(ndd, 0);
+	nsindex->myoff = cpu_to_le64(offset);
+	nsindex->mysize = cpu_to_le64(sizeof_namespace_index(ndd));
+	offset = (unsigned long) to_namespace_index(ndd,
+			label_next_nsindex(index))
+		- (unsigned long) to_namespace_index(ndd, 0);
+	nsindex->otheroff = cpu_to_le64(offset);
+	offset = (unsigned long) label_base(ndd)
+		- (unsigned long) to_namespace_index(ndd, 0);
+	nsindex->labeloff = cpu_to_le64(offset);
+	nsindex->nslot = cpu_to_le32(nslot);
+	nsindex->major = cpu_to_le16(1);
+	nsindex->minor = cpu_to_le16(1);
+	nsindex->checksum = cpu_to_le64(0);
+	/* init label bitmap */
+	memset(nsindex->free, 0xff, ALIGN(nslot, BITS_PER_LONG) / 8);
+	checksum = fletcher64(nsindex, sizeof_namespace_index(ndd), 1);
+	nsindex->checksum = cpu_to_le64(checksum);
+	return nvdimm_set_config_data(ndd, le64_to_cpu(nsindex->myoff),
+			nsindex, sizeof_namespace_index(ndd));
+}
+
 static struct parameters {
 	const char *bus;
 	const char *outfile;
+	bool force;
 	bool json;
 	bool verbose;
 } param;
 
+static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	struct nvdimm_data __ndd, *ndd = &__ndd;
+	struct ndctl_cmd *cmd_read;
+	int rc = 0, i;
+	ssize_t size;
+
+	cmd_read = read_labels(dimm);
+	if (!cmd_read)
+		return -ENXIO;
+
+	size = ndctl_cmd_cfg_read_get_size(cmd_read);
+	ndd->data = malloc(size);
+	if (!ndd->data)
+		return -ENOMEM;
+	rc = ndctl_cmd_cfg_read_get_data(cmd_read, ndd->data, size, 0);
+	if (rc < 0)
+		goto out;
+
+	ndd->dimm = dimm;
+	ndd->cmd_read = cmd_read;
+	ndd->config_size = size;
+	ndd->nsindex_size = 0;
+	ndd->ns_current = -1;
+	ndd->ns_next = -1;
+	log_init(&ndd->ctx, ndctl_dimm_get_devname(dimm), "NDCTL_INIT_LABELS");
+	if (param.verbose)
+		ndd->ctx.log_priority = LOG_DEBUG;
+
+	/*
+	 * If the region goes active after this point, i.e. we're racing
+	 * another administrative action, the kernel will fail writes to
+	 * the label area.
+	 */
+	if (ndctl_dimm_is_active(dimm)) {
+		err(ndd, "regions active, abort label write\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	if (label_validate(ndd) >= 0 && !param.force) {
+		err(ndd, "error: labels already initialized\n");
+		rc = -EBUSY;
+		goto out;
+	}
+
+	for (i = 0; i < 2; i++) {
+		rc = label_write_index(ndd, i, i*2);
+		if (rc)
+			goto out;
+	}
+
+	/*
+	 * If the dimm is already disabled the kernel is not holding a cached
+	 * copy of the label space.
+	 */
+	if (!ndctl_dimm_is_enabled(dimm))
+		goto out;
+
+	rc = ndctl_dimm_disable(dimm);
+	if (rc)
+		goto out;
+	rc = ndctl_dimm_enable(dimm);
+
+ out:
+	ndctl_cmd_unref(cmd_read);
+	free(ndd->data);
+	return rc;
+}
+
 #define BASE_OPTIONS() \
 OPT_STRING('b', "bus", &param.bus, "bus-id", \
 	"<nmem> must be on a bus with an id/provider of <bus-id>"), \
@@ -361,6 +732,10 @@ OPT_STRING('o', NULL, &param.outfile, "output-file", \
 	"filename to write label area contents"), \
 OPT_BOOLEAN('j', "json", &param.json, "parse label data into json")
 
+#define INIT_OPTIONS() \
+OPT_BOOLEAN('f', "force", &param.force, \
+		"force initialization even if existing index-block present")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	READ_OPTIONS(),
@@ -372,6 +747,12 @@ static const struct option base_options[] = {
 	OPT_END(),
 };
 
+static const struct option init_options[] = {
+	BASE_OPTIONS(),
+	INIT_OPTIONS(),
+	OPT_END(),
+};
+
 static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
@@ -536,6 +917,16 @@ int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
 
+int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_init, init_options,
+			"ndctl init-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "initialized %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
 int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_disable, base_options,
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index ec55865ecea8..efa90c0146ee 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -20,6 +20,7 @@ int cmd_enable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_dimm(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_init_labels(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx);
 #ifdef ENABLE_TEST
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index aaeb3f7c2bec..bdb17226f834 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -36,6 +36,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-dimm", cmd_disable_dimm },
 	{ "zero-labels", cmd_zero_labels },
 	{ "read-labels", cmd_read_labels },
+	{ "init-labels", cmd_init_labels },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
