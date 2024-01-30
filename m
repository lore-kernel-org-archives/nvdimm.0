Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D1334CD3
	for <nvdimm@lists.linux.dev>; Tue, 30 Jan 2024 02:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706582332; cv=none; b=dubJEohUp6aubrx+gF0pZtchAAajaeOxEeUdQvJXhd+wV8i/5vw8k/pqS47lgOPpbKMv0AIxnbeIoKm0x3riSvr/ghLj3orTooNTMBSuOVcZR6e+KOvOA8VYOQyagdAsDeeLE7U2L1rIx8H/pu+a5DvsX6EArIdqaKlPHBJ2Yaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706582332; c=relaxed/simple;
	bh=L89IzrilsDGveQdWAYWcXjFYMXSJQAdLrLejwXbXPuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujUotML0JAbnO+l9kOK2OFgwjJ3jjsTgLD3DyMVNOGVcKj5I4A9JIVqPxR+BRM+5wOBKU6zLyQAulKTdewKkH0VpfLMW73Tl3vrLElMMH0X57pQkd5fZ6I6zBnWo9VGilXymUnObCWAllfjX54r7YoA9mcpPDZvjNAMaTMkcewA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sEGaAf4m; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sEGaAf4m"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d8f3acc758so8060515ad.1
        for <nvdimm@lists.linux.dev>; Mon, 29 Jan 2024 18:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706582330; x=1707187130; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hqxjY1ElxNAwoveLPHwWFoaAKo7t78H+KCuILCPEg64=;
        b=sEGaAf4mKSdZR9RAUiJRjkkIW/ISAwEWvWwVDfW38z8JbkcDnPidHb3Kv+I6mpcSpH
         JxMROlus0Np0i6jX1mTzcsJkTfEPPRNc4KgrmUpvCt/CgjTgPqlHoRFPcu+IHfxRVQMs
         Zts/z+flrsJMKE6MtEHpZY0qhumTcABqStI44nB9PTVeKt9c73+2jdXstqwtz1LZHVge
         3t34jmrd342gqIgP4cmllJLhEeV2RveUk/Fek03wfg6s5vqB5xNEUfTOoqRmvok2XqTA
         iqYrC5m9MS3LOVEwuIDm50b/p6mweIaP1WoQW+3YIVqTJ6gxFkfFH4sWYwowqNXZCrBd
         +Vtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706582330; x=1707187130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqxjY1ElxNAwoveLPHwWFoaAKo7t78H+KCuILCPEg64=;
        b=lveEzEdvbO18hgpEWJgCQli2Tj1q8ySqT72w/fEXR5XgBmAEmg2ljqFiXsfrrDzpwT
         fys8+xLGrMe0OxlEVaOoonxSEQEYFakB3bTXp2FjjZDt3QMzR7T/rZVfRwj5Muv+DBLc
         YAX8JUTBvxgR6lfVkSH9yM/0ODvpkwcA83SdmBpEfNxe6KdmRdyC3fxNQVKM3nOvZXA9
         JVrLb8ph2pjy+xfAJBlTOTDZWi3mwVtklo1hrmLc28Q7uXDEWmSXNXq1mpDFcsnIB4m0
         0ehyd1LkVKjOXk5pbdaE7R78IjWiFNWzwm1XpxN/DBhyXftBuOqSAKEbaC+955vALZHg
         vJJw==
X-Gm-Message-State: AOJu0YzlSxZfHIG2Gvre1aRmIPCXnAcO3DzLvzUAxmfMOGQUPYEdLZA1
	nBiYE5WHWPLi+SYpY89AJU+Txovhqk+npHKP7YPqqdxNSJ1BcarbEbPs+cmpWpU=
