Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF89820958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:42 -0700 (PDT)
Subject: [ndctl PATCH 4/6] ndctl,
 read-labels: updates for v1.2 of the namespace specification
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:48:56 -0700
Message-ID: <149928773596.25150.2693241907298270098.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add basic support for just dumping the new v1.2 namespace label fields
in the output of "ndctl read-labels --json".

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 91 insertions(+), 15 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index d0de4d47a041..5645b6d9be0e 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -39,18 +39,19 @@ enum {
 };
 
 struct namespace_index {
-        char sig[NSINDEX_SIG_LEN];
-        le32 flags;
-        le32 seq;
-        le64 myoff;
-        le64 mysize;
-        le64 otheroff;
-        le64 labeloff;
-        le32 nslot;
-        le16 major;
-        le16 minor;
-        le64 checksum;
-        char free[0];
+	char sig[NSINDEX_SIG_LEN];
+	u8 flags[3];
+	u8 labelsize;
+	le32 seq;
+	le64 myoff;
+	le64 mysize;
+	le64 otheroff;
+	le64 labeloff;
+	le32 nslot;
+	le16 major;
+	le16 minor;
+	le64 checksum;
+	char free[0];
 };
 
 struct namespace_label {
@@ -64,9 +65,53 @@ struct namespace_label {
 	le64 dpa;
 	le64 rawsize;
 	le32 slot;
-	le32 unused;
+	/*
+	 * Accessing fields past this point should be gated by a
+	 * namespace_label_has() check.
+	 */
+	u8 align;
+	u8 reserved[3];
+	char type_guid[NSLABEL_UUID_LEN];
+	char abstraction_guid[NSLABEL_UUID_LEN];
+	u8 reserved2[88];
+	le64 checksum;
 };
 
+size_t sizeof_namespace_label(struct ndctl_cmd *cmd_read)
+{
+	struct namespace_index nsindex;
+	int v1 = 0, v2 = 0;
+	ssize_t offset;
+
+	for (offset = 0; offset < NSINDEX_ALIGN * 2; offset += NSINDEX_ALIGN) {
+		ssize_t len = (ssize_t) sizeof(nsindex);
+
+		len = ndctl_cmd_cfg_read_get_data(cmd_read, &nsindex, len, offset);
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
+		return sizeof(struct namespace_label);
+	return 128;
+}
+
+#define namespace_label_has(cmd_read, field) \
+	(offsetof(struct namespace_label, field) \
+	 < sizeof_namespace_label(cmd_read))
+
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 
 struct action_context {
@@ -98,6 +143,7 @@ static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 
 static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
 {
+	size_t namespace_label_size = sizeof_namespace_label(cmd_read);
 	struct json_object *jarray = json_object_new_array();
 	struct json_object *jlabel = NULL;
 	struct namespace_label nslabel;
@@ -108,7 +154,7 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 		return NULL;
 
 	for (offset = NSINDEX_ALIGN * 2; offset < size; offset += sizeof(nslabel)) {
-		ssize_t len = min_t(ssize_t, sizeof(nslabel), size - offset);
+		ssize_t len = min_t(ssize_t, namespace_label_size, size - offset);
 		struct json_object *jobj;
 		char uuid[40];
 
@@ -175,6 +221,21 @@ static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t s
 		json_object_object_add(jlabel, "rawsize", jobj);
 
 		json_object_array_add(jarray, jlabel);
+
+		if (namespace_label_size < 256)
+			continue;
+
+		uuid_unparse((void *) nslabel.type_guid, uuid);
+		jobj = json_object_new_string(uuid);
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "type_guid", jobj);
+
+		uuid_unparse((void *) nslabel.abstraction_guid, uuid);
+		jobj = json_object_new_string(uuid);
+		if (!jobj)
+			break;
+		json_object_object_add(jlabel, "abstraction_guid", jobj);
 	}
 
 	if (json_object_array_length(jarray) < 1) {
@@ -218,6 +279,21 @@ static struct json_object *dump_index_json(struct ndctl_cmd *cmd_read, ssize_t s
 			break;
 		json_object_object_add(jindex, "signature", jobj);
 
+		jobj = json_object_new_int(le16_to_cpu(nsindex.major));
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "major", jobj);
+
+		jobj = json_object_new_int(le16_to_cpu(nsindex.minor));
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "minor", jobj);
+
+		jobj = json_object_new_int(1 << (7 + nsindex.labelsize));
+		if (!jobj)
+			break;
+		json_object_object_add(jindex, "labelsize", jobj);
+
 		jobj = json_object_new_int(le32_to_cpu(nsindex.seq));
 		if (!jobj)
 			break;
@@ -665,7 +741,7 @@ static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
 	nslot = nvdimm_num_label_slots(ndd);
 
 	memcpy(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
-	nsindex->flags = cpu_to_le32(0);
+	memset(nsindex->flags, 0, 3);
 	nsindex->seq = cpu_to_le32(seq);
 	offset = (unsigned long) nsindex
 		- (unsigned long) to_namespace_index(ndd, 0);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
