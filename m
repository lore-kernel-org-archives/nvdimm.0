Return-Path: <SRS0=8Ot0=HX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D34C433DB
	for <linux-nvdimm@archiver.kernel.org>; Sun, 21 Feb 2021 02:38:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2E8364EF2
	for <linux-nvdimm@archiver.kernel.org>; Sun, 21 Feb 2021 02:38:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2E8364EF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 94186100EBBBD;
	Sat, 20 Feb 2021 18:38:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62f; helo=mail-ej1-x62f.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7CA85100EBBB4
	for <linux-nvdimm@lists.01.org>; Sat, 20 Feb 2021 18:38:46 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gg8so11902402ejb.13
        for <linux-nvdimm@lists.01.org>; Sat, 20 Feb 2021 18:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBZELyjdiaRxkUIOCMRr5zC42a7wDyovP4ztiyPYwJA=;
        b=SZhcpUnPIY16mbxDPZs7FJLai9+V02OlWx7dcuLRhV/uMdkbmgNhYIX77Sghi6tUez
         WI6ecCKOgvxAzf4xw9Rb+gqrZFAGnGQOztbkgILg5Lc6GmjfJd/7exnHj3QxsE1pt3NE
         b3DJlpju4WzvQCBpUjVu63TP911pjZoPymcXauPfIe8NjdrXsz5XApmF20Au7vnCBhjr
         YP/s+cDC++60+7QCFC3zkWUjAtXBXddKbQm6FC5H5lSxnungESfYrjpQp+lek1bOd6sB
         ture0wZZqY/fdtbGC+j6G5vTRdC5JZyFtjh+TSp0yDZ98amDPRIoH7JrG2vBvlXxzjet
         XZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBZELyjdiaRxkUIOCMRr5zC42a7wDyovP4ztiyPYwJA=;
        b=rPdiDdYdCSBz1BcA7wmjG26JqqgMXElFMDPcjYZlMUDFx6nXdLCIKDRMXDfCOYpM8G
         PJg7Q8SiroS+XACOFeNIYJWrJGUBFUaU+8x19cL3LJuM1s8Xx1HsIhhPYetDt79ZiLn8
         U34992KYnP8ivVx2GYo8gZYFgM5d3zNUai4/lKwr/TLYmQ3bt3MVXrRwazGiHL8jsOgh
         T5ZsLph9Ii/6fp8lV5K6CtX9tuku6l6dXkoyz8I0HjEdDqbQN08pd9eedL1v4mR86nKx
         a7uhAeRAwveL1xwuiu3lGAYD84ka/2WuJQWGJOb3oJ27y1Bo3u0t730rYuS0hepQQZI8
         UFrg==
X-Gm-Message-State: AOAM533STbmibcrgY1fW6/bsuV82ogR2N+VBKBAqzf7C7FP8EH441R3q
	JHpbiiSSZTM7gktnIsfXyDYZUY97tkyagMOJZE05Bg==
X-Google-Smtp-Source: ABdhPJzj4EpS0DF6GeGIIzG6wrEYyiNCZPNgYURacgTLXK/M9PlUj+M9NiJF5oiaFyf3vVLmvLijuWlRoISHuow3Tr4=
X-Received: by 2002:a17:907:373:: with SMTP id rs19mr2489774ejb.341.1613875123282;
 Sat, 20 Feb 2021 18:38:43 -0800 (PST)
MIME-Version: 1.0
References: <20210220215641.604535-1-ben.widawsky@intel.com>
In-Reply-To: <20210220215641.604535-1-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Feb 2021 18:38:36 -0800
Message-ID: <CAPcyv4gfoe=QGuKV19ay51D-cqzRqTMLpD-p5whnJbYkKoGtBA@mail.gmail.com>
Subject: Re: [PATCH] cxl/mem: Fixes to IOCTL interface
To: Ben Widawsky <ben.widawsky@intel.com>
Message-ID-Hash: 3NUOG5RBYBMXQSVUAV4ULKSHGZ34GDAN
X-Message-ID-Hash: 3NUOG5RBYBMXQSVUAV4ULKSHGZ34GDAN
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-cxl@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Alison Schofield <alison.schofield@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3NUOG5RBYBMXQSVUAV4ULKSHGZ34GDAN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Feb 20, 2021 at 1:57 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> When submitting a command for userspace, input and output payload bounce
> buffers are allocated. For a given command, both input and output
> buffers may exist and so when allocation of the input buffer fails, the
> output buffer must be freed. As far as I can tell, userspace can't
> easily exploit the leak to OOM a machine unless the machine was already
> near OOM state.
>
> This bug was introduced in v5 of the patch and did not exist in prior
> revisions.
>

Thanks for the quick turnaround, but I think that speed introduced
some issues...

> While here, adjust the variable 'j' found in patch review by Konrad.

Please split this pure cleanup to its own patch. The subject says
"Fixes", but it's only the one fix.

>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Since the commit is upstream add a "Fixes" line:

Fixes: 583fa5e71cae ('cxl/mem: Add basic IOCTL interface")

> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com> (v2)
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Jonathan and I didn't pre-review this.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
