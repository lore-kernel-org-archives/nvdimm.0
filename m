Return-Path: <SRS0=DizB=DO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E947FC47420
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 22:00:17 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C839212CC
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 22:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Ncyj5HRy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C839212CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A8BA7158A89E0;
	Wed,  7 Oct 2020 15:00:16 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::643; helo=mail-ej1-x643.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 389CF153771C4
	for <linux-nvdimm@lists.01.org>; Wed,  7 Oct 2020 15:00:13 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u21so5151062eja.2
        for <linux-nvdimm@lists.01.org>; Wed, 07 Oct 2020 15:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lT3B2ypuGco/P409+8M6gpuF12PaIQWc3S2n+DY8zro=;
        b=Ncyj5HRyOHiv/PCCXeiIOREYqhKi9W7Kz+qYVEQlXmRkJQFhr4mPMx/M7DMnm6YtOW
         DUL/0irEJWJ1u3Tn9PvlSn9dTNsY5IVKDzbC9mmRlGyJusWXyE84FSrRMHnC7+4R/s2K
         JlmM8UKi1+egfyf0npBB325upNgCiCd5lLpYz+Qt+xyrV5CQrPP3johyniRb8z+kgaE1
         GT+P5nqT7wPGuzMyK7J2sXKrVtMSHN7U9uJt8nssAD4vXadYIDhLD2lwmqXOOlH+//Pq
         Hz5f0mZ598OqpvKpcokOiVFhrrXoK3FDSB6Diw9PKUvJFn/Wdx3dxk6fca3QGoU6OwHC
         HCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lT3B2ypuGco/P409+8M6gpuF12PaIQWc3S2n+DY8zro=;
        b=Wy2sZ08RopxzlwguNWF2AtVU+3BLE5T1ujg8gpvRCRh7R2d6dzw6v6WZaOnMMN+eg2
         yKueBor/6K8Iq+SY8EgJzTxzg8XUPS/vvp/RYUwylpZr9m1LVJFdCgRVSPwu+UxVZzWR
         1FmLCM2W+6cwW/tcfdl4fDeCC+rK/lAHORt7OdqGe8SdusU0NzxwklIzT25DqG2SbIxA
         5M+33RQDy/UTEsRbfPL0GwXdYQXLoIuWJUVHp7bxx+wkrEvA6YBc+lAQj2Mou7xdsBbf
         YGb1U1ooOiTblb9Czvu4CphDFjGGfzDHowh2RcCOZeiMW7+ooxqvGtWLTryjUypgG5QY
         /QYg==
X-Gm-Message-State: AOAM533k0kbirEc6HCLjSebWxRWS6OBdXIELtTQMFiyPe6I8kVsOCy6G
	j6xB17mFcLPqzDkXHUyg4b8tp1qf+4Pv3DmViPrLpw==
X-Google-Smtp-Source: ABdhPJwku5mxYKwAyqqbDYZNawCeRw0Upn7X7sfFjzI/V4bf8n3ZT6QOAaXMTZWtxx4JzYTkY6EwLAJYedQOql+eTOc=
X-Received: by 2002:a17:906:4701:: with SMTP id y1mr5413376ejq.341.1602108010723;
 Wed, 07 Oct 2020 15:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201006230930.3908-1-rcampbell@nvidia.com> <20201007082517.GC6984@quack2.suse.cz>
In-Reply-To: <20201007082517.GC6984@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Oct 2020 14:59:59 -0700
Message-ID: <CAPcyv4j=q4n1PDW5vwOFpkeDEoDv2_xXBL+xoGsRwPn_ej=hnA@mail.gmail.com>
Subject: Re: [PATCH] ext4/xfs: add page refcount helper
To: Jan Kara <jack@suse.cz>
Message-ID-Hash: FRFMX6X53N5JEKHEJDR56L4OQSZV3OAK
X-Message-ID-Hash: FRFMX6X53N5JEKHEJDR56L4OQSZV3OAK
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Ralph Campbell <rcampbell@nvidia.com>, Linux MM <linux-mm@kvack.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/FRFMX6X53N5JEKHEJDR56L4OQSZV3OAK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 7, 2020 at 1:25 AM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 06-10-20 16:09:30, Ralph Campbell wrote:
> > There are several places where ZONE_DEVICE struct pages assume a reference
> > count == 1 means the page is idle and free. Instead of open coding this,
> > add a helper function to hide this detail.
> >
> > Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Looks as sane direction but if we are going to abstract checks when
> ZONE_DEVICE page is idle, we should also update e.g.
> mm/swap.c:put_devmap_managed_page() or
> mm/gup.c:__unpin_devmap_managed_user_page() (there may be more places like
> this but I found at least these two...). Maybe Dan has more thoughts about
> this.

Yes, but I think that cleanup comes once the idle page count is
unified to be 0 across typical and ZONE_DEVICE pages. Then
free_devmap_managed_page() can be moved internal to __put_page(). For
this patch it's just hiding the "idle == 1" assumption from
dax-filesystems.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
