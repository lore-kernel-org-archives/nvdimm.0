Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8E12C522
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708965887; cv=none; b=sDLQT3tBvOr5XYzgdPUzQBJf9a7eMa6OSVO7t6vHG8UTA5MSBSx9aRksKB5L3zdUWL3DH3ERsy3QZlkIHPPLOwJ+V8M6BXlMzRb0NKf9DZinnHD5uS/1pcv7DA0OAw3MZq9avr5VANN/yq7FWQDIuiBepFbSAeRGx1jjWbwocFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708965887; c=relaxed/simple;
	bh=y+X8P6lZt8EXbeQAdvQDhauHvvZupVn0T2o0Xx5B1Hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvpXfiwPhKWYBpakyjSvrLRG6fEU/IGM3ZZkKeb6ZoQi9N7h7u3gxnsamBJLMpdgMU+raM91NAZynzDaZyLX4Fv8nE9siKmbyDkha3tzt23wmQVhwA22t4dMfoGVBA+qkqcJ5Gjhg1VOw7lnrWJpBqjyk93EfucV/GMlGh6PiMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3qJoB9s; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3qJoB9s"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-59fb0b5b47eso1331450eaf.3
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 08:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708965885; x=1709570685; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCC5ncNmCyuQF9onN0jRe1hUy7kmROTAo9sKcTGzelU=;
        b=U3qJoB9s7xHdYfHwjoTOm67zwXnpLJWJDc0585x7Uj6Do93zySw3VXZ/lJh5EGGHCY
         R2JN7x5uFAVVbuigxYOU+DG8IWtnod+i7MwaUykmxgspBsuY3vNoc+mA9O8PpPZL7jr8
         t5kVgxAQZu3qjq7KLhxcszCQaFAIRB2nhUxXPDH9JoSd25S/+G1I4mUnZsTa1loVWENm
         ww9WVgfmS/k8xJ1JBxiMrg/T/ZCo5R/VUhyQ5gbvELPocUDJ9n0yRaBdbHK7WJlc3gBS
         b7j+/JjRZwz3s8AFGbOV/Mupz4E0p4xcFrgTrA3mXI4FKotgouv++BNFoGOn0l2Y1DHv
         RV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708965885; x=1709570685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uCC5ncNmCyuQF9onN0jRe1hUy7kmROTAo9sKcTGzelU=;
        b=EieSdO6I+nXRFIT+XR8zEqnc0Sd2mBY39XW50fJ+WynOJla1CXFlQeanndLIQDXLxb
         mw5ILXHAZF4U89uou2ufq6v+SDmU4Q+U4Z8DsuqWgwZ8pCgJSR5zNJv8D2ZNWmc/H/gM
         OsgsTgLCd3n2ycgIZwxb8fQbbKEqhJ2L7wh6w4gR4pcJUCD53oAjU49y/U5450Vk0bUa
         7mYdAPSSuh3Eyl6cYOh7sSh9TCJo2SkiQG/A4yAoy8dp9YkWrgzh3DHScBUor0ZxOm7b
         /fbbqcTrRCcwJTtxsAa0t9KV91sea9lg52FzBYmN02m2E8OcUlDNvHXWwamP65+Y5wqk
         RXvA==
X-Forwarded-Encrypted: i=1; AJvYcCXOgFuuPruGyKY4EcO9nwF47YCodrKTXLhiXfGqtWUCwz10hwU62msNHYTBZjxEcH2T7opCZ/Y/VSW70JqieqY0GgFlWqTY
X-Gm-Message-State: AOJu0YyhwGeVmOnu3eTILIxsiwQl8NKG62bg0vWZF88MeXM/mmfZrWsN
	niR+EV+1Qk0V9qY6mj2J5ILXIq8xFr2cl511yA1ZYaO2SwXL55mZ
X-Google-Smtp-Source: AGHT+IGozyu7911c+C7gQOncF2bMmF1vQ8RhljhCt730pdXma/C5hAI8bPMVZxZqqVpq06NENGZ+Fw==
X-Received: by 2002:a4a:2404:0:b0:59f:fc30:d3aa with SMTP id m4-20020a4a2404000000b0059ffc30d3aamr6789393oof.3.1708965884933;
        Mon, 26 Feb 2024 08:44:44 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id q30-20020a4a6c1e000000b0059fead519bdsm1303036ooc.19.2024.02.26.08.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 08:44:44 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 10:44:43 -0600
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
Subject: Re: [RFC PATCH 07/20] famfs: Add include/linux/famfs_ioctl.h
Message-ID: <z3fx5uiv6uu4sawvxrhfvx42qetchmq4ozxhq2huwg2rrcyk5c@odbiisdhop2m>
References: <cover.1708709155.git.john@groves.net>
 <b40ca30e4bf689249a8c237909d9a7aaca9861e4.1708709155.git.john@groves.net>
 <20240226123940.0000692c@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226123940.0000692c@Huawei.com>

On 24/02/26 12:39PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:51 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Add uapi include file for famfs. The famfs user space uses ioctl on
> > individual files to pass in mapping information and file size. This
> > would be hard to do via sysfs or other means, since it's
> > file-specific.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  include/uapi/linux/famfs_ioctl.h | 56 ++++++++++++++++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> >  create mode 100644 include/uapi/linux/famfs_ioctl.h
> > 
> > diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
> > new file mode 100644
> > index 000000000000..6b3e6452d02f
> > --- /dev/null
> > +++ b/include/uapi/linux/famfs_ioctl.h
> > @@ -0,0 +1,56 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2024 Micron Technology, Inc.
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +#ifndef FAMFS_IOCTL_H
> > +#define FAMFS_IOCTL_H
> > +
> > +#include <linux/ioctl.h>
> > +#include <linux/uuid.h>
> > +
> > +#define FAMFS_MAX_EXTENTS 2
> Why 2?

You catch everything! 

This limit is in place to avoid supporting somethign we're not testing. It
will probably be raised later.

Currently user space doesn't support deleting files, which makes it easy
to ignore whether any clients have a stale view of metadata. If there is
no delete, there's actually no reason to have more than 1 extent.

> > +
> > +enum extent_type {
> > +	SIMPLE_DAX_EXTENT = 13,
> 
> Comment on this would be good to have

Done. Basically we anticipate there being other types of extents in the
future.

> 
> > +	INVALID_EXTENT_TYPE,
> > +};
> > +
> > +struct famfs_extent {
> > +	__u64              offset;
> > +	__u64              len;
> > +};
> > +
> > +enum famfs_file_type {
> > +	FAMFS_REG,
> > +	FAMFS_SUPERBLOCK,
> > +	FAMFS_LOG,
> > +};
> > +
> > +/**
> > + * struct famfs_ioc_map
> > + *
> > + * This is the metadata that indicates where the memory is for a famfs file
> > + */
> > +struct famfs_ioc_map {
> > +	enum extent_type          extent_type;
> > +	enum famfs_file_type      file_type;
> 
> These are going to be potentially varying in size depending on arch, compiler
> settings etc.  Been a while, but I though best practice for uapi was always
> fixed size elements even though we lose the typing.

I might not be following you fully here. User space is running the same
arch as kernel, so an enum can't be a different size, right? It could be
a different size on different arches, but this is just between user/kernel.

I initially thought of XDR for on-media-format, which file systems need
to do with on-media structs (superblocks, logs, inodes, etc. etc.). But
this struct is not used in that way.

In fact, famfs' on-media/in-memory metadata (superblock, log, log entries)
is only ever read read and written by user space - so it's the user space
code that needs XDR on-media-format handling.

So to clarify - do you think those enums should be u32 or the like?

Thanks!
John

