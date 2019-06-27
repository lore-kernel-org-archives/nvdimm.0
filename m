Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 083EC212966F9
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jun 2019 11:58:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id b7so3354204otl.11
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jun 2019 11:58:23 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org>
 <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
In-Reply-To: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Jun 2019 11:58:12 -0700
Message-ID: <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Seema Pandit <seema.pandit@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, Robert Barror <robert.barror@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 27, 2019 at 11:29 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jun 27, 2019 at 9:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 5:34 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> > > > Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> > > > been encountering intermittent lockups. The backtraces always include
> > > > the filesystem-DAX PMD path, multi-order entries have been a source of
> > > > bugs in the past, and disabling the PMD path allows a test that fails in
> > > > minutes to run for an hour.
> > >
> > > On May 4th, I asked you:
> > >
> > > Since this is provoked by a fatal signal, it must have something to do
> > > with a killable or interruptible sleep.  There's only one of those in the
> > > DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
> > > I/O with write() or through a writable mmap()?  I'd like to know before
> > > I chase too far down this fault tree analysis.
> >
> > RocksDB in this case is using write() for writes and mmap() for reads.
>
> It's not clear to me that a fatal signal is a component of the failure
> as much as it's the way to detect that the benchmark has indeed locked
> up.

Even though db_bench is run with the mmap_read=1 option:

  cmd="${rocksdb_dir}/db_bench $params_r --benchmarks=readwhilewriting \
       --use_existing_db=1 \
        --mmap_read=1 \
       --num=$num_keys \
       --threads=$num_read_threads \

When the lockup occurs there are db_bench processes in the write fault path:

[ 1666.635212] db_bench        D    0  2492   2435 0x00000000
[ 1666.641339] Call Trace:
[ 1666.644072]  ? __schedule+0x24f/0x680
[ 1666.648162]  ? __switch_to_asm+0x34/0x70
[ 1666.652545]  schedule+0x29/0x90
[ 1666.656054]  get_unlocked_entry+0xcd/0x120
[ 1666.660629]  ? dax_iomap_actor+0x270/0x270
[ 1666.665206]  grab_mapping_entry+0x14f/0x230
[ 1666.669878]  dax_iomap_pmd_fault.isra.42+0x14d/0x950
[ 1666.675425]  ? futex_wait+0x122/0x230
[ 1666.679518]  ext4_dax_huge_fault+0x16f/0x1f0
[ 1666.684288]  __handle_mm_fault+0x411/0x1350
[ 1666.688961]  ? do_futex+0xca/0xbb0
[ 1666.692760]  ? __switch_to_asm+0x34/0x70
[ 1666.697144]  handle_mm_fault+0xbe/0x1e0
[ 1666.701429]  __do_page_fault+0x249/0x4f0
[ 1666.705811]  do_page_fault+0x32/0x110
[ 1666.709903]  ? page_fault+0x8/0x30
[ 1666.713702]  page_fault+0x1e/0x30

...where __handle_mm_fault+0x411 is in wp_huge_pmd():

(gdb) li *(__handle_mm_fault+0x411)
0xffffffff812713d1 is in __handle_mm_fault (mm/memory.c:3800).
3795    static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf,
pmd_t orig_pmd)
3796    {
3797            if (vma_is_anonymous(vmf->vma))
3798                    return do_huge_pmd_wp_page(vmf, orig_pmd);
3799            if (vmf->vma->vm_ops->huge_fault)
3800                    return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
3801
3802            /* COW handled on pte level: split pmd */
3803            VM_BUG_ON_VMA(vmf->vma->vm_flags & VM_SHARED, vmf->vma);
3804            __split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);

This bug feels like we failed to unlock, or unlocked the wrong entry
and this hunk in the bisected commit looks suspect to me. Why do we
still need to drop the lock now that the radix_tree_preload() calls
are gone?

                /*
                 * Besides huge zero pages the only other thing that gets
                 * downgraded are empty entries which don't need to be
                 * unmapped.
                 */
-               if (pmd_downgrade && dax_is_zero_entry(entry))
-                       unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
-                                                       PG_PMD_NR, false);
-
-               err = radix_tree_preload(
-                               mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
-               if (err) {
-                       if (pmd_downgrade)
-                               put_locked_mapping_entry(mapping, index);
-                       return ERR_PTR(err);
-               }
-               xa_lock_irq(&mapping->i_pages);
-
-               if (!entry) {
-                       /*
-                        * We needed to drop the i_pages lock while calling
-                        * radix_tree_preload() and we didn't have an entry to
-                        * lock.  See if another thread inserted an entry at
-                        * our index during this time.
-                        */
-                       entry = __radix_tree_lookup(&mapping->i_pages, index,
-                                       NULL, &slot);
-                       if (entry) {
-                               radix_tree_preload_end();
-                               xa_unlock_irq(&mapping->i_pages);
-                               goto restart;
-                       }
+               if (dax_is_zero_entry(entry)) {
+                       xas_unlock_irq(xas);
+                       unmap_mapping_pages(mapping,
+                                       xas->xa_index & ~PG_PMD_COLOUR,
+                                       PG_PMD_NR, false);
+                       xas_reset(xas);
+                       xas_lock_irq(xas);
                }

-               if (pmd_downgrade) {
-                       dax_disassociate_entry(entry, mapping, false);
-                       radix_tree_delete(&mapping->i_pages, index);
-                       mapping->nrexceptional--;
-                       dax_wake_mapping_entry_waiter(&mapping->i_pages,
-                                       index, entry, true);
-               }
+               dax_disassociate_entry(entry, mapping, false);
+               xas_store(xas, NULL);   /* undo the PMD join */
+               dax_wake_entry(xas, entry, true);
+               mapping->nrexceptional--;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
