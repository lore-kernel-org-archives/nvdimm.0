Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70698283FD9
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 07:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751702352; cv=none; b=s7RZQnYY7p2p3ODg+lyDsTpEddyUtowxP5LXNMH3VV3c99fq6VVFMngmBAI18pUgMSu1QfcQIsXTKxGOfynrW61K0U3zPF6bUwDcNwhtj1FHwUwrQOhsnIDv7SsYmv2/4iCiLG+Tz2RxFfFWTvZIqdSnUYn6ThCIcQHE19hm8hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751702352; c=relaxed/simple;
	bh=MyvvlUkjHpDb25gllFrtgrhNwHVoB15nnK/0nLDzEpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OrQhL+aNYwdbmxeDHvAkD+Wfo0lJUuYW8Dllye8JV/YmNE0BpUtFiqQkhP1fAKI15I1SAH7NZpxCRft2MFoQc4jHIKr2KeJ+DsPOYkZPxOf0vDyzVq4/Rsn7Bj/+Wmz5EGcPn8m8bq7a/4QfxFuffgJoezfaUnFG2StJFzXeJJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjvqAYZ8; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjvqAYZ8"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ade5b8aab41so310135266b.0
        for <nvdimm@lists.linux.dev>; Sat, 05 Jul 2025 00:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751702349; x=1752307149; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DUPGizcJCKcVSiA1WanuvVCLC1N0ClOoR03LFG1lAw=;
        b=RjvqAYZ8IuTHnCH/4zZlqxWPeq+Pb0jWBfqfzNuKAzVE7ivN+97A/9K4mNGyVBn6Oy
         9rZUp4LAzd6I8GJ4fZ2kiSVwI1dUgz5QyiQXR2N1ShSXAXMxuFayUZJ4voe4458LD+rF
         R13HzEjRyqHDIq4FucchgAcSYLw7ZMVFOritv6CI9KJ16NWQr2dEn6XHsJrb7DA8VcPn
         qRJOtKnZ8FNI3SYCaQpKLqaR0XHG0X6MoAbxaJ+wJ+wNfwX6rOtjWlU0v3Bm+8kTVl4a
         u7aEV6q788vGr95IDjjFhSrekUlVlrKuxP3w36DvVwG5mkWfHH/A4RhXMi2PZ+EjLf18
         d0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751702349; x=1752307149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DUPGizcJCKcVSiA1WanuvVCLC1N0ClOoR03LFG1lAw=;
        b=cNE/zN1V/bNmmRWHSmR8SMDb3LLH/SGVizWeFAW93tszqnR0jOipL+SeBiSgfZi4p8
         NAwG4o6MPbkZKN62qUDDg1ZNwmyR30jAmanj6R73kfj0gTrdn9uecnHw/r18MzrDU9Yq
         V7XKt+bpmKhW+ov+z/2AlSlm6yMfbryE7v779Z68W/hlxnHeMLMV5+gfynUUWx2BFCqy
         AzpramTyEt+oJWLG2com9i1d4+31cHmyR/uOa3X0qa+YLUm6o9hNJy4Om7Bcs8vC4Rue
         jv32WggZEKlDvLMRdyoiYFwPH3PDZ7D0OQ1Yk2yt+vqKuv+IDL1Kjm1WULoPHtlg+DUW
         sJNw==
X-Forwarded-Encrypted: i=1; AJvYcCX1IVIRwhGmeXS8Wz7ITOzBvnr7e6QnBoMLkQAVK8uo7g1mCCjeZBLQStYI7MO3wPncutAal+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxH9osIqQ9nPh1vjWN6+DSsux1g63O3DIEa7lg+BePpPK0DyxOB
	SBR4rb8DyM+51S58BP7EDjHi48ovucyAwn6ia/udzXv8y/KHjz5Hg0E6qNlxD8cmSRTkSVnr/ZY
	lvwa62b8m1u97Ems1aU91ohHt3WFv7Mg=
X-Gm-Gg: ASbGnctNa/Lyf20QbUnrvHuvMld0WUbTAl8iDRUn0l0gcXOK+G4fSgJJQEEJh68u1W7
	/jwOK7RWmS3Prl9GdeDy3K//sQRVRUVpjETd9aBnNgp6vNWSzcCF9BoTDiWt+793vTxsVDW+/hO
	nLoM/gPIrYPoOXRL0eM/TEt3mqSrpVxJ8HjKitJh3aEAc=
