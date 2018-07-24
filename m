Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F410210C0F6E
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 01:46:24 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 5/5] dax/super: Do not request a pointer kaddr when not
 required
Date: Tue, 24 Jul 2018 16:45:10 +0800
Message-Id: <20180724084510.6104-6-yehs2007@zoho.com>
In-Reply-To: <20180724084510.6104-1-yehs2007@zoho.com>
References: <20180724084510.6104-1-yehs2007@zoho.com>
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
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Some functions within driver/dax don't need to get pointer kaddr from
direct_access. In support of allowing memmap initialization to run in
the background elide requests for pointer kaddr when not required.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/dax/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 2b2332b..fad68d2 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -88,7 +88,6 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	struct dax_device *dax_dev;
 	pgoff_t pgoff;
 	int err, id;
-	void *kaddr;
 	pfn_t pfn;
 	long len;
 
@@ -113,7 +112,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	}
 
 	id = dax_read_lock();
-	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
+	len = dax_direct_access(dax_dev, pgoff, 1, NULL, &pfn);
 	dax_read_unlock(id);
 
 	put_dax(dax_dev);
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
