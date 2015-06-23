Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i8ciusz34UArM5MFFB8V-dz2JrCGKgkT3i5d6QT0-0xA@mail.gmail.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150622163453.GA9187@lst.de>
	<CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com>
	<20150622164837.GB9393@lst.de>
	<x49k2uvvbje.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com>
	<20150623101917.GG24894@lst.de>
	<CAPcyv4i8ciusz34UArM5MFFB8V-dz2JrCGKgkT3i5d6QT0-0xA@mail.gmail.com>
Date: Tue, 23 Jun 2015 13:33:44 -0700
Message-ID: <CAPcyv4iGaYWn_OzXgX71jW181L8YCYQwx0FcLLcU=+rU-8vAxw@mail.gmail.com>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 23, 2015 at 8:19 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jun 23, 2015 at 3:19 AM, Christoph Hellwig <hch@lst.de> wrote:
>> On Mon, Jun 22, 2015 at 12:02:54PM -0700, Dan Williams wrote:
>>> I don't see the need to re-invent partitioning which is the path this
>>> requested rework is putting us on...
>>>
>>> However, when the need arises for smaller granularity BTT we can have
>>> the partition fight then.  To be clear, I believe that need is already
>>> here today, but I'm not in a position to push that agenda at this late
>>> date.
>>
>>
>> Instead of all this complaining and moaning let's figure out what
>> architecture you'd actually want.  The one I had in mind is:
>>
>> +------------------------------+
>> |  block layer (& partitions)  |
>> +---------------+--------------+--------------------+
>> |  pmem driver  |  btt driver  |  other consumers   |
>> +---------------+--------------+--------------------+
>> |        pmem API through libnvdimm                 |
>> +---------------------------------------------------+
>>
>
> I've got this mostly coded up.  The nice property is that BTTs now
> become another flavor of the same namespace.

This approach has grown on me since yesterday.  I neglected to realize
that we can carve out a BLK-mode namespace to be a BTT enabled log
device if the need arises to satisfy what BTT on a partition was doing
previously.
