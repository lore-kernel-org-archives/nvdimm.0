Return-Path: <linux-nvdimm-bounces@lists.01.org>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170117143703.GP2517@quack2.suse.cz>
 <SN2PR04MB219128E4C8C4FD4AF3452C7C887C0@SN2PR04MB2191.namprd04.prod.outlook.com>
Date: Wed, 18 Jan 2017 15:47:37 -0500
In-Reply-To: <SN2PR04MB219128E4C8C4FD4AF3452C7C887C0@SN2PR04MB2191.namprd04.prod.outlook.com>
 (Slava Dubeyko's message of "Tue, 17 Jan 2017 23:15:17 +0000")
Message-ID: <x49mveo6qom.fsf@segfault.boston.devel.redhat.com>
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
To: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com> writes:

>> Well, the situation with NVM is more like with DRAM AFAIU. It is quite reliable
>> but given the size the probability *some* cell has degraded is quite high.
>> And similar to DRAM you'll get MCE (Machine Check Exception) when you try
>> to read such cell. As Vishal wrote, the hardware does some background scrubbing
>> and relocates stuff early if needed but nothing is 100%.
>
> My understanding that hardware does the remapping the affected address
> range (64 bytes, for example) but it doesn't move/migrate the stored
> data in this address range. So, it sounds slightly weird. Because it
> means that no guarantee to retrieve the stored data. It sounds that
> file system should be aware about this and has to be heavily protected
> by some replication or erasure coding scheme. Otherwise, if the
> hardware does everything for us (remap the affected address region and
> move data into a new address region) then why does file system need to
> know about the affected address regions?

The data is lost, that's why you're getting an ECC.  It's tantamount to
-EIO for a disk block access.

>> The reason why we play games with badblocks is to avoid those MCEs
>> (i.e., even trying to read the data we know that are bad). Even if it would
>> be rare event, MCE may mean the machine just immediately reboots
>> (although I find such platforms hardly usable with NVM then) and that
>> is no good. And even on hardware platforms that allow for more graceful
>> recovery from MCE it is asynchronous in its nature and our error handling
>> around IO is all synchronous so it is difficult to join these two models together.
>>
>> But I think it is a good question to ask whether we cannot improve on MCE handling
>> instead of trying to avoid them and pushing around responsibility for handling
>> bad blocks. Actually I thought someone was working on that.
>> Cannot we e.g. wrap in-kernel accesses to persistent memory (those are now
>> well identified anyway so that we can consult the badblocks list) so that it MCE
>> happens during these accesses, we note it somewhere and at the end of the magic
>> block we will just pick up the errors and report them back?
>
> Let's imagine that the affected address range will equal to 64 bytes. It sounds for me
> that for the case of block device it will affect the whole logical
> block (4 KB).

512 bytes, and yes, that's the granularity at which we track errors in
the block layer, so that's the minimum amount of data you lose.

> If the failure rate of address ranges could be significant then it
> would affect a lot of logical blocks.

Who would buy hardware like that?

> The situation is more critical for the case of DAX approach. Correct
> me if I wrong but my understanding is the goal of DAX is to provide
> the direct access to file's memory pages with minimal file system
> overhead. So, it looks like that raising bad block issue on file
> system level will affect a user-space application. Because, finally,
> user-space application will need to process such trouble (bad block
> issue). It sounds for me as really weird situation. What can protect a
> user-space application from encountering the issue with partially
> incorrect memory page?

Applications need to deal with -EIO today.  This is the same sort of
thing.  If an application trips over a bad block during a load from
persistent memory, they will get a signal, and they can either handle it
or not.

Have a read through this specification and see if it clears anything up
for you:
  http://www.snia.org/tech_activities/standards/curr_standards/npm

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
