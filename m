Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 598822194EB78
 for <linux-nvdimm@lists.01.org>; Sat, 16 Feb 2019 07:35:12 -0800 (PST)
Date: Sat, 16 Feb 2019 07:35:11 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: find_get_entries_tag regression bisected
Message-ID: <20190216153511.GM12668@bombadil.infradead.org>
References: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balcer,
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 06:08:15PM -0800, Dan Williams wrote:
> Hi Willy,
> 
> Piotr reports the following crash can be triggered on latest mainline:
> 
>  EXT4-fs (pmem5): recovery complete
>  EXT4-fs (pmem5): mounted filesystem with ordered data mode. Opts: dax
>  ------------[ cut here ]------------
>  kernel BUG at mm/pgtable-generic.c:127!
>  invalid opcode: 0000 [#1] SMP PTI
>  CPU: 28 PID: 1193 Comm: a.out Tainted: G        W  OE     4.19.0-rc5+ #2907
>  [..]
>  RIP: 0010:pmdp_huge_clear_flush+0x1e/0x80
>  [..]
>  Call Trace:
>   dax_writeback_mapping_range+0x473/0x8a0
>   ? print_shortest_lock_dependencies+0x40/0x40
>   ? jbd2_journal_stop+0xef/0x470
>   ? ext4_fill_super+0x3071/0x3110
>   ? __lock_is_held+0x4f/0x90
>   ? __lock_is_held+0x4f/0x90
>   ext4_dax_writepages+0xed/0x2f0
>   do_writepages+0x41/0xe0
>   __filemap_fdatawrite_range+0xbe/0xf0
>   file_write_and_wait_range+0x4c/0xa0
>   ext4_sync_file+0xa6/0x4f0
> 
> I bisected this regression to commit c1901cd33cf4 "page cache: Convert
> find_get_entries_tag to XArray". I suspect another case of pte vs pmd
> confusion.
> 
> Below is the small reproducer from Piotr, it triggers in a qemu
> environment with emulated pmem, but only with ext4 that I can see, but
> I did not dig too deep. Let me know if anything jumps out to you. I'll
> otherwise take a deeper look in the coming days.

I think this is another case of the XArray and radix tree iterators
having different behaviour with multi-slot entries.  The radix tree
iterator would rewind the index to the head index while the XArray
iterator leaves it static.

While the regression was introduced with the change to
find_get_entries_tag(), DAX now uses the xas_for_each_marked() iterator
directly, so changing the behaviour of find_get_entries_tag() would
be pointless.  I think the simplest way to fix this is for DAX to
set the index appropriately.  Maybe something like this?

diff --git a/fs/dax.c b/fs/dax.c
index 6959837cc465..43e3aad31885 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -843,7 +843,7 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		struct address_space *mapping, void *entry)
 {
-	unsigned long pfn;
+	unsigned long pfn, index;
 	long ret = 0;
 	size_t size;
 
@@ -894,16 +894,17 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_unlock_irq(xas);
 
 	/*
-	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
-	 * in the middle of a PMD, the 'index' we are given will be aligned to
-	 * the start index of the PMD, as will the pfn we pull from 'entry'.
+	 * If dax_writeback_mapping_range() was given a wbc->range_start
+	 * in the middle of a PMD, the 'index' we are given needs to be
+	 * aligned to the start index of the PMD.
 	 * This allows us to flush for PMD_SIZE and not have to worry about
 	 * partial PMD writebacks.
 	 */
 	pfn = dax_to_pfn(entry);
 	size = PAGE_SIZE << dax_entry_order(entry);
+	index = xas->xa_index &~ ((1UL << dax_entry_order(entry)) - 1);
 
-	dax_entry_mkclean(mapping, xas->xa_index, pfn);
+	dax_entry_mkclean(mapping, index, pfn);
 	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There


Another way to fix this would be to mask the address in dax_entry_mkclean(),
but I think this is cleaner.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
