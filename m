Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2BC6209589F8
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 04:47:47 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] nvdimm: avoid bogus -Wmaybe-uninitialized warning
Date: Tue,  1 Aug 2017 13:48:48 +0200
Message-Id: <20170801114926.1171418-1-arnd@arndb.de>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

Removing the btt_rw_page/pmem_rw_page functions had a surprising
side-effect of introducing a false-positive warning in another
function, due to changed inlining decisions in gcc:

In file included from drivers/nvdimm/pmem.c:36:0:
drivers/nvdimm/pmem.c: In function 'pmem_make_request':
drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/nvdimm/pmem.c:174:16: note: 'start' was declared here
In file included from drivers/nvdimm/btt.c:27:0:
drivers/nvdimm/btt.c: In function 'btt_make_request':
drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here

The problem is that gcc fails to track the value of the 'do_acct'
variable here and has to read it back from stack, but it does
remember that 'start' may be uninitialized sometimes.

This shuts up the warning by making nd_iostat_start() always
initialize the 'start' variable. In those cases that gcc successfully
tracks the state of the variable, this will have no effect.

Fixes: 503a5e89b1de ("drivers/nvdimm/btt.c: remove btt_rw_page()")
Fixes: 58100d6e735e ("drivers/nvdimm/pmem.c: remove pmem_rw_page()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/nvdimm/nd.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e1b5715bd91f..64f79a156456 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -392,8 +392,10 @@ static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 
-	if (!blk_queue_io_stat(disk->queue))
+	if (!blk_queue_io_stat(disk->queue)) {
+		*start = 0;
 		return false;
+	}
 
 	*start = jiffies;
 	generic_start_io_acct(bio_data_dir(bio),
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
