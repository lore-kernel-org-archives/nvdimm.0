Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F033211B5A4C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 18:32:03 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 3/5] dm-writecache: expand pmem_reinit for struct
 dm_writecache
Date: Thu, 31 Jan 2019 10:29:53 +0800
Message-Id: <20190131022955.9920-4-yehs2007@zoho.com>
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

When use persistent memory as cache data device, sometimes
the super block of pmem has messy data stored in it. That would
have risk to lead fn ctr failed to work due to invalid magic or
version.

Here we expand pmem_reinit to optional parameters in order to solve
this issue. When user gets pmem device, which has unrelated data,
as cache device, he should use paramenter 'reinit' to avoid s.magic
and s.version don't equal to NULL or correct
MEMORY_SUPERBLOCK_MAGIC/VERSION.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
---
 drivers/md/dm-writecache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index c69317c..2c1e825 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -149,6 +149,7 @@ struct dm_writecache {
 
 	bool pmem_mode:1;
 	bool writeback_fua:1;
+	bool pmem_reinit:1;
 
 	bool overwrote_committed:1;
 	bool memory_vmapped:1;
@@ -2026,6 +2027,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 				wc->writeback_fua = false;
 				wc->writeback_fua_set = true;
 			} else goto invalid_optional;
+		} else if (!strcasecmp(string, "reinit")) {
+			if (WC_MODE_PMEM(wc))
+				wc->pmem_reinit = true;
+			else goto invalid_optional;
 		} else {
 invalid_optional:
 			r = -EINVAL;
@@ -2127,7 +2132,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		ti->error = "Hardware memory error when reading superblock";
 		goto bad;
 	}
-	if (!le32_to_cpu(s.magic) && !le32_to_cpu(s.version)) {
+	if (wc->pmem_reinit || (!le32_to_cpu(s.magic) && !le32_to_cpu(s.version))) {
 		r = init_memory(wc);
 		if (r) {
 			ti->error = "Unable to initialize device";
-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
