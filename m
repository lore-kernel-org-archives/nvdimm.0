Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABE3F81DF4
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 06:37:09 -0800 (PST)
Date: Tue, 17 Jan 2017 15:37:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Message-ID: <20170117143703.GP2517@quack2.suse.cz>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
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
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 16-01-17 02:27:52, Slava Dubeyko wrote:
> 
> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com] 
> Sent: Friday, January 13, 2017 4:49 PM
> To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
> Cc: lsf-pc@lists.linux-foundation.org; linux-nvdimm@lists.01.org; linux-block@vger.kernel.org; Linux FS Devel <linux-fsdevel@vger.kernel.org>; Viacheslav Dubeyko <slava@dubeyko.com>
> Subject: Re: [LSF/MM TOPIC] Badblocks checking/representation in filesystems
> 
> <skipped>
> 
> > We don't have direct physical access to the device's address space, in the sense
> > the device is still free to perform remapping of chunks of NVM underneath us.
> > The problem is that when a block or address range (as small as a cache line) goes bad,
> > the device maintains a poison bit for every affected cache line. Behind the scenes,
> > it may have already remapped the range, but the cache line poison has to be kept so that
> > there is a notification to the user/owner of the data that something has been lost.
> > Since NVM is byte addressable memory sitting on the memory bus, such a poisoned
> > cache line results in memory errors and SIGBUSes.
> > Compared to tradational storage where an app will get nice and friendly (relatively speaking..) -EIOs.
> > The whole badblocks implementation was done so that the driver can intercept IO (i.e. reads)
> > to _known_ bad locations, and short-circuit them with an EIO. If the driver doesn't catch these,
> > the reads will turn into a memory bus access, and the poison will cause a SIGBUS.
> >
> > This effort is to try and make this badblock checking smarter - and try and reduce the penalty
> > on every IO to a smaller range, which only the filesystem can do.
> 
> I still slightly puzzled and I cannot understand why the situation looks
> like a dead end.  As far as I can see, first of all, a NVM device is able
> to use hardware-based LDPC, Reed-Solomon error correction or any other
> fancy code. It could provide some error correction basis. Also it can
> provide the way of estimation of BER value. So, if a NVM memory's address
> range degrades gradually (during weeks or months) then, practically, it's
> possible to remap and to migrate the affected address ranges in the
> background. Otherwise, if a NVM memory so unreliable that address range
> is able to degrade during seconds or minutes then who will use such NVM
> memory?

Well, the situation with NVM is more like with DRAM AFAIU. It is quite
reliable but given the size the probability *some* cell has degraded is
quite high. And similar to DRAM you'll get MCE (Machine Check Exception)
when you try to read such cell. As Vishal wrote, the hardware does some
background scrubbing and relocates stuff early if needed but nothing is 100%.

The reason why we play games with badblocks is to avoid those MCEs (i.e.,
even trying to read the data we know that are bad). Even if it would be
rare event, MCE may mean the machine just immediately reboots (although I
find such platforms hardly usable with NVM then) and that is no good. And
even on hardware platforms that allow for more graceful recovery from MCE
it is asynchronous in its nature and our error handling
around IO is all synchronous so it is difficult to join these two models
together.

But I think it is a good question to ask whether we cannot improve on MCE
handling instead of trying to avoid them and pushing around responsibility
for handling bad blocks. Actually I thought someone was working on that.
Cannot we e.g. wrap in-kernel accesses to persistent memory (those are now
well identified anyway so that we can consult the badblocks list) so that
it MCE happens during these accesses, we note it somewhere and at the end
of the magic block we will just pick up the errors and report them back?

> OK. Let's imagine that NVM memory device hasn't any internal error
> correction hardware-based scheme. Next level of defense could be any
> erasure coding scheme on device driver level. So, any piece of data can
> be protected by parities. And device driver will be responsible for
> management of erasure coding scheme. It will increase latency of read
> operation for the case of necessity to recover the affected memory page.
> But, finally, all recovering activity will be behind the scene and file
> system will be unaware about such recovering activity.

Note that your options are limited by the byte addressability and the
direct CPU access to the memory. But even with these limitations it is not
that error rate would but unusually high, it is just not zero.
 
> If you are going not to provide any erasure coding or error correction
> scheme then it's really bad case. The fsck tool is not regular case tool
> but the last resort. If you are going to rely on the fsck tool then
> simply forget about using your hardware. Some file systems haven't the
> fsck tool at all. Some guys really believe that file system has to work
> without support of the fsck tool.  Even if a mature file system has
> reliable fsck tool then the probability of file system recovering is very
> low in the case of serious metadata corruptions. So, it means that you
> are trying to suggest the technique when we will lose the whole file
> system volumes on regular basis without any hope to recover data. Even if
> file system has snapshots then, again, we haven't hope because we can
> suffer from read error and for operation with snapshot.

I hope I have cleared out that this is not about higher error rate of
persistent memory above. As a side note, XFS guys are working on automatic
background scrubbing and online filesystem checking. Not specifically for
persistent memory but simply because with growing size of the filesystem
the likelihood of some problem somewhere is growing. 
 
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
