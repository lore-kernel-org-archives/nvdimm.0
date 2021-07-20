Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3622FB2
	for <nvdimm@lists.linux.dev>; Tue, 20 Jul 2021 15:51:24 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="275086012"
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="275086012"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="510808319"
Received: from janandra-mobl.amr.corp.intel.com ([10.212.182.134])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 08:51:22 -0700
From: James Anandraj <james.sushanth.anandraj@intel.com>
To: nvdimm@lists.linux.dev,
	james.sushanth.anandraj@intel.com
Subject: [PATCH v2 2/4] ipmregion/list: Add ipmregion-list command to enumerate 'nvdimm' devices
Date: Tue, 20 Jul 2021 08:51:08 -0700
Message-Id: <20210720155110.14680-3-james.sushanth.anandraj@intel.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20210720155110.14680-1-james.sushanth.anandraj@intel.com>
References: <20210720155110.14680-1-james.sushanth.anandraj@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>

Add ipmregion-list command to enumerate 'nvdimm' devices. The command
reads pcd data from the 'nvdimm' devices to display information
related to region reconfiguration such as, pending
reconfiguration request and the status of last request.

Signed-off-by: James Sushanth Anandraj <james.sushanth.anandraj@intel.com>
---
 Makefile.am             |   2 +-
 configure.ac            |   1 +
 ipmregion/Makefile.am   |  17 ++
 ipmregion/builtin.h     |   8 +
 ipmregion/ipmregion.c   |  87 +++++++++
 ipmregion/list.c        | 114 ++++++++++++
 ipmregion/list.h        |  11 ++
 ipmregion/pcd.h         | 160 +++++++++++++++++
 ipmregion/reconfigure.c | 379 ++++++++++++++++++++++++++++++++++++++++
 ipmregion/reconfigure.h |  12 ++
 util/main.h             |   1 +
 11 files changed, 791 insertions(+), 1 deletion(-)
 create mode 100644 ipmregion/Makefile.am
 create mode 100644 ipmregion/builtin.h
 create mode 100644 ipmregion/ipmregion.c
 create mode 100644 ipmregion/list.c
 create mode 100644 ipmregion/list.h
 create mode 100644 ipmregion/pcd.h
 create mode 100644 ipmregion/reconfigure.c
 create mode 100644 ipmregion/reconfigure.h

diff --git a/Makefile.am b/Makefile.am
index f9fec0c..3ef2a98 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 include Makefile.am.in
 
 ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
-SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl
+SUBDIRS = . daxctl/lib ndctl/lib ndctl daxctl ipmregion
 if ENABLE_DOCS
 SUBDIRS += Documentation/ndctl Documentation/daxctl Documentation/ipmregion
 endif
