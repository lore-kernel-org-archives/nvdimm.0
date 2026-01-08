Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EDA33D4F5
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767914744; cv=none; b=c5CTG2buepNRpTqfXkjMyYeys1wLSkJq5Cgbk0bMIRHZ+cBNeXyval4Tip9ru/IL5wBgA7VML2Pkephlnk1mV59MNXDqwL62iov4be/eTdBCgUytSvntUEml+q0bpOH2x0VvaRQRK6vSoFlyuhL4HxTUR8oIAduSJm/1KVD32X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767914744; c=relaxed/simple;
	bh=obLYyhrFsoB9oBqm7xL6fDhdB8wxBGKxiOySCPXnFrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYsmhSvcmsN4kT4GJsBEz3SurvAZxZoyoqbut0G3F3HVDqUJw7WowzRjCv0oWrUNYt1wt9I5SgH3D5DXXu6DUgZS1nhjt663asWUE23E/pSZyZfPgOGBMgCvVsJiW4TEkMpI+ZVxaR0TP5q1ssKTV/pRJFl5Gxf1jVBgGj9mEgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XNQaaVhY; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XNQaaVhY"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8887ac841e2so33740556d6.2
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 15:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767914741; x=1768519541; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=055cXnB91pz5e1+jow3wyxxEvRh6YPpDHe6f2UW3p44=;
        b=XNQaaVhY4iP3pjvRVkIkPuelaxMDwYB4qWCqq186qF310LBl+r9NMk7VVJId9Vuyjm
         4hY4y+2s//kTRWuOS61OOsCx/jI1i706XVNShmieefKS/lvdRzt5xctQMGvT261bh6PD
         wVZioE6a8pwyoK6/6oBswWq3JbBvTiW+KvpuU0Yw7GILcODGeuPGZXsmz6k3DdJKI+Go
         8eGzgz2Tpx/Z3UFZxRgAStNBRjCxDMQWQgYTwHBsbMo0/k0LayWaejtYbQ9ZvhNjjVK/
         cHT7KcIdEciFAnX7/M7CDAQtcUSwkf0jTG8n6bEKnir34fy7ohYeFqrZPwKgiE82fk6k
         UMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767914741; x=1768519541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=055cXnB91pz5e1+jow3wyxxEvRh6YPpDHe6f2UW3p44=;
        b=BbEYNObqseZFyXvSH/KfBNjzmE707OwRLJg80hdVqrrBQ64m3RaF3wCp5ZSvpfJreI
         NbdSt5LRC+K4YVqCMUUYkbZIBRyrMO0YxUYMaVbnI0XfwtLamFSfSpdJ+rVHRv9ExCL/
         nwpgQi5DjtdB4SqqpxqE2em0IZbJHa2Yn4kdpSxSLZR3t2Rid31gfhAsB+zt9nfNHY+W
         i+7M3iqNnCKy9Y02JpuKGjLTdsqLbgEHMSqjig7FYDtvP9isQLw0GjniVAsEHETaf3sS
         r/djkwbrAaiGbWvvatOcDUeIGMG9WVlM2ddDhTTk/XGtJh/vESNaIP8mfjTQrHl5/d78
         XmAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKUjZPfrZiBoK0+ZpKfYVULqeOnP0D1A2PKvqGVKAT7qIz8aacaqDqzmYYWOlMcCIAb2gLuaQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZuQhRqHPrIolXqFUHzTaBdXWLlbYsKxv8jU0teh+sIVY4HgFT
	EovT3x907nC7RwMHDu1LHrkihPjgcojkYN5um3HgX0R/NTXOPZo/LarCLANzBMvcpis=
