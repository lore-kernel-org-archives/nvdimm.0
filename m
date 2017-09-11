Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87A8120958BEA
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 02:44:20 -0700 (PDT)
Date: Mon, 11 Sep 2017 11:47:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH v8 2/2] mm: introduce MAP_SHARED_VALIDATE, a
 mechanism to safely define new mmap flags
Message-ID: <20170911094714.GD8503@quack2.suse.cz>
References: <150489930202.29460.5141541423730649272.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150489931339.29460.8760855724603300792.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150489931339.29460.8760855724603300792.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Fri 08-09-17 12:35:13, Dan Williams wrote:
> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
> mechanism to define new behavior that is known to fail on older kernels
> without the support. Define a new MAP_SHARED_VALIDATE flag pattern that
> is guaranteed to fail on all legacy mmap implementations.
> 
> With this in place new flags can be defined as:
> 
>     #define MAP_new (MAP_SHARED_VALIDATE | val)

Is this changelog stale? Given MAP_SHARED_VALIDATE will be new mapping
type, I'd expect we define new flags just as any other mapping flags...
I see no reason why MAP_SHARED_VALIDATE should be or'ed to that.

> It is worth noting that the original proposal was for a standalone
> MAP_VALIDATE flag. However, when that  could not be supported by all
> archs Linus observed:
> 
>     I see why you *think* you want a bitmap. You think you want
>     a bitmap because you want to make MAP_VALIDATE be part of MAP_SYNC
>     etc, so that people can do
> 
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED
> 		    | MAP_SYNC, fd, 0);
> 
>     and "know" that MAP_SYNC actually takes.
> 
>     And I'm saying that whole wish is bogus. You're fundamentally
>     depending on special semantics, just make it explicit. It's already
>     not portable, so don't try to make it so.
> 
>     Rename that MAP_VALIDATE as MAP_SHARED_VALIDATE, make it have a value
>     of 0x3, and make people do
> 
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED_VALIDATE
> 		    | MAP_SYNC, fd, 0);
> 
>     and then the kernel side is easier too (none of that random garbage
>     playing games with looking at the "MAP_VALIDATE bit", but just another
>     case statement in that map type thing.
> 
>     Boom. Done.
> 
> Similar to ->fallocate() we also want the ability to validate the
> support for new flags on a per ->mmap() 'struct file_operations'
> instance basis.  Towards that end arrange for flags to be generically
> validated against a mmap_supported_mask exported by 'struct
> file_operations'. By default all existing flags are implicitly
> supported, but new flags require MAP_SHARED_VALIDATE and
> per-instance-opt-in.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/alpha/include/uapi/asm/mman.h           |    1 +
>  arch/mips/include/uapi/asm/mman.h            |    1 +
>  arch/parisc/include/uapi/asm/mman.h          |    1 +
>  arch/xtensa/include/uapi/asm/mman.h          |    1 +
>  include/linux/fs.h                           |    1 +
>  include/linux/mman.h                         |   44 ++++++++++++++++++++++++++
>  include/uapi/asm-generic/mman-common.h       |    1 +
>  mm/mmap.c                                    |   10 +++++-
>  tools/include/uapi/asm-generic/mman-common.h |    1 +
>  9 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
> index 3b26cc62dadb..c32276c4196a 100644
> --- a/arch/alpha/include/uapi/asm/mman.h
> +++ b/arch/alpha/include/uapi/asm/mman.h
> @@ -14,6 +14,7 @@
>  #define MAP_TYPE	0x0f		/* Mask for type of mapping (OSF/1 is _wrong_) */
>  #define MAP_FIXED	0x100		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x10		/* don't use a file */
> +#define MAP_SHARED_VALIDATE (MAP_SHARED|MAP_PRIVATE) /* validate extension flags */

And I'd explicitely define MAP_SHARED_VALIDATE as the first unused value
among mapping types (which is in fact enum embedded inside mapping flags).
I.e. 0x03 on alpha, x86, and probably all other archs - it has nothing to
do with MAP_SHARED|MAP_PRIVATE - it is just another type of the mapping
which happens to have most of the MAP_SHARED semantics...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
