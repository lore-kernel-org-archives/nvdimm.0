Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCC44B1E73;
	Mon, 19 May 2025 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747684871; cv=none; b=D58kA3hAswsQM1EOb6L+6bJOffiqNtjmmNqxRxkMtpHSbuLF9ACHWbcpseXbGCaK6iOWWKAPliPXZDL+xajRy2ynnj0Sa6lg0jSfU9htQeAK1olgm8i1ZWiPXQH3Fq6h9mmkFXEp+x3myOkS2znQZJx7dNza0cxBXy6AEs7QsTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747684871; c=relaxed/simple;
	bh=wLs3FhwGuYG804hBBjbb9x7jugrqnnaGdKAztLs9jlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bladSqIiLOkFfw1wBqK+z7HReMSCto0Mm37sBt0WHU86R0dJRHekU/9WPaUJNhsj6eWWNKjIFNIHpghpqz4SSq6xqecPt+Q5oF8LYTdX0fjlNo7ytznbRKiMlRV8Tks9hXqKgqu9CZ3FtRsLnbiNGIeds/FgD6bj4aDO4rzAGP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5CFC4CEE4;
	Mon, 19 May 2025 20:01:11 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v7 3/4] ndctl: Add features.h from kernel UAPI
Date: Mon, 19 May 2025 13:00:53 -0700
Message-ID: <20250519200056.3901498-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250519200056.3901498-1-dave.jiang@intel.com>
References: <20250519200056.3901498-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull in the kernel UAPI header files from CXL Features support and FWCTL.
This is needed to support building the CXL Features unit test.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/fwctl/cxl.h      |  56 ++++++++++++++
 cxl/fwctl/features.h | 179 +++++++++++++++++++++++++++++++++++++++++++
 cxl/fwctl/fwctl.h    | 141 ++++++++++++++++++++++++++++++++++
 3 files changed, 376 insertions(+)
 create mode 100644 cxl/fwctl/cxl.h
 create mode 100644 cxl/fwctl/features.h
 create mode 100644 cxl/fwctl/fwctl.h

