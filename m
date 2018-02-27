Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82701223522AA
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 09:23:58 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/3] nfit_test: fix buffer overrun, add sanity check
Date: Tue, 27 Feb 2018 10:29:51 -0700
Message-Id: <20180227172952.22177-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180227172952.22177-1-ross.zwisler@linux.intel.com>
References: <20180227172952.22177-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Dave Jiang <dave.jiang@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

It turns out that we were overrunning the 'nfit_buf' buffer in
nfit_test0_setup() in the (t->setup_hotplug == 1) case because we failed to
correctly account for all of the acpi_nfit_memory_map structures.

Fix the structure count which will increase the allocation size of
'nfit_buf' in nfit_test0_alloc().  Also add some WARN_ON()s to
nfit_test0_setup() and nfit_test1_setup() to catch future issues where the
size of the buffer doesn't match the amount of data we're writing.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1376fc95c33a..fcd233342273 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -104,7 +104,8 @@ enum {
 	NUM_HINTS = 8,
 	NUM_BDW = NUM_DCR,
 	NUM_SPA = NUM_PM + NUM_DCR + NUM_BDW,
-	NUM_MEM = NUM_DCR + NUM_BDW + 2 /* spa0 iset */ + 4 /* spa1 iset */,
+	NUM_MEM = NUM_DCR + NUM_BDW + 2 /* spa0 iset */
+		+ 4 /* spa1 iset */ + 1 /* spa11 iset */,
 	DIMM_SIZE = SZ_32M,
 	LABEL_SIZE = SZ_128K,
 	SPA_VCD_SIZE = SZ_4M,
@@ -2047,6 +2048,9 @@ static void nfit_test0_setup(struct nfit_test *t)
 			flush->hint_address[i] = t->flush_dma[4]
 				+ i * sizeof(u64);
 		offset += flush->header.length;
+
+		/* sanity check to make sure we've filled the buffer */
+		WARN_ON(offset != t->nfit_size);
 	}
 
 	post_ars_status(&t->ars_state, &t->badrange, t->spa_set_dma[0],
@@ -2165,6 +2169,9 @@ static void nfit_test1_setup(struct nfit_test *t)
 	dcr->windows = 0;
 	offset += dcr->header.length;
 
+	/* sanity check to make sure we've filled the buffer */
+	WARN_ON(offset != t->nfit_size);
+
 	post_ars_status(&t->ars_state, &t->badrange, t->spa_set_dma[0],
 			SPA2_SIZE);
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
