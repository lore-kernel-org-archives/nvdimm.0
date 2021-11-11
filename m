Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF962C95
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:57 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253825"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253825"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:54 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579058"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:53 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 05/16] libcxl: add support for command query and submission
Date: Thu, 11 Nov 2021 13:44:25 -0700
Message-Id: <20211111204436.1560365-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13645; h=from:subject; bh=omaDV7DtylDg212OIawdTj/ex1WX9gHxPKDHLnCH6hs=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DRs/rDzdUh08f66T0ZKX5QGOUYXzLYqaWt86WjmceHzu 6oLbHaUsDGIcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIaQrDT8Y688R7E5iElO6wf9Lkz3 D355LxKBHZEWn0fd4i47e6FxgZ2kxK4vrkvJVtntmKqN9lnTPLah5HpBbDz2XvJe43ZIWzAAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a set of APIs around 'cxl_cmd' for querying the kernel for supported
commands, allocating and validating command structures against the
supported set, and submitting the commands.

'Query Commands' and 'Send Command' are implemented as IOCTLs in the
kernel. 'Query Commands' returns information about each supported
command, such as flags governing its use, or input and output payload
sizes. This information is used to validate command support, as well as
set up input and output buffers for command submission.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  33 ++++
 cxl/lib/libcxl.c   | 390 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |  11 ++
 cxl/lib/libcxl.sym |   9 ++
 4 files changed, 443 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index fc88fa1..87ca17e 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -4,6 +4,9 @@
 #define _LIBCXL_PRIVATE_H_
 
 #include <libkmod.h>
+#include <cxl/cxl_mem.h>
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
 
@@ -21,6 +24,36 @@ struct cxl_memdev {
 	struct kmod_module *module;
 };
 
