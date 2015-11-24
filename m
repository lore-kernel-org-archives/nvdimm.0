Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 24 Nov 2015 09:27:57 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] arch: consolidate CONFIG_STRICT_DEVM in
 lib/Kconfig.debug
Message-ID: <20151124082757.GB23624@gmail.com>
References: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
 <20151123081235.GA23661@gmail.com>
 <CAPcyv4hDbi5KJ+tGJnEwQV5G=PM+ZRooQbgTNrYxyyVVPA3EwA@mail.gmail.com>
 <CAGXu5jLpm7iG17+ws2MfK7ZG9KEDaHWd5xxHSk7KHPyizYEm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLpm7iG17+ws2MfK7ZG9KEDaHWd5xxHSk7KHPyizYEm2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>


* Kees Cook <keescook@chromium.org> wrote:

> On Mon, Nov 23, 2015 at 9:12 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Mon, Nov 23, 2015 at 12:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >>
> >> * Dan Williams <dan.j.williams@intel.com> wrote:
> >>
> >>> Let all the archs that implement CONFIG_STRICT_DEVM use a common
> >>> definition in lib/Kconfig.debug.
> >>
> >> For the x86 bit:
> >>
> >> Acked-by: Ingo Molnar <mingo@kernel.org>
> >>
> >>> Note, the 'depends on !SPARC' is due to sparc not implementing
> >>> devmem_is_allowed().
> >>
> >> Maybe that should be converted into a helper Kconfig switch for architectures to
> >> opt in to /dev/mem restrictions?
> >
> > Sure, easy enough to add a ARCH_HAS_DEVMEM_IS_ALLOWED opt-in.
> 
> Is there some hidden meaning about the difference between ARCH_HAS_...
> and HAVE_ARCH_... and HAVE_... ?

There's also the double underscore variants such as __HAVE_ARCH_STRNCASECMP! ;-)

It's all just nonsensical historic muck: because no-one ever was confronted with 
the messy global picture.

Today you can run Documentation/features/list-arch.sh and wonder at the zoo of 
options ;-)

Thanks,

	Ingo
