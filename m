Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0674F81DF8
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jan 2017 15:15:25 -0800 (PST)
From: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Subject: RE: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Date: Tue, 17 Jan 2017 23:15:17 +0000
Message-ID: <SN2PR04MB219128E4C8C4FD4AF3452C7C887C0@SN2PR04MB2191.namprd04.prod.outlook.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170117143703.GP2517@quack2.suse.cz>
In-Reply-To: <20170117143703.GP2517@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


-----Original Message-----
From: Jan Kara [mailto:jack@suse.cz] 
Sent: Tuesday, January 17, 2017 6:37 AM
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>; linux-block@vger.kernel.org; Linux FS Devel <linux-fsdevel@vger.kernel.org>; lsf-pc@lists.linux-foundation.org; Viacheslav Dubeyko <slava@dubeyko.com>; linux-nvdimm@lists.01.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in filesystems

> > > We don't have direct physical access to the device's address space, 
> > > in the sense the device is still free to perform remapping of chunks of NVM underneath us.
> > > The problem is that when a block or address range (as small as a 
> > > cache line) goes bad, the device maintains a poison bit for every 
> > > affected cache line. Behind the scenes, it may have already remapped 
> > > the range, but the cache line poison has to be kept so that there is a notification to the user/owner of the data that something has been lost.
> > > Since NVM is byte addressable memory sitting on the memory bus, such 
> > > a poisoned cache line results in memory errors and SIGBUSes.
> > > Compared to tradational storage where an app will get nice and friendly (relatively speaking..) -EIOs.
> > > The whole badblocks implementation was done so that the driver can 
> > > intercept IO (i.e. reads) to _known_ bad locations, and 
> > > short-circuit them with an EIO. If the driver doesn't catch these, the reads will turn into a memory bus access, and the poison will cause a SIGBUS.
> > >
> > > This effort is to try and make this badblock checking smarter - and 
> > > try and reduce the penalty on every IO to a smaller range, which only the filesystem can do.

> Well, the situation with NVM is more like with DRAM AFAIU. It is quite reliable
> but given the size the probability *some* cell has degraded is quite high.
> And similar to DRAM you'll get MCE (Machine Check Exception) when you try
> to read such cell. As Vishal wrote, the hardware does some background scrubbing
> and relocates stuff early if needed but nothing is 100%.

My understanding that hardware does the remapping the affected address
range (64 bytes, for example) but it doesn't move/migrate the stored data in this address
range. So, it sounds slightly weird. Because it means that no guarantee to retrieve the stored
data. It sounds that file system should be aware about this and has to be heavily protected
by some replication or erasure coding scheme. Otherwise, if the hardware does everything for us
(remap the affected address region and move data into a new address region) then why
does file system need to know about the affected address regions?

> The reason why we play games with badblocks is to avoid those MCEs
> (i.e., even trying to read the data we know that are bad). Even if it would
> be rare event, MCE may mean the machine just immediately reboots
> (although I find such platforms hardly usable with NVM then) and that
> is no good. And even on hardware platforms that allow for more graceful
> recovery from MCE it is asynchronous in its nature and our error handling
> around IO is all synchronous so it is difficult to join these two models together.
>
> But I think it is a good question to ask whether we cannot improve on MCE handling
> instead of trying to avoid them and pushing around responsibility for handling
> bad blocks. Actually I thought someone was working on that.
> Cannot we e.g. wrap in-kernel accesses to persistent memory (those are now
> well identified anyway so that we can consult the badblocks list) so that it MCE
> happens during these accesses, we note it somewhere and at the end of the magic
> block we will just pick up the errors and report them back?

Let's imagine that the affected address range will equal to 64 bytes. It sounds for me
that for the case of block device it will affect the whole logical block (4 KB). If the failure
rate of address ranges could be significant then it would affect a lot of logical blocks.
It looks like a complete nightmare for the file system. Especially, if we discover such
issue on the read operation. Again, LBA means logical block address. It sounds for me
that this guy should be valid always. Otherwise, we crash the whole concept.

The situation is more critical for the case of DAX approach. Correct me if I wrong but
my understanding is the goal of DAX is to provide the direct access to file's memory
pages with minimal file system overhead. So, it looks like that raising bad block issue
on file system level will affect a user-space application. Because, finally, user-space
application will need to process such trouble (bad block issue). It sounds for me as really
weird situation. What can protect a user-space application from encountering the issue
with partially incorrect memory page?

> > OK. Let's imagine that NVM memory device hasn't any internal error 
> > correction hardware-based scheme. Next level of defense could be any 
> > erasure coding scheme on device driver level. So, any piece of data 
> > can be protected by parities. And device driver will be responsible 
> > for management of erasure coding scheme. It will increase latency of 
> > read operation for the case of necessity to recover the affected memory page.
> > But, finally, all recovering activity will be behind the scene and 
> > file system will be unaware about such recovering activity.
>
> Note that your options are limited by the byte addressability and
> the direct CPU access to the memory. But even with these limitations
> it is not that error rate would but unusually high, it is just not zero.
 
Even for the case of byte addressability, I cannot see any troubles
with using some error correction or erasure coding schemes
inside of the memory chip. Especially, for the rare case of such issue
the latency of device operations will be pretty OK.

> > If you are going not to provide any erasure coding or error correction 
> > scheme then it's really bad case. The fsck tool is not regular case 
> > tool but the last resort. If you are going to rely on the fsck tool 
> > then simply forget about using your hardware. Some file systems 
> > haven't the fsck tool at all. Some guys really believe that file 
> > system has to work without support of the fsck tool.  Even if a mature 
> > file system has reliable fsck tool then the probability of file system 
> > recovering is very low in the case of serious metadata corruptions. 
> > So, it means that you are trying to suggest the technique when we will 
> > lose the whole file system volumes on regular basis without any hope 
> > to recover data. Even if file system has snapshots then, again, we 
> > haven't hope because we can suffer from read error and for operation with snapshot.
>
> I hope I have cleared out that this is not about higher error rate
> of persistent memory above. As a side note, XFS guys are working on automatic
> background scrubbing and online filesystem checking. Not specifically for persistent
> memory but simply because with growing size of the filesystem the likelihood of
> some problem somewhere is growing. 
 
I see your point but even for low error rate you cannot predict what logical
block can be affected by such issue. Even the online file system checking subsystem
cannot prevent from file system corruption. Because, for example, if you find
during a read operation that your btree's root node is corrupted then you
can lose the whole btree.

Thanks,
Vyacheslav Dubeyko.
 
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
