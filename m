From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 0/2] mmap dio and DAX
Date: Fri, 3 Feb 2017 09:57:10 -0700
Message-ID: <20170203165710.GA24667@linux.intel.com>
References: <1484878888-11483-1-git-send-email-xzhou@redhat.com>
 <1484892950-25178-1-git-send-email-xzhou@redhat.com>
 <20170124222855.GA26631@linux.intel.com>
 <20170203055717.acjivw4o4zmxhd64@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170203055717.acjivw4o4zmxhd64-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Fri, Feb 03, 2017 at 01:57:17PM +0800, Xiong Zhou wrote:
> On Tue, Jan 24, 2017 at 03:28:55PM -0700, Ross Zwisler wrote:
> > On Fri, Jan 20, 2017 at 02:15:48PM +0800, Xiong Zhou wrote:
> > > common/rc         : requires SCRATCH_DEV support DAX
> > > src/t_mmap_dio.c  : intro mmap and O_DIRECT rw through files
> > > tests/generic/405 : IO between DAX/non-DAX mountpoints
> > > tests/xfs/138     : IO between DAX/non-DAX xfs files(per-inode flag)
> > > 
> > > v2 :
> > >   Merge helper function changes into the first patch;
> > >   Rewrite _require_dax, check options for sure;
> > >   Print msg in t_mmap_dio.c to show which test going wrong;
> > >   Empty mount options and check after mount to ensure we
> > > wont mount with wrong option;
> > >   Remove unnecessary leading underscore and _fail;
> > >   Use xfs_io instead of dd;
> > >   Other minor fixes.
> > > 
> > > v3:
> > >  close fds in C test programme for clean up.
> > > 
> > > v4:
> > >  Test both buffered and O_DIRECT IO;
> > >  Fix arg numbers in C test programme;
> > >  Fix fs options check after mount.
> > >  Cc Jeff Moyer since this test is based on his code.
> > >  (Sorry for the late cc!)
> > > 
> > > Test status:
> > >   Both cases not run on normal block device;
> > >   Both cases PASS on ramdisk based pmem devices;
> > >   DIO in both cases FAIL on brd based ramdisk with:
> > >   DIO in both cases FAIL on nvdimm devices with:
> > >     +write(Bad address) len 1024 dio dax to nondax
> > >     +write(Bad address) len 4096 dio dax to nondax
> > >     +write(Bad address) len 16777216 dio dax to nondax
> > >     +write(Bad address) len 67108864 dio dax to nondax
> > > 
> > >   I've reported this to nvdimm list.
> > >   https://lists.01.org/pipermail/linux-nvdimm/2017-January/008600.html
> > > 
> > > Xiong Zhou (2):
> > >   xfs: test per-inode DAX flag by IO
> > >   generic: test mmap io through DAX and non-DAX
> > > 
> > >  .gitignore            |   1 +
> > >  common/rc             |  13 ++++++
> > >  src/Makefile          |   2 +-
> > >  src/t_mmap_dio.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/405     | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/405.out |   2 +
> > >  tests/generic/group   |   1 +
> > >  tests/xfs/138         | 116 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/138.out     |   2 +
> > >  tests/xfs/group       |   1 +
> > >  10 files changed, 361 insertions(+), 1 deletion(-)
> > >  create mode 100644 src/t_mmap_dio.c
> > >  create mode 100755 tests/generic/405
> > >  create mode 100644 tests/generic/405.out
> > >  create mode 100755 tests/xfs/138
> > >  create mode 100644 tests/xfs/138.out
> > > 
> > > -- 
> > > 1.8.3.1
> > 
> > I just wanted to let you know that I'm testing with these new xfstests right
> > now, and so far I've been unable to successfully get any PMD faults.  I'm
> > looking into why that is right now, and should hopefully have some changes so
> > we can do both PTE and PMD testing with this set.
> 
> Thank you very much for looking into this!
> 
> Adding a printk msg in dax_iomap_pmd_fault in fs/dax.c shows that
> these 2 cases called this function, so do __radix_tree_insert
> in lib/radix-tree.c with order > 0.  I must have missed something..

Ah, yea, the flow is a little confusing.  When we first try to do a PMD fault
we insert a 2MiB "empty" entry into the radix tree that basically just allows
us to lock an entire 2MiB range.  This happens in dax_iomap_pmd_fault() via 
grab_mapping_entry().  This is most likely what you're seeing with your debug.

Then, with that empty 2MiB entry in place we try and actually service the
fault and insert a real mapping to a 2MiB huge page.  There are still cases
when this can fall back to 4k pages, and one of them is if the block
allocation we are given by the filesystem isn't 2MiB aligned.  That is the
alignment check against PG_PMD_COLOUR in dax_pmd_insert_mapping(), and that's
what we were hitting.  The way to get around this is to tell XFS that we would
like 2MiB aligned and sized block allocations via the following mkfs options:

export MKFS_OPTIONS="-d su=2m,sw=1"

We also need to fallocate our storage space so that we get 2 MiB allocations
instead of 4k allocations.

I've been working on patches that do all of this - I'll try and send them out
today.

This has taken a little longer than I would have liked because when debugging
this issue I found an issue with DAX + DIO in the kernel.  So, your test has
already found an important bug in the kernel before it was even committed to
xfstests!  :)

BTW, if we fallocate our files, is there additional value in writing data into
the files before we start testing as you do via these lines?

$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
        $SCRATCH_MNT/tf_s >> $seqres.full 2>&1
$XFS_IO_PROG -f -c "pwrite -W -b $psize 0 $tsize" \
        $SCRATCH_MNT/tf_d >> $seqres.full 2>&1

This puts a known pattern into the files and means that reads are handled from
media instead of from hole pages, but we never verify the data pattern and it
slows down the test quite a bit.  What do you think?