X-Google-Smtp-Source: AGHT+IGdvwsNyuJyTecRCTicnpvM7VA0CpzpCj0R6PEmEpr94y/m3eOzdizlm78HEjU0cgum7EREQ9o3ZQ/9Bn0+shk=
X-Received: by 2002:a17:907:6d04:b0:ae0:34d4:28a5 with SMTP id
 a640c23a62f3a-ae3fe3dafd3mr490037666b.0.1751702348395; Sat, 05 Jul 2025
 00:59:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-13-john@groves.net>
 <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>
 <c73wbrsbijzlcfoptr4d6ryuf2mliectblna2hek5pxcuxfgla@7dbxympec26j> <gwjcw52itbe4uyr2ttwvv2gjain7xyteicox5jhoqjkr23bhef@xfz6ikusckll>
In-Reply-To: <gwjcw52itbe4uyr2ttwvv2gjain7xyteicox5jhoqjkr23bhef@xfz6ikusckll>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 5 Jul 2025 09:58:57 +0200
X-Gm-Features: Ac12FXwv8-5VHpFmc1k0yFgQhA2TPysX4Xc_lFwiFozmpCMZCqpYDc11sx5Oc4k
Message-ID: <CAOQ4uxhnCh_Mm0DGgqwA5Vr4yySgSovesTqbnNH7Y_PXE9fzpg@mail.gmail.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 5, 2025 at 2:06=E2=80=AFAM John Groves <John@groves.net> wrote:
>
> On 25/07/04 03:30PM, John Groves wrote:
> > On 25/07/04 10:54AM, Amir Goldstein wrote:
> > > On Thu, Jul 3, 2025 at 8:51=E2=80=AFPM John Groves <John@groves.net> =
wrote:
> > > >
> > > > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP=
 to
> > > > retrieve and cache up the file-to-dax map in the kernel. If this
> > > > succeeds, read/write/mmap are resolved direct-to-dax with no upcall=
s.
> > > >
> > > > GET_FMAP has a variable-size response payload, and the allocated si=
ze
> > > > is sent in the in_args[0].size field. If the fmap would overflow th=
e
> > > > message, the fuse server sends a reply of size 'sizeof(uint32_t)' w=
hich
> > > > specifies the size of the fmap message. Then the kernel can realloc=
 a
> > > > large enough buffer and try again.
> > > >
> > > > Signed-off-by: John Groves <john@groves.net>
> > > > ---
> > > >  fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++=
++++
> > > >  fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
> > > >  fs/fuse/inode.c           | 19 +++++++--
> > > >  fs/fuse/iomode.c          |  2 +-
> > > >  include/uapi/linux/fuse.h | 18 +++++++++
> > > >  5 files changed, 154 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > > > index 93b82660f0c8..8616fb0a6d61 100644
> > > > --- a/fs/fuse/file.c
> > > > +++ b/fs/fuse/file.c
> > > > @@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct i=
node *inode, struct file *file)
> > > >         fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
> > > >  }
> > > >
> > > > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > >
> > > We generally try to avoid #ifdef blocks in c files
> > > keep them mostly in h files and use in c files
> > >    if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > >
> > > also #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > > it a bit strange for a bool Kconfig because it looks too
> > > much like the c code, so I prefer
> > > #ifdef CONFIG_FUSE_FAMFS_DAX
> > > when you have to use it
> > >
> > > If you need entire functions compiled out, why not put them in famfs.=
c?
> >
> > Perhaps moving fuse_get_fmap() to famfs.c is the best approach. Will tr=
y that
> > first.
> >
> > Regarding '#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)', vs.
> > '#ifdef CONFIG_FUSE_FAMFS_DAX' vs. '#if CONFIG_FUSE_FAMFS_DAX'...
> >
> > I've learned to be cautious there because the latter two are undefined =
if
> > CONFIG_FUSE_FAMFS_DAX=3Dm. I've been burned by this.

Yes, that's a risk, but as the code is shaping up right now,
I do not foresee FAMFS becoming a module(?)

> >
> > My original thinking was that famfs made sense as a module, but I'm lea=
ning
> > the other way now - and in this series fs/fuse/Kconfig makes it a bool =
-
> > meaning all three macro tests will work because a bool can't be set to =
'm'.
> >
> > So to the extent that I need conditional compilation macros I can switc=
h
> > to '#ifdef...'.
>
> Doh. Spirit of full disclosure: this commit doesn't build if
> CONFIG_FUSE_FAMFS_DAX is not set (!=3Dy). So the conditionals are at
> risk if getting worse, not better. Working on it...
>

You're probably going to need to add stub inline functions
for all the functions from famfs.c and a few more wrappers
I guess.

The right amount of ifdefs in C files is really a matter of judgement,
but the fewer the better for code flow clarity.

Thanks,
Amir.
