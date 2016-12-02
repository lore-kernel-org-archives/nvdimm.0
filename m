Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BF5A81F5F
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:20:17 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/8 linux-next] libnvdimm,
 namespace: add verbosity to persistence warning
Date: Fri,  2 Dec 2016 20:20:13 +0100
Message-Id: <1480706413-21004-1-git-send-email-fabf@skynet.be>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 2461843..822a712 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -267,7 +267,7 @@ static int pmem_attach_disk(struct device *dev,
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
 	if (nvdimm_has_flush(nd_region) < 0)
-		dev_warn(dev, "unable to guarantee persistence of writes\n");
+		dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(dev))) {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
