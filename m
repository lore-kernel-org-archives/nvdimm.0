Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB23FC2
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 21:15:58 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id b9so6562591plx.2
        for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 14:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HdgMfJjfBUm06w/tbdcTogg+ww6k//RogO3PbAJzw0=;
        b=QxjpQlOpuTkQV12epR2VAzo/40qiPmok1VA6W1DpNVqrUjJZzo6eDTeOAHSllTPRk5
         PCHJj4sa6Cc+zFYb+qagXaPuZIVnelMvGgQSrmER0WaH8FCD6WbClmdwL/5ivRwnh7Tr
         OlxIZtj6qvJP26iCb46k2X+oYiRGJnM7szuyUAAjyWh/ew+lAPB9DLrS/JNm80ahAaQ3
         OCezKZoWmAZh/d3UXDKW6re2ffhwpL/CbGe+scowDWt4jGvMyKioieZ/cTqBW3/sPEsw
         yQi9J5uIeeS+cZ9Q278rjGN4pnDH5ekMzhp0L914a+t9gnxjIOixK5iNFQn+7bU0o7zt
         ESCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HdgMfJjfBUm06w/tbdcTogg+ww6k//RogO3PbAJzw0=;
        b=ZDnSi7Gf3hI8v5XASK3HdjyNNyLStZQubRomNhkZLE5UxdAQup7u+b1eylS27ynmtB
         noAlRjUI+QkLod6NTb/31Dz7JcskoecArDvR4FsUzffO6YmZZacM4hiEIRyKcA/9tFnb
         s6zxtEMFMA5Maj+GIQWS0yDv0W0PZneVQMIZV/2elAV6gtQk6YLIJDnE8d84zWi3R04X
         zUvuvWqsUcTXfSJizfx9KZ+ZAYbB5UDl7eq2hc9GTQXi2ahKQ/5wHSUyb31J6NfLFWl4
         rnvNDM5Ehpp8evy8TWFmN5zHYYs5BU5LpJAHnMZyKdMpxf0EBYIrGN2ldhYprQwDvO4U
         c9qA==
X-Gm-Message-State: AOAM532nqD8cTF5xdt3xnM4wNGV8VbHCoe7hqsyyGiz6p/q6NhqimtJ/
	eH7fKp9LNifQEBkmfd1vUfFm1RwqnCG90OL7Jw8uWQ==
X-Google-Smtp-Source: ABdhPJwH2kZSUy5ZuN/S6Vj/YVaQMRJ9BeKt4NxFFtK5ME19C8ip4tZgOdf3QfLPpgM4bV40q4bP/8FpdYJXB3P7rOI=
X-Received: by 2002:a17:90b:23d6:: with SMTP id md22mr517969pjb.149.1629753357862;
 Mon, 23 Aug 2021 14:15:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-8-hch@lst.de>
In-Reply-To: <20210823123516.969486-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Aug 2021 14:15:47 -0700
Message-ID: <CAPcyv4hezYrurYEsBZ-7obnNYr0qbdtw+k0NBviOqqgT70ZL+w@mail.gmail.com>
Subject: Re: [PATCH 7/9] dax: stub out dax_supported for !CONFIG_FS_DAX
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 23, 2021 at 5:43 AM Christoph Hellwig <hch@lst.de> wrote:
>
> dax_supported calls into ->dax_supported which checks for fsdax support.
> Don't bother building it for !CONFIG_FS_DAX as it will always return
> false.
>

Looks good, modulo formatting question below:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 0a3ef9701e03..32dce5763f2c 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
[..]
> @@ -149,6 +144,13 @@ static inline bool bdev_dax_supported(struct block_device *bdev,
>
>  #define generic_fsdax_supported                NULL
>
> +static inline bool dax_supported(struct dax_device *dax_dev,
> +               struct block_device *bdev, int blocksize, sector_t start,
> +               sector_t len)
> +{
> +       return false;
> +}

I've started clang-formatting new dax and nvdimm code:

static inline bool dax_supported(struct dax_device *dax_dev,
                                 struct block_device *bdev, int blocksize,
                                 sector_t start, sector_t len)
{
        return false;
}

...but I also don't mind staying consistent with the surrounding code for now.
