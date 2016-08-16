Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id C89F41A1E13
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:22 -0700 (PDT)
Subject: [ndctl PATCH 6/8] test, create-namespace: reset global data
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:59 -0700
Message-ID: <147136811941.27902.5105214686399519689.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Before we add unit tests that call cmd_create_namespace() directly, we
need to ensure that consecutive calls to cmd_create_namespace() behave
the same as consecutive invocations of 'ndctl create-namespace'. I.e.
re-initialize global parameter to zero.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |   12 ++++++++++++
 test.h                            |    1 +
 2 files changed, 13 insertions(+)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 12ade241ff64..13811ea22da1 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -51,6 +51,18 @@ static struct parameters {
 	const char *sector_size;
 } param;
 
+void builtin_xaction_namespace_reset(void)
+{
+	/*
+	 * Initialize parameter data for the unit test case where
+	 * multiple calls to cmd_<action>_namespace() are made without
+	 * an intervening exit().
+	 */
+	verbose = false;
+	force = false;
+	memset(&param, 0, sizeof(param));
+}
+
 #define NSLABEL_NAME_LEN 64
 struct parsed_parameters {
 	enum ndctl_pfn_loc loc;
diff --git a/test.h b/test.h
index 120798f2dd75..331d4131e2c7 100644
--- a/test.h
+++ b/test.h
@@ -12,6 +12,7 @@ int __ndctl_test_attempt(struct ndctl_test *test, unsigned int kver,
 void __ndctl_test_skip(struct ndctl_test *test, const char *caller, int line);
 #define ndctl_test_skip(t) __ndctl_test_skip(t, __func__, __LINE__)
 struct ndctl_namespace *ndctl_get_test_dev(struct ndctl_ctx *ctx);
+void builtin_xaction_namespace_reset(void);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
