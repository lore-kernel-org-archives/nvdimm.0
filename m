Return-Path: <SRS0=7U0C=FU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6688EC4361B
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 06:06:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B6862333E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 16 Dec 2020 06:06:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B6862333E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B60CB100ED4A0;
	Tue, 15 Dec 2020 22:06:45 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::634; helo=mail-ej1-x634.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 347CE100ED49B
	for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 22:06:43 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b9so6103760ejy.0
        for <linux-nvdimm@lists.01.org>; Tue, 15 Dec 2020 22:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n9AP4hw+wrttYBnxzNOz611fczoKnvpoptmLkl3njAc=;
        b=uCkxp1DtDR8O38TsTawozwXfHW0r0UfgemU5OYPTGeEoXsHQcs6LNadpYloE9x/u5f
         UzoB0w61uo/f5r0fQD75m+h8ymUZ5cBJfnfQXSm9o70V7rL8ncPX+xEuy+l1eRTdGFut
         iDa26evduTsVNkktkgOfTBS2qquBvk/BPIOJqyAr8txqpLT7gqT98eTLGrNaCMYeyRy7
         TTlDUh9J9ZTIcMjMOFawduh7QAJqo+kB7z350mwq3ZCI+QDjFYQ+FOlR2xXG5ZuMc7LI
         4CZ1LViaJARDUg0Gkc7kT44AvyiYfSS+MXWu9vPk5DmY+jnsNa4VkxKu3WKxPNYjIo7i
         gShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n9AP4hw+wrttYBnxzNOz611fczoKnvpoptmLkl3njAc=;
        b=VuoRoYmX96QxZ900b5HaUvcI3JoHvg+hFf5fh0A9Na6CYKNmbqN13WC0C6TJYzpGHE
         StuZae9fWw6srxl8VS49a59wFqY2izqIKhpF94mfAyB722NVCi9QF5aTYaRPHUy7MsRn
         gwNcGBH5mEcTlD68Ngs1wLwe3DRVk2xSaA0+rjq8CXVxnm9/bszA0faHpfXsv8PX3HEY
         cxSSSCDctPaOwQq8SjxlJLXR8ENeofedB08P9JQT9aIBFG+2hHNVNIefVHcttQ4l2O/8
         b+ZQdGgQtab3T+SxXuGCYiHwH+7aHkZIFf6o4WojMy3Onc4oeONqvZRvW+yIr1K6lx2o
         4oYA==
X-Gm-Message-State: AOAM5339V5ZoU4Xiqk746mq8vQ4a7mv7m36Toya0KL/37yq5W5Ah0hWV
	YObg7Hgv+v7nh8TNoN0PYBQObGp+VLC2BCTe4PmzSg==
X-Google-Smtp-Source: ABdhPJzkiJK2xyrc2QwSC8CVZIupa2XWCcT1uQyhVvTVyuCsU8VdzP96S9LSL2lvAk84LlpkUpqQHdEZw7zDznsaLQ0=
X-Received: by 2002:a17:907:c15:: with SMTP id ga21mr29965062ejc.472.1608098801569;
 Tue, 15 Dec 2020 22:06:41 -0800 (PST)
MIME-Version: 1.0
References: <20201201135929.66530-1-wanghai38@huawei.com>
In-Reply-To: <20201201135929.66530-1-wanghai38@huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Dec 2020 22:06:30 -0800
Message-ID: <CAPcyv4gAmPLQnNwenDoaGQ7Ah9-eEkuL2xSoqi_zyg1waZYg9Q@mail.gmail.com>
Subject: Re: [PATCH] dax: fix memory leak when rmmod dax.ko
To: Wang Hai <wanghai38@huawei.com>
Message-ID-Hash: K2HB4GBXRDETPYTHIS3TRD454KZKQCBL
X-Message-ID-Hash: K2HB4GBXRDETPYTHIS3TRD454KZKQCBL
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/K2HB4GBXRDETPYTHIS3TRD454KZKQCBL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 1, 2020 at 5:54 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> When I repeatedly modprobe and rmmod dax.ko, kmemleak report a
> memory leak as follows:
>
> unreferenced object 0xffff9a5588c05088 (size 8):
>   comm "modprobe", pid 261, jiffies 4294693644 (age 42.063s)
> ...
>   backtrace:
>     [<00000000e007ced0>] kstrdup+0x35/0x70
>     [<000000002ae73897>] kstrdup_const+0x3d/0x50
>     [<000000002b00c9c3>] kvasprintf_const+0xbc/0xf0
>     [<000000008023282f>] kobject_set_name_vargs+0x3b/0xd0
>     [<00000000d2cbaa4e>] kobject_set_name+0x62/0x90
>     [<00000000202e7a22>] bus_register+0x7f/0x2b0
>     [<000000000b77792c>] 0xffffffffc02840f7
>     [<000000002d5be5ac>] 0xffffffffc02840b4
>     [<00000000dcafb7cd>] do_one_initcall+0x58/0x240
>     [<00000000049fe480>] do_init_module+0x56/0x1e2
>     [<0000000022671491>] load_module+0x2517/0x2840
>     [<000000001a2201cb>] __do_sys_finit_module+0x9c/0xe0
>     [<000000003eb304e7>] do_syscall_64+0x33/0x40
>     [<0000000051c5fd06>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> When rmmod dax is executed, dax_bus_exit() is missing. This patch
> can fix this bug.
>
> Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Looks good, applied.

...with some fixups to the changelog to add Cc: stable and change the
title to "device-dax/core: Fix..."
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
