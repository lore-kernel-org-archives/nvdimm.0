Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D657A14534F
	for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043183; cv=none; b=U414wPvJCdAOgMhRrH+f1QHysYsOzlJ/e1se8n4/XtSNDuFFoaQTHd0804cvT5+ACMJVFefdtH5PRxfZE7xszobJvRv41L3CsweA19D2ujFk/SC+s102khoWD3Ul26JPVPx2nFtqjD5HffYmHP+TzFiNrOKagmtaQM1n9VUq/fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043183; c=relaxed/simple;
	bh=vdy2/jshL3R4Tx8oyk8z07nWJMHJ6K0TNsRxmG/PSc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAdkUgNMBCJ+hxslXy0xG5b2+GMmG/MSdt9Bzt008fxWF01rnpmHmEl9Fr7QOvsZmabuJTP7c7FoiKmEL81dr/wvZrWoBsDF2jaUhb6APMGEX1RD/nhpz6ZyrtTpgfd32Rl+k481NmYG6lKLLZL9ZJIFR3bNkqgz5JgZr4Ppdyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bp4ApGOm; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bp4ApGOm"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e4b03f0903so153649a34.3
        for <nvdimm@lists.linux.dev>; Tue, 27 Feb 2024 06:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709043181; x=1709647981; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PGb5zgEK6C2hj+4mYKhczrOkyb0sOdrGR3mLsPhWNC8=;
        b=Bp4ApGOmp89WWxl6PgFqv15ghbQUlbk9MWy+OKawgcViptaQ/+CjSjX79l8Vy2RZy6
         EgJ1BfUhXcjvqqGH1w3uT82LEKlG2o+KCE/EzjbxfAwbjjp+/xUHb3UZX4i234s5OqrR
         ORhOPbRSHm6aStliGCIxLDBA9bFIQBfNiWFJxMTHVESu+QCL049J16NEa5umN1HQRMl9
         6CYG2r04++2HdS2/pEx6yr2U5Oi4C1Bjv2DUpxBcktk/aCGUbFLNFsaM9s7exXNpPYVN
         HoYdBw80LpGi0vT4IJH9ie45jRVNZkrg9NVQEboPwPniPwFT2mjbTqqWmF0V0omA78FZ
         9u0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709043181; x=1709647981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGb5zgEK6C2hj+4mYKhczrOkyb0sOdrGR3mLsPhWNC8=;
        b=mZj6+UzhFn+HaXMpRixEv0UVM/n4ajTQMdUHY0THXe8OHVF6vJ1FyY1Xj0rHTUUpYF
         lKEHRHdJXAXGhaec3dyIglcf9+5XyQ/GLOcVSZMZA9APo/u2C7qNmKXYZUoUjE8sigcn
         ZnhDrG4F9YnGYPU45LlF8yL8CuGpCf2ThVdT6hxf6VFmuCFB8dSA0QTmieHdpZyYmgs+
         G0FamVwLHBU2CrpabIJsS8zM70stYISY+BAGjJmSkNlk/6VWqEizi9GlVLaY6iZxo7P8
         vSlXcKNJD67Y9K65B+PRgADAZLMyhNUtlxGEd5vGmFsYiuv4og/d+e4E0dl2EfrJrD48
         QrWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUkYwvGsQmiLc31narF3/UZoWfPppMMPg0VIzpIUbmAwSmjc0ddc8Pa2uQRP/JqWZD4pklf7/HDRO2Mrk65kJmd28a8ICi
X-Gm-Message-State: AOJu0YxgAEfaM1amjtaeVh5Nd2FoTASmBewJIl5F9lLPgCc/r+Mp1JMf
	95egtM8UAt9lbTUF2rUjfrsSwwH5K0wsYDp95jE2/BQmzjBqomfQ
X-Google-Smtp-Source: AGHT+IH8/5KlM61VXYvgT2KPkGjl5A/QR3/+KkQX0L9Vg1IRz6Sl1T6Dy9r6eVf85Z1umiZN01LQ1Q==
X-Received: by 2002:a05:6870:8291:b0:21e:b3aa:1906 with SMTP id q17-20020a056870829100b0021eb3aa1906mr9462866oae.4.1709043180684;
        Tue, 27 Feb 2024 06:13:00 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id eu3-20020a0568303d0300b006e2e64d2e14sm1507666otb.75.2024.02.27.06.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 06:13:00 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Tue, 27 Feb 2024 08:12:57 -0600
From: John Groves <John@groves.net>
To: Christian Brauner <brauner@kernel.org>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 08/20] famfs: Add famfs_internal.h
Message-ID: <doozhoqznmwg74tc4uvmg2qwzwvga7hyoajb4naso7ptiddmvs@ysxldif4k6rn>
References: <13556dbbd8d0f51bc31e3bdec796283fe85c6baf.1708709155.git.john@groves.net>
 <20240227-kiesgrube-couch-77ee2f6917c7@brauner>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227-kiesgrube-couch-77ee2f6917c7@brauner>

On 24/02/27 02:38PM, Christian Brauner wrote:
> On Fri, Feb 23, 2024 at 11:41:52AM -0600, John Groves wrote:
> > Add the famfs_internal.h include file. This contains internal data
> > structures such as the per-file metadata structure (famfs_file_meta)
> > and extent formats.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_internal.h | 53 +++++++++++++++++++++++++++++++++++++++
> 
> Already mentioned in another reply here but adding a bunch of types such
> as famfs_file_operations that aren't even defines is pretty odd. So you
> should reorder this.

Acknowledged, thanks. V2 will phase in only what is needed by the
code in each patch.

> 
> >  1 file changed, 53 insertions(+)
> >  create mode 100644 fs/famfs/famfs_internal.h
> > 
> > diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
> > new file mode 100644
> > index 000000000000..af3990d43305
> > --- /dev/null
> > +++ b/fs/famfs/famfs_internal.h
> > @@ -0,0 +1,53 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * famfs - dax file system for shared fabric-attached memory
> > + *
> > + * Copyright 2023-2024 Micron Technology, Inc.
> > + *
> > + * This file system, originally based on ramfs the dax support from xfs,
> > + * is intended to allow multiple host systems to mount a common file system
> > + * view of dax files that map to shared memory.
> > + */
> > +#ifndef FAMFS_INTERNAL_H
> > +#define FAMFS_INTERNAL_H
> > +
> > +#include <linux/atomic.h>
> > +#include <linux/famfs_ioctl.h>
> > +
> > +#define FAMFS_MAGIC 0x87b282ff
> 
> That needs to go into include/uapi/linux/magic.h.

Done for v2.

Thank you,
John

