Return-Path: <SRS0=2mfB=HB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1760C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Jan 2021 00:31:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 359C164E00
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Jan 2021 00:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 359C164E00
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EFF15100EAB06;
	Fri, 29 Jan 2021 16:31:21 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62a; helo=mail-ej1-x62a.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DB0D6100EF27E
	for <linux-nvdimm@lists.01.org>; Fri, 29 Jan 2021 16:31:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g12so15443107ejf.8
        for <linux-nvdimm@lists.01.org>; Fri, 29 Jan 2021 16:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IHqwNfHmdWEcZfyYPR4+sBaYZ3Bn6Age7W/ZhgBDEQU=;
        b=NB6BRSIj0GzX1o6kI9lGeXRyRJGr6RAcJQ+EhSWJ0BC3oc/SvPN8mDWEfixyZfopvl
         BANLs4tolXi9xalwI4vJzTF5OSuXUJsridXoHgYjPKbJiQKeVk5vaBH6mcLY0H4BZRiq
         wfaYlKezDkRFMIrzC/4N3H4PPq5oJdHXV6Q01Q/n5KcCs6Ew+/ZecSW/Ta6Irop56k7U
         Z/DLPpfhWC0iKLTezq/K3cXp9ZKO27xjK0zn3Bqqqi6Zq8pzsnpj7my50SQHQOHfdaJ2
         MbkYoSMosvq8kWvBha1+L8Yc6pwMpH0ki+Tt+yxj6akZwZ5ZXx0qjp88CJKo9ExxxZaR
         IoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IHqwNfHmdWEcZfyYPR4+sBaYZ3Bn6Age7W/ZhgBDEQU=;
        b=dPMBX1BfR85fqd9HPjx2LAoLJAZO2JL/u2PlO+zNpfwZpvrcQJkpuXNwj3fW4x7YIh
         l93V4DqqEnyUAD0aX94UWwVC5UgXFgwkgV162JE0vjnYILnG8M3OBvGc3t/DRTYbLb9G
         wPwAyPykjnspmZ7qCzDJ1MCC5jpU0jgB7SaZa79LEznIWslCAkpzcDWVxEMyiVwCyJJd
         uni5xsBUyQWbHuzDvkYYF7hayqvvB0uczRocMCLnExTo1f3UKNEsV5YdJQQbrzY92K0h
         zbkfbSCZ3K6+HkxolNLP7juKVh8iK7W9fNHm9V2+yKCoJpRLSNe2X6sXzv5AsQFnoJqB
         spkw==
X-Gm-Message-State: AOAM531frDN6/KS+pVMV4cwjr1wwhIoLTm8lttZ6gwFsWKZdFIaz2cTa
	b0Z0CvzNi4A+Q24OetcarDvppGVDZkBFWoslHIA8dw==
X-Google-Smtp-Source: ABdhPJxWORcLeJpILlCiBMkcM8hzzExkJ43LngkFSAc8o5W/IdsfFI1WUl5QRvX2O9IoWQ8K1Y0+8F2KdET67DExNU0=
X-Received: by 2002:a17:906:191b:: with SMTP id a27mr7103895eje.472.1611966677063;
 Fri, 29 Jan 2021 16:31:17 -0800 (PST)
MIME-Version: 1.0
References: <20210130002438.1872527-1-ben.widawsky@intel.com> <20210130002438.1872527-6-ben.widawsky@intel.com>
In-Reply-To: <20210130002438.1872527-6-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jan 2021 16:31:15 -0800
Message-ID: <CAPcyv4gZvxJxPQr3XwC3=yh8opkz5ThDjy4E-AWzL7ysFeC0Mg@mail.gmail.com>
Subject: Re: [PATCH 05/14] cxl/mem: Register CXL memX devices
To: Ben Widawsky <ben.widawsky@intel.com>
Message-ID-Hash: PEVO5XNMWA2GU42BSROTDKW3VEEQF7GE
X-Message-ID-Hash: PEVO5XNMWA2GU42BSROTDKW3VEEQF7GE
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-cxl@vger.kernel.org, Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux PCI <linux-pci@vger.kernel.org>, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, daniel.lll@alibaba-inc.com, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PEVO5XNMWA2GU42BSROTDKW3VEEQF7GE/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 29, 2021 at 4:25 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> From: Dan Williams <dan.j.williams@intel.com>
>
> Create the /sys/bus/cxl hierarchy to enumerate:
>
> * Memory Devices (per-endpoint control devices)
>
> * Memory Address Space Devices (platform address ranges with
>   interleaving, performance, and persistence attributes)
>
> * Memory Regions (active provisioned memory from an address space device
>   that is in use as System RAM or delegated to libnvdimm as Persistent
>   Memory regions).
>
> For now, only the per-endpoint control devices are registered on the
> 'cxl' bus. However, going forward it will provide a mechanism to
> coordinate cross-device interleave.
>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl       |  26 ++
>  .../driver-api/cxl/memory-devices.rst         |  17 +
>  drivers/base/core.c                           |  14 +
>  drivers/cxl/Makefile                          |   3 +
>  drivers/cxl/bus.c                             |  29 ++
>  drivers/cxl/cxl.h                             |   4 +
>  drivers/cxl/mem.c                             | 308 +++++++++++++++++-
>  include/linux/device.h                        |   1 +
>  8 files changed, 400 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-cxl
>  create mode 100644 drivers/cxl/bus.c
[..]
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 25e08e5f40bd..33432a4cbe23 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -3179,6 +3179,20 @@ struct device *get_device(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(get_device);
>
> +/**
> + * get_live_device() - increment reference count for device iff !dead
> + * @dev: device.
> + *
> + * Forward the call to get_device() if the device is still alive. If
> + * this is called with the device_lock() held then the device is
> + * guaranteed to not die until the device_lock() is dropped.
> + */
> +struct device *get_live_device(struct device *dev)
> +{
> +       return dev && !dev->p->dead ? get_device(dev) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(get_live_device);

Disregard this hunk, it's an abandoned idea that I failed to cleanup.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
