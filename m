Return-Path: <SRS0=kyPS=JH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E27C433B4
	for <linux-nvdimm@archiver.kernel.org>; Sat, 10 Apr 2021 04:56:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91E9A6113A
	for <linux-nvdimm@archiver.kernel.org>; Sat, 10 Apr 2021 04:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91E9A6113A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5C8A0100EBB7D;
	Fri,  9 Apr 2021 21:56:02 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.218.54; helo=mail-ej1-f54.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 92B76100EBBBB
	for <linux-nvdimm@lists.01.org>; Fri,  9 Apr 2021 21:55:59 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id l4so11716797ejc.10
        for <linux-nvdimm@lists.01.org>; Fri, 09 Apr 2021 21:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4d0pH++PQprtx+vqNO/EImXYyO+3e2J6Tc3oRYuTHK8=;
        b=BFX07dcQQC7idy+oqH7E1iiDyabFawNYenVXM+2lE5XxCaEbyFMazKJOth+88p3tju
         SzPwxXxrY2LkPYOTNXxLEbBYtKl19VmsoCGFmXT86oltTsMrwc+VvpV4D5CotvB2h8fL
         eBUdSRQY839fxM8M0Y1gZ91sCyqmv69CePGWSIgGQoveZWn7UU6Vs5NmSjSLLFH3vH4N
         V/UHOIBL2/0M8vhTrswkLWS3I6vVexDEdkuZ29C3M0yBqmzPvc6Wq/difVZaeQjJJy3o
         q2W+LXLoNUy1Sh2w0ESC8+EjXQBHs7Ro0AnRC6GjC/GpNLwau7erKvMfav7KcPAoywi/
         KeXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4d0pH++PQprtx+vqNO/EImXYyO+3e2J6Tc3oRYuTHK8=;
        b=p2Wj/F0CVMNVLHvpDdgFh13S2bVNzctNu1HmPqMMYolrpLzk5GrQI2o4+anbnhBeNc
         1uS25vrwMqI9ZfOnhZwTILrlOHTlmyPqSpULjEs/gpUbzAFCwufNrfUN+/cHGnXHmx7g
         x2jNA4MRg4gB3koSDLBTfkC4yAMx1zBrLeGbDvhcRHRhVGRvJiw99e3PXURyuYrbhIzK
         m+/CNWSOLDSxw11NpbGERryaOO1Mh0Zm+Jm2SHe5Uz6UyAZyuvIzI1Qk3Gk5aWBXjyoN
         uyi87oBeIWc9Hdo7wK8wxysTiiy5XjHjScO2rjLyBLgnb1gab18XzUN8jbti9A1Gcd6+
         yVzA==
X-Gm-Message-State: AOAM530z7V/W1rar+femAgPHfSuwS96SPj4WIQ6nIgBt9ebin/AsfIM1
	O1uHehfav/AOlou3kFuSS09atJvZAjM9SfbKNywgtQ==
X-Google-Smtp-Source: ABdhPJy97uW/eMQbp6c11KKQsQT06Pryo58CAEY7vl4VUrtBAYLoCvDlt1KzsXgSFSdQmlWio+8NSWoCrNq2lW4GkQA=
X-Received: by 2002:a17:906:4fcd:: with SMTP id i13mr18945286ejw.341.1618030498122;
 Fri, 09 Apr 2021 21:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <1618014803-17231-1-git-send-email-wangyingjie55@126.com>
In-Reply-To: <1618014803-17231-1-git-send-email-wangyingjie55@126.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Apr 2021 21:54:50 -0700
Message-ID: <CAPcyv4hBN2eCGehzZES7_NNco5xupKsvv69JtxzzCoV-DzT9bQ@mail.gmail.com>
Subject: Re: [PATCH v1] libnvdimm, dax: Fix a missing check in nd_dax_probe()
To: wangyingjie55@126.com
Message-ID-Hash: LKWZSELPVFZX4ZHQUZ4XLI42VILNNNVS
X-Message-ID-Hash: LKWZSELPVFZX4ZHQUZ4XLI42VILNNNVS
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LKWZSELPVFZX4ZHQUZ4XLI42VILNNNVS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 9, 2021 at 5:33 PM <wangyingjie55@126.com> wrote:
>
> From: Yingjie Wang <wangyingjie55@126.com>
>
> In nd_dax_probe(), nd_dax_alloc() may fail and return NULL.
> Check for NULL before attempting to
> use nd_dax to avoid a NULL pointer dereference.
>
> Fixes: c5ed9268643c ("libnvdimm, dax: autodetect support")
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
> ---
>  drivers/nvdimm/dax_devs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> index 99965077bac4..b1426ac03f01 100644
> --- a/drivers/nvdimm/dax_devs.c
> +++ b/drivers/nvdimm/dax_devs.c
> @@ -106,6 +106,8 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
>
>         nvdimm_bus_lock(&ndns->dev);

hmmm...

>         nd_dax = nd_dax_alloc(nd_region);
> +       if (!nd_dax)
> +               return -ENOMEM;

Can you spot the bug this introduces? See the hint above.

>         nd_pfn = &nd_dax->nd_pfn;
>         dax_dev = nd_pfn_devinit(nd_pfn, ndns);
>         nvdimm_bus_unlock(&ndns->dev);
> --
> 2.7.4
>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
