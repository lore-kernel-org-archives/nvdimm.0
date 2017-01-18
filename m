Return-Path: <linux-nvdimm-bounces@lists.01.org>
MIME-Version: 1.0
In-Reply-To: <20170117235150.GE4880@omniknight.lm.intel.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <20170117063355.GL14033@birch.djwong.org>
 <20170117213549.GB4880@omniknight.lm.intel.com>
 <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
 <20170117223705.GD4880@omniknight.lm.intel.com>
 <CAOvWMLYcP9PN6LT51gwJvmyCTfRRrVeDTrjN-8_zTKhD+UmDiw@mail.gmail.com>
 <20170117235150.GE4880@omniknight.lm.intel.com>
From: Andiry Xu <andiry@gmail.com>
Date: Tue, 17 Jan 2017 17:58:43 -0800
Message-ID: <CAOvWMLZCt39EDg-1uppVVUeRG40JvOo9sKLY2XMuynZdnc0W9w@mail.gmail.com>
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

On Tue, Jan 17, 2017 at 3:51 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 01/17, Andiry Xu wrote:
>
> <snip>
>
>> >>
>> >> The pmem_do_bvec() read logic is like this:
>> >>
>> >> pmem_do_bvec()
>> >>     if (is_bad_pmem())
>> >>         return -EIO;
>> >>     else
>> >>         memcpy_from_pmem();
>> >>
>> >> Note memcpy_from_pmem() is calling memcpy_mcsafe(). Does this imply
>> >> that even if a block is not in the badblock list, it still can be bad
>> >> and causes MCE? Does the badblock list get changed during file system
>> >> running? If that is the case, should the file system get a
>> >> notification when it gets changed? If a block is good when I first
>> >> read it, can I still trust it to be good for the second access?
>> >
>> > Yes, if a block is not in the badblocks list, it can still cause an
>> > MCE. This is the latent error case I described above. For a simple read()
>> > via the pmem driver, this will get handled by memcpy_mcsafe. For mmap,
>> > an MCE is inevitable.
>> >
>> > Yes the badblocks list may change while a filesystem is running. The RFC
>> > patches[1] I linked to add a notification for the filesystem when this
>> > happens.
>> >
>>
>> This is really bad and it makes file system implementation much more
>> complicated. And badblock notification does not help very much,
>> because any block can be bad potentially, no matter it is in badblock
>> list or not. And file system has to perform checking for every read,
>> using memcpy_mcsafe. This is disaster for file system like NOVA, which
>> uses pointer de-reference to access data structures on pmem. Now if I
>> want to read a field in an inode on pmem, I have to copy it to DRAM
>> first and make sure memcpy_mcsafe() does not report anything wrong.
>
> You have a good point, and I don't know if I have an answer for this..
> Assuming a system with MCE recovery, maybe NOVA can add a mce handler
> similar to nfit_handle_mce(), and handle errors as they happen, but I'm
> being very hand-wavey here and don't know how much/how well that might
> work..
>
>>
>> > No, if the media, for some reason, 'dvelops' a bad cell, a second
>> > consecutive read does have a chance of being bad. Once a location has
>> > been marked as bad, it will stay bad till the ACPI clear error 'DSM' has
>> > been called to mark it as clean.
>> >
>>
>> I wonder what happens to write in this case? If a block is bad but not
>> reported in badblock list. Now I write to it without reading first. Do
>> I clear the poison with the write? Or still require a ACPI DSM?
>
> With writes, my understanding is there is still a possibility that an
> internal read-modify-write can happen, and cause a MCE (this is the same
> as writing to a bad DRAM cell, which can also cause an MCE). You can't
> really use the ACPI DSM preemptively because you don't know whether the
> location was bad. The error flow will be something like write causes the
> MCE, a badblock gets added (either through the mce handler or after the
> next reboot), and the recovery path is now the same as a regular badblock.
>

This is different from my understanding. Right now write_pmem() in
pmem_do_bvec() does not use memcpy_mcsafe(). If the block is bad it
clears poison and writes to pmem again. Seems to me writing to bad
blocks does not cause MCE. Do we need memcpy_mcsafe for pmem stores?

Thanks,
Andiry

>>
>> > [1]: http://www.linux.sgi.com/archives/xfs/2016-06/msg00299.html
>> >
>>
>> Thank you for the patchset. I will look into it.
>>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
