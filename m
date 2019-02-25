Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D722211CED96
 for <linux-nvdimm@lists.01.org>; Mon, 25 Feb 2019 13:49:57 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nvdimm, btt: fix LBA masking during 'free list' population
Date: Mon, 25 Feb 2019 14:49:31 -0700
Message-Id: <20190225214931.27928-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

The Linux BTT implementation assumes that log entries will never have
the 'zero' flag set, and indeed it never sets that flag for log entries
itself.

However, the UEFI spec is ambiguous on the exact format of the LBA field
of a log entry, specifically as to whether it should include the
additional flag bits or not. While a zero bit doesn't make sense in the
context of a log entry, other BTT implementations might still have it set.

If an implementation does happen to have it set, we would happily read
it in as the next block to write to for writes. Since a high bit is set,
it pushes the block number out of the range of an 'arena', and we fail
such a write with an EIO.

Follow the robustness principle, and tolerate such implementations by
stripping out the zero flag when populating the free list during
initialization.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dexuan Cui <decui@microsoft.com>
Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/btt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index b123b0dcf274..1c5447ac1e39 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -562,13 +562,15 @@ static int btt_freelist_init(struct arena_info *arena)
 		/* sub points to the next one to be overwritten */
 		arena->freelist[i].sub = 1 - new;
 		arena->freelist[i].seq = nd_inc_seq(le32_to_cpu(log_new.seq));
-		arena->freelist[i].block = le32_to_cpu(log_new.old_map);
+		arena->freelist[i].block =
+				le32_to_cpu(ent_lba(log_new.old_map));
 
 		/*
 		 * FIXME: if error clearing fails during init, we want to make
 		 * the BTT read-only
 		 */
 		if (ent_e_flag(log_new.old_map)) {
+			set_e_flag(arena->freelist[i].block);
 			ret = arena_clear_freelist_error(arena, i);
 			if (ret)
 				dev_err_ratelimited(to_dev(arena),
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
