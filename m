Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99B57212E46E7
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:57:31 -0700 (PDT)
Subject: [ndctl PATCH v2 16/26] ndctl/test: Fix device-dax bus-model detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:40:47 -0700
Message-ID: <156426364779.531577.16728668403285407838.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Don't look for bus-model patches on pre-v5.1 kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/test/core.c b/test/core.c
index b9e3bbf7d7a9..888f5d8c0e42 100644
--- a/test/core.c
+++ b/test/core.c
@@ -168,6 +168,16 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 				&& !ndctl_test_attempt(test,
 					KERNEL_VERSION(4, 7, 0)))
 			continue;
+
+		/*
+		 * Skip device-dax bus-model modules on pre-v5.1
+		 */
+		if ((strstr(name, "dax_pmem_core")
+				|| strstr(name, "dax_pmem_compat"))
+				&& !ndctl_test_attempt(test,
+					KERNEL_VERSION(5, 1, 0)))
+			continue;
+
 retry:
 		rc = kmod_module_new_from_name(*ctx, name, mod);
 		if (rc) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
