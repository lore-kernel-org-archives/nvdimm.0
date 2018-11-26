Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00DE921A07A92
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 04:22:25 -0800 (PST)
Date: Mon, 26 Nov 2018 04:22:23 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: FAILED: patch "[PATCH] dax: Avoid losing wakeup in
 dax_lock_mapping_entry" failed to apply to 4.19-stable tree
Message-ID: <20181126122223.GG3065@bombadil.infradead.org>
References: <154322882028207@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154322882028207@kroah.com>
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
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 26, 2018 at 11:40:20AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

The fix for 4.19 is rather more complex because we don't have the right information in the right places.  Dan, does this look right to you?


diff --git a/fs/dax.c b/fs/dax.c
index 0fb270f0a0ef6..b8dd66f1951a6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -227,7 +227,9 @@ static inline void *unlock_slot(struct address_space *mapping, void **slot)
  * Must be called with the i_pages lock held.
  */
 static void *__get_unlocked_mapping_entry(struct address_space *mapping,
-		pgoff_t index, void ***slotp, bool (*wait_fn)(void))
+			pgoff_t index, void ***slotp,
+			bool (*wait_fn)(struct address_space *mapping,
+					pgoff_t index, void *entry))
 {
 	void *entry, **slot;
 	struct wait_exceptional_entry_queue ewait;
@@ -253,7 +255,7 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
 		xa_unlock_irq(&mapping->i_pages);
-		revalidate = wait_fn();
+		revalidate = wait_fn(mapping, index, entry);
 		finish_wait(wq, &ewait.wait);
 		xa_lock_irq(&mapping->i_pages);
 		if (revalidate)
@@ -261,7 +263,8 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 	}
 }
 
-static bool entry_wait(void)
+static bool entry_wait(struct address_space *mapping, unsigned long index,
+			void *entry)
 {
 	schedule();
 	/*
@@ -393,12 +396,18 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
-static bool entry_wait_revalidate(void)
+static bool entry_wait_revalidate(struct address_space *mapping,
+					unsigned long index, void *entry)
 {
 	rcu_read_unlock();
 	schedule();
 	rcu_read_lock();
 
+	/*
+	 * We're not going to do anything with this entry; wake the next
+	 * task in line
+	 */
+	put_unlocked_mapping_entry(mapping, index, entry);
 	/*
 	 * Tell __get_unlocked_mapping_entry() to take a break, we need
 	 * to revalidate page->mapping after dropping locks

> ------------------ original commit in Linus's tree ------------------
> 
> >From 25bbe21bf427a81b8e3ccd480ea0e1d940256156 Mon Sep 17 00:00:00 2001
> From: Matthew Wilcox <willy@infradead.org>
> Date: Fri, 16 Nov 2018 15:50:02 -0500
> Subject: [PATCH] dax: Avoid losing wakeup in dax_lock_mapping_entry
> 
> After calling get_unlocked_entry(), you have to call
> put_unlocked_entry() to avoid subsequent waiters losing wakeups.
> 
> Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index cf2394e2bf4b..9bcce89ea18e 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -391,6 +391,7 @@ bool dax_lock_mapping_entry(struct page *page)
>  			rcu_read_unlock();
>  			entry = get_unlocked_entry(&xas);
>  			xas_unlock_irq(&xas);
> +			put_unlocked_entry(&xas, entry);
>  			rcu_read_lock();
>  			continue;
>  		}
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
