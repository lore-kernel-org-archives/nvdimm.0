Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBBB2FAF
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:29 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606939"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606939"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:21 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271375"
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
Subject: [ndctl PATCH v3 13/21] test/libcxl: introduce a command size fuzzing test
Date: Thu,  1 Jul 2021 14:09:57 -0600
Message-Id: <20210701201005.3065299-14-vishal.l.verma@intel.com>
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

Add a new test within test/libcxl which tries different combinations of
valid and invalid payload sizes, and ensures that the kernel responds as
expected by either succeeding, returning errors from the ioctl, adjusting
the out.size in the response, etc.

The fuzz set is a statically defined array which contains the different
combinations to test. Adding a new combination only needs appending to
this array.

Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/libcxl.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/test/libcxl.c b/test/libcxl.c
index 437b1ba..10f96f2 100644
--- a/test/libcxl.c
+++ b/test/libcxl.c
@@ -211,6 +211,117 @@ out_fail:
 	return rc;
 }
 
+struct cmd_fuzzer {
+	struct cxl_cmd *(*new_fn)(struct cxl_memdev *memdev);
+	int in;		/* in size to set in cmd (INT_MAX = don't change) */
+	int out;	/* out size to set in cmd (INT_MAX = don't change) */
+	int e_out;	/* expected out size returned (INT_MAX = don't check) */
+	int e_rc;	/* expected ioctl return (INT_MAX = don't check) */
+	int e_hwrc;	/* expected 'mbox_status' (INT_MAX = don't check) */
+} fuzz_set[] = {
+	{ cxl_cmd_new_identify, INT_MAX, INT_MAX, 67, 0, 0 },
+	{ cxl_cmd_new_identify, 64, INT_MAX, INT_MAX, -ENOMEM, INT_MAX },
+	{ cxl_cmd_new_identify, INT_MAX, 1024, 67, 0, INT_MAX },
+	{ cxl_cmd_new_identify, INT_MAX, 16, INT_MAX, -ENOMEM, INT_MAX },
+};
+
+static int do_one_cmd_size_test(struct cxl_memdev *memdev,
+		struct cmd_fuzzer *test)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_cmd *cmd;
+	int rc;
+
+	cmd = test->new_fn(memdev);
+	if (!cmd)
+		return -ENOMEM;
+
+	if (test->in != INT_MAX) {
+		rc = cxl_cmd_set_input_payload(cmd, NULL, test->in);
+		if (rc) {
+			fprintf(stderr,
+				"%s: %s: failed to set in.size (%d): %s\n",
+				__func__, devname, test->in, strerror(-rc));
+			goto out_fail;
+		}
+	}
+	if (test->out != INT_MAX) {
+		rc = cxl_cmd_set_output_payload(cmd, NULL, test->out);
+		if (rc) {
+			fprintf(stderr,
+				"%s: %s: failed to set out.size (%d): %s\n",
+				__func__, devname, test->out, strerror(-rc));
+			goto out_fail;
+		}
+	}
+
+	rc = cxl_cmd_submit(cmd);
+	if (test->e_rc != INT_MAX && rc != test->e_rc) {
+		fprintf(stderr, "%s: %s: expected cmd rc %d, got %d\n",
+			__func__, devname, test->e_rc, rc);
+		rc = -ENXIO;
+		goto out_fail;
+	}
+
+	rc = cxl_cmd_get_out_size(cmd);
+	if (test->e_out != INT_MAX && rc != test->e_out) {
+		fprintf(stderr, "%s: %s: expected response out.size %d, got %d\n",
+			__func__, devname, test->e_out, rc);
+		rc = -ENXIO;
+		goto out_fail;
+	}
+
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (test->e_hwrc != INT_MAX && rc != test->e_hwrc) {
+		fprintf(stderr, "%s: %s: expected firmware status %d, got %d\n",
+			__func__, devname, test->e_hwrc, rc);
+		rc = -ENXIO;
+		goto out_fail;
+	}
+	return 0;
+
+out_fail:
+	cxl_cmd_unref(cmd);
+	return rc;
+
+}
+
+static void print_fuzz_test_status(struct cmd_fuzzer *t, const char *devname,
+		unsigned long idx, const char *msg)
+{
+	fprintf(stderr,
+		"%s: fuzz_set[%lu]: in: %d, out %d, e_out: %d, e_rc: %d, e_hwrc: %d, result: %s\n",
+		devname, idx,
+		(t->in == INT_MAX) ? -1 : t->in,
+		(t->out == INT_MAX) ? -1 : t->out,
+		(t->e_out == INT_MAX) ? -1 : t->e_out,
+		(t->e_rc == INT_MAX) ? -1 : t->e_rc,
+		(t->e_hwrc == INT_MAX) ? -1 : t->e_hwrc,
+		msg);
+}
+
+static int test_cxl_cmd_fuzz_sizes(struct cxl_ctx *ctx)
+{
+	struct cxl_memdev *memdev;
+	unsigned long i;
+	int rc;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		const char *devname = cxl_memdev_get_devname(memdev);
+
+		for (i = 0; i < ARRAY_SIZE(fuzz_set); i++) {
+			rc = do_one_cmd_size_test(memdev, &fuzz_set[i]);
+			if (rc) {
+				print_fuzz_test_status(&fuzz_set[i], devname,
+					i, "FAIL");
+				return rc;
+			}
+			print_fuzz_test_status(&fuzz_set[i], devname, i, "OK");
+		}
+	}
+	return 0;
+}
+
 static int debugfs_write_raw_flag(char *str)
 {
 	char *path = "/sys/kernel/debug/cxl/mbox/raw_allow_all";
@@ -351,6 +462,7 @@ static do_test_fn do_test[] = {
 	test_cxl_emulation_env,
 	test_cxl_cmd_identify,
 	test_cxl_cmd_lsa,
+	test_cxl_cmd_fuzz_sizes,
 };
 
 static int test_libcxl(int loglevel, struct test_ctx *test, struct cxl_ctx *ctx)
-- 
2.31.1

