Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE6F320D7B24F
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 06:54:26 -0700 (PDT)
Date: Wed, 30 May 2018 09:54:22 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Message-ID: <20180530135421.GA81788@redhat.com>
References: <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530131623.GB2106@redhat.com>
 <alpine.LRH.2.02.1805300919070.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530132647.GB5157@redhat.com>
 <alpine.LRH.2.02.1805300929500.11327@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805300929500.11327@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 30 2018 at  9:33am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 30 May 2018, Mike Snitzer wrote:
> 
> > On Wed, May 30 2018 at  9:21am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > 
> > > On Wed, 30 May 2018, Mike Snitzer wrote:
> > > 
> > > > That is really great news, can you submit an incremental patch that
> > > > layers ontop of the linux-dm.git 'dm-4.18' branch?
> > > > 
> > > > Thanks,
> > > > Mike
> > > 
> > > I've sent the current version that I have. I fixed the bugs that were 
> > > reported here (missing DAX, dm_bufio_client_create, __branch_check__ 
> > > long->int truncation).
> > 
> > OK, but a monolithic dm-writecache.c is no longer useful to me.  I can
> > drop Arnd's gcc warning fix (with the idea that Ingo or Steve will take
> > your __branch_check__ patch).  Not sure what the dm_bufio_client_create
> > fix is... must've missed a report about that.
> > 
> > ANyway, point is we're on too a different phase of dm-writecache.c's
> > development.  I've picked it up and am trying to get it ready for the
> > 4.18 merge window (likely opening Sunday).  Therefore it needs to be in
> > a git tree, and incremental changes overlayed.  I cannot be rebasing at
> > this late stage in the 4.18 development window.
> > 
> > Thanks,
> > Mike
> 
> I downloaded dm-writecache from your git repository some times ago - but 
> you changed a lot of useless things (i.e. reordering the fields in the 
> structure) since that time - so, you'll have to merge the changes.

Fine I'll deal with it.  reordering the fields eliminated holes in the
structure and reduced struct members spanning cache lines.
 
> You dropped the latency measuring code - why? We still would like to 
> benchmark the driver.

I saved that patch.  It is a development-only patch.  I tried to have
you work on formalizing the code further by making the functions
actually get called, and by wrapping the code with
CONFIG_DM_WRITECACHE_MEASURE_LATENCY.  In the end I dropped it for now
and we'll just have to apply the patch when we need to benchmark.

Here is the current patch if you'd like to improve it (e.g. actually
call measure_latency_start and measure_latency_end in places) -- I
seemed to have lost my incremental change to switch over to
CONFIG_DM_WRITECACHE_MEASURE_LATENCY (likely due to rebase); can worry
about that later.

This is based on the dm-4.18 branch.

>From 20a7c123271741cb7260154b68730942417e803a Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 22 May 2018 15:54:53 -0400
Subject: [PATCH] dm writecache: add the ability to measure some latencies

Developer-only code that won't go upstream (as-is).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
 drivers/md/dm-writecache.c | 94 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 87 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 844c4fb2fcfc..e733a14faf8f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -28,6 +28,8 @@
 #define AUTOCOMMIT_BLOCKS_PMEM		64
 #define AUTOCOMMIT_MSEC			1000
 
+//#define WC_MEASURE_LATENCY
+
 #define BITMAP_GRANULARITY	65536
 #if BITMAP_GRANULARITY < PAGE_SIZE
 #undef BITMAP_GRANULARITY
@@ -217,6 +219,15 @@ struct dm_writecache {
 	struct dm_kcopyd_client *dm_kcopyd;
 	unsigned long *dirty_bitmap;
 	unsigned dirty_bitmap_size;
+
+#ifdef WC_MEASURE_LATENCY
+	ktime_t lock_acquired_time;
+	ktime_t max_lock_held;
+	ktime_t max_lock_wait;
+	ktime_t max_freelist_wait;
+	ktime_t measure_latency_time;
+	ktime_t max_measure_latency;
+#endif
 };
 
 #define WB_LIST_INLINE		16
