Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D888F6D
	for <nvdimm@lists.linux.dev>; Tue, 30 Apr 2024 02:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714443865; cv=none; b=cgZuqiBowU5Mqjywz2SQIor9QMh6NT4nBwfEkVrXxN3RgFgdCS0JcvkiN1ZQEZbC7ljkxYpwY0KJkHbTHVEA1hI+76TWoFnIxzpQ4LlLOx5ryFiY4oqNyCch0iZwIE3tjLlVigNQO9X0T3i1FGmfQpSIbjDrIpv5Gh2cAGWuzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714443865; c=relaxed/simple;
	bh=pHrX1nssNyu8gzUDF0TVhZ/6WzhA+XCFxaDORT7avuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUVHsWxl1jMgq8XISmE9ep/Oae0iUkjTWCROyWINCHRYjCfBvvI3r+h5yfa7pyvfoyo4sO2D0KZNLlwIqnMIQQegwcftE6esP+/K+FBiMNpGoCdYHlOjR+lWr0LmW6ukKzKXM4OVxd5kxWAxL5vO7jIPPq7uTA3jiUMXYhrk73Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WxpjuY1R; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxpjuY1R"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6ea2375d8d0so4254503a34.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 19:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714443862; x=1715048662; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BbtJf4mzLUwJVUVRJUYZehYcucbtm3NLWevtNONlCWM=;
        b=WxpjuY1R0kwFd0r4vn8ox0qnYDx2dMjJeJXOkCTRKR6Nmj7FuqhHiiquEfmlmlokz9
         /hI2nLPkWLcRXhju1snI+GXDHVRWNafQ41AY7tMmF6ExEFWHG25d7JnsZHtf3RHkqyFC
         9qJqQMuf28btrI3XU4MdP6TkPQzHBmLKMKbNV8ArLrnzXA0Ovyi2rmWbeTqt57ZXarEp
         oLkfTUWEvX/U5CMhbGaKHRnnmVp38MuPk8b5HpTJfg6dWUS+kxiHzfpe1yinqti6Y2VH
         QfOe0RguNk23TC5ih27aHPdInElZsc09VYQgMgzXdgILJlVu0r6DcltSnhTvTQBVNLgb
         vwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714443862; x=1715048662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BbtJf4mzLUwJVUVRJUYZehYcucbtm3NLWevtNONlCWM=;
        b=BPmINzOH/Xcd99DWEjIA69CXGgNG65OsQkD6GOvwzWtL5Pi+IsEvXfv8W6qiOjM/BS
         KchFvxU/gwxFJxaM9m+WICzV/9r0foLSIBdWtUMizWk8E/C5gPWgAVKupOoRuivsF+vR
         6s40IMuPfDt1SSGgmGkbh2dFU1LUZLCRNmLWrS7gecunD6AIifyYrGA9e5RRIb3sRwKv
         gJf4pGRdN4pn9GTbHKIMaWWxI0twy5LV+grBgrg+Aa8LMFM+9/vfrsvnLpNDiR3trjyb
         VgIpSMdjCHnIqoBa4T56qi4F6NtiDZ9PjdK7hCTYOK4RfBeZTkEr30NgeFN8oykLatsm
         spLg==
X-Forwarded-Encrypted: i=1; AJvYcCVeQUoDfApXjmOcN0zDxujMKAd4PXPIcD3Uns1fx55ZUQnGi0Jzi/hgXIw6YCn8Xa16G6cr97H0TZoSmgxfXS4qJ457ylza
X-Gm-Message-State: AOJu0YxaniZYO7NVCyQiM0gAYxy5epXHhp+B+/2RnyTs8rnIS7EQdCJd
	ybB//jFrIaVpTTJNSSOmD8e/Y7scQG1WrfgkDAQvbi1vALdh7bHn
