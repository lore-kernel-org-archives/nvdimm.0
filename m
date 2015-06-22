Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150622063028.GA30434@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621101346.GF5915@lst.de>
	<CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com>
	<20150621135406.GA9572@lst.de>
	<CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com>
	<20150622063028.GA30434@lst.de>
Date: Mon, 22 Jun 2015 00:17:29 -0700
Message-ID: <CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 11:30 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Sun, Jun 21, 2015 at 08:11:25AM -0700, Dan Williams wrote:
>> The labels only allow allocation of persistent media between pmem and
>> blk.  For a given dimm you may access in either mode and the label
>> records the decision.  We can have a btt on either the pmem or
>> blk-mode disk type, or partition thereof.
>
> Sounds like the spec should allow a btt type as well insteaad of
> requiring the OS to work around it, as that seems to be one of the few
> useful things to do with a run-time label.

To be fair the namespace was initially envisioned to be btt enabled or
not, and hide the raw media device.  It was only when we added the
"XFS needs BTT so we need BTT support on partitions" constraint did I
push stacked BTT as the most flexible way to handle all these
configurations.  It also simplified the namespace to only be a
partition of access modes and leave sub-dividing pmem to standard
partitions.

> Either way, partitions are trivial things and we could add them to the
> nvdimm layer.
>
>> Yes, it's this hybrid thing that mostly fits into the existing block
>> device model save for two new block_device_operations
>> ->direct_access() and ->rw_bytes().  We then use property of a
>> block_device that allows it to be claimed for exclusive ownership by a
>> filesystem or another block_device to layer storage semantics on top
>> be it files+directories, raid, caching, or atomic sectors.  NVDIMM
>> devices don't present the same complexity as MTD devices.  The only
>> complexity they present is byte-address-ability, not erase-block-size,
>> wear-leveling, etc...
>
> I didn't say they show the same complexities, but the same layering.
>
>> Good to hear that we don't need BTT for XFS v5, can we make the
>> guarantee for all filesystems that may want to support DAX?  I still
>> think stacking is a natural fit for this problem.
>
> I can't make any guarantees, especially not without verification.  But
> if correctly implemented any filesystems that does out of place metadata
> writes (and that includes a traditional log) and uses checksum to ensure
> the integrity of these updates it should be fine.  You'd still have
> the issue of sector atomicy of file I/O though.

If someone needs sector atomicity of file I/O then by definition they
can't have DAX enabled.

There's no guarantee that these drivers are only ever paired with
XFSv5.  Drivers tend to be backported more freely than filesystems.  I
don't think the need for BTT on partitions will go away, but if you're
not convinced we could try the wait and see approach and move BTT to
only be enabled at namespace boundaries.  That's a fairly invasive
change to the configuration model, I'd hate to come back in a few
months to re-add BTT on partition support alongside the namespace only
mode.  Not trying to throw FUD, I'm willing to admit there are
downsides to the stacking model, they're just not clear to me
presently.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
