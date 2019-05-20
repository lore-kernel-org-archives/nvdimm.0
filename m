Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 396B821260512
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 05:54:06 -0700 (PDT)
Date: Mon, 20 May 2019 08:53:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 26/30] fuse: Add logic to free up a memory range
Message-ID: <20190520125355.GA28008@redhat.com>
References: <20190515192715.18000-1-vgoyal@redhat.com>
 <20190515192715.18000-27-vgoyal@redhat.com>
 <CAN+Pk99SNKSf+GjSQUUWt_eu1fSjTy_ByUOEQUXHi8zNqXY1zA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAN+Pk99SNKSf+GjSQUUWt_eu1fSjTy_ByUOEQUXHi8zNqXY1zA@mail.gmail.com>
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
To: Eric Ren <ericdotren@gmail.com>
Cc: kvm@vger.kernel.org, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dgilbert@redhat.com, stefanha@redhat.com, linux-fsdevel@vger.kernel.org, swhiteho@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Sun, May 19, 2019 at 03:48:05PM +0800, Eric Ren wrote:
> Hi,
> 
> @@ -1784,8 +1822,23 @@ static int fuse_iomap_begin(struct inode *inode,
> > loff_t pos, loff_t length,
> >                 if (pos >= i_size_read(inode))
> >                         goto iomap_hole;
> >
> > -               alloc_dmap = alloc_dax_mapping(fc);
> > -               if (!alloc_dmap)
> > +               /* Can't do reclaim in fault path yet due to lock ordering.
> > +                * Read path takes shared inode lock and that's not
> > sufficient
> > +                * for inline range reclaim. Caller needs to drop lock,
> > wait
> > +                * and retry.
> > +                */
> > +               if (flags & IOMAP_FAULT || !(flags & IOMAP_WRITE)) {
> > +                       alloc_dmap = alloc_dax_mapping(fc);
> > +                       if (!alloc_dmap)
> > +                               return -ENOSPC;
> > +               } else {
> > +                       alloc_dmap = alloc_dax_mapping_reclaim(fc, inode);
> >
> 
> alloc_dmap could be NULL as follows:
> 
> alloc_dax_mapping_reclaim
>    -->fuse_dax_reclaim_first_mapping
>              -->fuse_dax_reclaim_first_mapping_locked
>                   --> fuse_dax_interval_tree_iter_first  ==> return NULL
> and
> 
> IS_ERR(NULL) is false, so we may miss that error case.

Hi Eric,

Good catch. I will fix it next version. 

Thanks
Vivek
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
