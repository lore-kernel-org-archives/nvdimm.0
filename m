Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75F1021CE748D
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:46 -0700 (PDT)
Subject: [ndctl PATCH 6/7] ndctl: introduce ndctl_dimm_{validate_labels,
 init_labels}
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:02:02 -0700
Message-ID: <150403692285.8240.13036761546531987479.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add an api that attempts to parse an opaque namespace label data blob
into namespace indices and labels. It requires the output from
ndctl_dimm_read_labels(), and it enables later interrogation of the dimm
via ndctl_dimm_sizeof_namespace_index() and
ndctl_dimm_sizeof_namespace_label() which require valid label data to be
present.

This mostly moves all the local label helpers from the ndctl utility
into the library.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am            |    1 
 ndctl/dimm.c           |  455 +++---------------------------------------------
 ndctl/lib/dimm.c       |  451 +++++++++++++++++++++++++++++++++++++++++++++++-
 ndctl/lib/libndctl.c   |    1 
 ndctl/lib/libndctl.sym |    3 
 ndctl/lib/private.h    |   10 +
 ndctl/libndctl.h.in    |    8 +
 ndctl/namespace.h      |    1 
 util/fletcher.c        |   35 ----
 util/fletcher.h        |   19 ++
 10 files changed, 513 insertions(+), 471 deletions(-)
 delete mode 100644 util/fletcher.c

diff --git a/Makefile.am b/Makefile.am
index ba81e8c3d5bb..b538b1fd57ba 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -69,7 +69,6 @@ libutil_a_SOURCES = \
 	util/strbuf.c \
 	util/wrapper.c \
 	util/filter.c \
-	util/fletcher.c\
 	util/bitmap.c
 
 nobase_include_HEADERS = daxctl/libdaxctl.h
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index ca7b833db182..7259506fc028 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -29,63 +29,9 @@
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 
-struct nvdimm_data {
-	struct ndctl_dimm *dimm;
-	struct ndctl_cmd *cmd_read;
-	unsigned long config_size;
-	size_t nslabel_size;
-	struct log_ctx ctx;
-	void *data;
-	int nsindex_size;
-	int ns_current, ns_next;
-};
-
-static size_t sizeof_namespace_label(struct nvdimm_data *ndd)
-{
-	struct namespace_index nsindex;
-	int v1 = 0, v2 = 0;
-	ssize_t offset;
-
-	if (ndd->nslabel_size)
-		return ndd->nslabel_size;
-
-	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
-		ssize_t len = (ssize_t) sizeof(nsindex);
-
-		len = ndctl_cmd_cfg_read_get_data(ndd->cmd_read, &nsindex,
-				len, offset);
-		if (len < 0)
-			break;
-
-		/*
-		 * Since we're doing a best effort parsing we don't
-		 * fully validate the index block. Instead just assume
-		 * v1.1 unless there's 2 index blocks that say v1.2.
-		 */
-		if (le16_to_cpu(nsindex.major) == 1) {
-			if (le16_to_cpu(nsindex.minor) == 1)
-				v1++;
-			else if (le16_to_cpu(nsindex.minor) == 2)
-				v2++;
-		}
-	}
-
-	if (v2 > v1)
-		ndd->nslabel_size = 256;
-	else
-		ndd->nslabel_size = 128;
-	return ndd->nslabel_size;
-}
-
-#define namespace_label_has(ndd, field) \
-	(offsetof(struct namespace_label, field) \
-	 < sizeof_namespace_label(ndd))
-
-static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
-
 struct action_context {
 	struct json_object *jdimms;
-	int labelversion;
+	enum ndctl_namespace_version labelversion;
 	FILE *f_out;
 	FILE *f_in;
 };
@@ -111,12 +57,9 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 	return ndctl_dimm_zero_labels(dimm);
 }
 
