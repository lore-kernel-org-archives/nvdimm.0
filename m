Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40135210C1EEC
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 09:30:30 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 6/6] filesystem-dax: Do not request kaddr and pfn when not
 required
Date: Thu, 26 Jul 2018 00:28:49 +0800
Message-Id: <20180725162849.8320-7-yehs2007@zoho.com>
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

Some functions within fs/dax don't need to get local pointer kaddr
or variable pfn from direct_access. Using NULL instead of having to
pass in useless pointer or variable that caller then just throw away.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 fs/dax.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6411928..959a533 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -647,7 +647,6 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 {
 	void *vto, *kaddr;
 	pgoff_t pgoff;
-	pfn_t pfn;
 	long rc;
 	int id;
 
@@ -656,7 +655,7 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		return rc;
 
 	id = dax_read_lock();
-	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
+	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, NULL);
 	if (rc < 0) {
 		dax_read_unlock(id);
 		return rc;
@@ -967,7 +966,6 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
-	void *kaddr;
 	int id, rc;
 	long length;
 
@@ -976,7 +974,7 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   &kaddr, pfnp);
+				   NULL, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
@@ -1052,15 +1050,13 @@ int __dax_zero_page_range(struct block_device *bdev,
 		pgoff_t pgoff;
 		long rc, id;
 		void *kaddr;
-		pfn_t pfn;
 
 		rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
 		if (rc)
 			return rc;
 
 		id = dax_read_lock();
-		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr,
-				&pfn);
+		rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
 		if (rc < 0) {
 			dax_read_unlock(id);
 			return rc;
@@ -1116,7 +1112,6 @@ int __dax_zero_page_range(struct block_device *bdev,
 		ssize_t map_len;
 		pgoff_t pgoff;
 		void *kaddr;
-		pfn_t pfn;
 
 		if (fatal_signal_pending(current)) {
 			ret = -EINTR;
@@ -1128,7 +1123,7 @@ int __dax_zero_page_range(struct block_device *bdev,
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
