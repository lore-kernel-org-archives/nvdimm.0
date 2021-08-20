Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33D72
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 03:08:20 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id w6so5148694plg.9
        for <nvdimm@lists.linux.dev>; Thu, 19 Aug 2021 20:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=th+3o8zziVHjvxzUP987Ww05j4TcgD1JnSG4koxybv0=;
        b=q6wVy4gsAMeGwkQk1GUOlCv3RL83jjFdSVgzVK6FKAVlTxnluo0nxdXMv090oS+6v5
         g/bsuD3TnVs6GjejENx6Ypc13QJi/TkgLHU9+HcG4DHRHbsowvEEqntPZXYalrUu+j31
         syDAnCHyvx3HduCFB+iILfPCIv+IleAOlCNuCLhbaR1BW+2UQ0tOrUKFxEdC+UO92K1/
         4QLTyL7EAEUhfv9vEPkShzVSM6rjyvX4GxezOP/i3Yoj+vduXuzI5RGoQbgTNemm6050
         3oyP1/6v7jPKCnfIP9AKLiBGwOOTQxTStdJIfOldCpt5V13LoApTXFCa0YTEXgvKOvuY
         g4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=th+3o8zziVHjvxzUP987Ww05j4TcgD1JnSG4koxybv0=;
        b=A02CMfF5HOCJvYYLwhqKS2c40TwTvxsSOj7OiLj9DiUbrttI5TeWYd/UUADcmePb7E
         ywsqHCA5Yq4c3aK8J+4ZBwTW5O7tnehMGtAv5OEGpoQNbM+tTVv7fP5TNXOaVxxrAtKe
         uvbt60Yw3iVA/ibjUqbStyXJuh3EVQxZslv0a8k1UaVmi37Moi0T7Y4REJdcnZGDwCYA
         KmS1VH1wHmRAvCqf1N7IfF9jFfAFAs3IssvmPBCirpBBeEbJBSOUD9eo5C2Nvjh/5Jfl
         3m3FNYFg5ndx3FS64D8v6W6Q9bDpyS9ctbs6eFSKAz3RERghMFDAdYRNTWZ5IG2u/eTP
         kccw==
X-Gm-Message-State: AOAM533gxLezVtG8kt3x7FtvzAU/PfRy20ovI5bMSdQQXZVBZyBbnGgM
	UcFqvVqIoA2XpuVWH8ylMmVxXRalsZhNJoRo+Lo9IQ==
X-Google-Smtp-Source: ABdhPJzbHC0+k8uuKZo5a6LFCnA40ZeG97Zg4M+zrZCKnhkWtnjKBCnLq4cagjtK6xI7c9K//8I6Ath0AByLrXcFmCU=
X-Received: by 2002:a17:902:e54e:b0:12d:cca1:2c1f with SMTP id
 n14-20020a170902e54e00b0012dcca12c1fmr14381234plf.79.1629428900343; Thu, 19
 Aug 2021 20:08:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-9-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210816060359.1442450-9-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Aug 2021 20:08:09 -0700
Message-ID: <CAPcyv4gsak1B3Y0xFvNn+oFBCM2DonsyHQj=ASE2_95n6yfpWQ@mail.gmail.com>
Subject: Re: [PATCH v7 8/8] fs/xfs: Add dax dedupe support
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Aug 15, 2021 at 11:05 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Introduce xfs_mmaplock_two_inodes_and_break_dax_layout() for dax files
> who are going to be deduped.  After that, call compare range function
> only when files are both DAX or not.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_file.c    |  2 +-
>  fs/xfs/xfs_inode.c   | 57 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h   |  1 +
>  fs/xfs/xfs_reflink.c |  4 ++--
>  4 files changed, 61 insertions(+), 3 deletions(-)
[..]
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 13e461cf2055..86c737c2baeb 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1327,8 +1327,8 @@ xfs_reflink_remap_prep(
>         if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
>                 goto out_unlock;
>
> -       /* Don't share DAX file data for now. */
> -       if (IS_DAX(inode_in) || IS_DAX(inode_out))
> +       /* Don't share DAX file data with non-DAX file. */
> +       if (IS_DAX(inode_in) != IS_DAX(inode_out))
>                 goto out_unlock;

What if you have 2 DAX inodes sharing data and one is flipped to
non-DAX? Does that operation need to first go undo all sharing?
