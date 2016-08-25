Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC1551A1E4D
 for <linux-nvdimm@lists.01.org>; Thu, 25 Aug 2016 17:00:23 -0700 (PDT)
Subject: [ndctl PATCH] test, libndctl: check btt size
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Aug 2016 16:58:00 -0700
Message-ID: <147216948018.40698.3869445232513766645.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that the kernel reports the size of the btt, lets check that the
size stays constant across kernel updates.  I.e. if we inadvertently
introduce a change that causes the btt to reduce the effective capacity
of the block device, this test is meant to catch it.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index 5f86addc5c7e..e36fe8a4fe6f 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -937,6 +937,68 @@ static int check_pfn_create(struct ndctl_region *region,
 	return rc;
 }
 
+static int check_btt_size(struct ndctl_btt *btt)
+{
+	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
+	unsigned long long ns_size = ndctl_namespace_get_size(ndns);
+	unsigned long sect_size = ndctl_btt_get_sector_size(btt);
+	unsigned long long actual, expect;
+	int size_select, sect_select;
+	unsigned long long expect_table[][2] = {
+		[0] = {
+			[0] = 0x11b4400,
+			[1] = 0x8da2000,
+		},
+		[1] = {
+			[0] = 0x13b0400,
+			[1] = 0x9d82000,
+		},
+		[2] = {
+			[0] = 0x1aa2600,
+			[1] = 0xd513000,
+		},
+	};
+
+	if (sect_size >= SZ_4K)
+		sect_select = 1;
+	else if (sect_size >= 512)
+		sect_select = 0;
+	else {
+		fprintf(stderr, "%s: %s unexpected sector size: %lx\n",
+				__func__, ndctl_btt_get_devname(btt),
+				sect_size);
+		return -ENXIO;
+	}
+
+	switch (ns_size) {
+	case SZ_18M:
+		size_select = 0;
+		break;
+	case SZ_20M:
+		size_select = 1;
+		break;
+	case SZ_27M:
+		size_select = 2;
+		break;
+	default:
+		fprintf(stderr, "%s: %s unexpected namespace size: %llx\n",
+				__func__, ndctl_namespace_get_devname(ndns),
+				ns_size);
+		break;
+	}
+
+	expect = expect_table[size_select][sect_select];
+	actual = ndctl_btt_get_size(btt);
+	if (expect != actual) {
+		fprintf(stderr, "%s: namespace: %s unexpected size: %llx (expected: %llx)\n",
+				ndctl_btt_get_devname(btt),
+				ndctl_namespace_get_devname(ndns), actual, expect);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
 static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace *ndns,
 		struct namespace *namespace)
 {
@@ -982,6 +1044,10 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
 			fprintf(stderr, "%s: expected safe mode got: %d\n",
 					devname, mode);
 
+		rc = check_btt_size(btt);
+		if (rc)
+			goto err;
+
 		if (btt_seed == ndctl_region_get_btt_seed(region)
 				&& btt == btt_seed) {
 			fprintf(stderr, "%s: failed to advance btt seed\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
