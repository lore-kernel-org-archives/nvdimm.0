Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74DF881F27
 for <linux-nvdimm@lists.01.org>; Thu,  9 Feb 2017 09:52:29 -0800 (PST)
Date: Thu, 9 Feb 2017 10:52:28 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: question about ext4 block allocation
Message-ID: <20170209175228.GA15524@linux.intel.com>
References: <20170206231409.GA16676@linux.intel.com>
 <20170209153009.GB3009@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170209153009.GB3009@quack2.suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 09, 2017 at 04:30:09PM +0100, Jan Kara wrote:
> Hi Ross,
> 
> On Mon 06-02-17 16:14:09, Ross Zwisler wrote:
> > I recently hit an issue in my DAX testing where I was unable to get ext4 to
> > give me 2 MiB sized and aligned block allocations in a situation where I
> > thought I should be able to.  I'm using a PMEM ramdisk of size 16 GiB, created
> > using the memmap kernel command line parameter.
> > 
> >   # fdisk -l /dev/pmem0
> >   Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
> >   Units: sectors of 1 * 512 = 512 bytes
> >   Sector size (logical/physical): 512 bytes / 4096 bytes
> >   I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > 
> > The very simple test program I used to reproduce this can be found at the
> > bottom of this mail.  Here is the quick function that I used to recreate my
> > filesystem each run:
> > 
> >   # type go_ext4
> >   go_ext4 is a function
> >   go_ext4 () 
> >   { 
> >       umount /dev/pmem0 2> /dev/null;
> >       mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem0;
> >       mount -o dax /dev/pmem0 ~/dax;
> >       cd ~/fsync
> >   }
> 
> ...
> 
> > Great.  That's what I want.  But, if I create the filesystem and use the test
> > to create a file that is 64 MiB in size, the PMD fault fails because the PFN I
> > get from the filesystem isn't 2MiB aligned:
> > 
> > test-1475  [006] .... 11809.982188: dax_pmd_fault: dev 259:0 ino 0xc shared
> > WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000 vm_end
> > 0x40400000 pgoff 0x280 max_pgoff 0x3fff 
> > 
> > test-1475  [006] .... 11809.982398: dax_pmd_insert_mapping_fallback: dev 259:0
> > ino 0xc shared write address 0x40280000 length 0x200000 pfn 0x108601 DEV|MAP
> > radix_entry 0x0
> > 
> > test-1475  [006] .... 11809.982399: dax_pmd_fault_done: dev 259:0 ino 0xc
> > shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000
> > vm_end 0x40400000 pgoff 0x280 max_pgoff 0x3fff FALLBACK
> > 
> > The PFN for the block allocation I get from ext4 is 0x108601, which isn't
> > aligned, so we fail the PG_PMD_COLOUR alignment check in
> > dax_iomap_pmd_fault(), and use PTEs instead.
> 
> Yeah, it's a bug in ext4 allocator. Requests for 128MB are exactly a group
> size so we find completely empty group and satisfy the request. Even larger
> requests will get split into 128MB chunks. 32MB requests are small enough
> that they go via a special path for power-of-two sized requests. However
> 64MB allocation request can be satisfied from somewhat filled group (there
> are sb backup blocks in group 1 in your case) and we screw up when deciding
> whether to treat such request as power-of-two or not and don't align it at
> all in the end.
> 
> Another problem is that the stride size ends up unused due to another bug
> in ext4. The second attached patch fixes that issue.
> 
> With these two patches applied I get file blocks aligned. That being said
> the stripe-aligned allocator does a poor job of creating large extents
> (larger than stripe-width) however that is more difficult to fix.

Thanks for the fixes!  Your patches do fix my simple reproducer so that it
gives me 2MiB aligned and size allocations for 64 MiB files, but when I run
Xiong's xfstest I'm still getting misaligned allocations only for 64 MiB
files.  32 MiB and 128 MiB sized files still work and give me a PMD.

I've pared down his xfstest to be a pretty minimal reproducer, and you can
find it here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/xfstests-dev.git/log/?h=ext4_PMD_allocation

You can just revert the top patch in this tree (which basically just comments
out 90% of the test and adds some debug) to get back to Xiong's full test.

The kernel tree I tested with today using your fixes can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=ext4_PMD_allocation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
