Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8278381D62
 for <linux-nvdimm@lists.01.org>; Sun, 15 Jan 2017 18:27:56 -0800 (PST)
From: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Subject: RE: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
Date: Mon, 16 Jan 2017 02:27:52 +0000
Message-ID: <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
In-Reply-To: <20170114004910.GA4880@omniknight.lm.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Viacheslav Dubeyko <slava@dubeyko.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


-----Original Message-----
From: Vishal Verma [mailto:vishal.l.verma@intel.com] 
Sent: Friday, January 13, 2017 4:49 PM
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: lsf-pc@lists.linux-foundation.org; linux-nvdimm@lists.01.org; linux-block@vger.kernel.org; Linux FS Devel <linux-fsdevel@vger.kernel.org>; Viacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems

<skipped>

> We don't have direct physical access to the device's address space, in the sense
> the device is still free to perform remapping of chunks of NVM underneath us.
> The problem is that when a block or address range (as small as a cache line) goes bad,
> the device maintains a poison bit for every affected cache line. Behind the scenes,
> it may have already remapped the range, but the cache line poison has to be kept so that
> there is a notification to the user/owner of the data that something has been lost.
> Since NVM is byte addressable memory sitting on the memory bus, such a poisoned
> cache line results in memory errors and SIGBUSes.
> Compared to tradational storage where an app will get nice and friendly (relatively speaking..) -EIOs.
> The whole badblocks implementation was done so that the driver can intercept IO (i.e. reads)
> to _known_ bad locations, and short-circuit them with an EIO. If the driver doesn't catch these,
> the reads will turn into a memory bus access, and the poison will cause a SIGBUS.
>
> This effort is to try and make this badblock checking smarter - and try and reduce the penalty
> on every IO to a smaller range, which only the filesystem can do.

I still slightly puzzled and I cannot understand why the situation looks like a dead end.
As far as I can see, first of all, a NVM device is able to use hardware-based LDPC,
Reed-Solomon error correction or any other fancy code. It could provide some error
correction basis. Also it can provide the way of estimation of BER value. So, if a NVM memory's
address range degrades gradually (during weeks or months) then, practically, it's possible
to remap and to migrate the affected address ranges in the background. Otherwise,
if a NVM memory so unreliable that address range is able to degrade during seconds or minutes
then who will use such NVM memory?

OK. Let's imagine that NVM memory device hasn't any internal error correction hardware-based
scheme. Next level of defense could be any erasure coding scheme on device driver level. So, any
piece of data can be protected by parities. And device driver will be responsible for management
of erasure coding scheme. It will increase latency of read operation for the case of necessity
to recover the affected memory page. But, finally, all recovering activity will be behind the scene
and file system will be unaware about such recovering activity.

If you are going not to provide any erasure coding or error correction scheme then it's really
bad case. The fsck tool is not regular case tool but the last resort. If you are going to rely on
the fsck tool then simply forget about using your hardware. Some file systems haven't the fsck
tool at all. Some guys really believe that file system has to work without support of the fsck tool.
Even if a mature file system has reliable fsck tool then the probability of file system recovering
is very low in the case of serious metadata corruptions. So, it means that you are trying to suggest
the technique when we will lose the whole file system volumes on regular basis without any hope
to recover data. Even if file system has snapshots then, again, we haven't hope because we can
suffer from read error and for operation with snapshot.

But if we will have support of any erasure coding scheme and NVM device discovers poisoned
cache line for some memory page then, I suppose, that such situation could looks like as page fault
and memory subsystem will need to re-read the page with background recovery of memory page's
content.

It sounds for me that we simply have some poorly designed hardware. And it is impossible
to push such issue on file system level. I believe that such issue can be managed by block
device or DAX subsystem in the presence of any erasure coding scheme. Otherwise, no
file system is able to survive in such wild environment. Because, I assume that any file
system volume will be in unrecoverable state in 50% (or significantly more) cases of bad block
discovering. Because any affection of metadata block can be resulted in severely inconsistent
state of file system's metadata structures. And it's very non-trivial task to recover the consistent
state of file system's metadata structures in the case of losing some part of it.

