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
 <x49mveo6qom.fsf@segfault.boston.devel.redhat.com>
 <SN2PR04MB21916B138434803EA9AF4C18887E0@SN2PR04MB2191.namprd04.prod.outlook.com>
Date: Thu, 19 Jan 2017 14:33:45 -0500
In-Reply-To: <SN2PR04MB21916B138434803EA9AF4C18887E0@SN2PR04MB2191.namprd04.prod.outlook.com>
 (Slava Dubeyko's message of "Thu, 19 Jan 2017 02:56:39 +0000")
Message-ID: <x4937gergiu.fsf@segfault.boston.devel.redhat.com>
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

Hi, Slava,

Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com> writes:

>>The data is lost, that's why you're getting an ECC.  It's tantamount
>>to -EIO for a disk block access.
>
> I see the three possible cases here:
> (1) bad block has been discovered (no remap, no recovering) -> data is
>> lost; -EIO for a disk block access, block is always bad;

This is, of course, a possiblity.  In that case, attempts to clear the
error will not succeed.

> (2) bad block has been discovered and remapped -> data is lost; -EIO
> for a disk block access.

Right, and the error is cleared when new data is provided (i.e. through
a write system call or fallocate).

> (3) bad block has been discovered, remapped and recovered -> no data is lost.

This is transparent to the OS and the application.

>>> Let's imagine that the affected address range will equal to 64 bytes. 
>>> It sounds for me that for the case of block device it will affect the 
>>> whole logical block (4 KB).
>>
>> 512 bytes, and yes, that's the granularity at which we track errors
>> in the block layer, so that's the minimum amount of data you lose.
>
> I think it depends what granularity hardware supports. It could be 512
> bytes, 4 KB, maybe greater.

Of course, though I expect the ECC protection in the NVDIMMs to cover a
range much smaller than a page.

>>> The situation is more critical for the case of DAX approach. Correct 
>>> me if I wrong but my understanding is the goal of DAX is to provide 
>>> the direct access to file's memory pages with minimal file system 
>>> overhead. So, it looks like that raising bad block issue on file 
>>> system level will affect a user-space application. Because, finally, 
>>> user-space application will need to process such trouble (bad block 
>>> issue). It sounds for me as really weird situation. What can protect a 
>>> user-space application from encountering the issue with partially 
>>> incorrect memory page?
>>
>> Applications need to deal with -EIO today.  This is the same sort of thing.
>> If an application trips over a bad block during a load from persistent memory,
>> they will get a signal, and they can either handle it or not.
>>
>> Have a read through this specification and see if it clears anything up for you:
>>  http://www.snia.org/tech_activities/standards/curr_standards/npm
>
> Thank you for sharing this. So, if a user-space application follows to the
> NVM Programming Model then it will be able to survive by means of catching
> and processing the exceptions. But these applications have to be implemented yet.
> Also such applications need in special technique(s) of recovering. It sounds
> that legacy user-space applications are unable to survive for the NVM.PM.FILE mode
> in the case of load/store operation's failure.

By legacy, I assume you mean those applications which mmap file data and
use msync.  Those applications already have to deal with SIGBUS today
when a disk block is bad.  There is no change in behavior.

If you meant legacy applications that use read/write, they also should
see no change in behavior.  Bad blocks are tracked in the block layer,
and any attempt to read from a bad area of memory will get -EIO.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