@@ -243,15 +254,60 @@ struct copy_struct {
 DECLARE_DM_KCOPYD_THROTTLE_WITH_MODULE_PARM(dm_writecache_throttle,
 					    "A percentage of time allocated for data copying");
 
-static void wc_lock(struct dm_writecache *wc)
+static inline void measure_latency_start(struct dm_writecache *wc)
+{
+#ifdef WC_MEASURE_LATENCY
+	wc->measure_latency_time = ktime_get();
+#endif
+}
+
+static inline void measure_latency_end(struct dm_writecache *wc, unsigned long n)
 {
+#ifdef WC_MEASURE_LATENCY
+	ktime_t now = ktime_get();
+	if (now - wc->measure_latency_time > wc->max_measure_latency) {
+		wc->max_measure_latency = now - wc->measure_latency_time;
+		printk(KERN_DEBUG "dm-writecache: measured latency %lld.%03lldus, %lu steps\n",
+		       wc->max_measure_latency / 1000, wc->max_measure_latency % 1000, n);
+	}
+#endif
+}
+
+static void __wc_lock(struct dm_writecache *wc, int line)
+{
+#ifdef WC_MEASURE_LATENCY
+	ktime_t before, after;
+	before = ktime_get();
+#endif
 	mutex_lock(&wc->lock);
+#ifdef WC_MEASURE_LATENCY
+	after = ktime_get();
+	if (unlikely(after - before > wc->max_lock_wait)) {
+		wc->max_lock_wait = after - before;
+		printk(KERN_DEBUG "dm-writecache: waiting for lock for %lld.%03lldus at %d\n",
+		       wc->max_lock_wait / 1000, wc->max_lock_wait % 1000, line);
+		after = ktime_get();
+	}
+	wc->lock_acquired_time = after;
+#endif
 }
+#define wc_lock(wc)	__wc_lock(wc, __LINE__)
 
-static void wc_unlock(struct dm_writecache *wc)
+static void __wc_unlock(struct dm_writecache *wc, int line)
 {
+#ifdef WC_MEASURE_LATENCY
+	ktime_t now = ktime_get();
+	if (now - wc->lock_acquired_time > wc->max_lock_held) {
+		wc->max_lock_held = now - wc->lock_acquired_time;
+		printk(KERN_DEBUG "dm-writecache: lock held for %lld.%03lldus at %d\n",
+		       wc->max_lock_held / 1000, wc->max_lock_held % 1000, line);
+	}
+#endif
 	mutex_unlock(&wc->lock);
 }
+#define wc_unlock(wc)	__wc_unlock(wc, __LINE__)
+
+#define wc_unlock_long(wc)	mutex_unlock(&wc->lock)
 
 #if IS_ENABLED(CONFIG_DAX_DRIVER)
 static int persistent_memory_claim(struct dm_writecache *wc)
@@ -293,6 +349,10 @@ static int persistent_memory_claim(struct dm_writecache *wc)
 		r = -EOPNOTSUPP;
 		goto err2;
 	}
+#ifdef WC_MEASURE_LATENCY
+	printk(KERN_DEBUG "dm-writecache: device %s, pfn %016llx\n",
+	       wc->ssd_dev->name, pfn.val);
+#endif
 	if (da != p) {
 		long i;
 		wc->memory_map = NULL;
@@ -701,16 +761,35 @@ static void writecache_free_entry(struct dm_writecache *wc, struct wc_entry *e)
 		swake_up(&wc->freelist_wait);
 }
 
-static void writecache_wait_on_freelist(struct dm_writecache *wc)
+static void __writecache_wait_on_freelist(struct dm_writecache *wc, bool measure, int line)
 {
 	DECLARE_SWAITQUEUE(wait);
+#ifdef WC_MEASURE_LATENCY
+	ktime_t before, after;
+#endif
 
 	prepare_to_swait(&wc->freelist_wait, &wait, TASK_UNINTERRUPTIBLE);
 	wc_unlock(wc);
+#ifdef WC_MEASURE_LATENCY
+	if (measure)
+		before = ktime_get();
+#endif
 	io_schedule();
 	finish_swait(&wc->freelist_wait, &wait);
+#ifdef WC_MEASURE_LATENCY
+	if (measure) {
+		after = ktime_get();
+		if (unlikely(after - before > wc->max_freelist_wait)) {
+			wc->max_freelist_wait = after - before;
+			printk(KERN_DEBUG "dm-writecache: waiting on freelist for %lld.%03lldus at %d\n",
+			       wc->max_freelist_wait / 1000, wc->max_freelist_wait % 1000, line);
+		}
+	}
+#endif
 	wc_lock(wc);
 }
+#define writecache_wait_on_freelist(wc)		__writecache_wait_on_freelist(wc, true, __LINE__)
+#define writecache_wait_on_freelist_long(wc)	__writecache_wait_on_freelist(wc, false, __LINE__)
 
 static void writecache_poison_lists(struct dm_writecache *wc)
 {
@@ -890,7 +969,7 @@ static void writecache_suspend(struct dm_target *ti)
 
 	writecache_poison_lists(wc);
 
-	wc_unlock(wc);
+	wc_unlock_long(wc);
 }
 
 static int writecache_alloc_entries(struct dm_writecache *wc)
@@ -1001,7 +1080,7 @@ static void writecache_resume(struct dm_target *ti)
 		writecache_commit_flushed(wc);
 	}
 
-	wc_unlock(wc);
+	wc_unlock_long(wc);
 }
 
 static int process_flush_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
@@ -1472,8 +1551,9 @@ static void __writeback_throttle(struct dm_writecache *wc, struct writeback_list
 	if (unlikely(wc->max_writeback_jobs)) {
 		if (READ_ONCE(wc->writeback_size) - wbl->size >= wc->max_writeback_jobs) {
 			wc_lock(wc);
-			while (wc->writeback_size - wbl->size >= wc->max_writeback_jobs)
-				writecache_wait_on_freelist(wc);
+			while (wc->writeback_size - wbl->size >= wc->max_writeback_jobs) {
+				writecache_wait_on_freelist_long(wc);
+			}
 			wc_unlock(wc);
 		}
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
