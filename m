Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B0366DB6
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 03:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776741153; cv=pass; b=tExLmPTtITh53vQYw6aTmbp2s19yq1DEszjML96wnELDlamYFMbjo+43N/A2IKIQhwHUOX+gm23HT3S+lyUv7eGe6xwfFfpxyRKbns8YYPG6WxxtAtJR+lUuRlZEezQteDZ4fKP1uyyAz1/Zr4GKQ2K/mlND1HL5npPj+5mZhkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776741153; c=relaxed/simple;
	bh=TB7+xGKrDA/gq1bgPQ89IONDVihb+vSN5EBGdRTMuSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VfcoSgWo/1xUl0x/gGHo9li/qnoJk9YgfDG3xAoaBYvAgG5cJ/+QkdM3ujTGuBD5s6tVaFEEclb2APMYsQayYn+CzH7hr57Ee5oJn9YoTaZw7exnahJbDIbqB41jZcxHycUAW1VNlAOcTQq2qVqxWk87N5wcJFxZDJzBKWOVE/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSOtejE6; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSOtejE6"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d77f6092eso2504158f8f.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Apr 2026 20:12:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776741150; cv=none;
        d=google.com; s=arc-20240605;
        b=alYCx65CEkhA3iL4SyLwd46Uz9+U3YPSXhXwLvm2D8G9qSwc70aTBt/SS5FrVai7pl
         bPYnKCsYgVwnexVrys7x/fpSkcZsVMjRNB/RpDlChx8Df1jekEgqT64hZQEaRPzfaPWS
         tD81DKyXU4rsvrqS0bk9KyhV5VhMrC8qQUX2OC5J9nG0nhnZzl9xAWPM02z1SElLGYYO
         sRXfnMNTrRx8CT2hXsuplYRAD3mUFVev5GHpS2HI6Z7Nr57ZaUWugYo1Afg8GIoxP0JA
         sa8VrH3S+qU/rro9tzaNnb4qb09u4LZLR9hT9Uvrndh0giAWWHQPhIY6Xzp/l7/ULde4
         NzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LZ3Z6vV4CUJEh8+FzQ0fKNGkP73y+YgkoPeSqUJ+lTQ=;
        fh=dTFOFXDuTvAEUY2Qf7BfZi5/1iiuQ/JgaO/tOOZRapY=;
        b=cTgfDTvb8KCxIJmtGlVbPEItykjOWfRdydp39PkG2Gq3qBNh8Nd1bpx6XCZMj8Lm5/
         KeBVmTXCDp2lLP7cqsCNlTcJgO1WCDyAikCsGvF6sERmndHEeDMkD4lGki+pVQKhbJsf
         b/99Z4GrFwqF77b1k7b/CJwA5tPjhAT9FuEdCuIEylYDCBfNIlds+BQKWYWv/jCqEsCm
         MfQTaBKm1lJaCAZzIkauB3ktTW4RSL6SV6WgbMTaywXZrMc1NWsDNlSBlF434RZByL+V
         6vGedNlt+xNbtxzFt5KKxwpX5Gklno/sPHzFYh3bAUu0D2utspKOnGDc63FiMcNDrqga
         rl7A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776741150; x=1777345950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZ3Z6vV4CUJEh8+FzQ0fKNGkP73y+YgkoPeSqUJ+lTQ=;
        b=jSOtejE6dUJQcwtwsaPuTW28wA0V3YswlDmz+E+xGIeWRyq1anma7NH9P/zgs9wp35
         9seRtmj4hFI10KTjRfdX40Zr1CQHN+naHw+rj1TY4jTQuKMziWd1ctmKNmJJZn9dGWgU
         iVv9+Aza2UjYor1hKrY2TZZccUBiqE16JBj9EXiycbdhPb2FGq92L+hOZfz5snXlpl+7
         GVrXAQlXhEA5cJT8+imQVqOI3vDDF2zUYs02U8KY7aevmDFLM+xfGXt1bZBKhkmtDEIS
         TcxHXoijjLeA1bAktN8IyRHF6nfC3+DyDgCwIY4UIutKnpyG6Nr6eZImePicWeSAFaRZ
         OJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776741150; x=1777345950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZ3Z6vV4CUJEh8+FzQ0fKNGkP73y+YgkoPeSqUJ+lTQ=;
        b=PVL2wn0WE2IDtUIj85o5Y/kwr6V720QlwacdG+JPivWhXpOFpnEqx3YLB9t4YfdkEd
         l3S2YzXJHJNG+T5qWfZfFrq2jV7wZuFyKSk9ZX9YfH5hPAQtRJngkGyiU9+WFQvB7uFO
         iTDlrJHUAwngurbvwwKoveAoNTyDb+PehqvXTWGzHXA8xDS1oYU7MAkUP0JX32fQIPCP
         6KpKT8ENXPqZ1nlLZ64zKUWAgX5oGrntKGUmVAWtJ1Q/MgyhaoTWRQ4Gd2tVumXMDxl+
         LkH/cFMmDQkYmiWAATxBgqTe31mG004Fd8CraQKjE4osIL0IESsVSCvMVCLyyOyP7vMX
         qm9g==
