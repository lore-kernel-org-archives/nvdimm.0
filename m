Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151122035707.9313.59919.stgit@dwillia2-desk3.jf.intel.com>
References: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
	<20151122035707.9313.59919.stgit@dwillia2-desk3.jf.intel.com>
Date: Mon, 23 Nov 2015 11:00:45 -0800
Message-ID: <CAGXu5jLpZLRbhK2+TuKhcDSujR91662SGLkTwC-mQCT8fFQ_1w@mail.gmail.com>
Subject: Re: [PATCH 2/2] restrict /dev/mem to idle io memory ranges
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Nov 21, 2015 at 7:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> This effectively promotes IORESOURCE_BUSY to IORESOURCE_EXCLUSIVE
> semantics by default.  If userspace really believes it is safe to access
> the memory region it can also perform the extra step of disabling an
> active driver.  This protects device address ranges with read side
> effects and otherwise directs userspace to use the driver.
>
> Persistent memory presents a large "mistake surface" to /dev/mem as now
> accidental writes can corrupt a filesystem.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  kernel/resource.c |    3 +++
>  lib/Kconfig.debug |   23 ++++++++++++++++++++---
>  2 files changed, 23 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index f150dbbe6f62..03a8b09f68a8 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1498,6 +1498,9 @@ int iomem_is_exclusive(u64 addr)
>                         break;
>                 if (p->end < addr)
>                         continue;
> +               if (IS_ENABLED(CONFIG_IO_STRICT_DEVMEM)
> +                               && p->flags & IORESOURCE_BUSY)
> +                       break;
>                 if (p->flags & IORESOURCE_BUSY &&
>                      p->flags & IORESOURCE_EXCLUSIVE) {
>                         err = 1;
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index ad85145d0047..be47f99fb191 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1866,9 +1866,26 @@ config STRICT_DEVMEM
>           enabled, even in this case there are restrictions on /dev/mem
>           use due to the cache aliasing requirements.
>
> +         If this option is switched on, and IO_STRICT_DEVMEM=n, the /dev/mem
> +         file only allows userspace access to PCI space and the BIOS code and
> +         data regions.  This is sufficient for dosemu and X and all common
> +         users of /dev/mem.
> +
> +         If in doubt, say Y.
> +
> +config IO_STRICT_DEVMEM
> +       bool "Filter I/O access to /dev/mem"
> +       depends on STRICT_DEVMEM
> +       default STRICT_DEVMEM
> +       ---help---
> +         If this option is disabled, you allow userspace (root) access to all
> +         io-memory regardless of whether a driver is actively using that
> +         range.  Accidental access to this is obviously disastrous, but
> +         specific access can be used by people debugging kernel drivers.
> +
>           If this option is switched on, the /dev/mem file only allows
> -         userspace access to PCI space and the BIOS code and data regions.
> -         This is sufficient for dosemu and X and all common users of
> -         /dev/mem.
> +         userspace access to *idle* io-memory ranges (see /proc/iomem) This
> +         may break traditional users of /dev/mem (dosemu, legacy X, etc...)
> +         if the driver using a given range cannot be disabled.
>
>           If in doubt, say Y.
>



-- 
Kees Cook
Chrome OS Security
