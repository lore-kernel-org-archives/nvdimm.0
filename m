Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BB3881F27
 for <linux-nvdimm@lists.01.org>; Thu,  9 Feb 2017 07:30:13 -0800 (PST)
Date: Thu, 9 Feb 2017 16:30:09 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: question about ext4 block allocation
Message-ID: <20170209153009.GB3009@quack2.suse.cz>
References: <20170206231409.GA16676@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20170206231409.GA16676@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ross,

On Mon 06-02-17 16:14:09, Ross Zwisler wrote:
> I recently hit an issue in my DAX testing where I was unable to get ext4 to
> give me 2 MiB sized and aligned block allocations in a situation where I
> thought I should be able to.  I'm using a PMEM ramdisk of size 16 GiB, created
> using the memmap kernel command line parameter.
> 
>   # fdisk -l /dev/pmem0
>   Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
>   Units: sectors of 1 * 512 = 512 bytes
>   Sector size (logical/physical): 512 bytes / 4096 bytes
>   I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> 
> The very simple test program I used to reproduce this can be found at the
> bottom of this mail.  Here is the quick function that I used to recreate my
> filesystem each run:
> 
>   # type go_ext4
>   go_ext4 is a function
>   go_ext4 () 
>   { 
>       umount /dev/pmem0 2> /dev/null;
>       mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem0;
>       mount -o dax /dev/pmem0 ~/dax;
>       cd ~/fsync
>   }

...

> Great.  That's what I want.  But, if I create the filesystem and use the test
> to create a file that is 64 MiB in size, the PMD fault fails because the PFN I
> get from the filesystem isn't 2MiB aligned:
> 
> test-1475  [006] .... 11809.982188: dax_pmd_fault: dev 259:0 ino 0xc shared
> WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000 vm_end
> 0x40400000 pgoff 0x280 max_pgoff 0x3fff 
> 
> test-1475  [006] .... 11809.982398: dax_pmd_insert_mapping_fallback: dev 259:0
> ino 0xc shared write address 0x40280000 length 0x200000 pfn 0x108601 DEV|MAP
> radix_entry 0x0
> 
> test-1475  [006] .... 11809.982399: dax_pmd_fault_done: dev 259:0 ino 0xc
> shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000
> vm_end 0x40400000 pgoff 0x280 max_pgoff 0x3fff FALLBACK
> 
> The PFN for the block allocation I get from ext4 is 0x108601, which isn't
> aligned, so we fail the PG_PMD_COLOUR alignment check in
> dax_iomap_pmd_fault(), and use PTEs instead.

Yeah, it's a bug in ext4 allocator. Requests for 128MB are exactly a group
size so we find completely empty group and satisfy the request. Even larger
requests will get split into 128MB chunks. 32MB requests are small enough
that they go via a special path for power-of-two sized requests. However
64MB allocation request can be satisfied from somewhat filled group (there
are sb backup blocks in group 1 in your case) and we screw up when deciding
whether to treat such request as power-of-two or not and don't align it at
all in the end.

Another problem is that the stride size ends up unused due to another bug
in ext4. The second attached patch fixes that issue.

With these two patches applied I get file blocks aligned. That being said
the stripe-aligned allocator does a poor job of creating large extents
(larger than stripe-width) however that is more difficult to fix.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--azLHFNyN32YCQGCU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-stripe-unaligned-allocations.patch"

>From ae69b07596c0f054483b0434c30a330a811ee8ff Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 9 Feb 2017 15:46:46 +0100
Subject: [PATCH 1/2] ext4: Fix stripe-unaligned allocations

When a filesystem is created using:

mkfs.ext4 -b 4096 -E stride=512 <dev>

and we try to allocate 64MB extent, we will end up directly in
ext4_mb_complex_scan_group(). This is because the request is detected as
power-of-two allocation (so we start in ext4_mb_regular_allocator()
with ac_criteria == 0) however the check before
ext4_mb_simple_scan_group() refuses the direct buddy scan because the
allocation request is too large. Since cr == 0, the check whether we
should use ext4_mb_scan_aligned() fails as well and we fall back to
ext4_mb_complex_scan_group().

Fix the problem by checking for upper limit on power-of-two requests
directly when detecting them.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7ae43c59bc79..37db7ba0f69e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2136,8 +2136,10 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	 * We search using buddy data only if the order of the request
 	 * is greater than equal to the sbi_s_mb_order2_reqs
 	 * You can tune it via /sys/fs/ext4/<partition>/mb_order2_req
+	 * We also support searching for power-of-two requests only for
+	 * requests upto maximum buddy size we have constructed.
 	 */
-	if (i >= sbi->s_mb_order2_reqs) {
+	if (i >= sbi->s_mb_order2_reqs && i <= sb->s_blocksize_bits + 2) {
 		/*
 		 * This should tell if fe_len is exactly power of 2
 		 */
@@ -2207,7 +2209,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			}
 
 			ac->ac_groups_scanned++;
-			if (cr == 0 && ac->ac_2order < sb->s_blocksize_bits+2)
+			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 && sbi->s_stripe &&
 					!(ac->ac_g_ex.fe_len % sbi->s_stripe))
-- 
2.10.2


--azLHFNyN32YCQGCU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Do-not-use-stripe_with-if-it-is-not-set.patch"

>From f76848d56ccc532a4a02fa8e62e750221abdba89 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 9 Feb 2017 16:13:30 +0100
Subject: [PATCH 2/2] ext4: Do not use stripe_with if it is not set

Avoid using stripe_width for sbi->s_stripe value if it is not actually
set. It prevents using the stride for sbi->s_stripe.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66845a08a87a..b82cd3b263b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2619,9 +2619,9 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 
 	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
 		ret = sbi->s_stripe;
-	else if (stripe_width <= sbi->s_blocks_per_group)
+	else if (stripe_width && stripe_width <= sbi->s_blocks_per_group)
 		ret = stripe_width;
-	else if (stride <= sbi->s_blocks_per_group)
+	else if (stride && stride <= sbi->s_blocks_per_group)
 		ret = stride;
 	else
 		ret = 0;
-- 
2.10.2


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--azLHFNyN32YCQGCU--
