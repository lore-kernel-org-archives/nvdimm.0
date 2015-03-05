Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54F84420.40209@plexistor.com>
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Mar 2015 15:03:10 -0800
Message-ID: <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>, Dan Williams <dan.j.williams@intel.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Ingo Molnar <mingo@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mar 5, 2015 3:55 AM, "Boaz Harrosh" <boaz@plexistor.com> wrote:
>
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> PMEM is a new driver That supports any physical contiguous iomem range
> as a single block device. The driver has support for as many as needed
> iomem ranges each as its own device.
>
> The driver is not only good for NvDIMMs, It is good for any flat memory
> mapped device. We've used it with NvDIMMs, Kernel reserved DRAM
> (memmap= on command line), PCIE Battery backed memory cards, VM shared
> memory, and so on.
>
> The API to pmem module a single string parameter named "map"
> of the form:
>                  map=mapS[,mapS...]
>
>                  where mapS=nn[KMG]$ss[KMG],
>                  or    mapS=nn[KMG]@ss[KMG],
>
>                  nn=size, ss=offset
>
> Just like the Kernel command line map && memmap parameters,
> so anything you did at grub just copy/paste to here.
>
> The "@" form is exactly the same as the "$" form only that
> at bash prompt we need to escape the "$" with \$ so also
> support the '@' char for convenience.
>
> For each specified mapS there will be a device created.

[...]

> +       pmem->virt_addr = ioremap_cache(pmem->phys_addr, pmem->size);

I think it would be nice to have control over the caching mode.
Depending on the application, WT or UC could make more sense.

--Andy
