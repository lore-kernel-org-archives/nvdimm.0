Return-Path: <SRS0=toYW=XV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69A5C432C2
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Sep 2019 03:58:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9272207FF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 26 Sep 2019 03:58:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="LFfuBtJA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9272207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 26B942010B847;
	Wed, 25 Sep 2019 21:00:32 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2607:f8b0:4864:20::243; helo=mail-oi1-x243.google.com;
 envelope-from=dan.j.williams@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56D8E2010B845
 for <linux-nvdimm@lists.01.org>; Wed, 25 Sep 2019 21:00:30 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id k25so841956oiw.13
 for <linux-nvdimm@lists.01.org>; Wed, 25 Sep 2019 20:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=C8aRMEzAG1LFBDuyUnWLMaUc+oAx+uYjzJmVSQYv6To=;
 b=LFfuBtJAEBUsZeRf1zdsm6cWTKyLFr7jAIs0jPe+xoxXgrK/agnjfR5/lyLfIVSXln
 ZXGebmDKI/KIMvOyc8ZdOvvxWOXS7Wo9XZHINmrxmj9EzbIZfPp5B2TGB/Ri54DezE6B
 ybj9fJqy5v/QEHUCLbdCwOLr9S81+fok+3pt2Y+1dvv38ydDTaVbx6d5uje+zJCrdGaT
 ot/vrKN6R//zYjKoEOS8ts7XwtCqTRWeUE1LkACmk8m5FKBPQy5XV9t3pYeQl560Zm5e
 WMAGJ0fWuq6pZT6mioGcYix5VyvGvRsX7WaICxT27PvwzTgJJuqmD5SW1MnNaL1sTgks
 uWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=C8aRMEzAG1LFBDuyUnWLMaUc+oAx+uYjzJmVSQYv6To=;
 b=FW3Npy4G/CxaJPOJxI5npuOOBvjQp8JPy4d6ZmkKI7xDeLkBxnJqmKhUaWzpDzTp2e
 zeanAaX95vLWw5mOVF6y5UIwlbQV92Ml6SHTCZkTZ0Tp0lis1oy33fsB0ESl/u9Dei/F
 UABJi9KXz9wxR7Tdg08zS+B68iHPMVtF2tLx9s5MALf9jlgn8SxsWqW4m0nqlAo185jG
 lKOx5ldu8tKqsNLbRZzK/nNWPRJjXEhb55J0uPCYfojhXxnhOOVLO1JYcr1AmDAYM3qI
 x8F+D65ps2ZLZxeYbYHjeZ0jhMM/pS289fi77WEKW1+3w+6p+OreZBmPxE6+YvOAWFSk
 NOkA==
X-Gm-Message-State: APjAAAXRnF5pwO5NwBpi2fBeGGDuBmAkxuWaEX4c48NX4ReFX2o8q3Hq
 ezv2LDkVCaaD4EBl9ncrSpEUANnt9vgoEbo3yHsnZMcw
X-Google-Smtp-Source: APXvYqxPDAajEUH+9cKV/YSF2NefKPIh2j6gtC+zIYGjVGSbXxQqoYCDgxrUsalD7GC/LEfXJJoKo51e+Cr65WREd+k=
X-Received: by 2002:a54:4f13:: with SMTP id e19mr1083652oiy.149.1569470300494; 
 Wed, 25 Sep 2019 20:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <1569468653-3489-1-git-send-email-taeho1224@gmail.com>
In-Reply-To: <1569468653-3489-1-git-send-email-taeho1224@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Sep 2019 20:58:09 -0700
Message-ID: <CAPcyv4ia511-iZDu7czMvOViKyxNDKGbYBT3cL90R+X-dDLVsA@mail.gmail.com>
Subject: Re: [PATCH] pmem: emulating usable memory as persistent memory
To: Taeho Hwang <taeho1224@gmail.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Wed, Sep 25, 2019 at 8:31 PM Taeho Hwang <taeho1224@gmail.com> wrote:
>
> This patch checks whether the specified memory (memmap) is
> userable or not. This patch prevents non-existing memory
> from being emulated as persistent memory.
> If non-existing memory is specified by memmap without
> this patch, struct nd_namespace_io and struct pmem_device
> will have invalid values.

The whole point of the memmap= option is that the person specifying it
knows more about the memory map than either the kernel or the platform
BIOS. Validating the memmap= parameter against the very same memory
map that is trying to be overridden violates that assumption. So
memmap= is a dangerous interface on purpose. Now, if you want to
define a new option that requires the base type to be E820_RAM that
might be defensible, but at this point given the age of the
memmap=ss!nn option and the wikis available to picking a valid value,
I'd advocate leaving it as is.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
