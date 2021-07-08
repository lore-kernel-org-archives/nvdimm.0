Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5B72FB8
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 18:37:56 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231332274"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="231332274"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="411017446"
Received: from janandra-mobl.amr.corp.intel.com ([10.251.31.93])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:37:54 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v1 4/4] pcdctl/reconfigure: Add support for pmem and iso-pmem modes
Date: Thu,  8 Jul 2021 11:37:41 -0700
Message-Id: <20210708183741.2952-5-james.sushanth.anandraj@intel.com>
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

Implement pcdctl-reconfigure-region pmem and iso-pmem support.
This patch adds helper functions to support processing of pmem
and iso-pmem reconfigure-region requests. The pmem
reconfigure-region request results in regions that
does not utilize hardware interleaving across non-volatile memory
devices. The iso-pmem request results in regions that
utilize hardware interleaving. The command reads
pcd data from the 'nvdimm' devices and writes a new pcd reflecting
the new region reconfiguration request.

Signed-off-by: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
---
 pcdctl/pcd.h         | 163 ++++++++++
 pcdctl/reconfigure.c | 709 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 870 insertions(+), 2 deletions(-)

diff --git a/pcdctl/pcd.h b/pcdctl/pcd.h
index e16c1e0..dccc03e 100644
--- a/pcdctl/pcd.h
+++ b/pcdctl/pcd.h
@@ -26,6 +26,11 @@
  *	 │		+---------------------+    +---------------+
  *	 +------------->│Configuration Output +--->│Extension table│
  *			+---------------------+    +---------------+
+ *
+ * The extension table for Configuration Input is determined by the region
+ * reconfiguration request. See section 5 in provisioning document for examples
+ * for each request type.
+ *
  * Glossary
  * --------
  * PCD - Platform Configuration Data
@@ -34,6 +39,11 @@
  * CIN - Configuration Input
  * COUT - Configuration Output
  * PSCT - Partition Size Change Table
+ * IIT - Interleave Information Table
+ * MIIIS - Module Identification Information for Interleave Set
+ * MUI - Module Unique Identifier
+ * ML - Module location
+ * MPIO - Module partition information output
  */
 /**
  * struct pcd_config_header - configuration header
@@ -130,6 +140,136 @@ struct pcd_psct {
 	u32 status;
 	u64 size;
 } __attribute__((packed));
+/**
+ * struct pcd_mui - module unique identifier
+ * @id: subsystem vendor id
+ * @location: manufacturing location
+ * @date: manufacturing date
+ * @serial: serial number
+ * The module unique identifier is a field in module identification information
+ * for interleave set. The field and its sub-fields are described in section
+ * 3.8.1.1 Table 311 in the provisioning specification document.
+ */
+struct pcd_mui {
+	u16 id;
+	u8 location;
+	u16 date;
+	u32 serial;
+} __attribute__((packed));
+/**
+ * struct pcd_ml - module location
+ * @socket_id: module socket id
+ * @die_id: module die id
+ * @mem_controller_id: module memory controller id
+ * @channel_id: memory channel number
+ * @slot_id: dimm number
+ * @r: reserved
+ * The module location is a field in module identification information for
+ * interleave set. The field and its sub-fields are described in section
+ * 3.8.1.1 Table 311 in the provisioning specification document.
+ */
+struct pcd_ml {
+	u8 socket_id;
+	u8 die_id;
+	u8 mem_controller_id;
+	u8 channel_id;
+	u8 slot_id;
+	u8 r[3];
+} __attribute__((packed));
+/**
+ * struct pcd_miiis - module identification information for interleave set
+ * @mui: module unique identifier
+ * @ml: module location only used in pcat v1.2
+ * @r: reserved
+ * @offset: partition offset
+ * @size: partition size
+ * The module identification information for interleave set is used for
+ * identifying the modules that are present in the interleave set.
+ * The structure and fields of table are described in section 3.8.1.1 Table 310
+ * and Table 311 in the provisioning specification document.
+ */
+struct pcd_miiis {
+	struct pcd_mui mui;
+	struct pcd_ml ml;
+	u8 r[15];
+	u64 offset;
+	u64 size;
+} __attribute__((packed));
+/**
+ * struct pcd_iit - interleave information table (type 5)
+ * @type: table type
+ * @length: length in bytes for the entire table
+ * @index: interleave set index
+ * @modules: number of modules in interleave set
+ * @itype: interleave memory type
+ * @isize: interleave size
+ * @iways: interleave ways - this field is ignore for pcat v1.2
+ * @r1: reserved
+ * @status: interleave change status
+ * @r2: reserved
+ * The interleave information table describes a interleave set. The structure
+ * and fields of the table are described in section 3.8 Table 38 and 39 in the
+ * provisioning specification document
+ */
+struct pcd_iit {
+	u16 type;
+	u16 length;
+	u16 index;
+	u8 modules;
+	u8 itype;
+	u16 isize;
+	u16 iways;
+	u8 r1;
+	u8 status;
+	u8 r2[10];
+} __attribute__((packed));
+/**
+ * struct nfit_handle - nfit handle
+ * @dimm: dimm number
+ * @mem_chnl: memory channel number
+ * @mem_ctrlr: memory controller id
+ * @socket_id: socket id
+ * @node: node id
+ * @r: reserved
+ * @value: unsigned value
+ * This structure is used to unpack the subfields of the dimm handle.
+ */
+struct nfit_handle {
+	union {
+		struct {
+			u8 dimm : 4;
+			u8 mem_chnl : 4;
+			u8 mem_ctrlr : 4;
+			u8 socket_id : 4;
+			u16 node : 12;
+			u8 r : 4;
+		} __attribute__((packed));
+		u32 value;
+	};
+} __attribute__((packed));
+/**
+ * struct pcd_mpio - module partition information output payload
+ * @volatile_capacity: volatile capacity
+ * @r1: reserved
+ * @volatile_start: volatile start location
+ * @persistent_capacity: persistent capacity
+ * @r2: reserved
+ * @persistent_start: persistent start location
+ * @raw_capacity: raw capacity
+ * The structure represents the output parameters of get module partition
+ * information vendor specific command. The structure and its fields are
+ * described in section 4.3 and Table 48 in the provisioning specification
+ * document.
+ */
+struct pcd_mpio {
+	u32 volatile_capacity;
+	u8 r1[4];
+	u64 volatile_start;
+	u32 persistent_capacity;
+	u8 r2[4];
+	u64 persistent_start;
+	u32 raw_capacity;
+} __attribute__((packed));
 /**
  * struct pcd_get_pcd_input - get pcd input
  * @partition_id: partition id
@@ -203,6 +343,12 @@ static const char *const pcd_status_str[] = {
  * in section 4.2 Table 45 of provisioning document.
  */
 #define PCD_OPCODE_SET_PCD ((u16)0x0701)
