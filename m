Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <x49k2uvvbje.fsf@segfault.boston.devel.redhat.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150622163453.GA9187@lst.de>
	<CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com>
	<20150622164837.GB9393@lst.de>
	<x49k2uvvbje.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 22 Jun 2015 12:02:54 -0700
Message-ID: <CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 11:32 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Christoph Hellwig <hch@lst.de> writes:
>
>> On Mon, Jun 22, 2015 at 09:48:03AM -0700, Dan Williams wrote:
>>> Only if you abandon BTT on partitions, which at this point it seems
>>> you're boldly committed to doing.  It's unacceptable to drop BTT on
>>> the floor so I'll take a look at making BTT per-disk only for 4.2.
>>
>> If by partitions you mean block layer partitions: yes.  If by partitions
>> you mean subdivision of nvdimms: no.
>
> How will this subdivision be recorded?  Not all NVDIMMs support the
> label specification.

...and the ones that do only use labels for resolving aliasing, not
partitioning.

> Sysadmins are already familiar with partitions;  I'm not sure why we'd
> deviate from that here.  What am I missing?

I don't see the need to re-invent partitioning which is the path this
requested rework is putting us on...

However, when the need arises for smaller granularity BTT we can have
the partition fight then.  To be clear, I believe that need is already
here today, but I'm not in a position to push that agenda at this late
date.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
