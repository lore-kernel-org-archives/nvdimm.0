Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DB11C5D59
	for <nvdimm@lists.linux.dev>; Mon, 20 Apr 2026 00:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776644832; cv=none; b=ng8sDQKl4/ntMIK2ijdlBtOE65OYOk+eLi1t7NLEFHL0RISNdIoI+SMEIVm/U0fBG/bonIxbBJnNXg7xeSi7Obh9QI2DFBFFrkY6uk8qU1OZqWvE7LYqq1ZfPOzV4PbCCuFOGzIawRmfwVFcCIEj6TWuMGJvwHCaPPWV0onEjj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776644832; c=relaxed/simple;
	bh=jcDub0vbMzoXjGv/GsvA5y2RfAALs2OusUBmV8GXOcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAM2iLf/datVu5RuAQ9lztrNwlCKLt2uCr6efJQNVrIwVaAIZYfQyWRszhEgm4eiDGjptvCV4utFft69KM0SmufALoH94E282aTY7QbiC9VWwqkqS1NjMar+zt547p1PHq85uvDt6Jcu3RdoGijTBF7iUg/rR9qONhPUD63wgQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=LQ11GIOL; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="LQ11GIOL"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a15ebb3abbso41275196d6.1
        for <nvdimm@lists.linux.dev>; Sun, 19 Apr 2026 17:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776644828; x=1777249628; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zrD5eQohrM7vmkJyoHhlIOR1pMETtOYOExt8SJ3jjbA=;
        b=LQ11GIOL0rJ23eDVC+tVGT0HryVyiv1NZt6B5JXXb4v06n84zueraRml8WRrHY2OhL
         1ZC+5u3PCVcCINyK/cCIEHJDCsHKwI80akOql6axLDpucrWQ/yDSus31wrb3da4orcvb
         r0gXBakBsuG0i5WiJt3cikq3pLvJFGTQg39kapCcJ70V5tJLsTMfWGjmq36QhuY5iXvO
         so5Z1DT73YOnUIWwJPo9HOBdxPpIWaeATdONXGyN8UBEACYUyN9Z3WWsdN766iXLzVBN
         zXoDkrzJ0PK4H40E8zD0VJV1RX+TPxP6pAj1TIKqyHe/D+Cp+0qaMFbRUa68iLbondNj
         Ww9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776644828; x=1777249628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrD5eQohrM7vmkJyoHhlIOR1pMETtOYOExt8SJ3jjbA=;
        b=LzbvgOgGyvsqliAFSfymIXcm9xuOyKSAsDaSjTAnhIN6mlS/xG5NBpDgC6sCEe2HHp
         dxnulOVNwspsa4KHNy80XLcScpVlYvZOQkI8xu+V0J7L9tOmzIapdGHVUHh0gVvxiKEg
         AnVadGDJYr7OU/QozZQcBXsR7Rkc6dyNL8cGDp+vEVGOMghalIdKOR8YSPdvjDly3Wdm
         7kvN8Fsy3CFM/B9RlY9lFv6ZiKsyN/MVYjK+KIWr/GE+6r6zHMHG9INNQ0t2uzUNZTHN
         MDHI/dvMQbPAOUkkpo0yu1vw5ifoNsHCuPYELFCHJRiFctn92pHmcZlphhk/0dto/bfY
         JogA==
X-Forwarded-Encrypted: i=1; AFNElJ+AuE6mUWCHypiHMbl4grfq4QU8nXIm+Ozsm2ERQf9iaZRDcCQsZiAyWMz4VJyNaC+jXouViIM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmBMg9VxzWk+mV4/LIpyfflSllj+tLdPoGMxaAtaz6egKL/81H
	0uIJ4H3UKCmIzL8RB4MkSBuo+l0yqUUQLheG8aJ/TJTGVi/t0hsGTlbtWa88jqF4znU=
