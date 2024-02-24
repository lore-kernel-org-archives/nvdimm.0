Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE663DF
	for <nvdimm@lists.linux.dev>; Sat, 24 Feb 2024 02:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708741407; cv=none; b=qrPQYZ1BUQFTR1cqNmis/ZloLR2e82hIgJBxPs3dAHV1QRiQpOlAXrhduuFg4Ev3Q2WI0cUuyXaY5KhYO06B9M1NYTxjy76QM9NG6ji5Is283cZN9xtdB7qCN+vIcqyO+NA5xFSoD6tmCMsYtWRcwh87FW1Qz0Zi43RGkD5bhHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708741407; c=relaxed/simple;
	bh=EWzIBMOYZahpCUPse8Ld+LyDtQlXxNMeWHPAUOF8KvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EInP3iuFt1OdRVXd51XB+bCVGBg1CPJdUdN9QDO1D6eelLeh3eoYQR2Q0DwU9no1jyx9wyNcDgX9nT0ioH3kejxy5RiOWMBQ09P2B6m92f5hpz1p+UIFTjMfDJzaMMZyT69+QfqDmUcXdjVphIBgh22oZA7P17WrOhzzaaskiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqI9oW9M; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqI9oW9M"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6e48153c13aso575884a34.3
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 18:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708741404; x=1709346204; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8+9bHGR06XHBSUgitwSrQmp0adstHwb6bNPHQIZNo6s=;
        b=RqI9oW9Msyf8VFN1PAit2QcabkCWTnKuih6y7uXpKxG0ipWGg7DHXpRcTY5cjjQ7Ip
         TJrKR8RLXKof3cvflUyTGJ5ZEH2+3ZdRi0RcioqmLf6iXxI9vBPN5zdhiI1Z61Q3nDMI
         K2gW4B1TQ6m54hKYyz9WiJEO1+irPH+ahCbAhgmJtyMUL96NXJwuLm8kd+hfLTkQv0Lw
         LMX/Lbr/FHmSj3gGVumGcFRKgjalUokF+jGaOV8BB7K3sJDWIHQTCQtBtEdQ4zxPbWUg
         ly3p5OLvgN7JCe1tG0pSP6IDRLESVVNng3y5ymzmKDfeZFnZdDQa2zIzrr9jXIeLA4wi
         WaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708741404; x=1709346204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+9bHGR06XHBSUgitwSrQmp0adstHwb6bNPHQIZNo6s=;
        b=Sc+9FNMJ2iFblFp/IJbUC6sjPzNUpYhUns3Qg0NT8nJUUxLfq54rpe9AKKbZ25P9Of
         MOdsNV0bqHE+uUsal0UWmclPLr7v9ayUSWyqRAC99wlhORLvaudjuLcYg9QQEbFrkEpc
         ejwbEOGgOafXSUFGVChvj+uDzochElsBOwMwTiGcNdvIqX5tdh5Jnb47EaAjlpxipDB/
         cIkorYJZf5l4GRVn6EipGy1nrIYqoBauzhBx/sa3vyyvuyiSm2ehyVMrwsqXuKPnuOpp
         ZP59wq2ArVmIhwJpFk3qA/TAgScoUlz7spKYODrkZGINiYI/fAAxi1pFqgcYLMHg9fQr
         QMIA==
X-Forwarded-Encrypted: i=1; AJvYcCWNRuRnJRRYn5NtorZYsBctMU12AgPFbz1TmW0f5aggPiFuSgT3OU1bx1JKcPavffv0IdUsTKYqpxECm3DFJQ+l6f0/cSgl
X-Gm-Message-State: AOJu0YxI4z/t+dfzaaD8xvBwh1e61b0IObgtI2CyX5PDx1jELyCl6QB7
	Ih7FdPNYN8ZfF08MGa3iGGfjZ7pZR7K/HRFJDdmtNp+4KxwVK4yW
X-Google-Smtp-Source: AGHT+IHsTo8lMNP09wsnI8P9igNi5kOPRrCfIRMTWkyNPOwyqA7p4iXPWhKj47VAFaSP8TaYIv7d4Q==
X-Received: by 2002:a9d:6246:0:b0:6e4:7aa6:1432 with SMTP id i6-20020a9d6246000000b006e47aa61432mr1537909otk.28.1708741404420;
        Fri, 23 Feb 2024 18:23:24 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id d7-20020a9d4f07000000b006e42884bad9sm91752otl.1.2024.02.23.18.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 18:23:23 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Fri, 23 Feb 2024 20:23:21 -0600
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
Subject: Re: [RFC PATCH 07/20] famfs: Add include/linux/famfs_ioctl.h
Message-ID: <7onhdq4spd7mnkr5c443sbvnr7l4n34amtterg4soiey2qubyl@r2ppa6fsohnk>
References: <cover.1708709155.git.john@groves.net>
 <b40ca30e4bf689249a8c237909d9a7aaca9861e4.1708709155.git.john@groves.net>
 <8f62b688-6c14-4eab-b039-7d9a112893f8@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f62b688-6c14-4eab-b039-7d9a112893f8@infradead.org>

On 24/02/23 05:39PM, Randy Dunlap wrote:
> Hi--
> 
> On 2/23/24 09:41, John Groves wrote:
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
> 
>       This is confusing to me. Is it just me? ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Thanks Randy. I think I was trying to say "based on ramfs *plus* the dax
support from xfs. But I'll try to come up with something more clear than
that...

> 
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
> > +
> > +enum extent_type {
> > +	SIMPLE_DAX_EXTENT = 13,
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
> 
> "/**" is used to begin kernel-doc comments, but this comment block is missing
> a few entries to make it be kernel-doc compatible. Please either add them
> or just use "/*" to begin the comment.

Will do, thanks. And I'll check the whole code base for other instances;
I won't be surprise if I was sloop about that in more than one place.

> 
> > + * struct famfs_ioc_map
> > + *
> > + * This is the metadata that indicates where the memory is for a famfs file
> > + */
> > +struct famfs_ioc_map {
> > +	enum extent_type          extent_type;
> > +	enum famfs_file_type      file_type;
> > +	__u64                     file_size;
> > +	__u64                     ext_list_count;
> > +	struct famfs_extent       ext_list[FAMFS_MAX_EXTENTS];
> > +};
> > +
> > +#define FAMFSIOC_MAGIC 'u'
> 
> This 'u' value should be documented in
> Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
> and if possible, you might want to use values like 0x5x or 0x8x
> that don't conflict with the ioctl numbers that are already used
> in the 'u' space.

Will do. I was trying to be too clever there, invoking "mu" for
micron. 

> 
> > +
> > +/* famfs file ioctl opcodes */
> > +#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC, 1, struct famfs_ioc_map)
> > +#define FAMFSIOC_MAP_GET       _IOR(FAMFSIOC_MAGIC, 2, struct famfs_ioc_map)
> > +#define FAMFSIOC_MAP_GETEXT    _IOR(FAMFSIOC_MAGIC, 3, struct famfs_extent)
> > +#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,  4)
> > +
> > +#endif /* FAMFS_IOCTL_H */
> 
> -- 
> #Randy

Thank you for taking the time to look it over, Randy.

John

