Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALCETrVLoJj6f72MraEZ3dUA9Mgr8fK17Yw-ACT7pvfB9nZ4MA@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CALCETrVLoJj6f72MraEZ3dUA9Mgr8fK17Yw-ACT7pvfB9nZ4MA@mail.gmail.com>
Date: Tue, 28 Apr 2015 15:21:44 -0700
Message-ID: <CAAek22GZPnBnHcPnNHe-dfNb9Kd_TNDHGXYMpdYRNQtNr4FnFw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 11/20] libnd, nd_pmem: add libnd support
 to the pmem driver
From: Phil Pokorny <ppokorny@penguincomputing.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 2:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 28, 2015 at 11:25 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> +config ND_E820
>> +       tristate "E820: Support the E820-type-12 PMEM convention"
>> +       depends on X86_PMEM_LEGACY
>> +       default m if X86_PMEM_LEGACY
>> +       select LIBND
>> +       help
>> +         Prior to ACPI 6 some platforms advertised peristent memory
>> +         via type-12 e820 memory ranges.  Create a libnd bus and
>> +         attach an instance of the pmem driver to these ranges.
>> +
>
> How about something like:
>
> "This driver allows libnd to work with legacy, pre-ACPI 6 NVDIMMs.
> This enables such devices to be exposed as block devices using PMEM.
>
> The legacy NVDIMM interface is problematic.  This driver will not work
> if you boot using UEFI, and some NVDIMMs and motherboards that work
> with this driver may require proprietary code in order to work
> reliably."

Perhaps not "problematic" but "requires a BIOS in Legacy mode"

It might also mention that if you use the kernel command line
memmap=nn!ss syntax it adds
a type 12 region to the e820 map and so you would want this support.

If you have a motherboard with UEFI support for NVDIMM's that would be
the recommended
configuration.

Phil P.

-- 
Philip Pokorny, RHCE
Chief Technology Officer
PENGUIN COMPUTING, Inc
www.penguincomputing.com
