Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150621100329.GA5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235503.12943.76918.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150621100329.GA5915@lst.de>
Date: Sun, 21 Jun 2015 09:31:02 -0700
Message-ID: <CAPcyv4iA96Khapnm54JZkgiduoqyWo1x45r7EX=OU8cs1dyhsw@mail.gmail.com>
Subject: Re: [PATCH 03/15] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 3:03 AM, Christoph Hellwig <hch@lst.de> wrote:
>> +config ND_MAX_REGIONS
>> +     int "Maximum number of regions supported by the sub-system"
>> +     default 64
>> +     ---help---
>> +       A 'region' corresponds to an individual DIMM or an interleave
>> +       set of DIMMs.  A typical maximally configured system may have
>> +       up to 32 DIMMs.
>> +
>> +       Leave the default of 64 if you are unsure.
>
> Having static limits in Kconfig is a bad idea.  What prevents you
> from handling any (reasonable) number dynamically?

Hmm, yes, this was a bad holdover from before we were using percpu
definitions for the lane locks.  Now that it's converted we can kill
the static definition of nd_percpu_lane and just do an alloc_percpu()
for each region dynamically.  Fixed in v2 and passing the test suite.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
