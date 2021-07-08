Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388862FB0
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 18:37:56 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231332272"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="231332272"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="411017442"
Received: from janandra-mobl.amr.corp.intel.com ([10.251.31.93])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:53 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v1 3/4] pcdctl/reconfigure: Add pcdctl-reconfigure-region command
Date: Thu,  8 Jul 2021 11:37:40 -0700
Message-Id: <20210708183741.2952-4-james.sushanth.anandraj@intel.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
References: <20210708183741.2952-1-james.sushanth.anandraj@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>

Add pcdctl-reconfigure-region command and helper functions. The command
reads pcd data from the 'nvdimm' devices and writes a new pcd
reflecting the region reconfiguration request. In this patch functions
to reconfigure region into volatile regions(ram) are implemented.

Signed-off-by: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
---
 pcdctl/Makefile.am   |   1 +
 pcdctl/builtin.h     |   1 +
 pcdctl/pcat.c        |  59 +++++++
 pcdctl/pcat.h        |  13 ++
 pcdctl/pcd.h         |  58 +++++++
 pcdctl/pcdctl.c      |   1 +
 pcdctl/reconfigure.c | 390 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 515 insertions(+), 8 deletions(-)
 create mode 100644 pcdctl/pcat.c
 create mode 100644 pcdctl/pcat.h

diff --git a/pcdctl/Makefile.am b/pcdctl/Makefile.am
index 1f26faf..f1511ae 100644
--- a/pcdctl/Makefile.am
+++ b/pcdctl/Makefile.am
@@ -6,6 +6,7 @@ pcdctl_SOURCES =\
 		pcdctl.c \
 		list.c \
 		reconfigure.c \
+		pcat.c \
 		../util/json.c \
 		builtin.h
 
diff --git a/pcdctl/builtin.h b/pcdctl/builtin.h
index b1c4b2f..43b7e5c 100644
--- a/pcdctl/builtin.h
+++ b/pcdctl/builtin.h
@@ -5,4 +5,5 @@
 
 struct ndctl_ctx;
 int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_reconfigure_region(int argc, const char **argv, struct ndctl_ctx *ctx);
 #endif /* _PCDCTL_BUILTIN_H_ */
diff --git a/pcdctl/pcat.c b/pcdctl/pcat.c
new file mode 100644
index 0000000..3320784
--- /dev/null
+++ b/pcdctl/pcat.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2020 Intel Corporation. All rights reserved.
+#include <pcat.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+#include <acpi.h>
+#include <errno.h>
+
+static u8 pcat_rev;
+
+/**
+ * Function to read pcat revision from acpi table
+ */
+static u8 read_pcat_rev(void)
+{
+	const char *sysfs_path = "/sys/firmware/acpi/tables/PCAT";
+	struct acpi_header acpi;
+	int fd = open(sysfs_path, O_RDONLY);
+	u32 bytes = 0;
+
+	if (fd < 0)
+		return 0;
+	memset(&acpi, 0, sizeof(struct acpi_header));
+	bytes = read(fd, &acpi, sizeof(struct acpi_header));
+	if (bytes < sizeof(struct acpi_header)) {
+		close(fd);
+		return 0;
+	}
+	close(fd);
+	return acpi.revision;
+}
+
+/**
+ * Check if we have already read the pcat revision else read it and return
+ */
+u8 get_pcat_rev(void)
+{
+	if (!pcat_rev)
+		pcat_rev = read_pcat_rev();
+	return pcat_rev;
+}
+
+/**
+ * See if the pcat revision is such that we can create a region reconfiguration
+ * request only two revisions (0.2 and 1.2) are supported and described in
+ * provisioning document. This is mentioned in section 3.1 of provisioning
+ * document.
+ */
+int validate_pcat_rev(void)
+{
+	if (!pcat_rev)
+		pcat_rev = read_pcat_rev();
+	if (pcat_rev == PCAT_REV_0_2 || pcat_rev == PCAT_REV_1_2)
+		return 0;
+	return -EOPNOTSUPP;
+}
diff --git a/pcdctl/pcat.h b/pcdctl/pcat.h
new file mode 100644
index 0000000..3f6f8ae
--- /dev/null
+++ b/pcdctl/pcat.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0*/
+/* Copyright(c) 2021 Intel Corporation. All rights reserved.*/
+
+#ifndef _PCAT_H_
+#define _PCAT_H_
+#include <stdint.h>
+#include <ccan/short_types/short_types.h>
+#define PCAT_REV_0_2 ((u8)0x02)
+#define PCAT_REV_1_2 ((u8)0x12)
+
+int validate_pcat_rev(void);
+u8 get_pcat_rev(void);
+#endif /* _LIST_H_ */
diff --git a/pcdctl/pcd.h b/pcdctl/pcd.h
index f49f7eb..e16c1e0 100644
--- a/pcdctl/pcd.h
+++ b/pcdctl/pcd.h
@@ -33,6 +33,7 @@
  * CCUR - Current Configuration
  * CIN - Configuration Input
  * COUT - Configuration Output
