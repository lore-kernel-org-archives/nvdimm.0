Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2762CAC
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:22:01 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511726"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511726"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555121"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:57 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 12/17] libcxl: add interfaces for label operations
Date: Thu,  7 Oct 2021 02:21:34 -0600
Message-Id: <20211007082139.3088615-13-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6123; h=from:subject; bh=ewb8qacAV37dYbOaWMqpC393PrjTJPFrPkDYtD+kacU=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx67iXbLGfz+xqOVfiX8yTqLlvuWOurdgSf9Cq22mOqclW K5/mjlIWBjEOBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEyE6QzD/4rMD37LbIO3V65c3iAsIL XhkKMtU6uxeJrWeZnU6Z+f7mFk+HbJkudoct/yaw9mp+T9u8Jon3NYKTl4manxQ9/X1nsimAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add libcxl interfaces to allow performinfg label (LSA) manipulations.
Add a 'cxl_cmd_new_set_lsa' interface to create a 'Set LSA' mailbox
command payload, and interfaces to read, write, and zero the LSA area on
a memdev.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |   6 ++
 cxl/lib/libcxl.c   | 137 +++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       |   7 +++
 cxl/lib/libcxl.sym |   4 ++
 4 files changed, 154 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 671f12f..89212df 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -79,6 +79,12 @@ struct cxl_cmd_get_lsa_in {
 	le32 length;
 } __attribute__((packed));
 
+struct cxl_cmd_set_lsa {
+	le32 offset;
+	le32 rsvd;
+	unsigned char lsa_data[0];
+} __attribute__ ((packed));
+
 struct cxl_cmd_get_health_info {
 	u8 health_status;
 	u8 media_status;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 59d091c..8dd69cf 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1126,3 +1126,140 @@ CXL_EXPORT int cxl_cmd_get_out_size(struct cxl_cmd *cmd)
 {
 	return cmd->send_cmd->out.size;
 }
+
+CXL_EXPORT struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
+		void *lsa_buf, unsigned int offset, unsigned int length)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_cmd_set_lsa *set_lsa;
+	struct cxl_cmd *cmd;
+	int rc;
+
+	cmd = cxl_cmd_new_generic(memdev, CXL_MEM_COMMAND_ID_SET_LSA);
+	if (!cmd)
+		return NULL;
+
+	/* this will allocate 'in.payload' */
+	rc = cxl_cmd_set_input_payload(cmd, NULL, sizeof(*set_lsa) + length);
+	if (rc) {
+		err(ctx, "%s: cmd setup failed: %s\n",
+			cxl_memdev_get_devname(memdev), strerror(-rc));
+		goto out_fail;
+	}
+	set_lsa = (void *)cmd->send_cmd->in.payload;
+	set_lsa->offset = cpu_to_le32(offset);
+	memcpy(set_lsa->lsa_data, lsa_buf, length);
+
+	return cmd;
+
+out_fail:
+	cxl_cmd_unref(cmd);
+	return NULL;
+}
+
+enum lsa_op {
+	LSA_OP_GET,
+	LSA_OP_SET,
+	LSA_OP_ZERO,
+};
+
+static int lsa_op(struct cxl_memdev *memdev, int op, void **buf,
+		size_t length, size_t offset)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_cmd *cmd;
+	void *zero_buf = NULL;
+	ssize_t ret_len;
+	int rc = 0;
+
+	if (op != LSA_OP_ZERO && (buf == NULL || *buf == NULL)) {
+		err(ctx, "%s: LSA buffer cannot be NULL\n", devname);
+		return -EINVAL;
+	}
+
+	/* TODO: handle the case for offset + len > mailbox payload size */
+	switch (op) {
+	case LSA_OP_GET:
+		if (length == 0)
+			length = memdev->lsa_size;
+		cmd = cxl_cmd_new_read_label(memdev, offset, length);
+		if (!cmd)
+			return -ENOMEM;
+		rc = cxl_cmd_set_output_payload(cmd, *buf, length);
+		if (rc) {
+			err(ctx, "%s: cmd setup failed: %s\n",
+			    cxl_memdev_get_devname(memdev), strerror(-rc));
+			goto out;
+		}
+		break;
+	case LSA_OP_ZERO:
+		if (length == 0)
+			length = memdev->lsa_size;
+		zero_buf = calloc(1, length);
+		if (!zero_buf)
+			return -ENOMEM;
+		buf = &zero_buf;
+		/* fall through */
+	case LSA_OP_SET:
+		cmd = cxl_cmd_new_write_label(memdev, *buf, offset, length);
+		if (!cmd) {
+			rc = -ENOMEM;
+			goto out_free;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0) {
+		err(ctx, "%s: cmd submission failed: %s\n",
+			devname, strerror(-rc));
+		goto out;
+	}
+
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0) {
+		err(ctx, "%s: firmware status: %d\n",
+			devname, rc);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (op == LSA_OP_GET) {
+		ret_len = cxl_cmd_read_label_get_payload(cmd, *buf, length);
+		if (ret_len < 0) {
+			rc = ret_len;
+			goto out;
+		}
+	}
+
+	/*
+	 * TODO: If writing, the memdev may need to be disabled/re-enabled to
+	 * refresh any cached LSA data in the kernel.
+	 */
+
+out:
+	cxl_cmd_unref(cmd);
+out_free:
+	free(zero_buf);
+	return rc;
+}
+
+CXL_EXPORT int cxl_memdev_zero_label(struct cxl_memdev *memdev)
+{
+	return lsa_op(memdev, LSA_OP_ZERO, NULL, 0, 0);
+}
+
+CXL_EXPORT int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf,
+		size_t length, size_t offset)
+{
+	return lsa_op(memdev, LSA_OP_SET, &buf, length, offset);
+}
+
+CXL_EXPORT int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf,
+		size_t length, size_t offset)
+{
+	return lsa_op(memdev, LSA_OP_GET, &buf, length, offset);
+}
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 2e24371..a832806 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -44,6 +44,11 @@ unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 int cxl_memdev_is_active(struct cxl_memdev *memdev);
+int cxl_memdev_zero_label(struct cxl_memdev *memdev);
+int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
+		size_t offset);
+int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
+		size_t offset);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
@@ -101,6 +106,8 @@ struct cxl_cmd *cxl_cmd_new_read_label(struct cxl_memdev *memdev,
 		unsigned int offset, unsigned int length);
 ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd, void *buf,
 		unsigned int length);
+struct cxl_cmd *cxl_cmd_new_write_label(struct cxl_memdev *memdev,
+		void *buf, unsigned int offset, unsigned int length);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 0e82030..490d6da 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -80,4 +80,8 @@ LIBCXL_4 {
 global:
 	cxl_memdev_get_label_size;
 	cxl_memdev_is_active;
+	cxl_cmd_new_write_label;
+	cxl_memdev_zero_label;
+	cxl_memdev_write_label;
+	cxl_memdev_read_label;
 } LIBCXL_3;
-- 
2.31.1

