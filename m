Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3771552FA
	for <nvdimm@lists.linux.dev>; Mon, 28 Apr 2025 01:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745804917; cv=none; b=CuiF4nLnNY4CYulYIUWc9NsMhoLD11O5pPhrsXrluEvNR9Yng6LLdIB6CEJ6LjC6o+KTMbun4zXqNm6G4nhmgv0btuzkTJH8wpsu4AnRCgqhSRTFRU72t7Qj/DfAyU9Xu5hz++htBFUWUfboKv/9HxVqkRsZvMLVpts7Qu2V+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745804917; c=relaxed/simple;
	bh=voGcHcuUJxZIvWYp/gqePl+JGxhXrFqBulPecpJwMZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGbI5QX2hSwBg+KscsfduX0QI4sytH1T/KbCRZvpz1ou1bBNxekPMCCLD0MQDOFfwYKodz8Ek7ao3qL8WBkojKL7xtnuP7YWP4PnnIm+vSBXuVByoFjAHZPxkeKcTu95JkAWW4C/LrBqsjeqD0LX+IK+KUqvRt7uOwrVR2M5O9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGxuRydi; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGxuRydi"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3f6dccdcadaso3514377b6e.2
        for <nvdimm@lists.linux.dev>; Sun, 27 Apr 2025 18:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745804913; x=1746409713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fOTD9+qJ3DB2cRPCVMYpnlZF0OQvWGQ+PHSchN+vCsg=;
        b=MGxuRydin0Qa7Sbe2LYIWRX/bFC+No0hnqpwdVY07pVyuJe7h5/ny57cvlHX5fi6pM
         N2Q86tPqAd/TJLoHGKZ5JUVSrYGKtk0ZU7Wc7X4P6VVo7CgKU71WXGxLL6/l7wlMCTcI
         8Ocetc6huZ5HrDRPMGFdvTWxy24+jacgRYlN4ZVh+VfZLQ2Nf7HYNKguXmlB25ZmNa97
         7EYw/S2Q9C/BLjHmLFOjvkc40ijpIul5VZkJu14O9i+KK3tueCGLp83XN8K+yOXCVNpY
         czlXYyV+mIRIHNb35Vykj157E4kXP5fX9mTbYKMrAm9CWZeginZ0K++NGOCOrsm3ef9t
         kqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745804913; x=1746409713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOTD9+qJ3DB2cRPCVMYpnlZF0OQvWGQ+PHSchN+vCsg=;
        b=XrY/Zh/ReXvz7BbI4ATvDJammWIRokXZoZfdWY0uMRCmMTMPfQM13JTkCZRM3VqyB7
         J/vLw7RDbAH3M/9eoU8KaKnnkVh0tRK1sAvces82I3iio9Hl64vOHnJgKYKd2r9F+pYn
         MIcLOhRew02grSWwvepEmS/1+/1G7soCpP+UmhnLpghN92GYNuuF5DM/gSlItpMe/SO/
         1s2urDgjrWFEYEavJTnJ2leExPODEkyBgejU2Y2oL6YKUoyxKCZVEC5bIcrsm0qby729
         g0GW5Zg0yQavipcyTtCrWWxaHGX6BGpJwbI/WH81AB15x8mAbqXASF8UZ8xPtzXxMw3g
         DBvw==
X-Forwarded-Encrypted: i=1; AJvYcCUnNwZnEhVOrAwv8J3JA/HM2GAddPG4JWYEDReEJ9rZQDks/TRU8FBj61eT2la69FpqLjEpjxI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyikkuziXAdCrnNfc8qufRbPSeoQHcRdZpXWsrhqc6qm6hxX8bn
	7/E7H6dB0n9UCCl8PDU6ok7HjMp+Mu+dDwQ04zTeJywjbqxXdZ/z
X-Gm-Gg: ASbGnctf5YjUXGF2O5VNGq84Z1wqbMpMStChG28Q6kFBiI0SBHfG6FWZWvlynKIHKMp
	YqiUU3ru+hTcBqqbfdksDlC77a7nI7EhonkjG0WgiB5bvOqLd6r58Hjy9nk5ulWz8APtT4cKbrG
	WLDWmtvqbmNI2xyFBFUL56jY3tjO9mPe3yzJby22cFT/4UHOuHg8hGxz51tW76qTnZ6ATAzL6W8
	24B6xCjWwaVgCoecE4iJQ+Cx4zKYqPe2JFgUboBDiE3mwPv0taMmfd55lPuL7mfLOeDZCZBQBrI
	2Q1JYsEIhVTF3zwID+Wo9G7Qf1exfe7Nm1pmRhKQtZpj10JCBxPVZSE=
