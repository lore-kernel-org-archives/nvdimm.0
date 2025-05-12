Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00287255E53
	for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 19:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747079511; cv=none; b=M+GCw+63O95x8rXVRzaoUDasTVvpbpysCFcaL3DV+Nnft4b+YTt+IYI7vCKHXpJFyaw9Ct9JRfeRE4WvnOJVSIEfPZbFumxZeA4NLxCfJ157bWC0hiNVYtf3Fs4+1RTuakJt90eLn1XIOTL0u1JizZxpL8deBLQJbZ4eWdUhib0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747079511; c=relaxed/simple;
	bh=gzPsO0UrZDgI9iXYum4r5I7+OTPZxIA5JzksCAF1yrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIa7fys6JxRupAZfcp6svVknJdWP1p3ulaQrdXKGh+xQSBC43tVkAQNawqdGaQxZ/5u3ZVdqTIE7SgDBk8KDlZd527QxjognAO05xMhn2peVuoNbhFMhYlSxQnyAPfYLH6I2ltPcv7HtHYUE+7MHUUizikn75z6pDs074mWSKTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lApPh3JA; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lApPh3JA"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-72c172f1de1so2780920a34.3
        for <nvdimm@lists.linux.dev>; Mon, 12 May 2025 12:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747079509; x=1747684309; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUkjMRzK3wxS4oootv0crIxPWYrPZ4z6gtzYbFkCOlI=;
        b=lApPh3JAy61AcGzmyDX0gysdvNSDVD9tnDBYbwEZ0gfNVY6xcLD3hg4DmNK+85Mmzd
         FtHotcAoKVLQvKiz3PtNHstLa7lz5I8DFeL2rWuW+FyvT/TBoRgviut/WvqXaGbh9AAZ
         KzfXwzXDx5jyOEi0GNC+TlEHlJMOxqmUGt49y23/5BtKiwaCtKC+t4XBv5vgtksHAmXr
         v08dzLhcHqPiCnT0WsgGhS6n+poFfHIXB79YvCZ6XSWCELwv6VlrGHrkm+Uv4zJEe/Uy
         DMTHkFcPKzMQ4gOLJrMvHFJ/ce3Z9Y/iYHcg3LauoIqpQNCdlZEpFfKs3Aw9mEh8zFMU
         SQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747079509; x=1747684309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUkjMRzK3wxS4oootv0crIxPWYrPZ4z6gtzYbFkCOlI=;
        b=WZwehvaEI4d8lsmzttnzDUBcfofOFgJ04Ze9r0GzI5iGpmUGE15VZ/j2cnhX20fKxf
         Fuoa6l0pDXOCP5kz0/O1OMYhw5DbpUaHvT7QxiRPh/TWl4VGGGCnQ4HsUO5tot9Umjv9
         a+/bxZ5EDuS3fyEofs7WMhfnUlwDnNVMQ4tRw9L0i+ksId1NG9n3RcUAO+Uy6G5cYotp
         S9uc1tp2aQSzSZHgrI4c6wtPhBNe2XwfBJzgKXuTIomlSiJanoisFWxxEyfymJ0wPYgX
         3u079bqMrARWo8YmPQ/c/MtQhTZIpC8BsnV1BagXyLXnukpSdqyAdeoHMlHuH4KTJ5dE
         xIzA==
X-Forwarded-Encrypted: i=1; AJvYcCWlcttwryQR9K0eNf5FsQQudFZfE7gljK6xlSozMJKRLFRm8i1UAOq+O0/5kCgFK0N8GIUJ7Bk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAAgnq9DHhnLAiag5dTICj1ZZgoyYWhahqRzAsEgdAK31hBDgx
	nEeVKoFpDgBUQobO8v/BgYoUMMZTAuOg1LXnhDW5jyLw/6DQwdVU
X-Gm-Gg: ASbGncvvVS4lymipqXCyAm18Fsqxmm60ZJ9jNWg2TLkmMSjOVPbXVJCtxR9TjFJsLjy
	Az4uyxnFshMILuH2t409D2A7t1nXYFrt+hj4VhpoSa3Kij/D3eYC1DvZ9hfS9me+D+kJJCjxeH1
	AUKqMv1fgvkAx1BBBPgzyEjsS5r8/sgwiWzjziQYOhOODsig2JRYDD7DyOvjB6uqnlQA1goZ0Xn
	92m8VUmhj6vMdlBByej2sjye42julaCTCJ4ZDBSTIbd+rtWB9oWw+7oJK0QNenPmn4KTQUFcSgq
	3uELztMuuxE8pIZMxKc8G1J8hNq4Y2x/jIbs7u4wd+cBbuwSz8bCok66Lofhqx9gWQ==
