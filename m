Return-Path: <SRS0=/Rsh=32=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F79C352A1
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Feb 2020 00:37:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64A08214AF
	for <linux-nvdimm@archiver.kernel.org>; Thu,  6 Feb 2020 00:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="pwboQQ6d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A08214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9151110FC3175;
	Wed,  5 Feb 2020 16:41:12 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::342; helo=mail-ot1-x342.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1DC7B1007B1FA
	for <linux-nvdimm@lists.01.org>; Wed,  5 Feb 2020 16:41:09 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 77so3870116oty.6
        for <linux-nvdimm@lists.01.org>; Wed, 05 Feb 2020 16:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CgZnEXyLY0Syv8bqgt/nY2nliVOx+eludqj9JOuXxQ=;
        b=pwboQQ6dDYepvw2yHSZ7z5GQ8dklJBoUgx6mY+1GPFCvi6qF7pwQwc1HBoxE94l5uf
         FrRuw63gYQSxkeL3yQDQ6w7haexXzC6nuTHkR7cM3WV2kJv3Cm7yWLHrKRN5K01Aldul
         cFm1aR5dBNJdzGk8yRek/jMlS4F3T/nHtX9o7QwHj6Kbyi2SN/oGstf5MIdDjbCg3TRV
         wgsAqsKwlwyeCYbG9OQRCBR4XKQiIDPJTpRuT8ZRLpv2IJ1nxl/xZ01+KPD9rFacJTbS
         1acZ0CEKWMpXWzhWtO66EURrfyINvc7RfsZ4/QSiyKI7ixNk6at3DcYSK2pqh3un6DdX
         Prdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CgZnEXyLY0Syv8bqgt/nY2nliVOx+eludqj9JOuXxQ=;
        b=JpkqkFi02MW7Ksl6NVMcke0FsWZhAy13nShfV3sTSjF56rGDdKms9jTaQMVquuNK/k
         k9QtxXoXqs7Pla1azxnr0RCpr639O9nVOpMxMknKMoKdbz0jI7GUk7Qvv85axbwHlpSN
         pd2ZlQnnthU7XfLyYyiJ8RQCxIgW9dweZ8L1PDkug71BlmjwMq4X+8U7wLAUwsNFmX+c
         o1mo0fNOBxADAYUF7Q+ubH5PUxL4uD5xJMhRxQBSsE4E7Uw4DapIoen68CJbO0aBFSHN
         wBwgUJIwsJtxFmClDp9v3A/NOOlfjEUQpYpPuukTC3+emwV689+iR4YATCh5qlccQeth
         JM4g==
X-Gm-Message-State: APjAAAW47KyTTMMaWqtV1xDBVhS6Xy7EyY/X6771QZ6OCIYLUmV+e3Je
	bkvjhjnfR3h+8BA/jTDA/WTnzdTO1tWPSAyaGGsVPQ==
X-Google-Smtp-Source: APXvYqxt4gAkv1hvtAuccfBn1VDSYiNjQ3JyFMqiBZWssfDAFC+d5vqWE5smrRjpV1xIeHW8XfSCsOK0aAAeNKsk2fM=
X-Received: by 2002:a9d:1284:: with SMTP id g4mr27696911otg.207.1580949471777;
 Wed, 05 Feb 2020 16:37:51 -0800 (PST)
MIME-Version: 1.0
References: <20200129210337.GA13630@redhat.com> <f97d1ce2-9003-6b46-cd25-a908dc3bd2c6@oracle.com>
In-Reply-To: <f97d1ce2-9003-6b46-cd25-a908dc3bd2c6@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Feb 2020 16:37:40 -0800
Message-ID: <CAPcyv4ittXHkEV4eH_4F5vCfwRLoTTtDqEU1SmCs5DYUdZxBOA@mail.gmail.com>
Subject: Re: [RFC][PATCH] dax: Do not try to clear poison for partial pages
To: Jane Chu <jane.chu@oracle.com>
Message-ID-Hash: 567CMT52Y4THCR7PN6HOCRUM6USJXHF6
X-Message-ID-Hash: 567CMT52Y4THCR7PN6HOCRUM6USJXHF6
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/567CMT52Y4THCR7PN6HOCRUM6USJXHF6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 5, 2020 at 12:27 PM <jane.chu@oracle.com> wrote:
>
> Hello,
>
> I haven't seen response to this proposal, unsure if there is a different
> but related discussion ongoing...
>
> I'd like to express my wish: please make it easier for the pmem
> applications when possible.
>
> If kernel does not clear poison when it could legitimately do so,

The only path where this happens today is write() syscalls in dax
mode, otherwise fallocate(PUNCH_HOLE) is currently the only guaranteed
way to trigger error clearing from userspace (outside of sending raw
commands to the device).

> applications have to go through lengths to clear poisons.
> For Cloud pmem applications that have upper bound on error recovery
> time, not clearing poison while zeroing-out is quite undesirable.

The complicating factor in all of this is the alignment requirement
for clearing and the inability for native cpu instructions to clear
errors. On current platforms talking to firmware is required and that
interface may require 256-byte block clearing. This is why the
implementation glommed on to clearing errors on block-I/O path writes
because we at least knew that all of those I/Os were 512-byte aligned.

This gets better with cpus that support the movdir64b instruction, in
that case there is still a 64-byte alignment requirement, but there's
no need to talk to the BIOS and therefore no need to talk to a driver.

So we have this awkward dependency on block-device I/O semantics only
because it happened to organize i/o in a way that supports error
clearing.

Right now the kernel does not install a pte on faults that land on a
page with known poison, but only because the error clearing path is so
convoluted and could only claim that fallocate(PUNCH_HOLE) cleared
errors because that was guaranteed to send 512-byte aligned zero's
down the block-I/O path when the fs-blocks got reallocated. In a world
where native cpu instructions can clear errors the dax write() syscall
case could be covered (modulo 64-byte alignment), and the kernel could
just let the page be mapped so that the application could attempt it's
own fine-grained clearing without calling back into the kernel.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
