Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B10F72
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 23:50:15 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id w6so12145964pll.3
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 16:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIoT3CHcF6Ui6SUKTLSeS0m12Ndh8eiq7ywYH+1sD+8=;
        b=XrS/I4JfqWkCKG8V0E5V7TUsfi4r56XeofNU3jWswDlz+IdF93Kj/PTaFLuvC7QgK9
         DUBwWm+2vL7riPfws29ww+AwWsypwgSIm8sz4IX8C4bJVp3lWDJFORZFHFjbwPn5mxYR
         Br5U/2fRwRcLcjWl3onWZ4KgpuNH0IWRLVD4IL4QdWCAK2Pp73dzL/+NSxCQVOe7wlRQ
         LLOTdy/m78Ii2ccdfTWWpUr31N0HME/kAKd7VOAXaPY2vB5C7w00QbP8P81wjPnQofGn
         l/G3WVeRF+GTgDOwEtOjLyErYWnL840cltdtInJuw3AvhiJiMUyx8b2PIdbGrj1DOhQ1
         NXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIoT3CHcF6Ui6SUKTLSeS0m12Ndh8eiq7ywYH+1sD+8=;
        b=sicmmyx1eELGJLGresz5TpUZ4QHjskQ+92kUaVIKKtIpeIn0QrlheaPIEg1jQ0+Cea
         yA0XMHwu6WII8xNmZ3wy7KUel2Bc+VPIOHbHJfQ0WjRPged6V9FpCcgnthHpN+Ad43E3
         gDIl8TbSSF43ZBOrSrwLfHMia1FQLQUzMdlwU2d28DmWwmRNqcxWUYE3ipSF+ULrNQBu
         9nTvOoKY5aGXrfhKllY8uoKb4OEjITHx/vuXNy2xb9VKxanOFHt0+mW8DvENWU/ta0sm
         1+xynsztuqV63sYqepDuugAb2x0ZFAsTfS+xwtdlcytiKzGlMzn/C545yzYNoiQEDJqD
         euhA==
X-Gm-Message-State: AOAM531T9BxLj6Yh16Gpu1mdbNJ03lV1xqrCk72rjhOoe3nel9uzgTlX
	dPmfZH1fuIUsmebJBI1ihXi3esge1CW2qLNejUS/oQ==
X-Google-Smtp-Source: ABdhPJwiPF8vZVbVc35Iub4ypV+u11zyGNfpowHKQKuKj6XlQ+gogtNtDHMHWMfKf9ZJPTPqzwoOIQXgvVfgvCvtytI=
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id
 d8-20020a170902cec800b0013b9ce1b3efmr24874704plg.4.1632181814749; Mon, 20 Sep
 2021 16:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210920072726.1159572-1-hch@lst.de> <20210920072726.1159572-4-hch@lst.de>
In-Reply-To: <20210920072726.1159572-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 16:50:03 -0700
Message-ID: <CAPcyv4iVL7bevm_MeFnkRK12SkwO4k5aR3-4KOAGMxThmJwOuA@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: warn if ->groups is set when calling add_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 20, 2021 at 12:30 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The proper API is to pass the groups to device_add_disk, but the code
> used to also allow groups being set before calling *add_disk.  Warn
> about that but keep the group pointer intact for now so that it can
> be removed again after a grace period.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Fixes: 52b85909f85d ("block: fold register_disk into device_add_disk")
> ---
>  block/genhd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 7b6e5e1cf9564..409cf608cc5bd 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -439,7 +439,8 @@ int device_add_disk(struct device *parent, struct gendisk *disk,
>         dev_set_uevent_suppress(ddev, 1);
>
>         ddev->parent = parent;
> -       ddev->groups = groups;
> +       if (!WARN_ON_ONCE(ddev->groups))
> +               ddev->groups = groups;

That feels too compact to me, and dev_WARN_ONCE() might save someone a
git blame to look up the reason for the warning:

    dev_WARN_ONCE(parent, ddev->groups, "unexpected pre-populated
attribute group\n");
    if (!ddev->groups)
        ddev->groups = groups;

...but not a deal breaker. Either way you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Jens, I'm ok for the final spin of this series to go through block.git
since the referenced commits in Fixes: went that route, just let me
know if you want me to take them.
