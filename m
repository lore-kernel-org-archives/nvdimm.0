Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA71DF963
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751743076; cv=none; b=b4pRRuAVoiVrJd99Bcml5T3uX83+jNYOzED2Zg0+SX9bZ2053XsNjddG7QUUw2b0AGmCPNztxufqvvw++7SFm5BCpcfeSbg44+QOqzsKHC9Gl1qYVSYjkP9ziszn9nWBnadLu7jEli4fSIoT2KxmAtbalebG3tgdpXBwSlVKdqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751743076; c=relaxed/simple;
	bh=5JfbTDmmRNRU0QSsGXO2ytdUbZn8uJPpIrPMtWAOkpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIucNaRq7YPmPEDNT7RxaEkJ+Auh+69XAB6krdbLAQrMRFB/D/ku51dK3ggXH6M/TmvlHUahZqOISMkdAUd4mumKDD8LANmsJK0gvpDhlAdtR8nc4gbj3+fMyBVQoDD1BXiwgIx6b9DgOqw/vN+sAKtutSNXuh1Ig3IglwXAWPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LBNYZW4z; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LBNYZW4z"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ef461b9daeso1583842fac.2
        for <nvdimm@lists.linux.dev>; Sat, 05 Jul 2025 12:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751743073; x=1752347873; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M0tal2TXuoVeMN1NrV/dwk0+DnB3su6E14sOZlFT3SI=;
        b=LBNYZW4z3+olXIXWrLF5W+eGrDIrmkLskjVaknPInYDhQuMM4EficnyapszreV2QTs
         dHwHcBkIX6ZXnVb7xVAaOkE1on4/wNWxeKjZn433iq4ReTK4r/9624AbmbVO6B8qUQiY
         9myDwc7nYeYnpjL2ARRM78yck7viQFJz6C5MlP7abdgdjeohP8KVXRbw1VvIAqp8R+60
         jHlS3h9svwOFxuEV5NBwWYKW52BUJ6Ltlro6ozJXiYgQTqEwB5ZCeV7aGQoNfuxCYQAy
         dGAe20dmLLYXqkes4jHiW2+8KPmu/mLiLm/UmSIQrqD/JhMeCSeV2JLp81cjeiGWyEFf
         FjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751743073; x=1752347873;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0tal2TXuoVeMN1NrV/dwk0+DnB3su6E14sOZlFT3SI=;
        b=qAfWorVyn5i8ou/pWDtv9Na5IOjNzYb41yfZmwbLv0Bw+HXJItrkECeRgkUUorF3Y3
         zAJCs1/72vnWTknvav9dXnz0mHKGtOiEhBpgwaWZw8nni8dtj/3tCRjQgIULJ5rJtWGN
         gvpAlv3p8x8w5+6IOcn2540e0DHuQdP5xXEtUk/wGn8APvam13Q415/M7mYeAAHaCEte
         k2qDTFQCB0oqbXDHdAAtRaF4QcD1hBriIN/4qAu7L2l2JtleSt+0d59l6nFb8ie3+TzI
         Ca4oNd5A2Ose1Z4sxDvOaDdEkZx7nsfGAL5U4oUCLaQFpBL4KJM+wWvnPuvFdHRebFo6
         kp6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCXmd13cCuMec8lv/D7/vmF4iQlfg9RIETw1Rot16Mm6mdU+bMvontWCccQIb76HdYNzNrfX4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX822sceQOvnn5GaWwRq/CP2OctgXcAkyavWGA3AJT5QGoP+n9
	ntRRX+qd7YMxwrd258+xWRqS2Sw6DNUcOxqG2cGLtjwZDgEjaA3nLIDw
X-Gm-Gg: ASbGncvefTzlMWTl3fDHzrtf9ynkQZCFSrnUfwoxLmY6f3ErDPyDwUYoXTE0EPzGww3
	5tRCjhcbHJiM8/PNuE0o6bhtvW87ZXU8OD9jOcLJb2lGfd45rBsFLQW4wMB6UzP8iZ/cqJZ9gzP
	S4ExoGRxpxp90+o3ejKgMFpdScfvKRnPn26KOX3mKTFiaf3MjxH9djPTZRUmaR5Oq8JThMkMAav
	7AoZ/Ud7FJcZ/Q6abCNNudYxSDU9RKMOyJg5Eyn68ZSHNoyULD+4hzpJ0AZgwAkiQl6YKv+4upR
	63/dNpwhNo9x7+pGrCNT1Yua9n0XFdt4p+yEwrD3SmY8TsbXcWvi53KfnIM91akRm+ZaKFPHFcR
	Y
X-Google-Smtp-Source: AGHT+IG5/wHt8NNYOAj0VVdS7ApVEHMemzu+FgEfnNgRE5AVwf3j0dSGHQb81nJIQIly3VlVlBvRsg==
X-Received: by 2002:a05:6870:5e0d:b0:2d4:dc79:b8b with SMTP id 586e51a60fabf-2f7afda584dmr2430162fac.10.1751743073028;
        Sat, 05 Jul 2025 12:17:53 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:5c68:c378:f4d3:49a4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2f7901a35cesm1243246fac.32.2025.07.05.12.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:17:52 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 5 Jul 2025 14:17:50 -0500
