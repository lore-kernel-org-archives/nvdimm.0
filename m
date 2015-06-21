Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150621101118.GE5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235551.12943.76656.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150619083410.GA2885@lst.de>
	<CAPcyv4gHHYapu+sWoxmUsGx4Thf5SkA_0Hg9o2hniU1vuaDHyg@mail.gmail.com>
	<20150621101118.GE5915@lst.de>
Date: Sun, 21 Jun 2015 06:22:32 -0700
Message-ID: <CAPcyv4i1C0+ucKHPTEPfxpFqWQ+98WrbJtpwMCbshd7YJ4x1Bg@mail.gmail.com>
Subject: Re: [PATCH 12/15] libnvdimm: enable iostat
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 21, 2015 at 3:11 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Jun 19, 2015 at 02:02:39AM -0700, Dan Williams wrote:
>> On Fri, Jun 19, 2015 at 1:34 AM, Christoph Hellwig <hch@lst.de> wrote:
>> > On Wed, Jun 17, 2015 at 07:55:51PM -0400, Dan Williams wrote:
>> >> This is disabled by default as the overhead is prohibitive, but if the
>> >> user takes the action to turn it on we'll oblige.
>> >
>> > If you care about users a compile time selection doesn't make sense,
>> > why not always build it but require an opt-in?
>>
>> It's always built the Kconfig just selects the default initial state
>> of QUEUE_FLAG_IO_STAT.  They can always turn it on/off via block queue
>> sysfs.
>
> Oh, missed that.  Just drop the Kconfig option in that case.

Ok.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
