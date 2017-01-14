Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E88BA81BC9
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jan 2017 16:50:17 -0800 (PST)
Date: Fri, 13 Jan 2017 17:49:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
Message-ID: <20170114004910.GA4880@omniknight.lm.intel.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Viacheslav Dubeyko <slava@dubeyko.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 01/14, Slava Dubeyko wrote:
> =

> ---- Original Message ----
> Subject: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
> Sent: Jan 13, 2017 1:40 PM
> From: "Verma, Vishal L" <vishal.l.verma@intel.com>
> To: lsf-pc@lists.linux-foundation.org
> Cc: linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-fsdevel=
@vger.kernel.org
> =

> > The current implementation of badblocks, where we consult the badblocks
> > list for every IO in the block driver works, and is a last option
> > failsafe, but from a user perspective, it isn't the easiest interface to
> > work with.
> =

> As I remember, FAT and HFS+ specifications contain description of bad blo=
cks
> (physical sectors) table. I believe that this table was used for the case=
 of
> floppy media. But, finally, this table becomes to be the completely obsol=
ete
> artefact because mostly storage devices are reliably enough. Why do you n=
eed
> in exposing the bad blocks on the file system level?  Do you expect that =
next
> generation of NVM memory will be so unreliable that file system needs to =
manage
> bad blocks? What's about erasure coding schemes? Do file system really ne=
ed to suffer
> from the bad block issue? =

> =

> Usually, we are using LBAs and it is the responsibility of storage device=
 to map
> a bad physical block/page/sector into valid one. Do you mean that we have
> access to physical NVM memory address directly? But it looks like that we=
 can
> have a "bad block" issue even we will access data into page cache's memory
> page (if we will use NVM memory for page cache, of course). So, what do y=
ou
> imply by "bad block" issue? =


We don't have direct physical access to the device's address space, in
the sense the device is still free to perform remapping of chunks of NVM
underneath us. The problem is that when a block or address range (as
small as a cache line) goes bad, the device maintains a poison bit for
every affected cache line. Behind the scenes, it may have already
remapped the range, but the cache line poison has to be kept so that
there is a notification to the user/owner of the data that something has
been lost. Since NVM is byte addressable memory sitting on the memory
bus, such a poisoned cache line results in memory errors and SIGBUSes.
Compared to tradational storage where an app will get nice and friendly
(relatively speaking..) -EIOs. The whole badblocks implementation was
done so that the driver can intercept IO (i.e. reads) to _known_ bad
locations, and short-circuit them with an EIO. If the driver doesn't
catch these, the reads will turn into a memory bus access, and the
poison will cause a SIGBUS.

This effort is to try and make this badblock checking smarter - and try
and reduce the penalty on every IO to a smaller range, which only the
filesystem can do.

> =

> > =

> > A while back, Dave Chinner had suggested a move towards smarter
> > handling, and I posted initial RFC patches [1], but since then the topic
> > hasn't really moved forward.
> > =

> > I'd like to propose and have a discussion about the following new
> > functionality:
> > =

> > 1. Filesystems develop a native representation of badblocks. For
> > example, in xfs, this would (presumably) be linked to the reverse
> > mapping btree. The filesystem representation has the potential to be=A0
> > more efficient than the block driver doing the check, as the fs can
> > check the IO happening on a file against just that file's range. =

> =

> What do you mean by "file system can check the IO happening on a file"?
> Do you mean read or write operation? What's about metadata?

For the purpose described above, i.e. returning early EIOs when
possible, this will be limited to reads and metadata reads. If we're
about to do a metadata read, and realize the block(s) about to be read
are on the badblocks list, then we do the same thing as when we discover
other kinds of metadata corruption.

> =

> If we are talking about the discovering a bad block on read operation then
> rare modern file system is able to survive as for the case of metadata as
> for the case of user data. Let's imagine that we have really mature file
> system driver then what does it mean to encounter a bad block? The failure
> to read a logical block of some metadata (bad block) means that we are
> unable to extract some part of a metadata structure. From file system
> driver point of view, it looks like that our file system is corrupted, we=
 need