X-Google-Smtp-Source: AGHT+IEAeXjZiozlRYEM0gARp0zQzeR/jbozJkUKlmzreQdwjSlhfL93jt9YN6NYGu8g494ESdu3sw==
X-Received: by 2002:a05:6830:4903:b0:72a:1d2a:4acf with SMTP id 46e09a7af769-73226aaed7fmr9385724a34.17.1747079508876;
        Mon, 12 May 2025 12:51:48 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:f16b:b065:d67a:e0f7])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73356c72943sm1353348a34.3.2025.05.12.12.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 12:51:47 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 12 May 2025 14:51:45 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
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
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, john@groves.net
Subject: Re: [RFC PATCH 13/19] famfs_fuse: Create files with famfs fmaps
Message-ID: <aytnzv4tmp7fdvpgxdfoe2ncu7qaxlp2svsxiskfnrvdnknhmp@uu4ifgc6aj34>
References: <20250421013346.32530-1-john@groves.net>
 <20250421013346.32530-14-john@groves.net>
 <nedxmpb7fnovsgbp2nu6y3cpvduop775jw6leywmmervdrenbn@kp6xy2sm4gxr>
 <20250424143848.GN25700@frogsfrogsfrogs>
 <5rwwzsya6f7dkf4de2uje2b3f6fxewrcl4nv5ba6jh6chk36f3@ushxiwxojisf>
 <20250428190010.GB1035866@frogsfrogsfrogs>
 <CAJfpegtR28rH1VA-442kS_ZCjbHf-WDD+w_FgrAkWDBxvzmN_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtR28rH1VA-442kS_ZCjbHf-WDD+w_FgrAkWDBxvzmN_g@mail.gmail.com>

On 25/05/06 06:56PM, Miklos Szeredi wrote:
> On Mon, 28 Apr 2025 at 21:00, Darrick J. Wong <djwong@kernel.org> wrote:
> 
> > <nod> I don't know what Miklos' opinion is about having multiple
> > fusecmds that do similar things -- on the one hand keeping yours and my
> > efforts separate explodes the amount of userspace abi that everyone must
> > maintain, but on the other hand it then doesn't couple our projects
> > together, which might be a good thing if it turns out that our domain
> > models are /really/ actually quite different.
> 
> Sharing the interface at least would definitely be worthwhile, as
> there does not seem to be a great deal of difference between the
> generic one and the famfs specific one.  Only implementing part of the
> functionality that the generic one provides would be fine.

Agreed. I'm coming around to thinking the most practical approach would be
to share the GET_FMAP message/response, but to add a separate response
format for Darrick's use case - when the time comes. In this patch set, 
that starts with 'struct fuse_famfs_fmap_header' and is followed by the 
approriate extent structures, serialized in the message. Collectively 
that's an fmap in message format.

Side note: the current patch set sends back the logically-variable-sized 
fmap in a fixed-size message, but V2 of the series will address that; 
I got some help from Bernd there, but haven't finished it yet.

So the next version of the patch set would, say, add a more generic first
'struct fmap_header' that would indicate whether the next item would be
'struct fuse_famfs_fmap_header' (i.e. my/famfs metadata) or some other
to be codified metadata format. I'm going here because I'm dubious that
we even *can* do grand-unified-fmap-metadata (or that we should try).

This will require versioning the affected structures, unless we think
the fmap-in-message structure can be opaque to the rest of fuse. @miklos,
is there an example to follow regarding struct versioning in 
already-existing fuse structures?

> 
> > (Especially because I suspect that interleaving is the norm for memory,
> > whereas we try to avoid that for disk filesystems.)
> 
> So interleaved extents are just like normal ones except they repeat,
> right?  What about adding a special "repeat last N extent
> descriptions" type of extent?

It's a bit more than that. The comment at [1] makes it possible to understand
the scheme, but I'd be happy to talk through it with you on a call if that
seems helpful.

An interleaved extent stripes data spread across N memory devices in raid 0
format; the space from each device is described by a single simple extent 
(so it's contigous), but it's not consumed contiguously - it's consumed in 
fixed-sized chunks that precess across the devices. Notwithstanding that I 
couldn't explain it very well when we talked about it at LPC, I think I 
could make it pretty clear in a pretty brief call now.

In any case, you have my word that it's actually quite elegant :D
(seriously, but also with a smile...)

> 
> > > But the current implementation does not contemplate partially cached fmaps.
> > >
> > > Adding notification could address revoking them post-haste (is that why
> > > you're thinking about notifications? And if not can you elaborate on what
> > > you're after there?).
> >
> > Yeah, invalidating the mapping cache at random places.  If, say, you
> > implement a clustered filesystem with iomap, the metadata server could
> > inform the fuse server on the local node that a certain range of inode X
> > has been written to, at which point you need to revoke any local leases,
> > invalidate the pagecache, and invalidate the iomapping cache to force
> > the client to requery the server.
> >
> > Or if your fuse server wants to implement its own weird operations (e.g.
> > XFS EXCHANGE-RANGE) this would make that possible without needing to
> > add a bunch of code to fs/fuse/ for the benefit of a single fuse driver.
> 
> Wouldn't existing invalidation framework be sufficient?
> 
> Thanks,
> Miklos

My current thinking is that Darrick's use case doesn't need GET_DAXDEV, but
famfs does. I think Darrick's use case has one backing device, and that should
be passed in at mount time. Correct me if you think that might be wrong.

Famfs doesn't necessarily have just one backing dev, which means that famfs
could pass in the *primary* backing dev at mount time, but it would still
need GET_DAXDEV to get the rest. But if I just use GET_FMAP every time, I
only need one way to do this.

I'll add a few more responses to Darrick's reply...

Thanks,
John

[1] https://github.com/cxl-micron-reskit/famfs-linux/blob/c57553c4ca91f0634f137285840ab25be8a87c30/fs/fuse/famfs_kfmap.h#L13

