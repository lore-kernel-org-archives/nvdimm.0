Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256803DC4A3
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776797972; cv=pass; b=SUzwVT+YPFM9VgWk37J+gikfpGIEd/77sc1aenucIHsJD71ZilIzJDFbfIL1TbKqNebeirjw4ostVCsAiueJpwFjWPQj1NvuR40vnU3SAA43nOeru1WyPWuLM0QHTI9YdfjQHSbUDfITMY7AUUWzLWD8b1NcmpSNqRLEo4RKics=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776797972; c=relaxed/simple;
	bh=XjAQR1r0lQrKkLZCrbGbS8NnZb6P2lNtC6R50SuCzPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFCmR6OyVvbhUpeAT3EZRTbA60o3XAzZCs9gFSG4fKQ4lDB2enURY4DZvDOYxOGwYOxofJhWz19nE+MEUsh584xGXMPhDa/1c6kYQ8uqs5FbkAUiYqov1FNjKTV1/X4HZ3dgOKsZ25UnXB5PaLpLL8N2Cmz8w0Is8dP+OQ7oig8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DcCteZIu; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DcCteZIu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso42715035e9.3
        for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 11:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776797968; cv=none;
        d=google.com; s=arc-20240605;
        b=QwllYeBVgFJK/BleoqJ0y8n1h+zfp2nD34947ubkRgMlr6yRJ2PWTthDH8F8TAlypV
         xXtAWbrD3VKjTYi1NyiyzV2M8ZtKc8VzuYMMgeqBrkg3Bo2mJx50UNw8Y6xyYelxAslU
         QHa5FDt5yejtL+q8PXwf99s+B7WheZlknHLcGwXyPCGDcxfBQMsgegQ8LREMvoXsMR56
         UyjC3DvGtxPTFbhLZZS9JR4w2vr2eSzwuNQPlshSRbXIlUgaFGgXbeuNlXaLYw4fIbvk
         3FJLOwQAR6RLr4ZQ465ap2OJ2yzqiUJG2Bijn/w9x9lS6+5wsrsgJd5RJzvoukFViM/+
         wogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0dzmsSkPtY/sR6K+ga+B+dYMUbxHjr7AOGboORaA1jw=;
        fh=VneWclDasyOpeU78eJh4wmtfy/FZeXHt+k3zIuA74TY=;
        b=ZMvVVEIvbaIso2d8GFWFTzc+G4Pb+RDK8T4lrotEzP3xZdtoNcwwbOnr8/FDMgANle
         38oeLJaOF6FzbaYZ1JYm6lXFFRCXq6Ap+mWV2COQOedcdkwtqgvGuSoe3Ehtm7I7TO+L
         uHv6SjDgOohHPGgQ50rZXjIqFcjfNx8WwXoJt8qvWKv2SaF+mbUvE69Rhv0tz8TKTPAj
         1Fk964C9KOcqNPgZvBNyNPAxTr1ic6csAinpmdzve64Iwpjkv19J6+B9RRULbz30RJgs
         VB69gVt9VQU4dtwb9e3jzoK+Y/rzrp3RypjvrrYFsIXh3Hj6MgVQu6x6rX+S51Tdv+xv
         EWLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776797968; x=1777402768; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dzmsSkPtY/sR6K+ga+B+dYMUbxHjr7AOGboORaA1jw=;
        b=DcCteZIuR+5+iOXYfKYeB5cBPcY60oLsEQknLQgZ8/vF7Db8KNHagWm3PgAjP5k5T9
         P+lBE/t1Vb8rqsqp5nPzArGgrw3aRFH1suq1c/AdIoNx66UO+Hx2+S0izE+ISmaa/3cH
         JqAzWOavW3VH2tFkPhiE1903MbX/EWkBYd+syWzJ+W5x1V2TX7KjCkETMi/kvwYylfUo
         xfZKIgAquplpOvx165Ru3xivBn2usd/hauIvWp3WDbUs3eMioL2cdEpUyJ31tCwHEIGp
         agJNR5/h/k/v03sZQLO7Kz+pl5pX3MzA0j+WG7PPZxmfTxDf34QGk6suV2cBVvGfM2/h
         rK1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776797968; x=1777402768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0dzmsSkPtY/sR6K+ga+B+dYMUbxHjr7AOGboORaA1jw=;
        b=GzdQureaohg6x7RktMFBZqGx6v/Ps1tRxOBibNeDyQoN2DGLFWiB0Sk4dYI88S0Z52
         jx1TaoR72ohGcPm3PulxFOcwAuRMqmPEaoo2k2Di7aBu9IRFzRpjXwmBCbzkYSwhI/qE
         d63ww0zz5tBkiExTjE/yPZqbpWHwQ1sjAWq27fV9Bb+g00SoHSWDLYQPxwUKnJnwSBmd
         3K3VRtGif2EhonBrZpjz/cehrxWdkKOOgTO7DCdT1DUTPryOlvn80063dGXZKQuakcaF
         FjENsBMNcM8IT8xKlhE1VD1GLA8/1vu3NdS1NU6iaJbYxl6pU4ijIk5WokyUnEb5OTL7
         4rCw==
X-Forwarded-Encrypted: i=1; AFNElJ+byOK88MyW/EEJgT7KQtOLyQoVWcAyH+UZl00dDMtC8j8qjosy9KCZLIH+1vPhIJAiiXgwVbE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrGt/WggX7tcsJbD3NiGWUGCn3uDI8milvXV2bKPkigR+WwIWa
	qwvkZyBGaERjxEuKgvtbtW/NxJ68uORanqvuilmtkopOKeqNQRfneeQGCjHWuqKLIEzew0iuUdZ
	vj+Ne3dl+OOb1Xt+dGQZD8CXbLwXlWNM=
