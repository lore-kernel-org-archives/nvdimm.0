Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH 1/4] pmem: Initial version of persistent memory driver
Date: Mon, 3 Nov 2014 16:19:37 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

I really wish people wouldn't use my Exchange email address for patches.  It's completely impossible to have a meaningful conversation this way.  I've resorted to inserting extra quotation marks by hand so people can stand at least some chance of understanding what the hell's going on.

> > +config BLK_DEV_PMEM_COUNT
> > +	int "Default number of PMEM disks"
> > +	default "4"
> 
> For real use I think a default of 1 would be better.

For real use, you need at least two to run xfstests.  This whole configuration mechanism is going away soon anyway.

> > +	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
> > +	size_t offset = page_offset << PAGE_SHIFT;
> > +
> 
> Since page_offset is only used to calculate offset, they
> could be joined to avoid relying on the compiler to
> optimize it away:
> 	size_t offset = sector >> PAGE_SECTORS_SHIFT << PAGE_SHIFT;

If you insist on doing the compiler's job for it, why not:

	size_t offset = sector >> (PAGE_SECTORS_SHIFT - PAGE_SHIFT);

I actually think the original is clearer.

> > +	BUG_ON(offset >= pmem->size);
> 
> BUG_ON is severe... should this function be designed to return 
> an error instead?

No ... upper levels should have prevented an out of range I/O from being communicated down to the driver.  Finding the I/O is out of range here indicates something is horribly wrong, and BUG_ON is the appropriate response.

> > +	if (rw == READ) {
> > +		copy_from_pmem(mem + off, pmem, sector, len);
> > +		flush_dcache_page(page);
> 
> Why does READ flush the dcache after reading?  It's fine to 
> leave data in dcache.

You misunderstand the purpose of flush_dcache_page(); see Documentation/cachetlb.txt.  It is to handle D-cache aliasing between user views of pages and kernel views of pages.  So we have to flush it after reading so that userspace sees the newly written data, and flush it before writing from it, so that the kernel sees all the data thast userspace has written to it.  These macros are no-ops on x86, but on CPUs like PA-RISC, they perform important work.

> If a read or write of a pmem address gets an uncorrectable
> error, the system should not crash; just report this IO is bad.  
> That reflects a difference in storage philosophy vs. memory
> philosophy.  All the rest of the data in the pmem might be
> fine, and many users prefer to recover 99% of their data
> than lose it all.
> 
> pmem_do_bvec needs a way to turn off normal DRAM "crash on
> error" handling for its accesses, and provide a return value
> indicating success or failure.

This is on our longer-term TODO list.  It requires integration with the MCE handler.

> Also, most storage devices automatically remap bad sectors
> when they are overwritten or remap them on command (e.g.,
> REASSIGN BLOCKS in SCSI), rather than leave that sector 
> bad forever.  I don't know how many filesystems and
> applications rely on that feature now, vs. maintain their
> own bad block tables; this may be something that pmem
> needs to provide.

At least ext4 supports the concept of bad blocks.  XFS doesn't (due to it being a bad idea for modern hard drives), but it's pretty trivial to add (a special inode that owns all of the bad blocks; no changes to any data structures).

> > +	BUG_ON(bio->bi_rw & REQ_DISCARD);
> > +
> 
> Since discard (i.e., unmap, trip) is just a hint, it could just 
> be ignored rather than trigger a drastic BUG.

Again, upper layers should have not sent down a DISCARD request since the driver didn't indicate support for them.  Personally, I would have not put this line in, but it's Ross' driver and I wasn't going to argue with him.

> Related suggestion: keep track of each sector that has been 
> discarded, and whether it has been written after discard.
> This would tell flash-backed DRAM which sectors don't need 
> to be flushed to flash on a power failure.

How would we communicate that info to the DIMM?  We're not opposed to putting in DISCARd support, but it needs to provide some value.

> Related suggestion: Adding WRITE SAME support would be useful
> for some software (for at least the writing zeros subset) - 
> that command is not just a hint.  It would result in a memset.

At this point, it's no more efficient in the Linux stack than having the filesystem send down I/Os full of zeroes.  The NVMe WRITE ZEROES command would be more efficient, but that's not yet supported by the Linux stack.

> These modparam variable names and description scripts use gb 
> and GB when they mean GiB.  The storage market generally uses 
> correct SI units; please don't follow JEDEC's misuse.  The
> Kconfig descriptions use the right IEC binary units.

These are also going away.

> > +/* FIXME: move phys_addr, virt_addr, size calls up to caller */
> 
> It is unclear what that wants to fix.

Also part of the configuration interface that is being replaced.

> > +	size_t disk_size = total_size / pmem_count;
> 
> There is no protection for pmem_count being 0 and causing
> divide-by-zero.
> 
> There is no check for disk_size being 0.  That might
> cause problems in pmem_init.

Also part of the configuration interface that is being replaced.

> This driver should be blk-mq based.  Not doing so loses
> out on a number of SMP and NUMA performance improvements.
> For example, blk_alloc_queue calls blk_alloc_queue_node
> with NUMA_NO_NODE.  If it called blk_mq_init_queue, then
> each CPU would get structures located on its node.

No, it's completely pointless to use blk-mq for pmem.  There is zero advantage for a synchronous block driver to include this overhead.

> > +	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
> 
> Many storage controllers support 1 MiB IOs now, and increasing
> amounts of software feel comfortable generating those sizes.  
> That means this should be at least 2048.

Linux prohibits this being larger than 1024 today; see Documentation/block/biodoc.txt

> It might be appropriate to call blk_queue_rq_timeout
> and set up a very short timeout, since persistent memory is
> very fast.  I'm not sure what the default is for non-blk-mq
> drivers; for blk-mq, I think it is 30 seconds, which is
> far too long for memory based storage.

The Linux block layer isn't tracking these I/Os because we're a BIO driver.

> > +	phys_addr  = (phys_addr_t) pmem_start_gb * 1024 * 1024 * 1024;
> > +	total_size = (size_t)	   pmem_size_gb  * 1024 * 1024 * 1024;
> 
> There is no check for start+size wrapping around the
> address space. 

Right; will go away as part of the new configuration system.

> Although modparams are a fine starting point, some way to
> automatically load drivers based on e820 table and other ACPI
> content will be needed.  pmem may not be the only driver
> vying for use of persistent memory regions; some sort of
> arbiter will be needed to implement the user's choice (the
> same way each boot).