X-Forwarded-Encrypted: i=1; AFNElJ8wWvyPXH7cJv+/sPMAiI6O79zrghDjpe/giFuSbLmVF5II88cW5v6pUV8czQI1vqUe7kFBL9w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBc7FARf2n9BJzNXpza4zFy+38ylRFoFQeab1QpYo2t017FwT8
	lFxsWJigJl9EWh9hGL/V0E1d0sr7w5Y0TOJBLWMqgj2XO4zT2kJBkupdbSfK+ITJpPKjMdor/+7
	n2oMnzMHDQcYpc3R6Bp0ZzhQThl5g14E=
X-Gm-Gg: AeBDiesxhirZ86vsOD2IQEjIRjlHsItVlY8z3EF3tsFIAdRF3xY3uNh/fV8n6QqKDGH
	oPGrEfhi7eA9eRYZ5OQMt86gXQH9OKtLcFDTsIGAht4pLFnNHckCQXn20KF3z9Lj075nh/57f7v
	sv6LLB3bHuJMyiM39PG00GpMzNOZHau1WEmq0K9jousEZewSum+6iiNvdFByoSEJtckJrOiAP3+
	H9Z4rW3WeYHKXkRQweugSXqxpqzWlSJHx9czRDkjcVG3wlPWLrrN3neCFNAwVbEhv7RQQ3xS1vp
	unYXnUdi2pLkp0oE
X-Received: by 2002:a05:6000:2282:b0:43d:7a97:78a2 with SMTP id
 ffacd0b85a97d-43fe3e09218mr24740414f8f.28.1776741149536; Mon, 20 Apr 2026
 20:12:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F> <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <aeUU8hMwPij2WvfF@groves.net> <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
In-Reply-To: <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 20 Apr 2026 20:12:17 -0700
X-Gm-Features: AQROBzCXrJPeZRWF5tNFcpUVaUlS3AP6Uy-uF-YDGWgd26fL7TVr2aqUE1sGo-8
Message-ID: <CAJnrk1ZpPS9rOoBqOBRsqTu0Zgk=aoYzpYZ0mAVDCoeewtLhcg@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Gregory Price <gourry@gourry.net>
Cc: John Groves <John@groves.net>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 19, 2026 at 5:27=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sun, Apr 19, 2026 at 03:36:30PM -0500, John Groves wrote:
> > On 26/04/15 10:16AM, David Hildenbrand (Arm) wrote:
> > > On 4/15/26 00:20, Gregory Price wrote:
> > > > On Tue, Apr 14, 2026 at 11:57:40AM -0700, Darrick J. Wong wrote:
> >
> > Gregory's code, in the current form, still uses two new fuse messages,
> > GET_FMAP and GET_DAXDEV, but it makes the fmap message format opaque by
> > removing fmap format structs from the uapi. It also uses two BPF progra=
ms.
> > One BPF program parses and validates the GET_FMAP payload for every fil=
e,
> > and hangs it from a 'void *' in each fuse_inode (just like the current =
famfs
> > code). The other BPF program is called during vma faults and reads the
> > fuse_inode->'void *' in order to handle faults the same way famfs-fuse =
does
> > today, but via BPF instead.
> >
>

Thanks John for running the benchmarks on your hardware. And thanks
Gregory for your work on this too.

