Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70DA72258AEE0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:19 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id a15so484170pgn.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:38 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 18/83] Add freelist statistics printing.
Date: Sat, 10 Mar 2018 10:17:59 -0800
Message-Id: <1520705944-6723-19-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/nova.h  |   1 +
 fs/nova/stats.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index c4abdd8..404e133 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -326,5 +326,6 @@ void nova_get_IO_stats(void);
 void nova_print_timing_stats(struct super_block *sb);
 void nova_clear_stats(struct super_block *sb);
 void nova_print_inode(struct nova_inode *pi);
+void nova_print_free_lists(struct super_block *sb);
 
 #endif /* __NOVA_H */
diff --git a/fs/nova/stats.c b/fs/nova/stats.c
index 4b7c317..9ddd267 100644
--- a/fs/nova/stats.c
+++ b/fs/nova/stats.c
@@ -128,6 +128,61 @@ DEFINE_PER_CPU(u64[TIMING_NUM], Countstats_percpu);
 u64 IOstats[STATS_NUM];
 DEFINE_PER_CPU(u64[STATS_NUM], IOstats_percpu);
 
+static void nova_print_alloc_stats(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long alloc_log_count = 0;
+	unsigned long alloc_log_pages = 0;
+	unsigned long alloc_data_count = 0;
+	unsigned long alloc_data_pages = 0;
+	unsigned long free_log_count = 0;
+	unsigned long freed_log_pages = 0;
+	unsigned long free_data_count = 0;
+	unsigned long freed_data_pages = 0;
+	int i;
+
+	nova_info("=========== NOVA allocation stats ===========\n");
+	nova_info("Alloc %llu, alloc steps %llu, average %llu\n",
+		Countstats[new_data_blocks_t], IOstats[alloc_steps],
+		Countstats[new_data_blocks_t] ?
+			IOstats[alloc_steps] / Countstats[new_data_blocks_t]
+			: 0);
+	nova_info("Free %llu\n", Countstats[free_data_t]);
+	nova_info("Fast GC %llu, check pages %llu, free pages %llu, average %llu\n",
+		Countstats[fast_gc_t], IOstats[fast_checked_pages],
+		IOstats[fast_gc_pages], Countstats[fast_gc_t] ?
+			IOstats[fast_gc_pages] / Countstats[fast_gc_t] : 0);
+	nova_info("Thorough GC %llu, checked pages %llu, free pages %llu, average %llu\n",
+		Countstats[thorough_gc_t],
+		IOstats[thorough_checked_pages], IOstats[thorough_gc_pages],
+		Countstats[thorough_gc_t] ?
+			IOstats[thorough_gc_pages] / Countstats[thorough_gc_t]
+			: 0);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+
+		alloc_log_count += free_list->alloc_log_count;
+		alloc_log_pages += free_list->alloc_log_pages;
+		alloc_data_count += free_list->alloc_data_count;
+		alloc_data_pages += free_list->alloc_data_pages;
+		free_log_count += free_list->free_log_count;
+		freed_log_pages += free_list->freed_log_pages;
+		free_data_count += free_list->free_data_count;
+		freed_data_pages += free_list->freed_data_pages;
+	}
+
+	nova_info("alloc log count %lu, allocated log pages %lu, "
+		"alloc data count %lu, allocated data pages %lu, "
+		"free log count %lu, freed log pages %lu, "
+		"free data count %lu, freed data pages %lu\n",
+		alloc_log_count, alloc_log_pages,
+		alloc_data_count, alloc_data_pages,
+		free_log_count, freed_log_pages,
+		free_data_count, freed_data_pages);
+}
+
 static void nova_print_IO_stats(struct super_block *sb)
 {
 	nova_info("=========== NOVA I/O stats ===========\n");
@@ -209,6 +264,7 @@ void nova_print_timing_stats(struct super_block *sb)
 	}
 
 	nova_info("\n");
+	nova_print_alloc_stats(sb);
 	nova_print_IO_stats(sb);
 }
 
@@ -229,6 +285,8 @@ static void nova_clear_timing_stats(void)
 
 static void nova_clear_IO_stats(struct super_block *sb)
 {
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
 	int i;
 	int cpu;
 
@@ -237,6 +295,19 @@ static void nova_clear_IO_stats(struct super_block *sb)
 		for_each_possible_cpu(cpu)
 			per_cpu(IOstats_percpu[i], cpu) = 0;
 	}
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+
+		free_list->alloc_log_count = 0;
+		free_list->alloc_log_pages = 0;
+		free_list->alloc_data_count = 0;
+		free_list->alloc_data_pages = 0;
+		free_list->free_log_count = 0;
+		free_list->freed_log_pages = 0;
+		free_list->free_data_count = 0;
+		free_list->freed_data_pages = 0;
+	}
 }
 
 void nova_clear_stats(struct super_block *sb)
@@ -261,3 +332,35 @@ void nova_print_inode(struct nova_inode *pi)
 	nova_dbg("create epoch id %llu, delete epoch id %llu\n",
 		pi->create_epoch_id, pi->delete_epoch_id);
 }
+
+void nova_print_free_lists(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int i;
+
+	nova_dbg("======== NOVA per-CPU free list allocation stats ========\n");
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		nova_dbg("Free list %d: block start %lu, block end %lu, "
+			"num_blocks %lu, num_free_blocks %lu, blocknode %lu\n",
+			i, free_list->block_start, free_list->block_end,
+			free_list->block_end - free_list->block_start + 1,
+			free_list->num_free_blocks, free_list->num_blocknode);
+
+		nova_dbg("Free list %d: alloc log count %lu, "
+			"allocated log pages %lu, alloc data count %lu, "
+			"allocated data pages %lu, free log count %lu, "
+			"freed log pages %lu, free data count %lu, "
+			"freed data pages %lu\n",
+			i,
+			free_list->alloc_log_count,
+			free_list->alloc_log_pages,
+			free_list->alloc_data_count,
+			free_list->alloc_data_pages,
+			free_list->free_log_count,
+			free_list->freed_log_pages,
+			free_list->free_data_count,
+			free_list->freed_data_pages);
+	}
+}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
