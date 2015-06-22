Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 18:45:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150622164515.GA9281@lst.de>
References: <20150621101346.GF5915@lst.de> <CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com> <20150621135406.GA9572@lst.de> <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com> <20150622063028.GA30434@lst.de> <CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com> <20150622072844.GA31263@lst.de> <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com> <20150622154056.GB7952@lst.de> <CAPcyv4hQ_r--8kmLZrkSZV5OBPAFt0VeRWN1r_OEhuxh96rxyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hQ_r--8kmLZrkSZV5OBPAFt0VeRWN1r_OEhuxh96rxyw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 09:36:50AM -0700, Dan Williams wrote:
> In that case "don't stack" is too coarse of a hammer.  I see this as a
> request to hide the subordinate ULD which is a new capability that DM
> and MD might benefit from as well.  We already have the case in MD
> where it internally holds a reference to bdev that has been hot
> removed, it seems not much of a stretch to have stacking drivers be
> able to hide device nodes for bdevs that they are holding.

I don't see why you're comparing with MD and DM here.  MD and DM
sit cleanly ontop of any block device.  If btt was independent of
libnvdimm and just used ->rw_bytes we could see it as this.

But it's all a giant entangled mess, where btt for example is probed
by libnvdimm.  At the same time pmem.c isn't really a true block
driver, it's really just a trivial shim between the block API
and pmem-style memcpy.  Especially with the proper pmem API btt
would become cleaner just calling that directly.  

> Yes, if they want to use DAX they should do it consciously and audit
> their application to be sure it is safe to abandon atomic sector
> guarantees.  With the current flexibility to do BTT on a partition
> they can do this conversion piecemeal and, for example, keep metadata
> on BTT and data on DAX.

By that logic you'd want to attach BTT by default and allow opt-out
at some level.  This could be a libnvmdimm-level partitioning scheme,
which would also allow storing the bit if BTT is used or not persistently.
Or it could be on fine grained boundaries which might be more useful.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
