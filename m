Return-Path: <SRS0=Z5NW=XB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FC7C43331
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Sep 2019 17:49:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4F5920842
	for <linux-nvdimm@archiver.kernel.org>; Fri,  6 Sep 2019 17:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="w9mvMZHj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4F5920842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 171D820294F25;
	Fri,  6 Sep 2019 10:50:08 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2607:f8b0:4864:20::244; helo=mail-oi1-x244.google.com;
 envelope-from=dan.j.williams@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 475392027725A
 for <linux-nvdimm@lists.01.org>; Fri,  6 Sep 2019 10:50:06 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id w144so5646316oia.6
 for <linux-nvdimm@lists.01.org>; Fri, 06 Sep 2019 10:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=v0nCUWfBIIke8wwI1KyHL3YbLuJIie4lZRF4o2QAa+U=;
 b=w9mvMZHjPsWt2wobT50t3BacTw+r6JWhWrAAMCRxMT+y42StYak3JdhEstaeezDbFz
 5D+YAGD+9uImohq67WH2J/CCRTTDaLzmW3aNN6J7gNEjIxb/NbFK3ai/+neHxUqopRe4
 kwsDljl0uMkWijhJj75ACoOmliGJkq7BSg7xt6ISm1/RLeM3M2PJoekNx81oC5NEVz+U
 q5X8Pjw8AQHAe23Y/lrlV6Irn3yIkAqh3WfO3/UG2TYLISTsg4SjnPmY8YMHNd0qtjJh
 h58yw39L+8CplWLYKSlBhz00s7ahXrBPqQEze/WZpes6LUMY9+gsrvQxgoXgbBV4sUp/
 ro5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=v0nCUWfBIIke8wwI1KyHL3YbLuJIie4lZRF4o2QAa+U=;
 b=ew7dpDKpqyNcSJVB022u1hYdORdsWd7JTQBSS5UlX0d3RvVp7sgY3ElXPdJVGxziAm
 FSIx6WyGx3aPCSOv+YE3upsjbMo0FeMxmrTNmZ1gwgYqc725wxErNbDtKULoH6jeKdKF
 D/cI5ywGFUA1pjxhnjVGjIkqlXUDE3yuUmRjOozeF+iWLxgGa/nAtRyre2xdgRvIQ3LS
 krVrXr7mxMl8XcbIwjhCD6dMOaaQep/hDRj5nTh9dpOPpPxpoXiSaOwE0D4zkjzwrO9J
 2IeL+5iyc9pROVa3QlLYkhKm6PEzwCEXTYdyfk0wWcVpXCSQWiMF4SiBtWVaxNYGTSuG
 2gdw==
X-Gm-Message-State: APjAAAW6KmXtVICe5t7v4iLPgXyERrW4O0ugxz+SLeWZtI85xZe1WjXo
 eOc8V7kReHagfH+OHjpYosZoNfy7rgRLGCJEHBy+Gg==
X-Google-Smtp-Source: APXvYqwIjRdKvXtSKs1CFHbh7noAzQrZn7gaPwXlKUXyVYYMR0KgmWTElXrbpBWGx+83AIEG1btt+VsAOolhNr1yLns=
X-Received: by 2002:aca:4b05:: with SMTP id y5mr7790208oia.70.1567792156564;
 Fri, 06 Sep 2019 10:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190905154603.10349-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190905154603.10349-1-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Sep 2019 10:49:05 -0700
Message-ID:
 <CAPcyv4jsDeZ27cfCQbeNtwxWhaUb-nT-U=mQnMM18GL7yxc7RQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/7] Mark the namespace disabled on pfn superblock
 mismatch
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
Message-ID: <20190906174905.65vre-ZzR1yzOvOQxUcvVBqdl4EaDdXAkWsqFfO0ThE@z>

On Thu, Sep 5, 2019 at 8:46 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> We add new members to pfn superblock (PAGE_SIZE and struct page size) in this series.
> This is now checked while initializing the namespace. If we find a mismatch we mark
> the namespace disabled.
>
> This series also handle configs where hugepage support is not enabled by default.
> This can result in different align restrictions for dax namespace. We mark the
> dax namespace disabled if we find the alignment not supported.
>
> Changes from v8:
> * updated patch 7 for addressing review feedback
>
> Changes from v6:
> * Formatting changes
>
> Changes from v5:
> * Split patch 3
> * Update commit message
> * Add MAX_STRUCT_PAGE_SIZE with value 64 and use that when allocating reserve block
> * Add BUILD_BUG_ON if we find sizeof(struct page) > 64
>
>
>
> Aneesh Kumar K.V (6):
>   libnvdimm/pmem: Advance namespace seed for specific probe errors
>   libnvdimm/pfn_dev: Add a build check to make sure we notice when
>     struct page size change
>   libnvdimm/pfn_dev: Add page size and struct page size to pfn
>     superblock
>   libnvdimm/label: Remove the dpa align check
>   libnvdimm: Use PAGE_SIZE instead of SZ_4K for align check
>   libnvdimm/dax: Pick the right alignment default when creating dax
>     devices
>
> Dan Williams (1):
>   libnvdimm/region: Rewrite _probe_success() to _advance_seeds()
>
>  drivers/nvdimm/bus.c            |   8 +--
>  drivers/nvdimm/label.c          |   5 --
>  drivers/nvdimm/namespace_devs.c |  40 +++++++++---
>  drivers/nvdimm/nd-core.h        |   3 +-
>  drivers/nvdimm/nd.h             |  10 +--
>  drivers/nvdimm/pfn.h            |   5 +-
>  drivers/nvdimm/pfn_devs.c       | 110 +++++++++++++++++++++++++-------
>  drivers/nvdimm/pmem.c           |  29 +++++++--
>  drivers/nvdimm/region_devs.c    |  76 ++++------------------
>  include/linux/huge_mm.h         |   7 +-
>  10 files changed, 176 insertions(+), 117 deletions(-)

Looks good, 0day has no complaints and this passes all the current
unit tests. I'll get it pushed out for v5.4 consideration. Thanks
Aneesh!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
