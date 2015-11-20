Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH] restrict /dev/mem to idle io memory ranges
Date: Fri, 20 Nov 2015 21:00:29 +0100
Message-ID: <4325714.tYNkapC69P@wuerfel>
In-Reply-To: <20151120173133.24259.97028.stgit@dwillia2-desk3.jf.intel.com>
References: <20151120173133.24259.97028.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Kees Cook <keescook@chromium.org>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Catalin Marinas <catalin.marinas@arm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Friday 20 November 2015 09:31:33 Dan Williams wrote:
> This effectively promotes IORESOURCE_BUSY to IORESOURCE_EXCLUSIVE
> semantics by default.  If userspace really believes it is safe to access
> the memory region it can also perform the extra step of disabling an
> active driver.  This protects device address ranges with read side
> effects and otherwise directs userspace to use the driver.
> 
> Persistent memory presents a large "mistake surface" to /dev/mem as now
> accidental writes can corrupt a filesystem.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 

I like the idea.

Maybe split the change up into two patches, where the first one
just does the trivial move of the Kconfig option, and the second
one that changes behavior is small?

There is also a question of whether we actually need two options
or if we can safely make the existing option stricter.

	Arnd
