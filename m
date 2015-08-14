Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1439586441.16263.6.camel@linux.intel.com>
References: <1439585008-30192-1-git-send-email-ross.zwisler@linux.intel.com>
	<CAPcyv4jxw5rP2UoBF5gKW4tWtcKCj6Z0iXqwbWSCNv9TpjRGEQ@mail.gmail.com>
	<1439586441.16263.6.camel@linux.intel.com>
Date: Fri, 14 Aug 2015 14:28:36 -0700
Message-ID: <CAPcyv4jKMhG-rAWiESFGktoC0-zyvOP543KKRZEe3+Vv2Qugnw@mail.gmail.com>
Subject: Re: [PATCH] nd_blk: add support for "read flush" DSM flag
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Jaeger <cj@linux.com>, Juergen Gross <jgross@suse.com>, X86 ML <x86@kernel.org>, Yalin Wang <Yalin.Wang@sonymobile.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Will Deacon <will.deacon@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Russell King <rmk+kernel@arm.linux.org.uk>, Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Dan Streetman <ddstreet@ieee.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 14, 2015 at 2:07 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, 2015-08-14 at 14:05 -0700, Dan Williams wrote:
>> On Fri, Aug 14, 2015 at 1:43 PM, Ross Zwisler
>> This should be s/MEMREMAP_WB/ARCH_MEMREMAP_PMEM/, but other than that
>> looks good to me.
>>
>> I also should go move ARCH_MEMREMAP_PMEM over to
>> arch/x86/include/asm/pmem.h and fold it in to your other pending
>> pmem-api cleanups.
>
> Sounds good.  Would you like a v2 with those changes, or would you rather
> fix it as you apply it to the nvdimm tree?

Actually on closer this breaks the build for the unit test, so please
respin with the ARCH_MEMREMAP_PMEM change and the unit test fixups.
