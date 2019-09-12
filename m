Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE935C4CEC7
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 14:21:52 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C62162081B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 14:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ier1/HQ9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C62162081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7A83C202E293B;
	Thu, 12 Sep 2019 07:21:54 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2a00:1450:4864:20::242; helo=mail-lj1-x242.google.com;
 envelope-from=miguel.ojeda.sandonis@gmail.com;
 receiver=linux-nvdimm@lists.01.org 
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com
 [IPv6:2a00:1450:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FECB202E2938
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 07:21:53 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id j16so23810712ljg.6
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YFMQkxTl4u1uDIPdWtzBBws4tnK81QKk4aIpoP8Wl4M=;
 b=ier1/HQ9wGA5OvIpZxEX/nq1XaK93pORQit51CSERGbvPQVVMZxU2LE7dq1kUbWZBK
 DZfxDgXDt06m2hz0f6EQdEhzZKMpsmTQCUvegCbnLkvE2n7UQGCYY4DrKmkWTbUQ3gU9
 rCWK7Mq7e9XB65nDGKTG8Vd3f177H0sXWfhuIaNyg+GIPMGcrfGD8Bv37JTuO5xCw/4e
 UKNfok63Ewt6nLhV/05ot7ZN+yiBQymDEPmeOwtJboDaF2ilZnZvS0RFoiG73MjLh/6J
 utc7GvSpVntuPNbjtmYK/01BWw8VLzIUfkPBWS8WHS8QG+rmkOHDp/MgYvuaqArEivi0
 uTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YFMQkxTl4u1uDIPdWtzBBws4tnK81QKk4aIpoP8Wl4M=;
 b=nkA6+HcupENQRsm2CtMn/QbHjO2oPv5lSI5ArZL3o+gYQSDJDRfCoWVmQUaZSNNzGV
 y0yXqFe7UthHFAqBNKvVzpht8BhczsCY9PlhpF8F8pgC1KhS8kcQ7i6qtPbCMg5PMZks
 s8c0kQNS2ZLym768sn54e4tE6mAXnk1eEHA9/uhgOTuNbnQa1h6HxvXMQWZtcAdGheed
 /BuvpCm7kdnRZwsLopWfOXKhJfppPsYWRerJWZ1x/pZhifVIaN1crrb4t4tEEpYwR05D
 pZUZzQqSILUm+OtOVNRY7gUIesBr0EABxqDyV1hDBToHFFhbudzBWswM3fYmIJpkVIGE
 nX2A==
X-Gm-Message-State: APjAAAWgejpEwIoagzzGDLspxmealCELvz53ImFHRLfzk0mocz1gGIGC
 6PYc5SyRg6d3C9Nr+BLwHelxEb/eFhSgA6c280s=
X-Google-Smtp-Source: APXvYqxc7Jor+XgK0qvsYhR5IbweDk6SR2yQ1TSzQPa7eM1/62+Oel69slNeS0cXOPPeiOS4CWyEidK9RBjUHSY+Zgg=
X-Received: by 2002:a2e:87d6:: with SMTP id v22mr2778028ljj.195.1568298109407; 
 Thu, 12 Sep 2019 07:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568256705.git.joe@perches.com>
 <x498sqtvclx.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498sqtvclx.fsf@segfault.boston.devel.redhat.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 12 Sep 2019 16:21:38 +0200
Message-ID: <CANiq72kTsf=0rEufDMo7BzMNv1dqc5=ws7fSd=H_e=cpHR24Kg@mail.gmail.com>
Subject: Re: [PATCH 00/13] nvdimm: Use more common kernel coding style
To: Jeff Moyer <jmoyer@redhat.com>
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
 Dan Carpenter <dan.carpenter@oracle.com>,
 linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, Sep 12, 2019 at 4:00 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Joe Perches <joe@perches.com> writes:
>
> > Rather than have a local coding style, use the typical kernel style.
>
> The coding style isn't that different from the core kernel, and it's
> still quite readable.  I'd rather avoid the churn and the risk of
> introducing regressions.  This will also make backports to stable more
> of a pain, so it isn't without cost.  Dan, is this really something you
> want to do?

+1 As soon as you get accustomed to have formatting done and enforced
automatically, it is great. Other major projects have done so for
quite a while now.

If doesn't think it is good enough, please let us know and, if it is
close enough, we can look at going for a newer LLVM to match the style
a bit more. Also note that one can disable formatting for some
sections of code if really needed.

Cheers,
Miguel
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
