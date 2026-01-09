Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC41A500940
	for <nvdimm@lists.linux.dev>; Fri,  9 Jan 2026 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767999505; cv=none; b=F6cBYDwY3TmdJ9A1b0tLPYIRZmu/h4H2ULd8IoVpXO+4BmzjaDG1rmPIqVR/PO4ztLWBRTlmUDJyeHvMXQnMSH2fVuQ0TPdHJmqKeLbSRxq6i1kjqb+Y6ddWfOLtRj58IQWYe7ZT3SurKcQ/nZMOqd9+1KCrwY4qo9QRpeDh+c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767999505; c=relaxed/simple;
	bh=bfOlHfz2d97lpJdcssjhFC6DH34X+brsAi4ooodTEnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rvM0tsa8BwJcTyWGCH+LmbByJCnvYGWYwGh+Sk+N5v/ic/u0oe9wKQBYb9SSgSmlMUgkkef24Aj2DLEqvdBu/ZJvigBhASTHuKS7+ZKgmhT0jpRnBg2z63u9NKYQngFn+OthY98Bz9SB5ctrGO8VK6GgFSvQw2ScYqjGDy5gGKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zq1CxqsO; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zq1CxqsO"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3f0d1a39cabso3285583fac.3
        for <nvdimm@lists.linux.dev>; Fri, 09 Jan 2026 14:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767999502; x=1768604302; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jl0CYGdZkEy3SnbyPzW+uVfkekcUJUWsyBrwQPbpYso=;
        b=Zq1CxqsOwFNPF7mrKDoQxtN/Uv8rfoHdzPla0lq8NQl31TEUu858PTGtp7TbE++J2B
         OXM2jBbzZ21sAJ09YvhiA78kW6WyeThzrserEahUn6TZfugrCGVGstKkEbJAM0nQ85Rb
         6a4dvglX6Cc2uEL7+GuGl4+aQSKJa49hHSA0XqgxEZ2s1b/Fqjag4nd/CG9kTNFu0Gil
         mucwS4NF2uLgBxqCYlJDFqxi0AmczhS3Aw390wC9CWgdH4CVcR2TtMgqzCDi+C205D64
         kmwXo4ObAKNnVHd4tJGW+jrPD4hCYK8mlD1bXy9GuCHQmHIrwczFrZJihFS9K84KUO5U
         IscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767999502; x=1768604302;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jl0CYGdZkEy3SnbyPzW+uVfkekcUJUWsyBrwQPbpYso=;
        b=RU46ecvmRqWd5HMOUIGKkOeeZk0tsgveKkiGC17RPecua6VEz6d4Bm2KLqBQZg7Xi6
         Fvb+XgrqC4uNG6wjBGnZ/lAU0BAf3L1Bp+GBzT48Hya8gSx6p9mNX+VTMc/0jA0SsPBr
         s4cH/zzBkOD5O+ASzP0rEWxJkYjPLMyofrnBIqovoP9Cs6kHGRfZ8KWq0ptFOGcxBJF/
         UPolulkuuvmPHTlnzwBpXuFPLmIRZWSYbZUH7JARFhen5uIG9qf5JcGpnnZiiAWjGKPY
         4FmtAoEjxLtsE0z9vRtaONQVSGlKp9jRjkP9EoJhEQ0J5neR+szFn16Jvaxo9Rd4qLX4
         jUaA==
X-Forwarded-Encrypted: i=1; AJvYcCWg5rPMHdzM5hZizXxo4O3NwTKMxYY45pxJ55eBiX12+7L/3UOcvY6CRO5nT6Au27267lcxG7Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjhxzrXhIKNdoO6/AY/OOLDLXHd6jhhqVmRByP/pmdnx95ycr2
	/e6EN/GtiKQJITdNMFWXGi6HsIDKvcj0lCdIv9M0hBkzXFVf2654jtGh
X-Gm-Gg: AY/fxX6lXuBsgfCMlEE8yzP6BYM5TAXTWOHoKhl6bNm8qr7c/vdE4BzHUG+S7G/WlEv
	RjGtHpZj2kmo2d12zIo9dIUdwaMgbB6l84Ntd09NFvI06V2+hkY8BKGuYM2WWLKp5bLMwCgm9uD
	RC6iQt+xDmh3G3HvLEDYqnTbSuDtzD1chaE9fBQg+0+Mh2qtpv1SwN5HkGercIGHjE1QQQTTJ3S
	laulpiblktv+COs/aCIoSQxWVI/E4mQu0f70iRzRu1fAg/AtjO723jWX8G/Gxv+hPjHd9VbCVuL
	jR5WZYyKnqzIhawS5JqQ79tcYDfxKbu38u0YTRa8xA+7utv592K6FUOJ2I+ukDtuWRa9UskYliz
	XEla7bjvhrDy29qirJ39GhgsjJrjASLqxExzuWBbVQwooskupC3RkuQc/PRs1hDQjfuIMeAO8/+
	6oSth/QNCdgckqMsUGAnuLDqaHwVj0OA==
X-Google-Smtp-Source: AGHT+IGcrXJh4xfE4lkfSVHPI8XEPFwP3dHD2B/pDcAOyuoAiez1IjT5czUxIie9qoy4hzIPDogU5Q==
X-Received: by 2002:a05:6820:3013:b0:65f:564f:34b1 with SMTP id 006d021491bc7-65f564f373dmr4235710eaf.16.1767999501751;
        Fri, 09 Jan 2026 14:58:21 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:184d:823f:1f40:e229])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48ccff66sm4496483eaf.16.2026.01.09.14.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 14:58:21 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 9 Jan 2026 16:58:18 -0600
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 12/21] famfs_fuse: Basic fuse kernel ABI enablement
 for famfs
Message-ID: <hhqgn4n5mnr2onutmn4pri7gaaavl56op6amsdsqwlaggsi63f@pombhppmc2l2>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-13-john@groves.net>
 <CAJnrk1ZcY3R-iL2jNU3CYsrWBDY4phHM3ujtZybpYH2hZGpxCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZcY3R-iL2jNU3CYsrWBDY4phHM3ujtZybpYH2hZGpxCA@mail.gmail.com>

On 26/01/09 10:29AM, Joanne Koong wrote:
> On Wed, Jan 7, 2026 at 7:34 AM John Groves <John@groves.net> wrote:
> >
> > * FUSE_DAX_FMAP flag in INIT request/reply
> >
> > * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
> >   famfs-enabled connection
> >
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/fuse/fuse_i.h          | 3 +++
> >  fs/fuse/inode.c           | 6 ++++++
> >  include/uapi/linux/fuse.h | 5 +++++
> >  3 files changed, 14 insertions(+)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index c13e1f9a2f12..5e2c93433823 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -240,6 +240,9 @@
> >   *  - add FUSE_COPY_FILE_RANGE_64
> >   *  - add struct fuse_copy_file_range_out
> >   *  - add FUSE_NOTIFY_PRUNE
> > + *
> > + *  7.46
> > + *    - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
> 
> very minor nit: the extra spacing before this line (and subsequent
> lines in later patches) should be removed
> 
> >   */
> >
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

Thanks Joanne - fixed!

John

