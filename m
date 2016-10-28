Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3658781DFB
 for <linux-nvdimm@lists.01.org>; Fri, 28 Oct 2016 14:49:09 -0700 (PDT)
Subject: [PATCH] device-dax: check devm_nsio_enable() return value
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Oct 2016 14:46:07 -0700
Message-ID: <147769116781.491.4900126924070257885.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If the dax_pmem driver is passed a resource that is already busy the
driver probe attempt should fail with a message like the following:

  dax_pmem dax0.1: could not reserve region [mem 0x100000000-0x11fffffff]

However, if we do not catch the error we crash for the obvious reason of
accessing memory that is not mapped.

 BUG: unable to handle kernel paging request at ffffc90020001000
 IP: [<ffffffff81496712>] __memcpy+0x12/0x20
 [..]
 Call Trace:
  [<ffffffff815c4960>] ? nsio_rw_bytes+0x60/0x180
  [<ffffffff815c6045>] nd_pfn_validate+0x75/0x320
  [<ffffffff815c63a9>] nvdimm_setup_pfn+0xb9/0x5d0
  [<ffffffff815c48ef>] ? devm_nsio_enable+0xff/0x110
  [<ffffffff815cb699>] dax_pmem_probe+0x59/0x260

Cc: <stable@vger.kernel.org>
Fixes: ab68f2622136 ("/dev/dax, pmem: direct access to persistent memory")
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 4a15fa5df98b..73c6ce93a0d9 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -78,7 +78,9 @@ static int dax_pmem_probe(struct device *dev)
 	nsio = to_nd_namespace_io(&ndns->dev);
 
 	/* parse the 'pfn' info block via ->rw_bytes */
-	devm_nsio_enable(dev, nsio);
+	rc = devm_nsio_enable(dev, nsio);
+	if (rc)
+		return rc;
 	altmap = nvdimm_setup_pfn(nd_pfn, &res, &__altmap);
 	if (IS_ERR(altmap))
 		return PTR_ERR(altmap);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
