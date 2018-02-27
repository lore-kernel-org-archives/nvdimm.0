Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7CC420955F21
 for <linux-nvdimm@lists.01.org>; Tue, 27 Feb 2018 09:23:58 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] nfit_test: prevent parsing error of nfit_test.0
Date: Tue, 27 Feb 2018 10:29:52 -0700
Message-Id: <20180227172952.22177-3-ross.zwisler@linux.intel.com>
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

When you load nfit_test you currently see the following error in dmesg:

 nfit_test nfit_test.0: found a zero length table '0' parsing nfit

This happens because when we parse the nfit_test.0 table via
acpi_nfit_init(), we specify a size of nfit_test->nfit_size.  For the first
pass through nfit_test.0 where (t->setup_hotplug == 0) this is the size of
the entire buffer we allocated, including space for the hot plug
structures, not the size that we've actually filled in.

Fix this by only trying to parse the size of the structures that we've
filled in.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index fcd233342273..d785235ba04e 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -154,6 +154,7 @@ struct nfit_test {
 	void *nfit_buf;
 	dma_addr_t nfit_dma;
 	size_t nfit_size;
+	size_t nfit_filled;
 	int dcr_idx;
 	int num_dcr;
 	int num_pm;
@@ -2053,6 +2054,8 @@ static void nfit_test0_setup(struct nfit_test *t)
 		WARN_ON(offset != t->nfit_size);
 	}
 
+	t->nfit_filled = offset;
+
 	post_ars_status(&t->ars_state, &t->badrange, t->spa_set_dma[0],
 			SPA0_SIZE);
 
@@ -2172,6 +2175,8 @@ static void nfit_test1_setup(struct nfit_test *t)
 	/* sanity check to make sure we've filled the buffer */
 	WARN_ON(offset != t->nfit_size);
 
+	t->nfit_filled = offset;
+
 	post_ars_status(&t->ars_state, &t->badrange, t->spa_set_dma[0],
 			SPA2_SIZE);
 
@@ -2529,7 +2534,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	nd_desc->ndctl = nfit_test_ctl;
 
 	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_buf,
-			nfit_test->nfit_size);
+			nfit_test->nfit_filled);
 	if (rc)
 		return rc;
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
