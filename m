Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12A7D21AF39C0
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:18:05 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/24] md: namespace private helper names
Date: Wed, 31 May 2017 18:18:06 +0200
Message-Id: <20170531161826.23243-5-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Amir Goldstein <amir73il@gmail.com>

The md private helper uuid_equal() collides with a generic helper
of the same name.

Rename the md private helper to md_uuid_equal() and do the same for
md_sb_equal().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Shaohua Li <shli@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 10367ffe92e3..b9ab268ba7f9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -825,7 +825,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return -EINVAL;
 }
 
-static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	return	sb1->set_uuid0 == sb2->set_uuid0 &&
 		sb1->set_uuid1 == sb2->set_uuid1 &&
@@ -833,7 +833,7 @@ static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 		sb1->set_uuid3 == sb2->set_uuid3;
 }
 
-static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
@@ -1025,12 +1025,12 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
-		if (!uuid_equal(refsb, sb)) {
+		if (!md_uuid_equal(refsb, sb)) {
 			pr_warn("md: %s has different UUID to %s\n",
 				b, bdevname(refdev->bdev,b2));
 			goto abort;
 		}
-		if (!sb_equal(refsb, sb)) {
+		if (!md_sb_equal(refsb, sb)) {
 			pr_warn("md: %s has same UUID but different superblock to %s\n",
 				b, bdevname(refdev->bdev, b2));
 			goto abort;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
