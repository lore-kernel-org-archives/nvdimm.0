Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150621100801.GC5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235541.12943.86562.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621100801.GC5915@lst.de>
Date: Sun, 21 Jun 2015 06:28:43 -0700
Message-ID: <CAPcyv4gtFeFt-Mpa=s9bs+W+4LpHP4cTCFu6To5FG0Z1_uOEkA@mail.gmail.com>
Subject: Re: [PATCH 10/15] libnvdimm: fix up max_hw_sectors
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 3:08 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +void nd_blk_queue_init(struct request_queue *q)
>> +{
>> +     blk_queue_max_hw_sectors(q, UINT_MAX);
>> +     blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
>> +}
>
> Please just add the calls to the drivers instead of this helper which
> hides the intent.

I thought it made it clearer what properties are shared between block
devices on an nvdimm bus, but if you're initial reaction is that it
hides intent I'll kill the helper.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
