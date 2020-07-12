Return-Path: <SRS0=1VC5=AX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C16C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sun, 12 Jul 2020 15:04:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 340DE2068F
	for <linux-nvdimm@archiver.kernel.org>; Sun, 12 Jul 2020 15:04:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="1lpYHrUL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 340DE2068F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id BA1A6100554EA;
	Sun, 12 Jul 2020 08:04:17 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::543; helo=mail-ed1-x543.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BE88C100554E7
	for <linux-nvdimm@lists.01.org>; Sun, 12 Jul 2020 08:04:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so8555405edq.8
        for <linux-nvdimm@lists.01.org>; Sun, 12 Jul 2020 08:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qj0bhI6ITf7NsNQCzc13g7xBPIcKDPLXLxRWVyhKadk=;
        b=1lpYHrULhKhjRujL3vVYKMk1pTOV6z0Qn18Pzbj+9SqIeqTldQN8GQqJlESnF6hjmw
         3Pz3nl4IcvtVeRiZEsp08fVKMRVGuPYYUbbPOSWwoDw/A8exAOQBML2/eyUwqqENmpJJ
         hX340/opzmdPMAR389oxPTwEuy2wGVaOopHNKrH90Qzg5ycV1FB7E2dakduhKMcCizJn
         I5Lj6WOVVCP6geJ0G276K/DWG27qmsdljdFPwafjcso4Z1pWsPlzskTTbYylIQ18yevt
         EEWVHlpTyD7TEMkBpNuocr/MKWq5XuE6DWE8t6SUMqy7tz3I7WJ9UUOc55QjwXiDOxS5
         AYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qj0bhI6ITf7NsNQCzc13g7xBPIcKDPLXLxRWVyhKadk=;
        b=Tl8L9rKTyhwBKxafDLtecm6wVNrXDB7VITxhn6s7YzcVF8wVeBeIOjx3EUa/dK5HCS
         CasfKedC8PWkHunvpvi+KM7aVTpSt2+uCaoG30Rcwgl6B+X6lMXZrmRefxRo/uwHDse+
         Neb5PJ7JFn78vE5Ph8gLDf0+bNV0zMpzcApCFSd9QlERZ+HgguT63QK2tu6inmNdiANQ
         v2bMHN7ebSWbbgk8IK3l5SLZFhNxSViv3iRi4kEmx3mAhCbtbxjH2d4WLOXa1EtrlCDJ
         10UoCVHf4YvNqueeUpOHqBNsAsVWbk2f3CRtX7AupTVgoOMa5oLqYVH5fQmtD0cH1Fc4
         nucQ==
X-Gm-Message-State: AOAM53190vfMmNOSfyZyJsw6fv/SjErDJUTNAGkf3UPRMQHNWjWGb5po
	dltGf/NnKxBQp76SEauPAy2q43PLySf0fQMUBOvHjQ==
X-Google-Smtp-Source: ABdhPJxG8Dl1xq6NkBc+xRJtZwvYnZi7DEGDY0N/lQBH3mzasBMIBTbG6Hirp+yrERkxJoOoCodwiyhBz69sABrZtFs=
X-Received: by 2002:aa7:d043:: with SMTP id n3mr90307558edo.102.1594566251727;
 Sun, 12 Jul 2020 08:04:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200403205900.18035-1-joao.m.martins@oracle.com> <20200403205900.18035-11-joao.m.martins@oracle.com>
In-Reply-To: <20200403205900.18035-11-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Jul 2020 08:04:00 -0700
Message-ID: <CAPcyv4g=KifpmjbQYZYnxxYn=W0NBogvr6kGR3+bX14opYEZ=w@mail.gmail.com>
Subject: Re: [PATCH ndctl v1 10/10] daxctl/test: Add tests for dynamic dax regions
To: Joao Martins <joao.m.martins@oracle.com>
Message-ID-Hash: PXXJDOWPYD3PRAMGZ4NFRWM3TPXT5TV2
X-Message-ID-Hash: PXXJDOWPYD3PRAMGZ4NFRWM3TPXT5TV2
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PXXJDOWPYD3PRAMGZ4NFRWM3TPXT5TV2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 3, 2020 at 1:59 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Add a couple tests which exercise the new sysfs based
> interface for Soft-Reserved regions (by EFI/HMAT, or
> efi_fake_mem).
>
> The tests exercise the daxctl orchestration surrounding
> for creating/disabling/destroying/reconfiguring devices.
> Furthermore it exercises dax region space allocation
> code paths particularly:
>
>  1) zeroing out and reconfiguring a dax device from
>  its current size to be max available and back to initial
>  size
>
>  2) creates devices from holes in the beginning,
>  middle of the region.
>
>  3) reconfigures devices in a interleaving fashion
>
>  4) test adjust of the region towards beginning and end
>
> The tests assume you pass a valid efi_fake_mem parameter
> marked as EFI_MEMORY_SP e.g.
>
>         efi_fake_mem=112G@16G:0x40000
>
> Naturally it bails out from the test if hmem device driver
> isn't loaded/builtin or no region is found.

So, I finally have the kernel passing this test. Thank you! I did
notice that I need to make sure that there is only one hmem range
defined otherwise the test gets confused and fails. I expect it spills
over to other regions when the test expects that the region should be
full. Could you take a look at adjusting the test to constrain its
allocations to a single region?
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
