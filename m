Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FEB1CA.5090902@plexistor.com>
Date: Tue, 10 Mar 2015 10:56:42 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
References: <54F82CE0.4040502@plexistor.com> <54F82ED1.8030900@plexistor.com> <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com> <CALCETrX6hLg+VPU-8voTFz+uChUdYf_JYg5iEwr6skEHp4R=Dg@mail.gmail.com> <54FD8DBD.3070309@plexistor.com> <20150310051137.GA18810@linux-rxt1.site>
In-Reply-To: <20150310051137.GA18810@linux-rxt1.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/10/2015 07:11 AM, joeyli wrote:
<>
> 
> Per my understand...
> 
> With EFI Boot Stub, there have setup_e820() codes in arch/x86/boot/compressed/eboot.c
> that used to transfer EFI memmap to e820 entries. Currently doesn't have any
> EFI_MEMORY_TYPE reflects to NvDIMM that will map to e820_type. 
> 
> I wonder what kind of EFI_MEMORY_TYPE reported by UEFI BIOS on those "shipped
> NvDIMMs motherboards", like supermicro X9DRH-iF-NV. Then we may need add code
> to setup_e820() for mapping the efi memory type to e820 type 12 region.
> 

Thanks Joey. This is tremendous help. (Just saved me days of research)

Our DDR4 NvDIMM chips arrive this week I will try and debug all this, also
booting EFI.

If you have any chance to experiments in your lab, and compare notes it
would be great.

<>
> 
> Thanks a lot!
> Joey Lee
> 

Thanks
Boaz

