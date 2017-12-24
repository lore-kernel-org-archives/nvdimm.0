Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17A7E22225C09
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 17:00:49 -0800 (PST)
Subject: [PATCH v4 16/18] wait_bit: introduce {wait_on,wake_up}_atomic_one
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:57:26 -0800
Message-ID: <151407704609.38751.16443220639298609451.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Add a generic facility for awaiting an atomic_t to reach a value of one.

Page reference counts typically need to reach zero to be considered a
free / inactive page. However, ZONE_DEVICE pages allocated via
devm_memremap_pages() are never 'onlined', i.e. the put_page() typically
done at init time to assign pages to the page allocator is skipped.

These pages will have their reference count elevated > 1 by
get_user_pages() when they are under DMA. In order to coordinate DMA to
these pages vs filesytem operations like hole-punch and truncate the
filesystem-dax implementation needs to capture the DMA-idle event (1 to
0 count transition).

For now, this implementation does not have functional behavior change,
follow-on patches will add waiters for these page-idle events.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c      |    2 +-
 include/linux/wait_bit.h |   13 ++++++++++
 kernel/sched/wait_bit.c  |   59 +++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0352a098b099..85a56f849b0c 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -167,7 +167,7 @@ struct dax_device {
 #if IS_ENABLED(CONFIG_FS_DAX)
 static void generic_dax_pagefree(struct page *page, void *data)
 {
-	/* TODO: wakeup page-idle waiters */
+	wake_up_atomic_one(&page->_refcount);
 }
 
 struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 61b39eaf7cad..564c9a0141cd 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -33,10 +33,15 @@ int __wait_on_bit(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *
 int __wait_on_bit_lock(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_entry, wait_bit_action_f *action, unsigned int mode);
 void wake_up_bit(void *word, int bit);
 void wake_up_atomic_t(atomic_t *p);
+static inline void wake_up_atomic_one(atomic_t *p)
+{
+	wake_up_atomic_t(p);
+}
 int out_of_line_wait_on_bit(void *word, int, wait_bit_action_f *action, unsigned int mode);
 int out_of_line_wait_on_bit_timeout(void *word, int, wait_bit_action_f *action, unsigned int mode, unsigned long timeout);
 int out_of_line_wait_on_bit_lock(void *word, int, wait_bit_action_f *action, unsigned int mode);
 int out_of_line_wait_on_atomic_t(atomic_t *p, wait_atomic_t_action_f action, unsigned int mode);
+int out_of_line_wait_on_atomic_one(atomic_t *p, wait_atomic_t_action_f action, unsigned int mode);
 struct wait_queue_head *bit_waitqueue(void *word, int bit);
 extern void __init wait_bit_init(void);
 
@@ -262,4 +267,12 @@ int wait_on_atomic_t(atomic_t *val, wait_atomic_t_action_f action, unsigned mode
 	return out_of_line_wait_on_atomic_t(val, action, mode);
 }
 
+static inline
+int wait_on_atomic_one(atomic_t *val, wait_atomic_t_action_f action, unsigned mode)
+{
+	might_sleep();
+	if (atomic_read(val) == 1)
+		return 0;
+	return out_of_line_wait_on_atomic_one(val, action, mode);
+}
 #endif /* _LINUX_WAIT_BIT_H */
diff --git a/kernel/sched/wait_bit.c b/kernel/sched/wait_bit.c
index 84cb3acd9260..8739b1e50df5 100644
--- a/kernel/sched/wait_bit.c
+++ b/kernel/sched/wait_bit.c
@@ -162,28 +162,47 @@ static inline wait_queue_head_t *atomic_t_waitqueue(atomic_t *p)
 	return bit_waitqueue(p, 0);
 }
 
-static int wake_atomic_t_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync,
-				  void *arg)
+static struct wait_bit_queue_entry *to_wait_bit_q(
+		struct wait_queue_entry *wq_entry)
+{
+	return container_of(wq_entry, struct wait_bit_queue_entry, wq_entry);
+}
+
+static int __wake_atomic_t_function(struct wait_queue_entry *wq_entry,
+		unsigned mode, int sync, void *arg, int target)
 {
 	struct wait_bit_key *key = arg;
-	struct wait_bit_queue_entry *wait_bit = container_of(wq_entry, struct wait_bit_queue_entry, wq_entry);
+	struct wait_bit_queue_entry *wait_bit = to_wait_bit_q(wq_entry);
 	atomic_t *val = key->flags;
 
 	if (wait_bit->key.flags != key->flags ||
 	    wait_bit->key.bit_nr != key->bit_nr ||
-	    atomic_read(val) != 0)
+	    atomic_read(val) != target)
 		return 0;
 	return autoremove_wake_function(wq_entry, mode, sync, key);
 }
 
