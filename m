Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35A8720945BD0
 for <linux-nvdimm@lists.01.org>; Wed, 27 Sep 2017 16:29:00 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 create-namespace: fix --align= default for nfit_test
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Sep 2017 16:25:50 -0700
Message-ID: <150655475033.40865.7840035470610962973.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Vishal reports:

    (after ndctl create-namepsace -t pmem --bus=nfit_test.0) I'm seeing that
    it is created as a memory mode namespace, but after cycling it, it comes
    up as raw and dmesg has:

        pfn7.0: bad offset: 0x2af000 dax disabled align: 0x200000

This arises from the hacks that nfit_test uses to emulate pmem with
vmalloc(). Setting the alignment to 4K avoids these problems.

For casual testing try to detect the nfit_test case and adjust the
default alignment accordingly.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 README.md         |    5 +++++
 ndctl/namespace.c |   13 +++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/README.md b/README.md
index 14ff0ccb1f51..1698e52b817d 100644
--- a/README.md
+++ b/README.md
@@ -88,3 +88,8 @@ to /etc/depmod.d with the following contents:
 `override nd_btt * extra`  
 `override nd_e820 * extra`  
 `override nd_pmem * extra`  
+
+The nfit_test module emulates pmem with memory allocated via vmalloc().
+One of the side effects is that this breaks 'physically contiguous'
+assumptions in the driver. Use the '--align=4K option to 'ndctl
+create-namespace' to avoid these corner case scenarios.
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index d26ed1289c33..077d5968d0e8 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -563,6 +563,19 @@ static int validate_namespace_options(struct ndctl_region *region,
 			return -ENXIO;
 		}
 
+		/*
+		 * Fallback to a 4K default alignment if the region is
+		 * not 2MB (typical default) aligned. This mainly helps
+		 * the nfit_test use case where it is backed by vmalloc
+		 * memory.
+		 */
+		if (param.align_default && (ndctl_region_get_resource(region)
+					& (SZ_2M - 1))) {
+			debug("%s: falling back to a 4K alignment\n",
+					region_name);
+			p->align = SZ_4K;
+		}
+
 		switch (p->align) {
 		case SZ_4K:
 		case SZ_2M:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
