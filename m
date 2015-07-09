Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 9 Jul 2015 20:54:41 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v5 2/6] arch: unify ioremap prototypes and macro aliases
Message-ID: <20150709185441.GE7021@wotan.suse.de>
References: <20150622081028.35954.89885.stgit@dwillia2-desk3.jf.intel.com>
 <20150622082427.35954.73529.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150622082427.35954.73529.stgit@dwillia2-desk3.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: arnd@arndb.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, tglx@linutronix.de, ross.zwisler@linux.intel.com, akpm@linux-foundation.org, jgross@suse.com, x86@kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, stefan.bader@canonical.com, luto@amacapital.net, linux-mm@kvack.org, geert@linux-m68k.org, ralf@linux-mips.org, hmh@hmh.eng.br, mpe@ellerman.id.au, tj@kernel.org, paulus@samba.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 04:24:27AM -0400, Dan Williams wrote:
> diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
> index d8f8622fa044..4789b1cec313 100644
> --- a/include/asm-generic/iomap.h
> +++ b/include/asm-generic/iomap.h
> @@ -62,14 +62,6 @@ extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
>  extern void ioport_unmap(void __iomem *);
>  #endif
>  
> -#ifndef ARCH_HAS_IOREMAP_WC
> -#define ioremap_wc ioremap_nocache
> -#endif
> -
> -#ifndef ARCH_HAS_IOREMAP_WT
> -#define ioremap_wt ioremap_nocache
> -#endif
> -
>  #ifdef CONFIG_PCI
>  /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
>  struct pci_dev;

While at it we should also detangle ioremap() variants default implementations
from requiring !CONFIG_MMU, so to be clear, if you have CONFIG_MMU you should
implement ioremap() and iounmap(), then additionally if you have a way to
support an ioremap_*() variant you should do so as well. You can
include asm-generic/iomap.h to help complete ioremap_*() variants you may not
have defined but note below.

***Big fat note**: this however assumes we have a *safe* general ioremap() to
default to for all architectures but for a slew of reasons we cannot have this
today and further discussion is needed to see if it may be possible one day. In
the meantime we must then settle to advocate architecture developers to
provide their own ioremap_*() variant implementations. We can do this two ways:

  1) make new defaults return NULL - to avoid improper behaviour
  2) revisit current default implementations on asm-generic for
     ioremap_*() variants and vet that they are safe for each architecture
     actually using them, if they are safe tuck under each arch its own
     mapping. After all this then convert default to return NULL. This
     will prevent future issues with other architectures.
  3) long term: work towards the lofty objective of defining an architecturally
     sane iorema_*() variant default. This can only be done once all the
     semantics of all the others are well established.

I'll provide a small demo patch with a very specific fix. We can either
address this as separate work prior to your patchset or mesh this work
together.

  Luis

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