From: John Groves <John@groves.net>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
Message-ID: <xyzi6ymuc4wi3byq4t4bjtdbm2xchrf7vrdmrdagpdawjrgvi2@ncdxgkt6dvjw>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-13-john@groves.net>
 <CAOQ4uxh-qDahaEpdn2Xs9Q7iBTT0Qx577RK-PrZwzOST_AQqUA@mail.gmail.com>
 <c73wbrsbijzlcfoptr4d6ryuf2mliectblna2hek5pxcuxfgla@7dbxympec26j>
 <gwjcw52itbe4uyr2ttwvv2gjain7xyteicox5jhoqjkr23bhef@xfz6ikusckll>
 <CAOQ4uxhnCh_Mm0DGgqwA5Vr4yySgSovesTqbnNH7Y_PXE9fzpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhnCh_Mm0DGgqwA5Vr4yySgSovesTqbnNH7Y_PXE9fzpg@mail.gmail.com>

On 25/07/05 09:58AM, Amir Goldstein wrote:
> On Sat, Jul 5, 2025 at 2:06 AM John Groves <John@groves.net> wrote:
> >
> > On 25/07/04 03:30PM, John Groves wrote:
> > > On 25/07/04 10:54AM, Amir Goldstein wrote:
> > > > On Thu, Jul 3, 2025 at 8:51 PM John Groves <John@groves.net> wrote:
> > > > >
> > > > > Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> > > > > retrieve and cache up the file-to-dax map in the kernel. If this
> > > > > succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.
> > > > >
> > > > > GET_FMAP has a variable-size response payload, and the allocated size
> > > > > is sent in the in_args[0].size field. If the fmap would overflow the
> > > > > message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
> > > > > specifies the size of the fmap message. Then the kernel can realloc a
> > > > > large enough buffer and try again.
> > > > >
> > > > > Signed-off-by: John Groves <john@groves.net>
> > > > > ---
> > > > >  fs/fuse/file.c            | 84 +++++++++++++++++++++++++++++++++++++++
> > > > >  fs/fuse/fuse_i.h          | 36 ++++++++++++++++-
> > > > >  fs/fuse/inode.c           | 19 +++++++--
> > > > >  fs/fuse/iomode.c          |  2 +-
> > > > >  include/uapi/linux/fuse.h | 18 +++++++++
> > > > >  5 files changed, 154 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > > > > index 93b82660f0c8..8616fb0a6d61 100644
> > > > > --- a/fs/fuse/file.c
> > > > > +++ b/fs/fuse/file.c
> > > > > @@ -230,6 +230,77 @@ static void fuse_truncate_update_attr(struct inode *inode, struct file *file)
> > > > >         fuse_invalidate_attr_mask(inode, FUSE_STATX_MODSIZE);
> > > > >  }
> > > > >
> > > > > +#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > > >
> > > > We generally try to avoid #ifdef blocks in c files
> > > > keep them mostly in h files and use in c files
> > > >    if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
> > > >
> > > > also #if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)
> > > > it a bit strange for a bool Kconfig because it looks too
> > > > much like the c code, so I prefer
> > > > #ifdef CONFIG_FUSE_FAMFS_DAX
> > > > when you have to use it
> > > >
> > > > If you need entire functions compiled out, why not put them in famfs.c?
> > >
> > > Perhaps moving fuse_get_fmap() to famfs.c is the best approach. Will try that
> > > first.
> > >
> > > Regarding '#if IS_ENABLED(CONFIG_FUSE_FAMFS_DAX)', vs.
> > > '#ifdef CONFIG_FUSE_FAMFS_DAX' vs. '#if CONFIG_FUSE_FAMFS_DAX'...
> > >
> > > I've learned to be cautious there because the latter two are undefined if
> > > CONFIG_FUSE_FAMFS_DAX=m. I've been burned by this.
> 
> Yes, that's a risk, but as the code is shaping up right now,
> I do not foresee FAMFS becoming a module(?)

Yeah, I can't think of a good reason to go that way at this point.

> 
> > >
> > > My original thinking was that famfs made sense as a module, but I'm leaning
> > > the other way now - and in this series fs/fuse/Kconfig makes it a bool -
> > > meaning all three macro tests will work because a bool can't be set to 'm'.
> > >
> > > So to the extent that I need conditional compilation macros I can switch
> > > to '#ifdef...'.
> >
> > Doh. Spirit of full disclosure: this commit doesn't build if
> > CONFIG_FUSE_FAMFS_DAX is not set (!=y). So the conditionals are at
> > risk if getting worse, not better. Working on it...
> >
> 
> You're probably going to need to add stub inline functions
> for all the functions from famfs.c and a few more wrappers
> I guess.
> 
> The right amount of ifdefs in C files is really a matter of judgement,
> but the fewer the better for code flow clarity.
> 
> Thanks,
> Amir.

Right - I've done that now, and it actually looks pretty clean to me.

Thanks!
John

