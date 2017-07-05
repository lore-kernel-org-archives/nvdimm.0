Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 796D320958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:48 -0700 (PDT)
Subject: [ndctl PATCH 5/6] ndctl,
 init-labels: allow opt-in to new v1.2 label format
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:49:01 -0700
Message-ID: <149928774122.25150.307004901330084674.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

With the kernel change in 4.13 to start using v1.2 labels by default,
some environments may choose to keep deploying v1.1. The --label-version
option explicitly initializes the index block to the desired version. It
defaults to "1.1" since that has the widest compatibility.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |  155 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 121 insertions(+), 34 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 5645b6d9be0e..264917d05cc0 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -77,16 +77,31 @@ struct namespace_label {
 	le64 checksum;
 };
 
-size_t sizeof_namespace_label(struct ndctl_cmd *cmd_read)
+struct nvdimm_data {
+	struct ndctl_dimm *dimm;
+	struct ndctl_cmd *cmd_read;
+	unsigned long config_size;
+	size_t nslabel_size;
+	struct log_ctx ctx;
+	void *data;
+	int nsindex_size;
+	int ns_current, ns_next;
+};
+
+static size_t sizeof_namespace_label(struct nvdimm_data *ndd)
 {
 	struct namespace_index nsindex;
 	int v1 = 0, v2 = 0;
 	ssize_t offset;
 
+	if (ndd->nslabel_size)
+		return ndd->nslabel_size;
+
 	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
 		ssize_t len = (ssize_t) sizeof(nsindex);
 
-		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nsindex, len, offset);
+		len = ndctl_cmd_cfg_read_get_data(ndd->cmd_read, &nsindex,
+				len, offset);
 		if (len < 0)
 			break;
 
@@ -104,18 +119,21 @@ size_t sizeof_namespace_label(struct ndctl_cmd *cmd_read)
 	}
 
 	if (v2 > v1)
-		return sizeof(struct namespace_label);
-	return 128;
+		ndd->nslabel_size = 256;
+	else
+		ndd->nslabel_size = 128;
+	return ndd->nslabel_size;
 }
 
-#define namespace_label_has(cmd_read, field) \
+#define namespace_label_has(ndd, field) \
 	(offsetof(struct namespace_label, field) \
-	 < sizeof_namespace_label(cmd_read))
+	 < sizeof_namespace_label(ndd))
 
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 
 struct action_context {
 	struct json_object *jdimms;
+	int labelversion;
 	FILE *f_out;
 	FILE *f_in;
 };
@@ -143,7 +161,10 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 
 static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
 {
-	size_t namespace_label_size = sizeof_namespace_label(cmd_read);
+	struct nvdimm_data __ndd = {
+		.nslabel_size = 0,
+		.cmd_read = cmd_read
+	}, *ndd = &__ndd;
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
@@ -153,8 +174,10 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 	if (!jarray)
 		return NULL;
 
-	for (offset = NSINDEX_ALIGN * 2; offset < size; offset += sizeof(nslabel)) {
-		ssize_t len = min_t(ssize_t, namespace_label_size, size - offset);
+	for (offset = NSINDEX_ALIGN * 2; offset < size;
+			offset += sizeof_namespace_label(ndd)) {
+		ssize_t len = min_t(ssize_t, sizeof_namespace_label(ndd),
+				size - offset);
 		struct json_object *jobj;
 		char uuid[40];
 
@@ -163,7 +186,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 		if (!jlabel)
 			break;
 
-		if (len < (ssize_t) sizeof(nslabel))
+		if (len < (ssize_t) sizeof_namespace_label(ndd))
 			break;
 
 		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nslabel, len, offset);
@@ -222,7 +245,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 
 		json_object_array_add(jarray, jlabel);
 
-		if (namespace_label_size < 256)
+		if (sizeof_namespace_label(ndd) < 256)
 			continue;
 
 		uuid_unparse((void *) nslabel.type_guid, uuid);
@@ -486,16 +509,6 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 	return rc;
 }
 
-struct nvdimm_data {
-	struct ndctl_dimm *dimm;
-	struct ndctl_cmd *cmd_read;
-	unsigned long config_size;
-	struct log_ctx ctx;
-	void *data;
-	int nsindex_size;
-	int ns_current, ns_next;
-};
-
 /*
  * Note, best_seq(), inc_seq(), sizeof_namespace_index()
  * nvdimm_num_label_slots(), label_validate(), and label_write_index()
@@ -508,6 +521,7 @@ struct nvdimm_data {
  * 5/ s,__cpu_to,cpu_to,gc
  * 6/ remove flags argument to label_write_index
  * 7/ dropped clear_bit_le() usage in label_write_index
+ * 8/ s,nvdimm_drvdata,nvdimm_data,gc
  */
 
 static unsigned inc_seq(unsigned seq)
@@ -532,7 +546,7 @@ static u32 best_seq(u32 a, u32 b)
 		return a;
 }
 
