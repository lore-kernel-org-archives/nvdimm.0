Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA942C81
	for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 17:51:19 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id h74so273819pfe.0
        for <nvdimm@lists.linux.dev>; Sun, 31 Oct 2021 10:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8mR+D/eH/dZNNjPVwCwixw0JTq5UBSJUqcsN3WCTdc=;
        b=MvRLH8wCuHLDGU5wWh67k3cqC1Fdd3cZizRDNMF6VwG3BIGVykQrXQ5XqN/SFH4gF0
         aMNjx/sd3ls8H4qnD1YxCP5l5GJAAEpAG/Esp4V6LKux9NYOWi96TwUZ/pFb3TcmZBWP
         zVBzvEL+MVUnbMk9GV0AJMQQu68lxnATIX9jNgOg6W2MrQQWyRvUFoiusZtaNgUAPfI1
         AxT4pyI0WF/pD617rNm69wlS3SI/GAt5yD+1ZKqpLA3r9I/GOI56o8ePSp4PP7gIIGX3
         ZjKHBLE0TTaieZDjpKAQiXOrBhNCxqkLUX94RtN1Jp6OGXuvi8GYPomwsciSqBwOSwmF
         zWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8mR+D/eH/dZNNjPVwCwixw0JTq5UBSJUqcsN3WCTdc=;
        b=F20gdFEXmp9EJVhZ+sCzHSDVWELSLQXjTtymGVrgqMJ526U/92Q1Dmy6xYW41F410l
         f0YfhvcVRKYZvjozBGgCrttoIspmt5ew7GxyHOcENtaIOycxvWNofzU4uFXMBPlWHoXb
         Ism2albYRYRDz0HBV8DgoDfS2hSLySohJc0k+ziRn6GmXmX5SZzl+tMrtDtjVCZAPP78
         GScqYAit9WcsoDLp+vub3pBt8fsh67g98EnQ81cml6DuvugbDr8z7LBF0SIWIu26qiEF
         vZXJzLK4j1gjwTBro1sj9ogzlDa58hlxEZWIGYF/EU+xruNtf1U3fS4xa6f6mMRwyYEQ
         hXcg==
X-Gm-Message-State: AOAM531FefJWu1E2WPtI3nKk76ggqkIpfyYLveUi3VuwmDHYWv7f7mhI
	jlZwC+jgEs0q3WNFGxZHyynt6kZSGo+Woe9vyRFKEw==
X-Google-Smtp-Source: ABdhPJwgKG5Mr66Ui8RTcSTuDFaX+/IepWZB1EHkIZ09RxQEUmJyKltynz0/5/JNtOiXpRzef+xr6SruizxyjaU9z7s=
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr17997770pgc.356.1635702678641;
 Sun, 31 Oct 2021 10:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211015235219.2191207-1-mcgrof@kernel.org> <20211015235219.2191207-5-mcgrof@kernel.org>
In-Reply-To: <20211015235219.2191207-5-mcgrof@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 31 Oct 2021 10:51:08 -0700
Message-ID: <CAPcyv4g98Dk4HFvgzEeCfCNjF-vjfpEhjGjsPDazGPg-BqMr8A@mail.gmail.com>
Subject: Re: [PATCH 04/13] nvdimm/btt: use goto error labels on btt_blk_init()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	Paul Mackerras <paulus@samba.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, 
	Nitin Gupta <ngupta@vflare.org>, senozhatsky@chromium.org, 
	Richard Weinberger <richard@nod.at>, miquel.raynal@bootlin.com, vigneshr@ti.com, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-mtd@lists.infradead.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-nvme@lists.infradead.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 15, 2021 at 4:53 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> This will make it easier to share common error paths.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/nvdimm/btt.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 29cc7325e890..23ee8c005db5 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1520,10 +1520,11 @@ static int btt_blk_init(struct btt *btt)
>  {
>         struct nd_btt *nd_btt = btt->nd_btt;
>         struct nd_namespace_common *ndns = nd_btt->ndns;
> +       int rc = -ENOMEM;
>
>         btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
>         if (!btt->btt_disk)
> -               return -ENOMEM;
> +               goto out;

I tend to not use a goto when there is nothing to unwind.

The rest looks good to me. After dropping "goto out;" you can add:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
