Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA470
	for <nvdimm@lists.linux.dev>; Wed, 16 Jun 2021 00:49:00 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso2955715pjb.0
        for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 17:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N705IiD7n6FnNdMOVPwQtLkiV4KgkJ6X1/De6zQZWwI=;
        b=Vdg0YlGJ8YdIQxJsskt857Kp1UiDME+54VPtdHVPVXgoShl4VVVAaR6LXE0dbZKVV2
         +W+U4JeT3w/znleh/vZYdYXLbeE/pb0HV5ZEWUPDcvLxO26mt2qXZgivFzn3uSvahElD
         IwGdaPoF4IcRH7qJIdQjXQmZCbal2lLL+QkYNIl2RRjAfHR9PYesk+uc+Sgyx5CZHFfl
         e2DUPodC5WlhmtLJUFdwdvpJ9eljMdTNGqS+3FoZy7nhDaFOgT1hWfV8NXRx6YQNwhKl
         h2XdYcERWOQAJ9xAgYdgl/J4fe3qT8u41yhXFC39k2ZstvQJHVRG9+iqruFGveOSagxS
         R4dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N705IiD7n6FnNdMOVPwQtLkiV4KgkJ6X1/De6zQZWwI=;
        b=rgVkkbPBvKbz178Zl3VNdIYmUX1nacXOLi3LFti6lU++vlOiqZUi6173G6RuagoROR
         O/sG7SluaJluP2iJptG6TnSzEA4x5/vvExJWQyRAcWeGNZsurVnQLS/xdU/ze/AJO0PF
         LR1ldSxf2iEvzEOWTErVhXLfD2GRVd+6gL8Gm8c8hH9D82yeeTGfkVgdXUCBMxtvbBYL
         vRE9iGkx7Cja4BUBhtp79tyEcy/J+K73LA59Ryr4R8lGaKsRWGeRC0tOlQcNimIPH43c
         5vipyizYvS6s+EdmgrO/1VKH05FnAIAbj0FF834yozly/1IUKYRE/EeY33fvMYFAuITy
         L7Cw==
X-Gm-Message-State: AOAM531cnO6kGisy6w3lu+UMBovyB1ZXklcz1eM5tdH4WwRLvlFF7wRh
	8vUOB1gJP7qp4/e46lTc3F83UfKmLLvprskeOxZYTw==
X-Google-Smtp-Source: ABdhPJyPFTJSM7pJ7JUKFEZ8HQ+iir1f0oux2sr4aUWcOno+cjQdFNUvLXFLljz8kRS7NiWvMxxI/6TF54PHQ215JUQ=
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr7683966pjn.168.1623804539893;
 Tue, 15 Jun 2021 17:48:59 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210604011844.1756145-1-ruansy.fnst@fujitsu.com> <20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210604011844.1756145-4-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Jun 2021 17:48:49 -0700
Message-ID: <CAPcyv4h=bUCgFudKTrW09dzi8MWxg7cBC9m68zX1=HY24ftR-A@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] fs: Introduce ->corrupted_range() for superblock
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, 
	david <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

[ drop old linux-nvdimm@lists.01.org, add nvdimm@lists.linux.dev ]

On Thu, Jun 3, 2021 at 6:19 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> Memory failure occurs in fsdax mode will finally be handled in
> filesystem.  We introduce this interface to find out files or metadata
> affected by the corrupted range, and try to recover the corrupted data
> if possiable.
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>  include/linux/fs.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c3c88fdb9b2a..92af36c4225f 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2176,6 +2176,8 @@ struct super_operations {
>                                   struct shrink_control *);
>         long (*free_cached_objects)(struct super_block *,
>                                     struct shrink_control *);
> +       int (*corrupted_range)(struct super_block *sb, struct block_device *bdev,
> +                              loff_t offset, size_t len, void *data);

Why does the superblock need a new operation? Wouldn't whatever
function is specified here just be specified to the dax_dev as the
->notify_failure() holder callback?
