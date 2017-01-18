Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <CAOvWMLZA092iUCnFxCxPZmDNX-hH08xbSnweBhK-E-m9Ko0yuw@mail.gmail.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <20170117063355.GL14033@birch.djwong.org>
 <20170117213549.GB4880@omniknight.lm.intel.com>
 <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
 <1BAF6FD6-1FDB-4F7C-A915-891F46E78B8C@dilger.ca>
 <CAOvWMLZA092iUCnFxCxPZmDNX-hH08xbSnweBhK-E-m9Ko0yuw@mail.gmail.com>
From: Lu Zhang <luzh@eng.ucsd.edu>
Date: Tue, 17 Jan 2017 19:08:18 -0800
Message-ID: <CAL4pJv6MvJhTuPJbPAV-HXGrMST-dJs461O=wwfcpdvQA-amdA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
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
To: Andiry Xu <andiry@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

I'm curious about the fault model and corresponding hardware ECC mechanisms
for NVDIMMs. In my understanding for memory accesses to trigger MCE, it
means the memory controller finds a detectable but uncorrectable error
(DUE). So if there is no hardware ECC support the media errors won't even
be noticed, not to mention badblocks or machine checks.

Current hardware ECC support for DRAM usually employs (72, 64) single-bit
error correction mechanism, and for advanced ECCs there are techniques like
Chipkill or SDDC which can tolerate a single DRAM chip failure. What is the
expected ECC mode for NVDIMMs, assuming that PCM or 3dXpoint based
technology might have higher error rates?

If DUE does happen and is flagged to the file system via MCE (somehow...),
and the fs finds that the error corrupts its allocated data page, or
metadata, now if the fs wants to recover its data the intuition is that
there needs to be a stronger error correction mechanism to correct the
hardware-uncorrectable errors. So knowing the hardware ECC baseline is
helpful for the file system to understand how severe are the faults in
badblocks, and develop its recovery methods.

Regards,
Lu

On Tue, Jan 17, 2017 at 6:01 PM, Andiry Xu <andiry@gmail.com> wrote:

