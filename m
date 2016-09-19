Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC41E1A1E3D
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 14:41:05 -0700 (PDT)
Subject: [ndctl PATCH 4/6] test,
 libndctl: fix uninitialized variable usage in check_btt_size()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 14:38:02 -0700
Message-ID: <147432107740.39548.1060602141777439986.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147432105652.39548.8883834720654751375.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If the namespace size is not one we expect, fail the test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index e36fe8a4fe6f..a0bf74a9c333 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -984,7 +984,7 @@ static int check_btt_size(struct ndctl_btt *btt)
 		fprintf(stderr, "%s: %s unexpected namespace size: %llx\n",
 				__func__, ndctl_namespace_get_devname(ndns),
 				ns_size);
-		break;
+		return -ENXIO;
 	}
 
 	expect = expect_table[size_select][sect_select];

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