I thought you were being cc'd on the review of that document ... ?

> > +	res_mem = request_mem_region_exclusive(phys_addr, total_size, "pmem");

> Does the call to request_mem_region_exclusive, which uses:
>	#define IORESOURCE_EXCLUSIVE    0x08000000      /* Userland may not map this > resource */
> mean that userspace cannot mmap files and directly access
> persistent memory?  There are only 3 drivers that use
> request.*exclusive functions: drivers/net/ethernet/intel/e1000e
> and drivers/watchdog/sp5100-tco. None of the storage drivers 
> do so.

It does not mean that, since I do exactly this today using DAX on top of PMEM.  It means that userspace can't go poking around in /proc/mem and map the memory directly, which isn't how anybody wants programs to work.

> > +	virt_addr = ioremap_cache(phys_addr, total_size);
> 
> ioremap_cache maps the addresses as writeback cacheable.  How 
> about offering all the cache attributes as modparams?
> * writeback (WB): costly cache flushes to preserve data
> * write combining (WC): must flush the WC buffers
> * writethrough (WT): safe, good for cases where the application
>   expects to read the data again soon
> * uncacheable (UC): safe, good for cases where the application
>   does not expect to read the data
> 
> There are some use cases for persistence across reboots
> that don't care about persistence across power cycles;
> for these, separate options could be provided for:
> * WB
> * WB+flush
> * WC
> * WC+flush

We hadn't talked about this previously ... let's look into it.

> > +	result = register_blkdev(0, "pmem");
> > +	if (result < 0) {
> > +		result = -EIO;
> > +		goto out_unmap;
> 
> In comparison, if sd fails register_blkdev, it returns
> -ENODEV.  Since no pmem device is created, -ENODEV might
> be more appropriate.

I'm not sure why we don't just return the error from register_blkdev().  Ross?

> The pmem_major variable might be unsafe/racy if multiple
> concurrent module loads are possible.

They aren't.

> Should this function call blk_register_region after
> calling register_blkdev?

I don't think that's necessary with dynamic majors, but I'm happy to learn that I'm wrong about this.

Phew, that was a long one!  Thanks for your review!
