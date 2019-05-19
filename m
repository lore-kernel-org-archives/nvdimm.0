Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6C742122C317
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 00:48:17 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 145so5271960pgg.9
 for <linux-nvdimm@lists.01.org>; Sun, 19 May 2019 00:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-27-vgoyal@redhat.com>
In-Reply-To: <20190515192715.18000-27-vgoyal@redhat.com>
From: Eric Ren <ericdotren@gmail.com>
Date: Sun, 19 May 2019 15:48:05 +0800
Message-ID: <CAN+Pk99SNKSf+GjSQUUWt_eu1fSjTy_ByUOEQUXHi8zNqXY1zA@mail.gmail.com>
Subject: Re: [PATCH v2 26/30] fuse: Add logic to free up a memory range
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, stefanha@redhat.com, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Hi,

@@ -1784,8 +1822,23 @@ static int fuse_iomap_begin(struct inode *inode,
> loff_t pos, loff_t length,
>                 if (pos >= i_size_read(inode))
>                         goto iomap_hole;
>
> -               alloc_dmap = alloc_dax_mapping(fc);
> -               if (!alloc_dmap)
> +               /* Can't do reclaim in fault path yet due to lock ordering.
> +                * Read path takes shared inode lock and that's not
> sufficient
> +                * for inline range reclaim. Caller needs to drop lock,
> wait
> +                * and retry.
> +                */
> +               if (flags & IOMAP_FAULT || !(flags & IOMAP_WRITE)) {
> +                       alloc_dmap = alloc_dax_mapping(fc);
> +                       if (!alloc_dmap)
> +                               return -ENOSPC;
> +               } else {
> +                       alloc_dmap = alloc_dax_mapping_reclaim(fc, inode);
>

alloc_dmap could be NULL as follows:

alloc_dax_mapping_reclaim
   -->fuse_dax_reclaim_first_mapping
             -->fuse_dax_reclaim_first_mapping_locked
                  --> fuse_dax_interval_tree_iter_first  ==> return NULL
and

IS_ERR(NULL) is false, so we may miss that error case.

> +                       if (IS_ERR(alloc_dmap))
> +                               return PTR_ERR(alloc_dmap);
> +               }


Regards,
Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
