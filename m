Return-Path: <SRS0=9qxr=5I=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24406C4332E
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Mar 2020 18:40:48 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC6CE20409
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Mar 2020 18:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="gmgI9N6R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC6CE20409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EC98610FC379E;
	Mon, 23 Mar 2020 11:41:37 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::342; helo=mail-ot1-x342.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E098310FC3797
	for <linux-nvdimm@lists.01.org>; Mon, 23 Mar 2020 11:41:34 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e19so14485820otj.7
        for <linux-nvdimm@lists.01.org>; Mon, 23 Mar 2020 11:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JF4VmSimjtq6coHOhoT6Hj3UWbFBo+hkCp4f7I12HUo=;
        b=gmgI9N6Rz/U+4gBPdcY2Xc1Wh0CXPU8OyoHgUTW19qBu1D1BV8GGuCL8jVfVho9Sqx
         bJ0RgZ3pe5S/Kcm0a2FyfBJh5OpuDxP/62sEm1O05Z7gz7ysch6SXOiKomMltSpUI88G
         aKMj6VTeeEoqmoLdkotfp0+vC86m1BsBjh0V2uOuejqPv+FsEwipDheYEllg85V76X4Y
         7Ef4rl+SyWOQuIT3XFrpX9PXE9iUzUboo+laN20U825h4CGrV/pciNqptiJTULomDYE/
         Y/+uHMdpxnJ5DW3zhvMlODdBgEqvFWow4ZnxVbcAnppOuZFIefEM/9+DuJ7gbHD7UzYb
         M4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JF4VmSimjtq6coHOhoT6Hj3UWbFBo+hkCp4f7I12HUo=;
        b=frz2JscTnZv7ylAvsXvGifcNA1A9YVeVuar+85KWySBs5ZOFY0/y6uDQEp6OToCsMP
         NeNVkcalMVnS1YakEzOEItaTWeTgrrlAMk5uAifb+4DRqbdGMRjdwFgRykBABVYOzOrq
         BtOe48V7i6fgv5DxoYylFr3khPrt+eNUjHHulz/rvuOa0jJCnsLSthj2DdVYfDzOmvle
         4+XsX/McLHOMC+zjfZY+NCYuVNRx+Gk+xBGJLqx9mb5ySjq0znmQ0gvAxLVPz/kzJQjb
         XHXOx1jjGe54nsabFcfnx90iUEtJxNWqbcJFUsKZr/JzcBHoFldwT5GGD7+um4LnUUXA
         px+A==
X-Gm-Message-State: ANhLgQ3Vx7BMvZkkyCDbPuox7mI80VFIOk+aqMgCmBtAYncoTZgjmSKf
	WQZe+yTm+u2IvxUY2A64DVbNuw40ZnNQJxMREEUdDw==
X-Google-Smtp-Source: ADFU+vvjdEUIjCDX50+QoDxaaY3gcdCIDlxcKrlRDwSy9dJHnAXPYDfzu78L2919UnJrR8+zj8mqhJq9hOG1Voq0/8s=
X-Received: by 2002:a9d:3a45:: with SMTP id j63mr17759718otc.71.1584988843217;
 Mon, 23 Mar 2020 11:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200323183321.21889-1-vishal.l.verma@intel.com>
In-Reply-To: <20200323183321.21889-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Mar 2020 11:40:31 -0700
Message-ID: <CAPcyv4jY7f5LfptRfpWDEs_15_zTa8uspxRuJcbO7nR-gPdw1Q@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl/namespace: Fix a resource leak in file_write_infoblock
To: Vishal Verma <vishal.l.verma@intel.com>
Message-ID-Hash: SF23KYV4EFSVGDT66ZVXK7VKYUK45XPD
X-Message-ID-Hash: SF23KYV4EFSVGDT66ZVXK7VKYUK45XPD
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SF23KYV4EFSVGDT66ZVXK7VKYUK45XPD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 23, 2020 at 11:33 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Static analysis reported that we were leaking 'fd' in one case in the
> above function, fix the error handling to go through the 'out' label.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/namespace.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 21252b6..0550580 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -1958,8 +1958,10 @@ static int file_write_infoblock(const char *path)
>         }
>
>         buf = calloc(INFOBLOCK_SZ, 1);
> -       if (!buf)
> -               return -ENOMEM;
> +       if (!buf) {
> +               rc = -ENOMEM;
> +               goto out;
> +       }

Looks good:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
