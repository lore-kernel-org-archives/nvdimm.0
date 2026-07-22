Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C7A367F5E
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 14:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731391; cv=pass; b=OY7I23Z9YOq1Qur2Nx56Wa+ksuHm0HvcARjJOvmSbcUnO9nU54WEtLxZijOgOjMSKXWDv0+8fSSpVbkmoI3364dcz3dV3scXyLBnajBglbIAG25AdnKjJGCsX5TqXDKrJwMSqQresz+ctBHJwsOcquvVrPC2yy3FlVWrznb3/x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731391; c=relaxed/simple;
	bh=ahrPeW46a3z7uaEO1zJL6eWoGd4K9B9MS3EeUm2ySI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DDuO4nBqnzw1osm3soc6GzAswpIYExD844TTa1zZlTEyt2bADvqFN+Jtv0OSj/YFkH6EuUN4v908itUwfDBXtRC5kMKU8YkdyvfClcESiBxSmLjAApF7jFsfUheX+j2dPpjT0deFUymYccdXlGVrJBxVkmcGzNJZTuycxrhCR2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bj2GP5kn; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bj2GP5kn"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47de008b020so4683664f8f.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 07:43:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784731387; cv=none;
        d=google.com; s=arc-20260327;
        b=l5rPpaAbh6+AVp38NKoaHwfAMwYMFA+awB4gwlduIxCZP+qkSoM2VV56Je1hrp6sbb
         pzpogluaxcRDnocDjUyRM10CRfPThw2dFZP5CxNW4OXW7UNHhbTXmgDviMG3jHcJ7f3r
         KcNEmHk6qjylC11a5pzlyfhpsTa0JQtdByScRpurbJYeW24QofRFgnghIBjnwlc67va4
         qXxoXEMOZ7R92Y4rsiOiAfc7JD2uS0ZcFByza3OfHSdaoM7vVcy+suh9Uwsh2w/WOn/r
         Y+bsgGtMoiC5XBajtnxBotP1dccNgX80d/nrjhfyvDaqeLPYgGx1A6FQbGwlJZ7aSv/S
         w/2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nbVVn3kwJvwjtX0fZqdUSffXklqAZ5aOd6f3vVAXXIo=;
        fh=cpszbU5ypZFQVKUNTc65XzhUUJ3tQGiCpysrysUIeNY=;
        b=jbhuAZfYPyZTStjaN2Xr6FRMamDOJ5jN3x/m3+Ji6oaiUY7EH0FHlIOMkpTz690G/9
         gX8hB3YR0UlFE7LDa2bjU0epuCsxFcjw3QPsz3KlocxDukkUFgyIOUgFKLHWGFWigQ2u
         Ust2pHRYNwkV2uB4FG7SEXkt2xmf1YVAfNqwvy+HY7OFGVx3l18DEzjunMYJC3rFBkNL
         Paq6SYqWiBYorMXAj49xc9W/t5HeU5K4b/+RPZHy/sBETe19nl1Ln0QfpUcdQl2koZcW
         CbqYeZ1Me88GoWiUHlultDYHCypsR5EKFRvy7LBEYUxwD5jsOT47r4dHwywlQYB/q9az
         0jyQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784731387; x=1785336187; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nbVVn3kwJvwjtX0fZqdUSffXklqAZ5aOd6f3vVAXXIo=;
        b=bj2GP5knKSdyTKHAhnL42Tlw5FT8euu/COJfXkBJoHMlxQq1X6L3skcXu0msuNi48F
         LCBItv2ghG9ns53EidaTibSBthAn4K63pmdkkkyOXvA6KRtQ1ITrrsX46jgpaV36LgKv
         xfFZI6be8fYPqPhyrUmAVhRlob/V1VI8wofwXvcASBwTEf8mHcjPnQsCXwxfAD3KGdA5
         7hqgH+IXyfX48t4cgfGVggKG20dNbYpLBqLDQRiSuwW3jrfTiQe8WxNq6FqOEt4sesaL
         94K7BxOL166oLzqJDuW8LfTJYMEioyMf1qRty6VXnCuUZaZhntIA7aFaSUTu8v6xrbo/
         pTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784731387; x=1785336187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nbVVn3kwJvwjtX0fZqdUSffXklqAZ5aOd6f3vVAXXIo=;
        b=KdcFNl+wtDYVKrS1nAy0HhaBgP+keKoa4lW3e0iMBtqa4VTbcphNns+FItaXGqdpIh
         0aiKgMQNIDQYLQLy+tlNB97xf62bvhtp845Z5Of2TE2fKoplqQ53vt2qVgEEcQm5/xAo
         KYAr7CqDwQO2O0d1HpXJ5S6DsmLraxe5gQ/M7mLribaaXJPTu9bARGyrSdd9gVgUjouc
         EuYXAla7llWQBLJoiNCpWNfpty53r2asS25/DN7m5XFL0GVI1R6fWfqsIIW4k9Kb3WS+
         pD5PPPPGftVKmhNRnCY6xgtqyfvTRdIygssqDfGLCXu3QVaULQ+vxiF0xeRqraRTzjcd
         fLSg==
