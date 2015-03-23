Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54F84538.8080500@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	<54F830D4.7030205@plexistor.com>
	<54F84538.8080500@plexistor.com>
Date: Mon, 23 Mar 2015 13:59:53 -0700
Message-ID: <CAPcyv4hLmPsEMVV1Za5k=_O0R8X5UB_nue6skRCXeiT4=pHLgg@mail.gmail.com>
Subject: Re: [PATCH 7/8] pmem: Add support for page structs
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 5, 2015 at 3:59 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>
> One of the current shortcomings of the NVDIMM/PMEM
> support is that this memory does not have a page-struct(s)
> associated with its memory and therefor cannot be passed
> to a block-device or network or DMAed in any way through
> another device in the system.
>
> The use of add_persistent_memory() fixes all this. After this patch
> an FS can do:
>         bdev_direct_access(,&pfn,);

Hmm, can we do this mapping on demand per direct access mapping rather
than unconditionally for each range that pmem is handling?

Going forward I don't think we want to be tied to guaranteeing that
plain bdev_direct_access() always yields pfn_to_page()-capable pfns.

Perhaps a DAX_MAP_PFN flag or something along those lines?
