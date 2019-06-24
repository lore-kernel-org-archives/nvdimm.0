Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com
 [IPv6:2607:f8b0:4864:20::842])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B584212741EC
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jun 2019 10:14:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d17so15249126qtj.8
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jun 2019 10:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <CANQeFDCCGED3BR0oTpzQ75gtGpdGCw8FLf+kspBYytw3YteXAw@mail.gmail.com>
 <20190620083628.GH13630@quack2.suse.cz>
 <CANQeFDB_oSkb_0tBbqoL88UzGf6+FYqjZ3oOo1puSyR7aKtYOA@mail.gmail.com>
 <CAJfpeguGr66Oox27ThPUedDa+rDofehNC1f2gsb_C+eHay1kmg@mail.gmail.com>
 <20190624104106.GC32376@quack2.suse.cz>
In-Reply-To: <20190624104106.GC32376@quack2.suse.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Mon, 24 Jun 2019 10:13:55 -0700
Message-ID: <CANQeFDBYQH5Pxwk17rey6VsCDLV9_g0YX5u=OzcnpoojPveO+w@mail.gmail.com>
Subject: Re: a few questions about pagevc_lookup_entries
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
Cc: linux-nvdimm@lists.01.org, Miklos Szeredi <miklos@szeredi.hu>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Matthew Wilcox <willy@infradead.org>, Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 24, 2019 at 3:41 AM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 24-06-19 09:25:00, Miklos Szeredi wrote:
> > [cc: vivek, stefan, dgilbert]
> >
> > On Fri, Jun 21, 2019 at 12:04 AM Liu Bo <obuil.liubo@gmail.com> wrote:
> > >
> > > On Thu, Jun 20, 2019 at 1:36 AM Jan Kara <jack@suse.cz> wrote:
> > > >
> > > > [added some relevant lists to CC - this can safe some people debugging by
> > > > being able to google this discussion]
> > > >
> > > > On Wed 19-06-19 15:57:38, Liu Bo wrote:
> > > > > I found a weird dead loop within invalidate_inode_pages2_range, the
> > > > > reason being that  pagevec_lookup_entries(index=1) returns an indices
> > > > > array which has only one entry storing value 0, and this has led
> > > > > invalidate_inode_pages2_range() to a dead loop, something like,
> > > > >
> > > > > invalidate_inode_pages2_range()
> > > > >   -> while (pagevec_lookup_entries(index=1, indices))
> > > > >     ->  for (i = 0; i < pagevec_count(&pvec); i++) {
> > > > >       -> index = indices[0]; // index is set to 0
> > > > >       -> if (radix_tree_exceptional_entry(page)) {
> > > > >           -> if (!invalidate_exceptional_entry2()) //
> > > > >                   ->__dax_invalidate_mapping_entry // return 0
> > > > >                      -> // entry marked as PAGECACHE_TAG_DIRTY/TOWRITE
> > > > >                  ret = -EBUSY;
> > > > >           ->continue;
> > > > >           } // end of if (radix_tree_exceptional_entry(page))
> > > > >     -> index++; // index is set to 1
> > > > >
> > > > > The following debug[1] proved the above analysis,  I was wondering if
> > > > > this was a corner case that  pagevec_lookup_entries() allows or a
> > > > > known bug that has been fixed upstream?
> > > > >
> > > > > ps: the kernel in use is 4.19.30 (LTS).
> > > >
> > > > Hum, the above trace suggests you are using DAX. Are you really? Because the
> > > > stacktrace below shows we are working on fuse inode so that shouldn't
> > > > really be DAX inode...
> > > >
> > >
> > > So I was running tests against virtiofs[1] which adds dax support to
> > > fuse, with dax, fuse provides posix stuff while dax provides data
> > > channel.
> > >
> > > [1]: https://virtio-fs.gitlab.io/
> > > https://gitlab.com/virtio-fs/linux
>
> OK, thanks for the explanation and the pointer. So if I should guess, I'd
> say that there's some problem with multiorder entries (for PMD pages) in
> the radix tree. In particular if you lookup index 1 and there's
> multiorder entry for indices 0-511, radix_tree_next_chunk() is updating
> iter->index like:
>
> iter->index = (index &~ node_maxindex(node)) | (offset << node->shift);
>
> and offset is computed by radix_tree_descend() as:
>
> offset = (index >> parent->shift) & RADIX_TREE_MAP_MASK;
>
> So this all results in iter->index being set to 0 and thus confusing the
> iteration in invalidate_inode_pages2_range(). Current kernel has xarray
> code from Matthew which maintains originally passed index in xas.xa_index
> and thus the problem isn't there.
>
> So to sum up: Seems like a DAX-specific bug with PMD entries in older
> kernels fixed by xarray rewrite.
>

Thank you so much for the information, Jan.

I'll double check if that's the root cause and report back, if yes,
guess then we have to fix 4.19's radix tree in place to do the right
thing instead of porting back xarray rewrite..

thanks,
liubo

>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
