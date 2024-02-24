Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48624C129
	for <nvdimm@lists.linux.dev>; Sat, 24 Feb 2024 02:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708741452; cv=none; b=ZlxLTttHPh/pVrlnH1QWELRdm3W6UjTMgW5SqG1CA6yjOOTDjr0oCxp0XsCsK4zk0LTvcbCBt66x2RrLibKnEyMnE/u9XQH/GFDGb2neIRcyNDpZ77zeDZpG7BvB2uSnGyCSDgBUq/fQgqrGbja3enlrYPbzAIWsjVxQpYIzcfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708741452; c=relaxed/simple;
	bh=96/hYmvsl6lJNB2fS6l4UYShHAt/iwzhUf86OQUpLDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMwx5PTK59YOhTOR+/Fa8XXWpt3Kc/ovIU/lgQ+YxN3QuAFODW8O9WDis+zgoqe77cmyKeMATmE3cZv5fMtzp2xKwl2e44mw2Khreb3pySMLBAq+7w5J4rIqiodp96F1Wu1p7c0drvC0f+Nig0ssp5rC6+KzLKR9/GnlT44/YDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QiUNV7Qc; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QiUNV7Qc"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-21e9589d4ffso884872fac.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 18:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708741450; x=1709346250; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bOuv/zCxApvTn7JI2PSH32UWjQlemun/rMcaip0qb0o=;
        b=QiUNV7QcA5R+KaeR7H2GqVFJ9lKUseHh4N7pVa892eB9lR9nx1ssX/+0sEQ8ck/4iW
         Mv1O1t72BNWlz/Hd8nR9VDQcLbT0Tva9VJIeIkk9u3a5naA04tzIM0u5QAlTWw+N89r3
         BphFoGcXRN4WKd/Zp7vxr2tmbqbgOtxj8dpiaKwz0AfBqliittaSEpt3xR780RXg2Qi4
         ugnJxbqtOyquekiwyulWanT12jLGP9gcSKY+fQ0c3dq/cwBz/NQBv3xdSwV77pHd91Ce
         bR2hJsX236P21+k5LX+O4pdLHi66qINysMmSwxen2wCR2ojzVUa89LZ3/rtwtek4R6T6
         Ulsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708741450; x=1709346250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOuv/zCxApvTn7JI2PSH32UWjQlemun/rMcaip0qb0o=;
        b=UpQC2PU4qiJhgNvZn7dG9blaR2nYLD1L9SzgZ3iwMjudtj7tYM8/sTxUS4oXIP5POF
         HvIz49dr3K5uyCkCifMpdgzeUr0czamdPDKrZK7u/uJEoGzNRDdnzzN8VdtOtTpt4Ozo
         1Rzz9vsU5nrfGVBe64nKYoZEj0Km7LY24QZJQuNrwOFkwNqBVzrNqF3RjtVv6I9Vt/rY
         GiXpHImtnmCjA5bpaJFadt+om3CJ4c4B0NckjDFTjYAzPyJS7TyHanexeGDT4/TgFlom
         4cNoA3DyOc9tUXOl5UXOHhvIVL+blAWnvv6tl9xo2PLs9Gdl7JKSmyA+tq55Tc0Z3hQb
         SccA==
X-Forwarded-Encrypted: i=1; AJvYcCXmyTEG4MQLc8lmFfH1tthtgg1gFDVmeWgv3uObkZRBVIV3Yl+6Sp85T3GkzDVj3sJ1mWRC5GNnnka7PRz+6RZ45BVGgDOq
X-Gm-Message-State: AOJu0YwP4WT2PagEb42AdoT0f5XaUX5iEnR5PZlfMSlTtTJABUxtdpLb
	r4TAsZkgzbout661KwF2R3NqzR/SrBXQnA3oLK/7ZUfo8UCbZKgi
X-Google-Smtp-Source: AGHT+IHSwDehYa6qmK5HSq895V5y1nwMHTQrmOJ+xptsqjtflER37IUrDa4cTZzMA3WP0zG9JHmiDA==
X-Received: by 2002:a05:6870:4214:b0:21e:231e:a63 with SMTP id u20-20020a056870421400b0021e231e0a63mr1690531oac.11.1708741447364;
        Fri, 23 Feb 2024 18:24:07 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id gk27-20020a0568703c1b00b0021edaa6e35asm123256oab.21.2024.02.23.18.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 18:24:07 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 23 Feb 2024 20:24:05 -0600
From: John Groves <John@groves.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 20/20] famfs: Add Kconfig and Makefile plumbing
Message-ID: <kujd277lutkvpafgkstyh4opm7bwlbvv2gerwab7rutfwwsuzh@j5zdvx2brz3m>
References: <cover.1708709155.git.john@groves.net>
 <1225d42bc8756c016bb73f8a43095a384b08524a.1708709155.git.john@groves.net>
 <161f53c9-65ba-422d-b08e-2e5d88a208a2@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161f53c9-65ba-422d-b08e-2e5d88a208a2@infradead.org>

On 24/02/23 05:50PM, Randy Dunlap wrote:
> Hi,
> 
> On 2/23/24 09:42, John Groves wrote:
> > Add famfs Kconfig and Makefile, and hook into fs/Kconfig and fs/Makefile
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/Kconfig        |  2 ++
> >  fs/Makefile       |  1 +
> >  fs/famfs/Kconfig  | 10 ++++++++++
> >  fs/famfs/Makefile |  5 +++++
> >  4 files changed, 18 insertions(+)
> >  create mode 100644 fs/famfs/Kconfig
> >  create mode 100644 fs/famfs/Makefile
> > 
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 89fdbefd1075..8a11625a54a2 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -141,6 +141,8 @@ source "fs/autofs/Kconfig"
> >  source "fs/fuse/Kconfig"
> >  source "fs/overlayfs/Kconfig"
> >  
> > +source "fs/famfs/Kconfig"
> > +
> >  menu "Caches"
> >  
> >  source "fs/netfs/Kconfig"
> > diff --git a/fs/Makefile b/fs/Makefile
> > index c09016257f05..382c1ea4f4c3 100644
> > --- a/fs/Makefile
> > +++ b/fs/Makefile
> > @@ -130,3 +130,4 @@ obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
> >  obj-$(CONFIG_EROFS_FS)		+= erofs/
> >  obj-$(CONFIG_VBOXSF_FS)		+= vboxsf/
> >  obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
> > +obj-$(CONFIG_FAMFS)             += famfs/
> > diff --git a/fs/famfs/Kconfig b/fs/famfs/Kconfig
> > new file mode 100644
> > index 000000000000..e450928d8912
> > --- /dev/null
> > +++ b/fs/famfs/Kconfig
> > @@ -0,0 +1,10 @@
> > +
> > +
> > +config FAMFS
> > +       tristate "famfs: shared memory file system"
> > +       depends on DEV_DAX && FS_DAX
> > +       help
> > +         Support for the famfs file system. Famfs is a dax file system that
> > +	 can support scale-out shared access to fabric-attached memory
> > +	 (e.g. CXL shared memory). Famfs is not a general purpose file system;
> > +	 it is an enabler for data sets in shared memory.
> 
> Please use one tab + 2 spaces to indent help text (below the "help" keyword)
> as documented in Documentation/process/coding-style.rst.

Will do, thank you!

John

