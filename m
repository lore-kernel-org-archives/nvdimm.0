Return-Path: <SRS0=DizB=DO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E87C46466
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 02:40:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F8AB207EA
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 02:40:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="EPjdVqDe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F8AB207EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 8CE67158B62E2;
	Tue,  6 Oct 2020 19:40:22 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::642; helo=mail-ej1-x642.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A291E1589CF52
	for <linux-nvdimm@lists.01.org>; Tue,  6 Oct 2020 19:40:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lw21so751850ejb.6
        for <linux-nvdimm@lists.01.org>; Tue, 06 Oct 2020 19:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=afZ2ku0615X/vbgIsq8uZABQa+HrZmef3/cMOPPeXPE=;
        b=EPjdVqDeTinUn3xle7QkZRs1c1I777r6WwVNCzmQvuelLMEIhN7D3byY1DbMWiHRAd
         QgHw7nunbi78JiFNVYPaj+vzDaQToh84mycymDqg79odab44O2bFpy0hTFRZMk6Gq88h
         gdm22jg2FmT9PYcFKiksCpHH97YYjHNLfkRJqB+XyuOtAK7X6n9Ol7Qc3aWxyX/ubcf1
         1Dj3nT3ueZ1gSrXVBd01SuIcMxMF+W8KjeuouHZbfkVWg3QUD53z+H8ypZQCYHGiMbYk
         lCoLazlQUecuVDEtHUfRDwSsCvcaF59aNbsh9HWw6NNgsgGSQloXWj+DnfN5l7npN3En
         PmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=afZ2ku0615X/vbgIsq8uZABQa+HrZmef3/cMOPPeXPE=;
        b=RGLnD+1mdyAL2n7ea/zz2ykw0ik+Uza6Uu/xVtMD/ygO5R4A6hsZPije6TThTRdD0a
         8OGSqgtX6XhawleBe5HTX4O5EBYk56FPVtTJtgiRufNQVJETpk78Lo8/PP0lHFvmrPM/
         nlizSyy596WSX/UJWyqrfj4/V89GZBQ/G6d/Jp/kXxwYtdNJO9AwJb5F1EwrGO0571q1
         vtxtkoSv1P71fgQ+l7bcQc5GulY/iCU//YQ016rdrAbtmBCtwM3wnb6hGUZK/NHa8TZ4
         0+PL9YI4Juwx6xM3AFZkl/fmdowZW0F1EFMQUOJbcsOxeYn62Iy0D4fh/vxS2fN1jR/7
         Av2g==
X-Gm-Message-State: AOAM532xR1ptouCrZi2qvvBzNnrqdjlhnymhji/CW/3ME8TZFpz81xe2
	AZxJV/M3NnzHRdqL3gwKSMEE2CC9ledi2vqfYvjttQ==
X-Google-Smtp-Source: ABdhPJyzhK0w2iAz2iCMzOOn/0AFV3bEvaxuBmF2mBxx+C4IpyFlFHdfkT/qw+BQgpUSKwf1wNdFiTZy1ImFQ33Wm94=
X-Received: by 2002:a17:906:1a0b:: with SMTP id i11mr1116582ejf.472.1602038416463;
 Tue, 06 Oct 2020 19:40:16 -0700 (PDT)
MIME-Version: 1.0
References: <20201006230930.3908-1-rcampbell@nvidia.com>
In-Reply-To: <20201006230930.3908-1-rcampbell@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Oct 2020 19:40:05 -0700
Message-ID: <CAPcyv4gYtCmzPOWErYOkCCfD0ZvLcrgfR8n2kG3QPMww9B0gyg@mail.gmail.com>
Subject: Re: [PATCH] ext4/xfs: add page refcount helper
To: Ralph Campbell <rcampbell@nvidia.com>
Message-ID-Hash: 7ANPW2ASME7ZW7GGXC66YW3IRNKOMABA
X-Message-ID-Hash: 7ANPW2ASME7ZW7GGXC66YW3IRNKOMABA
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Linux MM <linux-mm@kvack.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Andreas Dilger <adilger.kernel@dilger.ca>, "Darrick J. Wong" <darrick.wong@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7ANPW2ASME7ZW7GGXC66YW3IRNKOMABA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 6, 2020 at 4:09 PM Ralph Campbell <rcampbell@nvidia.com> wrote:
>
> There are several places where ZONE_DEVICE struct pages assume a reference
> count == 1 means the page is idle and free. Instead of open coding this,
> add a helper function to hide this detail.
>
> Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>
> I'm resending this as a separate patch since I think it is ready to
> merge. Originally, this was part of an RFC and is unchanged from v3:
> https://lore.kernel.org/linux-mm/20201001181715.17416-1-rcampbell@nvidia.com
>
> It applies cleanly to linux-5.9.0-rc7-mm1 but doesn't really
> depend on anything, just simple merge conflicts when applied to
> other trees.
> I'll let the various maintainers decide which tree and when to merge.
> It isn't urgent since it is a clean up patch.

Thanks Ralph, it looks good to me. Jan, or Ted care to ack? I don't
have much else pending for dax at the moment as Andrew is carrying my
dax updates for this cycle. Andrew please take this into -mm if you
get a chance. Otherwise I'll cycle back to it when some other dax
updates arrive in my queue.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
