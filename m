Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E002FB2
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:16 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606876"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606876"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:14 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271300"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:14 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 03/21] cxl: add a local copy of the cxl_mem UAPI header
Date: Thu,  1 Jul 2021 14:09:47 -0600
Message-Id: <20210701201005.3065299-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While CXL functionality is under development, it is useful to have a
local copy of the UAPI header for cxl_mem definitions. This allows
building cxl and libcxl on systems where the appropriate kernel headers
are not installed in the usual locations.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am         |   3 +-
 Makefile.am.in      |   1 +
 cxl/cxl_mem.h       | 189 ++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/Makefile.am |   2 +-
 4 files changed, 193 insertions(+), 2 deletions(-)
 create mode 100644 cxl/cxl_mem.h

diff --git a/Makefile.am b/Makefile.am
index 428fd40..4904ee7 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -89,4 +89,5 @@ libutil_a_SOURCES = \
 
 nobase_include_HEADERS = \
 	daxctl/libdaxctl.h \
-	cxl/libcxl.h
+	cxl/libcxl.h \
+	cxl/cxl_mem.h
diff --git a/Makefile.am.in b/Makefile.am.in
index aaeee53..a748128 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -11,6 +11,7 @@ AM_CPPFLAGS = \
 	-DNDCTL_MAN_PATH=\""$(mandir)"\" \
 	-I${top_srcdir}/ndctl/lib \
 	-I${top_srcdir}/ndctl \
+	-I${top_srcdir}/cxl \
 	-I${top_srcdir}/ \
 	$(KMOD_CFLAGS) \
 	$(UDEV_CFLAGS) \
diff --git a/cxl/cxl_mem.h b/cxl/cxl_mem.h
new file mode 100644
index 0000000..d38cc9c
--- /dev/null
+++ b/cxl/cxl_mem.h
@@ -0,0 +1,189 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/* Copyright (C) 2020-2021, Intel Corporation. All rights reserved. */
+/*
+ * CXL IOCTLs for Memory Devices
+ */
+
+#ifndef _UAPI_CXL_MEM_H_
+#define _UAPI_CXL_MEM_H_
+
+#include <linux/types.h>
+#include <sys/user.h>
+#include <unistd.h>
+
+#define __user
+
+/**
+ * DOC: UAPI
+ *
+ * Not all of all commands that the driver supports are always available for use
+ * by userspace. Userspace must check the results from the QUERY command in
+ * order to determine the live set of commands.
+ */
+
+#define CXL_MEM_QUERY_COMMANDS _IOR(0xCE, 1, struct cxl_mem_query_commands)
+#define CXL_MEM_SEND_COMMAND _IOWR(0xCE, 2, struct cxl_send_command)
+
+#define CXL_CMDS                                                          \
+	___C(INVALID, "Invalid Command"),                                 \
+	___C(IDENTIFY, "Identify Command"),                               \
+	___C(RAW, "Raw device command"),                                  \
+	___C(GET_SUPPORTED_LOGS, "Get Supported Logs"),                   \
+	___C(GET_FW_INFO, "Get FW Info"),                                 \
+	___C(GET_PARTITION_INFO, "Get Partition Information"),            \
+	___C(GET_LSA, "Get Label Storage Area"),                          \
+	___C(GET_HEALTH_INFO, "Get Health Info"),                         \
+	___C(GET_LOG, "Get Log"),                                         \
+	___C(SET_PARTITION_INFO, "Set Partition Information"),            \
+	___C(SET_LSA, "Set Label Storage Area"),                          \
+	___C(GET_ALERT_CONFIG, "Get Alert Configuration"),                \
+	___C(SET_ALERT_CONFIG, "Set Alert Configuration"),                \
+	___C(GET_SHUTDOWN_STATE, "Get Shutdown State"),                   \
+	___C(SET_SHUTDOWN_STATE, "Set Shutdown State"),                   \
+	___C(GET_POISON, "Get Poison List"),                              \
+	___C(INJECT_POISON, "Inject Poison"),                             \
+	___C(CLEAR_POISON, "Clear Poison"),                               \
+	___C(GET_SCAN_MEDIA_CAPS, "Get Scan Media Capabilities"),         \
+	___C(SCAN_MEDIA, "Scan Media"),                                   \
+	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
+	___C(MAX, "invalid / last command")
+
+#define ___C(a, b) CXL_MEM_COMMAND_ID_##a
+enum { CXL_CMDS };
+
+#undef ___C
+#define ___C(a, b) { b }
+static const struct {
+	const char *name;
+} cxl_command_names[] = { CXL_CMDS };
+
+/*
+ * Here's how this actually breaks out:
+ * cxl_command_names[] = {
+ *	[CXL_MEM_COMMAND_ID_INVALID] = { "Invalid Command" },
+ *	[CXL_MEM_COMMAND_ID_IDENTIFY] = { "Identify Command" },
+ *	...
+ *	[CXL_MEM_COMMAND_ID_MAX] = { "invalid / last command" },
+ * };
+ */
+
+#undef ___C
+
+/**
+ * struct cxl_command_info - Command information returned from a query.
+ * @id: ID number for the command.
+ * @flags: Flags that specify command behavior.
+ * @size_in: Expected input size, or -1 if variable length.
+ * @size_out: Expected output size, or -1 if variable length.
+ *
+ * Represents a single command that is supported by both the driver and the
+ * hardware. This is returned as part of an array from the query ioctl. The
+ * following would be a command that takes a variable length input and returns 0
+ * bytes of output.
+ *
+ *  - @id = 10
+ *  - @flags = 0
+ *  - @size_in = -1
+ *  - @size_out = 0
+ *
+ * See struct cxl_mem_query_commands.
+ */
+struct cxl_command_info {
+	__u32 id;
+
+	__u32 flags;
+#define CXL_MEM_COMMAND_FLAG_MASK GENMASK(0, 0)
+
+	__s32 size_in;
+	__s32 size_out;
+};
+
+/**
+ * struct cxl_mem_query_commands - Query supported commands.
+ * @n_commands: In/out parameter. When @n_commands is > 0, the driver will
+ *		return min(num_support_commands, n_commands). When @n_commands
+ *		is 0, driver will return the number of total supported commands.
+ * @rsvd: Reserved for future use.
+ * @commands: Output array of supported commands. This array must be allocated
+ *            by userspace to be at least min(num_support_commands, @n_commands)
+ *
+ * Allow userspace to query the available commands supported by both the driver,
+ * and the hardware. Commands that aren't supported by either the driver, or the
+ * hardware are not returned in the query.
+ *
+ * Examples:
+ *
+ *  - { .n_commands = 0 } // Get number of supported commands
+ *  - { .n_commands = 15, .commands = buf } // Return first 15 (or less)
+ *    supported commands
+ *
+ *  See struct cxl_command_info.
+ */
+struct cxl_mem_query_commands {
+	/*
+	 * Input: Number of commands to return (space allocated by user)
+	 * Output: Number of commands supported by the driver/hardware
+	 *
+	 * If n_commands is 0, kernel will only return number of commands and
+	 * not try to populate commands[], thus allowing userspace to know how
+	 * much space to allocate
+	 */
+	__u32 n_commands;
+	__u32 rsvd;
+
+	struct cxl_command_info __user commands[]; /* out: supported commands */
+};
+
+/**
+ * struct cxl_send_command - Send a command to a memory device.
+ * @id: The command to send to the memory device. This must be one of the
+ *	commands returned by the query command.
+ * @flags: Flags for the command (input).
+ * @raw: Special fields for raw commands
+ * @raw.opcode: Opcode passed to hardware when using the RAW command.
+ * @raw.rsvd: Must be zero.
+ * @rsvd: Must be zero.
+ * @retval: Return value from the memory device (output).
+ * @in: Parameters associated with input payload.
+ * @in.size: Size of the payload to provide to the device (input).
+ * @in.rsvd: Must be zero.
+ * @in.payload: Pointer to memory for payload input, payload is little endian.
+ * @out: Parameters associated with output payload.
+ * @out.size: Size of the payload received from the device (input/output). This
+ *	      field is filled in by userspace to let the driver know how much
+ *	      space was allocated for output. It is populated by the driver to
+ *	      let userspace know how large the output payload actually was.
+ * @out.rsvd: Must be zero.
+ * @out.payload: Pointer to memory for payload output, payload is little endian.
+ *
+ * Mechanism for userspace to send a command to the hardware for processing. The
+ * driver will do basic validation on the command sizes. In some cases even the
+ * payload may be introspected. Userspace is required to allocate large enough
+ * buffers for size_out which can be variable length in certain situations.
+ */
+struct cxl_send_command {
+	__u32 id;
+	__u32 flags;
+	union {
+		struct {
+			__u16 opcode;
+			__u16 rsvd;
+		} raw;
+		__u32 rsvd;
+	};
+	__u32 retval;
+
+	struct {
+		__s32 size;
+		__u32 rsvd;
+		__u64 payload;
+	} in;
+
+	struct {
+		__s32 size;
+		__u32 rsvd;
+		__u64 payload;
+	} out;
+};
+
+#endif
diff --git a/cxl/lib/Makefile.am b/cxl/lib/Makefile.am
index 277f0cd..72c9ccd 100644
--- a/cxl/lib/Makefile.am
+++ b/cxl/lib/Makefile.am
@@ -3,7 +3,7 @@ include $(top_srcdir)/Makefile.am.in
 %.pc: %.pc.in Makefile
 	$(SED_PROCESS)
 
-pkginclude_HEADERS = ../libcxl.h
+pkginclude_HEADERS = ../libcxl.h ../cxl_mem.h
 lib_LTLIBRARIES = libcxl.la
 
 libcxl_la_SOURCES =\
-- 
2.31.1

