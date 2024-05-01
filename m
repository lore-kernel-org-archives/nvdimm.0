Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E3A101CA
	for <nvdimm@lists.linux.dev>; Wed,  1 May 2024 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714529365; cv=none; b=Ae+MEepMzuzvhGJmHflza9D70qYbhMzFyLXxAwtVWgk2bbCHUZejIQ3zxBO0TognCTyKhZ1DRp0wrUF54tARHclw2bmq4816/1uhnXjNnnmekVUYMooyeo7rmWelAod7k4O61JhKJuRO2BA2uQQX2Bzj6acaMEadtE2KgHmrSd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714529365; c=relaxed/simple;
	bh=ySsZVAs1iEFo2LCjm6AMLn2MXUzr5ui6+DRDT1wzK5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j16QywS4Ylu6ALWdFOzFCLkT2/z6Bw+FDImk8J8j5eYvrtbncIgMXn3FTbQm62KiDHdosjVT1g5pc6LLIbxmgsQd5Njuh7olItYKctBmCKbBIxtqvNQHYbA5zWVzLkxFBVpr/9rqDwq/eGdD/c00q9wtl5O20WfeeS/ypwZyUn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaYodL4s; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaYodL4s"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6ee2be5b765so1541709a34.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 19:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714529362; x=1715134162; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yezFULKDfkH4O3tF/9359IJey7y6CAqBHbGwFEbOyVA=;
        b=eaYodL4sv311N02sUvapF+dPz8fPLjElibBg0Cq9hjgChspTwmTmqysMglv+UmGuTF
         iZ8JR5GXDH0L4sZxcd+V5RON4CgFAPkqa3j5d+GEY2LJ5VO6dmHseIvYzSobKL+Jouzw
         ZJUw9j/DIjKIhXdsqBj2Y+t1w1GBFoclDFYsEm9hyK9DloRHwNxJWAF3OYozsbRcPZaW
         bx5dGVTNPxONODFMffVoGwy+PnnBaKyElABbTkNHXdht18+Mr/RBEte3by4lxJtt0EMt
         aQFl82d1z3Jn+xgw9ThbsZcckeq356DlxlOHQxtvajKOdDCI3Pj4WGLfDgu4s6PRqssq
         hWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714529362; x=1715134162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yezFULKDfkH4O3tF/9359IJey7y6CAqBHbGwFEbOyVA=;
        b=hR5+LvQcs/x1Dtd+zqxd5cdCvjzwvIAtWztEQT0FCe42JCUTw2lCsTLNZH6QAnkm0P
         MxvT+FqExF/+WDd2/K/Y2nt8fOhrcR2xAdzDQQrfyQ0TZMXDKCrukMxNffr4aI+ygfjh
         eRV/BAKZA+fE9vHlrq8YVO8q71cM3jaNERTe7kby+FyA5ihAk3+H+mCJVmlC3WVzTBJG
         sLbn5NK8EFX71Z4Dz0vr60mEzerOkRr0fTDAf1yMiVXUbm1vj0WuR10a7Kw1bbo4SDX1
         wy1wYsahLaHZiYFR1UjYQB5wIhiT4sH4Qf03nQR+cutEodM3PWCfyxGD710k/LZ+lW8j
         Yr6w==
X-Forwarded-Encrypted: i=1; AJvYcCX7pFK80JFebM13h+FL9lt885EndgUEHDmrbuDKecK5kV4KgVlmC9kxMTj0giolTB0Q8exCj61hfZlWzOpXyWD4iuxOVQrv
X-Gm-Message-State: AOJu0YzBthIlPf6wCxzWpsWdweuU3QUbiEyqgFJJv6b1k0smg5zDgCkN
	t8u50ALPuAHwLGCvaxr4Mw8Tb5+PlXMM2hqEEtjq+d/XEOvKJ18c
X-Google-Smtp-Source: AGHT+IFCXZV9GskZrc8P0wyeR7SistjwlusLdB0r7UTGFqSaOO/E5aKxcvUFB9ZcRRmGCZ6KMJV0HQ==
X-Received: by 2002:a05:6830:e16:b0:6ee:62e5:8fe3 with SMTP id do22-20020a0568300e1600b006ee62e58fe3mr1414305otb.25.1714529361993;
        Tue, 30 Apr 2024 19:09:21 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id bq10-20020a056830388a00b006ef888380a9sm338042otb.59.2024.04.30.19.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 19:09:21 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 30 Apr 2024 21:09:18 -0500
From: John Groves <John@groves.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	John Groves <jgroves@micron.com>, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com, 
	Randy Dunlap <rdunlap@infradead.org>, Jerome Glisse <jglisse@google.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Eishan Mirakhur <emirakhur@micron.com>, Ravi Shankar <venkataravis@micron.com>, 
	Srinivasulu Thanneeru <sthanneeru@micron.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Chandan Babu R <chandanbabu@kernel.org>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Steve French <stfrench@microsoft.com>, Nathan Lynch <nathanl@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Julien Panis <jpanis@baylibre.com>, Stanislav Fomichev <sdf@google.com>, 
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: Re: [RFC PATCH v2 00/12] Introduce the famfs shared-memory file
 system
