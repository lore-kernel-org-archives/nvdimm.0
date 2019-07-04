Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B3C4212B0811
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jul 2019 12:14:13 -0700 (PDT)
Date: Thu, 4 Jul 2019 12:14:07 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
Message-ID: <20190704191407.GM1729@bombadil.infradead.org>
References: <156213869409.3910140.7715747316991468148.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190703121743.GH1729@bombadil.infradead.org>
 <CAPcyv4jgs5LTtTXR+2CyfbjJE85B_eoPFuXQsGBDnVMo41Jawg@mail.gmail.com>
 <20190703195302.GJ1729@bombadil.infradead.org>
 <CAPcyv4iPNz=oJyc_EoE-mC11=gyBzwMKbmj1ZY_Yna54=cC=Mg@mail.gmail.com>
 <20190704032728.GK1729@bombadil.infradead.org>
 <20190704165450.GH31037@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190704165450.GH31037@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <openosd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 04, 2019 at 06:54:50PM +0200, Jan Kara wrote:
> On Wed 03-07-19 20:27:28, Matthew Wilcox wrote:
> > So I think we're good for all current users.
> 
> Agreed but it is an ugly trap. As I already said, I'd rather pay the
> unnecessary cost of waiting for pte entry and have an easy to understand
> interface. If we ever have a real world use case that would care for this
> optimization, we will need to refactor functions to make this possible and
> still keep the interfaces sane. For example get_unlocked_entry() could
> return special "error code" indicating that there's no entry with matching
> order in xarray but there's a conflict with it. That would be much less
> error-prone interface.

This is an internal interface.  I think it's already a pretty gnarly
interface to use by definition -- it's going to sleep and might return
almost anything.  There's not much scope for returning an error indicator
either; value entries occupy half of the range (all odd numbers between 1
and ULONG_MAX inclusive), plus NULL.  We could use an internal entry, but
I don't think that makes the interface any easier to use than returning
a locked entry.

I think this iteration of the patch makes it a little clearer.  What do you
think?

diff --git a/fs/dax.c b/fs/dax.c
index 2e48c7ebb973..398b601259f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -198,8 +198,11 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
  * if it did.
  *
  * Must be called with the i_pages lock held.
+ *
+ * If order is non-zero, then a locked smaller entry (eg a PTE entry)
+ * may be returned.
  */
-static void *get_unlocked_entry(struct xa_state *xas)
+static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 {
 	void *entry;
 	struct wait_exceptional_entry_queue ewait;
@@ -211,7 +214,8 @@ static void *get_unlocked_entry(struct xa_state *xas)
 	for (;;) {
 		entry = xas_find_conflict(xas);
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
-				!dax_is_locked(entry))
+				!dax_is_locked(entry) ||
+				dax_entry_order(entry) < order)
 			return entry;
 
 		wq = dax_entry_waitqueue(xas, entry, &ewait.key);
@@ -253,8 +257,12 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
 
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
-	/* If we were the only waiter woken, wake the next one */
-	if (entry)
+	/*
+	 * If we were the only waiter woken, wake the next one.
+	 * Do not wake anybody if the entry is locked; that indicates
+	 * we weren't woken.
+	 */
+	if (entry && !dax_is_locked(entry))
 		dax_wake_entry(xas, entry, false);
 }
 
@@ -461,7 +469,7 @@ void dax_unlock_page(struct page *page, dax_entry_t cookie)
  * overlap with xarray value entries.
  */
 static void *grab_mapping_entry(struct xa_state *xas,
-		struct address_space *mapping, unsigned long size_flag)
+		struct address_space *mapping, unsigned int order)
 {
 	unsigned long index = xas->xa_index;
 	bool pmd_downgrade = false; /* splitting PMD entry into PTE entries? */
@@ -469,7 +477,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 retry:
 	xas_lock_irq(xas);
-	entry = get_unlocked_entry(xas);
+	entry = get_unlocked_entry(xas, order);
 
 	if (entry) {
 		if (!xa_is_value(entry)) {
@@ -477,7 +485,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 			goto out_unlock;
 		}
 
-		if (size_flag & DAX_PMD) {
+		if (order == PMD_ORDER) {
 			if (dax_is_pte_entry(entry)) {
 				put_unlocked_entry(xas, entry);
 				goto fallback;
@@ -523,7 +531,10 @@ static void *grab_mapping_entry(struct xa_state *xas,
 	if (entry) {
 		dax_lock_entry(xas, entry);
 	} else {
-		entry = dax_make_entry(pfn_to_pfn_t(0), size_flag | DAX_EMPTY);
+		unsigned long flags = DAX_EMPTY;
+		if (order > 0)
+			flags |= DAX_PMD;
+		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
 		dax_lock_entry(xas, entry);
 		if (xas_error(xas))
 			goto out_unlock;
@@ -594,7 +605,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
 		if (WARN_ON_ONCE(!xa_is_value(entry)))
 			continue;
 		if (unlikely(dax_is_locked(entry)))
-			entry = get_unlocked_entry(&xas);
+			entry = get_unlocked_entry(&xas, 0);
 		if (entry)
 			page = dax_busy_page(entry);
 		put_unlocked_entry(&xas, entry);
@@ -621,7 +632,7 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	void *entry;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, 0);
 	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
 		goto out;
 	if (!trunc &&
@@ -849,7 +860,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	if (unlikely(dax_is_locked(entry))) {
 		void *old_entry = entry;
 
-		entry = get_unlocked_entry(xas);
+		entry = get_unlocked_entry(xas, dax_entry_order(entry));
 
 		/* Entry got punched out / reallocated? */
 		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
@@ -861,6 +872,9 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		 */
 		if (dax_to_pfn(old_entry) != dax_to_pfn(entry))
 			goto put_unlocked;
+		/* Did a PMD entry get split? */
+		if (dax_is_locked(entry))
+			goto put_unlocked;
 		if (WARN_ON_ONCE(dax_is_empty_entry(entry) ||
 					dax_is_zero_entry(entry))) {
 			ret = -EIO;
@@ -1510,7 +1524,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * entry is already in the array, for instance), it will return
 	 * VM_FAULT_FALLBACK.
 	 */
-	entry = grab_mapping_entry(&xas, mapping, DAX_PMD);
+	entry = grab_mapping_entry(&xas, mapping, PMD_ORDER);
 	if (xa_is_internal(entry)) {
 		result = xa_to_internal(entry);
 		goto fallback;
@@ -1659,7 +1673,7 @@ dax_insert_pfn_mkwrite(struct vm_fault *vmf, pfn_t pfn, unsigned int order)
 	vm_fault_t ret;
 
 	xas_lock_irq(&xas);
-	entry = get_unlocked_entry(&xas);
+	entry = get_unlocked_entry(&xas, order);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (order == 0 && !dax_is_pte_entry(entry)) ||
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