X-Gm-Gg: AeBDietkrBZPk0ITktusBoQAokUDOE8AmYgynltpMrCL5hVpD+X6kgO2cSI+dDxMbIw
	kRCQgDhPSdLr4wZaI2RSiswOB/aFVcscpuiCMAMJZY1jxQvd/iF0SgbkkjdpInwEnxCq45HeUwU
	7Qtrt+fw/Y/fUO8zKg3EONmpUwvfU5EzdJIVEr5A59Ih4UxZZmAspPz0eBKLPo1YpXMOb3p6kEI
	6K31WIdw1j3mAatA6hsDmU5lWncqYQW6rHCYEyBw2i7WmyEtqcPHtX3uY/e7U7fe4KhMaFNzgpG
	IcGmpGVl8punb/ojI4BFrHnbv58=
X-Received: by 2002:a05:600c:4fd1:b0:488:a824:fdff with SMTP id
 5b1f17b1804b1-488fb782a04mr281702235e9.22.1776797968112; Tue, 21 Apr 2026
 11:59:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F> <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <aeUU8hMwPij2WvfF@groves.net> <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
 <CAJnrk1ZpPS9rOoBqOBRsqTu0Zgk=aoYzpYZ0mAVDCoeewtLhcg@mail.gmail.com> <aeeJ8Lgg2z0X-NC_@gourry-fedora-PF4VCD3F>
In-Reply-To: <aeeJ8Lgg2z0X-NC_@gourry-fedora-PF4VCD3F>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 21 Apr 2026 11:59:15 -0700
X-Gm-Features: AQROBzCRxuv-Mo8vTeVJtIkciXT2taj5PigvXEDVcF1XUKUHVIX85BjGabelR_0
Message-ID: <CAJnrk1Zd2RFE=z=sPRCHaBdqK40+23Vv_owS=7OfxYF1TtPomg@mail.gmail.com>
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

On Tue, Apr 21, 2026 at 7:30=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Mon, Apr 20, 2026 at 08:12:17PM -0700, Joanne Koong wrote:
> > On Sun, Apr 19, 2026 at 5:27=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t> wrote:
> > >
> > >   struct fuse_dax_fmap_ops {
> > >       char name[FUSE_DAX_FMAP_OPS_NAME_LEN];   // 16 bytes
> > >       int (*dax_fmap_parse)(struct fuse_dax_fmap_parse_ctx *ctx);
> >
> > Just a note for later, if the bpf approach gets pursued further:
> > instead of making this a dax specific ops, I think this needs to be
> > integrated interface-wise with Darrick's fuse-iomap work since he does
> > the same thing. I think dax_fmap_parse() could be renamed to something
> > like iomap_setup(), where userspace can use this to do any sort of
> > generic setup, whether that's mapping related or dax related or not.
> > In my mind, the dax vs non dax distinction is handled by the fuse
> > iomap plumbing that chooses which iomap entry points to call,  but
> > beyond that,  the callbacks and struct ops themselves should be
> > generic enough to be shared between the two.
> >
>
> I think this is reasonable.  I'm not a FUSE wizard either, but I would
> presume the iomap_setup() process would just essentially be John's
> existing GET_FMAP / GET_DAXDEV code bundled.
>
> GET_DAXDEV happens lazily to save him the round-trips to userland if the
> DAXDEVs have already been seen previously.  I think your proposal does
> in fact save him further round trips, and it would probably solve the
> performance impact he saw from porting to FUSE.
>
> > > And otherwise, imap_begin() works exactly as Joanne proposed, but wit=
h
> > > in-kernel cached data instead of the bpfmap.
> > >
> > >   const struct dax_simple_meta *meta =3D (const struct dax_simple_met=
a *)
> > >                    bpf_fuse_dax_resolve_get_meta(ctx, 0, sizeof(*meta=
));
> >
> > another note for later, if the benchmarks prove promising and after
> > the LSF discussions we decide to go with this approach: imo we
> > could/should repurpose this into a generic
> > bpf_fuse_iomap_get_inode_meta() that returns a bounded pointer into
> > whatever opaque blob was cached on the inode during iomap_setup(),
> > where it'd be a generic kfunc serving both the dax and non-dax case
> > for any kind of mapping layout
> >
>
> Note that Christian Brauner just said he preferred not having dedicated
> bpf storage in struct inode [1].
>
> sans BPF, is there value in such a metadata blob existing?
>
> If there was a generic format, then I suppose the blob storage would not
> be BPF specific, it would just overload it (simple union).

I'm not sure if this addresses Christian's concerns or not, but the
blob would reside within struct fuse_inode not struct inode. I
definitely agree with him that this should not touch or add any infra
outside fuse.

I hadn't heard of bpf arenas until his comment. If the hashmap
overhead is too high for famfs, having a custom in-arena hash table
would be much faster I think, as it could be designed to require less
pointer chasing and avoid other overhead in the bpf hashmap
implementation, though now famfs would have to manage the data
structure and complexity itself.

Thanks,
Joanne

>
> [1] https://lore.kernel.org/linux-fsdevel/20260421-arsch-gelernt-e0b5bcd8=
a7ff@brauner/T/#m8fea90f5ed4a1b23bdc2563d978948b263b2030b
>
> ~Gregory