Message-ID: <zwtglxnnbjbgtzcv7rhrbtqz6owmviv3yg25bcluenaayzzj4p@nng3gh5twcjo>
References: <cover.1714409084.git.john@groves.net>
 <Zi_n15gvA89rGZa_@casper.infradead.org>
 <bnkdeobpatyunljvujzvwydtixkkj3gfeyvk4pzgndfxo7uc32@y6lk7nplt3uk>
 <jklmoshdemmnv62nfvygkr5blz75jq6fhhaqaditws4hsj6glr@rkhdqze4d7un>
 <h6tbyvdeq5hzkttsy4uyzq4v64xlkzeqfyo52ku3w4x3vvtpd7@4vxafcct62xh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h6tbyvdeq5hzkttsy4uyzq4v64xlkzeqfyo52ku3w4x3vvtpd7@4vxafcct62xh>

On 24/04/29 11:11PM, Kent Overstreet wrote:
> On Mon, Apr 29, 2024 at 09:24:19PM -0500, John Groves wrote:
> > On 24/04/29 07:08PM, Kent Overstreet wrote:
> > > On Mon, Apr 29, 2024 at 07:32:55PM +0100, Matthew Wilcox wrote:
> > > > On Mon, Apr 29, 2024 at 12:04:16PM -0500, John Groves wrote:
> > > > > This patch set introduces famfs[1] - a special-purpose fs-dax file system
> > > > > for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> > > > > CXL-specific in anyway way.
> > > > > 
> > > > > * Famfs creates a simple access method for storing and sharing data in
> > > > >   sharable memory. The memory is exposed and accessed as memory-mappable
> > > > >   dax files.
> > > > > * Famfs supports multiple hosts mounting the same file system from the
> > > > >   same memory (something existing fs-dax file systems don't do).
> > > > 
> > > > Yes, but we do already have two filesystems that support shared storage,
> > > > and are rather more advanced than famfs -- GFS2 and OCFS2.  What are
> > > > the pros and cons of improving either of those to support DAX rather
> > > > than starting again with a new filesystem?
> > > 
> > > I could see a shared memory filesystem as being a completely different
> > > beast than a shared block storage filesystem - and I've never heard
> > > anyone talking about gfs2 or ocfs2 as codebases we particularly liked.
> > 
> > Thanks for your attention on famfs, Kent.
> > 
> > I think of it as a completely different beast. See my reply to Willy re:
> > famfs being more of a memory allocator with the benefit of allocations 
> > being accessible (and memory-mappable) as files.
> 
> That's pretty much what I expected.
> 
> I would suggest talking to RDMA people; RDMA does similar things with
> exposing address spaces across machine, and an "external" memory
> allocator is a basic building block there as well - it'd be great if we
> could get that turned into some clean library code.
> 
> GPU people as well, possibly.

Thanks for your attention Kent.

I'm on it. Part of the core idea behind famfs is that page-oriented data
movement can be avoided with actual shared memory. Yes, the memory is likely to 
be slower (either BW or latency or both) but it's cacheline access rather than 
full-page (or larger) retrieval, which is a win for some access patterns (and
not so for others).

Part of the issue is communicating the fact that shared access to cachelines
is possible.

There are some interesting possibilities with GPUs retrieving famfs files
(or portions thereof), but I have no insight as to the motivations of GPU 
vendors.

> 
> > The famfs user space repo has some good documentation as to the on-
> > media structure of famfs. Scroll down on [1] (the documentation from
> > the famfs user space repo). There is quite a bit of info in the docs
> > from that repo.
> 
> Ok, looking through that now.
> 
> So youv've got a metadata log; that looks more like a conventional
> filesystem than a conventional purely in-memory thing.
> 
> But you say it's a shared filesystem, and it doesn't say anything about
> that. Inter node locking?
> 
> Perhaps the ocfs2/gfs2 comparison is appropriate, after all.

Famfs is intended to be mounted from more than one host from the same in-memory
image. A metadata log is kinda the simpliest approach to make that work (let me
know your thoughts if you disagree on that). When a client mounts, playing the 
log from the shared memory brings that client mount into sync with the source 
(the Master).

No inter-node locking is currently needed because only the node that created
the file system (the Master) can write the log. Famfs is not intended to be 
a general-purpose FS...

The famfs log is currently append-only, and I think of it as a "code-first"
implementation of a shared memory FS that that gets the job done in something
approaching the simplest possible approach.

If the approach evolves to full allocate-on-write, then moving to a file system
platform that handles that would make sense. If it remains (as I suspect will
make sense) a way to share collections of data sets, or indexes, or other 
data that is published and then consumed [all or mostly] read-only, this
simple approach may be long-term sufficient.

Regards,
John



