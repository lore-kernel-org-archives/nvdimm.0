Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 204D621B02822
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 22:01:21 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: fsdax memory error handling regression
Date: Wed, 7 Nov 2018 06:01:19 +0000
Message-ID: <35429d15f7dfd2c551b9d61512abe2e04376d2a0.camel@intel.com>
References: <118cae852d1dbcc582261ae364e75a7bdf3d43ed.camel@intel.com>
 <20181106144848.GE3074@bombadil.infradead.org>
In-Reply-To: <20181106144848.GE3074@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <1F4D16DF3C440746B88C3B64282D304E@intel.com>
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
To: "willy@infradead.org" <willy@infradead.org>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-11-06 at 06:48 -0800, Matthew Wilcox wrote:
> On Tue, Nov 06, 2018 at 03:44:47AM +0000, Williams, Dan J wrote:
> > Hi Willy,
> > 
> > I'm seeing the following warning with v4.20-rc1 and the "dax.sh"
> > test
> > from the ndctl repository:
> 
> I'll try to run this myself later today.
> 
> > I tried to get this test going on -next before the merge window,
> > but
> > -next was not bootable for me. Bisection points to:
> > 
> >     9f32d221301c dax: Convert dax_lock_mapping_entry to XArray
> > 
> > At first glance I think we need the old "always retry if we slept"
> > behavior. Otherwise this failure seems similar to the issue fixed
> > by
> > Ross' change to always retry on any potential collision:
> > 
> >     b1f382178d15 ext4: close race between direct IO and
> > ext4_break_layouts()
> > 
> > I'll take a closer look tomorrow to see if that guess is plausible.
> 
> If your thought is correct, then this should be all that's needed:
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 616e36ea6aaa..529ac9d7c10a 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -383,11 +383,8 @@ bool dax_lock_mapping_entry(struct page *page)
>  		entry = xas_load(&xas);
>  		if (dax_is_locked(entry)) {
>  			entry = get_unlocked_entry(&xas);
> -			/* Did the page move while we slept? */
> -			if (dax_to_pfn(entry) != page_to_pfn(page)) {
> -				xas_unlock_irq(&xas);
> -				continue;
> -			}
> +			xas_unlock_irq(&xas);
> +			continue;
>  		}
>  		dax_lock_entry(&xas, entry);
>  		xas_unlock_irq(&xas);

No, that doesn't work.

> 
> I don't quite understand how we'd find a PFN for this page in the
> tree
> after the page has had page->mapping removed.  However, the more I
> look
> at this path, the more I don't like it -- it doesn't handle returning
> NULL explicitly, nor does it handle the situation where a PMD is
> split
> to form multiple PTEs explicitly, it just kind of relies on those bit
> patterns not matching.
> 
> So I kind of like the "just retry without doing anything clever"
> situation
> that the above patch takes us to.

I've been hacking at this today and am starting to lean towards
"revert" over "fix" for the amount of changes needed to get this back
on its feet. I've been able to get the test passing again with the
below changes directly on top of commit 9f32d221301c "dax: Convert
dax_lock_mapping_entry to XArray". That said, I have thus far been
unable to rebase this patch on top of v4.20-rc1 and yield a functional
result.

My concerns are:
- I can't determine if dax_unlock_entry() wants an unlocked entry
parameter, or locked. The dax_insert_pfn_mkwrite() and
dax_unlock_mapping_entry() usages seem to disagree.

- The multi-order use case of Xarray is a mystery to me. It seems to
want to know the order of entries a-priori with a choice to use
XA_STATE_ORDER() vs XA_STATE(). This falls over in
dax_unlock_mapping_entry() and other places where the only source of
the order of the entry is determined from dax_is_pmd_entry() i.e. the
Xarray itself. PageHead() does not work for DAX pages because
PageHead() is only established by the page allocator and DAX pages
never participate in the page allocator.

- The usage of rcu_read_lock() in dax_lock_mapping_entry() is needed
for inode lifetime synchronization, not just for walking the radix.
That lock needs to be dropped before sleeping, and if we slept the
inode may no longer exist.

- I could not see how the pattern:
	entry = xas_load(&xas);
	if (dax_is_locked(entry)) {
		entry = get_unlocked_entry(&xas);
...was safe given that get_unlock_entry() turns around and does
validation that the entry is !xa_internal_entry() and !NULL.

- The usage of internal entries in grab_mapping_entry() seems to need
auditing. Previously we would compare the entry size against
@size_flag, but it now if index hits a multi-order entry in
get_unlocked_entry() afaics it could be internal and we need to convert
it to the actual entry before aborting... at least to match the v4.19
behavior.

This all seems to merit a rethink of the dax integration of Xarray.

diff --git a/fs/dax.c b/fs/dax.c
index fc2745ca3308..2b3bd4a4cc48 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -99,17 +99,6 @@ static void *dax_make_locked(unsigned long pfn, unsigned long flags)
 			DAX_LOCKED);
 }
 