diff --git a/configure.ac b/configure.ac
index 9f16b01..222eda2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -225,6 +225,7 @@ AC_CONFIG_FILES([
         ndctl/lib/Makefile
         ndctl/Makefile
         daxctl/Makefile
+        ipmregion/Makefile
         test/Makefile
         Documentation/ndctl/Makefile
         Documentation/daxctl/Makefile
diff --git a/ipmregion/Makefile.am b/ipmregion/Makefile.am
new file mode 100644
index 0000000..4a17a69
--- /dev/null
+++ b/ipmregion/Makefile.am
@@ -0,0 +1,17 @@
+include $(top_srcdir)/Makefile.am.in
+
+bin_PROGRAMS = ipmregion
+
+ipmregion_SOURCES =\
+		ipmregion.c \
+		list.c \
+		reconfigure.c \
+		../util/json.c \
+		builtin.h
+
+ipmregion_LDADD =\
+	../ndctl/lib/libndctl.la \
+	../libutil.a \
+	$(UUID_LIBS) \
+	$(KMOD_LIBS) \
+	$(JSON_LIBS)
diff --git a/ipmregion/builtin.h b/ipmregion/builtin.h
new file mode 100644
index 0000000..4ea5650
--- /dev/null
+++ b/ipmregion/builtin.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2015-2021 Intel Corporation. All rights reserved. */
+#ifndef _IPMREGION_BUILTIN_H_
+#define _IPMREGION_BUILTIN_H_
+
+struct ndctl_ctx;
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx);
+#endif /* _IPMREGION_BUILTIN_H_ */
diff --git a/ipmregion/ipmregion.c b/ipmregion/ipmregion.c
new file mode 100644
index 0000000..7726974
--- /dev/null
+++ b/ipmregion/ipmregion.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <util/parse-options.h>
+#include <util/main.h>
+#include <ccan/array_size/array_size.h>
+#include <ipmregion/builtin.h>
+#include <ndctl/libndctl.h>
+
+static const char ipmregion_usage_string[] =
+	"ipmregion [--version] [--help] COMMAND [ARGS]";
+static const char ipmregion_more_info_string[] =
+	"See 'ipmregion help COMMAND' for more information on a specific command."
+	"\n ipmregion --list-cmds to see all available commands";
+
+static int cmd_version(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	printf("%s\n", VERSION);
+	return 0;
+}
+
+static int cmd_help(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	const char *const builtin_help_subcommands[] = {
+		"list",
+		NULL,
+	};
+	struct option builtin_help_options[] = {
+		OPT_END(),
+	};
+	static const char *builtin_help_usage[] = { "ipmregion help [command]",
+						    NULL };
+
+	argc = parse_options_subcommand(argc, argv, builtin_help_options,
+					builtin_help_subcommands,
+					builtin_help_usage, 0);
+
+	if (!argv[0]) {
+		printf("\n usage: %s\n\n", ipmregion_usage_string);
+		printf("\n %s\n\n", ipmregion_more_info_string);
+		return 0;
+	}
+
+	return help_show_man_page(argv[0], "ipmregion", "ipmregion_MAN_VIEWER");
+}
+
+static struct cmd_struct commands[] = {
+	{ "version", { cmd_version } },
+	{ "list", { cmd_list } },
+	{ "help", { cmd_help } },
+};
+
+int main(int argc, const char **argv)
+{
+	struct ndctl_ctx *ctx;
+	int rc;
+
+	/* Look for flags.. */
+	argv++;
+	argc--;
+	main_handle_options(&argv, &argc, ipmregion_usage_string, commands,
+			    ARRAY_SIZE(commands));
+
+	if (argc > 0) {
+		if (!prefixcmp(argv[0], "--"))
+			argv[0] += 2;
+	} else {
+		/* The user didn't specify a command; give them help */
+		printf("\n usage: %s\n\n", ipmregion_usage_string);
+		printf("\n %s\n\n", ipmregion_more_info_string);
+		goto out;
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc)
+		goto out;
+	main_handle_internal_command(argc, argv, ctx, commands,
+				     ARRAY_SIZE(commands), PROG_ipmregion);
+	ndctl_unref(ctx);
+	fprintf(stderr, "Unknown command: '%s'\n", argv[0]);
+out:
+	return 1;
+}
diff --git a/ipmregion/list.c b/ipmregion/list.c
new file mode 100644
index 0000000..242999a
--- /dev/null
+++ b/ipmregion/list.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2015-2021 Intel Corporation. All rights reserved.
+#include <util/json.h>
+#include <util/filter.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <ipmregion/builtin.h>
+#include <util/parse-options.h>
+#include <reconfigure.h>
+
+static struct list_param {
+	const char *bus;
+	bool verbose;
+} param;
+
+struct json_object *ipmregion_list_dimm_to_json(struct ndctl_dimm *dimm)
+{
+	struct json_object *jdimm = json_object_new_object();
+	const char *id = ndctl_dimm_get_unique_id(dimm);
+	unsigned int handle = ndctl_dimm_get_handle(dimm);
+	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
+	struct json_object *jobj;
+
+	if (!jdimm)
+		return NULL;
+
+	jobj = json_object_new_string(ndctl_dimm_get_devname(dimm));
+	if (!jobj)
+		goto err;
+	json_object_object_add(jdimm, "dev", jobj);
+	if (id) {
+		jobj = json_object_new_string(id);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "id", jobj);
+	}
+	if (handle < UINT_MAX) {
+		jobj = util_json_object_hex(handle, 0);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "handle", jobj);
+	}
+	if (phys_id < USHRT_MAX) {
+		jobj = util_json_object_hex(phys_id, 0);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "phys_id", jobj);
+	}
+	if (ipmregion_dimm_reconfigure_region_pending(dimm)) {
+		jobj = json_object_new_boolean(true);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "reconfigure_pending", jobj);
+	} else {
+		const char *r_status_str = NULL;
+		const int r_status = ipmregion_dimm_reconfigure_status(dimm);
+
+		r_status_str = ipmregion_dimm_reconfigure_status_string(dimm);
+		if (r_status_str) {
+			jobj = json_object_new_string(r_status_str);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jdimm, "reconfigure_status",
+					       jobj);
+		}
+
+		if (r_status >= 0) {
+			jobj = json_object_new_int(r_status);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jdimm, "reconfigure_err_status",
+					       jobj);
+		}
+	}
+	return jdimm;
+err:
+	json_object_put(jdimm);
+	return NULL;
+}
+
+int cmd_list(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id",
+			   "filter by <bus-id>"),
+		OPT_BOOLEAN('v', "verbose", &param.verbose, "turn on debug"),
+		OPT_END(),
+	};
+	const char *const u[] = { "ipmregion list [<options>]", NULL };
+	struct ndctl_bus *bus = NULL;
+	struct json_object *j_dimms = NULL;
+
+	argc = parse_options(argc, argv, options, u, 0);
+	if (param.verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+	j_dimms = json_object_new_array();
+	if (!j_dimms)
+		return -ENOMEM;
+	ndctl_bus_foreach(ctx, bus) {
+		struct ndctl_dimm *dimm = NULL;
+
+		if (!util_bus_filter(bus, param.bus))
+			continue;
+		ndctl_dimm_foreach(bus, dimm) {
+			struct json_object *j_dimm = NULL;
+
+			j_dimm = ipmregion_list_dimm_to_json(dimm);
+			if (j_dimm)
+				json_object_array_add(j_dimms, j_dimm);
+		}
+	}
+	util_display_json_array(stdout, j_dimms, 0);
+	return 0;
+}
diff --git a/ipmregion/list.h b/ipmregion/list.h
new file mode 100644
index 0000000..eabd710
--- /dev/null
+++ b/ipmregion/list.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0*/
+/* Copyright(c) 2021 Intel Corporation. All rights reserved.*/
+
+#ifndef _LIST_H_
+#define _LIST_H_
+
+#include <ndctl/lib/private.h>
+#include <ndctl/libndctl.h>
+#include <util/json.h>
+struct json_object *ipmregion_list_dimm_to_json(struct ndctl_dimm *dimm);
+#endif /* _LIST_H_ */
diff --git a/ipmregion/pcd.h b/ipmregion/pcd.h
new file mode 100644
index 0000000..f49f7eb
--- /dev/null
+++ b/ipmregion/pcd.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
+#ifndef _PCD_H_
+#define _PCD_H_
+#include <stdint.h>
+#include <ccan/short_types/short_types.h>
+#include <string.h>
+#include <acpi.h>
+/**
+ * The module Platform Configuration Data (PCD) refers to a section of the
+ * PMem module that is used to store metadata. The metadata stored in the PCD
+ * is the architected interface between software and platform firmware to
+ * support PMem provisioning. The format of PCD partition ID #1 used for
+ * provisioning is as follows. This is from Section 3 Figure 31 of Provisioning
+ * specification document.
+ * PCD Partition ID 1 - Configuration management usage (64KB)
+ *
+ *			+---------------------+    +---------------+
+ *	 +------------->│Current Configuration+--->│Extension table│
+ *	 │		+---------------------+    +---------------+
+ *	 │
+ * +-----+-------+      +---------------------+    +---------------+
+ * │Configuration+----->│ Configuration Input +--->│Extension table│
+ * │   Header    │      +---------------------+    +---------------+
+ * +-----+-------+
+ *	 │		+---------------------+    +---------------+
+ *	 +------------->│Configuration Output +--->│Extension table│
+ *			+---------------------+    +---------------+
+ * Glossary
+ * --------
+ * PCD - Platform Configuration Data
+ * Config Header - Configuration header
+ * CCUR - Current Configuration
+ * CIN - Configuration Input
+ * COUT - Configuration Output
+ */
+/**
+ * struct pcd_config_header - configuration header
+ * @header: ACPI header
+ * @ccur_data_size: current configuration data size
+ * @ccur_offset: current configuration start offset
+ * @cin_data_size: configuration input data size
+ * @cin_offset: configuration input start offset
+ * @cout_data_size: configuration output data size
+ * @cout_offset: configuration output start offset
+ * The configuration header structure contains two parts - ACPI header
+ * and the body part contains pointers to the current configuration,
+ * configuration input, and configuration output. The structure and its
+ * fields are described in the configuration header section 3.1 and Table 31
+ * in provisioning specification document.
+ */
+struct pcd_config_header {
+	struct acpi_header header;
+	u32 ccur_data_size;
+	u32 ccur_offset;
+	u32 cin_data_size;
+	u32 cin_offset;
+	u32 cout_data_size;
+	u32 cout_offset;
+} __attribute__((packed));
+/**
+ * struct pcd_ccur - current configuration
+ * @header: ACPI header
+ * @status: configuration status
+ * @r1: reserved
+ * @volatile_size: volatile memory size mapped into SPA
+ * @persistent_size: persistent memory size mapped into SPA
+ * The current configuration structure consists of two parts - ACPI header
+ * and the body fields that are created by the platform firmware and
+ * updated on each PMem module during the memory configuration phase of
+ * the platform firmware. The structure and its fields are described in the
+ * section 3.2 and Table 32 in the provisioning specification document.
+ */
+struct pcd_ccur {
+	struct acpi_header header;
+	u16 status;
+	u8 r1[2];
+	u64 volatile_size;
+	u64 persistent_size;
+} __attribute__((packed));
+/**
+ * struct pcd_cin - configuration input
+ * @header: ACPI header
+ * @sequence: sequence number
+ * @r1: reserved
+ * The configuration input structure consists of two parts - ACPI header and
+ * the body fields that represents a configuration request created by the
+ * software. The platform firmware processes this table on the next system
+ * reboot. The structure and its fields are described in the section 3.3 and
+ * Table 33 in the provisioning specification document.
+ */
+struct pcd_cin {
+	struct acpi_header header;
+	u32 sequence;
+	u8 r1[8];
+} __attribute__((packed));
+/**
+ * struct pcd_cout - configuration output
+ * @header: ACPI header
+ * @sequence: sequence number
+ * @status: validation status
+ * @r1: reserved
+ * The configuration output structure consists of two parts - ACPI header and
+ * the body fields that are created by the platform firmware in response to the
+ * software request input configuration input table. The structure and its
+ * fields are described in the section 3.4 and Table 34 in the provisioning
+ * specification document.
+ */
+struct pcd_cout {
+	struct acpi_header header;
+	u32 sequence;
+	u8 status;
+	u8 r1[7];
+} __attribute__((packed));
+/**
+ * struct pcd_get_pcd_input - get pcd input
+ * @partition_id: partition id
+ * @payload_type: payload type
+ * @retreive option: retreive option
+ * @reserved: reserved
+ * @offset: offset
+ * The structure represents the input parameters to get
+ * pcd vendor specific command. The structure and its fields are described in
+ * section 4.1 and Table 41 in the provisioning specification document.
+ */
+struct pcd_get_pcd_input {
+	u8 partition_id;
+	struct {
+		u8 payload_type : 1;
+		u8 retrieve_option : 1;
+		u8 reserved : 6;
+	} __attribute__((packed)) options;
+	u32 offset;
+} __attribute__((packed));
+/**
+ * Human readable pcd status string
+ */
+static const char *const pcd_status_str[] = {
+	"undefined",
+	"success",
+	"reserved",
+	"configuration input error",
+};
+
+/**
+ * PCD small payload size .The value is mentioned in section 4.1 of
+ * provisioning document.
+ */
+#define PCD_SP_SIZE 128u
+/**
+ * PCD dimm partition size.The value is mentioned in section 3 figure 31 of
+ * provisioning document.
+ */
+#define MAX_PCD_SIZE 0x10000u
+/**
+ * The opcode value for get pcd vendor specific command. The value is mentioned
+ * in section 4.1 Table 42 of provisioning document.
+ */
+#define PCD_OPCODE_GET_PCD ((u16)0x0601)
+#endif /* _PCD_H_ */
diff --git a/ipmregion/reconfigure.c b/ipmregion/reconfigure.c
new file mode 100644
index 0000000..17703e8
--- /dev/null
+++ b/ipmregion/reconfigure.c
@@ -0,0 +1,379 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2021 Intel Corporation. All rights reserved.
+#include <ndctl/libndctl.h>
+#include <pcd.h>
+#include <stdbool.h>
+#include <reconfigure.h>
+#include <stdlib.h>
+#include <ccan/minmax/minmax.h>
+
+/**
+ * The location of the configuration input in the pcd partition
+ * is determined by configuration input start offset field. The
+ * field is described in Section 3.1 and Table 31 in provisioning
+ * document
+ */
+static struct pcd_cin *get_cin(struct pcd_config_header const *c)
+{
+	return (struct pcd_cin *)((u8 *)c + c->cin_offset);
+}
+
+/**
+ * The location of the current configuration in the pcd partition
+ * is determined by current configuration start offset field. The
+ * field is described in Section 3.1 and Table 31 in provisioning
+ * document
+ */
+static struct pcd_ccur *get_ccur(struct pcd_config_header const *c)
+{
+	return (struct pcd_ccur *)((u8 *)c + c->ccur_offset);
+}
+
+/**
+ * The location of the configuration output in the pcd partition
+ * is determined by configuration output start offset field. The
+ * field is described in Section 3.1 and Table 31 in provisioning
+ * document
+ */
+static struct pcd_cout *get_cout(struct pcd_config_header const *c)
+{
+	return (struct pcd_cout *)((u8 *)c + c->cout_offset);
+}
+
+/**
+ * To determine if a reconfiguration request is pending we can look at
+ * configuration input data size and sequence number fields.
+ */
+static bool is_pcd_reconfigure_pending(struct pcd_config_header const *ch)
+{
+	struct pcd_cin *cin = NULL;
+	struct pcd_cout *cout = NULL;
+
+	/**
+	 * There is a pending request if configuration input table is
+	 * present and the sequence number in the configuration input
+	 * table is not same as the sequence number in configuration
+	 * output table
+	 */
+	cin = get_cin(ch);
+	cout = get_cout(ch);
+	if (ch->cin_data_size == 0) {
+		return false;
+	} else if (cin->sequence > 0) {
+		if (ch->cout_data_size == 0)
+			return true;
+		else if (cin->sequence != cout->sequence)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * Map the current configuration status value to human readable strings. The
+ * current configuration status field is described in Section 3.2 and Table 32
+ * in provisioning document
+ */
+static const char *get_ccur_status_string(struct pcd_config_header const *ch)
+{
+	struct pcd_ccur *ccur = NULL;
+
+	ccur = get_ccur(ch);
+	if (ch->ccur_data_size == 0)
+		return NULL;
+	if (ccur->status <= 3)
+		return pcd_status_str[ccur->status];
+	if (ccur->status == 5)
+		return pcd_status_str[2];
+	/* conf status is cin error */
+	if (ccur->status >= 4 && ccur->status < 16)
+		return pcd_status_str[3];
+	/* all other values are reserved */
+	return pcd_status_str[2];
+}
+
+/**
+ * Get configuration status field from current configuration structure. The
+ * field is described in Section 3.2 and Table 32 in provisioning document
+ */
+static int get_pcd_ccur_status(struct pcd_config_header const *ch)
+{
+	struct pcd_ccur *ccur = NULL;
+
+	ccur = get_ccur(ch);
+	if (ch->ccur_data_size == 0)
+		return -ENOTTY;
+	return ccur->status;
+}
+
+/**
+ * Function to execute a vendor specific command where input data
+ * can be sent and output data can be received
+ */
+static int execute_vendor_specific_cmd(struct ndctl_dimm *dimm,
+				       const u32 op_code, void *inp,
+				       const u32 inp_size, void *op,
+				       u32 op_size)
+{
+	struct ndctl_cmd *cmd = NULL;
+	size_t bytes;
+
+	if (!dimm || !inp || inp_size == 0 || (op_size > 0 && !op) ||
+	    op_size > PCD_SP_SIZE) {
+		fprintf(stderr, "%s: dimm: %#x vendor cmd param incorrect\n",
+			__func__, ndctl_dimm_get_handle(dimm));
+		return -ENOTTY;
+	}
+	cmd = ndctl_dimm_cmd_new_vendor_specific(dimm, op_code, inp_size,
+						 op_size);
+	if (!cmd)
+		return -ENOTTY;
+	bytes = ndctl_cmd_vendor_set_input(cmd, inp, inp_size);
+	if (bytes != inp_size)
+		return -ENOTTY;
+	ndctl_cmd_submit(cmd);
+	if (op_size > 0) {
+		size_t rbytes = 0;
+
+		rbytes = ndctl_cmd_vendor_get_output(cmd, op, op_size);
+		if (rbytes < op_size)
+			return -ENOTTY;
+	}
+	ndctl_cmd_unref(cmd);
+	return 0;
+}
+
+static inline u32 max_of_three(u32 a, u32 b, u32 c)
+{
+	return max(a, b) > c ? max(a, b) : c;
+}
+
+/**
+ * The maximum pcd table size that needs to be read for purpose of reconfigure
+ * regions is the entire 64 kb configuration management usage sub partition.
+ * The actual table structures could occupy less space. The function helps
+ * to calculate the size that needs to be read to get all the pcd table
+ * structures. PCD format is explained in section 3 of provisioning document.
+ */
+static u32 get_table_size(struct pcd_config_header const *ch)
+{
+	u32 size = 0;
+
+	/**
+	 * Find which table among ccur, cin and cout is the furthest in
+	 * the sub partition. The offset + data size of the furthest
+	 * table rounded up to pcd small payload size and bounded by the maximum
+	 * pcd size would be the furthest we need to read to get all the pcd
+	 * table structures. The fields used are explained in section 3.1 and
+	 * table 31 of the provisioning document.
+	 */
+	size = max_of_three(ch->ccur_offset + ch->ccur_data_size,
+			    ch->cin_offset + ch->cin_data_size,
+			    ch->cout_offset + ch->cout_data_size);
+	size = size > PCD_SP_SIZE ? size - (size % PCD_SP_SIZE) + PCD_SP_SIZE :
+				    PCD_SP_SIZE;
+	size = min(size, MAX_PCD_SIZE);
+	return size;
+}
+
+/**
+ * Given a ndctl dimm object read the pcd and calculate table size to read
+ * and get all pcd table structures.
+ */
+static u32 read_pcd_size(struct ndctl_dimm *dimm)
+{
+	u32 op_code = 0;
+	char inp[PCD_SP_SIZE];
+	char op[PCD_SP_SIZE];
+	struct pcd_get_pcd_input *in = NULL;
+
+	memset(inp, 0, PCD_SP_SIZE);
+	memset(op, 0, PCD_SP_SIZE);
+	in = (struct pcd_get_pcd_input *)inp;
+	in->partition_id = 1;
+	in->options.payload_type = 1;
+	in->options.retrieve_option = 0;
+	in->offset = 0;
+	op_code = cpu_to_be16(PCD_OPCODE_GET_PCD);
+	if (execute_vendor_specific_cmd(dimm, op_code, inp, PCD_SP_SIZE, op,
+					PCD_SP_SIZE) != 0)
+		return 0;
+	return get_table_size((struct pcd_config_header *)op);
+}
+
+/**
+ * Given ndctl dimm object and a preallocated buffer read the pcd upto
+ * the number of bytes mentioned in size field into the buffer
+ */
+static int read_pcd(struct ndctl_dimm *dimm, struct pcd_config_header **pcd,
+		    u32 size)
+{
+	u32 op_code = 0;
+	char inp[PCD_SP_SIZE];
+	char op[PCD_SP_SIZE];
+	char **buf = (char **)pcd;
+	struct pcd_get_pcd_input *in = NULL;
+
+	memset(inp, 0, PCD_SP_SIZE);
+	memset(op, 0, PCD_SP_SIZE);
+	in = (struct pcd_get_pcd_input *)inp;
+	in->partition_id = 1;
+	in->options.payload_type = 1;
+	in->options.retrieve_option = 0;
+	in->offset = 0;
+	op_code = cpu_to_be16(PCD_OPCODE_GET_PCD);
+	while (size > 0) {
+		if (execute_vendor_specific_cmd(dimm, op_code, inp, PCD_SP_SIZE,
+						op, PCD_SP_SIZE) != 0)
+			return -ENOTTY;
+		memcpy((*buf) + in->offset, op, PCD_SP_SIZE);
+		size = size - PCD_SP_SIZE;
+		in->offset = in->offset + PCD_SP_SIZE;
+	}
+	return 0;
+}
+
+/**
+ * Validate checksum field of configuration header.
+ */
+static inline int validate_config_header(struct pcd_config_header *c)
+{
+	return acpi_checksum(c, c->header.length);
+}
+
+/**
+ * Validate signature and checksum fields of current configuration,
+ * configuration input and configuration output tables when they are present.
+ * These tables and the fields are explained in Section 3 of provisioning
+ * document.
+ */
+static inline int validate_config_data(struct pcd_config_header const *ch)
+{
+	int ret = 0;
+
+	if (ch->ccur_data_size > 0) {
+		const char *ccur_sig = "CCUR";
+		struct pcd_ccur *ccur = get_ccur(ch);
+
+		if (memcmp(ccur_sig, &ccur->header.signature, 4) != 0)
+			ret = -ENOTTY;
+		if (acpi_checksum(ccur, ccur->header.length) != 0)
+			ret = -ENOTTY;
+	}
+	if (ch->cin_data_size > 0) {
+		const char *cin_sig = "CIN_";
+		struct pcd_cin *cin = get_cin(ch);
+
+		if (memcmp(cin_sig, &cin->header.signature, 4) != 0)
+			ret = -ENOTTY;
+		if (acpi_checksum(cin, cin->header.length) != 0)
+			ret = -ENOTTY;
+	}
+	if (ch->cout_data_size > 0) {
+		const char *cout_sig = "COUT";
+		struct pcd_cout *cout = get_cout(ch);
+
+		if (memcmp(cout_sig, &cout->header.signature, 4) != 0)
+			ret = -ENOTTY;
+		if (acpi_checksum(cout, cout->header.length) != 0)
+			ret = -ENOTTY;
+	}
+	return ret;
+}
+
+/**
+ * Given a pcd buffer validate checksum and signature of sub tables. The pcd
+ * tables and subtables are explained in section 3 of provisioning document.
+ */
+static int validate_pcd(struct pcd_config_header *pcd)
+{
+	int ret = -ENOTTY;
+
+	if (!pcd)
+		return ret;
+	if (validate_config_header(pcd) != 0)
+		return ret;
+	if (validate_config_data(pcd) != 0)
+		return ret;
+	ret = 0;
+	return ret;
+}
+
+/**
+ * Read pcd data from dimm and if valid pcd is present check if there is
+ * a pending region reconfigure request.
+ */
+bool ipmregion_dimm_reconfigure_region_pending(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	bool ret = false;
+	u32 size = read_pcd_size(dimm);
+
+	if (!size)
+		return ret;
+	buf = (struct pcd_config_header *)calloc(size, sizeof(char));
+	if (!(buf))
+		return ret;
+	if (read_pcd(dimm, &buf, size))
+		goto out;
+	if (validate_pcd(buf))
+		goto out;
+	ret = is_pcd_reconfigure_pending(buf);
+out:
+	free(buf);
+	return ret;
+}
+
+/**
+ * Read pcd data from dimm and if valid pcd and reconfigure request is present.
+ * return human readable configuration status string. This field is explained in
+ * section 3.2 and Table 32 of provisioning specification.
+ */
+const char *ipmregion_dimm_reconfigure_status_string(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	const char *status = NULL;
+	u32 size = read_pcd_size(dimm);
+
+	if (!size)
+		return status;
+	buf = (struct pcd_config_header *)calloc(size, sizeof(char));
+	if (!(buf))
+		return status;
+	if (read_pcd(dimm, &buf, size))
+		goto out;
+	if (validate_pcd(buf))
+		goto out;
+	status = get_ccur_status_string(buf);
+out:
+	free(buf);
+	return status;
+}
+
+/**
+ * Read pcd data from dimm and if valid pcd and reconfiguration request is
+ * present return the configuration status value if it is not success. This
+ * field is explained in section 3.2 and Table 32 of provisioning specification.
+ */
+int ipmregion_dimm_reconfigure_status(struct ndctl_dimm *dimm)
+{
+	struct pcd_config_header *buf = NULL;
+	int status = -1;
+	u32 size = read_pcd_size(dimm);
+
+	if (!size)
+		return status;
+	buf = (struct pcd_config_header *)calloc(size, sizeof(char));
+	if (!(buf))
+		return status;
+	if (read_pcd(dimm, &buf, size))
+		goto out;
+	if (validate_pcd(buf))
+		goto out;
+	status = get_pcd_ccur_status(buf);
+	/* No need to display if status is success */
+	if (status == 1)
+		status = -1;
+out:
+	free(buf);
+	return status;
+}
diff --git a/ipmregion/reconfigure.h b/ipmregion/reconfigure.h
new file mode 100644
index 0000000..84b3340
--- /dev/null
+++ b/ipmregion/reconfigure.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0*/
+/* Copyright(c) 2021 Intel Corporation. All rights reserved.*/
+
+#ifndef _RECONFIGURE_H_
+#define _RECONFIGURE_H_
+
+#include <ndctl/lib/private.h>
+#include <ndctl/libndctl.h>
+bool ipmregion_dimm_reconfigure_region_pending(struct ndctl_dimm *dimm);
+const char *ipmregion_dimm_reconfigure_status_string(struct ndctl_dimm *dimm);
+int ipmregion_dimm_reconfigure_status(struct ndctl_dimm *dimm);
+#endif /* _RECONFIGURE_H_ */
diff --git a/util/main.h b/util/main.h
index c89a843..f723c6e 100644
--- a/util/main.h
+++ b/util/main.h
@@ -10,6 +10,7 @@
 enum program {
 	PROG_NDCTL,
 	PROG_DAXCTL,
+	PROG_ipmregion
 };
 
 struct ndctl_ctx;
-- 
2.20.1

