Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56A1C2097FABE
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 09:29:50 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 2/6] s390,
 dcssblk: kaddr and pfn can be NULL to ->direct_access()
Date: Thu, 26 Jul 2018 00:28:45 +0800
Message-Id: <20180725162849.8320-3-yehs2007@zoho.com>
In-Reply-To: <20180725162849.8320-1-yehs2007@zoho.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
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
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, snitzer@redhat.com, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, colyli@suse.de, bart.vanassche@wdc.com, dm-devel@redhat.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

dcssblk_direct_access() needs to check the validity of pointers kaddr
and pfn for NULL assignment. If anyone equals to NULL, it doesn't need
to calculate the value.

If either of them is equal to NULL, that is to say callers may
have no need for kaddr or pfn, so this patch is prepared for allowing
them to pass in NULL instead of having to pass in a pointer or local
variable that they then just throw away.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/s390/block/dcssblk.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index ed60728..23e526c 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -922,9 +922,11 @@ static DEVICE_ATTR(save, S_IWUSR | S_IRUSR, dcssblk_save_show,
 	unsigned long dev_sz;
 
 	dev_sz = dev_info->end - dev_info->start + 1;
-	*kaddr = (void *) dev_info->start + offset;
-	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
-			PFN_DEV|PFN_SPECIAL);
+	if (kaddr)
+		*kaddr = (void *) dev_info->start + offset;
+	if (pfn)
+		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset),
+				PFN_DEV|PFN_SPECIAL);
 
 	return (dev_sz - offset) / PAGE_SIZE;
 }
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
