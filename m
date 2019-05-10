Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A51A21C93EDD
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 08:41:38 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g18so5731746otj.11
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 08:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190429172649.8288-13-rgoldwyn@suse.de>
 <20190510153222.24665-1-kilobyte@angband.pl>
In-Reply-To: <20190510153222.24665-1-kilobyte@angband.pl>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 May 2019 08:41:25 -0700
Message-ID: <CAPcyv4jPF70QECzpgDCwzasJT38eOqG9tfQRbo37OWg+YzGu_w@mail.gmail.com>
Subject: Re: [PATCH for-goldwyn] btrfs: disallow MAP_SYNC outside of DAX mounts
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
To: Adam Borowski <kilobyte@angband.pl>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, nborisov@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 10, 2019 at 8:33 AM Adam Borowski <kilobyte@angband.pl> wrote:
>
> Even if allocation is done synchronously, data would be lost except on
> actual pmem.  Explicit msync()s don't need MAP_SYNC, and don't require
> a sync per page.
>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> MAP_SYNC can't be allowed unconditionally, as cacheline flushes don't help
> guarantee persistency in page cache.  This fixes an error in my earlier
> patch "btrfs: allow MAP_SYNC mmap" -- you'd probably want to amend that.
>
>
>  fs/btrfs/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 362a9cf9dcb2..0bc5428037ba 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2233,6 +2233,13 @@ static int btrfs_file_mmap(struct file   *filp, struct vm_area_struct *vma)
>         if (!IS_DAX(inode) && !mapping->a_ops->readpage)
>                 return -ENOEXEC;
>
> +       /*
> +        * Normal operation of btrfs is pretty much an antithesis of MAP_SYNC;
> +        * supporting it outside DAX is pointless.
> +        */
> +       if (!IS_DAX(inode) && (vma->vm_flags & VM_SYNC))
> +               return -EOPNOTSUPP;
> +

If the virtio-pmem patch set goes upstream prior to btrfs-dax support
this will need to switch over to the new daxdev_mapping_supported()
helper.

https://lore.kernel.org/lkml/20190426050039.17460-5-pagupta@redhat.com/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
