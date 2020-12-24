Return-Path: <SRS0=fnpI=F4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0090C433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:04:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C88022288
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:04:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C88022288
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E72D7100EC1E6;
	Thu, 24 Dec 2020 10:04:40 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::634; helo=mail-ej1-x634.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3F40E100EC1E1
	for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:04:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id 6so4149528ejz.5
        for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t3tVfLCza2sZXYqfDT7M/Kfwfd+ScNfUAL29TNNsMNs=;
        b=LZohmurxAg+IIXFTcRxyeLuEyJRrBYtdc5Y6L9d983RXMlqUL6locmiKcKI2AiHQBL
         Dt3ulsAPNUcmpqTZb0ZJRbC2fSKWNSpZaJxNWzckjY1AD4lii4ZCXFbPxSGXi+FQ1nvI
         yf/1lsfNNHM9eJhTmLX1MCVbHhX1ZdOTuW4UEfOXHINYM83nqxL995kxIypB75+r6d8z
         QdGkAg0/p2TW5L+IQ7yUR+YyLmkgvXzwNrb7zzH5xXG2XnXGNQwLobiAB6bXy+KfFoSJ
         KwWqryiT2PpuLu5WJwbQc+0KoRp+HRqJIfhcqj+4o6KMtUF+QuyVOZAD+TIa4auC/AJQ
         qubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3tVfLCza2sZXYqfDT7M/Kfwfd+ScNfUAL29TNNsMNs=;
        b=t+pY/awbqisMM4abzLFPNDjL4/d5pUzpxskkk+f3GDoqv1PfHNxy/sQrHqPauS9Rut
         fhK6oqDF5JfL+kxumK7cQlZqfkjewGdEhC4ZmN4e50dNOaFIP5GT6RsOfBEbJiWQgaDv
         3WweF916nYNLAcTXniP2iqcxCgS7pABzBdhT4/sVbZci5Pva6e7nJlAUKTd6CtzDlL//
         YJE6X0kh+2D/LJQ2ikqjdrTkb7wp98Dls1sLp7ioKLiY+vlYKMPFDoReBaRR9+KgobL4
         0WmHez5Bb6o0At55cBdaAT0NaLV/N42DN7xS77Hd3/ssMbns7K7Er7fckKsAJ2Qz/V43
         cGyg==
X-Gm-Message-State: AOAM533PXYZJMEWpev0bHZAvt/BZbb03Cbpvan+7uH38tlzfl54TYJ6Y
	1cZmzoKrKnHVO7BGvu2aiowH/LoTc2qzuwonk0itVg==
X-Google-Smtp-Source: ABdhPJw7dpI2Wim5ePR6UmRCUFYbtYaIWjkZLzIn+BRbeLkvP2NmOGdJ6B1LMC0L4FaasfzIQ0cJuTlriijfHPwORzA=
X-Received: by 2002:a17:906:a29a:: with SMTP id i26mr28662478ejz.45.1608833075889;
 Thu, 24 Dec 2020 10:04:35 -0800 (PST)
MIME-Version: 1.0
References: <1608514782-19193-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1608514782-19193-1-git-send-email-tiantao6@hisilicon.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Dec 2020 10:04:25 -0800
Message-ID: <CAPcyv4h6Pn6Y86P_TeSTqpPeRy6nhQaZPGuggUMT8Ww6TT-Eig@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Switch to using the new API kobj_to_dev()
To: Tian Tao <tiantao6@hisilicon.com>
Message-ID-Hash: 6XDR7S73IBO5BG43KBTTKYKQAVMGO3MY
X-Message-ID-Hash: 6XDR7S73IBO5BG43KBTTKYKQAVMGO3MY
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/6XDR7S73IBO5BG43KBTTKYKQAVMGO3MY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Dec 20, 2020 at 5:40 PM Tian Tao <tiantao6@hisilicon.com> wrote:
>
> fixed the following coccicheck:
> drivers/nvdimm/region_devs.c:762:60-61: WARNING opportunity for
> kobj_to_dev().
>

Thanks for this, but you missed a few:

drivers/nvdimm/bus.c:716:       struct device *dev =
container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/core.c:506:      struct device *dev =
container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/dimm_devs.c:421: struct device *dev =
container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/dimm_devs.c:537: struct device *dev =
container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/namespace_devs.c:1626:   struct device *dev =
container_of(kobj, struct device, kobj);
drivers/nvdimm/region_devs.c:647:       struct device *dev =
container_of(kobj, typeof(*dev), kobj);
drivers/nvdimm/region_devs.c:762:       struct device *dev =
container_of(kobj, struct device, kobj);

Care to resend with those included?
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