+ * PSCT - Partition Size Change Table
  */
 /**
  * struct pcd_config_header - configuration header
@@ -112,6 +113,23 @@ struct pcd_cout {
 	u8 status;
 	u8 r1[7];
 } __attribute__((packed));
+/**
+ * struct pcd_psct - partition size change table (type 4)
+ * @type: table type
+ * @length: length in bytes for entire table
+ * @status: partition size change status
+ * @size: persistent memory partition size
+ * The Partition Size Change Table is used for changing the module partition
+ * size, and it is used in the configuration input and output structures. The
+ * structure and its fields are described in 3.7 and Table 37 in the
+ * provisioning specification document.
+ */
+struct pcd_psct {
+	u16 type;
+	u16 length;
+	u32 status;
+	u64 size;
+} __attribute__((packed));
 /**
  * struct pcd_get_pcd_input - get pcd input
  * @partition_id: partition id
@@ -132,6 +150,24 @@ struct pcd_get_pcd_input {
 	} __attribute__((packed)) options;
 	u32 offset;
 } __attribute__((packed));
+/**
+ * struct pcd_set_pcd_input - set pcd input
+ * @partition_id: partition id
+ * @payload_type: payload type
+ * @offset: offset
+ * @reserved: reserved
+ * @data: data
+ * The structure represents the input parameters to set pcd vendor specific
+ * command. The structure and its fields are described in section 4.2 and Table
+ * 45 in the provisioning specification document.
+ */
+struct pcd_set_pcd_input {
+	u8 partition_id;
+	u8 payload_type;
+	u32 offset;
+	u8 reserved[58];
+	u8 data[64];
+} __attribute__((packed));
 /**
  * Human readable pcd status string
  */
@@ -147,6 +183,11 @@ static const char *const pcd_status_str[] = {
  * provisioning document.
  */
 #define PCD_SP_SIZE 128u
+/**
+ * PCD write payload data size. The value is mentioned in section 4.2 and Table
+ * 45 of provisioning document.
+ */
+#define PCD_WP_SIZE 64u
 /**
  * PCD dimm partition size.The value is mentioned in section 3 figure 31 of
  * provisioning document.
@@ -157,4 +198,21 @@ static const char *const pcd_status_str[] = {
  * in section 4.1 Table 42 of provisioning document.
  */
 #define PCD_OPCODE_GET_PCD ((u16)0x0601)
+/**
+ * The opcode value for set pcd vendor specific command. The value is mentioned
+ * in section 4.2 Table 45 of provisioning document.
+ */
+#define PCD_OPCODE_SET_PCD ((u16)0x0701)
+/**
+ * Defines for PCD revision values
+ */
+#define PCD_REV_0_1 ((u8)0x01)
+#define PCD_REV_0_2 ((u8)0x02)
+#define PCD_REV_1_0 ((u8)0x10)
+#define PCD_REV_1_2 ((u8)0x12)
+/**
+ * Define for header type value for Partition Size Change Table. The value is
+ * mentioned in Table 37 of provisioning document.
+ */
+#define PSCT_TYPE ((u16)0x4)
 #endif /* _PCD_H_ */
diff --git a/pcdctl/pcdctl.c b/pcdctl/pcdctl.c
index 17607ac..6f6380a 100644
--- a/pcdctl/pcdctl.c
+++ b/pcdctl/pcdctl.c
@@ -51,6 +51,7 @@ static int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx)
 static struct cmd_struct commands[] = {
 	{ "version", { cmd_version } },
 	{ "list", { cmd_list } },
+	{ "reconfigure-region", { cmd_reconfigure_region } },
 	{ "help", { cmd_help } },
 };
 
