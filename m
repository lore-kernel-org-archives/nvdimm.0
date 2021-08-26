Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADE53FCB
	for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 14:37:40 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id e7so3276209pgk.2
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2HF2Xls84jUZ7suMHbKiqQQLoSKjQ0Sp55OfKg/g+s=;
        b=Dco0Ve1HsF5HR6fQPSDcbsON7RovI6+GXbCjwy05Qf/MIvb+uEReb2jP0tUbbZNBUc
         RDLIpbZxUIgA2DcUbnEPUcoa+gAsV3xXBk0QJbhyJ6AN0mBlTsAOZgRyAYEF+kjGHOUq
         LAYslifFUXbJ5Kk6yi/lbXXokRTgOPv+Y5EQ3uNcweWCWEqgB8Z5VtwNKT+Yx9Jeg74V
         NSoDfvU5VDppT5xzPl0U17d/zETFIEcB8wplMdGZiW+W4bQDUs4XrknFSI+mRn3FrAoY
         ffP5hmJ6LWFsNAaXH9PegEQu0nH284g/XB2yoZc81qwEmGJMYlrhSyIHm3yufqyzLf7N
         vRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2HF2Xls84jUZ7suMHbKiqQQLoSKjQ0Sp55OfKg/g+s=;
        b=MoZG5PQhztY2NMFembppv4b+QylD6U8mCZ4vE+zOjrh7+TZQLD4Nju9o0G2NaTir/R
         lKOSck9RyyX9LQzP2rSse6O+0XaHAtb+i5tfDUc1M5aZY5BPMfhuk1rlF38aMp6A0KQ6
         iOUOtgkRnoPnpnmNzyUTtBj+fdxqISRP0VlwlpQqWvvHCIta3TzhOjkXFheRGmgqH9q2
         +YZQgOzMo0Sj+7JwVRTX0h8/SpBMTEYIOMsKpJ/cpm6BCcWeYwf8UQBNnyO1oShw/3XH
         2aW1vNKf3iI5k/TXoeqFWIuvfdk75X7Dwdnh/+WKbPFwSI95fwkq4P0i2hFtez0SjrVO
         Mn4g==
X-Gm-Message-State: AOAM5321GTNFz9CAUoGfO5NkChUj3QfTxY6N0SQU7B83wgZ230+VUTvA
	3CoE2tVRYjRQ3l7VJ4EqplkVCMKHFmDesqA8kTrKoQ==
X-Google-Smtp-Source: ABdhPJxMKI6O3/cUhf97XeZzMtCS61IH/s/SfH2Ap1H+km08WqpkwpkZUAqzW4rOPcMFxINeVXaRQxmOOQTgAbmdNrE=
X-Received: by 2002:a65:47c6:: with SMTP id f6mr3651187pgs.450.1629988660383;
 Thu, 26 Aug 2021 07:37:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210826135510.6293-1-hch@lst.de> <20210826135510.6293-9-hch@lst.de>
In-Reply-To: <20210826135510.6293-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Aug 2021 07:37:29 -0700
Message-ID: <CAPcyv4jXAxSABiZ543xDWOnx0xGAq+LqjbQdqjs+6wbFgsqYyg@mail.gmail.com>
Subject: Re: [PATCH 8/9] xfs: factor out a xfs_buftarg_is_dax helper
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"

[ add Darrick ]


On Thu, Aug 26, 2021 at 7:07 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Refactor the DAX setup code in preparation of removing
> bdev_dax_supported.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  fs/xfs/xfs_super.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)

Darrick, any concerns with me taking this through the dax tree?

>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c9e26a44546..5a89bf601d97 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -314,6 +314,14 @@ xfs_set_inode_alloc(
>         return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
>  }
>
> +static bool
> +xfs_buftarg_is_dax(
> +       struct super_block      *sb,
> +       struct xfs_buftarg      *bt)
> +{
> +       return bdev_dax_supported(bt->bt_bdev, sb->s_blocksize);
> +}
> +
>  STATIC int
>  xfs_blkdev_get(
>         xfs_mount_t             *mp,
> @@ -1549,11 +1557,10 @@ xfs_fs_fill_super(
>                 xfs_warn(mp,
>                 "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>
> -               datadev_is_dax = bdev_dax_supported(mp->m_ddev_targp->bt_bdev,
> -                       sb->s_blocksize);
> +               datadev_is_dax = xfs_buftarg_is_dax(sb, mp->m_ddev_targp);
>                 if (mp->m_rtdev_targp)
> -                       rtdev_is_dax = bdev_dax_supported(
> -                               mp->m_rtdev_targp->bt_bdev, sb->s_blocksize);
> +                       rtdev_is_dax = xfs_buftarg_is_dax(sb,
> +                                               mp->m_rtdev_targp);
>                 if (!rtdev_is_dax && !datadev_is_dax) {
>                         xfs_alert(mp,
>                         "DAX unsupported by block device. Turning off DAX.");
> --
> 2.30.2
>
>
