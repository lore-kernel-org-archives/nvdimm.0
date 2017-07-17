Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 221A121CB0304
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 16:56:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 4/6] btt: cache sector_size in arena_info
Date: Mon, 17 Jul 2017 17:56:53 -0600
Message-Id: <20170717235655.26424-5-vishal.l.verma@intel.com>
In-Reply-To: <20170717235655.26424-1-vishal.l.verma@intel.com>
References: <20170717235655.26424-1-vishal.l.verma@intel.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the error clearing rework, add sector_size in the
arena_info struct.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 1 +
 drivers/nvdimm/btt.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 304dac4..6b84eae 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -566,6 +566,7 @@ static struct arena_info *alloc_arena(struct btt *btt, size_t size,
 	if (!arena)
 		return NULL;
 	arena->nd_btt = btt->nd_btt;
+	arena->sector_size = btt->sector_size;
 
 	if (!size)
 		return arena;
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 09fabf5..2bc0d10b 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -108,6 +108,7 @@ struct aligned_lock {
  *			handle incoming writes.
  * @version_major:	Metadata layout version major.
  * @version_minor:	Metadata layout version minor.
+ * @sector_size:	The Linux sector size - 512 or 4096
  * @nextoff:		Offset in bytes to the start of the next arena.
  * @infooff:		Offset in bytes to the info block of this arena.
  * @dataoff:		Offset in bytes to the data area of this arena.
@@ -135,6 +136,7 @@ struct arena_info {
 	u32 nfree;
 	u16 version_major;
 	u16 version_minor;
+	u32 sector_size;
 	/* Byte offsets to the different on-media structures */
 	u64 nextoff;
 	u64 infooff;
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
