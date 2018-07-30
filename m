Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CEB09210C515B
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 00:17:05 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 5/6] md/dm-writecache: Don't request pointer dummy_addr
 when not required
Date: Mon, 30 Jul 2018 15:15:47 +0800
Message-Id: <20180730071548.9172-6-yehs2007@zoho.com>
In-Reply-To: <20180730071548.9172-1-yehs2007@zoho.com>
References: <20180730071548.9172-1-yehs2007@zoho.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: jack@suse.cz, snitzer@redhat.com, heiko.carstens@de.ibm.com, dm-devel@redhat.com, agk@redhat.com, linux-s390@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, keescook@chromium.org, chengnt@lenovo.com, colyli@suse.de, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Function persistent_memory_claim doesn't need to get local pointer
dummy_addr from direct_access. Using NULL instead of having to pass
in a useless local pointer that caller then just throw away.

Suggested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-writecache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 87107c9..9d79084 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -268,9 +268,8 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 		i = 0;
 		do {
 			long daa;
-			void *dummy_addr;
 			daa = dax_direct_access(wc->ssd_dev->dax_dev, i, p - i,
-						&dummy_addr, &pfn);
+						NULL, &pfn);
 			if (daa <= 0) {
 				r = daa ? daa : -EINVAL;
 				goto err3;
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