-static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
+static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
+		struct ndctl_cmd *cmd_read, ssize_t size)
 {
-	struct nvdimm_data __ndd = {
-		.nslabel_size = 0,
-		.cmd_read = cmd_read
-	}, *ndd = &__ndd;
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
@@ -127,8 +70,9 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 		return NULL;
 
 	for (offset = NSINDEX_ALIGN * 2; offset < size;
-			offset += sizeof_namespace_label(ndd)) {
-		ssize_t len = min_t(ssize_t, sizeof_namespace_label(ndd),
+			offset += ndctl_dimm_sizeof_namespace_label(dimm)) {
+		ssize_t len = min_t(ssize_t,
+				ndctl_dimm_sizeof_namespace_label(dimm),
 				size - offset);
 		struct json_object *jobj;
 		char uuid[40];
@@ -138,7 +82,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 		if (!jlabel)
 			break;
 
-		if (len < (ssize_t) sizeof_namespace_label(ndd))
+		if (len < (ssize_t) ndctl_dimm_sizeof_namespace_label(dimm))
 			break;
 
 		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nslabel, len, offset);
@@ -197,7 +141,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 
 		json_object_array_add(jarray, jlabel);
 
-		if (sizeof_namespace_label(ndd) < 256)
+		if (ndctl_dimm_sizeof_namespace_label(dimm) < 256)
 			continue;
 
 		uuid_unparse((void *) nslabel.type_guid, uuid);
@@ -303,7 +247,7 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
 	jindex = dump_index_json(cmd_read, size);
 	if (!jindex)
 		goto err_jindex;
-	jlabel = dump_label_json(cmd_read, size);
+	jlabel = dump_label_json(dimm, cmd_read, size);
 	if (!jlabel)
 		goto err_jlabel;
 
@@ -427,320 +371,6 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
-/*
- * Note, best_seq(), inc_seq(), sizeof_namespace_index()
- * nvdimm_num_label_slots(), label_validate(), and label_write_index()
- * are copied from drivers/nvdimm/label.c in the Linux kernel with the
- * following modifications:
- * 1/ s,nd_,,gc
- * 2/ s,ndd->nsarea.config_size,ndd->config_size,gc
- * 3/ s,dev_dbg(dev,dbg(ndd,gc
- * 4/ s,__le,le,gc
- * 5/ s,__cpu_to,cpu_to,gc
- * 6/ remove flags argument to label_write_index
- * 7/ dropped clear_bit_le() usage in label_write_index
- * 8/ s,nvdimm_drvdata,nvdimm_data,gc
- */
-
-static unsigned inc_seq(unsigned seq)
-{
-	static const unsigned next[] = { 0, 2, 3, 1 };
-
-	return next[seq & 3];
-}
-
-static u32 best_seq(u32 a, u32 b)
-{
-	a &= NSINDEX_SEQ_MASK;
-	b &= NSINDEX_SEQ_MASK;
-
-	if (a == 0 || a == b)
-		return b;
-	else if (b == 0)
-		return a;
-	else if (inc_seq(a) == b)
-		return b;
-	else
-		return a;
-}
-
-size_t sizeof_namespace_index(struct nvdimm_data *ndd)
-{
-	u32 index_span;
-
-	if (ndd->nsindex_size)
-		return ndd->nsindex_size;
-
-	/*
-	 * The minimum index space is 512 bytes, with that amount of
-	 * index we can describe ~1400 labels which is less than a byte
-	 * of overhead per label.  Round up to a byte of overhead per
-	 * label and determine the size of the index region.  Yes, this
-	 * starts to waste space at larger config_sizes, but it's
-	 * unlikely we'll ever see anything but 128K.
-	 */
-	index_span = ndd->config_size / (sizeof_namespace_label(ndd) + 1);
-	index_span /= NSINDEX_ALIGN * 2;
-	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
-
-	return ndd->nsindex_size;
-}
-
-int nvdimm_num_label_slots(struct nvdimm_data *ndd)
-{
-	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
-}
-
-static struct namespace_index *to_namespace_index(struct nvdimm_data *ndd,
-		int i)
-{
-	char *index;
-
-	if (i < 0)
-		return NULL;
-
-	index = (char *) ndd->data + sizeof_namespace_index(ndd) * i;
-	return (struct namespace_index *) index;
-}
-
-static int __label_validate(struct nvdimm_data *ndd)
-{
-	/*
-	 * On media label format consists of two index blocks followed
-	 * by an array of labels.  None of these structures are ever
-	 * updated in place.  A sequence number tracks the current
-	 * active index and the next one to write, while labels are
-	 * written to free slots.
-	 *
-	 *     +------------+
-	 *     |            |
-	 *     |  nsindex0  |
-	 *     |            |
-	 *     +------------+
-	 *     |            |
-	 *     |  nsindex1  |
-	 *     |            |
-	 *     +------------+
-	 *     |   label0   |
-	 *     +------------+
-	 *     |   label1   |
-	 *     +------------+
-	 *     |            |
-	 *      ....nslot...
-	 *     |            |
-	 *     +------------+
-	 *     |   labelN   |
-	 *     +------------+
-	 */
-	struct namespace_index *nsindex[] = {
-		to_namespace_index(ndd, 0),
-		to_namespace_index(ndd, 1),
-	};
-	const int num_index = ARRAY_SIZE(nsindex);
-	bool valid[2] = { 0 };
-	int i, num_valid = 0;
-	u32 seq;
-
-	for (i = 0; i < num_index; i++) {
-		u32 nslot;
-		u8 sig[NSINDEX_SIG_LEN];
-		u64 sum_save, sum, size;
-		unsigned int version, labelsize;
-
-		memcpy(sig, nsindex[i]->sig, NSINDEX_SIG_LEN);
-		if (memcmp(sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN) != 0) {
-			dbg(ndd, "nsindex%d signature invalid\n", i);
-			continue;
-		}
-
-		/* label sizes larger than 128 arrived with v1.2 */
-		version = le16_to_cpu(nsindex[i]->major) * 100
-			+ le16_to_cpu(nsindex[i]->minor);
-		if (version >= 102)
-			labelsize = 1 << (7 + nsindex[i]->labelsize);
-		else
-			labelsize = 128;
-
-		if (labelsize != sizeof_namespace_label(ndd)) {
-			dbg(ndd, "nsindex%d labelsize %d invalid\n",
-					i, nsindex[i]->labelsize);
-			continue;
-		}
-
-		sum_save = le64_to_cpu(nsindex[i]->checksum);
-		nsindex[i]->checksum = cpu_to_le64(0);
-		sum = fletcher64(nsindex[i], sizeof_namespace_index(ndd), 1);
-		nsindex[i]->checksum = cpu_to_le64(sum_save);
-		if (sum != sum_save) {
-			dbg(ndd, "nsindex%d checksum invalid\n", i);
-			continue;
-		}
-
-		seq = le32_to_cpu(nsindex[i]->seq);
-		if ((seq & NSINDEX_SEQ_MASK) == 0) {
-			dbg(ndd, "nsindex%d sequence: %#x invalid\n", i, seq);
-			continue;
-		}
-
-		/* sanity check the index against expected values */
-		if (le64_to_cpu(nsindex[i]->myoff)
-				!= i * sizeof_namespace_index(ndd)) {
-			dbg(ndd, "nsindex%d myoff: %#llx invalid\n",
-					i, (unsigned long long)
-					le64_to_cpu(nsindex[i]->myoff));
-			continue;
-		}
-		if (le64_to_cpu(nsindex[i]->otheroff)
-				!= (!i) * sizeof_namespace_index(ndd)) {
-			dbg(ndd, "nsindex%d otheroff: %#llx invalid\n",
-					i, (unsigned long long)
-					le64_to_cpu(nsindex[i]->otheroff));
-			continue;
-		}
-
-		size = le64_to_cpu(nsindex[i]->mysize);
-		if (size > sizeof_namespace_index(ndd)
-				|| size < sizeof(struct namespace_index)) {
-			dbg(ndd, "nsindex%d mysize: %#zx invalid\n", i, size);
-			continue;
-		}
-
-		nslot = le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof_namespace_label(ndd)
-				+ 2 * sizeof_namespace_index(ndd)
-				> ndd->config_size) {
-			dbg(ndd, "nsindex%d nslot: %u invalid, config_size: %#zx\n",
-					i, nslot, ndd->config_size);
-			continue;
-		}
-		valid[i] = true;
-		num_valid++;
-	}
-
-	switch (num_valid) {
-	case 0:
-		break;
-	case 1:
-		for (i = 0; i < num_index; i++)
-			if (valid[i])
-				return i;
-		/* can't have num_valid > 0 but valid[] = { false, false } */
-		err(ndd, "unexpected index-block parse error\n");
-		break;
-	default:
-		/* pick the best index... */
-		seq = best_seq(le32_to_cpu(nsindex[0]->seq),
-				le32_to_cpu(nsindex[1]->seq));
-		if (seq == (le32_to_cpu(nsindex[1]->seq) & NSINDEX_SEQ_MASK))
-			return 1;
-		else
-			return 0;
-		break;
-	}
-
-	return -1;
-}
-
-int label_validate(struct nvdimm_data *ndd)
-{
-	/*
-	 * In order to probe for and validate namespace index blocks we
-	 * need to know the size of the labels, and we can't trust the
-	 * size of the labels until we validate the index blocks.
-	 * Resolve this dependency loop by probing for known label
-	 * sizes, but default to v1.2 256-byte namespace labels if
-	 * discovery fails.
-	 */
-	int label_size[] = { 128, 256 };
-	int i, rc;
-
-	for (i = 0; (size_t) i < ARRAY_SIZE(label_size); i++) {
-		ndd->nslabel_size = label_size[i];
-		rc = __label_validate(ndd);
-		if (rc >= 0)
-			return rc;
-	}
-
-	return -1;
-}
-
-static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
-		void *buf, size_t len)
-{
-	struct ndctl_cmd *cmd_write;
-	int rc;
-
-	cmd_write = ndctl_dimm_cmd_new_cfg_write(ndd->cmd_read);
-	if (!cmd_write)
-		return -ENXIO;
-
-	rc = ndctl_cmd_cfg_write_set_data(cmd_write, buf, len, offset);
-	if (rc < 0)
-		goto out;
-
-	rc = ndctl_cmd_submit(cmd_write);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
-		rc = -ENXIO;
- out:
-	ndctl_cmd_unref(cmd_write);
-	return rc;
-}
-
-static int label_next_nsindex(int index)
-{
-	if (index < 0)
-		return -1;
-	return (index + 1) % 2;
-}
-
-static struct namespace_label *label_base(struct nvdimm_data *ndd)
-{
-	char *base = (char *) to_namespace_index(ndd, 0);
-
-	base += 2 * sizeof_namespace_index(ndd);
-	return (struct namespace_label *) base;
-}
-
-static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
-{
-	struct namespace_index *nsindex;
-	unsigned long offset;
-	u64 checksum;
-	u32 nslot;
-
-	nsindex = to_namespace_index(ndd, index);
-	nslot = nvdimm_num_label_slots(ndd);
-
-	memcpy(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
-	memset(nsindex->flags, 0, 3);
-	nsindex->labelsize = sizeof_namespace_label(ndd) >> 8;
-	nsindex->seq = cpu_to_le32(seq);
-	offset = (unsigned long) nsindex
-		- (unsigned long) to_namespace_index(ndd, 0);
-	nsindex->myoff = cpu_to_le64(offset);
-	nsindex->mysize = cpu_to_le64(sizeof_namespace_index(ndd));
-	offset = (unsigned long) to_namespace_index(ndd,
-			label_next_nsindex(index))
-		- (unsigned long) to_namespace_index(ndd, 0);
-	nsindex->otheroff = cpu_to_le64(offset);
-	offset = (unsigned long) label_base(ndd)
-		- (unsigned long) to_namespace_index(ndd, 0);
-	nsindex->labeloff = cpu_to_le64(offset);
-	nsindex->nslot = cpu_to_le32(nslot);
-	nsindex->major = cpu_to_le16(1);
-	if (sizeof_namespace_label(ndd) < 256)
-		nsindex->minor = cpu_to_le16(1);
-	else
-		nsindex->minor = cpu_to_le16(2);
-	nsindex->checksum = cpu_to_le64(0);
-	/* init label bitmap */
-	memset(nsindex->free, 0xff, ALIGN(nslot, BITS_PER_LONG) / 8);
-	checksum = fletcher64(nsindex, sizeof_namespace_index(ndd), 1);
-	nsindex->checksum = cpu_to_le64(checksum);
-	return nvdimm_set_config_data(ndd, le64_to_cpu(nsindex->myoff),
-			nsindex, sizeof_namespace_index(ndd));
-}
-
 static struct parameters {
 	const char *bus;
 	const char *outfile;
@@ -753,76 +383,42 @@ static struct parameters {
 	.labelversion = "1.1",
 };
 
-static int __action_init(struct ndctl_dimm *dimm, int version, int chk_only)
+static int __action_init(struct ndctl_dimm *dimm,
+		enum ndctl_namespace_version version, int chk_only)
 {
-	struct nvdimm_data __ndd = { 0 }, *ndd = &__ndd;
 	struct ndctl_cmd *cmd_read;
-	int rc = 0, i;
-	ssize_t size;
+	int rc;
 
 	cmd_read = ndctl_dimm_read_labels(dimm);
 	if (!cmd_read)
 		return -ENXIO;
 
-	size = ndctl_cmd_cfg_read_get_size(cmd_read);
-	if (size < 0)
-		return size;
-
-	ndd->data = malloc(size);
-	if (!ndd->data)
-		return -ENOMEM;
-	rc = ndctl_cmd_cfg_read_get_data(cmd_read, ndd->data, size, 0);
-	if (rc < 0)
-		goto out;
-
-	ndd->dimm = dimm;
-	ndd->cmd_read = cmd_read;
-	ndd->config_size = size;
-	ndd->nsindex_size = 0;
-	ndd->ns_current = -1;
-	ndd->ns_next = -1;
-	log_init(&ndd->ctx, ndctl_dimm_get_devname(dimm), "NDCTL_INIT_LABELS");
-	if (param.verbose)
-		ndd->ctx.log_priority = LOG_DEBUG;
-
 	/*
 	 * If the region goes active after this point, i.e. we're racing
 	 * another administrative action, the kernel will fail writes to
 	 * the label area.
 	 */
 	if (!chk_only && ndctl_dimm_is_active(dimm)) {
-		err(ndd, "regions active, abort label write\n");
+		fprintf(stderr, "%s: regions active, abort label write\n",
+				ndctl_dimm_get_devname(dimm));
 		rc = -EBUSY;
 		goto out;
 	}
 
-	rc = label_validate(ndd);
-	if (chk_only) {
-		rc = rc >= 0 ? 0 : -ENXIO;
+	rc = ndctl_dimm_validate_labels(dimm);
+	if (chk_only)
 		goto out;
-	}
 
 	if (rc >= 0 && !param.force) {
-		err(ndd, "error: labels already initialized\n");
+		fprintf(stderr, "%s: error: labels already initialized\n",
+				ndctl_dimm_get_devname(dimm));
 		rc = -EBUSY;
 		goto out;
 	}
 
-	/*
-	 * We may have initialized ndd to whatever labelsize is
-	 * currently on the dimm during label_validate(), so we reset it
-	 * to the desired version here.
-	 */
-	if (version > 1)
-		ndd->nslabel_size = 256;
-	else
-		ndd->nslabel_size = 128;
-
-	for (i = 0; i < 2; i++) {
-		rc = label_write_index(ndd, i, i*2);
-		if (rc)
-			goto out;
-	}
+	rc = ndctl_dimm_init_labels(dimm, version);
+	if (rc < 0)
+		goto out;
 
 	/*
 	 * If the dimm is already disabled the kernel is not holding a cached
@@ -838,7 +434,6 @@ static int __action_init(struct ndctl_dimm *dimm, int version, int chk_only)
 
  out:
 	ndctl_cmd_unref(cmd_read);
-	free(ndd->data);
 	return rc;
 }
 
@@ -966,13 +561,13 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
 	if (strcmp(param.labelversion, "1.1") == 0)
-		actx.labelversion = 1;
+		actx.labelversion = NDCTL_NS_VERSION_1_1;
 	else if (strcmp(param.labelversion, "v1.1") == 0)
-		actx.labelversion = 1;
+		actx.labelversion = NDCTL_NS_VERSION_1_1;
 	else if (strcmp(param.labelversion, "1.2") == 0)
-		actx.labelversion = 2;
+		actx.labelversion = NDCTL_NS_VERSION_1_2;
 	else if (strcmp(param.labelversion, "v1.2") == 0)
-		actx.labelversion = 2;
+		actx.labelversion = NDCTL_NS_VERSION_1_2;
 	else {
 		fprintf(stderr, "'%s' is not a valid label version\n",
 				param.labelversion);
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index f7696af04ba2..212e9189c5b6 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -10,11 +10,454 @@
  * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
  * more details.
  */
+#include <ndctl/namespace.h>
 #include <ndctl/libndctl.h>
+#include <util/fletcher.h>
 #include <util/sysfs.h>
 #include <stdlib.h>
 #include "private.h"
 
+static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
+
+/*
+ * Note, best_seq(), inc_seq(), sizeof_namespace_index()
+ * nvdimm_num_label_slots(), label_validate(), and label_write_index()
+ * are copied from drivers/nvdimm/label.c in the Linux kernel with the
+ * following modifications:
+ * 1/ s,nd_,,gc
+ * 2/ s,ndd->nsarea.config_size,ndd->config_size,gc
+ * 3/ s,dev_dbg(dev,dbg(ctx,gc
+ * 4/ s,__le,le,gc
+ * 5/ s,__cpu_to,cpu_to,gc
+ * 6/ remove flags argument to label_write_index
+ * 7/ dropped clear_bit_le() usage in label_write_index
+ * 8/ s,nvdimm_drvdata,nvdimm_data,gc
+ */
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
+static struct ndctl_dimm *to_dimm(struct nvdimm_data *ndd)
+{
+	return container_of(ndd, struct ndctl_dimm, ndd);
+}
+
+static unsigned int sizeof_namespace_label(struct nvdimm_data *ndd)
+{
+	return ndctl_dimm_sizeof_namespace_label(to_dimm(ndd));
+}
+
+static unsigned int sizeof_namespace_index(struct nvdimm_data *ndd)
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
+	index_span = ndd->config_size / (sizeof_namespace_label(ndd) + 1);
+	index_span /= NSINDEX_ALIGN * 2;
+	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
+
+	return ndd->nsindex_size;
+}
+
+static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
+{
+	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
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
+static int __label_validate(struct nvdimm_data *ndd)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(to_dimm(ndd));
+
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
+		unsigned int version, labelsize;
+
+		memcpy(sig, nsindex[i]->sig, NSINDEX_SIG_LEN);
+		if (memcmp(sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN) != 0) {
+			dbg(ctx, "nsindex%d signature invalid\n", i);
+			continue;
+		}
+
+		/* label sizes larger than 128 arrived with v1.2 */
+		version = le16_to_cpu(nsindex[i]->major) * 100
+			+ le16_to_cpu(nsindex[i]->minor);
+		if (version >= 102)
+			labelsize = 1 << (7 + nsindex[i]->labelsize);
+		else
+			labelsize = 128;
+
+		if (labelsize != sizeof_namespace_label(ndd)) {
+			dbg(ctx, "nsindex%d labelsize %d invalid\n",
+					i, nsindex[i]->labelsize);
+			continue;
+		}
+
+		sum_save = le64_to_cpu(nsindex[i]->checksum);
+		nsindex[i]->checksum = cpu_to_le64(0);
+		sum = fletcher64(nsindex[i], sizeof_namespace_index(ndd), 1);
+		nsindex[i]->checksum = cpu_to_le64(sum_save);
+		if (sum != sum_save) {
+			dbg(ctx, "nsindex%d checksum invalid\n", i);
+			continue;
+		}
+
+		seq = le32_to_cpu(nsindex[i]->seq);
+		if ((seq & NSINDEX_SEQ_MASK) == 0) {
+			dbg(ctx, "nsindex%d sequence: %#x invalid\n", i, seq);
+			continue;
+		}
+
+		/* sanity check the index against expected values */
+		if (le64_to_cpu(nsindex[i]->myoff)
+				!= i * sizeof_namespace_index(ndd)) {
+			dbg(ctx, "nsindex%d myoff: %#llx invalid\n",
+					i, (unsigned long long)
+					le64_to_cpu(nsindex[i]->myoff));
+			continue;
+		}
+		if (le64_to_cpu(nsindex[i]->otheroff)
+				!= (!i) * sizeof_namespace_index(ndd)) {
+			dbg(ctx, "nsindex%d otheroff: %#llx invalid\n",
+					i, (unsigned long long)
+					le64_to_cpu(nsindex[i]->otheroff));
+			continue;
+		}
+
+		size = le64_to_cpu(nsindex[i]->mysize);
+		if (size > sizeof_namespace_index(ndd)
+				|| size < sizeof(struct namespace_index)) {
+			dbg(ctx, "nsindex%d mysize: %#zx invalid\n", i, size);
+			continue;
+		}
+
+		nslot = le32_to_cpu(nsindex[i]->nslot);
+		if (nslot * sizeof_namespace_label(ndd)
+				+ 2 * sizeof_namespace_index(ndd)
+				> ndd->config_size) {
+			dbg(ctx, "nsindex%d nslot: %u invalid, config_size: %#zx\n",
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
+		err(ctx, "unexpected index-block parse error\n");
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
+	return -EINVAL;
+}
+
+/*
+ * If the dimm labels have not been previously validated this routine
+ * will make up a default size. Otherwise, it will pick the size based
+ * on what version is specified in the index block.
+ */
+NDCTL_EXPORT unsigned int ndctl_dimm_sizeof_namespace_label(struct ndctl_dimm *dimm)
+{
+	struct nvdimm_data *ndd = &dimm->ndd;
+	struct namespace_index nsindex;
+	ssize_t offset, size;
+	int v1 = 0, v2 = 0;
+
+	if (ndd && ndd->nslabel_size)
+		return ndd->nslabel_size;
+
+	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
+		ssize_t len = (ssize_t) sizeof(nsindex);
+
+		len = ndctl_cmd_cfg_read_get_data(ndd->cmd_read, &nsindex,
+				len, offset);
+		if (len < 0)
+			break;
+
+		/*
+		 * Since we're doing a best effort parsing we don't
+		 * fully validate the index block. Instead just assume
+		 * v1.1 unless there's 2 index blocks that say v1.2.
+		 */
+		if (le16_to_cpu(nsindex.major) == 1) {
+			if (le16_to_cpu(nsindex.minor) == 1)
+				v1++;
+			else if (le16_to_cpu(nsindex.minor) == 2)
+				v2++;
+		}
+	}
+
+	if (v2 > v1)
+		size = 256;
+	else
+		size = 128;
+	if (ndd)
+		ndd->nslabel_size = size;
+	return size;
+}
+
+static int label_validate(struct nvdimm_data *ndd)
+{
+	/*
+	 * In order to probe for and validate namespace index blocks we
+	 * need to know the size of the labels, and we can't trust the
+	 * size of the labels until we validate the index blocks.
+	 * Resolve this dependency loop by probing for known label
+	 * sizes, but default to v1.2 256-byte namespace labels if
+	 * discovery fails.
+	 */
+	int label_size[] = { 128, 256 };
+	int i, rc;
+
+	for (i = 0; (size_t) i < ARRAY_SIZE(label_size); i++) {
+		ndd->nslabel_size = label_size[i];
+		rc = __label_validate(ndd);
+		if (rc >= 0)
+			return nvdimm_num_label_slots(ndd);
+	}
+
+	return -EINVAL;
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
+static void init_ndd(struct nvdimm_data *ndd, struct ndctl_cmd *cmd_read)
+{
+	ndctl_cmd_unref(ndd->cmd_read);
+	memset(ndd, 0, sizeof(*ndd));
+	ndd->cmd_read = cmd_read;
+	ndctl_cmd_ref(cmd_read);
+	ndd->data = cmd_read->iter.total_buf;
+	ndd->config_size = cmd_read->iter.total_xfer;
+	ndd->nsindex_size = 0;
+	ndd->ns_current = -1;
+	ndd->ns_next = -1;
+}
+
+static int write_label_index(struct ndctl_dimm *dimm,
+		enum ndctl_namespace_version ver, unsigned index, unsigned seq)
+{
+	struct nvdimm_data *ndd = &dimm->ndd;
+	struct namespace_index *nsindex;
+	unsigned long offset;
+	u64 checksum;
+	u32 nslot;
+
+	/*
+	 * We may have initialized ndd to whatever labelsize is
+	 * currently on the dimm during label_validate(), so we reset it
+	 * to the desired version here.
+	 */
+	switch (ver) {
+	case NDCTL_NS_VERSION_1_1:
+		ndd->nslabel_size = 128;
+		break;
+	case NDCTL_NS_VERSION_1_2:
+		ndd->nslabel_size = 256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	nsindex = to_namespace_index(ndd, index);
+	nslot = nvdimm_num_label_slots(ndd);
+
+	memcpy(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
+	memset(nsindex->flags, 0, 3);
+	nsindex->labelsize = sizeof_namespace_label(ndd) >> 8;
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
+	if (sizeof_namespace_label(ndd) < 256)
+		nsindex->minor = cpu_to_le16(1);
+	else
+		nsindex->minor = cpu_to_le16(2);
+	nsindex->checksum = cpu_to_le64(0);
+	/* init label bitmap */
+	memset(nsindex->free, 0xff, ALIGN(nslot, BITS_PER_LONG) / 8);
+	checksum = fletcher64(nsindex, sizeof_namespace_index(ndd), 1);
+	nsindex->checksum = cpu_to_le64(checksum);
+	return nvdimm_set_config_data(ndd, le64_to_cpu(nsindex->myoff),
+			nsindex, sizeof_namespace_index(ndd));
+}
+
+NDCTL_EXPORT int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
+		enum ndctl_namespace_version v)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct nvdimm_data *ndd = &dimm->ndd;
+	int i;
+
+	if (!ndd->cmd_read) {
+		err(ctx, "%s: needs to be initialized by ndctl_dimm_read_labels\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EINVAL;
+	}
+
+	for (i = 0; i < 2; i++) {
+		int rc;
+
+		rc = write_label_index(dimm, v, i, i*2);
+		if (rc < 0)
+			return rc;
+	}
+
+	return nvdimm_num_label_slots(ndd);
+}
+
+NDCTL_EXPORT int ndctl_dimm_validate_labels(struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct nvdimm_data *ndd = &dimm->ndd;
+
+	if (!ndd->cmd_read) {
+		err(ctx, "%s: needs to be initialized by ndctl_dimm_read_labels\n",
+				ndctl_dimm_get_devname(dimm));
+		return -EINVAL;
+	}
+
+	return label_validate(&dimm->ndd);
+}
+
 NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm)
 {
         struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
@@ -38,9 +481,11 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm)
         rc = ndctl_cmd_submit(cmd_read);
         if (rc || ndctl_cmd_get_firmware_status(cmd_read))
                 goto out_read;
+	ndctl_cmd_unref(cmd_size);
 
-        ndctl_cmd_unref(cmd_size);
-        return cmd_read;
+	init_ndd(&dimm->ndd, cmd_read);
+
+	return cmd_read;
 
  out_read:
         ndctl_cmd_unref(cmd_read);
@@ -118,5 +563,3 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 
 	return strtoul(buf, NULL, 0);
 }
-
-
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 86abeb6cc577..17fc8ee4ce00 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -560,6 +560,7 @@ static void free_dimm(struct ndctl_dimm *dimm)
 		kmod_module_unref(dimm->module);
 	if (dimm->health_eventfd > -1)
 		close(dimm->health_eventfd);
+	ndctl_cmd_unref(dimm->ndd.cmd_read);
 	free(dimm);
 }
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 95c6e400124d..4c1773daa861 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -114,7 +114,10 @@ global:
 	ndctl_cmd_smart_threshold_get_spares;
 	ndctl_dimm_zero_labels;
 	ndctl_dimm_read_labels;
+	ndctl_dimm_validate_labels;
+	ndctl_dimm_init_labels;
 	ndctl_dimm_get_available_labels;
+	ndctl_dimm_sizeof_namespace_label;
 	ndctl_region_get_first;
 	ndctl_region_get_next;
 	ndctl_region_get_id;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 64906b8123d0..808e77da07ca 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -34,6 +34,15 @@
 #include "hpe1.h"
 #include "msft.h"
 
+struct nvdimm_data {
+	struct ndctl_cmd *cmd_read;
+	void *data;
+	unsigned long config_size;
+	size_t nslabel_size;
+	int nsindex_size;
+	int ns_current, ns_next;
+};
+
 /**
  * struct ndctl_dimm - memory device as identified by NFIT
  * @module: kernel module (libnvdimm)
@@ -56,6 +65,7 @@ struct ndctl_dimm {
 	struct kmod_module *module;
 	struct ndctl_bus *bus;
 	struct ndctl_smart_ops *smart_ops;
+	struct nvdimm_data ndd;
 	unsigned int handle, major, minor, serial;
 	unsigned short phys_id;
 	unsigned short vendor_id;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 9be380b8a735..2bbda046f130 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -359,7 +359,15 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg_size);
 struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cfg_read);
 int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm);
 struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm);
+int ndctl_dimm_validate_labels(struct ndctl_dimm *dimm);
+enum ndctl_namespace_version {
+	NDCTL_NS_VERSION_1_1,
+	NDCTL_NS_VERSION_1_2,
+};
+int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
+		enum ndctl_namespace_version v);
 unsigned long ndctl_dimm_get_available_labels(struct ndctl_dimm *dimm);
+unsigned int ndctl_dimm_sizeof_namespace_label(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_cfg_size_get_size(struct ndctl_cmd *cfg_size);
 ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read, void *buf,
 		unsigned int len, unsigned int offset);
diff --git a/ndctl/namespace.h b/ndctl/namespace.h
index b466c2b96bd3..6d56468b8f89 100644
--- a/ndctl/namespace.h
+++ b/ndctl/namespace.h
@@ -12,6 +12,7 @@
  */
 #ifndef __NDCTL_NAMESPACE_H__
 #define __NDCTL_NAMESPACE_H__
+#include <sys/types.h>
 #include <util/size.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
diff --git a/util/fletcher.c b/util/fletcher.c
deleted file mode 100644
index 29778db833f5..000000000000
--- a/util/fletcher.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-#include <stdlib.h>
-#include <stdbool.h>
-#include <util/fletcher.h>
-#include <ccan/endian/endian.h>
-#include <ccan/short_types/short_types.h>
-
-/*
- * Note, fletcher64() is copied from drivers/nvdimm/label.c in the Linux kernel
- */
-u64 fletcher64(void *addr, size_t len, bool le)
-{
-	u32 *buf = addr;
-	u32 lo32 = 0;
-	u64 hi32 = 0;
-	size_t i;
-
-	for (i = 0; i < len / sizeof(u32); i++) {
-		lo32 += le ? le32_to_cpu((le32) buf[i]) : buf[i];
-		hi32 += lo32;
-	}
-
-	return hi32 << 32 | lo32;
-}
diff --git a/util/fletcher.h b/util/fletcher.h
index e3bbce387702..54e2ecf5d6ed 100644
--- a/util/fletcher.h
+++ b/util/fletcher.h
@@ -1,8 +1,25 @@
 #ifndef _NDCTL_FLETCHER_H_
 #define _NDCTL_FLETCHER_H_
 
+#include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
 
-u64 fletcher64(void *addr, size_t len, bool le);
+/*
+ * Note, fletcher64() is copied from drivers/nvdimm/label.c in the Linux kernel
+ */
+static inline u64 fletcher64(void *addr, size_t len, bool le)
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
 
 #endif /* _NDCTL_FLETCHER_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