diff --git a/pcdctl/reconfigure.c b/pcdctl/reconfigure.c
index 1b405f7..72385f9 100644
--- a/pcdctl/reconfigure.c
+++ b/pcdctl/reconfigure.c
@@ -6,9 +6,53 @@
 #include <reconfigure.h>
 #include <stdlib.h>
 #include <ccan/minmax/minmax.h>
+#include <util/parse-options.h>
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <pcat.h>
+#include <list.h>
+
+static struct reconfigure_param {
+	const char *bus;
+	bool verbose;
+	const char *mode;
+} param;
+static const struct option reconfigure_options[] = {
+	OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by <bus-id>"),
+	OPT_BOOLEAN('v', "verbose", &param.verbose, "turn on debug"),
+	OPT_STRING('m', "mode", &param.mode, "mode", "reconfigure region mode"),
+	OPT_END()
+};
 
 /**
- * The location of the configuration input in the pcd partition
+ * Return the Configuration Header revision based on pcat revision.
+ * 0.1: Used with PCAT revision 0.2
+ * 1.2: Used with PCAT revision 1.2
+ * The configuration header contains pointers to the current configuration,
+ * configuration input, and configuration output. Its structure and fields are
+ * described in Section 3.1 and Table 31 in provisioning document
+ */
+static inline u8 get_cfg_header_revision(u8 pcat_revision)
+{
+	return pcat_revision > PCD_REV_0_2 ? PCD_REV_1_2 : PCD_REV_0_1;
+}
+
+/**
+ * Return the PCD table revision based on config header revision.
+ * 0.2: Used with config header revision 0.1
+ * 1.2: Used with PCAT revision 1.2
+ * Current configuration, configuration input, and configuration output contain
+ * revision fields. The structures and fields are described in Table 32, Table
+ * 33 and Table 34 in provisioning document.
+ */
+static inline u8 get_pcd_table_revision(u8 cfg_header_revision)
+{
+	return cfg_header_revision > PCD_REV_1_0 ? PCD_REV_1_2 : PCD_REV_0_2;
+}
+
+/**
+ * The location of the configuration input(cin) in the pcd partition
  * is determined by configuration input start offset field. The
  * field is described in Section 3.1 and Table 31 in provisioning
  * document
@@ -19,7 +63,7 @@ static struct pcd_cin *get_cin(struct pcd_config_header const *c)
 }
 
 /**
- * The location of the current configuration in the pcd partition
+ * The location of the current configuration(ccur) in the pcd partition
  * is determined by current configuration start offset field. The
  * field is described in Section 3.1 and Table 31 in provisioning
  * document
@@ -30,7 +74,7 @@ static struct pcd_ccur *get_ccur(struct pcd_config_header const *c)
 }
 
 /**
- * The location of the configuration output in the pcd partition
+ * The location of the configuration output(cout) in the pcd partition
  * is determined by configuration output start offset field. The
  * field is described in Section 3.1 and Table 31 in provisioning
  * document
@@ -40,6 +84,154 @@ static struct pcd_cout *get_cout(struct pcd_config_header const *c)
 	return (struct pcd_cout *)((u8 *)c + c->cout_offset);
 }
 
+/**
+ * Determine the max bytes to write in PCD based on number of bytes
+ * read (pcd_length) and the size of the new tables (buf_length) to be written.
+ */
+static u32 set_pcd_length(u32 pcd_length, u32 buf_length)
+{
+	u32 length = 0;
+
+	/**
+	 * Here the total of read PCD length and size of new tables is rounded
+	 * down to MAX_PCD_SIZE and rounded up to PCD_SP_SIZE multiple. These
+	 * values are mentioned in section 3 figure 31 and section 4.1 of
+	 * provisioning document.
+	 */
+	length = pcd_length + buf_length;
+	length = length > MAX_PCD_SIZE ? MAX_PCD_SIZE : length;
+	if (length % PCD_SP_SIZE != 0) {
+		length = length + PCD_SP_SIZE - (length % PCD_SP_SIZE);
+		length = length > MAX_PCD_SIZE ? MAX_PCD_SIZE : length;
+	}
+	return length;
+}
+
+/**
+ * When creating a new request a new configuration input(cin) table needs to be
+ * created. This table can be placed at the end of ccur or between current
+ * configuration and configuration header if the gap is big enough
+ */
+static u32 calc_cin_offset(u32 ccur_offset, u32 ccur_size, u32 buf_length)
+{
+	u32 offset = 0;
+	u32 total_length = buf_length + sizeof(struct pcd_cin);
+	u32 space = ccur_offset - sizeof(struct pcd_config_header);
+
+	/**
+	 * Here space is the gap between configuration header and current
+	 * configuration. Total length is the size of the new configuration
+	 * input table and the extension tables to be written for the new
+	 * request. See section 5 in provisioning document for examples
+	 * on how pcd is structured for new requests.
+	 */
+	if (space > total_length)
+		offset = sizeof(struct pcd_config_header);
+	else
+		offset = ccur_offset + ccur_size;
+	return offset;
+}
+
+/**
+ * Given an empty buffer, its length and size of new tables to be written for
+ * a request. Initialize the buffer based on the read pcd. The configuration
+ * header and current configuration have to be copied over to the new buffer.
+ * Some values of configuration input can be set to default values. Section 3
+ * and Section 5 in provisioning document explain the fields and have examples
+ * of pcd when a new request is created.
+ */
+static void init_pcd(struct pcd_config_header const *buf, u32 set_pcd_length,
+		     u32 cin_length, struct pcd_config_header *ch)
+{
+	struct pcd_cin *cin = NULL;
+	struct pcd_cout *cout = NULL;
+
+	/**
+	 * The steps to initialize pcd from read pcd are as follows
+	 * 1) Copy configuration header
+	 * 2) Copy current configuraiton if it exists
+	 * 3) Update the revision, configuration input data size and
+	 *    configuration input offset fields
+	 * 4) Zero out configuration output data size and configuration
+	 *    offset fields
+	 * 5) Copy header section of configuration header to configuration
+	 *    input table
+	 * 6) Initialize signature, length, revision, id fields and sequence of
+	 *    configuration input table
+	 * Section 3 and Section 5 in provisioning document explain the fields
+	 * and have examples of pcd when a new request is created.
+	 */
+	memset(ch, 0, set_pcd_length);
+	/* copy over config header */
+	memcpy(ch, buf, sizeof(struct pcd_config_header));
+	/* copy over ccur */
+	if (ch->ccur_data_size > 0)
+		memcpy(((char *)ch + ch->ccur_offset),
+		       ((char *)buf + ch->ccur_offset), ch->ccur_data_size);
+	ch->header.revision = get_cfg_header_revision(get_pcat_rev());
+	ch->cin_data_size = sizeof(struct pcd_cin) + cin_length;
+	ch->cin_offset = calc_cin_offset(ch->ccur_offset, ch->ccur_data_size,
+					 cin_length);
+	ch->cout_data_size = 0;
+	ch->cout_offset = 0;
+	cin = get_cin(ch);
+	/* prefill cin with ch header */
+	memcpy(cin, ch, sizeof(struct acpi_header));
+	memcpy(&cin->header.signature, "CIN_", 4);
+	cin->header.length = sizeof(struct pcd_cin) + cin_length;
+	cin->header.revision = get_pcd_table_revision(ch->header.revision);
+	memcpy(&cin->header.asl_id, "PCDC", 4);
+	cin->header.asl_revision = 1;
+	/**
+	 * The sequence value is 1 if no configuration output table exists or
+	 * one more than sequence value of configuration output table
+	 */
+	cin->sequence = 1;
+	if (buf->cout_data_size > 0) {
+		cout = get_cout(buf);
+		cin->sequence = cout->sequence + 1;
+	}
+}
+
+/**
+ * This helper function provides the location after configuration input (cin)
+ * table. New tables listed in section 3.5 of provisioning document can
+ * be placed at this location.
+ */
+static void *get_cin_tables_start(struct pcd_config_header const *c)
+{
+	return (void *)(get_cin(c) + 1);
+}
+
+/**
+ * This helper function fills the fields of the partition size change table
+ * (psct). The structure and the fields are described in section 3.7 of the
+ * provisioning document.
+ */
+static void fill_psct(struct pcd_psct *psct, const u64 size)
+{
+	psct->type = PSCT_TYPE;
+	psct->length = sizeof(struct pcd_psct);
+	psct->status = 0;
+	psct->size = size;
+}
+
+/**
+ * Update the checksum fields in the configuration input and configuration
+ * header. These fields are described in Table 31 and Table 33 of provisioning
+ * document.
+ */
+static void finalize_pcd(struct pcd_config_header *ch)
+{
+	struct pcd_cin *cin = NULL;
+
+	cin = get_cin(ch);
+	cin->header.checksum = 0;
+	cin->header.checksum = acpi_checksum(cin, cin->header.length);
+	ch->header.checksum = 0;
+	ch->header.checksum = acpi_checksum(ch, ch->header.length);
+}
+
 /**
  * To determine if a reconfiguration request is pending we can look at
  * configuration input data size and sequence number fields.
@@ -69,9 +261,9 @@ static bool is_pcd_reconfigure_pending(struct pcd_config_header const *ch)
 }
 
 /**
- * Map the current configuration status value to human readable strings. The
- * current configuration status field is described in Section 3.2 and Table 32
- * in provisioning document
+ * Map the current configuration (ccur) status value to human readable strings.
+ * The current configuration status field is described in Section 3.2 and
+ * Table 32 in provisioning document
  */
 static const char *get_ccur_status_string(struct pcd_config_header const *ch)
 {
@@ -92,8 +284,8 @@ static const char *get_ccur_status_string(struct pcd_config_header const *ch)
 }
 
 /**
- * Get configuration status field from current configuration structure. The
- * field is described in Section 3.2 and Table 32 in provisioning document
+ * Get configuration status field from current configuration(ccur) structure.
+ * The field is described in Section 3.2 and Table 32 in provisioning document
  */
 static int get_pcd_ccur_status(struct pcd_config_header const *ch)
 {
@@ -232,6 +424,45 @@ static int read_pcd(struct ndctl_dimm *dimm, struct pcd_config_header **pcd,
 	return 0;
 }
 
+/**
+ * Given ndctl dimm object ,a pcd buffer and its length write the pcd upto
+ * to the dimm using set pcd vendor specific command. The structure of command
+ * and its fields are described in section 4.2 and Table 45 in the provisioning
+ * specification document.
+ */
+static int write_pcd(struct ndctl_dimm *dimm, const char *buf, u32 buf_length)
+{
+	u32 op_code = 0;
+	char inp[PCD_SP_SIZE];
+	char op[PCD_SP_SIZE];
+	struct pcd_set_pcd_input *in = NULL;
+	int ret = 0;
+
+	memset(inp, 0, PCD_SP_SIZE);
+	memset(op, 0, PCD_SP_SIZE);
+	in = (struct pcd_set_pcd_input *)inp;
+	in->partition_id = 1;
+	in->payload_type = 1;
+	in->offset = 0;
+	op_code = cpu_to_be16(PCD_OPCODE_SET_PCD);
+	while (buf_length > 0) {
+		/**
+		 * Write PCD_WP_SIZE bytes of pcd in every iteration. The value
+		 * is mentioned in section 4.2 and Table 45 of provisioning
+		 * document.
+		 */
+		memcpy(in->data, buf + in->offset, PCD_WP_SIZE);
+		ret = execute_vendor_specific_cmd(dimm, op_code, inp,
+						  PCD_SP_SIZE, op, PCD_SP_SIZE);
+		if (ret)
+			return ret;
+		in->offset = in->offset + PCD_WP_SIZE;
+		buf_length =
+			buf_length < PCD_WP_SIZE ? 0 : buf_length - PCD_WP_SIZE;
+	}
+	return 0;
+}
+
 /**
  * Validate checksum field of configuration header.
  */
@@ -377,3 +608,146 @@ out:
 	free(buf);
 	return status;
 }