+enum cxl_cmd_query_status {
+	CXL_CMD_QUERY_NOT_RUN = 0,
+	CXL_CMD_QUERY_OK,
+	CXL_CMD_QUERY_UNSUPPORTED,
+};
+
+/**
+ * struct cxl_cmd - CXL memdev command
+ * @memdev: the memory device to which the command is being sent
+ * @query_cmd: structure for the Linux 'Query commands' ioctl
+ * @send_cmd: structure for the Linux 'Send command' ioctl
+ * @input_payload: buffer for input payload managed by libcxl
+ * @output_payload: buffer for output payload managed by libcxl
+ * @refcount: reference for passing command buffer around
+ * @query_status: status from query_commands
+ * @query_idx: index of 'this' command in the query_commands array
+ * @status: command return status from the device
+ */
+struct cxl_cmd {
+	struct cxl_memdev *memdev;
+	struct cxl_mem_query_commands *query_cmd;
+	struct cxl_send_command *send_cmd;
+	void *input_payload;
+	void *output_payload;
+	int refcount;
+	int query_status;
+	int query_idx;
+	int status;
+};
+
 static inline int check_kmod(struct kmod_ctx *kmod_ctx)
 {
 	return kmod_ctx ? 0 : -ENXIO;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index c15e987..727d599 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -9,14 +9,17 @@
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <sys/ioctl.h>
 #include <sys/sysmacros.h>
 #include <uuid/uuid.h>
 #include <ccan/list/list.h>
 #include <ccan/array_size/array_size.h>
 
 #include <util/log.h>
+#include <util/size.h>
 #include <util/sysfs.h>
 #include <util/bitmap.h>
+#include <cxl/cxl_mem.h>
 #include <cxl/libcxl.h>
 #include "private.h"
 
@@ -343,3 +346,390 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
 {
 	return memdev->firmware_version;
 }
+
+CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
+{
+	if (!cmd)
+		return;
+	if (--cmd->refcount == 0) {
+		free(cmd->query_cmd);
+		free(cmd->send_cmd);
+		free(cmd->input_payload);
+		free(cmd->output_payload);
+		free(cmd);
+	}
+}
+
+CXL_EXPORT void cxl_cmd_ref(struct cxl_cmd *cmd)
+{
+	cmd->refcount++;
+}
+
+static int cxl_cmd_alloc_query(struct cxl_cmd *cmd, int num_cmds)
+{
+	size_t size;
+
+	if (!cmd)
+		return -EINVAL;
+
+	if (cmd->query_cmd != NULL)
+		free(cmd->query_cmd);
+
+	size = struct_size(cmd->query_cmd, commands, num_cmds);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	cmd->query_cmd = calloc(1, size);
+	if (!cmd->query_cmd)
+		return -ENOMEM;
+
+	cmd->query_cmd->n_commands = num_cmds;
+
+	return 0;
+}
+
+static struct cxl_cmd *cxl_cmd_new(struct cxl_memdev *memdev)
+{
+	struct cxl_cmd *cmd;
+	size_t size;
+
+	size = sizeof(*cmd);
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cxl_cmd_ref(cmd);
+	cmd->memdev = memdev;
+
+	return cmd;
+}
+
+static int __do_cmd(struct cxl_cmd *cmd, int ioctl_cmd, int fd)
+{
+	void *cmd_buf;
+	int rc;
+
+	switch (ioctl_cmd) {
+	case CXL_MEM_QUERY_COMMANDS:
+		cmd_buf = cmd->query_cmd;
+		break;
+	case CXL_MEM_SEND_COMMAND:
+		cmd_buf = cmd->send_cmd;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rc = ioctl(fd, ioctl_cmd, cmd_buf);
+	if (rc < 0)
+		rc = -errno;
+
+	return rc;
+}
+
+static int do_cmd(struct cxl_cmd *cmd, int ioctl_cmd)
+{
+	char *path;
+	struct stat st;
+	unsigned int major, minor;
+	int rc = 0, fd;
+	struct cxl_memdev *memdev = cmd->memdev;
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	const char *devname = cxl_memdev_get_devname(memdev);
+
+	major = cxl_memdev_get_major(memdev);
+	minor = cxl_memdev_get_minor(memdev);
+
+	if (asprintf(&path, "/dev/cxl/%s", devname) < 0)
+		return -ENOMEM;
+
+	fd = open(path, O_RDWR);
+	if (fd < 0) {
+		err(ctx, "failed to open %s: %s\n", path, strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+	if (fstat(fd, &st) >= 0 && S_ISCHR(st.st_mode)
+			&& major(st.st_rdev) == major
+			&& minor(st.st_rdev) == minor) {
+		rc = __do_cmd(cmd, ioctl_cmd, fd);
+	} else {
+		err(ctx, "failed to validate %s as a CXL memdev node\n", path);
+		rc = -ENXIO;
+	}
+	close(fd);
+out:
+	free(path);
+	return rc;
+}
+
+static int alloc_do_query(struct cxl_cmd *cmd, int num_cmds)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(cmd->memdev);
+	int rc;
+
+	rc = cxl_cmd_alloc_query(cmd, num_cmds);
+	if (rc)
+		return rc;
+
+	rc = do_cmd(cmd, CXL_MEM_QUERY_COMMANDS);
+	if (rc < 0)
+		err(ctx, "%s: query commands failed: %s\n",
+			cxl_memdev_get_devname(cmd->memdev),
+			strerror(-rc));
+	return rc;
+}
+
+static int cxl_cmd_do_query(struct cxl_cmd *cmd)
+{
+	struct cxl_memdev *memdev = cmd->memdev;
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	const char *devname = cxl_memdev_get_devname(memdev);
+	int rc, n_commands;
+
+	switch (cmd->query_status) {
+	case CXL_CMD_QUERY_OK:
+		return 0;
+	case CXL_CMD_QUERY_UNSUPPORTED:
+		return -EOPNOTSUPP;
+	case CXL_CMD_QUERY_NOT_RUN:
+		break;
+	default:
+		err(ctx, "%s: Unknown query_status %d\n",
+			devname, cmd->query_status);
+		return -EINVAL;
+	}
+
+	rc = alloc_do_query(cmd, 0);
+	if (rc)
+		return rc;
+
+	n_commands = cmd->query_cmd->n_commands;
+	dbg(ctx, "%s: supports %d commands\n", devname, n_commands);
+
+	return alloc_do_query(cmd, n_commands);
+}
+
+static int cxl_cmd_validate(struct cxl_cmd *cmd, u32 cmd_id)
+{
+	struct cxl_memdev *memdev = cmd->memdev;
+	struct cxl_mem_query_commands *query = cmd->query_cmd;
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	u32 i;
+
+	for (i = 0; i < query->n_commands; i++) {
+		struct cxl_command_info *cinfo = &query->commands[i];
+		const char *cmd_name = cxl_command_names[cinfo->id].name;
+
+		if (cinfo->id != cmd_id)
+			continue;
+
+		dbg(ctx, "%s: %s: in: %d, out %d, flags: %#08x\n",
+			devname, cmd_name, cinfo->size_in,
+			cinfo->size_out, cinfo->flags);
+
+		cmd->query_idx = i;
+		cmd->query_status = CXL_CMD_QUERY_OK;
+		return 0;
+	}
+	cmd->query_status = CXL_CMD_QUERY_UNSUPPORTED;
+	return -EOPNOTSUPP;
+}
+
+CXL_EXPORT int cxl_cmd_set_input_payload(struct cxl_cmd *cmd, void *buf,
+		int size)
+{
+	struct cxl_memdev *memdev = cmd->memdev;
+
+	if (size > memdev->payload_max || size < 0)
+		return -EINVAL;
+
+	if (!buf) {
+
+		/* If the user didn't supply a buffer, allocate it */
+		cmd->input_payload = calloc(1, size);
+		if (!cmd->input_payload)
+			return -ENOMEM;
+		cmd->send_cmd->in.payload = (u64)cmd->input_payload;
+	} else {
+		/*
+		 * Use user-buffer as is. If an automatic allocation was
+		 * previously made (based on a fixed size from query),
+		 * it will get freed during unref.
+		 */
+		cmd->send_cmd->in.payload = (u64)buf;
+	}
+	cmd->send_cmd->in.size = size;
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_cmd_set_output_payload(struct cxl_cmd *cmd, void *buf,
+		int size)
+{
+	struct cxl_memdev *memdev = cmd->memdev;
+
+	if (size > memdev->payload_max || size < 0)
+		return -EINVAL;
+
+	if (!buf) {
+
+		/* If the user didn't supply a buffer, allocate it */
+		cmd->output_payload = calloc(1, size);
+		if (!cmd->output_payload)
+			return -ENOMEM;
+		cmd->send_cmd->out.payload = (u64)cmd->output_payload;
+	} else {
+		/*
+		 * Use user-buffer as is. If an automatic allocation was
+		 * previously made (based on a fixed size from query),
+		 * it will get freed during unref.
+		 */
+		cmd->send_cmd->out.payload = (u64)buf;
+	}
+	cmd->send_cmd->out.size = size;
+
+	return 0;
+}
+
+static int cxl_cmd_alloc_send(struct cxl_cmd *cmd, u32 cmd_id)
+{
+	struct cxl_mem_query_commands *query = cmd->query_cmd;
+	struct cxl_command_info *cinfo = &query->commands[cmd->query_idx];
+	size_t size;
+
+	if (!query)
+		return -EINVAL;
+
+	size = sizeof(struct cxl_send_command);
+	cmd->send_cmd = calloc(1, size);
+	if (!cmd->send_cmd)
+		return -ENOMEM;
+
+	if (cinfo->id != cmd_id)
+		return -EINVAL;
+
+	cmd->send_cmd->id = cmd_id;
+
+	if (cinfo->size_in > 0) {
+		cmd->input_payload = calloc(1, cinfo->size_in);
+		if (!cmd->input_payload)
+			return -ENOMEM;
+		cmd->send_cmd->in.payload = (u64)cmd->input_payload;
+		cmd->send_cmd->in.size = cinfo->size_in;
+	}
+	if (cinfo->size_out > 0) {
+		cmd->output_payload = calloc(1, cinfo->size_out);
+		if (!cmd->output_payload)
+			return -ENOMEM;
+		cmd->send_cmd->out.payload = (u64)cmd->output_payload;
+		cmd->send_cmd->out.size = cinfo->size_out;
+	}
+
+	return 0;
+}
+
+static struct cxl_cmd *cxl_cmd_new_generic(struct cxl_memdev *memdev,
+		u32 cmd_id)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_cmd *cmd;
+	int rc;
+
+	cmd = cxl_cmd_new(memdev);
+	if (!cmd)
+		return NULL;
+
+	rc = cxl_cmd_do_query(cmd);
+	if (rc) {
+		err(ctx, "%s: query returned: %s\n", devname, strerror(-rc));
+		goto fail;
+	}
+
+	rc = cxl_cmd_validate(cmd, cmd_id);
+	if (rc) {
+		errno = -rc;
+		goto fail;
+	}
+
+	rc = cxl_cmd_alloc_send(cmd, cmd_id);
+	if (rc) {
+		errno = -rc;
+		goto fail;
+	}
+
+	cmd->status = 1;
+	return cmd;
+
+fail:
+	cxl_cmd_unref(cmd);
+	return NULL;
+}
+
+CXL_EXPORT const char *cxl_cmd_get_devname(struct cxl_cmd *cmd)
+{
+	return cxl_memdev_get_devname(cmd->memdev);
+}
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev,
+		int opcode)
+{
+	struct cxl_cmd *cmd;
+
+	/* opcode '0' is reserved */
+	if (opcode <= 0) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_RAW);
+	if (!cmd)
+		return NULL;
+
+	cmd->send_cmd->raw.opcode = opcode;
+	return cmd;
+}
+
+CXL_EXPORT int cxl_cmd_submit(struct cxl_cmd *cmd)
+{
+	struct cxl_memdev *memdev = cmd->memdev;
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	int rc;
+
+	switch (cmd->query_status) {
+	case CXL_CMD_QUERY_OK:
+		break;
+	case CXL_CMD_QUERY_UNSUPPORTED:
+		return -EOPNOTSUPP;
+	case CXL_CMD_QUERY_NOT_RUN:
+		return -EINVAL;
+	default:
+		err(ctx, "%s: Unknown query_status %d\n",
+			devname, cmd->query_status);
+		return -EINVAL;
+	}
+
+	dbg(ctx, "%s: submitting SEND cmd: in: %d, out: %d\n", devname,
+		cmd->send_cmd->in.size, cmd->send_cmd->out.size);
+	rc = do_cmd(cmd, CXL_MEM_SEND_COMMAND);
+	cmd->status = cmd->send_cmd->retval;
+	dbg(ctx, "%s: got SEND cmd: in: %d, out: %d, retval: %d, status: %d\n",
+		devname, cmd->send_cmd->in.size, cmd->send_cmd->out.size,
+		rc, cmd->status);
+
+	return rc;
+}
+
+CXL_EXPORT int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd)
+{
+	return cmd->status;
+}
+
+CXL_EXPORT int cxl_cmd_get_out_size(struct cxl_cmd *cmd)
+{
+	return cmd->send_cmd->out.size;
+}
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index fd06790..6e87b80 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -48,6 +48,17 @@ const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
              memdev != NULL; \
              memdev = cxl_memdev_get_next(memdev))
 
