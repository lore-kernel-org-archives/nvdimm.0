Return-Path: <SRS0=jR4L=AY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0E6C433E4
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jul 2020 16:55:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 895AA2067D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 13 Jul 2020 16:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="gtc+M+tW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 895AA2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 60E45110ACB97;
	Mon, 13 Jul 2020 09:55:05 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::544; helo=mail-ed1-x544.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6859E110ACB94
	for <linux-nvdimm@lists.01.org>; Mon, 13 Jul 2020 09:55:02 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id z17so14273040edr.9
        for <linux-nvdimm@lists.01.org>; Mon, 13 Jul 2020 09:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HgOXhDZaQ0Vm8QAO9SEojO+HqYa4R2CkQWkXTg5E7NY=;
        b=gtc+M+tWYcQvh1sK797pkjo7WfNXIE8olCSzxehn9iEfDXPy4UnYyp2+rSeemkOHd9
         3YCD1bGiwRH6cQssBiZxingdGDUwZDouqVsreN1+gJuIGG6p5wdMSWJUxTsfZgJsaSP/
         EKUruPSgSi5imDehnJ0OoKNYarRo4grmHiicSB3YKJASTXyGDOGVaFs1Xtu7/0rRGn5l
         W9+vrC+x0eOE026JlZDzAPRS9I7c7ZrINzB0baTS0Fv4LSjRTfPGrURIPHkOUcVtnaEy
         84Ykd5bPtW/7cJhsDtttHYS1i4aFielTGd+j2sm60fnPvc5Fai51ccDG/VbXOrStWecV
         ncaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgOXhDZaQ0Vm8QAO9SEojO+HqYa4R2CkQWkXTg5E7NY=;
        b=VM2G2hOAbVjZ0/5/j6/DfwhTJvaWzci6cltO/ILKhL5Fwti80gl7QggdEa18rr5VzK
         JECes8fPVFh5CVJSaY4cw1Xd81YMOrGI7CmHVN7kvb23kTiqblexun6i0DYFaigcxjH+
         aQT5neoZCbiPBZBlaSUjL4OyoQaio4qfvc/Tu77TAN/KBeYki7W4u1DIE76Eownu79sm
         Vu8x62T6WNb2NXJsbK+ILltkgLz0iXPX/yCrnm1+X4DiecxSIo3VH2JsdwixVYrzhTkt
         Wgb1GTqDILNRAij9OC3JdK4qlMJva7ypeod7REdr91W+fe9xMt7AAD1uBvc0NMlFsBVh
         oIdg==
X-Gm-Message-State: AOAM531U23BIFMnB9CXrGC21g+X9Kvma3z9NffJoNz4x5iHDRyJw69dc
	QOO44jaeHVay6y52QppkraCM7NwTtn6xMEfwgF2+Ig==
X-Google-Smtp-Source: ABdhPJy2i/ttAyiKjR1qbX0QvV/QhWFNtJPFDiAHrxVvIXYFYUkb5Tgr0e/mIqA9cSxtejueFDTinGXoBIyHGcdsgj8=
X-Received: by 2002:a50:d9cb:: with SMTP id x11mr299675edj.93.1594659300586;
 Mon, 13 Jul 2020 09:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <159457116473.754248.7879464730875147365.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159457126779.754248.3575056680831729751.stgit@dwillia2-desk3.amr.corp.intel.com>
 <52e00a67-b686-8554-8b92-a172ba9f34b6@nvidia.com>
In-Reply-To: <52e00a67-b686-8554-8b92-a172ba9f34b6@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Jul 2020 09:54:49 -0700
Message-ID: <CAPcyv4gQpAjkQ2j9D0pU-0UrmJzf9eLqtFsmqd8v5=+kyR3ZSg@mail.gmail.com>
Subject: Re: [PATCH v2 19/22] mm/memremap_pages: Convert to 'struct range'
To: Ralph Campbell <rcampbell@nvidia.com>
Message-ID-Hash: D3O2NWDYFT6L73XJ4OK7CVYTAJFTJ6VG
X-Message-ID-Hash: D3O2NWDYFT6L73XJ4OK7CVYTAJFTJ6VG
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Paul Mackerras <paulus@ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jason Gunthorpe <jgg@mellanox.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joao Martins <joao.m.martins@oracle.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/D3O2NWDYFT6L73XJ4OK7CVYTAJFTJ6VG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 13, 2020 at 9:36 AM Ralph Campbell <rcampbell@nvidia.com> wrote:
>
>
> On 7/12/20 9:27 AM, Dan Williams wrote:
> > The 'struct resource' in 'struct dev_pagemap' is only used for holding
> > resource span information. The other fields, 'name', 'flags', 'desc',
> > 'parent', 'sibling', and 'child' are all unused wasted space.
> >
> > This is in preparation for introducing a multi-range extension of
> > devm_memremap_pages().
> >
> > The bulk of this change is unwinding all the places internal to
> > libnvdimm that used 'struct resource' unnecessarily.
> >
> > P2PDMA had a minor usage of the flags field, but only to report failures
> > with "%pR". That is replaced with an open coded print of the range.
> >
> > Cc: Paul Mackerras <paulus@ozlabs.org>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Ben Skeggs <bskeggs@redhat.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Jason Gunthorpe <jgg@mellanox.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >   arch/powerpc/kvm/book3s_hv_uvmem.c     |   13 +++--
> >   drivers/dax/bus.c                      |   10 ++--
> >   drivers/dax/bus.h                      |    2 -
> >   drivers/dax/dax-private.h              |    5 --
> >   drivers/dax/device.c                   |    3 -
> >   drivers/dax/hmem/hmem.c                |    5 ++
> >   drivers/dax/pmem/core.c                |   12 ++---
> >   drivers/gpu/drm/nouveau/nouveau_dmem.c |    3 +
> >   drivers/nvdimm/badrange.c              |   26 +++++------
> >   drivers/nvdimm/claim.c                 |   13 +++--
> >   drivers/nvdimm/nd.h                    |    3 +
> >   drivers/nvdimm/pfn_devs.c              |   12 ++---
> >   drivers/nvdimm/pmem.c                  |   26 ++++++-----
> >   drivers/nvdimm/region.c                |   21 +++++----
> >   drivers/pci/p2pdma.c                   |   11 ++---
> >   include/linux/memremap.h               |    5 +-
> >   include/linux/range.h                  |    6 ++
> >   mm/memremap.c                          |   77 ++++++++++++++++----------------
> >   tools/testing/nvdimm/test/iomap.c      |    2 -
> >   19 files changed, 135 insertions(+), 120 deletions(-)
>
> I think you are missing a call to memremap_pages() in lib/test_hmm.c
> and a call to release_mem_region() that need to be converted too.
> Try setting CONFIG_TEST_HMM=m.

Thanks Ralph, looks like I overlooked these changes since the rebase.

> Also, what about the call to release_mem_region() in
> drivers/gpu/drm/nouveau/nouveau_dmem.c? Doesn't that need a small change too?

I'll double check my config, that one should have been flagged at build time.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