X-Google-Smtp-Source: AGHT+IG3Tf1LicjzS4Qa3v1HBWJ0okdxx8XgE9n1laWHdO3qtQvRbO5N3KnA5oTi64pctq5hmJtDrA==
X-Received: by 2002:a17:902:d550:b0:1d7:1a90:65ba with SMTP id z16-20020a170902d55000b001d71a9065bamr500304plf.25.1706582329913;
        Mon, 29 Jan 2024 18:38:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id ml8-20020a17090334c800b001d8fb16118csm1038823plb.267.2024.01.29.18.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 18:38:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rUe1O-00H85k-2a;
	Tue, 30 Jan 2024 13:38:46 +1100
Date: Tue, 30 Jan 2024 13:38:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [RFC PATCH 7/7] xfs: Use dax_is_supported()
Message-ID: <ZbhhNnQ+fqd4Hda+@dread.disaster.area>
References: <20240129210631.193493-1-mathieu.desnoyers@efficios.com>
 <20240129210631.193493-8-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129210631.193493-8-mathieu.desnoyers@efficios.com>

On Mon, Jan 29, 2024 at 04:06:31PM -0500, Mathieu Desnoyers wrote:
> Use dax_is_supported() to validate whether the architecture has
> virtually aliased caches at mount time.
> 
> This is relevant for architectures which require a dynamic check
> to validate whether they have virtually aliased data caches
> (ARCH_HAS_CACHE_ALIASING_DYNAMIC=y).

Where's the rest of this patchset? I have no idea what
dax_is_supported() actually does, how it interacts with
CONFIG_FS_DAX, etc.

If you are changing anything to do with FSDAX, the cc-ing the
-entire- patchset to linux-fsdevel is absolutely necessary so the
entire patchset lands in our inboxes and not just a random patch
from the middle of a bigger change.

> Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Chandan Babu R <chandan.babu@oracle.com>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: linux-xfs@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-arch@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: nvdimm@lists.linux.dev
> Cc: linux-cxl@vger.kernel.org
> ---
>  fs/xfs/xfs_super.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 764304595e8b..b27ecb11db66 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1376,14 +1376,22 @@ xfs_fs_parse_param(
>  	case Opt_nodiscard:
>  		parsing_mp->m_features &= ~XFS_FEAT_DISCARD;
>  		return 0;
> -#ifdef CONFIG_FS_DAX
>  	case Opt_dax:
> -		xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
> -		return 0;
> +		if (dax_is_supported()) {
> +			xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
> +			return 0;
> +		} else {
> +			xfs_warn(parsing_mp, "dax option not supported.");
> +			return -EINVAL;
> +		}
>  	case Opt_dax_enum:
> -		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
> -		return 0;
> -#endif
> +		if (dax_is_supported()) {
> +			xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
> +			return 0;
> +		} else {
> +			xfs_warn(parsing_mp, "dax option not supported.");
> +			return -EINVAL;
> +		}

Assuming that I understand what dax_is_supported() is doing, this
change isn't right.  We're just setting the DAX configuration flags
from the mount options here, we don't validate them until 
we've parsed all options and eliminated conflicts and rejected
conflicting options. We validate whether the options are
appropriate for the underlying hardware configuration later in the
mount process.

dax=always suitability is check in xfs_setup_dax_always() called
later in the mount process when we have enough context and support
to open storage devices and check them for DAX support. If the
hardware does not support DAX then we simply we turn off DAX
support, we do not reject the mount as this change does.

dax=inode and dax=never are valid options on all configurations,
even those with without FSDAX support or have hardware that is not
capable of using DAX. dax=inode only affects how an inode is
instantiated in cache - if the inode has a flag that says "use DAX"
and dax is suppoortable by the hardware, then the turn on DAX for
that inode. Otherwise we just use the normal non-dax IO paths.

Again, we don't error out the filesystem if DAX is not supported,
we just don't turn it on. This check is done in
xfs_inode_should_enable_dax() and I think all you need to do is
replace the IS_ENABLED(CONFIG_FS_DAX) with a dax_is_supported()
call...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