> I'll just lay out what i've done and why.
>
> For John's sanity, if there are NACKs, knowing sooner rather than later
> would be a kindness.
>
> =3D=3D=3D Problem: Any lookup() in iomap_begin() is too much overhead.
>
> No dax-backed server will want to eat the cost of a lookup() that
> could be multiple microseconds on what should be a 1-5us soft-fault.
>
> Joanne's prototype had this:
>
>    meta =3D bpf_map_lookup_elem(&inode_map, &nodeid);
>
> But it was offsetting a single pointer dereference:
>
>    struct fuse_inode *fi =3D get_fuse_inode(inode);
>    struct famfs_file_meta *meta =3D fi->famfs_meta;
>
> Not all O(1) are created equal here.
>
>    A single L3 LLC miss plus page table walk can cost you ~100ns.
>    If that pointer was cache-hot, it's almost free.
>
>    A pointer chase through any structure is N x ~100ns.
>    This is unlikely to ever be sufficiently cache hot by comparison.
>
> So, lets just avoid this problem altogether.
>
>
> =3D=3D=3D  Requirements
>
> 1) No hard-coded OMF structures in the FUSE API.
>
>    While RAID0 style interleaving isn't exactly fancy or novel,
>    folks think this should not be in the kernel headers.
>
>    (I'm not going to argue, I think the argument is pointless)
>
>
> 2) imap_begin() needs metadata accessible on the order of a single
>    pointer dereference - which is what John has implemented.
>
>
> 3) open() needs to validate the metadata and identify DAX devices
>
>    a) it needs to validate the DAX devices are available and
>       acquire them / set them up / etc.  This is a kernel-side op.
>
>    b) it needs to validate the addressing information is valid for
>       the relevant dax devices
>
>    Both GET_FMAP and GET_DAXDEV are avoided if the metadata is
>    already cached or the DAXDEV is already setup.  So keeping these
>    separate is actually important.
>
>
> Joanne's code deals with #1 - but it doesn't handle #2 or #3.
> (It also doesn't handle GET_DAXDEV at all).

It handles #3 by removing GET_DAXDEV as a fuse op and having the
daxdev initialization / setup routed through FUSE_IOMAP_CONFIG at
iomap initialization time instead, which integrates with the generic
iomap infrastruture/uapi additions Darrick added in his fuse-iomap
series [1].

In this series the GET_DAXDEV op gets sent lazily on file opens but
it's still not clear to me why this is necessary. imo device setup
should happen logically as part of iomap configuration and it seems
more efficient to have devices validated/acquired before any files are
opened. I thihnk that makes things a lot simpler on the kernel side in
other ways (eg we can get rid of famfs_dax_devlist / famfs_daxdev /
famfs_devlist_sem / famfs_update_daxdev_table() /
famfs_fuse_get_daxdev() altogether). It also saves the famfs server
the roundtrip context switching cost if we get rid of GET_DAXDEV and
move it to iomap initialization time, which will improve FUSE_OPEN
performance for famfs. Maybe there's something I'm missing here as to
why the daxdev initialization has to be done lazily on open?

I think Darrick had also mentioned something earlier about how he
thinks GET_DAXDEV should be another application of backing files [2] -
I like this idea too, as it gets rid of the GET_DAXDEV op and reuses
fuse's existing infrastructure.

[1] https://lore.kernel.org/linux-fsdevel/177188734695.3935739.819885401100=
4837207.stgit@frogsfrogsfrogs/
[2] https://lore.kernel.org/linux-fsdevel/20260416224331.GD114184@frogsfrog=
sfrogs/

>
> John's code mananges #2 and #3 by having the fuse-server pass meta data
> on open() via GET_FMAP and GET_DAXDEV.
>
>   GET_FMAP acquires the meta data on how dax devices are used
>
>   GET_DAXDEV just translates an ID to specific dax device.
>   iomap_being() then uses the OMF to do the mapping.
>
> But it does this by hard-coding the format into kernel headers.
>
>
> =3D=3D=3D  Observation: Add a BPF dax_fmap_parse() on open()
>
> Pair Joanne's suggestion with John's GET_FMAP/GET_DAXDEV operations.
>
>   struct fuse_dax_fmap_ops {
>       char name[FUSE_DAX_FMAP_OPS_NAME_LEN];   // 16 bytes
>       int (*dax_fmap_parse)(struct fuse_dax_fmap_parse_ctx *ctx);

Just a note for later, if the bpf approach gets pursued further:
instead of making this a dax specific ops, I think this needs to be
integrated interface-wise with Darrick's fuse-iomap work since he does
the same thing. I think dax_fmap_parse() could be renamed to something
like iomap_setup(), where userspace can use this to do any sort of
generic setup, whether that's mapping related or dax related or not.
In my mind, the dax vs non dax distinction is handled by the fuse
iomap plumbing that chooses which iomap entry points to call,  but
beyond that,  the callbacks and struct ops themselves should be
generic enough to be shared between the two.

>       int (*iomap_begin)(struct fuse_dax_fmap_resolve_ctx *ctx,
>                          struct fuse_iomap_io *io);
>   };
>
> This parse function is used to do filesystem specific setup the (such as
> populate the dax bitmap) based on filesystem-specific per-file metadata.
>
> In John's case, essentially all it does is populate the dax bitmap and
> toss the data onto fi->dax_fmap.meta.
>
> Pseudo code:
>
>   fuse_dax_fmap_open(inode):
>       fmap_size =3D send_GET_FMAP(inode, fmap_buf)
>
>       /* Make space to store the metadata */
>       meta_buf =3D kzalloc(meta_size)
>       ctx =3D { ... }
>       kern =3D { .ctx, .blob =3D blob, .meta_buf =3D meta_buf }
>
>       /* Parse the metadata: i.e. fill out the daxdev bitmap */
>       fc->dax_fmap_ops->dax_fmap_parse(&ctx)
>
>       /* Call GET_DAXDEV for any new dax devices */
>       resolve_dev_bitmap(ctx.dev_bitmap)
>
>       /* cache the meta data on the inode */
>       inode_lock()
>       fi->dax_fmap.meta      =3D meta_buf
>       ... etc etc ...
>       inode_unlock()
>
> And otherwise, imap_begin() works exactly as Joanne proposed, but with
> in-kernel cached data instead of the bpfmap.
>
>   const struct dax_simple_meta *meta =3D (const struct dax_simple_meta *)
>                    bpf_fuse_dax_resolve_get_meta(ctx, 0, sizeof(*meta));

another note for later, if the benchmarks prove promising and after
the LSF discussions we decide to go with this approach: imo we
could/should repurpose this into a generic
bpf_fuse_iomap_get_inode_meta() that returns a bounded pointer into
whatever opaque blob was cached on the inode during iomap_setup(),
where it'd be a generic kfunc serving both the dax and non-dax case
for any kind of mapping layout

>
> And since both parse() and iomap_begin() are bpf programs - and they're
> the only consumers of the metadata - FUSE itself no longer needs to know
> anything about the server's particular strategy to use the dax devices.
>
>   struct fuse_inode {
>       ...
>   #if IS_ENABLED(CONFIG_FUSE_DAX_FMAP)
>       struct {
>           void    *meta;
>           u32      meta_size;
>           u64      file_size;

I don't think file_size is needed here? seems like we could just
derive this from i_size_read(inode)?

>       } dax_fmap;

/s/dax_fmap/iomap

>   #endif
>   };
>
> Just a big ol' honkin' void* that otherwise gets ignored.
>
> (Note: while i'm not a BPF wizard, this pattern seems well established in
>        existing BPF code, i found code in the network stack that caches
>        data on kernel objects this way as well)
>
> =3D=3D=3D=3D Caveats
>
> 1) We don't know the overhead BPF introduces in the fault path.
>
> My napkin math (and best understanding of BPF) suggests:
>
>    1) trampoline / vtable for bpf ops (iomap_begin func)
>    2) retpoline cost of BPF (assuming this is on, safe assumption)
>    3) bpf_fuse_dax_resolve_get_meta() overhead (extra pointer deref)
>
> This *should* (i think) amount to an extra pointer dereference, a longjum=
p,
> and a retpoline, which hopefully is <100ns since any extra pointer
> derefs here SHOULD be cache-hot (hard to know).
>
> It's not 0 overhead, and if the average fault time is 1us then every
> additional 10ns not an insignificant cost.
>
> But this is napkin math.  John will collect data.
>
>
> 2) FUSE needs to be ok with the BPF-driven changes:
>
> https://github.com/joannekoong/linux/commits/prototype_generic_iomap_dax/
>
>
> 3) FUSE needs to be ok with GET_FMAP/GET_DAXDEV as opaque meta-data
>    handlers for DAX devices.