> to stop the file system operations and, finally, to check and recover file
> system volume by means of fsck tool. If we find a bad block for some
> user file then, again, it looks like an issue. Some file systems simply
> return "unrecovered read error". Another one, theoretically, is able
> to survive because of snapshots, for example. But, anyway, it will look
> like as Read-Only mount state and the user will need to resolve such
> trouble by hands.

As far as I can tell, all of these things remain the same. The goal here
isn't to survive more NVM badblocks than we would've before, and lost
data or lost metadata will continue to have the same consequences as
before, and will need the same recovery actions/intervention as before.
The goal is to make the failure model similar to what users expect
today, and as much as possible make recovery actions too similarly
intuitive.

> =

> If we are talking about discovering a bad block during write operation th=
en,
> again, we are in trouble. Usually, we are using asynchronous model
> of write/flush operation. We are preparing the consistent state of all our
> metadata structures in the memory, at first. The flush operations for met=
adata
> and user data can be done in different times. And what should be done if =
we
> discover bad block for any piece of metadata or user data? Simple trackin=
g of
> bad blocks is not enough at all. Let's consider user data, at first. If w=
e cannot
> write some file's block successfully then we have two ways: (1) forget ab=
out
> this piece of data; (2) try to change the associated LBA for this piece o=
f data.
> The operation of re-allocation LBA number for discovered bad block
> (user data case) sounds as real pain. Because you need to rebuild the met=
adata
> that track the location of this part of file. And it sounds as practically
> impossible operation, for the case of LFS file system, for example.
> If we have trouble with flushing any part of metadata then it sounds as
> complete disaster for any file system.

Writes can get more complicated in certain cases. If it is a regular
page cache writeback, or any aligned write that goes through the block
driver, that is completely fine. The block driver will check that the
block was previously marked as bad, do a "clear poison" operation
(defined in the ACPI spec), which tells the firmware that the poison bit
is not OK to be cleared, and writes the new data. This also removes the
block from the badblocks list, and in this scheme, triggers a
notification to the filesystem that it too can remove the block from its
accounting. mmap writes and DAX can get more complicated, and at times
they will just trigger a SIGBUS, and there's no way around that.

> =

> Are you really sure that file system should process bad block issue?
> =

> >In contrast, today, the block driver checks against the whole block devi=
ce
> > range for every IO. On encountering badblocks, the filesystem can
> > generate a better notification/error message that points the user to=A0
> > (file, offset) as opposed to the block driver, which can only provide
> > (block-device, sector).
> >
> > 2. The block layer adds a notifier to badblock addition/removal
> > operations, which the filesystem subscribes to, and uses to maintain its
> > badblocks accounting. (This part is implemented as a proof of concept in
> > the RFC mentioned above [1]).
> =

> I am not sure that any bad block notification during/after IO operation
> is valuable for file system. Maybe, it could help if file system simply w=
ill
> know about bad block beforehand the operation of logical block allocation.
> But what subsystem will discover bad blocks before any IO operations?
> How file system will receive information or some bad block table?

The driver populates its badblocks lists whenever an Address Range Scrub
is started (also via ACPI methods). This is always done at
initialization time, so that it can build an in-memory representation of
the badblocks. Additionally, this can also be triggered manually. And
finally badblocks can also get populated for new latent errors when a
machine check exception occurs. All of these can trigger notification to
the file system without actual user reads happening.

> I am not convinced that suggested badblocks approach is really feasible.
> Also I am not sure that file system should see the bad blocks at all.
> Why hardware cannot manage this issue for us?

Hardware does manage the actual badblocks issue for us in the sense that
when it discovers a badblock it will do the remapping. But since this is
on the memory bus, and has different error signatures than applications
are used to, we want to make the error handling similar to the existing
storage model.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
