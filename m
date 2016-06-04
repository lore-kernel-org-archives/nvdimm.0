Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id F3F161A1E47
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:54:22 -0700 (PDT)
Subject: [PATCH 09/13] libnvdimm,
 pmem: use nvdimm_flush() for namespace I/O writes
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:53:20 -0700
Message-ID: <146507360028.8347.5147093673004288129.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

nsio_rw_bytes() is used to write info block metadata to the namespace,
so it should trigger a flush after every write.  Replace wmb_pmem() with
nvdimm_flush() in this path.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/claim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 9997ff94a132..d5dc80c48b4c 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -240,7 +240,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		return memcpy_from_pmem(buf, nsio->addr + offset, size);
 	} else {
 		memcpy_to_pmem(nsio->addr + offset, buf, size);
-		wmb_pmem();
+		nvdimm_flush(to_nd_region(ndns->dev.parent));
 	}
 
 	return 0;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