I think we could kill GET_DAXDEV and for GET_FMAP, we could make this
a generic FUSE_IOMAP_GETMAP where the server can set a flag on open to
indicate whether the mapping blob should be fetched or not.
>
>    That means there is no default parser or format. If you don't
>    register ops, these functions are functionally dead.
>
>    (probably fine to enforce during init, which is what i did)
>
>
> 4) As John said: MM needs to be good with it.
>
>    Any server using DAX like this already essentially has CAP_SYS_RAWIO
>    for DAX, and most likely some form of CAP_SYS_ADMIN.
>
>    Additionally, as folks have pointed out, the resolution to PTE is
>    bounded by dax device extents, so it's not entirely arbitrary.
>
> =3D=3D=3D
>
> As mentioned at the start - you'd be doing John a kindness if there are
> clear and obvious NACK's to be had here.

I don't have a NACK on what you wrote above, thank you for your work
on this and bridging it into John's famfs server.

As I understand it, Amir also scheduled a cross-track FS+MM+IO session
at LSF to discuss famfs and dax iomap. Christoph had posted a
suggestion in another message about solving this problem with adding
generic stride/offset multi-device support to fs/iomap, and I'm hoping
the LSF session will shed more light on this, as that to me seems the
cleanest solution and would pretty much give everyone what they want
(including getting famfs unblocked, as I think with this approach we
would just need to figure out the generic stride/offset format for the
fuse iomap uapi, and could have the interleaving logic living in fuse
initially with fs/iomap migrations done post-merge). In the meantime,
I think it's really helpful getting the data points on how bpf
performs, thank you for running the benchmarks on your setup, John.

Thanks,
Joanne
>
> ~Gregory
