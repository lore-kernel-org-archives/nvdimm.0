Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DAF20CCF3
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741348931; cv=none; b=NQpfz7GBnEY3qkd3qs3htFuaGkEPaKfZSRkBMYvQAq4dG/ETYpYbNmEgWGNVoTb3/KZMSVZjq/IL0KIfUdk1w8kFUowVoeHkpwMGLJAH2BYQYy1ZmbyBY1hYWqqT1Ug+3TDLQAEwK7/YRcHWgWHXYwskI5SKtZZXmv2es/Rm5l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741348931; c=relaxed/simple;
	bh=mZ+uN18yZy1WmlXNxcPBu/Apftud6kZ5z4TdAXrJKdQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFKXzFYHjPfYYWMPKZLRC7FaSYJxebtGaJYOAH7aBL3a0dFvieX4yurqy1YkN/Isqzc9Ql0VkM8nDKZDbHEenJVyOxaaiUO0Y3PJ0Nm//BpoAoW6n1MBTixHEs9IVtJ8jDwRCGgfyZVXGCaZkKNgOdUUy5cHSdc5fzYg/UurN30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eSd5hX0e; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eSd5hX0e"
X-UUID: fb541616fb4b11ef8eb9c36241bbb6fb-20250307
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=blsq4JOwbziFi2W42Dtc6ebpKzN452+fjKIqUwFyGtA=;
	b=eSd5hX0enne70uayixh/PohmAI/5rXbiyep6ABGMJo6M1WqIz70nivN+D2g5ErXaqiZa3H9N/r6oge4E7bZ7tgA5Yc69B/YFu3gW3dONiGIsOiSBMz6dy28yXVekWkZxPfgEHKeKMdbL7FWomcg07fW8X9dSArxud29R7K/LqPc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:557f7ffc-a5f6-4c31-b5d5-2a1a0ef1faf3,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:0ef645f,CLOUDID:36cad149-a527-43d8-8af6-bc8b32d9f5e9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: fb541616fb4b11ef8eb9c36241bbb6fb-20250307
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <qun-wei.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 835196444; Fri, 07 Mar 2025 20:02:02 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 7 Mar 2025 20:02:01 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Fri, 7 Mar 2025 20:02:01 +0800
From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
To: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris
 Li <chrisl@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying"
	<ying.huang@intel.com>, Kairui Song <kasong@tencent.com>, Dan Schatzberg
	<schatzberg.dan@gmail.com>, Barry Song <baohua@kernel.org>, Al Viro
	<viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	Casper Li <casper.li@mediatek.com>, Chinwen Chang
	<chinwen.chang@mediatek.com>, Andrew Yang <andrew.yang@mediatek.com>, James
 Hsu <james.hsu@mediatek.com>, Qun-Wei Lin <qun-wei.lin@mediatek.com>
Subject: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram compression
Date: Fri, 7 Mar 2025 20:01:04 +0800
Message-ID: <20250307120141.1566673-3-qun-wei.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Introduced Kcompressd to offload zram page compression, improving
system efficiency by handling compression separately from memory
reclaiming. Added necessary configurations and dependencies.

Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
---
 drivers/block/zram/Kconfig      |  11 ++
 drivers/block/zram/Makefile     |   3 +-
 drivers/block/zram/kcompressd.c | 340 ++++++++++++++++++++++++++++++++
 drivers/block/zram/kcompressd.h |  25 +++
 drivers/block/zram/zram_drv.c   |  22 ++-
 5 files changed, 397 insertions(+), 4 deletions(-)
 create mode 100644 drivers/block/zram/kcompressd.c
 create mode 100644 drivers/block/zram/kcompressd.h

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 402b7b175863..f0a1b574f770 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -145,3 +145,14 @@ config ZRAM_MULTI_COMP
 	  re-compress pages using a potentially slower but more effective
 	  compression algorithm. Note, that IDLE page recompression
 	  requires ZRAM_TRACK_ENTRY_ACTIME.
+
+config KCOMPRESSD
+	tristate "Kcompressd: Accelerated zram compression"
+	depends on ZRAM
+	help
+	  Kcompressd creates multiple daemons to accelerate the compression of pages
+	  in zram, offloading this time-consuming task from the zram driver.
+
+	  This approach improves system efficiency by handling page compression separately,
+	  which was originally done by kswapd or direct reclaim.
+
diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index 0fdefd576691..23baa5dfceb9 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -9,4 +9,5 @@ zram-$(CONFIG_ZRAM_BACKEND_ZSTD)	+= backend_zstd.o
 zram-$(CONFIG_ZRAM_BACKEND_DEFLATE)	+= backend_deflate.o
 zram-$(CONFIG_ZRAM_BACKEND_842)		+= backend_842.o
 
