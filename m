Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 23 Nov 2015 10:19:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] arch: consolidate CONFIG_STRICT_DEVM in
 lib/Kconfig.debug
Message-ID: <20151123101944.GA32300@e104818-lin.cambridge.arm.com>
References: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Will Deacon <will.deacon@arm.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 21, 2015 at 07:57:02PM -0800, Dan Williams wrote:
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 04fb73b973f1..e13c4bf84d9e 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -14,20 +14,6 @@ config ARM64_PTDUMP
>  	  kernel.
>  	  If in doubt, say "N"
>  
> -config STRICT_DEVMEM
> -	bool "Filter access to /dev/mem"
> -	depends on MMU
> -	help
> -	  If this option is disabled, you allow userspace (root) access to all
> -	  of memory, including kernel and userspace memory. Accidental
> -	  access to this is obviously disastrous, but specific access can
> -	  be used by people debugging the kernel.
> -
> -	  If this option is switched on, the /dev/mem file only allows
> -	  userspace access to memory mapped peripherals.
> -
> -	  If in doubt, say Y.
> -
>  config PID_IN_CONTEXTIDR
>  	bool "Write the current PID to the CONTEXTIDR register"
>  	help

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