+
+/**
+ * Given a dimm object read its pcd and create a pcd structure with a
+ * configuration input table that requests creation of volatile region.
+ * To create the request a new Configuration input table and Partition size
+ * change table are to be added the pcd and existing configuration output
+ * table is removed. Section 5.1 in provisioning document provides an example
+ * pcd when creating this request.
+ * PCD Partition ID 1 - Configuration management usage (64KB)
+ *
+ * +-------------+	+---------------------+    +---------------+
+ * |		 +----->│Current Configuration+--->│Extension table│
+ * |Configuration|	+---------------------+    +---------------+
+ * │	Header	 |	+---------------------+    +---------------------------+
+ * │		 +----->│ Configuration Input +--->│Partition Size Change table│
+ * +-------------+	+---------------------+    +---------------------------+
+ */
+static int reconfigure_volatile(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	u32 length = 0;
+	struct pcd_config_header *ch = NULL;
+	struct pcd_psct *psct = NULL;
+	int ret = 0;
+	u32 pcd_size = read_pcd_size(dimm);
+
+	/**
+	 * Here are the steps to create a 100% memory mode request
+	 * 1) Read current pcd
+	 * 2) Copy configuration header, current configuration tables to a new
+	 *    pcd
+	 * 3) Create the Configuration input table and partition size change
+	      table and add them to the pcd
+	 * 4) Write the new pcd.
+	 * The value of persistent memory partition size in the partition size
+	 * change table is set to 0 to indicate that all memory is to be used
+	 * memory mode. Section 5.1 in provisioning document provides an
+	 * example pcd when creating this request.
+	 */
+	if (!pcd_size)
+		goto out;
+	buf = (struct pcd_config_header *)calloc(pcd_size, sizeof(char));
+	if (!(buf))
+		goto out;
+	ret = read_pcd(dimm, &buf, pcd_size);
+	if (ret != 0)
+		goto out;
+	/**
+	 * Create new partition size change table for memory mode. The length
+	 * of pcd to be written would depend on sum of read pcd size and length
+	 * of psct table for 100% memory mode request. The configuration input
+	 * table would take the same space as zeroed out configuration output
+	 * table from read pcd. Section 5.1 in provisioning document provides
+	 * an example pcd when creating this request.
+	 */
+	length = sizeof(struct pcd_psct);
+	pcd_size = set_pcd_length(pcd_size, length);
+	ch = malloc(pcd_size);
+	if (!ch) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	init_pcd(buf, pcd_size, length, ch);
+	psct = (struct pcd_psct *)get_cin_tables_start(ch);
+	fill_psct(psct, 0);
+	finalize_pcd(ch);
+	ret = write_pcd(dimm, (char *)ch, pcd_size);
+out:
+	free(buf);
+	free(ch);
+	return ret;
+}
+
+/**
+ * Given the mode option perform the region reconfiguration action on
+ * the dimm object
+ */
+static int do_reconfigure(struct ndctl_dimm *dimm, const char *mode)
+{
+	if (!mode)
+		return -EOPNOTSUPP;
+	if (strncmp(mode, "ram", 3) == 0)
+		return reconfigure_volatile(dimm);
+	return -EOPNOTSUPP;
+}
+
+/**
+ * Function to implement region reconfiguration command based on user
+ * options
+ */
+int cmd_reconfigure_region(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	struct ndctl_bus *bus = NULL;
+	struct json_object *j_dimms = NULL;
+	u32 n_obj = 0;
+	int i, ret = 0;
+	char *usage = "pcdctl reconfigure-region [<options>]";
+	const char *const u[] = { usage, NULL };
+
+	argc = parse_options(argc, argv, reconfigure_options, u, 0);
+	if (param.verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+	for (i = 1; i < argc; i++)
+		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
+	if (argc > 1) {
+		usage_with_options(u, reconfigure_options);
+		return -EOPNOTSUPP;
+	}
+	ret = validate_pcat_rev();
+	if (ret) {
+		fprintf(stderr, "error: Invalid pcat revision %u\n",
+			get_pcat_rev());
+		return ret;
+	}
+	j_dimms = json_object_new_array();
+	if (!j_dimms)
+		return -ENOMEM;
+	ndctl_bus_foreach(ctx, bus) {
+		struct ndctl_dimm *dimm = NULL;
+
+		if (!util_bus_filter(bus, param.bus))
+			continue;
+		if (!ndctl_bus_has_nfit(bus))
+			continue;
+		ndctl_dimm_foreach(bus, dimm) {
+			struct json_object *j_dimm = NULL;
+
+			ret = do_reconfigure(dimm, param.mode);
+			if (ret) {
+				fprintf(stderr, "error: %s on dimm: %u\n",
+					strerror(ret), n_obj);
+				return ret;
+			}
+			j_dimm = pcdctl_list_dimm_to_json(dimm);
+			if (j_dimm)
+				json_object_array_add(j_dimms, j_dimm);
+			n_obj++;
+		}
+	}
+	util_display_json_array(stdout, j_dimms, 0);
+	fprintf(stderr, "%u nmems reconfig submitted\n", n_obj);
+	return 0;
+}
-- 
2.20.1

