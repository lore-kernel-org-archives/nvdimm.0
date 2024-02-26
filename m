Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F821DFCD
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708984078; cv=none; b=H3ux0fvZmFd07YP9pEJBujuN/qbJQLohajLV5lK2mff4/LKJVWy+kYaJcj6d5jT/aFeQWYpVsOSyTsZkw3dfN9rH2N3bWIZBpf+VVQMKEAwx8QdXtlBRUWB9P2qKwAOivEsLtmzBWP4xs9nDXb6M+O6r6TqVOgQNVvtiYfh5cH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708984078; c=relaxed/simple;
	bh=+mhRZDCckO6W8K7cXxypdompx2eyAZlDqNRYXBm0lRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puh1QhiNazVWU0MXcYwwQJ+qaD2vI1Bktl5C/IPDEBSrgE1LqQxSmse4OMEbJgk4BQuQX4acwcf72lQwUIHIOorm+rMp2K/nHqjQtFe+spRahPjAlZ9mTXsyM5N3q6hyHeOyRI/7QPmo7JvRcq3cpm57uTy5YBF+rkLKWhExiD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKOAA5Cn; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKOAA5Cn"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-59d489e8d68so1604293eaf.2
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 13:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708984076; x=1709588876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WwkLzcOkTdepCEL/rTOLTVwMFBrXTv/HE2I151NYxEg=;
        b=mKOAA5Cn2TvrN/rC+llgyBs/ZFcLld6ZpGW9S/jm9JRanLx2K31GPmAnsPWTWNHnVO
         hBwGzoB5qBfez96VpzywzjdR1cqX7/CjRbFMbrSjZacnQjrI4jVmnBtnH3JRRC+TEJjH
         uPguBxLLM75ncWAKzD9tDoPYYkzeT4OxYCvqzybSHD+QPP9wybwPzQ1eVXmfDt1FGX7j
         5S6aGtkS7yVkpRCDEArBEB+BWESDxyaHURvon+W/axANbMLgn6LXfGL2EXS7/1Zundmf
         duVlxP9eUdhXAv8sGJQPvp5jaoI/p/5ljOeU7g84dYua8ISs2IeswLq3iheFdDrDupME
         ZpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708984076; x=1709588876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwkLzcOkTdepCEL/rTOLTVwMFBrXTv/HE2I151NYxEg=;
        b=JASjOwBNNGDjag35LGsi8TyyNHDVNw7wHYJjyKx3tvL6kO5t4k758iaHqJC3lN9kcX
         y+C7how+lJ8DZ99eS+AU2NHV9dC2eLtNGImo7fIE0MvevM5A4CK2eMHC7PQwmI5WXWFJ
         5QV/V+k8ymWp1aoPJNZZPr7iLTLU9Q8iJiRJcLKQ1zeT0RoJlxWRXeF+ADUj7/iy4gvd
         QWUPJAowYhbOHnSQrfWbxOd4Oxc1jNWpU41h004lusSs4VDPYErI/Y9X1y/O21iNOi2x
         FMRW83cSl2hXPeFbmEGlT7rcXmWu2loMM1Z/MmnRTQ941BLHC9haZMc70E4XkcAMutqj
         gjYw==
X-Forwarded-Encrypted: i=1; AJvYcCXS9jXcn1p+SlVMqMwjTzvCyxKoFGEW5lEnOwsaOXM2ADeuk/YtmpwrHq4V/xcNZe6v78m1PDDokF9T/UrxSHlqnKD1VdRK
X-Gm-Message-State: AOJu0YwkaJq/KJzycZRlX9Mrfc3Si0angkVkffgIuTXMzbHZmLyVS4YN
	G9gwpRR29wtKmr1cQm4ngIwrtMBqJ1cdZV/OqSkjj5JCFw8Miquw
X-Google-Smtp-Source: AGHT+IENzrYho4sVLLETE+2kSmQeGnYGjapvMx2yk+6P/1Df/2LXKbX/7P21pTgZxerQUQHeu5dWRA==
X-Received: by 2002:a4a:ee8e:0:b0:5a0:5ac0:e81c with SMTP id dk14-20020a4aee8e000000b005a05ac0e81cmr6718130oob.6.1708984076000;
        Mon, 26 Feb 2024 13:47:56 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id h26-20020a4ad29a000000b005a0174b67c0sm1415632oos.3.2024.02.26.13.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 13:47:55 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 15:47:53 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 09/20] famfs: Add super_operations
