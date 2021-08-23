Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E118A3FC2
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 21:23:04 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so378762pjr.1
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ShErwyspG88Bo4yVlFpB0fmc1BjfRh8zuGfu0CGRDeA=;
        b=rHIKZbBUCGl81JJDCGO2jSGr728UIVVQ13KxyIxc5kP6Wg5oWA9rRVWif9iIao5pL4
         L8JX62XyKt1eePLQ2AwBJuJrwPwVawP5zim6ZdRWmHiKv2kKR3fko7lTmbKjyT/aQtzo
         MEdxWwqwa1yVZo9MHkLO9AqBKKOAaM2gOsmwCUlHxgSNIJ8uSbFInX867fUxouhXCXBK
         gKKCWO53t3zw6Z8NYQly+wmZgIqWldfA/074D115o3Qsil+IMBtncqlvsQq8DAEwET7c
         V12Srx4AvkF0ONhtcsEFOppkKM7yNRBoaPdKFKb4agsQdX7D6hUMAsWrwA5FtIt/Kyou
         eNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ShErwyspG88Bo4yVlFpB0fmc1BjfRh8zuGfu0CGRDeA=;
        b=rCyxMHFI7yxwVF3KFqcTVW2ysS7UD2z/UsGcd36cXPo5Z0QOxPhL1pYBcOJ1uonzo3
         HNXYvsKY69ooYe3iFBjufevTLZD7YljjIA/IXjDdu597aS7fPSSINf+Px1AcXYoyPJx7
         8Qq3uhapJssplOVtUjZVCMD1EKtfDIt0PvnOGu/v1ASvFONLcM/Ym7pwVLAvdOC8IGud
         kpA0FkH+6owi6NX5Gb+6BO5c2h6qjch3iL4BsUn/U6XftsiBMk34eNwjwpAzdwhlsMkX
         wyo5n4cO1NagJoGlavTYM5pMfxIw29EBq5kCkqG8F0G39xrMToacR6s3WVnHQhO1BJaw
         z7mQ==
X-Gm-Message-State: AOAM530aXcCztpYbKcR1I7+VWuBX9IbZiSXGpUfkVVFMKeU2rmj6Xlot
	lQHZw1VlAcsgDJ1LtgoMtWE2NbJLGFuC6u3odxWLkA==
X-Google-Smtp-Source: ABdhPJx42nu034KgnU+n5z3pwJcpAAmVm/tyH+LAY8tSKD1qwe5mGvbj3AXhqEGCH92DHgFtK8TvIT3ZBlghdPmQxgY=
X-Received: by 2002:a17:902:edd0:b0:135:b351:bd5a with SMTP id
 q16-20020a170902edd000b00135b351bd5amr2141894plk.52.1629753782818; Mon, 23
 Aug 2021 14:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-10-hch@lst.de>
In-Reply-To: <20210823123516.969486-10-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 14:22:52 -0700
Message-ID: <CAPcyv4hNL+ohvTP7VK9zrPDhyVTbUZSD74=z2H2uveudaqi+=w@mail.gmail.com>
Subject: Re: [PATCH 9/9] dax: remove bdev_dax_supported
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:45 AM Christoph Hellwig <hch@lst.de> wrote:
>
> All callers already have a dax_device obtained from fs_dax_get_by_bdev
> at hand, so just pass that to dax_supported() insted of doing another
> lookup.

Looks good, series passes regression tests:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

I can take this with an XFS ack, or if Darrick wants to carry it to
make Ruan's life easier that's ok with me.
