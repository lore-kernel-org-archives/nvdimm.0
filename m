Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C61B122198F6E
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 09:08:04 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id a42so770457otj.5
 for <linux-nvdimm@lists.01.org>; Thu, 21 Dec 2017 09:12:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171221163055.3943-2-jack@suse.cz>
References: <20171221163055.3943-1-jack@suse.cz>
 <20171221163055.3943-2-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Dec 2017 09:12:52 -0800
Message-ID: <CAPcyv4jYKqEr+y8Uon3ddSvqskAiT_xKMNgnY7=UJkE=3xEM5A@mail.gmail.com>
Subject: Re: [PATCH 1/2] dax: Pass detailed error code from dax_iomap_fault()
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 21, 2017 at 8:30 AM, Jan Kara <jack@suse.cz> wrote:
> Ext4 needs to pass through error from its iomap handler to the page
> fault handler so that it can properly detect ENOSPC and force
> transaction commit and retry the fault (and block allocation). Add
> argument to dax_iomap_fault() for passing such error.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/dax.c            | 9 ++++++---
>  fs/ext2/file.c      | 2 +-
>  fs/ext4/file.c      | 2 +-
>  fs/xfs/xfs_file.c   | 2 +-
>  include/linux/dax.h | 2 +-
>  5 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 95981591977a..f3afa1d6156c 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1096,7 +1096,7 @@ static bool dax_fault_is_synchronous(unsigned long flags,
>  }
>
>  static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
> -                              const struct iomap_ops *ops)
> +                              int *iomap_errp, const struct iomap_ops *ops)
>  {
>         struct vm_area_struct *vma = vmf->vma;
>         struct address_space *mapping = vma->vm_file->f_mapping;
> @@ -1149,6 +1149,8 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>          * that we never have to deal with more than a single extent here.
>          */
>         error = ops->iomap_begin(inode, pos, PAGE_SIZE, flags, &iomap);
> +       if (iomap_errp)
> +               *iomap_errp = error;

Since we already have 'struct iomap' tracking the state of the iomap
should we track the error status there as well?  I.e. move the on
stack allocation of struct iomap to the per-fs dax fault handlers.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
