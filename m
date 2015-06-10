Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150609063900.GD9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001514.4506.13974.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609063900.GD9804@lst.de>
Date: Wed, 10 Jun 2015 08:54:32 -0700
Message-ID: <CAPcyv4jZe7K0CSLceXeUft0EzKUH1H_7EoGeVVX5FjWfES2n_Q@mail.gmail.com>
Subject: Re: [PATCH v5 12/21] libnvdimm: namespace indices: read and validate
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 8, 2015 at 11:39 PM, Christoph Hellwig <hch@lst.de> wrote:
>> +#include <asm-generic/io-64-nonatomic-lo-hi.h>
>> +
>> +#ifndef __io_virt
>> +#define __io_virt(x) ((void __force *) (x))
>> +#endif
>
> NAK. driver code mus never include asm-generic headers directly,
> and __io_virt isn't something that's up to a driver to redefine either.
>
> I think we really need the memremap series in first before trying to
> do the things done in this patch.

I was abusing read[wlq] and write[wlq].  All this patch needs is a
conversion to use __leXXto_cpu and __cpu_to_leXX helpers.
