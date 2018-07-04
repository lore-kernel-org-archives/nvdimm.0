Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBDF82098C8D1
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 23:42:09 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 3/3] fs/dax: Assigning NULL to gfn of dax_direct_access if
 useless
Date: Wed,  4 Jul 2018 14:40:58 +0800
Message-Id: <20180704064058.1344-3-yehs2007@zoho.com>
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

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 fs/dax.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index aaec72de..aa75dfd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -550,7 +550,6 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 {
 	void *vto, *kaddr;
 	pgoff_t pgoff;
-	pfn_t pfn;
 	long rc;
 	int id;
 
@@ -559,7 +558,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		return rc;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, NULL);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -961,7 +960,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 		pgoff_t pgoff;
 		long rc, id;
 		void *kaddr;
-		pfn_t pfn;
 
 		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
 		if (rc)
@@ -969,7 +967,7 @@ int __dax_zero_page_range(struct block_device *bdev,
 
 		id = dax_read_lock();
 		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr,
-				&pfn);
+				NULL);
 		if (rc < 0) {
 			dax_read_unlock(id);
 			return rc;
@@ -1024,7 +1022,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 		ssize_t map_len;
 		pgoff_t pgoff;
 		void *kaddr;
-		pfn_t pfn;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -1036,7 +1033,7 @@ int __dax_zero_page_range(struct block_device *bdev,
 			break;
 
 		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
-				&kaddr, &pfn);
+				&kaddr, NULL);
 		if (map_len < 0) {
 			ret = map_len;
 			break;
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
