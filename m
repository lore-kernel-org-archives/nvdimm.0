Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54FD8DBD.3070309@plexistor.com>
Date: Mon, 09 Mar 2015 14:10:37 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
References: <54F82CE0.4040502@plexistor.com> <54F82ED1.8030900@plexistor.com> <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com> <CALCETrX6hLg+VPU-8voTFz+uChUdYf_JYg5iEwr6skEHp4R=Dg@mail.gmail.com>
In-Reply-To: <CALCETrX6hLg+VPU-8voTFz+uChUdYf_JYg5iEwr6skEHp4R=Dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/06/2015 01:09 AM, Andy Lutomirski wrote:
<>
> 
> I will be shocked if a standard of this form ever appears.  Modern
> systems *don't have e820*.  The BIOSes that are using this type 12
> hack are awful throwbacks.

So far the systems we have, with DDR4 NvDIMM(s) (Actual chips arriving soon)
still have BIOS (On by default). The BIOS was yelled "Wolfe" for so long NOW ;-)
Again these are working system in the field, who will switch them all to UEFI?

How will the UEFI present them to the system? can you point me to the relevant
code? (Or did you mean BIOS but with a different communication path than e820?)

> 
> --Andy
> 

Thanks
Boaz

