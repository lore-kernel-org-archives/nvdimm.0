Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274E41110
	for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 11:32:57 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id g22so2809237uap.3
        for <nvdimm@lists.linux.dev>; Sun, 13 Nov 2022 03:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QZvRyD4M5+zFkbDYVhqBnw+Q9GmoKf7/UeDVhKpYoo=;
        b=dPIz6bgV7rDD8gW2kNtZ+bKKj7qTFHbJbnAwN/sPkcbIclY5/ZrLy8rQlfcn38C5wl
         CyPzOiqhGAYcAfyQd2fQ26hgxFtFuN4MCp1rpKbwkzzzFHpu1vaVMeTk8otm9mRHQhLs
         oAOLHum09VrK7MelP/FPKwfv8xggfW5xHEikdEh66xBHEcfAe6q18azDyzSTE4lF4Cs+
         WnygNKcRqyf6F3o+UNgMRqKMTmE7tkul/w6XB0rugqKwQSfl/BQ/jpwKlta0vVyiBAzI
         tCM9nukH8PWin8iEzjioKCjN8Cj36eFnhYy/DkwzIokja7+6bFTvkbwI3Zy0qnSsszfk
         vPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QZvRyD4M5+zFkbDYVhqBnw+Q9GmoKf7/UeDVhKpYoo=;
        b=lP3oB0/OQOkK8jIhJlp2j8b9GpSrUzehYRZcsWgo7Go5fo6aoZpN9QiCGV4IKUHBCr
         ixa1KnWe0l8yBdzhsiVQKY8bgaZ0PH88EKh+Usg+bvS6ZzQjy9FKwlGOTPCT3SuUlfO3
         iR9c32sUUo9UcNGCTvtM3TMwKglrWszkBao3386RnKOUdff1UHxXTgkc/CP7bvGTl8eZ
         dcDF1Ee9u3cecHiLFApFKOF52AOI73dG+J4jHVzIxbnBkpSE/xDpHaDvuAfKkB0XQRpf
         nX978ouipl22kJHM/BdTxskBFU4ACiHLWv9LiMYsN7tN/LB/XI7xiX8Nbe9au4r1t/NF
         PKyQ==
X-Gm-Message-State: ANoB5pljdWQ5OQ5dRHlUjHsBSv9H3IPsjDf8mT5052kSjuY+ffIH8LhI
	om/XKJPsTGmImZ9Qqc7dxwdn4vH4QzMWPGCtUpI=
X-Google-Smtp-Source: AA0mqf6lzzI7oOuLBkJTezEkfY4Josaj54aJ/MqWrp2JaM0BbPQwqbTXOMVJz9M8+sGJoNOx7/7X3yDibtJ9h3Jc0fY=
X-Received: by 2002:ab0:3b5a:0:b0:415:8954:bd51 with SMTP id
 o26-20020ab03b5a000000b004158954bd51mr4455074uaw.97.1668339175936; Sun, 13
 Nov 2022 03:32:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221113112653.12304-1-tegongkang@gmail.com>
In-Reply-To: <20221113112653.12304-1-tegongkang@gmail.com>
From: Kang Minchul <tegongkang@gmail.com>
Date: Sun, 13 Nov 2022 20:32:44 +0900
Message-ID: <CA+uqrQABhoUAoJ8S4iAKn-=zouDJu=jaB29BgL4oLa5jxtGeCg@mail.gmail.com>
Subject: Re: [PATCH] ndtest: Remove redundant NULL check
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2022=EB=85=84 11=EC=9B=94 13=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 8:26, =
Kang Minchul <tegongkang@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> This addresses cocci warning as follows:
> WARNING: NULL check before some freeing functions is not needed.
>
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/te=
st/ndtest.c
> index 01ceb98c15a0..de4bc34bc47b 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -370,8 +370,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv=
 *p, size_t size,
>  buf_err:
>         if (__dma && size >=3D DIMM_SIZE)
>                 gen_pool_free(ndtest_pool, __dma, size);
> -       if (buf)
> -               vfree(buf);
> +       vfree(buf);
>         kfree(res);
>
>         return NULL;
> --
> 2.34.1
>

I just found an earlier discussion about the same patch as mine.
Please ignore this patch.

Thanks.

Kang Minchul
