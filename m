Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FCD22B8B5
	for <nvdimm@lists.linux.dev>; Wed, 21 May 2025 22:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747866619; cv=none; b=iv5yUBajAtIsn0sdcr+kSimu/hEkoutvg+uQ06gFrMD5amL2V9MHaI2n8M9MAdBDIGKyHSe3JYPheTHQfcpVFogoN4tYuTOl/ccge1LR39SlA76Ol1y+K8YAGz0hURgtNCFtUVkno3HmhkhV+eLB6vbE/7SNtbwsEFJjUrIbqzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747866619; c=relaxed/simple;
	bh=nb9O4TtCOuppud69ug4IkU6bS5EpzMCb96C4mzfPqcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJc0C2yCLsusDJaXZF1BxodW5ROmB9p6vhAkGwwoe3KjYJZIK24dyygm2JdxUF+qRMcrvQwCXqTsiNaUP1CxYTehrApkAJK5zJLXrBel0L7Yz3R0SnMdODBtbJkRLv4aUNP9znwg1btAXXI7h6o/nA1xEkav0+m8L0dnE0vvXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EP27ybdF; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP27ybdF"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3feaedb531dso2033307b6e.3
        for <nvdimm@lists.linux.dev>; Wed, 21 May 2025 15:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747866616; x=1748471416; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nb9O4TtCOuppud69ug4IkU6bS5EpzMCb96C4mzfPqcs=;
        b=EP27ybdF5P0Rrg+GCHd3wbRQpB7V6EoqvJE3+ZAifIC3ysadsWYH0rcxuTjGmVv+Tj
         zqtty1TfDVSxmurQCSNZ7r9d7p/npluSufXvodPAQDBi7+ll85mBOIu1jMnDUmS1GLjC
         ZEpanMgzwXNk7vXYD6/tkBjCoww/2+y4eJRcDoXDpx/BNboWPzzlkm14DGxBHmkggR/W
         rkpo7SSytLm4kFE8G7kLf7/3DHtIB6mP41M7h0QwXS5njGtGa7Pat0GLJN7cmq3vxxgM
         g7KCkATcGiiDfbd27F32qcmkNy5JYF8L4gCawNgKyWET2gQBoZOWzj7WUKLKItLRT3Dz
         uPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747866616; x=1748471416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nb9O4TtCOuppud69ug4IkU6bS5EpzMCb96C4mzfPqcs=;
        b=m2UvPyyL3XIbRZqeaqm+W9K9t2E+YhPhZHf/v88CvGnHu0Mbn9gpZsuGNSAOlScUGZ
         8BpX1nhF+Jb6SSELLxKM67AbepmdnlTHskU0ZlGuFxOSaGxsDQnfrxable2fuZ+BD5+U
         oPxonO9EyrW7B1sbfRSeal6/rJjFIZGJCYqP0XuawWqozdGcJnx+8XVG1bZVOT5wZ9zK
         4ePhgPkkr6Wlk4Ozac67D9C/goylUaXhy5Ahj1DcZe7TdAv906jMHj1P4HzHtvLsk143
         uTLFM4h4wZECbW1Tu/6kVnnmTlQijgmLB5URxC7vPNmlK43tcnt3p5yCqUk1+NbrYDf5
         QZLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLXgXzyO7CPE0hBOF4f5la8PpN3PDHtL2FA6yRPi1rbpZIesHRhEaXx8Ot0OA1qSJcbSFqxsY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywqx1ImV3RbaJybeDUIffCzL4zw34lbdL/+WsvH001+qjX9d/pn
	xu5ZuIW6tOAEN6VzfPfLwm1sq7EdM9KYlFEE4EDjG30sRgb1Ka7G2zM1
X-Gm-Gg: ASbGncuZtAIrjdyOlyyaNtybMyUIpCiJdDxwXjagAMS6uoL+0p7BeCTPydGKzoScFmi
	ol9eom0xXv0kWS520tIwqPh2GNyPh/f+bFxt+cZ/Uybs8OlQOF4oW2nOxpQaAHEbG0OeIGkDo4n
	xXk2LO08mAs46rEGT8QCVOolC3oBrZR3O9m47z/tob1S6TLhinuf+kZ1jpSs0iXNeJFBY5xfgBu
	K9lG9J6FgP2ABfY5yRdjpKpDk1dltb15IE0ZdbmQiQVNXCvMRyjg3tiOq63BSD1h0noOITY4Ixk
	Q0rwEYqBh+Equ0Vm9qR3+SpekGL1eUgkRKeo7V+EP71n8N+FDku3Pzcu2yNYsASSyNoXoGQ=