-static size_t sizeof_namespace_index(struct nvdimm_data *ndd)
+size_t sizeof_namespace_index(struct nvdimm_data *ndd)
 {
 	u32 index_span;
 
@@ -547,16 +561,16 @@ static size_t sizeof_namespace_index(struct nvdimm_data *ndd)
 	 * starts to waste space at larger config_sizes, but it's
 	 * unlikely we'll ever see anything but 128K.
 	 */
-	index_span = ndd->config_size / 129;
+	index_span = ndd->config_size / (sizeof_namespace_label(ndd) + 1);
 	index_span /= NSINDEX_ALIGN * 2;
 	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
 
 	return ndd->nsindex_size;
 }
 
-static int nvdimm_num_label_slots(struct nvdimm_data *ndd)
+int nvdimm_num_label_slots(struct nvdimm_data *ndd)
 {
-	return ndd->config_size / 129;
+	return ndd->config_size / (sizeof_namespace_label(ndd) + 1);
 }
 
 static struct namespace_index *to_namespace_index(struct nvdimm_data *ndd,
@@ -571,7 +585,7 @@ static struct namespace_index *to_namespace_index(struct nvdimm_data *ndd,
 	return (struct namespace_index *) index;
 }
 
-static int label_validate(struct nvdimm_data *ndd)
+static int __label_validate(struct nvdimm_data *ndd)
 {
 	/*
 	 * On media label format consists of two index blocks followed
@@ -613,12 +627,28 @@ static int label_validate(struct nvdimm_data *ndd)
 		u32 nslot;
 		u8 sig[NSINDEX_SIG_LEN];
 		u64 sum_save, sum, size;
+		unsigned int version, labelsize;
 
 		memcpy(sig, nsindex[i]->sig, NSINDEX_SIG_LEN);
 		if (memcmp(sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN) != 0) {
 			dbg(ndd, "nsindex%d signature invalid\n", i);
 			continue;
 		}
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
+			dbg(ndd, "nsindex%d labelsize %d invalid\n",
+					i, nsindex[i]->labelsize);
+			continue;
+		}
+
 		sum_save = le64_to_cpu(nsindex[i]->checksum);
 		nsindex[i]->checksum = cpu_to_le64(0);
 		sum = fletcher64(nsindex[i], sizeof_namespace_index(ndd), 1);
@@ -658,7 +688,7 @@ static int label_validate(struct nvdimm_data *ndd)
 		}
 
 		nslot = le32_to_cpu(nsindex[i]->nslot);
-		if (nslot * sizeof(struct namespace_label)
+		if (nslot * sizeof_namespace_label(ndd)
 				+ 2 * sizeof_namespace_index(ndd)
 				> ndd->config_size) {
 			dbg(ndd, "nsindex%d nslot: %u invalid, config_size: %#zx\n",
@@ -693,6 +723,29 @@ static int label_validate(struct nvdimm_data *ndd)
 	return -1;
 }
 
+int label_validate(struct nvdimm_data *ndd)
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
+			return rc;
+	}
+
+	return -1;
+}
+
 static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
 		void *buf, size_t len)
 {
@@ -742,6 +795,7 @@ static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
 
 	memcpy(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
 	memset(nsindex->flags, 0, 3);
+	nsindex->labelsize = sizeof_namespace_label(ndd) >> 8;
 	nsindex->seq = cpu_to_le32(seq);
 	offset = (unsigned long) nsindex
 		- (unsigned long) to_namespace_index(ndd, 0);
@@ -756,7 +810,10 @@ static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
 	nsindex->labeloff = cpu_to_le64(offset);
 	nsindex->nslot = cpu_to_le32(nslot);
 	nsindex->major = cpu_to_le16(1);
-	nsindex->minor = cpu_to_le16(1);
+	if (sizeof_namespace_label(ndd) < 256)
+		nsindex->minor = cpu_to_le16(1);
+	else
+		nsindex->minor = cpu_to_le16(2);
 	nsindex->checksum = cpu_to_le64(0);
 	/* init label bitmap */
 	memset(nsindex->free, 0xff, ALIGN(nslot, BITS_PER_LONG) / 8);
@@ -770,14 +827,17 @@ static struct parameters {
 	const char *bus;
 	const char *outfile;
 	const char *infile;
+	const char *labelversion;
 	bool force;
 	bool json;
 	bool verbose;
-} param;
+} param = {
+	.labelversion = "1.1",
+};
 
-static int __action_init(struct ndctl_dimm *dimm, int chk_only)
+static int __action_init(struct ndctl_dimm *dimm, int version, int chk_only)
 {
-	struct nvdimm_data __ndd, *ndd = &__ndd;
+	struct nvdimm_data __ndd = { 0 }, *ndd = &__ndd;
 	struct ndctl_cmd *cmd_read;
 	int rc = 0, i;
 	ssize_t size;
@@ -830,6 +890,16 @@ static int __action_init(struct ndctl_dimm *dimm, int chk_only)
 		goto out;
 	}
 
+	/*
+	 * We may have initialized ndd to whatever labelsize is
+	 * currently on the dimm during label_validate(), so we reset it
+	 * to the desired version here.
+	 */
+	if (version > 1)
+		ndd->nslabel_size = 256;
+	else
+		ndd->nslabel_size = 128;
+
 	for (i = 0; i < 2; i++) {
 		rc = label_write_index(ndd, i, i*2);
 		if (rc)
@@ -856,12 +926,12 @@ static int __action_init(struct ndctl_dimm *dimm, int chk_only)
 
 static int action_init(struct ndctl_dimm *dimm, struct action_context *actx)
 {
-	return __action_init(dimm, 0);
+	return __action_init(dimm, actx->labelversion, 0);
 }
 
 static int action_check(struct ndctl_dimm *dimm, struct action_context *actx)
 {
-	return __action_init(dimm, 1);
+	return __action_init(dimm, 0, 1);
 }
 
 
@@ -881,7 +951,9 @@ OPT_STRING('i', "input", &param.infile, "input-file", \
 
 #define INIT_OPTIONS() \
 OPT_BOOLEAN('f', "force", &param.force, \
-		"force initialization even if existing index-block present")
+		"force initialization even if existing index-block present"), \
+OPT_STRING('V', "--label-version", &param.labelversion, "version-number", \
+	"namespace label specification version (default: 1.1)")
 
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
@@ -975,6 +1047,21 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	if (param.verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
+	if (strcmp(param.labelversion, "1.1") == 0)
+		actx.labelversion = 1;
+	else if (strcmp(param.labelversion, "v1.1") == 0)
+		actx.labelversion = 1;
+	else if (strcmp(param.labelversion, "1.2") == 0)
+		actx.labelversion = 2;
+	else if (strcmp(param.labelversion, "v1.2") == 0)
+		actx.labelversion = 2;
+	else {
+		fprintf(stderr, "'%s' is not a valid label version\n",
+				param.labelversion);
+		rc = -EINVAL;
+		goto out;
+	}
+
 	rc = 0;
 	err = 0;
 	count = 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
