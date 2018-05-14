Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr0-x244.google.com (mail-wr0-x244.google.com
 [IPv6:2a00:1450:400c:c0c::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E897A207E634A
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 00:26:07 -0700 (PDT)
Received: by mail-wr0-x244.google.com with SMTP id v5-v6so11101949wrf.9
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 00:26:07 -0700 (PDT)
Date: Mon, 14 May 2018 09:26:03 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: use memcpy_mcsafe() for copy_to_iter() (was: Re: [PATCH v3 0/9]
 Series short description)
Message-ID: <20180514072603.GA14099@gmail.com>
References: <CAPcyv4g5p72aiXYh8Tf03tvZq8HNYmTFU95PJGG1iQ4JHcr9PA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g5p72aiXYh8Tf03tvZq8HNYmTFU95PJGG1iQ4JHcr9PA@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Ingo, Thomas, Al, any concerns with this series?

Yeah, so:

   "[PATCH v3 0/9] Series short description"

... isn't the catchiest of titles to capture my [all too easily distracted] 
attention! ;-)

I have marked it now for -tip processing. Linus was happy with this and acked the 
approach, right?

Thanks,

	Ingo

> 
> On Thu, May 3, 2018 at 5:06 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > Changes since v2 [1]:
> >
> > * Fix source address increment in mcsafe_handle_tail() (Mika)
> >
> > * Extend the unit test to inject simulated write faults and validate
> >   that data is properly transferred.
> >
> > * Rename MCSAFE_DEBUG to MCSAFE_TEST
> >
> > [1]: https://lists.01.org/pipermail/linux-nvdimm/2018-May/015583.html
> >
> > ---
> >
> > Currently memcpy_mcsafe() is only deployed in the pmem driver when
> > reading through a /dev/pmemX block device. However, a filesystem in dax
> > mode mounted on a /dev/pmemX block device will bypass the block layer
> > and the driver for reads. The filesystem-dax (fsdax) read case uses
> > dax_direct_access() and copy_to_iter() to bypass the block layer.
> >
> > The result of the bypass is that the kernel treats machine checks during
> > read as system fatal (reboot) when they could simply be flagged as an
> > I/O error, similar to performing reads through the pmem driver. Prevent
> > this fatal condition by deploying memcpy_mcsafe() in the fsdax read
> > path.
> >
> > The main differences between this copy_to_user_mcsafe() and
> > copy_user_generic_unrolled() are:
> >
> > * Typical tail/residue handling after a fault retries the copy
> >   byte-by-byte until the fault happens again. Re-triggering machine
> >   checks is potentially fatal so the implementation uses source alignment
> >   and poison alignment assumptions to avoid re-triggering machine
> >   checks.
> >
> > * SMAP coordination is handled external to the assembly with
> >   __uaccess_begin() and __uaccess_end().
> >
> > * ITER_KVEC and ITER_BVEC can now end prematurely with an error.
> >
> > The new MCSAFE_TEST facility is proposed as a way to unit test the
> > exception handling without requiring an ACPI EINJ capable platform.
> >
> > ---
> >
> > Dan Williams (9):
> >       x86, memcpy_mcsafe: remove loop unrolling
> >       x86, memcpy_mcsafe: add labels for write fault handling
> >       x86, memcpy_mcsafe: return bytes remaining
> >       x86, memcpy_mcsafe: add write-protection-fault handling
> >       x86, memcpy_mcsafe: define copy_to_iter_mcsafe()
> >       dax: introduce a ->copy_to_iter dax operation
> >       dax: report bytes remaining in dax_iomap_actor()
> >       pmem: switch to copy_to_iter_mcsafe()
> >       x86, nfit_test: unit test for memcpy_mcsafe()
> >
> >
> >  arch/x86/Kconfig                   |    1
> >  arch/x86/Kconfig.debug             |    3 +
> >  arch/x86/include/asm/mcsafe_test.h |   75 ++++++++++++++++++++++++
> >  arch/x86/include/asm/string_64.h   |   10 ++-
> >  arch/x86/include/asm/uaccess_64.h  |   14 +++++
> >  arch/x86/lib/memcpy_64.S           |  112 +++++++++++++++++-------------------
> >  arch/x86/lib/usercopy_64.c         |   21 +++++++
> >  drivers/dax/super.c                |   10 +++
> >  drivers/md/dm-linear.c             |   16 +++++
> >  drivers/md/dm-log-writes.c         |   15 +++++
> >  drivers/md/dm-stripe.c             |   21 +++++++
> >  drivers/md/dm.c                    |   25 ++++++++
> >  drivers/nvdimm/claim.c             |    3 +
> >  drivers/nvdimm/pmem.c              |   13 +++-
> >  drivers/s390/block/dcssblk.c       |    7 ++
> >  fs/dax.c                           |   21 ++++---
> >  include/linux/dax.h                |    5 ++
> >  include/linux/device-mapper.h      |    5 +-
> >  include/linux/string.h             |    4 +
> >  include/linux/uio.h                |   15 +++++
> >  lib/iov_iter.c                     |   61 ++++++++++++++++++++
> >  tools/testing/nvdimm/test/nfit.c   |  104 +++++++++++++++++++++++++++++++++
> >  22 files changed, 482 insertions(+), 79 deletions(-)
> >  create mode 100644 arch/x86/include/asm/mcsafe_test.h
> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm@lists.01.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
