Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 17:40:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150622154056.GB7952@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com> <20150621101346.GF5915@lst.de> <CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com> <20150621135406.GA9572@lst.de> <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com> <20150622063028.GA30434@lst.de> <CAPcyv4hmYiU5Gzmz8prPCESOYGn099-TffFTZH0E2OAx+JzkTQ@mail.gmail.com> <20150622072844.GA31263@lst.de> <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gUp6LtYVuzbQfzq6RbDyf=3nQ0509TPnNCJtVBazrUTg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 12:39:34AM -0700, Dan Williams wrote:
> Now I'm confused, you *don't* want the raw device to be hidden *and*
> you want to kill the stacking?  Something got crossed.  The current
> implementation hides nothing, you get to see the entire stacked
> composition.  I'd much prefer to avoid hiding anything.

You see it, but you can't actually use it.  The proper way to expose it
would be to the devices visible in the low-level bus sysfs enumeration
logic but only one ULD attach to it.

> The sinister aspect of sector tearing is that most applications don't
> know they have this dependency.  At least today's disk's rarely ever
> tear sectors and if they do you almost certainly get a CRC error on
> access.  NVDIMMs will always tear and always silently.  I think not
> merging BTT at all to see what happens is simply wrong.

So now you leave your users with a choice between a rock and a hard
place, that is using BTT to introduce non-significant overhead and not
supporting DAX or just use it as-is.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