X-Gm-Gg: AeBDievhrTxRktL7eNmwKRPzNoyJ0CTcXOMGXhtWxw2ssGWJn4p5FwTqTK7FlBy3MJ9
	taCoaRb5L6I2g7oQ9Osq+omWWfnOaN4sl1PpxQvkZCcQie+HsSlP0t9As+FdGg4p4SMlYd1+L6i
	ke5CPuSWf7rejLs+8eYvhWv0IdovyKt+Ts2DaGBtA1SQDc2AbgMv7/T+bHIWWo9BrfakH1NJtLZ
	TSQTj4srm5FxRiggb0qLMhb5MkpEZYvxb3uyd2BT22CfDcte/kEme4oQ6BDGa43wz1FnxTJR2j7
	Dv7uJkbmtYvqrdZU15W4fr56XDAPi7bmwpyfFBrsmFiIQLH92bm8SPUJsS16PQ3lv5nX7AxLVq5
	ehd/wp7GBvVGCor1RmkeXs2JfSyDwQPzHzpur88fMdCuo+YCKhm/qiABrXV6C1bHzkIISaiNlp2
	N9ig+N88xAJVT9Hwh1Kfzon3sH9zrWbWUtXyAAE+SlPWkg61JAH0biiyxy+4Eco4t8GBeevrftB
	zz8QkKvQmUsuPrGRrkYpfw=
X-Received: by 2002:ac8:5ac9:0:b0:50d:7c4b:5c5b with SMTP id d75a77b69052e-50e3682827amr179637411cf.5.1776644828349;
        Sun, 19 Apr 2026 17:27:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-28-184-223.washdc.fios.verizon.net. [108.28.184.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e392c7b26sm71614241cf.5.2026.04.19.17.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 17:27:07 -0700 (PDT)
Date: Sun, 19 Apr 2026 20:27:04 -0400
From: Gregory Price <gourry@gourry.net>
To: John Groves <John@groves.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
References: <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net>
 <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <aeUU8hMwPij2WvfF@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeUU8hMwPij2WvfF@groves.net>

On Sun, Apr 19, 2026 at 03:36:30PM -0500, John Groves wrote:
> On 26/04/15 10:16AM, David Hildenbrand (Arm) wrote:
> > On 4/15/26 00:20, Gregory Price wrote:
> > > On Tue, Apr 14, 2026 at 11:57:40AM -0700, Darrick J. Wong wrote:
> 
> Gregory's code, in the current form, still uses two new fuse messages,
> GET_FMAP and GET_DAXDEV, but it makes the fmap message format opaque by
> removing fmap format structs from the uapi. It also uses two BPF programs.
> One BPF program parses and validates the GET_FMAP payload for every file,
> and hangs it from a 'void *' in each fuse_inode (just like the current famfs
> code). The other BPF program is called during vma faults and reads the 
> fuse_inode->'void *' in order to handle faults the same way famfs-fuse does
> today, but via BPF instead.
> 

I'll just lay out what i've done and why.

For John's sanity, if there are NACKs, knowing sooner rather than later
would be a kindness.

=== Problem: Any lookup() in iomap_begin() is too much overhead.

No dax-backed server will want to eat the cost of a lookup() that
could be multiple microseconds on what should be a 1-5us soft-fault.

Joanne's prototype had this:

   meta = bpf_map_lookup_elem(&inode_map, &nodeid);

But it was offsetting a single pointer dereference:

   struct fuse_inode *fi = get_fuse_inode(inode);
   struct famfs_file_meta *meta = fi->famfs_meta;

Not all O(1) are created equal here.

   A single L3 LLC miss plus page table walk can cost you ~100ns.
   If that pointer was cache-hot, it's almost free.

   A pointer chase through any structure is N x ~100ns.
   This is unlikely to ever be sufficiently cache hot by comparison.

So, lets just avoid this problem altogether.


===  Requirements

1) No hard-coded OMF structures in the FUSE API.

   While RAID0 style interleaving isn't exactly fancy or novel,
   folks think this should not be in the kernel headers.

   (I'm not going to argue, I think the argument is pointless)


2) imap_begin() needs metadata accessible on the order of a single
   pointer dereference - which is what John has implemented.


3) open() needs to validate the metadata and identify DAX devices

   a) it needs to validate the DAX devices are available and
      acquire them / set them up / etc.  This is a kernel-side op.

   b) it needs to validate the addressing information is valid for
      the relevant dax devices

   Both GET_FMAP and GET_DAXDEV are avoided if the metadata is
   already cached or the DAXDEV is already setup.  So keeping these
   separate is actually important.


