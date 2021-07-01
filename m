Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8835A29CA
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:29 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606934"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606934"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:21 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271369"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:20 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 12/21] test/libcxl: add a test for {set, get}_lsa commands
Date: Thu,  1 Jul 2021 14:09:56 -0600
Message-Id: <20210701201005.3065299-13-vishal.l.verma@intel.com>
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

Add a test to store a static string in the label storage area using the
SET_LSA mailbox command, and retrieve it using the GET_LSA command.
Compare the strings sent and received and ensure they match.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/libcxl.c    | 134 +++++++++++++++++++++++++++++++++++++++++++++++
 test/Makefile.am |   3 +-
 2 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/test/libcxl.c b/test/libcxl.c
index 241a4bb..437b1ba 100644
--- a/test/libcxl.c
+++ b/test/libcxl.c
@@ -19,6 +19,7 @@
 #include <linux/version.h>
 
 #include <util/size.h>
+#include <util/hexdump.h>
 #include <ccan/short_types/short_types.h>
 #include <ccan/array_size/array_size.h>
 #include <ccan/endian/endian.h>
@@ -210,6 +211,138 @@ out_fail:
 	return rc;
 }
 
+static int debugfs_write_raw_flag(char *str)
+{
+	char *path = "/sys/kernel/debug/cxl/mbox/raw_allow_all";
+	int fd = open(path, O_WRONLY|O_CLOEXEC);
+	int n, len = strlen(str) + 1, rc;
+
+	if (fd < 0)
+		return -errno;
+
+	n = write(fd, str, len);
+	rc = -errno;
+	close(fd);
+	if (n < len) {
+		fprintf(stderr, "failed to write %s to %s: %s\n", str, path,
+					strerror(errno));
+		return rc;
+	}
+	return 0;
+}
+
+static char *test_lsa_data = "LIBCXL_TEST LSA DATA 01";
+static int lsa_size = EXPECT_CMD_IDENTIFY_LSA_SIZE;
+
+static int test_set_lsa(struct cxl_memdev *memdev)
+{
+	int data_size = strlen(test_lsa_data) + 1;
+	struct cxl_cmd *cmd;
+	struct {
+		le32 offset;
+		le32 rsvd;
+		unsigned char data[lsa_size];
+	} __attribute__((packed)) set_lsa;
+	int rc;
+
+	set_lsa.offset = cpu_to_le32(0);
+	set_lsa.rsvd = cpu_to_le32(0);
+	memcpy(set_lsa.data, test_lsa_data, data_size);
+
+	cmd = cxl_cmd_new_raw(memdev, 0x4103);
+	if (!cmd)
+		return -ENOMEM;
+
+	rc = cxl_cmd_set_input_payload(cmd, &set_lsa, sizeof(set_lsa));
+	if (rc) {
+		fprintf(stderr, "%s: %s: cmd setup failed: %s\n",
+			__func__, cxl_memdev_get_devname(memdev),
+			strerror(-rc));
+		goto out_fail;
+	}
+
+	rc = debugfs_write_raw_flag("Y");
+	if (rc < 0)
+		return rc;
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		fprintf(stderr, "%s: %s: cmd submission failed: %s\n",
+			__func__, cxl_memdev_get_devname(memdev),
+			strerror(-rc));
+
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0) {
+		fprintf(stderr, "%s: %s: firmware status: %d\n",
+			__func__, cxl_memdev_get_devname(memdev), rc);
+		return -ENXIO;
+	}
+
+	if(debugfs_write_raw_flag("N") < 0)
+		fprintf(stderr, "%s: %s: failed to restore raw flag\n",
+			__func__, cxl_memdev_get_devname(memdev));
+
+out_fail:
+	cxl_cmd_unref(cmd);
+	return rc;
+}
+
+static int test_cxl_cmd_lsa(struct cxl_ctx *ctx)
+{
+	int data_size = strlen(test_lsa_data) + 1;
+	struct cxl_memdev *memdev;
+	struct cxl_cmd *cmd;
+	unsigned char *buf;
+	int rc;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		rc = test_set_lsa(memdev);
+		if (rc)
+			return rc;
+
+		cmd = cxl_cmd_new_get_lsa(memdev, 0, lsa_size);
+		if (!cmd)
+			return -ENOMEM;
+		rc = cxl_cmd_set_output_payload(cmd, NULL, lsa_size);
+		if (rc) {
+			fprintf(stderr, "%s: output buffer allocation: %s\n",
+				__func__, strerror(-rc));
+			return rc;
+		}
+		rc = cxl_cmd_submit(cmd);
+		if (rc < 0) {
+			fprintf(stderr, "%s: %s: cmd submission failed: %s\n",
+				__func__, cxl_memdev_get_devname(memdev),
+				strerror(-rc));
+			goto out_fail;
+		}
+
+		rc = cxl_cmd_get_mbox_status(cmd);
+		if (rc != 0) {
+			fprintf(stderr, "%s: %s: firmware status: %d\n",
+				__func__, cxl_memdev_get_devname(memdev), rc);
+			return -ENXIO;
+		}
+
+		buf = cxl_cmd_get_lsa_get_payload(cmd);
+		if (rc < 0)
+			goto out_fail;
+
+		if (memcmp(buf, test_lsa_data, data_size) != 0) {
+			fprintf(stderr, "%s: LSA data mismatch.\n", __func__);
+			hex_dump_buf(buf, data_size);
+			rc = -EIO;
+			goto out_fail;
+		}
+		cxl_cmd_unref(cmd);
+	}
+	return 0;
+
+out_fail:
+	cxl_cmd_unref(cmd);
+	return rc;
+}
+
 typedef int (*do_test_fn)(struct cxl_ctx *ctx);
 
 static do_test_fn do_test[] = {
@@ -217,6 +350,7 @@ static do_test_fn do_test[] = {
 	test_cxl_presence,
 	test_cxl_emulation_env,
 	test_cxl_cmd_identify,
+	test_cxl_cmd_lsa,
 };
 
 static int test_libcxl(int loglevel, struct test_ctx *test, struct cxl_ctx *ctx)
diff --git a/test/Makefile.am b/test/Makefile.am
index ce492a4..23f4860 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -86,7 +86,8 @@ LIBNDCTL_LIB =\
 testcore =\
 	core.c \
 	../util/log.c \
-	../util/sysfs.c
+	../util/sysfs.c \
+	../util/hexdump.c
 
 libndctl_SOURCES = libndctl.c $(testcore)
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
-- 
2.31.1