+struct cxl_cmd;
+const char *cxl_cmd_get_devname(struct cxl_cmd *cmd);
+struct cxl_cmd *cxl_cmd_new_raw(struct cxl_memdev *memdev, int opcode);
+int cxl_cmd_set_input_payload(struct cxl_cmd *cmd, void *in, int size);
+int cxl_cmd_set_output_payload(struct cxl_cmd *cmd, void *out, int size);
+void cxl_cmd_ref(struct cxl_cmd *cmd);
+void cxl_cmd_unref(struct cxl_cmd *cmd);
+int cxl_cmd_submit(struct cxl_cmd *cmd);
+int cxl_cmd_get_mbox_status(struct cxl_cmd *cmd);
+int cxl_cmd_get_out_size(struct cxl_cmd *cmd);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 2616e5c..3900f90 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -20,6 +20,15 @@ global:
 	cxl_memdev_get_pmem_size;
 	cxl_memdev_get_ram_size;
 	cxl_memdev_get_firmware_verison;
+	cxl_cmd_get_devname;
+	cxl_cmd_new_raw;
+	cxl_cmd_set_input_payload;
+	cxl_cmd_set_output_payload;
+	cxl_cmd_ref;
+	cxl_cmd_unref;
+	cxl_cmd_submit;
+	cxl_cmd_get_mbox_status;
+	cxl_cmd_get_out_size;
 local:
         *;
 };
-- 
2.31.1