> > > 
> > > A while back, Dave Chinner had suggested a move towards smarter 
> > > handling, and I posted initial RFC patches [1], but since then the 
> > > topic hasn't really moved forward.
> > > 
> > > I'd like to propose and have a discussion about the following new
> > > functionality:
> > > 
> > > 1. Filesystems develop a native representation of badblocks. For 
> > > example, in xfs, this would (presumably) be linked to the reverse 
> > > mapping btree. The filesystem representation has the potential to be 
> > > more efficient than the block driver doing the check, as the fs can 
> > > check the IO happening on a file against just that file's range.
> > 
> > What do you mean by "file system can check the IO happening on a file"?
> > Do you mean read or write operation? What's about metadata?
>
> For the purpose described above, i.e. returning early EIOs when possible,
> this will be limited to reads and metadata reads. If we're about to do a metadata
> read, and realize the block(s) about to be read are on the badblocks list, then
> we do the same thing as when we discover other kinds of metadata corruption.

Frankly speaking, I cannot follow how badblock list is able to help the file system
driver to survive. Every time when file system driver encounters the bad block
presence then it stops the activity with: (1) unrecovered read error; (2) remount
in RO mode; (3) simple crash. It means that it needs to unmount a file system volume
(if driver hasn't crashed) and to run fsck tool. So, file system driver cannot gain
from tracking bad blocks in the special list because, mostly, it will stop the regular
operation in the case of access the bad block. Even if the file system driver extracts
the badblock list from some low-level driver then what can be done by file system
driver? Let's imagine that file system driver knows that LBA#N is bad then the best
behavior will be simply panic or remount in RO state, nothing more.

<skipped>

> As far as I can tell, all of these things remain the same. The goal here isn't to survive
> more NVM badblocks than we would've before, and lost data or
> lost metadata will continue to have the same consequences as before, and
> will need the same recovery actions/intervention as before.
> The goal is to make the failure model similar to what users expect
> today, and as much as possible make recovery actions too similarly intuitive.

OK. Nowadays, user expects that hardware is reliably enough. It's the same
situation like for NAND flash. NAND flash can have bad erase blocks. But FTL
hides this reality from a file system. Otherwise, file system should be
NAND flash oriented and to be able to manage bad erase blocks presence.
Your suggestion will increase probability of unrecoverable state of file
system volume dramatically. So, it's hard to see the point for such approach.

> Writes can get more complicated in certain cases. If it is a regular page cache
> writeback, or any aligned write that goes through the block driver, that is completely
> fine. The block driver will check that the block was previously marked as bad,
> do a "clear poison" operation (defined in the ACPI spec), which tells the firmware that
> the poison bit is not OK to be cleared, and writes the new data. This also removes
> the block from the badblocks list, and in this scheme, triggers a notification to
> the filesystem that it too can remove the block from its accounting.
> mmap writes and DAX can get more complicated, and at times they will just
>trigger a SIGBUS, and there's no way around that.

If page cache writeback finishes with writing data in valid location then
no troubles here at all. But I assume that critical point will on the read path.
Because, we still will have the same troubles as I mentioned above.

<skipped>

> Hardware does manage the actual badblocks issue for us
> in the sense that when it discovers a badblock it will do the remapping.
> But since this is on the memory bus, and has different error signatures
> than applications are used to, we want to make the error handling
> similar to the existing storage model.

So, if hardware is able to do the remapping of bad portions of memory page
then it is possible to see the valid logical page always. The key point here
that hardware controller should manage migration of data from aged/pre-bad
NVM memory ranges into valid ones. Or it needs to use some fancy
error-correction techniques or erasure coding schemes.

Thanks,
Vyacheslav Dubeyko.

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