-static void *dax_make_entry(pfn_t pfn, unsigned long flags)
-{
-	return xa_mk_value(flags | (pfn_t_to_pfn(pfn) << DAX_SHIFT));
-}
-
-static void *dax_make_page_entry(struct page *page)
-{
-	pfn_t pfn = page_to_pfn_t(page);
-	return dax_make_entry(pfn, PageHead(page) ? DAX_PMD : 0);
-}
-
 static bool dax_is_locked(void *entry)
 {
 	return xa_to_value(entry) & DAX_LOCKED;
@@ -225,7 +214,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
  *
  * Must be called with the i_pages lock held.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *__get_unlocked_entry(struct xa_state *xas, bool (*wait_fn)(void))
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -235,6 +224,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 	ewait.wait.func = wake_exceptional_entry_func;
 
 	for (;;) {
+		bool revalidate;
+
 		entry = xas_load(xas);
 		if (!entry || xa_is_internal(entry) ||
 				WARN_ON_ONCE(!xa_is_value(entry)) ||
@@ -247,12 +238,29 @@ static void *get_unlocked_entry(struct xa_state *xas)
 					  TASK_UNINTERRUPTIBLE);
 		xas_unlock_irq(xas);
 		xas_reset(xas);
-		schedule();
+		revalidate = wait_fn();
 		finish_wait(wq, &ewait.wait);
 		xas_lock_irq(xas);
+		if (revalidate)
+			return ERR_PTR(-EAGAIN);
 	}
 }
 
+static bool entry_wait(void)
+{
+	schedule();
+	/*
+	 * Never return an ERR_PTR() from __get_unlocked_entry(), just
+	 * keep looping.
+	 */
+	return false;
+}
+
+static void *get_unlocked_entry(struct xa_state *xas)
+{
+	return __get_unlocked_entry(xas, entry_wait);
+}
+
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
@@ -366,16 +374,6 @@ static void *__get_unlocked_mapping_entry(struct address_space *mapping,
 	}
 }
 
-static bool entry_wait(void)
-{
-	schedule();
-	/*
-	 * Never return an ERR_PTR() from
-	 * __get_unlocked_mapping_entry(), just keep looping.
-	 */
-	return false;
-}
-
 static void *get_unlocked_mapping_entry(struct address_space *mapping,
 		pgoff_t index, void ***slotp)
 {
@@ -498,16 +496,33 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
+
+static bool entry_wait_revalidate(void)
+{
+	rcu_read_unlock();
+	schedule();
+	rcu_read_lock();
+
+	/*
+	 * Tell __get_unlocked_entry() to take a break, we need to
+	 * revalidate page->mapping after dropping locks
+	 */
+	return true;
+}
+
 bool dax_lock_mapping_entry(struct page *page)
 {
 	XA_STATE(xas, NULL, 0);
+	bool did_lock = false;
 	void *entry;
 
+	/* hold rcu lock to coordinate with inode end-of-life */
+	rcu_read_lock();
 	for (;;) {
 		struct address_space *mapping = READ_ONCE(page->mapping);
 
 		if (!dax_mapping(mapping))
-			return false;
+			break;
 
 		/*
 		 * In the device-dax case there's no need to lock, a
@@ -516,9 +531,12 @@ bool dax_lock_mapping_entry(struct page *page)
 		 * otherwise we would not have a valid pfn_to_page()
 		 * translation.
 		 */
-		if (S_ISCHR(mapping->host->i_mode))
-			return true;
+		if (S_ISCHR(mapping->host->i_mode)) {
+			did_lock = true;
+			break;
+		}
 
+		xas_reset(&xas);
 		xas.xa = &mapping->i_pages;
 		xas_lock_irq(&xas);
 		if (mapping != page->mapping) {
@@ -526,30 +544,33 @@ bool dax_lock_mapping_entry(struct page *page)
 			continue;
 		}
 		xas_set(&xas, page->index);
-		entry = xas_load(&xas);
-		if (dax_is_locked(entry)) {
-			entry = get_unlocked_entry(&xas);
-			/* Did the page move while we slept? */
-			if (dax_to_pfn(entry) != page_to_pfn(page)) {
-				xas_unlock_irq(&xas);
-				continue;
-			}
+		entry = __get_unlocked_entry(&xas, entry_wait_revalidate);
+		if (!entry) {
+			xas_unlock_irq(&xas);
+			break;
+		} else if (IS_ERR(entry)) {
+			xas_unlock_irq(&xas);
+			WARN_ON_ONCE(PTR_ERR(entry) != -EAGAIN);
+			continue;
 		}
 		dax_lock_entry(&xas, entry);
+		did_lock = true;
 		xas_unlock_irq(&xas);
-		return true;
+		break;
 	}
+	rcu_read_unlock();
+
+	return did_lock;
 }
 
 void dax_unlock_mapping_entry(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	XA_STATE(xas, &mapping->i_pages, page->index);
 
 	if (S_ISCHR(mapping->host->i_mode))
 		return;
 
-	dax_unlock_entry(&xas, dax_make_page_entry(page));
+	unlock_mapping_entry(mapping, page->index);
 }
 
 /*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
