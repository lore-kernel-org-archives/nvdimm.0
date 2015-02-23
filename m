Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <54EB219F.5050706@plexistor.com>
References: <54EB1D33.3050107@plexistor.com> <54EB219F.5050706@plexistor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Feb 2015 07:49:36 -0800
Message-ID: <CALCETrWOT9D_NX509zLgNPLU9ueVxwSiXDWUs_8gqOTg11vJfw@mail.gmail.com>
Subject: Re: [PATCH 3B/3 fat] e820: dynamic unknown-xxx names (for DDR3-NvDIMM)
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 23, 2015 at 4:48 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
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
>
> I Wish and call the ACPI comity to Define that NvDIMM is type-12.
> Also for DDR4
>
> In this patch I dynamically sprintf names into a static buffer
> (max two unknown names) of the form "unknown-XXX" where XXX
> is the type number. This is so we can return static string to
> caller.

I prefer the other variant.

For Pete's sake, people, defining new e820 types is ludicrous.  It's
already sort of happened for nvdimms (and I really hope that type 12
is on its way out), and if it every happens again, we can deal with it
them.

--Andy
