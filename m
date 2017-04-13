Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17DF52194EB6F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:06:52 -0700 (PDT)
From: Logan Gunthorpe <logang@deltatee.com>
Date: Thu, 13 Apr 2017 16:05:33 -0600
Message-Id: <1492121135-4437-21-git-send-email-logang@deltatee.com>
In-Reply-To: <1492121135-4437-1-git-send-email-logang@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
Subject: [PATCH 20/22] mmc: sdricoh_cs: Make use of the new sg_map helper
 function
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
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: Steve Wise <swise@opengridcomputing.com>
List-ID: <linux-nvdimm@lists.01.org>

This is a straightforward conversion to the new function.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/mmc/host/sdricoh_cs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 5ff26ab..7eeed23 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -319,16 +319,20 @@ static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		for (i = 0; i < data->blocks; i++) {
 			size_t len = data->blksz;
 			u8 *buf;
-			struct page *page;
 			int result;
-			page = sg_page(data->sg);
 
-			buf = kmap(page) + data->sg->offset + (len * i);
+			buf = sg_map_offset(data->sg, (len * i), SG_KMAP);
+			if (IS_ERR(buf)) {
+				cmd->error = PTR_ERR(buf);
+				break;
+			}
+
 			result =
 				sdricoh_blockio(host,
 					data->flags & MMC_DATA_READ, buf, len);
-			kunmap(page);
-			flush_dcache_page(page);
+			sg_unmap_offset(data->sg, buf, (len * i), SG_KMAP);
+
+			flush_dcache_page(sg_page(data->sg));
 			if (result) {
 				dev_err(dev, "sdricoh_request: cmd %i "
 					"block transfer failed\n", cmd->opcode);
-- 
2.1.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
