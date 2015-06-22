Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150622072844.GA31263@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621101346.GF5915@lst.de>
	<CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com>
	<20150621135406.GA9572@lst.de>
	<CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com>
	<20150622063028.GA30434@lst.de>
	<CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com>
	<20150622072844.GA31263@lst.de>
Date: Mon, 22 Jun 2015 00:39:34 -0700
Message-ID: <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 12:28 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 22, 2015 at 12:17:29AM -0700, Dan Williams wrote:
>> To be fair the namespace was initially envisioned to be btt enabled or
>> not, and hide the raw media device.
>
> What's the fascination with hiding one access mode just because
> another one is available?
>

Now I'm confused, you *don't* want the raw device to be hidden *and*
you want to kill the stacking?  Something got crossed.  The current
implementation hides nothing, you get to see the entire stacked
composition.  I'd much prefer to avoid hiding anything.

>> There's no guarantee that these drivers are only ever paired with
>> XFSv5.
>
> There's not guarantee for anything.   Note that anything not following
> my criteria earlier would need some form of atomic sector updates,
> which is a lot more.  But then again for most of those setups you
> wouldn't take advantage of pmem anyway.
>
> Sounds like we simply shouldn't merge btt at all for now and wait for
> a real use case, which would simplify the whole issue a lot.

The sinister aspect of sector tearing is that most applications don't
know they have this dependency.  At least today's disk's rarely ever
tear sectors and if they do you almost certainly get a CRC error on
access.  NVDIMMs will always tear and always silently.  I think not
merging BTT at all to see what happens is simply wrong.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