X-Google-Smtp-Source: AGHT+IFfX8qoIbkKOSqPj1wPbalW+jRr6ClWAncq4u97YuYFYRE8SBbRjtrH84rETYC65rqrpvfI5Q==
X-Received: by 2002:a05:6830:e0e:b0:6ea:19af:6c8a with SMTP id do14-20020a0568300e0e00b006ea19af6c8amr13270869otb.10.1714443862556;
        Mon, 29 Apr 2024 19:24:22 -0700 (PDT)
Received: from Borg-10.local ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id d13-20020a05683025cd00b006ee65e27a95sm79052otu.32.2024.04.29.19.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 19:24:22 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 29 Apr 2024 21:24:19 -0500
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
Message-ID: <jklmoshdemmnv62nfvygkr5blz75jq6fhhaqaditws4hsj6glr@rkhdqze4d7un>
References: <cover.1714409084.git.john@groves.net>
 <Zi_n15gvA89rGZa_@casper.infradead.org>
 <bnkdeobpatyunljvujzvwydtixkkj3gfeyvk4pzgndfxo7uc32@y6lk7nplt3uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bnkdeobpatyunljvujzvwydtixkkj3gfeyvk4pzgndfxo7uc32@y6lk7nplt3uk>

On 24/04/29 07:08PM, Kent Overstreet wrote:
> On Mon, Apr 29, 2024 at 07:32:55PM +0100, Matthew Wilcox wrote:
> > On Mon, Apr 29, 2024 at 12:04:16PM -0500, John Groves wrote:
> > > This patch set introduces famfs[1] - a special-purpose fs-dax file system
> > > for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> > > CXL-specific in anyway way.
> > > 
> > > * Famfs creates a simple access method for storing and sharing data in
> > >   sharable memory. The memory is exposed and accessed as memory-mappable
> > >   dax files.
> > > * Famfs supports multiple hosts mounting the same file system from the
> > >   same memory (something existing fs-dax file systems don't do).
> > 
> > Yes, but we do already have two filesystems that support shared storage,
> > and are rather more advanced than famfs -- GFS2 and OCFS2.  What are
> > the pros and cons of improving either of those to support DAX rather
> > than starting again with a new filesystem?
> 
> I could see a shared memory filesystem as being a completely different
> beast than a shared block storage filesystem - and I've never heard
> anyone talking about gfs2 or ocfs2 as codebases we particularly liked.

Thanks for your attention on famfs, Kent.

I think of it as a completely different beast. See my reply to Willy re:
famfs being more of a memory allocator with the benefit of allocations 
being accessible (and memory-mappable) as files.

> 
> This looks like it might not even be persistent? Does it survive a
> reboot? If not, that means it'll be much smaller than a conventional
> filesystem.

Right; cxl memory *can* be persistent, but most of the future products
I'm aware of will not be persistent. Those of us who work at memory
companies have been educated in recent years as to the value (or
lack thereof) of persistence (see 3DX / Optane).

But since shared memory is probably on a separate power domain from
a server, it is likely to persist across reboots. But it still ain't
storage.

> 
> But yeah, a bit more on where this is headed would be nice.

The famfs user space repo has some good documentation as to the on-
media structure of famfs. Scroll down on [1] (the documentation from
the famfs user space repo). There is quite a bit of info in the docs
from that repo.

The other docs from the cover letter are also useful...

> 
> Another concern is that every filesystem tends to be another huge
> monolithic codebase without a lot of code sharing between them - how
> much are we going to be adding in the end?

A fair concern. Famfs is kinda fuse-like, in that the metadata handling
is mostly in user space. Famfs is currently <1 KLOC of code in the 
kernel. That may grow, but it's not clear that there is a risk of
"huge monolithic". 

But it's something we should consider - and I'll be at LSFMM and 
happy to engage about this.

> 
> Can we start looking for more code sharing, more library code to factor
> out?
> 
> Some description of the internal data structures would really help here.


[1] https://github.com/cxl-micron-reskit/famfs/blob/master/README.md

Best regards,
John