X-Forwarded-Encrypted: i=1; AHgh+Roor7YdbshcmVLsCMNpuChWWzfiU0woP4FgVzU0qrn5/A6RMJsHHRsGK1+hX4cVE6R+XF9v/FE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYHe5WWSvPmie86r5755H/wpcJheJYqaku1nqWsXooavmChuD9
	XDkxURL/52qpXXdvoZ4k4r1skqfmmcu7W9BGFFFlh1K0JTYdAYqh+Qzwt0zJ/S8Is5LwwJ7DXOW
	8FQkndpVjEY4jAqRmjRoOUSd94HcEtuc=
X-Gm-Gg: AR+sD1341VlOFfSvzOYagthBEsWw5UUx/Wt3AzecJy3m2abyHXWZFgefE05zniy9mA6
	jVEnUAX2LXTl2g4yBfPjKwyzVk7nj/fDDWwmtX8Mgla7sec0I9KmkCgQ5N+s8tp++bxpfmF1ShY
	X1E+n9h5b435Sh/bW8qy4nwFT0aZafP/ru4FMydGHgLW+Utn/T0BFboO9VIqvpgTecNPn29g55J
	oX//ycmZZq4ML2auveHQhzrL8Yu2LDPwE+xtWrNTsBIylpbCVx/6eVetCMA87d9Dr4vbSm07YMz
	UA7z4C5k00I0QFEl0NHeRn+hqkmwNCfxZMvaeXyWcQ==
X-Received: by 2002:a05:6000:2a0f:b0:47f:6d9b:f204 with SMTP id
 ffacd0b85a97d-47f840d1199mr3725320f8f.23.1784731386878; Wed, 22 Jul 2026
 07:43:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
 <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com> <CAOQ4uxhuivjMMt_Dm3VwKmOhHg7ZHdAww6j6jp+RMjPoRde+bA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhuivjMMt_Dm3VwKmOhHg7ZHdAww6j6jp+RMjPoRde+bA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 22 Jul 2026 07:42:52 -0700
X-Gm-Features: AUfX_mwxuEB8MpcAvVdcxrfmXjtIkJPDlLRoLVxYiUNlL8we5MhuKUq5tNA-EIo
Message-ID: <CAJnrk1Yat+SEr=SmZXwUt9y2WcC0VEC4KUpPrkrRSjMEmx42WQ@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, John Groves <john@jagalactic.com>, 
	John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 5:47=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Jul 22, 2026 at 12:47=E2=80=AFPM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> >
> > On Mon, 20 Jul 2026 at 12:07, Amir Goldstein <amir73il@gmail.com> wrote=
:
> >
> > > It's not about this ioctl, it's about infrastructure reuse.
> > > It's about the fact that there is NOTHING special about dax_devlist;
> > > and no reason not to manage it via backing_files_map.
> > >
> > > The reason you stated was that you want userspace to determine the
> > > daxdev_index/backing_id - fine, no problem - this is why I asked that
> > > you pass it the desired backing_id in the ioctl.
> > > In fact I think that all fuse backing_ids would be better assigned by=
 user space