X-Google-Smtp-Source: AGHT+IFRVrKFlC0xucIoI6A+MH0Ub4hMMxnTf/HTOcSeOiiFXD7vWW4zpucHXKEWzpbcRbmwqIHzEQ==
X-Received: by 2002:a05:6808:6c8b:b0:403:37dd:e26f with SMTP id 5614622812f47-404da82bb8dmr14303754b6e.33.1747866615474;
        Wed, 21 May 2025 15:30:15 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:b8ec:6599:4c13:ce82])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-404e303ffcasm2023067b6e.4.2025.05.21.15.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 15:30:14 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 21 May 2025 17:30:12 -0500
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, Alistair Popple <apopple@nvidia.com>, john@groves.net
Subject: Re: [RFC PATCH 00/19] famfs: port into fuse
Message-ID: <hobxhwsn5ruaw42z4xuhc2prqnwmfnbouui44lru7lnwimmytj@fwga2crw2ych>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250421013346.32530-1-john@groves.net>

On 25/04/20 08:33PM, John Groves wrote:
> Subject: famfs: port into fuse
>
> <snip>

I'm planning to apply the review comments and send v2 of
this patch series soon - hopefully next week.

I asked a couple of specific questions for Miklos and
Amir at [1] that I hope they will answer in the next few
days. Do you object to zeroing fuse_inodes when they're
allocated, and do I really need an xchg() to set the
fi->famfs_meta pointer during fuse_alloc_inode()? cmpxchg
would be good for avoiding stepping on an "already set"
pointer, but not useful if fi->famfs_meta has random
contents (which it does when allocated).

I plan to move the GET_FMAP message to OPEN time rather than
LOOKUP - unless that leads to problems that I don't
currently foresee. The GET_FMAP response will also get a
variable-sized payload.

Darrick and I have met and discussed commonality between our
use cases, and the only thing from famfs that he will be able
to directly use is the GET_FMAP message/response - but likely
with a different response payload. The file operations in
famfs.c are not applicable for Darrick, as they only handle
mapping file offsets to devdax offsets (i.e. fs-dax over
devdax).

Darrick is primarily exploring adapting block-backed file
systems to use fuse. These are conventional page-cache-backed
files that will primarily be read and written between
blockdev and page cache.

(Darrick, correct me if I got anything important wrong there.)

In prep for Darrick, I'll add an offset and length to the
GET_FMAP message, to specify what range of the file map is
being requested. I'll also add a new "first header" struct
in the GET_FMAP response that can accommodate additional fmap
types, and will specify the file size as well as the offset
and length of the fmap portion described in the response
(allowing for GET_FMAP responses that contain an incomplete
file map).

If there is desire to give GET_FMAP a different name, like
GET_IOMAP, I don't much care - although the term "iomap" may
be a bit overloaded already (e.g. the dax_iomap_rw()/
dax_iomap_fault() functions debatably didn't need "iomap"
in their names since they're about converting a file offset
range to daxdev ranges, and they don't handle anything
specifically iomap-related). At least "FMAP" is more narrowly
descriptive of what it is.

I don't think Darrick needs GET_DAXDEV (or anything
analogous), because passing in the backing dev at mount time
seems entirely sufficient - so I assume that at least for now
GET_DAXDEV won't be shared. But famfs definitely needs
GET_DAXDEV, because files must be able to interleave across
memory devices.

The one issue that I will kick down the road until v3 is
fixing the "poisoned page|folio" problem. Because of that,
v2 of this series will still be against a 6.14 kernel. Not
solving that problem means this series won't be merge-able
until v3.

I hope this is all clear and obvious. Let me know if not (or
if so).

Thanks,
John


[1] https://lore.kernel.org/linux-fsdevel/20250421013346.32530-1-john@groves.net/T/#me47467b781d6c637899a38b898c27afb619206e0

