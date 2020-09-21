Return-Path: <SRS0=qwCt=C6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F221C43469
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Sep 2020 16:29:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EC28A2396D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 21 Sep 2020 16:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="MLvu1XiM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC28A2396D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 71E87144BC997;
	Mon, 21 Sep 2020 09:29:55 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::52c; helo=mail-ed1-x52c.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5DC38143F0B74
	for <linux-nvdimm@lists.01.org>; Mon, 21 Sep 2020 09:29:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so13443329edw.7
        for <linux-nvdimm@lists.01.org>; Mon, 21 Sep 2020 09:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZaQa7Abtd+8UEp0nRWic7q85wZ9hYgwWkThXnfGTs2A=;
        b=MLvu1XiM37JMQAK8mcEAQHS7riWkwtKaVBpKVAYWsDADTla2z7wxFBQoQoZCPCosWu
         k/xyc4pdz/9ctIx9GtYlGlNWsy/Pq594BO8Ux18yfFhw4E6jW0wTKVu7AKILG67S52RN
         GGvi49YkmH7M1+9Fakpl6Bb+YwZKsK6ZKAikMWXr6j7rkLmxEkc25JkOME2lEo+9Ms2O
         QoqS6rQwQOk2h7O09zMq9bzGo/ZBnyBFwdtXBH7y/JJmm+olQLKajFFxIb2p2diy4C8c
         9YMzMAlsTE2VcjvWm1xEqIOQL/Vf82jNw41tlOlf8z4RH5kZrZQitdWYhrgAFokomH7+
         wa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZaQa7Abtd+8UEp0nRWic7q85wZ9hYgwWkThXnfGTs2A=;
        b=bn+M4JItFKUka4rXxWmhwlDXZgPNhQuWpIug18rJCYJp/3rEWzQdxe1OfiOYK30gQ8
         b4m5V0ESL8nZ6l4dOsiQtFmLRqKt9ct5Gxzs9aIofVdaJTzImxSTNwpcGLt4O6ZympXW
         YEIKbPi0gNXhTPhOs2HXaywetZvauwvsOrW4TUOGpJMj2D50aHgoXmUPbREgnYXE3Yc0
         InQyry2yUwKBJ7mxFbjBSoU1CnQ+UFgJe8P0FFcHCAAHd7Bpq7jEPgye9JAomBvj45in
         SePnohKirny6zJfNRuqoebzOldlkqPheaZm77V8EtvevKY7U9l/p9j5YT1nDeOVJtITI
         cOWg==
X-Gm-Message-State: AOAM531860Katqda63+cnO5J/Cy4iQlNBE+7J06RCeRVTiZS9MKP2sPC
	QfTI63caNvizJ7g40wTF2h+fmpVmFs0I8vcpY1DIJw==
X-Google-Smtp-Source: ABdhPJwheY2Lh1Ak+5XOojdS0UI6tT1hZiNEqs83oA0r33KKqLLs9hbC0JRM9HMp7eSFZRFsaag+Z+HNQGPl7N6O5UQ=
X-Received: by 2002:aa7:c511:: with SMTP id o17mr500351edq.300.1600705790950;
 Mon, 21 Sep 2020 09:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009140852030.22422@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gh=QaDB61_9_QTgtt-pZuTFdR6td0orE0VMH6=6SA2vw@mail.gmail.com> <alpine.LRH.2.02.2009211133190.15623@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009211133190.15623@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Sep 2020 09:29:39 -0700
Message-ID: <CAPcyv4iys4xDnDyuzo4yj1MvOWXkQ_NgPfupB=btZt_kzi29Ug@mail.gmail.com>
Subject: Re: [RFC] nvfs: a filesystem for persistent memory
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID-Hash: ADHQ5CW6P2LUDWK6BEHQDX5FW4MJMKY4
X-Message-ID-Hash: ADHQ5CW6P2LUDWK6BEHQDX5FW4MJMKY4
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>, "Tadakamadla, Rajesh (DCIG/CDI/HPS Perf)" <rajesh.tadakamadla@hpe.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ADHQ5CW6P2LUDWK6BEHQDX5FW4MJMKY4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 21, 2020 at 9:19 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Tue, 15 Sep 2020, Dan Williams wrote:
>
> > > TODO:
> > >
> > > - programs run approximately 4% slower when running from Optane-based
> > > persistent memory. Therefore, programs and libraries should use page cache
> > > and not DAX mapping.
> >
> > This needs to be based on platform firmware data f(ACPI HMAT) for the
> > relative performance of a PMEM range vs DRAM. For example, this
> > tradeoff should not exist with battery backed DRAM, or virtio-pmem.
>
> Hi
>
> I have implemented this functionality - if we mmap a file with
> (vma->vm_flags & VM_DENYWRITE), then it is assumed that this is executable
> file mapping - the flag S_DAX on the inode is cleared on and the inode
> will use normal page cache.
>
> Is there some way how to test if we are using Optane-based module (where
> this optimization should be applied) or battery backed DRAM (where it
> should not)?

No, there's no direct reliable type information. Instead the firmware
on ACPI platforms provides the HMAT table which provides performance
details of system-memory ranges.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