X-Gm-Gg: AY/fxX4eZGHj+qssWL6C5wgBJWjtHHcNII876Xx2/LnZ3hIWiU3wjJxhOa2oSpXu4dQ
	tjTo4gKSaI/BhvXiDlwcN9+w/BqPVMXqaCpSfdyuw7Or+nV+WO40BZSeKlxt1+VRL6uEO/n+jiy
	vBmRaUQiW5uClwvHOf+NRlytpi58OBTOv9B6g4AKw95gQPrZmv8rcLQassklNJrsT80wqqFii5C
	JL2o+Saamrd0Nw8hiygjvRS2fm9+5VIhYGX2MmDtajMMwTTRc62rhlZrE/Uo+4xp01RYsgY+6k5
	X+20qalKLchRMcjjhlpQDdf1SEiKOZk1u3Jr/3X/pTsTs9PT4JBfcR0VY2r3FNBy+rnnMrtwYLS
	NSP+f+ii3swOouzchFa7fBVVCFv97fSLAWLUZN+bh68Vve5mLdRbDajsLSkxUoS/5l+LOrrb1jf
	+IVJ1gzJ18Tcx2mNkxintrjoo8W7uNVOTgaK9tOhyto8mYCgHyRPf+/i/5zuq2PfMKhiyaVQ==
X-Google-Smtp-Source: AGHT+IH58K2fkRuNeCFONQo5PN3X5lTd6kkVRVrUL8HrgTghUwX32Msen1mn/KH+JIVLSLRjRmPpIQ==
X-Received: by 2002:a05:6214:d0f:b0:88a:342f:32a with SMTP id 6a1803df08f44-89084185ec7mr128066396d6.14.1767914741275;
        Thu, 08 Jan 2026 15:25:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346e2sm66493856d6.33.2026.01.08.15.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 15:25:40 -0800 (PST)
Date: Thu, 8 Jan 2026 18:25:05 -0500
From: Gregory Price <gourry@gourry.net>
To: John Groves <John@groves.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 02/21] dax: add fsdev.c driver for fs-dax on character
 dax
Message-ID: <aWA80edCywOLw0li@gourry-fedora-PF4VCD3F>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-3-john@groves.net>
 <20260108113134.000040fd@huawei.com>
 <6ibgx5e2lnzjqln2yrdtdt3vordyoaktn4nhwe3ojxradhattg@eo2pdrlcdrt2>
 <5hswaqyoz474uybw33arwtkojxrtyxrvlk57bdwnu2lnpao4aa@4vxygh226knw>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5hswaqyoz474uybw33arwtkojxrtyxrvlk57bdwnu2lnpao4aa@4vxygh226knw>

On Thu, Jan 08, 2026 at 03:15:10PM -0600, John Groves wrote:
> On 26/01/08 09:12AM, John Groves wrote:
> > On 26/01/08 11:31AM, Jonathan Cameron wrote:
> > > On Wed,  7 Jan 2026 09:33:11 -0600
> > > John Groves <John@Groves.net> wrote:
> 
> [ ... ]
> 
> > > > diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> > > > index d656e4c0eb84..491325d914a8 100644
> > > > --- a/drivers/dax/Kconfig
> > > > +++ b/drivers/dax/Kconfig
> > > > @@ -78,4 +78,21 @@ config DEV_DAX_KMEM
> > > >  
> > > >  	  Say N if unsure.
> > > >  
> > > > +config DEV_DAX_FS
> > > > +	tristate "FSDEV DAX: fs-dax compatible device driver"
> > > > +	depends on DEV_DAX
> > > > +	default DEV_DAX
> > > 
> > > What's the logic for the default? Generally I'd not expect a
> > > default for something new like this (so default of default == no)
> > 
> > My thinking is that this is harmless unless you use it, but if you
> > need it you need it. So defaulting to include the module seems
> > viable.
> > 
> > [ ... ]
> 
> On further deliberation, I think I'd like to get rid of 
> CONFIG_DEV_DAX_FS, and just include the fsdev_dax driver if DEV_DAX
> and FS_DAX are configured. Then CONFIG_FUSE_FAMFS_DAX (controlling the
> famfs code in fuse) can just depend on DEV_DAX, FS_DAX and FUSE_FS. 
> 
> That's where I'm leaning for the next rev of the series...
> 
> John
>

Please do that for CXL_DAX or whatever because it's really annoying to
have CXL and DAX configured but not have your dax device show up because
CXL_DAX wasn't configured.

:P

~Gregory