X-Google-Smtp-Source: AGHT+IGqN3xTf5U+964YoRhK3pXmFW3/L8+DHv6gDtXxO/8dRDPl0vk0yvhPN+naZgspiiBdb3mvUA==
X-Received: by 2002:a05:6808:3319:b0:3fc:7e1:a455 with SMTP id 5614622812f47-401f2877e01mr6528091b6e.2.1745804913012;
        Sun, 27 Apr 2025 18:48:33 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:14de:ab78:90c3:bb9a])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-401f36b6099sm1325232b6e.44.2025.04.27.18.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Apr 2025 18:48:32 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 27 Apr 2025 20:48:30 -0500
From: John Groves <John@groves.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Luis Henriques <luis@igalia.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 0@groves.net
Subject: Re: [RFC PATCH 13/19] famfs_fuse: Create files with famfs fmaps
Message-ID: <5rwwzsya6f7dkf4de2uje2b3f6fxewrcl4nv5ba6jh6chk36f3@ushxiwxojisf>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-14-john@groves.net>
 <nedxmpb7fnovsgbp2nu6y3cpvduop775jw6leywmmervdrenbn@kp6xy2sm4gxr>
 <20250424143848.GN25700@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424143848.GN25700@frogsfrogsfrogs>

On 25/04/24 07:38AM, Darrick J. Wong wrote:
> On Thu, Apr 24, 2025 at 08:43:33AM -0500, John Groves wrote:
> > On 25/04/20 08:33PM, John Groves wrote:
> > > On completion of GET_FMAP message/response, setup the full famfs
> > > metadata such that it's possible to handle read/write/mmap directly to
> > > dax. Note that the devdax_iomap plumbing is not in yet...
> > > 
> > > Update MAINTAINERS for the new files.
> > > 
> > > Signed-off-by: John Groves <john@groves.net>
> > > ---
> > >  MAINTAINERS               |   9 +
> > >  fs/fuse/Makefile          |   2 +-
> > >  fs/fuse/dir.c             |   3 +
> > >  fs/fuse/famfs.c           | 344 ++++++++++++++++++++++++++++++++++++++
> > >  fs/fuse/famfs_kfmap.h     |  63 +++++++
> > >  fs/fuse/fuse_i.h          |  16 +-
> > >  fs/fuse/inode.c           |   2 +-
> > >  include/uapi/linux/fuse.h |  42 +++++
> > >  8 files changed, 477 insertions(+), 4 deletions(-)
> > >  create mode 100644 fs/fuse/famfs.c
> > >  create mode 100644 fs/fuse/famfs_kfmap.h
> > > 
> 
> <snip>
> 
> > > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > > index d85fb692cf3b..0f6ff1ffb23d 100644
> > > --- a/include/uapi/linux/fuse.h
> > > +++ b/include/uapi/linux/fuse.h
> > > @@ -1286,4 +1286,46 @@ struct fuse_uring_cmd_req {
> > >  	uint8_t padding[6];
> > >  };
> > >  
> > > +/* Famfs fmap message components */
> > > +
> > > +#define FAMFS_FMAP_VERSION 1
> > > +
> > > +#define FUSE_FAMFS_MAX_EXTENTS 2
> > > +#define FUSE_FAMFS_MAX_STRIPS 16
> > 
> > FYI, after thinking through the conversation with Darrick,  I'm planning 
> > to drop FUSE_FAMFS_MAX_(EXTENTS|STRIPS) in the next version.  In the 
> > response to GET_FMAP, it's the structures below serialized into a message 
> > buffer. If it fits, it's good - and if not it's invalid. When the
> > in-memory metadata (defined in famfs_kfmap.h) gets assembled, if there is
> > a reason to apply limits it can be done - but I don't currently see a reason
> > do to that (so if I'm currently enforcing limits there, I'll probably drop
> > that.
> 
> You could also define GET_FMAP to have an offset in the request buffer,
> and have the famfs daemon send back the next offset at the end of its
> reply (or -1ULL to stop).  Then the kernel can call GET_FMAP again with
> that new offset to get more mappings.
> 
> Though at this point maybe it should go the /other/ way, where the fuse
> server can sends a "notification" to the kernel to populate its mapping
> data?  fuse already defines a handful of notifications for invalidating
> pagecache and directory links.
> 
> (Ugly wart: notifications aren't yet implemented for the iouring channel)

I don't have fully-formed thoughts about notifications yet; thinking...

If the fmap stuff may be shared by more than one use case (as has always
seemed possible), it's a good idea to think through a couple of things: 
1) is there anything important missing from this general approach, and 
2) do you need to *partially* cache fmaps? (or is the "offset" idea above 
just to deal with an fmap that might otherwise overflow a response size?)

The current approach lets the kernel retrieve and cache simple and 
interleaved fmaps (and BTW interleaved can be multi-dev or single-dev - 
there are current weird cases where that's useful). Also too, FWIW everything
that can be done with simple ext list fmaps can be done with a collection
of interleaved extents, each with strip count = 1. But I think there is a
worthwhile clarity to having both.

But the current implementation does not contemplate partially cached fmaps.

Adding notification could address revoking them post-haste (is that why
you're thinking about notifications? And if not can you elaborate on what
you're after there?).

> 
> --D

Cheers,
John