> On Tue, Jan 17, 2017 at 4:16 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On Jan 17, 2017, at 3:15 PM, Andiry Xu <andiry@gmail.com> wrote:
> >> On Tue, Jan 17, 2017 at 1:35 PM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> >>> On 01/16, Darrick J. Wong wrote:
> >>>> On Fri, Jan 13, 2017 at 05:49:10PM -0700, Vishal Verma wrote:
> >>>>> On 01/14, Slava Dubeyko wrote:
> >>>>>>
> >>>>>> ---- Original Message ----
> >>>>>> Subject: [LSF/MM TOPIC] Badblocks checking/representation in
> filesystems
> >>>>>> Sent: Jan 13, 2017 1:40 PM
> >>>>>> From: "Verma, Vishal L" <vishal.l.verma@intel.com>
> >>>>>> To: lsf-pc@lists.linux-foundation.org
> >>>>>> Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org,
> linux-fsdevel@vger.kernel.org
> >>>>>>
> >>>>>>> The current implementation of badblocks, where we consult the
> >>>>>>> badblocks list for every IO in the block driver works, and is a
> >>>>>>> last option failsafe, but from a user perspective, it isn't the
> >>>>>>> easiest interface to work with.
> >>>>>>
> >>>>>> As I remember, FAT and HFS+ specifications contain description of
> bad blocks
> >>>>>> (physical sectors) table. I believe that this table was used for
> the case of
> >>>>>> floppy media. But, finally, this table becomes to be the completely
> obsolete
> >>>>>> artefact because mostly storage devices are reliably enough. Why do
> you need
> >>>>
> >>>> ext4 has a badblocks inode to own all the bad spots on disk, but ISTR
> it
> >>>> doesn't support(??) extents or 64-bit filesystems, and might just be a
> >>>> vestigial organ at this point.  XFS doesn't have anything to track bad
> >>>> blocks currently....
> >>>>
> >>>>>> in exposing the bad blocks on the file system level?  Do you expect
> that next
> >>>>>> generation of NVM memory will be so unreliable that file system
> needs to manage
> >>>>>> bad blocks? What's about erasure coding schemes? Do file system
> really need to suffer
> >>>>>> from the bad block issue?
> >>>>>>
> >>>>>> Usually, we are using LBAs and it is the responsibility of storage
> device to map
> >>>>>> a bad physical block/page/sector into valid one. Do you mean that
> we have
> >>>>>> access to physical NVM memory address directly? But it looks like
> that we can
> >>>>>> have a "bad block" issue even we will access data into page cache's
> memory
> >>>>>> page (if we will use NVM memory for page cache, of course). So,
> what do you
> >>>>>> imply by "bad block" issue?
> >>>>>
> >>>>> We don't have direct physical access to the device's address space,
> in
> >>>>> the sense the device is still free to perform remapping of chunks of
> NVM
> >>>>> underneath us. The problem is that when a block or address range (as
> >>>>> small as a cache line) goes bad, the device maintains a poison bit
> for
> >>>>> every affected cache line. Behind the scenes, it may have already
> >>>>> remapped the range, but the cache line poison has to be kept so that
> >>>>> there is a notification to the user/owner of the data that something
> has
> >>>>> been lost. Since NVM is byte addressable memory sitting on the memory
> >>>>> bus, such a poisoned cache line results in memory errors and
> SIGBUSes.
> >>>>> Compared to tradational storage where an app will get nice and
> friendly
> >>>>> (relatively speaking..) -EIOs. The whole badblocks implementation was
> >>>>> done so that the driver can intercept IO (i.e. reads) to _known_ bad
> >>>>> locations, and short-circuit them with an EIO. If the driver doesn't
> >>>>> catch these, the reads will turn into a memory bus access, and the
> >>>>> poison will cause a SIGBUS.
> >>>>
> >>>> "driver" ... you mean XFS?  Or do you mean the thing that makes pmem
> >>>> look kind of like a traditional block device? :)
> >>>
> >>> Yes, the thing that makes pmem look like a block device :) --
> >>> drivers/nvdimm/pmem.c
> >>>
> >>>>
> >>>>> This effort is to try and make this badblock checking smarter - and
> try
> >>>>> and reduce the penalty on every IO to a smaller range, which only the
> >>>>> filesystem can do.
> >>>>
> >>>> Though... now that XFS merged the reverse mapping support, I've been
> >>>> wondering if there'll be a resubmission of the device errors callback?
> >>>> It still would be useful to be able to inform the user that part of
> >>>> their fs has gone bad, or, better yet, if the buffer is still in
> memory
> >>>> someplace else, just write it back out.
> >>>>
> >>>> Or I suppose if we had some kind of raid1 set up between memories we
> >>>> could read one of the other copies and rewrite it into the failing
> >>>> region immediately.
> >>>
> >>> Yes, that is kind of what I was hoping to accomplish via this
> >>> discussion. How much would filesystems want to be involved in this sort
> >>> of badblocks handling, if at all. I can refresh my patches that provide
> >>> the fs notification, but that's the easy bit, and a starting point.
> >>>
> >>
> >> I have some questions. Why moving badblock handling to file system
> >> level avoid the checking phase? In file system level for each I/O I
> >> still have to check the badblock list, right? Do you mean during mount
> >> it can go through the pmem device and locates all the data structures
> >> mangled by badblocks and handle them accordingly, so that during
> >> normal running the badblocks will never be accessed? Or, if there is
> >> replicataion/snapshot support, use a copy to recover the badblocks?
> >
> > With ext4 badblocks, the main outcome is that the bad blocks would be
> > pemanently marked in the allocation bitmap as being used, and they would
> > never be allocated to a file, so they should never be accessed unless
> > doing a full device scan (which ext4 and e2fsck never do).  That would
> > avoid the need to check every I/O against the bad blocks list, if the
> > driver knows that the filesystem will handle this.
> >
>
> Thank you for explanation. However this only works for free blocks,
> right? What about allocated blocks, like file data and metadata?
>
> Thanks,
> Andiry
>
> > The one caveat is that ext4 only allows 32-bit block numbers in the
> > badblocks list, since this feature hasn't been used in a long time.
> > This is good for up to 16TB filesystems, but if there was a demand to
> > use this feature again it would be possible allow 64-bit block numbers.
> >
> > Cheers, Andreas
> >
> >
> >
> >
> >
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
