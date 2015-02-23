Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54EB2124.7040701@plexistor.com>
References: <54EB1D33.3050107@plexistor.com> <54EB2124.7040701@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Feb 2015 07:48:23 -0800
Message-ID: <CALCETrVcs0bW=fZE4hWe0CoHyHvGRSym6dG4Cwqhe=igr+n+SA@mail.gmail.com>
Subject: Re: [PATCH 3A/3 good] e820: Add the unknown-12 Memory type (DDR3-NvDIMM)
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 23, 2015 at 4:46 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>
> There are multiple vendors of DDR3 NvDIMMs out in the market today.
> At various stages of development/production. It is estimated that
> there are already more the 100ds of thousands chips sold to
> testers and sites.
>
> All the BIOS vendors I know of, tagged these chips at e820 table
> as type-12 memory.
>

I have no problem with this patch.

> Now the ACPI comity, as far as I know, did not yet define a
> standard type for NvDIMM. Also, as far as I know any NvDIMM
> standard will only be defined for DDR4. So DDR3 NvDIMM is
> probably stuck with this none STD type.

s/comity/committee?

>
> I Wish and call the ACPI comity to Define that NvDIMM is type-12.
> Also for DDR4
>
> In this patch I name type-12 "unknown-12". This is because of
> ACPI politics that refuse to reserve type-12 as DDR3-NvDIMM
> and members keep saying:
>         "What if ACPI assigns type-12 for something else in future"
>
> [And I say: Then just don't. Please?]

Good luck :)

--Andy
