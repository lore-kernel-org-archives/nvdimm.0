Return-Path: <SRS0=hVMm=HS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77301C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue, 16 Feb 2021 16:48:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39C9964E10
	for <linux-nvdimm@archiver.kernel.org>; Tue, 16 Feb 2021 16:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39C9964E10
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 11FD3100EB348;
	Tue, 16 Feb 2021 08:48:47 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62b; helo=mail-ej1-x62b.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7A400100EB345
	for <linux-nvdimm@lists.01.org>; Tue, 16 Feb 2021 08:48:44 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id y26so17540096eju.13
        for <linux-nvdimm@lists.01.org>; Tue, 16 Feb 2021 08:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ecI3AnraXxD8s3/KbtK83ACA5HZ+x4/w5NBzKVHXCM=;
        b=Wm4E81qbjZm4Ote4+krHtLMT/Sg47muTNtm9HAKUxuG6Ynbpz/zx9MMwTAxRVTsgVJ
         /dzzWYIWuocSvGpYzRWHIensXSKdcLuR4nL7RXCE+p8DgFHIcvSeX0wcN5u7/JmCK0qp
         acnyO5VrRzp2jteOXYfH01EwKQRMekKGfugDte/4je+KFj4VmoylnLVz45G4U+t/SrpB
         iZWqFLwHhLLKfGymiYFRCCxGZPBfX3wrdFNwaXAyieuKeokwaE98+EHOUIK5WC+f3xUs
         9De32myHYjeq1IRoGAK7DkzalOxPCkwfTVMLHCtzioAjkOxq3Tp1syboSAYFWZtlM49Y
         /hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ecI3AnraXxD8s3/KbtK83ACA5HZ+x4/w5NBzKVHXCM=;
        b=S44yT/6LfEJMQLb8xypiEpuPOG85FU0Hp95UZlJG/oUHOvPJDiwxGuO1tFauY5xCk0
         E9hkNA1STFBSnvshCg6kC8XpmSj2PIUl3P7K/Slw9VNIsQRiwoQASIFXJ4axfo9sgXkU
         iVvU6ehlO0DmykMNJK4PMmsiU3ayyuk0l7jU3NmBopHKifde3E0Q2D+CPKs4Ehzh72Ij
         tDNKsWv+TIiqq0R8l2hNAIU5kXKLqF4ASCxXtDuxOSWnZOE2KFIcBaUWopuMXOk/JDkL
         acBr85p35Xo4FZNCBu5bzcgODNORL/AU4Ro2kStO+KLL4xUDNuNFYKQRjW4grnXwHoI5
         9BsQ==
X-Gm-Message-State: AOAM533/LrPdeR/rEQwfGsW7qLNaG6cGlQDFweQJgAsc2r9q+8hIAjDT
	rOqsHFlnDJ8kS2sbAFsj55+lNJEmhTprAS7c8VGcLw==
X-Google-Smtp-Source: ABdhPJw7/a6RtFAeh/ix7sMWO3UbzMvUPTqfzkV9KVjhDzFN7lG80bkPRoVGizFBbZxeH5ml2XKSfBwSVxENdDqxJEM=
X-Received: by 2002:a17:906:5655:: with SMTP id v21mr3112272ejr.264.1613494122365;
 Tue, 16 Feb 2021 08:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20210216014538.268106-1-ben.widawsky@intel.com>
 <20210216014538.268106-10-ben.widawsky@intel.com> <20210216154857.0000261d@Huawei.com>
In-Reply-To: <20210216154857.0000261d@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Feb 2021 08:48:32 -0800
Message-ID: <CAPcyv4j+DZq7fkRTW+_O1-AtAQwOPD65A8M5AWg7XU9N+TksRA@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] cxl/mem: Add payload dumping for debug
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Message-ID-Hash: 5V72HLYHI7FTE7IBIXBV5ZCIVPPN5CX2
X-Message-ID-Hash: 5V72HLYHI7FTE7IBIXBV5ZCIVPPN5CX2
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Ben Widawsky <ben.widawsky@intel.com>, linux-cxl@vger.kernel.org, Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux PCI <linux-pci@vger.kernel.org>, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, David Hildenbrand <david@redhat.com>, David Rientjes <rientjes@google.com>, Jon Masters <jcm@jonmasters.org>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/5V72HLYHI7FTE7IBIXBV5ZCIVPPN5CX2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Feb 16, 2021 at 7:50 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 15 Feb 2021 17:45:38 -0800
> Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> > It's often useful in debug scenarios to see what the hardware has dumped
> > out. As it stands today, any device error will result in the payload not
> > being copied out, so there is no way to triage commands which weren't
> > expected to fail (and sometimes the payload may have that information).
> >
> > The functionality is protected by normal kernel security mechanisms as
> > well as a CONFIG option in the CXL driver.
> >
> > This was extracted from the original version of the CXL enabling patch
> > series.
> >
> > Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
>
> My gut feeling here is use a tracepoint rather than spamming the kernel
> log.  Alternatively just don't bother merging this patch - it's on the list
> now anyway so trivial for anyone doing such debug to pick it up.
>

I've long wanted to make dev_dbg() a way to declare trace-points. With
that, enabling it as a log message, or a trace-point is user policy.
The value of this is having it readily available, not digging up a
patch off the list for a debug session.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
