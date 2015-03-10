Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 10 Mar 2015 13:11:37 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
Message-ID: <20150310051137.GA18810@linux-rxt1.site>
References: <54F82CE0.4040502@plexistor.com>
 <54F82ED1.8030900@plexistor.com>
 <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com>
 <CALCETrX6hLg+VPU-8voTFz+uChUdYf_JYg5iEwr6skEHp4R=Dg@mail.gmail.com>
 <54FD8DBD.3070309@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54FD8DBD.3070309@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi, 

On Mon, Mar 09, 2015 at 02:10:37PM +0200, Boaz Harrosh wrote:
> On 03/06/2015 01:09 AM, Andy Lutomirski wrote:
> <>
> > 
> > I will be shocked if a standard of this form ever appears.  Modern
> > systems *don't have e820*.  The BIOSes that are using this type 12
> > hack are awful throwbacks.
> 
> So far the systems we have, with DDR4 NvDIMM(s) (Actual chips arriving soon)
> still have BIOS (On by default). The BIOS was yelled "Wolfe" for so long NOW ;-)
> Again these are working system in the field, who will switch them all to UEFI?
> 
> How will the UEFI present them to the system? can you point me to the relevant
> code? (Or did you mean BIOS but with a different communication path than e820?)
>

Per my understand...

With EFI Boot Stub, there have setup_e820() codes in arch/x86/boot/compressed/eboot.c
that used to transfer EFI memmap to e820 entries. Currently doesn't have any
EFI_MEMORY_TYPE reflects to NvDIMM that will map to e820_type. 

I wonder what kind of EFI_MEMORY_TYPE reported by UEFI BIOS on those "shipped
NvDIMMs motherboards", like supermicro X9DRH-iF-NV. Then we may need add code
to setup_e820() for mapping the efi memory type to e820 type 12 region.

> > 
> > --Andy
> > 
> 
> Thanks
> Boaz
> 

Thanks a lot!
Joey Lee
