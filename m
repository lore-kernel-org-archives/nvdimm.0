Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B41CC210C1EF6
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 23:41:59 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 2/3] drivers/s390/block/dcssblk: check the validity of the
 pointer pfn
Date: Wed,  4 Jul 2018 14:40:57 +0800
Message-Id: <20180704064058.1344-2-yehs2007@zoho.com>
In-Reply-To: <20180704064058.1344-1-yehs2007@zoho.com>
References: <20180704064058.1344-1-yehs2007@zoho.com>
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
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, mawilcox@microsoft.com, chengnt@lenovo.com, jack@suse.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Some functions within fs/dax don't need to get gfn from direct_access.
Assigning NULL to gfn of dax_direct_access is more intuitive and simple
than offering a useless local variable.

So direct_access needs to check validity of the pointer pfn For NULL
assignment. If pfn equals to NULL, it doesn't need to calculate its
value.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/s390/block/dcssblk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 0a312e4..5cdfa02 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -916,7 +916,8 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
 
 	dev_sz = dev_info->end - dev_info->start + 1;
 	*kaddr = (void *) dev_info->start + offset;
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
+	if (pfn)
+		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
 			PFN_DEV|PFN_SPECIAL);
 
 	return (dev_sz - offset) / PAGE_SIZE;
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