+/**
+ * The opcode value for get module partition information vendor specific
+ * command. The value is mentioned in section 4.3 Table 447 of provisioning
+ * document.
+ */
+#define PCD_OPCODE_GET_MPI ((u16)0x0602)
 /**
  * Defines for PCD revision values
  */
@@ -215,4 +361,21 @@ static const char *const pcd_status_str[] = {
  * mentioned in Table 37 of provisioning document.
  */
 #define PSCT_TYPE ((u16)0x4)
+/**
+ * Define for header type value for Interleave Information Table. The value is
+ * mentioned in Table 38 of provisioning document.
+ */
+#define IIT_TYPE ((u16)0x5)
+/**
+ * Define for interleave memory type field app direct mode value in Interleave
+ * information table. The value is mentioned in Table 38 of provisioning
+ * document.
+ */
+#define APP_DIRECT_MODE ((u8)0x2)
+/**
+ * Define for interleave size field value in Interleave information table.
+ * The value is mentioned in Table 38 of provisioning document.
+ */
+#define INTERLEAVE_SIZE ((u16)0x4040)
+
 #endif /* _PCD_H_ */
diff --git a/pcdctl/reconfigure.c b/pcdctl/reconfigure.c
index 72385f9..d8389a7 100644
--- a/pcdctl/reconfigure.c
+++ b/pcdctl/reconfigure.c
@@ -9,6 +9,7 @@
 #include <util/parse-options.h>
 #include <util/json.h>
 #include <util/filter.h>
+#include <util/bitmap.h>
 #include <json-c/json.h>
 #include <pcat.h>
 #include <list.h>
@@ -25,6 +26,20 @@ static const struct option reconfigure_options[] = {
 	OPT_END()
 };
 
+/**
+ * Global interleave set linked list pointer. This stores the different
+ * interleave sets for the system. The interleave sets are ordered by socket
+ * id of the dimms in the interleave set. Within a set the dimms are ordered
+ * as they would in module identification information field. See Section 3.8
+ * Table 38 in provisioning document for more information on this field.
+ */
+static struct ndctl_dimm **iset_list;
+/**
+ * Global variable to store number of dimms in the interleave set linked list.
+ * It should be equal to the number of dimms in the system.
+ */
+static u32 iset_count;
+
 /**
  * Return the Configuration Header revision based on pcat revision.
  * 0.1: Used with PCAT revision 0.2
@@ -216,6 +231,125 @@ static void fill_psct(struct pcd_psct *psct, const u64 size)
 	psct->size = size;
 }
 
+/**
+ * The first module identification information for interleave set structure
+ * comes immediately after the location of interleave information table
+ * in PCD. These structures are explained in Section 3.8 Table 38, 39 and
+ * Section 3.8.1.1 Table 310, 311 of the provisioning document
+ */
+static struct pcd_miiis *get_miiis(struct pcd_iit const *i)
+{
+	return (struct pcd_miiis *)(i + 1);
+}
+
+/**
+ * Helper function to convert raw capacity in GiB to bytes. The Persistent
+ * memory partition size field of partition size change table needs to be
+ * filled as bytes. See section 3.7 Table 37 of the provisioning document.
+ */
+static u64 raw_capacity_to_bytes(u32 raw_capacity)
+{
+	u64 capacity = raw_capacity;
+
+	return capacity << 12;
+}
+
+/**
+ * Helper function to align byte to 1-GiB. The partition size field in module
+ * identification information for Interleave set needs to be filled in as bytes
+ * aligned to 1-GiB size. See section 3.8.1.1 Table 310 and 311 of the
+ * provisioning docuement.
+ */
+static inline u64 align_to_gb(u64 byte)
+{
+	return (byte >> 30) << 30;
+}
+
+/**
+ * Helper function to get the Interleave ways field value of Interleave
+ * information table , given number of modules in interleave set. See section
+ * 38 Table 38 of the provisioning document
+ */
+static u32 get_interleave_ways(u32 m_count)
+{
+	u32 i;
+	/**
+	 * The array has the number of modules in the interleave set given a
+	 * index position. The index position is used to determine the bit to
+	 * be set for the interleave ways field. See section 38 Table 38 of the
+	 * provisioning document
+	 */
+	u32 i_ways[] = { 1, 2, 3, 4, 6, 8, 12, 16, 24 };
+
+	/**
+	 * Search the array to find the index position the number of modules
+	 * is at. Return BIT(index) as the interleave ways field value. See
+	 * section 38 Table 38 of the provisioning document
+	 */
+	for (i = 0; i < 9; i++)
+		if (i_ways[i] == m_count)
+			return BIT(i);
+	return 0;
+}
+
+/**
+ * This helper function fills the fields of the interleave information table
+ * (iit). The structure and the fields are described in section 3.8 Table 38
+ * of the provisioning document.
+ */
+static void fill_iit(struct pcd_iit *iit, u8 modules, u16 index)
+{
+	iit->type = IIT_TYPE;
+	iit->length =
+		sizeof(struct pcd_iit) + (modules * sizeof(struct pcd_miiis));
+	iit->index = index;
+	iit->modules = modules;
+	iit->itype = APP_DIRECT_MODE;
+	iit->isize = INTERLEAVE_SIZE;
+	/**
+	 * This field is only present in 0.2 version of the interleave
+	 * information table. In version 1.2 the field becomes reserved
+	 * See section 3.8 Table 38 of the provisioning document
+	 */
+	iit->iways =
+		get_pcat_rev() < PCD_REV_1_0 ? get_interleave_ways(modules) : 0;
+}
+
+/**
+ * This helper function fills the fields of the module identification
+ * information for interleave set table (miiis). The structure and the
+ * fields are described in section 3.8.1.1 Table 310, 311
+ * of the provisioning document.
+ */
+static void fill_miiis(struct ndctl_dimm *dimm, struct pcd_miiis *m,
+		       u8 revision, u64 size)
+{
+	struct nfit_handle n_handle;
+
+	m->mui.id = ndctl_dimm_get_vendor(dimm);
+	m->mui.id = cpu_to_be16(m->mui.id);
+	m->mui.location = ndctl_dimm_get_manufacturing_location(dimm);
+	m->mui.date = ndctl_dimm_get_manufacturing_date(dimm);
+	m->mui.date = cpu_to_be16(m->mui.date);
+	m->mui.serial = ndctl_dimm_get_serial(dimm);
+	m->mui.serial = cpu_to_be32(m->mui.serial);
+	m->offset = 0;
+	m->size = size;
+	n_handle.value = ndctl_dimm_get_handle(dimm);
+	/**
+	 * The module location field only exists in v1.2 of the table
+	 * In v0.2 the field is reserved. See section 3.8.1.1 Table 311
+	 * of the provisioning document
+	 */
+	if (revision > PCD_REV_1_0) {
+		m->ml.socket_id = n_handle.socket_id;
+		m->ml.die_id = 0;
+		m->ml.mem_controller_id = n_handle.mem_ctrlr;
+		m->ml.channel_id = n_handle.mem_chnl;
+		m->ml.slot_id = n_handle.dimm;
+	}
+}
+
 /**
  * Update the checksum fields in the configuration input and configuration
  * header. These fields are described in Table 31 and Table 33 of provisioning
@@ -463,6 +597,30 @@ static int write_pcd(struct ndctl_dimm *dimm, const char *buf, u32 buf_length)
 	return 0;
 }
 
+/**
+ * Given the ndctl dimm object obtain the module partition information
+ * output structure by using a vendor specific command. See section 4.3
+ * Table 47 and 48 for more information on the command and the structure
+ * and field information of command input and output.
+ */
+static int get_module_partition_info(struct ndctl_dimm *dimm,
+				     struct pcd_mpio *buf)
+{
+	u32 op_code = 0;
+	char inp[PCD_SP_SIZE];
+	char op[PCD_SP_SIZE];
+
+	memset(buf, 0, sizeof(struct pcd_mpio));
+	memset(inp, 0, PCD_SP_SIZE);
+	memset(op, 0, PCD_SP_SIZE);
+	op_code = cpu_to_be16(PCD_OPCODE_GET_MPI);
+	if (execute_vendor_specific_cmd(dimm, op_code, inp, PCD_SP_SIZE, op,
+					PCD_SP_SIZE) != 0)
+		return -ENOTTY;
+	memcpy(buf, op, sizeof(struct pcd_mpio));
+	return 0;
+}
+
 /**
  * Validate checksum field of configuration header.
  */
@@ -609,6 +767,323 @@ out:
 	return status;
 }
 
