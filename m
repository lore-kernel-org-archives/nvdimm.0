Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E74712034C0BA
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 09:45:20 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id h6so15933696oia.10
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 09:48:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019125817.11580-2-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-2-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 09:48:58 -0700
Message-ID: <CAPcyv4jpHVUamGR=JuK4eUUfFDCWzVmiCMr7K-sTJ2U1TX8uzQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 19, 2017 at 5:58 AM, Jan Kara <jack@suse.cz> wrote:
>
> From: Dan Williams <dan.j.williams@intel.com>
>
> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
> unknown flags. However, proposals like MAP_SYNC need a mechanism to
> define new behavior that is known to fail on older kernels without the
> support. Define a new MAP_SHARED_VALIDATE flag pattern that is
> guaranteed to fail on all legacy mmap implementations.
>
> It is worth noting that the original proposal was for a standalone
> MAP_VALIDATE flag. However, when that  could not be supported by all
> archs Linus observed:
>
>     I see why you *think* you want a bitmap. You think you want
>     a bitmap because you want to make MAP_VALIDATE be part of MAP_SYNC
>     etc, so that people can do
>
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED
>                     | MAP_SYNC, fd, 0);
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
>                     | MAP_SYNC, fd, 0);
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
> validated against a mmap_supported_flags exported by 'struct
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
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  arch/alpha/include/uapi/asm/mman.h           |  1 +
>  arch/mips/include/uapi/asm/mman.h            |  1 +
>  arch/parisc/include/uapi/asm/mman.h          |  1 +
>  arch/xtensa/include/uapi/asm/mman.h          |  1 +
>  include/linux/fs.h                           |  1 +
>  include/linux/mman.h                         | 39 ++++++++++++++++++++++++++++
>  include/uapi/asm-generic/mman-common.h       |  1 +
>  mm/mmap.c                                    | 21 +++++++++++++++
>  tools/include/uapi/asm-generic/mman-common.h |  1 +
>  9 files changed, 67 insertions(+)
>
> diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
> index 3b26cc62dadb..92823f24890b 100644
> --- a/arch/alpha/include/uapi/asm/mman.h
> +++ b/arch/alpha/include/uapi/asm/mman.h
> @@ -14,6 +14,7 @@
>  #define MAP_TYPE       0x0f            /* Mask for type of mapping (OSF/1 is _wrong_) */
>  #define MAP_FIXED      0x100           /* Interpret addr exactly */
>  #define MAP_ANONYMOUS  0x10            /* don't use a file */
> +#define MAP_SHARED_VALIDATE 0x3                /* share + validate extension flags */

Looks good, only comment is your original feedback to move this
definition next to MAP_SHARED a few lines up in the all places where
we define it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
