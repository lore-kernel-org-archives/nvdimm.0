Return-Path: <SRS0=jR4L=AY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F87C433E7
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jul 2020 15:42:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C7F720771
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jul 2020 15:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="shNHxqlE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C7F720771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2FA32117FA59C;
	Mon, 13 Jul 2020 08:42:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::642; helo=mail-ej1-x642.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 50ED6117E12BC
	for <linux-nvdimm@lists.01.org>; Mon, 13 Jul 2020 08:42:54 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so17760762ejc.3
        for <linux-nvdimm@lists.01.org>; Mon, 13 Jul 2020 08:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KYHsayQ+qnaeJrGEqb3AbWD3OCs6eDEgmK0sEjz5stk=;
        b=shNHxqlEshcLM+d6HS5/rUuF/G7IfTpZe/gUMK2OQCtYZavKPmFx9lPmSy+8XWB0KK
         35jBVVrUdNO+Jfvrrp+eIP/JvR08WY9U0DdkU6T89bTgCxQCuK1PVuWJIjGMTLjE8rE3
         XTJ5PHCfIDj2m3E204SFtns5sNa6dcgofuJWbiwgwOmwi0NipOUB6QrkLZ+DoEueqmMB
         PgWCgNO4So36JTX6IgokxC3NYAKVD194ZFfivEOk1MU5Ch8Hq+JnhQK68aoXqc58zKh0
         6H4qLbRrffd4vFYKWrXDmxbjRxZ7jEpY4zZCg4XrAX2YN8jpDHcMkBByyN832GpItPwM
         QGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KYHsayQ+qnaeJrGEqb3AbWD3OCs6eDEgmK0sEjz5stk=;
        b=JkoB8TciT1LlUz+ch4H72VwufGq00JL+rQbs6dDMPCWqEoqWivcG9PU3c+R8pi5k2X
         CVBZ8YMBqpXbBbVG32vCtTYBd8HOfVlaYCyGJ7HSThGUGruEsO6aY8qP7XSWT9/q9dRq
         PExTqPdkt8LWICflM2giKGbh0p02FdR5HjIkzXxw2iwDYwlOP3DvgK5E/lgH195mSmII
         iHERV49v/ph4wzgzPYQX5AF4QAGyTrjR4msiNijYPxpXe/X1vQBr8OtNLgh7h8QY7wH6
         B8k47Nel9BnPzUTEszq8KQCaKNOr1i41cR1HkDuLyVU5AqUcm54RQurBCaSh6NaFb0Fc
         uBxg==
X-Gm-Message-State: AOAM5319iKOFeBmHDBIQ9S7RI7Lrb+XUV/HgfpwRR0tvFQzc6G4lCDEo
	hDEUoKhR7wPDpH/dIY9KlPWpqXDIuFbgzS+w49tWvA==
X-Google-Smtp-Source: ABdhPJxUImaKchQhePlG2M01YtnBmwJfKXSrMtOhR08dhoQCgRWcxaVYGh90/4tQIBcAr8wpwsrZSqeoZAyg7POGAfM=
X-Received: by 2002:a17:907:20af:: with SMTP id pw15mr393528ejb.204.1594654971733;
 Mon, 13 Jul 2020 08:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <159457116473.754248.7879464730875147365.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159457120334.754248.12908401960465408733.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200713065801.GB11000@linux.ibm.com>
In-Reply-To: <20200713065801.GB11000@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Jul 2020 08:42:41 -0700
Message-ID: <CAPcyv4gBgCptZupxhzbDN3qscnuJ9HNWHHvfhH6z+z84VE1cPg@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] numa: Introduce a generic memory_add_physaddr_to_nid()
To: Mike Rapoport <rppt@linux.ibm.com>
Message-ID-Hash: PBA7SFTEUWWYSYTZSA7A7NDECANJHAJL
X-Message-ID-Hash: PBA7SFTEUWWYSYTZSA7A7NDECANJHAJL
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Jia He <justin.he@arm.com>, Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joao Martins <joao.m.martins@oracle.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PBA7SFTEUWWYSYTZSA7A7NDECANJHAJL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 12, 2020 at 11:58 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Hi Dan,
>
> On Sun, Jul 12, 2020 at 09:26:43AM -0700, Dan Williams wrote:
> > For architectures that opt into storing their numa data in memblock
> > (only ARM64 currently), add a memblock generic way to interrogate that
> > data for memory_add_physaddr_to_nid(). This requires ARCH_KEEP_MEMBLOCK
> > to keep memblock text and data around after boot.
>
> I afraid we are too far from using memblock as a generic placeholder for
> numa data. Although all architectures now have the numa info in
> memblock, only arm64 uses memblock as the primary source of that data.
>
> I'd rather prefer Jia's solution [1] to have a weak default for
> memory_add_physaddr_to_nid() and let architectures override it.

I'm ok with that as long as we do the same for phys_to_target_node().

Will had the concern about adding a generic numa-info facility the
last I tried this. I just don't see a practical way to get there in
the near term.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
