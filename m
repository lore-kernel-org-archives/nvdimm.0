Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170117213549.GB4880@omniknight.lm.intel.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <20170117063355.GL14033@birch.djwong.org>
 <20170117213549.GB4880@omniknight.lm.intel.com>
From: Andiry Xu <andiry@gmail.com>
Date: Tue, 17 Jan 2017 14:15:50 -0800
Message-ID: <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

On Tue, Jan 17, 2017 at 1:35 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 01/16, Darrick J. Wong wrote:
>> On Fri, Jan 13, 2017 at 05:49:10PM -0700, Vishal Verma wrote:
>> > On 01/14, Slava Dubeyko wrote:
>> > >
>> > > ---- Original Message ----
>> > > Subject: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
>> > > Sent: Jan 13, 2017 1:40 PM
>> > > From: "Verma, Vishal L" <vishal.l.verma@intel.com>
>> > > To: lsf-pc@lists.linux-foundation.org
>> > > Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
>> > >
>> > > > The current implementation of badblocks, where we consult the badblocks
>> > > > list for every IO in the block driver works, and is a last option
>> > > > failsafe, but from a user perspective, it isn't the easiest interface to
>> > > > work with.
>> > >
>> > > As I remember, FAT and HFS+ specifications contain description of bad blocks
>> > > (physical sectors) table. I believe that this table was used for the case of
>> > > floppy media. But, finally, this table becomes to be the completely obsolete
>> > > artefact because mostly storage devices are reliably enough. Why do you need
>>
>> ext4 has a badblocks inode to own all the bad spots on disk, but ISTR it
>> doesn't support(??) extents or 64-bit filesystems, and might just be a
>> vestigial organ at this point.  XFS doesn't have anything to track bad
>> blocks currently....
>>
>> > > in exposing the bad blocks on the file system level?  Do you expect that next
>> > > generation of NVM memory will be so unreliable that file system needs to manage
>> > > bad blocks? What's about erasure coding schemes? Do file system really need to suffer
>> > > from the bad block issue?
>> > >
>> > > Usually, we are using LBAs and it is the responsibility of storage device to map
>> > > a bad physical block/page/sector into valid one. Do you mean that we have
>> > > access to physical NVM memory address directly? But it looks like that we can
>> > > have a "bad block" issue even we will access data into page cache's memory
>> > > page (if we will use NVM memory for page cache, of course). So, what do you
>> > > imply by "bad block" issue?
>> >
>> > We don't have direct physical access to the device's address space, in
>> > the sense the device is still free to perform remapping of chunks of NVM
>> > underneath us. The problem is that when a block or address range (as
>> > small as a cache line) goes bad, the device maintains a poison bit for
>> > every affected cache line. Behind the scenes, it may have already
>> > remapped the range, but the cache line poison has to be kept so that
>> > there is a notification to the user/owner of the data that something has
>> > been lost. Since NVM is byte addressable memory sitting on the memory
>> > bus, such a poisoned cache line results in memory errors and SIGBUSes.
>> > Compared to tradational storage where an app will get nice and friendly
>> > (relatively speaking..) -EIOs. The whole badblocks implementation was
>> > done so that the driver can intercept IO (i.e. reads) to _known_ bad
>> > locations, and short-circuit them with an EIO. If the driver doesn't
>> > catch these, the reads will turn into a memory bus access, and the
>> > poison will cause a SIGBUS.
>>
>> "driver" ... you mean XFS?  Or do you mean the thing that makes pmem
>> look kind of like a traditional block device? :)
>
> Yes, the thing that makes pmem look like a block device :) --
> drivers/nvdimm/pmem.c
>
>>
>> > This effort is to try and make this badblock checking smarter - and try
>> > and reduce the penalty on every IO to a smaller range, which only the
>> > filesystem can do.
>>
>> Though... now that XFS merged the reverse mapping support, I've been
>> wondering if there'll be a resubmission of the device errors callback?
>> It still would be useful to be able to inform the user that part of
>> their fs has gone bad, or, better yet, if the buffer is still in memory
>> someplace else, just write it back out.
>>
>> Or I suppose if we had some kind of raid1 set up between memories we
>> could read one of the other copies and rewrite it into the failing
>> region immediately.
>
> Yes, that is kind of what I was hoping to accomplish via this
> discussion. How much would filesystems want to be involved in this sort
> of badblocks handling, if at all. I can refresh my patches that provide
> the fs notification, but that's the easy bit, and a starting point.
>

