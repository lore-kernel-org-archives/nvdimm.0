Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DB5021954068
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:05:13 -0700 (PDT)
Subject: [ndctl PATCH 4/5] test, libndctl: get ndctl_btt_get_size() on v4.8+
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:59:19 -0700
Message-ID: <149272195993.23427.16508179192531953920.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

This support went into the kernel with commit abe8b4e3cef8 "nvdimm, btt:
add a size attribute for BTTs"

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index 38a0bb746905..0381ee2cdefb 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -970,6 +970,8 @@ static int check_pfn_create(struct ndctl_region *region,
 
 static int check_btt_size(struct ndctl_btt *btt)
 {
+	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
 	unsigned long long ns_size = ndctl_namespace_get_size(ndns);
 	unsigned long sect_size = ndctl_btt_get_sector_size(btt);
@@ -1018,6 +1020,10 @@ static int check_btt_size(struct ndctl_btt *btt)
 		return -ENXIO;
 	}
 
+	/* prior to 4.8 btt devices did not have a size attribute */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0)))
+		return 0;
+
 	expect = expect_table[size_select][sect_select];
 	actual = ndctl_btt_get_size(btt);
 	if (expect != actual) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
