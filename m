Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A91FF1A@G9W0745.americas.hpqcorp.net>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150520205749.32249.9040.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A91FF1A@G9W0745.americas.hpqcorp.net>
Date: Fri, 22 May 2015 14:39:51 -0700
Message-ID: <CAPcyv4hjKxP-s65Y-MTk-hV8pe9fke9x65hyXmtzDXqJsPL4qw@mail.gmail.com>
Subject: Re: [PATCH v3 18/21] nd_btt: atomic sector updates
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "mingo@kernel.org" <mingo@kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "neilb@suse.de" <neilb@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 22, 2015 at 2:16 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>
>
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Wednesday, May 20, 2015 3:58 PM
>> To: axboe@kernel.dk
>> Cc: mingo@kernel.org; linux-nvdimm@lists.01.org; neilb@suse.de;
>> gregkh@linuxfoundation.org; Dave Chinner; linux-kernel@vger.kernel.org; Andy
>> Lutomirski; Jens Axboe; linux-acpi@vger.kernel.org; H. Peter Anvin;
>> hch@lst.de
>> Subject: [PATCH v3 18/21] nd_btt: atomic sector updates
>>
>> From: Vishal Verma <vishal.l.verma@linux.intel.com>
>>
> ...
>> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
>> index 00d9afe9475e..2b169806eac5 100644
>> --- a/drivers/block/nd/Kconfig
>> +++ b/drivers/block/nd/Kconfig
>> @@ -32,9 +32,25 @@ config BLK_DEV_PMEM
>>         capable of DAX (direct-access) file system mappings.  See
>>         Documentation/blockdev/nd.txt for more details.
>>
>> -       Say Y if you want to use a NVDIMM described by NFIT
>> +       Say Y if you want to use a NVDIMM described by ACPI, E820, etc...
>>
>>  config ND_BTT_DEVS
>> -     def_bool y
>> +     bool
>> +
>> +config ND_BTT
>> +     tristate "BTT: Block Translation Table (atomic sector updates)"
>> +     depends on LIBND
>> +     default LIBND
>> +     select ND_BTT_DEVS
>
> The ND_BTT option, which is presented during a kernel build,
> is missing help text. So is E820_PMEM in patch 3/21.
>

Right, but another alternative is hiding the ability to configure it
altogether.  Perhaps just build them in always.  I made them
configurable for those kernel size folks that like the ability to
throw away things they don't need, but this may be a degree of freedom
too far.  E820_PMEM is a bit more straightforward, and could use a
help comment like "you've already gone through the trouble to turn on
X86_PMEM_LEGACY, you had better turn on the driver too, otherwise
what's the point" :).
