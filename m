Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 448A221DFC87C
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 10:25:56 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id u207so26841163ywc.3
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 10:28:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150286944610.8837.9513410258028246174.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150286946864.8837.17147962029964281564.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Aug 2017 10:28:21 -0700
Message-ID: <CAPcyv4i+GbwcqMwKscTmTAuoXnQNfqBtHsxUu-L0+NzNO2f4Lw@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] fs, xfs: introduce MAP_DIRECT for creating
 block-map-atomic file ranges
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 16, 2017 at 12:44 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> MAP_DIRECT is an mmap(2) flag with the following semantics:
>
>   MAP_DIRECT
>   When specified with MAP_SHARED a successful fault in this range
>   indicates that the kernel is maintaining the block map (user linear
>   address to file offset to physical address relationship) in a manner
>   that no external agent can observe any inconsistent changes. In other
>   words, the block map of the mapping is effectively pinned, or the kernel
>   is otherwise able to exchange a new physical extent atomically with
>   respect to any hardware / software agent. As implied by this definition
>   a successful fault in a MAP_DIRECT range bypasses kernel indirections
>   like the page-cache, and all updates are carried directly through to the
>   underlying file physical blocks (modulo cpu cache effects).
>
>   ETXTBSY may be returned to any third party operation on the file that
>   attempts to update the block map (allocate blocks / convert unwritten
>   extents / break shared extents). However, whether a filesystem returns
>   EXTBSY for a certain state of the block relative to a MAP_DIRECT mapping
>   is filesystem and kernel version dependent.
>
>   Some filesystems may extend these operation restrictions outside the
>   mapped range and return ETXTBSY to any file operations that might mutate
>   the block map. MAP_DIRECT faults may fail with a SIGBUS if the
>   filesystem needs to write the block map to satisfy the fault. For
>   example, if the mapping was established over a hole in a sparse file.
>
>   ERRORS
>   EACCES A MAP_DIRECT mapping was requested and PROT_WRITE was not set,
>   or the requesting process is missing CAP_LINUX_IMMUTABLE.
>
>   EINVAL MAP_ANONYMOUS or MAP_PRIVATE was specified with MAP_DIRECT.
>
>   EOPNOTSUPP The filesystem explicitly does not support the flag
>
>   SIGBUS Attempted to write a MAP_DIRECT mapping at a file offset that
>          might require block-map updates.
>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
[..]
> diff --git a/include/linux/mman.h b/include/linux/mman.h
> index 0e1de42c836f..7c9e3d11027f 100644
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -7,16 +7,6 @@
>  #include <linux/atomic.h>
>  #include <uapi/linux/mman.h>
>
> -#ifndef MAP_32BIT
> -#define MAP_32BIT 0
> -#endif
> -#ifndef MAP_HUGE_2MB
> -#define MAP_HUGE_2MB 0
> -#endif
> -#ifndef MAP_HUGE_1GB
> -#define MAP_HUGE_1GB 0
> -#endif

This was inadvertent, we need this to build on non-x86 archs, will fix.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