Joanne's code deals with #1 - but it doesn't handle #2 or #3.
(It also doesn't handle GET_DAXDEV at all).

John's code mananges #2 and #3 by having the fuse-server pass meta data
on open() via GET_FMAP and GET_DAXDEV.

  GET_FMAP acquires the meta data on how dax devices are used

  GET_DAXDEV just translates an ID to specific dax device.
  iomap_being() then uses the OMF to do the mapping.

But it does this by hard-coding the format into kernel headers.


===  Observation: Add a BPF dax_fmap_parse() on open() 

Pair Joanne's suggestion with John's GET_FMAP/GET_DAXDEV operations.

  struct fuse_dax_fmap_ops {
      char name[FUSE_DAX_FMAP_OPS_NAME_LEN];   // 16 bytes
      int (*dax_fmap_parse)(struct fuse_dax_fmap_parse_ctx *ctx);
      int (*iomap_begin)(struct fuse_dax_fmap_resolve_ctx *ctx,
                         struct fuse_iomap_io *io);
  };

This parse function is used to do filesystem specific setup the (such as
populate the dax bitmap) based on filesystem-specific per-file metadata.

In John's case, essentially all it does is populate the dax bitmap and
toss the data onto fi->dax_fmap.meta.

Pseudo code:

  fuse_dax_fmap_open(inode):
      fmap_size = send_GET_FMAP(inode, fmap_buf)

      /* Make space to store the metadata */
      meta_buf = kzalloc(meta_size)
      ctx = { ... }
      kern = { .ctx, .blob = blob, .meta_buf = meta_buf }

      /* Parse the metadata: i.e. fill out the daxdev bitmap */
      fc->dax_fmap_ops->dax_fmap_parse(&ctx)

      /* Call GET_DAXDEV for any new dax devices */
      resolve_dev_bitmap(ctx.dev_bitmap)

      /* cache the meta data on the inode */
      inode_lock()
      fi->dax_fmap.meta      = meta_buf
      ... etc etc ...
      inode_unlock()

And otherwise, imap_begin() works exactly as Joanne proposed, but with
in-kernel cached data instead of the bpfmap.

  const struct dax_simple_meta *meta = (const struct dax_simple_meta *)
                   bpf_fuse_dax_resolve_get_meta(ctx, 0, sizeof(*meta));

And since both parse() and iomap_begin() are bpf programs - and they're
the only consumers of the metadata - FUSE itself no longer needs to know
anything about the server's particular strategy to use the dax devices.

  struct fuse_inode {
      ...
  #if IS_ENABLED(CONFIG_FUSE_DAX_FMAP)
      struct {
          void    *meta;
          u32      meta_size;
          u64      file_size;
      } dax_fmap;
  #endif
  };

Just a big ol' honkin' void* that otherwise gets ignored.

(Note: while i'm not a BPF wizard, this pattern seems well established in
       existing BPF code, i found code in the network stack that caches
       data on kernel objects this way as well)

==== Caveats

1) We don't know the overhead BPF introduces in the fault path.

My napkin math (and best understanding of BPF) suggests:

   1) trampoline / vtable for bpf ops (iomap_begin func)
   2) retpoline cost of BPF (assuming this is on, safe assumption)
   3) bpf_fuse_dax_resolve_get_meta() overhead (extra pointer deref)

This *should* (i think) amount to an extra pointer dereference, a longjump,
and a retpoline, which hopefully is <100ns since any extra pointer
derefs here SHOULD be cache-hot (hard to know).

It's not 0 overhead, and if the average fault time is 1us then every
additional 10ns not an insignificant cost.

But this is napkin math.  John will collect data.


2) FUSE needs to be ok with the BPF-driven changes:

https://github.com/joannekoong/linux/commits/prototype_generic_iomap_dax/


3) FUSE needs to be ok with GET_FMAP/GET_DAXDEV as opaque meta-data
   handlers for DAX devices.

   That means there is no default parser or format. If you don't
   register ops, these functions are functionally dead.

   (probably fine to enforce during init, which is what i did)


4) As John said: MM needs to be good with it.

   Any server using DAX like this already essentially has CAP_SYS_RAWIO
   for DAX, and most likely some form of CAP_SYS_ADMIN.

   Additionally, as folks have pointed out, the resolution to PTE is
   bounded by dax device extents, so it's not entirely arbitrary.

===

As mentioned at the start - you'd be doing John a kindness if there are
clear and obvious NACK's to be had here.

~Gregory