> > > so the extension of padding =3D> backing_id is not unique to famfs.
> >
> > Right, so I suggest to just reuse FUSE_DEV_IOC_BACKING_OPEN and add
> > two flags: one to enable user supplied backing ID and the other to
> > indicate that fd refers to DAX device.  The changes to do compared to
> > the current patchset are quite minimal.
> >
> > > And the best part is that this request requires no changes to your us=
erspace.
> > > You already bite the bullet and maintain the new/old uapi but changin=
g the
> > > kernel implementation does not require this burden from you, so to be=
 honest
> > > I really don't understand why you did not follow Miklos' suggestion.
> >
> > Code reuse is also important, but I understand John's position to want
> > to separate famfs from existing codebase as much as possible.  And
> > because this is an implementation detail I don't want to make this a
> > show stopper.  We can easily fix it later.
> >
> > > > - Lose the famfs interleaved extent format. I have complied with th=
is request.
> > > >   It makes some things worse, but we'll discuss that later.
> > > >
> > >
> > > I am really not aware of a request to lose the interleaved extent for=
mat.
> > > How can this patch [2] from Miklos which reimplements this format as =
a generic
> > > uapi be mistaken for a request to lose this format?
> >
> > Let's not care.  We can easily add this later if famfs (or any other
> > use case) decides to want this after all.
> >
> > Making the initial patchset smaller is win in any case.
> >
> > > Let me recap the former review requests as I understand them:
> > >
> > > 1. Use ioctl instead of GET_DAXDEV
> >
> > This is done, just need to reuse the existing ioctl instead of add a
> > new one with the same semantics (okay not true because of the fixed
> > backing ID extension...)
> >
> > > 2. Use backing files infra for daxdev table
> >
> > Leave this later.
> >
> > > 3. Use ioctl instead of GET_FMAP
> >
> > Not sure we agreed to use an ioctl for extent mapping.   What we did
> > agree on was to use a generic interface that doesn't have anything
> > famfs specific in it.
>
> My bad. I thought that FUSE_DEV_IOC_STRIPE_OPEN was an
> example of how GET_FMAP should be made into a generic interface.

I had the same impression as Amir. The FUSE_DEV_IOC_STRIPE_OPEN patch
[1] right now is only for the interleaved case to handle striping, but
imo it seems a lot cleaner to make FUSE_DEV_IOC_STRIPE_OPEN a generic
interface for handling any backing layout that corresponds to a
backing id, and having the simple extent case go through this same
infrastructure / path. Especially since John's future patches for
adding the interleaving will go through the ioctl, it seems nicer
server-side as well for famfs to have one consolidated path instead of
needing two totally different ones. I think also file passthrough will
want this infrastructure in the future too, and their use case would
be mostly non-striped extents.

I was imagining something like:

struct fuse_backing_member {
    uint32_t backing_id;
    uint32_t reserved;
    uint64_t offset;
    uint64_t length;
};

struct fuse_backing_layout {
    uint16_t nr_members;
    uint16_t reserved1;
    uint32_t reserved2;
    uint64_t chunk_size;
    uint64_t flags;

    struct fuse_backing_member members[] __counted_by(nr_members);
};

which is the same as what was in the FUSE_DEV_IOC_STRIPE_OPEN patch
but just renamed and a uint64_t flags and uint64_t length field added.

This would let us eliminate GET_FMAP, which imo needs to be
eliminated. The ioctl also gives famfs more flexibility with being
able to preload extent mappings outside of the hot path instead of
being forced to only upload it on opens.

If not the ioctl, what did you have in mind for a generic interface? I
think anything else would have to keep GET_FMAP, but maybe I'm wrong
here.

I think John has patiently endured a lot of demands in the last 2
years, so I agree that anything that isn't uapi-dependent should just
be done in the future as follow-up work and shouldn't block this
series. imo the ideal version of this series would have nothing famfs
specific in it, but I think a lot of that can be renamed /
restructured internally later on. But the extent uploading / GET_FMAP
part seems like the last thing needed to figure out.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260601152327.2069787-1-mszeredi=
@redhat.com/#t
