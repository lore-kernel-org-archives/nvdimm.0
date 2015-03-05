Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54F82ED1.8030900@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	<54F82ED1.8030900@plexistor.com>
Date: Thu, 5 Mar 2015 12:56:01 -0800
Message-ID: <CAPcyv4i5WfR48hmGwqLDgTFRpUPaAxusHXKKUKY4FBxu1Mqm+w@mail.gmail.com>
Subject: Re: [PATCH 3/3] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 5, 2015 at 2:24 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>
> There are multiple vendors of DDR3 NvDIMMs out in the market today.
> At various stages of development/production. It is estimated that
> there are already more the 100ds of thousands chips sold to
> testers and sites.
>
> All the BIOS vendors I know of, tagged these chips at e820 table
> as type-12 memory.
>
> Now the ACPI comity, as far as I know, did not yet define a
> standard type for NvDIMM. Also, as far as I know any NvDIMM
> standard will only be defined for DDR4. So DDR3 NvDIMM is
> probably stuck with this none STD type.

There's no relation between E820 types and DDR technology revisions.

> I Wish and call the ACPI comity to Define that NvDIMM is type-12.
> Also for DDR4
>
> The motivation of this patch is to be able to differentiate
> this NvDIMM type from a real future "unknown-reserved" type.
>
> In this patch I name type-12 "unknown-12". This is because of
> ACPI politics that refuse to reserve type-12 as DDR3-NvDIMM

It's not "politics".  Setting standards takes time and the platforms
in question simply jumped the gun to enable a proof-of-concept.

> and members keep saying:
>         "What if ACPI assigns type-12 for something else in future"
>
> [And I say: Then just don't. Please?]

Once a standard number is assigned, platform firmwares can update
type-12 to that number.  We might consider a compile time override for
these niche/pre-standard systems that can't/won't update, but it's not
clear to me that we even need to go that far.
