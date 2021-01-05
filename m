Return-Path: <SRS0=Icw8=GI=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77E5C433E6
	for <linux-nvdimm@archiver.kernel.org>; Tue,  5 Jan 2021 05:43:10 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4D81A22838
	for <linux-nvdimm@archiver.kernel.org>; Tue,  5 Jan 2021 05:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D81A22838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F40E2100EBBC1;
	Mon,  4 Jan 2021 21:43:09 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62f; helo=mail-ej1-x62f.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DE3A9100EF260
	for <linux-nvdimm@lists.01.org>; Mon,  4 Jan 2021 21:43:07 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 6so39733101ejz.5
        for <linux-nvdimm@lists.01.org>; Mon, 04 Jan 2021 21:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CmvrTwTOLCxJGYA+L8vnsRq7pQdWjB2uBzHiEQLghE=;
        b=DFQdiZejzRJBlir0ay06r5fcQjz1D4NsJMshTXAaljvFFeyP7wL9+zPXDd7Iq0AOIS
         K9SYOsvsRghXdb/P9VdoFn4vse4IhNSpWOdZ8PPLRLrjqGNx+D8+B5uzjwvdcf6xuI8U
         am6QCDKfMmrsKEd9PynpGihEhDpF/Ak0JDCvmiXWf+z43jJDYNyWcbG1ZNiE8Blw5+s9
         x+JgMNkpd/uvGISykRZZAEThjgfWVxU+qy1NJB4oPrYxekRVqZ6PUoVmp5/iogkGIg9I
         Kiy5epIb330ep1CdBZ9hpKsYiql2JVan0j3qpRncU5e/LQTccmQ1D1RJBaxlnreEa1lr
         ooBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CmvrTwTOLCxJGYA+L8vnsRq7pQdWjB2uBzHiEQLghE=;
        b=R3k5VIxxQgmQtz87t+9HDf+aW3SvbyflOB1+Dl/9ulbt94bS+NnRSSjcbP36Slqv7g
         POzfo1PCM/NlwzsDoyFprRWyzYCifeWs3r35XKWilx4E1QBtYyGNEa+7lAI340R+GCG6
         CE8Kir50JWmJe6a3T6J46lmvyPB4R4h4adx/dyZ2NcvhRicLCzWiKh2mCjWQJKlfo3Kf
         MEkXW0Ez8AdsyEUMItjI4IZCmyLz2ku8ULYQS7IA9GDev0RAXYNVb5aznF+nqgfqi5vP
         G9OikNGzr3MeJexyPPoNM5tU2eb5MJBe9M5HsX48tqdYfzjEG495WpGHsda72+rUxXIA
         5Y7g==
X-Gm-Message-State: AOAM531asL8wAFHFqy/v+debLc97j7iuDlNskaB1yASEEGkLAiEgToMM
	ScJPBM3BrsK7uShXxNxY6AksbGCUTKcMrFVrIJGIwA==
X-Google-Smtp-Source: ABdhPJx7m/Sf0ohBHUMCtWefo85ADNjmKH0VHW7sKIZoRIr8AXB9Bw3Shm9m7fih9e4QeOv1njHPYp+1UN1nW3Djk94=
X-Received: by 2002:a17:906:a29a:: with SMTP id i26mr68498113ejz.45.1609825385802;
 Mon, 04 Jan 2021 21:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20201231053156.24276-1-zhuling8@huawei.com>
In-Reply-To: <20201231053156.24276-1-zhuling8@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Jan 2021 21:42:59 -0800
Message-ID: <CAPcyv4i9mn7SJ6CSY4uH_74f6pRny5aLQhg6Ubf3cDw8kJoWzg@mail.gmail.com>
Subject: Re: [PATCH] arm64: add pmem module for kernel update
To: Zhuling <zhuling8@huawei.com>
Message-ID-Hash: 4JXURV3PSEPFJYJF6P6N7I5WEVKL3LP2
X-Message-ID-Hash: 4JXURV3PSEPFJYJF6P6N7I5WEVKL3LP2
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Will Deacon <will@kernel.org>, luanjianhai@huawei.com, luchunhua@huawei.com, sangyan@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4JXURV3PSEPFJYJF6P6N7I5WEVKL3LP2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Zhuling,

On Wed, Dec 30, 2020 at 10:18 PM Zhuling <zhuling8@huawei.com> wrote:
>
> Category: feature
> Bugzilla: NA
> CVE: NA

These tags can be dropped.

>
> Use reserved memory to create a pmem device to store the
> processes information that dumped before kernel update.
> When you want to use this feature you need to declare by
> "pmemmem=pmem_size:pmem_phystart" in cmdline.
> (exp: pmemmem=100M:0x202000000000)
>

Interesting. I like the feature, but it's not clear to me that a new
command line based configuration scheme is needed. There is the
existing memmap= parameter that on x86 describes a
IORES_DESC_PERSISTENT_MEMORY_LEGACY range. The driver/nvdimm/e820.c
driver could be reworked to attach to the same thing on ARM64.

Then as far as assigning memory to different kernel usages there is
the existing capability in libnvdimm to attach a "personality" to an
nvdimm namespace. I imagine you could write a special signature to the
namespace that libnvdimm would recognize as a KUP reservation
namespace and work generically across any arch.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