I have some questions. Why moving badblock handling to file system
level avoid the checking phase? In file system level for each I/O I
still have to check the badblock list, right? Do you mean during mount
it can go through the pmem device and locates all the data structures
mangled by badblocks and handle them accordingly, so that during
normal running the badblocks will never be accessed? Or, if there is
replicataion/snapshot support, use a copy to recover the badblocks?

How about operations bypass the file system, i.e. mmap?


>>
>> > > > A while back, Dave Chinner had suggested a move towards smarter
>> > > > handling, and I posted initial RFC patches [1], but since then the topic
>> > > > hasn't really moved forward.
>> > > >
>> > > > I'd like to propose and have a discussion about the following new
>> > > > functionality:
>> > > >
>> > > > 1. Filesystems develop a native representation of badblocks. For
>> > > > example, in xfs, this would (presumably) be linked to the reverse
>> > > > mapping btree. The filesystem representation has the potential to be
>> > > > more efficient than the block driver doing the check, as the fs can
>> > > > check the IO happening on a file against just that file's range.
>>
>> OTOH that means we'd have to check /every/ file IO request against the
>> rmapbt, which will make things reaaaaaally slow.  I suspect it might be
>> preferable just to let the underlying pmem driver throw an error at us.
>>
>> (Or possibly just cache the bad extents in memory.)
>
> Interesting - this would be a good discussion to have. My motivation for
> this was the reasoning that the pmem driver has to check every single IO
> against badblocks, and maybe the fs can do a better job. But if you
> think the fs will actually be slower, we should try to somehow benchmark
> that!
>
>>
>> > > What do you mean by "file system can check the IO happening on a file"?
>> > > Do you mean read or write operation? What's about metadata?
>> >
>> > For the purpose described above, i.e. returning early EIOs when
>> > possible, this will be limited to reads and metadata reads. If we're
>> > about to do a metadata read, and realize the block(s) about to be read
>> > are on the badblocks list, then we do the same thing as when we discover
>> > other kinds of metadata corruption.
>>
>> ...fail and shut down? :)
>>
>> Actually, for metadata either we look at the xfs_bufs to see if it's in
>> memory (XFS doesn't directly access metadata) and write it back out; or
>> we could fire up the online repair tool to rebuild the metadata.
>
> Agreed, I was just stressing that this scenario does not change from
> status quo, and really recovering from corruption isn't the problem
> we're trying to solve here :)
>
>>
>> > > If we are talking about the discovering a bad block on read operation then
>> > > rare modern file system is able to survive as for the case of metadata as
>> > > for the case of user data. Let's imagine that we have really mature file
>> > > system driver then what does it mean to encounter a bad block? The failure
>> > > to read a logical block of some metadata (bad block) means that we are
>> > > unable to extract some part of a metadata structure. From file system
>> > > driver point of view, it looks like that our file system is corrupted, we need
>> > > to stop the file system operations and, finally, to check and recover file
>> > > system volume by means of fsck tool. If we find a bad block for some
>> > > user file then, again, it looks like an issue. Some file systems simply
>> > > return "unrecovered read error". Another one, theoretically, is able
>> > > to survive because of snapshots, for example. But, anyway, it will look
>> > > like as Read-Only mount state and the user will need to resolve such
>> > > trouble by hands.
>> >
>> > As far as I can tell, all of these things remain the same. The goal here
>> > isn't to survive more NVM badblocks than we would've before, and lost
>> > data or lost metadata will continue to have the same consequences as
>> > before, and will need the same recovery actions/intervention as before.
>> > The goal is to make the failure model similar to what users expect
>> > today, and as much as possible make recovery actions too similarly
>> > intuitive.
>> >
>> > >
>> > > If we are talking about discovering a bad block during write operation then,
>> > > again, we are in trouble. Usually, we are using asynchronous model
>> > > of write/flush operation. We are preparing the consistent state of all our
>> > > metadata structures in the memory, at first. The flush operations for metadata
>> > > and user data can be done in different times. And what should be done if we
>> > > discover bad block for any piece of metadata or user data? Simple tracking of
>> > > bad blocks is not enough at all. Let's consider user data, at first. If we cannot
>> > > write some file's block successfully then we have two ways: (1) forget about
>> > > this piece of data; (2) try to change the associated LBA for this piece of data.
>> > > The operation of re-allocation LBA number for discovered bad block
>> > > (user data case) sounds as real pain. Because you need to rebuild the metadata
>> > > that track the location of this part of file. And it sounds as practically
>> > > impossible operation, for the case of LFS file system, for example.
>> > > If we have trouble with flushing any part of metadata then it sounds as
>> > > complete disaster for any file system.
>> >
>> > Writes can get more complicated in certain cases. If it is a regular
>> > page cache writeback, or any aligned write that goes through the block
>> > driver, that is completely fine. The block driver will check that the
>> > block was previously marked as bad, do a "clear poison" operation
>> > (defined in the ACPI spec), which tells the firmware that the poison bit
>> > is not OK to be cleared, and writes the new data. This also removes the
>> > block from the badblocks list, and in this scheme, triggers a
>> > notification to the filesystem that it too can remove the block from its
>> > accounting. mmap writes and DAX can get more complicated, and at times
>> > they will just trigger a SIGBUS, and there's no way around that.
>> >
>> > >
>> > > Are you really sure that file system should process bad block issue?
>> > >
>> > > >In contrast, today, the block driver checks against the whole block device
>> > > > range for every IO. On encountering badblocks, the filesystem can
>> > > > generate a better notification/error message that points the user to
>> > > > (file, offset) as opposed to the block driver, which can only provide
>> > > > (block-device, sector).
>>
>> <shrug> We can do the translation with the backref info...
>
> Yes we should at least do that. I'm guessing this would happen in XFS
> when it gets an EIO from an IO submission? The bio submission path in
> the fs is probably not synchronous (correct?), but whenever it gets the
> EIO, I'm guessing we just print a loud error message after doing the
> backref lookup..
>
>>
>> > > > 2. The block layer adds a notifier to badblock addition/removal
>> > > > operations, which the filesystem subscribes to, and uses to maintain its
>> > > > badblocks accounting. (This part is implemented as a proof of concept in
>> > > > the RFC mentioned above [1]).
>> > >
>> > > I am not sure that any bad block notification during/after IO operation
>> > > is valuable for file system. Maybe, it could help if file system simply will
>> > > know about bad block beforehand the operation of logical block allocation.
>> > > But what subsystem will discover bad blocks before any IO operations?
>> > > How file system will receive information or some bad block table?
>> >
>> > The driver populates its badblocks lists whenever an Address Range Scrub
>> > is started (also via ACPI methods). This is always done at
>> > initialization time, so that it can build an in-memory representation of
>> > the badblocks. Additionally, this can also be triggered manually. And
>> > finally badblocks can also get populated for new latent errors when a
>> > machine check exception occurs. All of these can trigger notification to
>> > the file system without actual user reads happening.
>> >
>> > > I am not convinced that suggested badblocks approach is really feasible.
>> > > Also I am not sure that file system should see the bad blocks at all.
>> > > Why hardware cannot manage this issue for us?
>> >
>> > Hardware does manage the actual badblocks issue for us in the sense that
>> > when it discovers a badblock it will do the remapping. But since this is
>> > on the memory bus, and has different error signatures than applications
>> > are used to, we want to make the error handling similar to the existing
>> > storage model.
>>
>> Yes please and thank you, to the "error handling similar to the existing
>> storage model".  Even better if this just gets added to a layer
>> underneath the fs so that IO to bad regions returns EIO. 8-)
>
> This (if this just gets added to a layer underneath the fs so that IO to bad
> regions returns EIO) already happens :)  See pmem_do_bvec() in
> drivers/nvdimm/pmem.c, where we return EIO for a known badblock on a
> read. I'm wondering if this can be improved..
>

The pmem_do_bvec() read logic is like this:

pmem_do_bvec()
    if (is_bad_pmem())
        return -EIO;
    else
        memcpy_from_pmem();

Note memcpy_from_pmem() is calling memcpy_mcsafe(). Does this imply
that even if a block is not in the badblock list, it still can be bad
and causes MCE? Does the badblock list get changed during file system
running? If that is the case, should the file system get a
notification when it gets changed? If a block is good when I first
read it, can I still trust it to be good for the second access?

Thanks,
Andiry

>>
>> (Sleeeeep...)
>>
>> --D
>>
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
