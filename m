Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4325714.tYNkapC69P@wuerfel>
References: <20151120173133.24259.97028.stgit@dwillia2-desk3.jf.intel.com>
	<4325714.tYNkapC69P@wuerfel>
Date: Fri, 20 Nov 2015 12:07:08 -0800
Message-ID: <CAGXu5jJnk5PbrJFftheQSd2s=T1A5gnbnMzc7VgqTPNMd8Vw=Q@mail.gmail.com>
Subject: Re: [RFC PATCH] restrict /dev/mem to idle io memory ranges
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Dan Williams <dan.j.williams@intel.com>, LKML <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Catalin Marinas <catalin.marinas@arm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 20, 2015 at 12:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 20 November 2015 09:31:33 Dan Williams wrote:
>> This effectively promotes IORESOURCE_BUSY to IORESOURCE_EXCLUSIVE
>> semantics by default.  If userspace really believes it is safe to access
>> the memory region it can also perform the extra step of disabling an
>> active driver.  This protects device address ranges with read side
>> effects and otherwise directs userspace to use the driver.
>>
>> Persistent memory presents a large "mistake surface" to /dev/mem as now
>> accidental writes can corrupt a filesystem.
>>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>>
>
> I like the idea.

Yes please! I was always surprised that IORESOURCE_BUSY was allowed
under STRICT_DEVMEM.

> Maybe split the change up into two patches, where the first one
> just does the trivial move of the Kconfig option, and the second
> one that changes behavior is small?

Agreed: consolidate the per-arch Kconfigs first.

> There is also a question of whether we actually need two options
> or if we can safely make the existing option stricter.

Right -- what actually breaks if we add _BUSY to getting blocked?

-Kees

-- 
Kees Cook
Chrome OS Security
