Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 08:30:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150622063028.GA30434@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com> <20150621101346.GF5915@lst.de> <CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com> <20150621135406.GA9572@lst.de> <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 08:11:25AM -0700, Dan Williams wrote:
> The labels only allow allocation of persistent media between pmem and
> blk.  For a given dimm you may access in either mode and the label
> records the decision.  We can have a btt on either the pmem or
> blk-mode disk type, or partition thereof.

Sounds like the spec should allow a btt type as well insteaad of
requiring the OS to work around it, as that seems to be one of the few
useful things to do with a run-time label.

Either way, partitions are trivial things and we could add them to the
nvdimm layer.

> Yes, it's this hybrid thing that mostly fits into the existing block
> device model save for two new block_device_operations
> ->direct_access() and ->rw_bytes().  We then use property of a
> block_device that allows it to be claimed for exclusive ownership by a
> filesystem or another block_device to layer storage semantics on top
> be it files+directories, raid, caching, or atomic sectors.  NVDIMM
> devices don't present the same complexity as MTD devices.  The only
> complexity they present is byte-address-ability, not erase-block-size,
> wear-leveling, etc...

I didn't say they show the same complexities, but the same layering.

> Good to hear that we don't need BTT for XFS v5, can we make the
> guarantee for all filesystems that may want to support DAX?  I still
> think stacking is a natural fit for this problem.

I can't make any guarantees, especially not without verification.  But
if correctly implemented any filesystems that does out of place metadata
writes (and that includes a traditional log) and uses checksum to ensure
the integrity of these updates it should be fine.  You'd still have
the issue of sector atomicy of file I/O though.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
