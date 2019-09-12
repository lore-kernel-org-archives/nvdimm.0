Return-Path: <SRS0=iZWN=XH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF1CC4CEC5
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 14:35:33 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB22F2081B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 12 Sep 2019 14:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="U+948HHk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB22F2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 72C0E202E293A;
	Thu, 12 Sep 2019 07:35:34 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=2607:f8b0:4864:20::241; helo=mail-oi1-x241.google.com;
 envelope-from=dan.j.williams@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB96E202E2938
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 07:35:32 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id a127so17315339oii.2
 for <linux-nvdimm@lists.01.org>; Thu, 12 Sep 2019 07:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=intel-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Io9DNJGsYP/EoLiKkjBJ1rL6MkBN0phNsCUNsDEUxEA=;
 b=U+948HHkOKyR9d/hZ4xXOolDklm6ZxogihkXVaQXIlZ2Jp0xAfPiOiDR1eeKLcxhsb
 5Ay9oW8x4gAF/ScNXFJ5/uAfJF+x96sJU8OdlshGaW/ZPcVv2a7utPAsbHVt+K7wGEci
 YUXtY8qTKYk7tEFBAN1BU43HEsU51Txu+WY53MJcV8TMBMcRyutk9IeYeB1U6/3OlFCH
 mfYbjUizrBISPJmIzcvtuPtT0BpSFs641NcVqIFAcIqAXsmFg3PhladJynRdijim3v/X
 gt+S7+ZPfO6uJ3ZlnHessp7AGmoSuDuPfxVxgNmgtymXoTgmvpzeZhtJHNboAqN989Wf
 4Z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Io9DNJGsYP/EoLiKkjBJ1rL6MkBN0phNsCUNsDEUxEA=;
 b=spaMz0jG5npm/c2qH556Sp1OGeJaz73O+KjWHCIDCGX3uiVIUj9d7x3wtXc7/5aHRe
 OltwnfNtHq5mq8XbvWNI1G9IT0fIWY5aBkZXtuBVj9fzX+eTQ2+dq5ydD71md1gs2WT5
 S/N2AKfBj+QhT9gpB+1CfODVpuqTiw9kn/7ndA5sNT3XEzrot9FH74dsj54uKGMcUMsN
 RT7bvCWR5yMFtTHyBqhnLnjxyvGYmkilnNArpC+D8Usyx5S3shRXZ9bQsLYK7Xy6LtFR
 wHjqBelf9QzIeTEgrZ+QPNeJnvcZHTujP5wMbb0w/fTDgb/MSQLNa06QItqp69lo0G5M
 aHPA==
X-Gm-Message-State: APjAAAU/ivmMCMtaT1BWtgZ0vN5fKBRDX++sPKp/9e+WLiYcg6G0uDIu
 6DM+wjuwdYCF9Yan63W66r5wmeQ1Dbnk5eSLSycGLA==
X-Google-Smtp-Source: APXvYqzD2zpg+CObBviUAPj5DEJdMDbUroz5eIu/ODnjvin5v1n6Ap2TxZcFLLZZWfJmGy580oftPSIZHc19EMV+U8Y=
X-Received: by 2002:aca:1b11:: with SMTP id b17mr380825oib.0.1568298929503;
 Thu, 12 Sep 2019 07:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568256705.git.joe@perches.com>
 <x498sqtvclx.fsf@segfault.boston.devel.redhat.com>
 <16d91aa0-e353-843b-2e94-efd5a26e145d@suse.de>
In-Reply-To: <16d91aa0-e353-843b-2e94-efd5a26e145d@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Sep 2019 07:35:18 -0700
Message-ID: <CAPcyv4hhZZ558baVow9HdGbjFupg6xjyT-Zpvjs99neDwOPA9A@mail.gmail.com>
Subject: Re: [PATCH 00/13] nvdimm: Use more common kernel coding style
To: Johannes Thumshirn <jthumshirn@suse.de>
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
Cc: Joe Perches <joe@perches.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dan Carpenter <dan.carpenter@oracle.com>,
 linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Thu, Sep 12, 2019 at 7:06 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> On 12/09/2019 16:00, Jeff Moyer wrote:
> > I'd rather avoid the churn and the risk of
> > introducing regressions.  This will also make backports to stable more
> > of a pain, so it isn't without cost.  Dan, is this really something you
> > want to do?
>
> I'm a 100% with Jeff on this!

Agree, see my other response here:

https://lore.kernel.org/r/CAPcyv4iu13D5P+ExdeW8OGMV8g49fMUy52xbYZM+bewwVSwhjg@mail.gmail.com/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
