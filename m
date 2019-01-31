Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 470B3211B5A4C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 18:33:04 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 5/5] dm-writecache: output seq_count within status
Date: Thu, 31 Jan 2019 10:29:55 +0800
Message-Id: <20190131022955.9920-6-yehs2007@zoho.com>
In-Reply-To: <20190131022955.9920-1-yehs2007@zoho.com>
References: <20190131022955.9920-1-yehs2007@zoho.com>
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
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

seq_count is important for flush operations, output it within status
for debugging and analyzing code behavior.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 2c1e825..3396710 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2231,9 +2231,9 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%ld %llu %llu %llu", writecache_has_error(wc),
+		DMEMIT("%ld %llu %llu %llu %llu", writecache_has_error(wc),
 		       (unsigned long long)wc->n_blocks, (unsigned long long)wc->freelist_size,
-		       (unsigned long long)wc->writeback_size);
+		       (unsigned long long)wc->writeback_size, wc->seq_count);
 		break;
 	case STATUSTYPE_TABLE:
 		DMEMIT("%c %s %s %u ", WC_MODE_PMEM(wc) ? 'p' : 's',
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