diff --git a/cxl/fwctl/cxl.h b/cxl/fwctl/cxl.h
new file mode 100644
index 000000000000..43f522f0cdcd
--- /dev/null
+++ b/cxl/fwctl/cxl.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2024-2025 Intel Corporation
+ *
+ * These are definitions for the mailbox command interface of CXL subsystem.
+ */
+#ifndef _UAPI_FWCTL_CXL_H_
+#define _UAPI_FWCTL_CXL_H_
+
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <cxl/features.h>
+
+/**
+ * struct fwctl_rpc_cxl - ioctl(FWCTL_RPC) input for CXL
+ * @opcode: CXL mailbox command opcode
+ * @flags: Flags for the command (input).
+ * @op_size: Size of input payload.
+ * @reserved1: Reserved. Must be 0s.
+ * @get_sup_feats_in: Get Supported Features input
+ * @get_feat_in: Get Feature input
+ * @set_feat_in: Set Feature input
+ */
+struct fwctl_rpc_cxl {
+	__struct_group(fwctl_rpc_cxl_hdr, hdr, /* no attrs */,
+		__u32 opcode;
+		__u32 flags;
+		__u32 op_size;
+		__u32 reserved1;
+	);
+	union {
+		struct cxl_mbox_get_sup_feats_in get_sup_feats_in;
+		struct cxl_mbox_get_feat_in get_feat_in;
+		struct cxl_mbox_set_feat_in set_feat_in;
+	};
+};
+
+/**
+ * struct fwctl_rpc_cxl_out - ioctl(FWCTL_RPC) output for CXL
+ * @size: Size of the output payload
+ * @retval: Return value from device
+ * @get_sup_feats_out: Get Supported Features output
+ * @payload: raw byte stream of payload
+ */
+struct fwctl_rpc_cxl_out {
+	__struct_group(fwctl_rpc_cxl_out_hdr, hdr, /* no attrs */,
+		__u32 size;
+		__u32 retval;
+	);
+	union {
+		struct cxl_mbox_get_sup_feats_out get_sup_feats_out;
+		__DECLARE_FLEX_ARRAY(__u8, payload);
+	};
+};
+
+#endif
diff --git a/cxl/fwctl/features.h b/cxl/fwctl/features.h
new file mode 100644
index 000000000000..490606d7694b
--- /dev/null
+++ b/cxl/fwctl/features.h
@@ -0,0 +1,179 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2024,2025, Intel Corporation
+ *
+ * These are definitions for the mailbox command interface of CXL subsystem.
+ */
+#ifndef _UAPI_CXL_FEATURES_H_
+#define _UAPI_CXL_FEATURES_H_
+
+#include <linux/types.h>
+
+typedef unsigned char __uapi_uuid_t[16];
+
+#ifdef __KERNEL__
+#include <linux/uuid.h>
+/*
+ * Note, __uapi_uuid_t is 1-byte aligned on modern compilers and 4-byte
+ * aligned on others. Ensure that __uapi_uuid_t in a struct is placed at
+ * a 4-byte aligned offset, or the structure is packed, to ensure
+ * consistent padding.
+ */
+static_assert(sizeof(__uapi_uuid_t) == sizeof(uuid_t));
+#define __uapi_uuid_t uuid_t
+#endif
+
+/*
+ * struct cxl_mbox_get_sup_feats_in - Get Supported Features input
+ *
+ * @count: bytes of Feature data to return in output
+ * @start_idx: index of first requested Supported Feature Entry, 0 based.
+ * @reserved: reserved field, must be 0s.
+ *
+ * Get Supported Features (0x500h) CXL r3.2 8.2.9.6.1 command.
+ * Input block for Get support Feature
+ */
+struct cxl_mbox_get_sup_feats_in {
+	__le32 count;
+	__le16 start_idx;
+	__u8 reserved[2];
+} __attribute__ ((__packed__));
+
+/* CXL spec r3.2 Table 8-87 command effects */
+#define CXL_CMD_CONFIG_CHANGE_COLD_RESET	BIT(0)
+#define CXL_CMD_CONFIG_CHANGE_IMMEDIATE		BIT(1)
+#define CXL_CMD_DATA_CHANGE_IMMEDIATE		BIT(2)
+#define CXL_CMD_POLICY_CHANGE_IMMEDIATE		BIT(3)
+#define CXL_CMD_LOG_CHANGE_IMMEDIATE		BIT(4)
+#define CXL_CMD_SECURITY_STATE_CHANGE		BIT(5)
+#define CXL_CMD_BACKGROUND			BIT(6)
+#define CXL_CMD_BGCMD_ABORT_SUPPORTED		BIT(7)
+#define CXL_CMD_EFFECTS_VALID			BIT(9)
+#define CXL_CMD_CONFIG_CHANGE_CONV_RESET	BIT(10)
+#define CXL_CMD_CONFIG_CHANGE_CXL_RESET		BIT(11)
+#define CXL_CMD_EFFECTS_RESERVED		GENMASK(15, 12)
+
+/*
+ * struct cxl_feat_entry - Supported Feature Entry
+ * @uuid: UUID of the Feature
+ * @id: id to identify the feature. 0 based
+ * @get_feat_size: max bytes required for Get Feature command for this Feature
+ * @set_feat_size: max bytes required for Set Feature command for this Feature
+ * @flags: attribute flags
+ * @get_feat_ver: Get Feature version
+ * @set_feat_ver: Set Feature version
+ * @effects: Set Feature command effects
+ * @reserved: reserved, must be 0
+ *
+ * CXL spec r3.2 Table 8-109
+ * Get Supported Features Supported Feature Entry
+ */
+struct cxl_feat_entry {
+	__uapi_uuid_t uuid;
+	__le16 id;
+	__le16 get_feat_size;
+	__le16 set_feat_size;
+	__le32 flags;
+	__u8 get_feat_ver;
+	__u8 set_feat_ver;
+	__le16 effects;
+	__u8 reserved[18];
+} __attribute__ ((__packed__));
+
+/* @flags field for 'struct cxl_feat_entry' */
+#define CXL_FEATURE_F_CHANGEABLE		BIT(0)
+#define CXL_FEATURE_F_PERSIST_FW_UPDATE		BIT(4)
+#define CXL_FEATURE_F_DEFAULT_SEL		BIT(5)
+#define CXL_FEATURE_F_SAVED_SEL			BIT(6)
+
+/*
+ * struct cxl_mbox_get_sup_feats_out - Get Supported Features output
+ * @num_entries: number of Supported Feature Entries returned
+ * @supported_feats: number of supported Features
+ * @reserved: reserved, must be 0s.
+ * @ents: Supported Feature Entries array
+ *
+ * CXL spec r3.2 Table 8-108
+ * Get supported Features Output Payload
+ */
+struct cxl_mbox_get_sup_feats_out {
+	__struct_group(cxl_mbox_get_sup_feats_out_hdr, hdr, /* no attrs */,
+		__le16 num_entries;
+		__le16 supported_feats;
+		__u8 reserved[4];
+	);
+	struct cxl_feat_entry ents[] __counted_by_le(num_entries);
+} __attribute__ ((__packed__));
+
+/*
+ * Get Feature CXL spec r3.2 Spec 8.2.9.6.2
+ */
+
+/*
+ * struct cxl_mbox_get_feat_in - Get Feature input
+ * @uuid: UUID for Feature
+ * @offset: offset of the first byte in Feature data for output payload
+ * @count: count in bytes of Feature data returned
+ * @selection: 0 current value, 1 default value, 2 saved value
+ *
+ * CXL spec r3.2 section 8.2.9.6.2 Table 8-99
+ */
+struct cxl_mbox_get_feat_in {
+	__uapi_uuid_t uuid;
+	__le16 offset;
+	__le16 count;
+	__u8 selection;
+} __attribute__ ((__packed__));
+
+/*
+ * enum cxl_get_feat_selection - selection field of Get Feature input
+ */
+enum cxl_get_feat_selection {
+	CXL_GET_FEAT_SEL_CURRENT_VALUE,
+	CXL_GET_FEAT_SEL_DEFAULT_VALUE,
+	CXL_GET_FEAT_SEL_SAVED_VALUE,
+	CXL_GET_FEAT_SEL_MAX
+};
+
+/*
+ * Set Feature CXL spec r3.2  8.2.9.6.3
+ */
+
+/*
+ * struct cxl_mbox_set_feat_in - Set Features input
+ * @uuid: UUID for Feature
+ * @flags: set feature flags
+ * @offset: byte offset of Feature data to update
+ * @version: Feature version of the data in Feature Data
+ * @rsvd: reserved, must be 0s.
+ * @feat_data: raw byte stream of Features data to update
+ *
+ * CXL spec r3.2 section 8.2.9.6.3 Table 8-101
+ */
+struct cxl_mbox_set_feat_in {
+	__struct_group(cxl_mbox_set_feat_hdr, hdr, /* no attrs */,
+		__uapi_uuid_t uuid;
+		__le32 flags;
+		__le16 offset;
+		__u8 version;
+		__u8 rsvd[9];
+	);
+	__u8 feat_data[];
+}  __packed;
+
+/*
+ * enum cxl_set_feat_flag_data_transfer - Set Feature flags field
+ */
+enum cxl_set_feat_flag_data_transfer {
+	CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER = 0,
+	CXL_SET_FEAT_FLAG_INITIATE_DATA_TRANSFER,
+	CXL_SET_FEAT_FLAG_CONTINUE_DATA_TRANSFER,
+	CXL_SET_FEAT_FLAG_FINISH_DATA_TRANSFER,
+	CXL_SET_FEAT_FLAG_ABORT_DATA_TRANSFER,
+	CXL_SET_FEAT_FLAG_DATA_TRANSFER_MAX
+};
+
+#define CXL_SET_FEAT_FLAG_DATA_TRANSFER_MASK		GENMASK(2, 0)
+#define CXL_SET_FEAT_FLAG_DATA_SAVED_ACROSS_RESET	BIT(3)
+
+#endif
diff --git a/cxl/fwctl/fwctl.h b/cxl/fwctl/fwctl.h
new file mode 100644
index 000000000000..716ac0eee42d
--- /dev/null
+++ b/cxl/fwctl/fwctl.h
@@ -0,0 +1,141 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (c) 2024-2025, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef _UAPI_FWCTL_H
+#define _UAPI_FWCTL_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define FWCTL_TYPE 0x9A
+
+/**
+ * DOC: General ioctl format
+ *
+ * The ioctl interface follows a general format to allow for extensibility. Each
+ * ioctl is passed a structure pointer as the argument providing the size of
+ * the structure in the first u32. The kernel checks that any structure space
+ * beyond what it understands is 0. This allows userspace to use the backward
+ * compatible portion while consistently using the newer, larger, structures.
+ *
+ * ioctls use a standard meaning for common errnos:
+ *
+ *  - ENOTTY: The IOCTL number itself is not supported at all
+ *  - E2BIG: The IOCTL number is supported, but the provided structure has
+ *    non-zero in a part the kernel does not understand.
+ *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
+ *    understood, however a known field has a value the kernel does not
+ *    understand or support.
+ *  - EINVAL: Everything about the IOCTL was understood, but a field is not
+ *    correct.
+ *  - ENOMEM: Out of memory.
+ *  - ENODEV: The underlying device has been hot-unplugged and the FD is
+ *            orphaned.
+ *
+ * As well as additional errnos, within specific ioctls.
+ */
+enum {
+	FWCTL_CMD_BASE = 0,
+	FWCTL_CMD_INFO = 0,
+	FWCTL_CMD_RPC = 1,
+};
+
+enum fwctl_device_type {
+	FWCTL_DEVICE_TYPE_ERROR = 0,
+	FWCTL_DEVICE_TYPE_MLX5 = 1,
+	FWCTL_DEVICE_TYPE_CXL = 2,
+	FWCTL_DEVICE_TYPE_PDS = 4,
+};
+
+/**
+ * struct fwctl_info - ioctl(FWCTL_INFO)
+ * @size: sizeof(struct fwctl_info)
+ * @flags: Must be 0
+ * @out_device_type: Returns the type of the device from enum fwctl_device_type
+ * @device_data_len: On input the length of the out_device_data memory. On
+ *	output the size of the kernel's device_data which may be larger or
+ *	smaller than the input. Maybe 0 on input.
+ * @out_device_data: Pointer to a memory of device_data_len bytes. Kernel will
+ *	fill the entire memory, zeroing as required.
+ *
+ * Returns basic information about this fwctl instance, particularly what driver
+ * is being used to define the device_data format.
+ */
+struct fwctl_info {
+	__u32 size;
+	__u32 flags;
+	__u32 out_device_type;
+	__u32 device_data_len;
+	__aligned_u64 out_device_data;
+};
+#define FWCTL_INFO _IO(FWCTL_TYPE, FWCTL_CMD_INFO)
+
+/**
+ * enum fwctl_rpc_scope - Scope of access for the RPC
+ *
+ * Refer to fwctl.rst for a more detailed discussion of these scopes.
+ */
+enum fwctl_rpc_scope {
+	/**
+	 * @FWCTL_RPC_CONFIGURATION: Device configuration access scope
+	 *
+	 * Read/write access to device configuration. When configuration
+	 * is written to the device it remains in a fully supported state.
+	 */
+	FWCTL_RPC_CONFIGURATION = 0,
+	/**
+	 * @FWCTL_RPC_DEBUG_READ_ONLY: Read only access to debug information
+	 *
+	 * Readable debug information. Debug information is compatible with
+	 * kernel lockdown, and does not disclose any sensitive information. For
+	 * instance exposing any encryption secrets from this information is
+	 * forbidden.
+	 */
+	FWCTL_RPC_DEBUG_READ_ONLY = 1,
+	/**
+	 * @FWCTL_RPC_DEBUG_WRITE: Writable access to lockdown compatible debug information
+	 *
+	 * Allows write access to data in the device which may leave a fully
+	 * supported state. This is intended to permit intensive and possibly
+	 * invasive debugging. This scope will taint the kernel.
+	 */
+	FWCTL_RPC_DEBUG_WRITE = 2,
+	/**
+	 * @FWCTL_RPC_DEBUG_WRITE_FULL: Write access to all debug information
+	 *
+	 * Allows read/write access to everything. Requires CAP_SYS_RAW_IO, so
+	 * it is not required to follow lockdown principals. If in doubt
+	 * debugging should be placed in this scope. This scope will taint the
+	 * kernel.
+	 */
+	FWCTL_RPC_DEBUG_WRITE_FULL = 3,
+};
+
+/**
+ * struct fwctl_rpc - ioctl(FWCTL_RPC)
+ * @size: sizeof(struct fwctl_rpc)
+ * @scope: One of enum fwctl_rpc_scope, required scope for the RPC
+ * @in_len: Length of the in memory
+ * @out_len: Length of the out memory
+ * @in: Request message in device specific format
+ * @out: Response message in device specific format
+ *
+ * Deliver a Remote Procedure Call to the device FW and return the response. The
+ * call's parameters and return are marshaled into linear buffers of memory. Any
+ * errno indicates that delivery of the RPC to the device failed. Return status
+ * originating in the device during a successful delivery must be encoded into
+ * out.
+ *
+ * The format of the buffers matches the out_device_type from FWCTL_INFO.
+ */
+struct fwctl_rpc {
+	__u32 size;
+	__u32 scope;
+	__u32 in_len;
+	__u32 out_len;
+	__aligned_u64 in;
+	__aligned_u64 out;
+};
+#define FWCTL_RPC _IO(FWCTL_TYPE, FWCTL_CMD_RPC)
+
+#endif
-- 
2.49.0

