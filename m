Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3673921E14532
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 02:16:15 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id q189so837818wmd.0
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 02:18:39 -0700 (PDT)
Date: Tue, 15 Aug 2017 12:18:36 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Message-ID: <20170815091836.c3xpsfgfwz7w35od@node.shutemov.name>
References: <150277752553.23945.13932394738552748440.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, darrick.wong@oracle.com, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 14, 2017 at 11:12:22PM -0700, Dan Williams wrote:
> MAP_DIRECT is an mmap(2) flag with the following semantics:
> 
>   MAP_DIRECT
>   In addition to this mapping having MAP_SHARED semantics, successful
>   faults in this range may assume that the block map (logical-file-offset
>   to physical memory address) is pinned for the lifetime of the mapping.
>   Successful MAP_DIRECT faults establish mappings that bypass any kernel
>   indirections like the page-cache. All updates are carried directly
>   through to the underlying file physical blocks (modulo cpu cache
>   effects).
> 
>   ETXTBSY is returned on attempts to change the block map (allocate blocks
>   / convert unwritten extents / break shared extents) in the mapped range.
>   Some filesystems may extend these same restrictions outside the mapped
>   range and return ETXTBSY to any file operations that might mutate the
>   block map. MAP_DIRECT faults may fail with a SIGSEGV if the filesystem
>   needs to write the block map to satisfy the fault. For example, if the
>   mapping was established over a hole in a sparse file.

We had issues before with user-imposed ETXTBSY. See MAP_DENYWRITE.

Are we sure it won't a source of denial-of-service attacks?

>   The kernel ignores attempts to mark a MAP_DIRECT mapping MAP_PRIVATE and
>   will silently fall back to MAP_SHARED semantics.

Hm.. Any reason for this strage behaviour? Looks just broken to me.

> 
>   ERRORS
>   EACCES A MAP_DIRECT mapping was requested and PROT_WRITE was not set.
> 
>   EINVAL MAP_ANONYMOUS was specified with MAP_DIRECT.
> 
>   EOPNOTSUPP The filesystem explicitly does not support the flag
> 
>   SIGSEGV Attempted to write a MAP_DIRECT mapping at a file offset that
>           might require block-map updates.

I think it should be SIGBUS.

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