-obj-$(CONFIG_ZRAM)	+=	zram.o
+obj-$(CONFIG_ZRAM)		+= zram.o
+obj-$(CONFIG_KCOMPRESSD)	+= kcompressd.o
diff --git a/drivers/block/zram/kcompressd.c b/drivers/block/zram/kcompressd.c
new file mode 100644
index 000000000000..195b7e386869
--- /dev/null
+++ b/drivers/block/zram/kcompressd.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 MediaTek Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bio.h>
+#include <linux/bitops.h>
+#include <linux/freezer.h>
+#include <linux/kernel.h>
+#include <linux/psi.h>
+#include <linux/kfifo.h>
+#include <linux/swap.h>
+#include <linux/delay.h>
+
+#include "kcompressd.h"
+
+#define INIT_QUEUE_SIZE		4096
+#define DEFAULT_NR_KCOMPRESSD	4
+
+static atomic_t enable_kcompressd;
+static unsigned int nr_kcompressd;
+static unsigned int queue_size_per_kcompressd;
+static struct kcompress *kcompress;
+
+enum run_state {
+	KCOMPRESSD_NOT_STARTED = 0,
+	KCOMPRESSD_RUNNING,
+	KCOMPRESSD_SLEEPING,
+};
+
+struct kcompressd_para {
+	wait_queue_head_t *kcompressd_wait;
+	struct kfifo *write_fifo;
+	atomic_t *running;
+};
+
+static struct kcompressd_para *kcompressd_para;
+static BLOCKING_NOTIFIER_HEAD(kcompressd_notifier_list);
+
+struct write_work {
+	void *mem;
+	struct bio *bio;
+	compress_callback cb;
+};
+
+int kcompressd_enabled(void)
+{
+	return likely(atomic_read(&enable_kcompressd));
+}
+EXPORT_SYMBOL(kcompressd_enabled);
+
+static void kcompressd_try_to_sleep(struct kcompressd_para *p)
+{
+	DEFINE_WAIT(wait);
+
+	if (!kfifo_is_empty(p->write_fifo))
+		return;
+
+	if (freezing(current) || kthread_should_stop())
+		return;
+
+	atomic_set(p->running, KCOMPRESSD_SLEEPING);
+	prepare_to_wait(p->kcompressd_wait, &wait, TASK_INTERRUPTIBLE);
+
+	/*
+	 * After a short sleep, check if it was a premature sleep. If not, then
+	 * go fully to sleep until explicitly woken up.
+	 */
+	if (!kthread_should_stop() && kfifo_is_empty(p->write_fifo))
+		schedule();
+
+	finish_wait(p->kcompressd_wait, &wait);
+	atomic_set(p->running, KCOMPRESSD_RUNNING);
+}
+
+static int kcompressd(void *para)
+{
+	struct task_struct *tsk = current;
+	struct kcompressd_para *p = (struct kcompressd_para *)para;
+
+	tsk->flags |= PF_MEMALLOC | PF_KSWAPD;
+	set_freezable();
+
+	while (!kthread_should_stop()) {
+		bool ret;
+
+		kcompressd_try_to_sleep(p);
+		ret = try_to_freeze();
+		if (kthread_should_stop())
+			break;
+
+		if (ret)
+			continue;
+
+		while (!kfifo_is_empty(p->write_fifo)) {
+			struct write_work entry;
+
+			if (sizeof(struct write_work) == kfifo_out(p->write_fifo,
+						&entry, sizeof(struct write_work))) {
+				entry.cb(entry.mem, entry.bio);
+				bio_put(entry.bio);
+			}
+		}
+
+	}
+
+	tsk->flags &= ~(PF_MEMALLOC | PF_KSWAPD);
+	atomic_set(p->running, KCOMPRESSD_NOT_STARTED);
+	return 0;
+}
+
+static int init_write_queue(void)
+{
+	int i;
+	unsigned int queue_len = queue_size_per_kcompressd * sizeof(struct write_work);
+
+	for (i = 0; i < nr_kcompressd; i++) {
+		if (kfifo_alloc(&kcompress[i].write_fifo,
+					queue_len, GFP_KERNEL)) {
+			pr_err("Failed to alloc kfifo %d\n", i);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+static void clean_bio_queue(int idx)
+{
+	struct write_work entry;
+
+	while (sizeof(struct write_work) == kfifo_out(&kcompress[idx].write_fifo,
+				&entry, sizeof(struct write_work))) {
+		bio_put(entry.bio);
+		entry.cb(entry.mem, entry.bio);
+	}
+	kfifo_free(&kcompress[idx].write_fifo);
+}
+
+static int kcompress_update(void)
+{
+	int i;
+	int ret;
+
+	kcompress = kvmalloc_array(nr_kcompressd, sizeof(struct kcompress), GFP_KERNEL);
+	if (!kcompress)
+		return -ENOMEM;
+
+	kcompressd_para = kvmalloc_array(nr_kcompressd, sizeof(struct kcompressd_para), GFP_KERNEL);
+	if (!kcompressd_para)
+		return -ENOMEM;
+
+	ret = init_write_queue();
+	if (ret) {
+		pr_err("Initialization of writing to FIFOs failed!!\n");
+		return ret;
+	}
+
+	for (i = 0; i < nr_kcompressd; i++) {
+		init_waitqueue_head(&kcompress[i].kcompressd_wait);
+		kcompressd_para[i].kcompressd_wait = &kcompress[i].kcompressd_wait;
+		kcompressd_para[i].write_fifo = &kcompress[i].write_fifo;
+		kcompressd_para[i].running = &kcompress[i].running;
+	}
+
+	return 0;
+}
+
+static void stop_all_kcompressd_thread(void)
+{
+	int i;
+
+	for (i = 0; i < nr_kcompressd; i++) {
+		kthread_stop(kcompress[i].kcompressd);
+		kcompress[i].kcompressd = NULL;
+		clean_bio_queue(i);
+	}
+}
+
+static int do_nr_kcompressd_handler(const char *val,
+		const struct kernel_param *kp)
+{
+	int ret;
+
+	atomic_set(&enable_kcompressd, false);
+
+	stop_all_kcompressd_thread();
+
+	ret = param_set_int(val, kp);
+	if (!ret) {
+		pr_err("Invalid number of kcompressd.\n");
+		return -EINVAL;
+	}
+
+	ret = init_write_queue();
+	if (ret) {
+		pr_err("Initialization of writing to FIFOs failed!!\n");
+		return ret;
+	}
+
+	atomic_set(&enable_kcompressd, true);
+
+	return 0;
+}
+
+static const struct kernel_param_ops param_ops_change_nr_kcompressd = {
+	.set = &do_nr_kcompressd_handler,
+	.get = &param_get_uint,
+	.free = NULL,
+};
+
+module_param_cb(nr_kcompressd, &param_ops_change_nr_kcompressd,
+		&nr_kcompressd, 0644);
+MODULE_PARM_DESC(nr_kcompressd, "Number of pre-created daemon for page compression");
+
+static int do_queue_size_per_kcompressd_handler(const char *val,
+		const struct kernel_param *kp)
+{
+	int ret;
+
+	atomic_set(&enable_kcompressd, false);
+
+	stop_all_kcompressd_thread();
+
+	ret = param_set_int(val, kp);
+	if (!ret) {
+		pr_err("Invalid queue size for kcompressd.\n");
+		return -EINVAL;
+	}
+
+	ret = init_write_queue();
+	if (ret) {
+		pr_err("Initialization of writing to FIFOs failed!!\n");
+		return ret;
+	}
+
+	pr_info("Queue size for kcompressd was changed: %d\n", queue_size_per_kcompressd);
+
+	atomic_set(&enable_kcompressd, true);
+	return 0;
+}
+
+static const struct kernel_param_ops param_ops_change_queue_size_per_kcompressd = {
+	.set = &do_queue_size_per_kcompressd_handler,
+	.get = &param_get_uint,
+	.free = NULL,
+};
+
+module_param_cb(queue_size_per_kcompressd, &param_ops_change_queue_size_per_kcompressd,
+		&queue_size_per_kcompressd, 0644);
+MODULE_PARM_DESC(queue_size_per_kcompressd,
+		"Size of queue for kcompressd");
+
+int schedule_bio_write(void *mem, struct bio *bio, compress_callback cb)
+{
+	int i;
+	bool submit_success = false;
+	size_t sz_work = sizeof(struct write_work);
+
+	struct write_work entry = {
+		.mem = mem,
+		.bio = bio,
+		.cb = cb
+	};
+
+	if (unlikely(!atomic_read(&enable_kcompressd)))
+		return -EBUSY;
+
+	if (!nr_kcompressd || !current_is_kswapd())
+		return -EBUSY;
+
+	bio_get(bio);
+
+	for (i = 0; i < nr_kcompressd; i++) {
+		submit_success =
+			(kfifo_avail(&kcompress[i].write_fifo) >= sz_work) &&
+			(sz_work == kfifo_in(&kcompress[i].write_fifo, &entry, sz_work));
+
+		if (submit_success) {
+			switch (atomic_read(&kcompress[i].running)) {
+			case KCOMPRESSD_NOT_STARTED:
+				atomic_set(&kcompress[i].running, KCOMPRESSD_RUNNING);
+				kcompress[i].kcompressd = kthread_run(kcompressd,
+						&kcompressd_para[i], "kcompressd:%d", i);
+				if (IS_ERR(kcompress[i].kcompressd)) {
+					atomic_set(&kcompress[i].running, KCOMPRESSD_NOT_STARTED);
+					pr_warn("Failed to start kcompressd:%d\n", i);
+					clean_bio_queue(i);
+				}
+				break;
+			case KCOMPRESSD_RUNNING:
+				break;
+			case KCOMPRESSD_SLEEPING:
+				wake_up_interruptible(&kcompress[i].kcompressd_wait);
+				break;
+			}
+			return 0;
+		}
+	}
+
+	bio_put(bio);
+	return -EBUSY;
+}
+EXPORT_SYMBOL(schedule_bio_write);
+
+static int __init kcompressd_init(void)
+{
+	int ret;
+
+	nr_kcompressd = DEFAULT_NR_KCOMPRESSD;
+	queue_size_per_kcompressd = INIT_QUEUE_SIZE;
+
+	ret = kcompress_update();
+	if (ret) {
+		pr_err("Init kcompressd failed!\n");
+		return ret;
+	}
+
+	atomic_set(&enable_kcompressd, true);
+	blocking_notifier_call_chain(&kcompressd_notifier_list, 0, NULL);
+	return 0;
+}
+
+static void __exit kcompressd_exit(void)
+{
+	atomic_set(&enable_kcompressd, false);
+	stop_all_kcompressd_thread();
+
+	kvfree(kcompress);
+	kvfree(kcompressd_para);
+}
+
+module_init(kcompressd_init);
+module_exit(kcompressd_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Qun-Wei Lin <qun-wei.lin@mediatek.com>");
+MODULE_DESCRIPTION("Separate the page compression from the memory reclaiming");
+
diff --git a/drivers/block/zram/kcompressd.h b/drivers/block/zram/kcompressd.h
new file mode 100644
index 000000000000..2fe0b424a7af
--- /dev/null
+++ b/drivers/block/zram/kcompressd.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2024 MediaTek Inc.
+ */
+
+#ifndef _KCOMPRESSD_H_
+#define _KCOMPRESSD_H_
+
+#include <linux/rwsem.h>
+#include <linux/kfifo.h>
+#include <linux/atomic.h>
+
+typedef void (*compress_callback)(void *mem, struct bio *bio);
+
+struct kcompress {
+	struct task_struct *kcompressd;
+	wait_queue_head_t kcompressd_wait;
+	struct kfifo write_fifo;
+	atomic_t running;
+};
+
+int kcompressd_enabled(void);
+int schedule_bio_write(void *mem, struct bio *bio, compress_callback cb);
+#endif
+
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2e1a70f2f4bd..bcd63ecb6ff2 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -35,6 +35,7 @@
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
 
+#include "kcompressd.h"
 #include "zram_drv.h"
 
 static DEFINE_IDR(zram_index_idr);
@@ -2240,6 +2241,15 @@ static void zram_bio_write(struct zram *zram, struct bio *bio)
 	bio_endio(bio);
 }
 
+#if IS_ENABLED(CONFIG_KCOMPRESSD)
+static void zram_bio_write_callback(void *mem, struct bio *bio)
+{
+	struct zram *zram = (struct zram *)mem;
+
+	zram_bio_write(zram, bio);
+}
+#endif
+
 /*
  * Handler function for all zram I/O requests.
  */
@@ -2252,6 +2262,10 @@ static void zram_submit_bio(struct bio *bio)
 		zram_bio_read(zram, bio);
 		break;
 	case REQ_OP_WRITE:
+#if IS_ENABLED(CONFIG_KCOMPRESSD)
+		if (kcompressd_enabled() && !schedule_bio_write(zram, bio, zram_bio_write_callback))
+			break;
+#endif
 		zram_bio_write(zram, bio);
 		break;
 	case REQ_OP_DISCARD:
@@ -2535,9 +2549,11 @@ static int zram_add(void)
 #if ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE
 		.max_write_zeroes_sectors	= UINT_MAX,
 #endif
-		.features			= BLK_FEAT_STABLE_WRITES	|
-						  BLK_FEAT_READ_SYNCHRONOUS	|
-						  BLK_FEAT_WRITE_SYNCHRONOUS,
+		.features			= BLK_FEAT_STABLE_WRITES
+						  | BLK_FEAT_READ_SYNCHRONOUS
+#if !IS_ENABLED(CONFIG_KCOMPRESSD)
+						  | BLK_FEAT_WRITE_SYNCHRONOUS,
+#endif
 	};
 	struct zram *zram;
 	int ret, device_id;
-- 
2.45.2

