Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150622154056.GB7952@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621101346.GF5915@lst.de>
	<CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com>
	<20150621135406.GA9572@lst.de>
	<CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com>
	<20150622063028.GA30434@lst.de>
	<CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com>
	<20150622072844.GA31263@lst.de>
	<CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com>
	<20150622154056.GB7952@lst.de>
Date: Mon, 22 Jun 2015 09:36:50 -0700
Message-ID: <CAPcyv4hQ_r--8kmLZrkSZV5OBPAFt0VeRWN1r_OEhuxh96rxyw@mail.gmail.com>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 8:40 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 22, 2015 at 12:39:34AM -0700, Dan Williams wrote:
>> Now I'm confused, you *don't* want the raw device to be hidden *and*
>> you want to kill the stacking?  Something got crossed.  The current
>> implementation hides nothing, you get to see the entire stacked
>> composition.  I'd much prefer to avoid hiding anything.
>
> You see it, but you can't actually use it.  The proper way to expose it
> would be to the devices visible in the low-level bus sysfs enumeration
> logic but only one ULD attach to it.
>

In that case "don't stack" is too coarse of a hammer.  I see this as a
request to hide the subordinate ULD which is a new capability that DM
and MD might benefit from as well.  We already have the case in MD
where it internally holds a reference to bdev that has been hot
removed, it seems not much of a stretch to have stacking drivers be
able to hide device nodes for bdevs that they are holding.

>> The sinister aspect of sector tearing is that most applications don't
>> know they have this dependency.  At least today's disk's rarely ever
>> tear sectors and if they do you almost certainly get a CRC error on
>> access.  NVDIMMs will always tear and always silently.  I think not
>> merging BTT at all to see what happens is simply wrong.
>
> So now you leave your users with a choice between a rock and a hard
> place, that is using BTT to introduce non-significant overhead and not
> supporting DAX or just use it as-is.

Yes, if they want to use DAX they should do it consciously and audit
their application to be sure it is safe to abandon atomic sector
guarantees.  With the current flexibility to do BTT on a partition
they can do this conversion piecemeal and, for example, keep metadata
on BTT and data on DAX.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