Message-ID: <z3tnfxbbvhtbyantbm3yr3yv2qsih7darbm3p5pwwdsknuxlqa@rvexwleaixiy>
References: <cover.1708709155.git.john@groves.net>
 <537f836056c141ae093c42b9623d20de919083b1.1708709155.git.john@groves.net>
 <20240226125136.00002e64@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226125136.00002e64@Huawei.com>

On 24/02/26 12:51PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:53 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Introduce the famfs superblock operations
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_inode.c | 72 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 72 insertions(+)
> >  create mode 100644 fs/famfs/famfs_inode.c
> > 
> > diff --git a/fs/famfs/famfs_inode.c b/fs/famfs/famfs_inode.c
> > new file mode 100644
> > index 000000000000..3329aff000d1
> > --- /dev/null
> > +++ b/fs/famfs/famfs_inode.c
> > @@ -0,0 +1,72 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2024 Micron Technology, inc
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/pagemap.h>
> > +#include <linux/highmem.h>
> > +#include <linux/time.h>
> > +#include <linux/init.h>
> > +#include <linux/string.h>
> > +#include <linux/backing-dev.h>
> > +#include <linux/sched.h>
> > +#include <linux/parser.h>
> > +#include <linux/magic.h>
> > +#include <linux/slab.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/fs_context.h>
> > +#include <linux/fs_parser.h>
> > +#include <linux/seq_file.h>
> > +#include <linux/dax.h>
> > +#include <linux/hugetlb.h>
> > +#include <linux/uio.h>
> > +#include <linux/iomap.h>
> > +#include <linux/path.h>
> > +#include <linux/namei.h>
> > +#include <linux/pfn_t.h>
> > +#include <linux/blkdev.h>
> 
> That's a lot of header for such a small patch.. I'm going to guess
> they aren't all used - bring them in as you need them - I hope
> you never need some of these!

I didn't phase in headers in this series. Based on these recommendations,
the next version of this series is gonna have to be 100% constructed from
scratch, but okay. My head hurts just thinking about it. I need a nap...

I've been rebasing for 3 weeks to get this series out, and it occurs to
me that maybe there are tools I'm not aware of that make it eaiser? I'm
just typing "rebase -i..." 200 times a day. Is there a less soul-crushing way?

> 
> 
> > +
> > +#include "famfs_internal.h"
> > +
> > +#define FAMFS_DEFAULT_MODE	0755
> > +
> > +static const struct super_operations famfs_ops;
> > +static const struct inode_operations famfs_file_inode_operations;
> > +static const struct inode_operations famfs_dir_inode_operations;
> 
> Why are these all up here?

These forward declarations are needed by a later patch in the series.
They were in famfs_internal.h, but they are only used in this file, so
I moved them here.

For all answers such as this, I will hereafter reply "rebase fu", with
further clarification only if necessary.

> 
> > +
> > +/**********************************************************************************
> > + * famfs super_operations
> > + *
> > + * TODO: implement a famfs_statfs() that shows size, free and available space, etc.
> > + */
> > +
> > +/**
> > + * famfs_show_options() - Display the mount options in /proc/mounts.
> Run kernel doc script + fix all warnings.

Will do; I actually think I have already fixed those...

> 
> > + */
> > +static int famfs_show_options(
> > +	struct seq_file *m,
> > +	struct dentry   *root)
> Not that familiar with fs code, but this unusual kernel style. I'd go with 
> something more common
> 
> static int famfs_show_options(struct seq_file *m, struct dentry *root)

Done. To all functions...

> 
> > +{
> > +	struct famfs_fs_info *fsi = root->d_sb->s_fs_info;
> > +
> > +	if (fsi->mount_opts.mode != FAMFS_DEFAULT_MODE)
> > +		seq_printf(m, ",mode=%o", fsi->mount_opts.mode);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct super_operations famfs_ops = {
> > +	.statfs		= simple_statfs,
> > +	.drop_inode	= generic_delete_inode,
> > +	.show_options	= famfs_show_options,
> > +};
> > +
> > +
> One blank line probably fine.

Done

> 
> 
> Add the rest of the stuff a module normally has, author etc in this
> patch.

Because "rebase fu" I'm not sure the order will remain the same. Will
try not to make anybody tell me this again though...

John