+static u8 get_socket_id(struct ndctl_dimm *dimm)
+{
+	struct nfit_handle n_handle;
+
+	n_handle.value = ndctl_dimm_get_handle(dimm);
+	return n_handle.socket_id;
+}
+
+static int compare_dimm_socket(const void *p1, const void *p2)
+{
+	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
+	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
+	u8 sid1 = get_socket_id(dimm1);
+	u8 sid2 = get_socket_id(dimm2);
+
+	return sid1 - sid2;
+}
+
+static int compare_dimm_iset_parity(const void *p1, const void *p2)
+{
+	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
+	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
+	struct nfit_handle n_handle;
+	u32 order1 = 0;
+	u32 order2 = 0;
+
+	n_handle.value = ndctl_dimm_get_handle(dimm1);
+	/**
+	 * For six-way interleave sets (which can occur in sockets that have
+	 * two iMCs, each with three channels), the order is determined as
+	 * follows: Modules are first ordered by
+	 * “(channel number + iMC number) modulus 2”
+	 * and then ordered by channel number. See section 3.8 Table 38 of the
+	 * provisioning document.
+	 */
+	order1 = n_handle.socket_id << 8 |
+		 (n_handle.mem_chnl + n_handle.mem_ctrlr) % 2 << 4 |
+		 n_handle.mem_chnl;
+	n_handle.value = ndctl_dimm_get_handle(dimm2);
+	order2 = n_handle.socket_id << 8 |
+		 (n_handle.mem_chnl + n_handle.mem_ctrlr) % 2 << 4 |
+		 n_handle.mem_chnl;
+	return order1 - order2;
+}
+
+static int compare_dimm_iset(const void *p1, const void *p2)
+{
+	struct ndctl_dimm *dimm1 = *(struct ndctl_dimm **)p1;
+	struct ndctl_dimm *dimm2 = *(struct ndctl_dimm **)p2;
+	struct nfit_handle n_handle;
+	u32 order1 = 0;
+	u32 order2 = 0;
+
+	n_handle.value = ndctl_dimm_get_handle(dimm1);
+	/**
+	 * In interleave set the modules are first ordered by channel number
+	 * and then ordered by iMC number. See section 3.8 Table 38 of the
+	 * provisioning document.
+	 */
+	order1 = n_handle.socket_id << 8 | n_handle.mem_chnl << 4 |
+		 n_handle.mem_ctrlr;
+	n_handle.value = ndctl_dimm_get_handle(dimm2);
+	order2 = n_handle.socket_id << 8 | n_handle.mem_chnl << 4 |
+		 n_handle.mem_ctrlr;
+	return order1 - order2;
+}
+
+/**
+ * Helper function to rearrange dimms in the global interleave set dimm array
+ * with the same socket id into the order in which they would be in an
+ * module identification information field. See Section 3.8 Table 38 in
+ * provisioning document for more information on this field.
+ */
+static void rearrange_iset(u32 loc)
+{
+	static u8 tsocket;
+	static u32 dcount;
+	u8 csocket = 0;
+
+	/**
+	 * Here are the steps
+	 * 1) Check if there is dimm in the location
+	 * 2) If first location store the socket id
+	 * 3) If the socket id is same as stored socket id increment dcount
+	 * 4) If new socket id is seen one interleave set is complete and
+	 *    can be sorted
+	 * 5) Reset dcount and stored socket id for next interleave set
+	 */
+	if (iset_list[loc]) {
+		csocket = get_socket_id(iset_list[loc]);
+		if (loc == 0)
+			tsocket = csocket;
+		if (tsocket == csocket)
+			dcount++;
+	}
+	if (!iset_list[loc] || csocket != tsocket) {
+		/* All devices within the socket have been found */
+		if (dcount == 6)
+			qsort(&iset_list[loc - dcount], dcount,
+			      sizeof(struct ndctl_dimm *),
+			      compare_dimm_iset_parity);
+		else
+			qsort(&iset_list[loc - dcount], dcount,
+			      sizeof(struct ndctl_dimm *), compare_dimm_iset);
+		dcount = 1;
+		tsocket = csocket;
+	}
+}
+
+/**
+ * Helper function to initialize in the global interleave set dimm array
+ * with dimms sorted first in increasing order of socket id. Dimms with same
+ * socket id belong to same interleave set. Within each interleave set the
+ * are stored in order in which they would be in an
+ * module identification information field. See Section 3.8 Table 38 in
+ * provisioning document for more information on this field.
+ */
+static int initialize_adi(struct ndctl_dimm *dimm, u32 adcount)
+{
+	struct ndctl_bus *const bus = ndctl_dimm_get_bus((void *)dimm);
+	u32 i = 0;
+
+	/**
+	 * Here are the steps
+	 * 1) Do initialization, if this is the first dimm.
+	 * 2) Count number of dimms
+	 * 3) Create a global array with size number of dimms + 1
+	 * 4) Copy dimms into the global array and assign null to last element
+	 * 5) Sort the dimms by socket id to create interleave sets with dimms
+	 *    having the same socket id
+	 * 6) Run the helper function over all dimms to identify interleave sets
+	 *    and sort the dimms within an interleave set in order in which
+	 *    they would be in a module identification information field.
+	 *    See Section 3.8 Table 38 in provisioning document.
+	 */
+	if (adcount != 0)
+		return 0;
+	dimm = NULL;
+	ndctl_dimm_foreach((void *)bus, dimm) {
+		iset_count++;
+	}
+	iset_list = malloc((iset_count + 1) * sizeof(dimm));
+	if (!iset_list)
+		return -ENOMEM;
+	i = 0;
+	ndctl_dimm_foreach((void *)bus, dimm) {
+		iset_list[i++] = dimm;
+	}
+	iset_list[i] = NULL;
+	qsort(iset_list, iset_count, sizeof(dimm), compare_dimm_socket);
+	for (i = 0; i < iset_count + 1; i++)
+		rearrange_iset(i);
+	return 0;
+}
+
+/**
+ * Given a iset location, socket id of dimm, and previously returned
+ * interleave set dimm, see if the dimm in iset location can be returned
+ * as the next dimm in the interleave set
+ */
+static int check_next_iset_dimm(u32 loc, u8 sid, struct ndctl_dimm **b)
+{
+	struct ndctl_dimm *d = (void *)iset_list[loc];
+
+	/**
+	 * Here are the steps
+	 * 1) If previous returned dimm is null, return dimm at current
+	 *    iset location as the next dimm in interleave set.
+	 * 2) If previous returned dimm is at current iset location, check to
+	 *    see if dimm in next iset location exists and belongs to same
+	 *    iset (same socket id), if so return the dimm in loc + 1 as the
+	 *    next dimm in interleave set
+	 * 3) If dimm at loc + 1 does not exist or has different socket id. The
+	 *    end of interleave set is reached and return null as next dimm.
+	 * See Section 3.8 Table 38 in provisioning document for ordering a
+	 * interleave set.
+	 */
+	if (!(*b)) {
+		/* inp is null , return first elem */
+		*b = d;
+		return 0;
+	} else if (*b == d) {
+		/* reached last returned elem */
+		struct ndctl_dimm *dn = iset_list[loc + 1];
+
+		if (!dn) {
+			/* No more elements in isetlist */
+			*b = NULL;
+			return 0;
+		} else if (dn) {
+			/* Next element in isetlist present */
+			u8 isid = get_socket_id(dn);
+
+			if (isid != sid) {
+				/* No next element to return */
+				*b = NULL;
+				return 0;
+			} else if (isid == sid) {
+				/* Next element is same sid */
+				*b = dn;
+				return 0;
+			}
+		}
+	}
+	return -1;
+}
+
+/**
+ * Given a dimm object and a dimm in the interleave set b, get the
+ * next dimm in the same interleave set after b. If next dimm does not exist
+ * or belongs to another interleave set return null. If b is null then
+ * the first dimm in interleave set to which dimm object belongs is returned.
+ */
+static int get_next_iset_dimm(struct ndctl_dimm *dimm, struct ndctl_dimm **b)
+{
+	u8 sid = 0;
+	struct ndctl_dimm *di = NULL;
+	u32 i = 0;
+	int ret = 0;
+
+	/**
+	 * Here are the steps
+	 * 1) Get socket id of dimm
+	 * 2) Loop through dimms in global interleave set array till dimm of
+	 *    same socket id can be found.
+	 * 3) For each dimm of same socket id, call check_next_iset_dimm
+	 *    to see if the next dimm in global interleave set array should
+	 *    be returned as the next dimm in interleave set after dimm b
+	 * See Section 3.8 Table 38 in provisioning document for ordering a
+	 * interleave set.
+	 */
+	di = (void *)iset_list[0];
+	if (!b || !dimm || !di)
+		return -ENOTTY;
+	sid = get_socket_id(dimm);
+	while (di) {
+		u8 isid = 0;
+
+		isid = get_socket_id(di);
+		if (sid == isid) {
+			ret = check_next_iset_dimm(i, sid, b);
+			if (!ret)
+				return ret;
+		}
+		di = (void *)iset_list[++i];
+	}
+	*b = NULL;
+	return -1;
+}
+
+/**
+ * Given a dimm object, get the number of dimms in the interleave set to which
+ * it belongs. See Section 3.8 Table 38 in provisioning document for ordering a
+ * interleave set
+ */
+static int get_iset_dimm_count(struct ndctl_dimm *dimm, u32 *count)
+{
+	struct ndctl_dimm *d = NULL;
+	int ret = -1;
+
+	if (!count)
+		return ret;
+	*count = 0;
+	/**
+	 * Iterate through the dimms in the interleave set and keep count
+	 * of dimms. If next dimm in interleave set is NULL, then return count
+	 */
+	while (!(ret = get_next_iset_dimm(dimm, &d))) {
+		if (!d)
+			break;
+		*count = *count + 1;
+	}
+	return ret;
+}
+
+/**
+ * Given a dimm object calculate partition size field in module identification
+ * information for interleave set table. See section 3.8.1.1 Table 310 and 311
+ * of provisioning document.
+ */
+static u64 get_iset_psize(struct ndctl_dimm *dimm)
+{
+	struct ndctl_dimm *d = NULL;
+	int count = 0;
+	struct pcd_mpio mpio;
+	u64 i_size = 0;
+	u64 r_size = 0;
+	int ret = 0;
+
+	/**
+	 * Iterate over dimms in the same interleave set as dimm object and
+	 * return the lowest raw capacity aligned to 1gib
+	 */
+	while (!(ret = get_next_iset_dimm(dimm, &d))) {
+		if (!d)
+			break;
+		if (get_module_partition_info(d, &mpio) != 0)
+			break;
+		i_size = align_to_gb(raw_capacity_to_bytes(mpio.raw_capacity));
+		r_size = (count == 0) ? i_size : min(r_size, i_size);
+		count++;
+	}
+	return r_size;
+}
+
+/**
+ * Free the global interleave set array. Using the passed in count, free is
+ * called only after all dimms are processed for the reconfigure request.
+ */
+static void deinitialize_adi(u32 ad_count)
+{
+	if ((ad_count == iset_count || ad_count == 0) && iset_list) {
+		free(iset_list);
+		iset_list = NULL;
+	}
+}
+
 /**
  * Given a dimm object read its pcd and create a pcd structure with a
  * configuration input table that requests creation of volatile region.
@@ -681,6 +1156,234 @@ out:
 	return ret;
 }
 
+/**
+ * Given a dimm object read its pcd and create a pcd structure with a
+ * configuration input table that requests creation of
+ * non-interleaved region.
+ * To create the request a new Configuration input table, Partition size
+ * change table, interleave information table and module identification
+ * information for interleave set table are to be added the pcd .Existing
+ * configuration output table is removed.
+ * PCD Partition ID 1 - Configuration management usage (64KB)
+ *
+ * +-------------+	+---------------------+    +---------------+
+ * |		 +----->│Current Configuration+--->│Extension table│
+ * |Configuration|	+---------------------+    +---------------+
+ * │	Header	 |	+---------------------+    +--------------------------+
+ * │		 +----->│ Configuration Input +--->│ Request Extension tables │
+ * +-------------+	+---------------------+    +--------------------------+
+ *
+ * The request extension tables for non-interleaved regions are
+ * 1) Partition size change table (PSCT)
+ * 2) Interleave information table (IIT)
+ * 3) Module identification information for interleave set (MIIIS)
+ * These tables are placed one after another. Section 5.2 in provisioning
+ * document provides an example pcd when creating this request.
+ */
+static int reconfigure_adni(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	u32 length = 0;
+	struct pcd_mpio mpio;
+	struct pcd_config_header *ch = NULL;
+	struct pcd_psct *psct = NULL;
+	struct pcd_iit *iit = NULL;
+	struct pcd_miiis *m = NULL;
+	static u32 isi;
+	int ret = 0;
+	u64 msize = 0;
+	u32 pcd_size = read_pcd_size(dimm);
+
+	/**
+	 * Here are the steps to create a 100% memory mode request
+	 * 1) Read current pcd and module partition information
+	 * 2) Copy configuration header, current configuration tables to a new
+	 *    pcd
+	 * 3) Create the Configuration input table, partition size change
+	      table, interleave information table, module identification
+	      information for interleave set and add them to the pcd
+	 * 4) Write the new pcd.
+	 * The value of persistent memory partition size in the partition size
+	 * change table is set to raw capacity of the dimm to indicate that all
+	 * memory is to be used for interleave set. The number of modules in
+	 * interleave set field of interleave information table is set to 1 to
+	 * indicate there is no interleaving. Section 5.2 in provisioning
+	 * document provides an example pcd when creating this request.
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
+	 * For non-interleave request, The length of pcd table
+	 * to be written would depend on
+	 * 1) sum of read pcd size
+	 * 2) length of psct table
+	 * 3) length of iit table
+	 * 4) length of one miiis
+	 * The configuration input table would take the same space as zeroed
+	 * out configuration output table from read pcd. Section 5.2 in
+	 * provisioning document provides an example pcd when creating
+	 * this request.
+	 */
+	length = sizeof(struct pcd_psct) + sizeof(struct pcd_iit) +
+		 sizeof(struct pcd_miiis);
+	pcd_size = set_pcd_length(pcd_size, length);
+	ret = get_module_partition_info(dimm, &mpio);
+	if (ret != 0)
+		goto out;
+	ch = malloc(pcd_size);
+	if (!ch) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	init_pcd(buf, pcd_size, length, ch);
+	psct = (struct pcd_psct *)get_cin_tables_start(ch);
+	fill_psct(psct, raw_capacity_to_bytes(mpio.raw_capacity));
+	iit = (struct pcd_iit *)(psct + 1);
+	fill_iit(iit, 1, isi++);
+	m = get_miiis(iit);
+	msize = align_to_gb(raw_capacity_to_bytes(mpio.raw_capacity));
+	fill_miiis(dimm, m, ch->header.revision, msize);
+	finalize_pcd(ch);
+	ret = write_pcd(dimm, (char *)ch, pcd_size);
+out:
+	free(ch);
+	free(buf);
+	return ret;
+}
+
+/**
+ * Given a dimm object read its pcd and create a pcd structure with a
+ * configuration input table that requests creation of
+ * interleaved region.
+ * To create the request a new Configuration input table, Partition size
+ * change table, interleave information table and module identification
+ * information for interleave set tables for each dimm in the interleave set
+ * are to be added the pcd .Existing configuration output table is removed.
+ * PCD Partition ID 1 - Configuration management usage (64KB)
+ *
+ * +-------------+	+---------------------+    +---------------+
+ * |		 +----->│Current Configuration+--->│Extension table│
+ * |Configuration|	+---------------------+    +---------------+
+ * │	Header	 |	+---------------------+    +--------------------------+
+ * │		 +----->│ Configuration Input +--->│ Request Extension tables │
+ * +-------------+	+---------------------+    +--------------------------+
+ *
+ * The request extension tables for interleaved are
+ * 1) Partition size change table (PSCT)
+ * 2) Interleave information table (IIT)
+ * 3) N * Module identification information for interleave set (MIIIS). N is
+ *    number of dimms in the same interleave set as dimm object.
+ * Here an interleave set is all dimms with same socket id as dimm object.
+ * These tables are placed one after another. Section 5.3 in provisioning
+ * document provides an example pcd when creating this request.
+ */
+static int reconfigure_ad(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	static u32 ad_count;
+	u32 mii_count = 0;
+	u32 length = 0;
+	struct pcd_mpio mpio;
+	int ret = 0;
+	struct ndctl_dimm *idimm = NULL;
+	struct pcd_config_header *ch = NULL;
+	struct pcd_psct *psct = NULL;
+	struct pcd_iit *iit = NULL;
+	struct pcd_miiis *m = NULL;
+	u64 msize = 0;
+	u32 pcd_size = read_pcd_size(dimm);
+
+	/**
+	 * Here are the steps to create interleave request
+	 * 1) Create interleave sets for system if not created.
+	 * 2) Read current pcd and module partition information
+	 * 3) Copy configuration header, current configuration tables to a new
+	 *    pcd
+	 * 4) Create the Configuration input table, partition size change
+	      table and interleave information table.
+	 * 5) Identify other dimms in the same interleave set and for each
+	 *    dimm create a module indentification information for interleave
+	 *    set table and add all of them to interleave information table.
+	 * 6) Add all the new tables to the new pcd.
+	 * 7) Write the new pcd.
+	 * The value of persistent memory partition size in the partition size
+	 * change table is set to raw capacity of the dimm to indicate that all
+	 * memory is to be used for interleave set. The number of modules in
+	 * interleave set field of interleave information table is set to
+	 * to number of dimms in interleave set to indicate there is
+	 * interleaving. Section 5.3 in provisioning
+	 * document provides an example pcd when creating this request.
+	 */
+	ret = initialize_adi(dimm, ad_count++);
+	if (ret != 0)
+		goto out;
+	ret = get_iset_dimm_count(dimm, &mii_count);
+	if (ret != 0)
+		goto out;
+	ret = get_next_iset_dimm(dimm, &idimm);
+	if (ret != 0)
+		goto out;
+	ret = get_module_partition_info(dimm, &mpio);
+	if (ret != 0)
+		goto out;
+	if (!pcd_size)
+		goto out;
+	buf = (struct pcd_config_header *)calloc(pcd_size, sizeof(char));
+	if (!(buf))
+		goto out;
+	ret = read_pcd(dimm, &buf, pcd_size);
+	if (ret != 0)
+		goto out;
+	/**
+	 * For interleave request, The length of pcd table
+	 * to be written would depend on
+	 * 1) sum of read pcd size
+	 * 2) length of psct table
+	 * 3) length of iit table
+	 * 4) length of miiis * number of dimms in interleave set
+	 * The configuration input table would take the same space as zeroed
+	 * out configuration output table from read pcd. Section 5.3 in
+	 * provisioning document provides an example pcd when creating
+	 * this request.
+	 */
+	length = sizeof(struct pcd_psct) + sizeof(struct pcd_iit) +
+		 (mii_count * sizeof(struct pcd_miiis));
+	pcd_size = set_pcd_length(pcd_size, length);
+	ch = malloc(pcd_size);
+	if (!ch) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	init_pcd(buf, pcd_size, length, ch);
+	psct = (struct pcd_psct *)get_cin_tables_start(ch);
+	fill_psct(psct, raw_capacity_to_bytes(mpio.raw_capacity));
+	iit = (struct pcd_iit *)(psct + 1);
+	fill_iit(iit, mii_count, get_socket_id(dimm) + 1);
+	m = get_miiis(iit);
+	msize = get_iset_psize(dimm);
+	while (idimm) {
+		fill_miiis(idimm, m, ch->header.revision, msize);
+		get_next_iset_dimm(dimm, &idimm);
+		m = m + 1;
+	}
+	finalize_pcd(ch);
+	ret = write_pcd(dimm, (char *)ch, pcd_size);
+out:
+	free(ch);
+	free(buf);
+	/* Force deinitialization if returning error */
+	if (ret != 0)
+		ad_count = 0;
+	deinitialize_adi(ad_count);
+	return ret;
+}
+
 /**
  * Given the mode option perform the region reconfiguration action on
  * the dimm object
@@ -688,10 +1391,12 @@ out:
 static int do_reconfigure(struct ndctl_dimm *dimm, const char *mode)
 {
 	if (!mode)
-		return -EOPNOTSUPP;
+		return reconfigure_ad(dimm);
 	if (strncmp(mode, "ram", 3) == 0)
 		return reconfigure_volatile(dimm);
-	return -EOPNOTSUPP;
+	if (strncmp(mode, "pmem", 4) == 0)
+		return reconfigure_adni(dimm);
+	return reconfigure_ad(dimm);
 }
 
 /**
-- 
2.20.1

