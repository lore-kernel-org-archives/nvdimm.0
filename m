Return-Path: <SRS0=fnpI=F4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8480DC433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:12:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 050A7224B8
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 050A7224B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B04D9100EC1E9;
	Thu, 24 Dec 2020 10:12:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::629; helo=mail-ej1-x629.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A444C100EC1E3
	for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:12:54 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id g20so4207868ejb.1
        for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/bZV6f3Jgwpe0hsSvhOuCb/+QOJ83g18wcZboghI0Y=;
        b=pWkJ0CXUF8MOopXQSCftP9Fm67ZjipXsPCwZm8GMMkKqJtoWlxDJUJYdF2lnKGWXHb
         YFQdfLFSmHWXVtxbT3IFdFBl2TFMqW88RjwH0eSrF3Xdwctqr5jHx6uMxpPWBpPY8u2l
         qgCwhmGtXfzNY4oCS1wBMulXx+5hOxrBxSmGuQk+650dKKYwy9Zfy3aQwq0YumaW1xvE
         mV+BVqGJE49DEVPOctznZcE8Wu+rgKXqMAxML1BSyTXRlceltOFco1UuEIYIfQgtyNtM
         6Nudfd1V9upHxx2jcFQPYzw9cWnw2KiTds+22HcXkxhhUJTfDD0XoirOwUq2Ks7Zqd0P
         FCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i/bZV6f3Jgwpe0hsSvhOuCb/+QOJ83g18wcZboghI0Y=;
        b=rPZw9UbYt3yGxoCo4nwNys8B3xBDrbIQ+cMIXmQQM3piFinos5SEfYwIhgZpLydEpp
         V5utPzgvvELlsBtC1cW0EGXm6+HMy/oR/yelSZSp5LDOdkDvo6CqOexXBIsa+Cb96JY7
         58BIBGRg04yGnVdTSxSVPUHyZrIojiXiDZRJH2ZMAbY8eAOIOF2OXlxIi5oOIl+TPSp6
         rJPFNebcW20rh24kI0JaN8fIsGaQwTOd9fMzqPlQWctgQY1xp3UlbLSvOOaEiNIQHd37
         XLjbacdQZAatetr2Tw9we1UmjUUjZ6h414uNRa8GUPL5EMyb4deqpY9Z3PSsRGbjYgwL
         tWRg==
X-Gm-Message-State: AOAM532Ze/Fp22lJI6s8xm+kXgxNIfhVmXC5EALoYD6wJihzOXM2sSdP
	pWa6a3LIDHyN8KkU8cGj8X2/FdYrYGjYBoSFCOOTWg==
X-Google-Smtp-Source: ABdhPJxUVrAI6Hfaopd0MhhblCfzYhbFzcD2Qva6RHDD6HsvjDMOfogg30xNXJ/eArWSfgnSt92nXNVX0Apo7Zs1/5Q=
X-Received: by 2002:a17:906:a3c7:: with SMTP id ca7mr29715074ejb.523.1608833573249;
 Thu, 24 Dec 2020 10:12:53 -0800 (PST)
MIME-Version: 1.0
References: <alpine.DEB.2.22.394.2012222207060.2723@hadrien>
In-Reply-To: <alpine.DEB.2.22.394.2012222207060.2723@hadrien>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Dec 2020 10:12:42 -0800
Message-ID: <CAPcyv4hDqwQ3eatVBUYwAVSMc-p3yqRJkwesxYEZW2j=WEjqgg@mail.gmail.com>
Subject: Re: [PATCH] ACPI: NFIT: fix flexible_array.cocci warnings
To: Julia Lawall <julia.lawall@inria.fr>
Message-ID-Hash: GVYWSHY33G62PRS2XVKRKGFY5UTVMMLV
X-Message-ID-Hash: GVYWSHY33G62PRS2XVKRKGFY5UTVMMLV
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Denis Efremov <efremov@linux.com>, kbuild-all@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GVYWSHY33G62PRS2XVKRKGFY5UTVMMLV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 22, 2020 at 1:10 PM Julia Lawall <julia.lawall@inria.fr> wrote:
>
> From: kernel test robot <lkp@intel.com>
>
> Zero-length and one-element arrays are deprecated, see
> Documentation/process/deprecated.rst
> Flexible-array members should be used instead.
>
> Generated by: scripts/coccinelle/misc/flexible_array.cocci
>
> Fixes: 7b36c1398fb6 ("coccinelle: misc: add flexible_array.cocci script")
> CC: Denis Efremov <efremov@linux.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Julia Lawall <julia.lawall@inria.fr>

Hmm, this triggers:

drivers/acpi/nfit/core.c:2276:4: error: flexible array member in a
struct with no named members
drivers/acpi/nfit/core.c:2287:4: error: flexible array member in a
struct with no named members

$ gcc --version
gcc (GCC) 10.2.1 20201016 (Red Hat 10.2.1-6)

I'll need to circle back to this later.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