+static int wake_atomic_t_function(struct wait_queue_entry *wq_entry,
+		unsigned mode, int sync, void *arg)
+{
+	return __wake_atomic_t_function(wq_entry, mode, sync, arg, 0);
+}
+
+static int wake_atomic_one_function(struct wait_queue_entry *wq_entry,
+		unsigned mode, int sync, void *arg)
+{
+	return __wake_atomic_t_function(wq_entry, mode, sync, arg, 1);
+}
+
 /*
  * To allow interruptible waiting and asynchronous (i.e. nonblocking) waiting,
  * the actions of __wait_on_atomic_t() are permitted return codes.  Nonzero
  * return codes halt waiting and return.
  */
 static __sched
-int __wait_on_atomic_t(struct wait_queue_head *wq_head, struct wait_bit_queue_entry *wbq_entry,
-		       wait_atomic_t_action_f action, unsigned int mode)
+int __wait_on_atomic_t(struct wait_queue_head *wq_head,
+		struct wait_bit_queue_entry *wbq_entry,
+		wait_atomic_t_action_f action, unsigned int mode, int target)
 {
 	atomic_t *val;
 	int ret = 0;
@@ -191,10 +210,10 @@ int __wait_on_atomic_t(struct wait_queue_head *wq_head, struct wait_bit_queue_en
 	do {
 		prepare_to_wait(wq_head, &wbq_entry->wq_entry, mode);
 		val = wbq_entry->key.flags;
-		if (atomic_read(val) == 0)
+		if (atomic_read(val) == target)
 			break;
 		ret = (*action)(val, mode);
-	} while (!ret && atomic_read(val) != 0);
+	} while (!ret && atomic_read(val) != target);
 	finish_wait(wq_head, &wbq_entry->wq_entry);
 	return ret;
 }
@@ -210,6 +229,17 @@ int __wait_on_atomic_t(struct wait_queue_head *wq_head, struct wait_bit_queue_en
 		},							\
 	}
 
+#define DEFINE_WAIT_ATOMIC_ONE(name, p)					\
+	struct wait_bit_queue_entry name = {				\
+		.key = __WAIT_ATOMIC_T_KEY_INITIALIZER(p),		\
+		.wq_entry = {						\
+			.private	= current,			\
+			.func		= wake_atomic_one_function,	\
+			.entry		=				\
+				LIST_HEAD_INIT((name).wq_entry.entry),	\
+		},							\
+	}
+
 __sched int out_of_line_wait_on_atomic_t(atomic_t *p,
 					 wait_atomic_t_action_f action,
 					 unsigned int mode)
@@ -217,7 +247,7 @@ __sched int out_of_line_wait_on_atomic_t(atomic_t *p,
 	struct wait_queue_head *wq_head = atomic_t_waitqueue(p);
 	DEFINE_WAIT_ATOMIC_T(wq_entry, p);
 
-	return __wait_on_atomic_t(wq_head, &wq_entry, action, mode);
+	return __wait_on_atomic_t(wq_head, &wq_entry, action, mode, 0);
 }
 EXPORT_SYMBOL(out_of_line_wait_on_atomic_t);
 
@@ -230,6 +260,17 @@ __sched int atomic_t_wait(atomic_t *counter, unsigned int mode)
 }
 EXPORT_SYMBOL(atomic_t_wait);
 
+__sched int out_of_line_wait_on_atomic_one(atomic_t *p,
+					   wait_atomic_t_action_f action,
+					   unsigned int mode)
+{
+	struct wait_queue_head *wq_head = atomic_t_waitqueue(p);
+	DEFINE_WAIT_ATOMIC_ONE(wq_entry, p);
+
+	return __wait_on_atomic_t(wq_head, &wq_entry, action, mode, 1);
+}
+EXPORT_SYMBOL(out_of_line_wait_on_atomic_one);
+
 /**
  * wake_up_atomic_t - Wake up a waiter on a atomic_t
  * @p: The atomic_t being waited on, a kernel virtual address

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
