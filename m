Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0825770
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 08:38:08 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id f10so3183957vkm.12
        for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 01:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVHzs0poOF+hVS1v1BAW6iRpurNI2FLCHK2qQooBQc8=;
        b=mYFxiTlAOZ3uRn7Fgbv8ITJD5XXXHXZf0dS53/Emo+wQXtX8BS1ly0U5utTJ1D09ta
         OybmfM9XF3sCEsLeze963skCSxz5E94DVznncFu3jhHOP7CeEuwX7vfYz00otd6aKJib
         4EuF05/jNNcjPcAOlxMUQM0dOtWEE+yyJHY1iVx7G9cJiXJUB7HjDC3XmWOtbOTXwyLb
         5W7VxQvKlZN2/AbAi7j/RRe9WjRgC8f/E3dZ4HFYmh+f7Fg3UlNqPz6F/2erLmHuGOzc
         xtibQ2AnGdgGYRon1kss/ob2pHeHODnqoHCs7ogtQxh8cWIAdYgWy/BWqfvUqY4eIXuu
         W0Pg==
X-Gm-Message-State: AOAM533oeR/AF8O/GYkH5KhMHJ/rCmXuBxzaue+hlz/6ahGBiA9BIViI
	vqf5XQcRyfv+S7yqGdiUL16E8YTgIr/nZAF25Yc=
X-Google-Smtp-Source: ABdhPJzGTg0SxZhAyS6W3ANe8pj0R0i+6+zDbI/+BVCcJpHhTvw5AwmdUSLpxqeMfSWaogZWi2MJbcqhNDfvoXw93hU=
X-Received: by 2002:a1f:2504:: with SMTP id l4mr9071521vkl.5.1621586288105;
 Fri, 21 May 2021 01:38:08 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210521055116.1053587-1-hch@lst.de> <20210521055116.1053587-20-hch@lst.de>
In-Reply-To: <20210521055116.1053587-20-hch@lst.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 21 May 2021 10:37:56 +0200
Message-ID: <CAMuHMdUReZCGwii_rJuOOag+jmn4E3yfH+=P3a=5bJDf8CJvrQ@mail.gmail.com>
Subject: Re: [PATCH 19/26] nfblock: convert to blk_alloc_disk/blk_cleanup_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, 
	Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, 
	Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, 
	Nitin Gupta <ngupta@vflare.org>, Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>, 
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>, 
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>, 
	"open list:TENSILICA XTENSA PORT (xtensa)" <linux-xtensa@linux-xtensa.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-bcache@vger.kernel.org, 
	linux-raid@vger.kernel.org, Linux MMC List <linux-mmc@vger.kernel.org>, 
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org, 
	linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, May 21, 2021 at 7:52 AM Christoph Hellwig <hch@lst.de> wrote:
> Convert the nfblock driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
