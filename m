Return-Path: <SRS0=BCNs=7B=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028F2C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue, 19 May 2020 07:09:28 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA6DB207D8
	for <linux-nvdimm@archiver.kernel.org>; Tue, 19 May 2020 07:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="pN7+ZmJt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA6DB207D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9916B11EAAB27;
	Tue, 19 May 2020 00:06:11 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::641; helo=mail-ej1-x641.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 6F38311EAAB23
	for <linux-nvdimm@lists.01.org>; Tue, 19 May 2020 00:06:09 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id h21so10896366ejq.5
        for <linux-nvdimm@lists.01.org>; Tue, 19 May 2020 00:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kh83+i5wB5y2TfXkmhcoF7oKPmPUYzTeTgOonnemCpU=;
        b=pN7+ZmJtXthz51NwK6m+cXBceZzSW8sG8yjk8lz9tZ2AYsaxG7G5SuJU9gcTPwhgF2
         SjBsEkJFw+nwv5D66n6a7vYs1Fm44ovq7EFARvR/L30Q7OvDbNiFqOuKH6yh0qSYaCXD
         4C71DCRRAxm98S6NZmsDUvbqxY2Y2TiyvEpPQGYxLr7E2T/53XMsHzWJ77p2dgQV4UMl
         6FO8hAIZ450ZNMkZsnUDPuZ2ROfV7bCLdgmXPfKqmdjPC+y+E+M03Bq1hhukl82tFPd9
         T+es2PQDXaXYx+CU5Hfv8opcO/Vh58qINekflet+xyOykAlkVmzUW0Yp+bGlDIZaRKkQ
         5Nng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kh83+i5wB5y2TfXkmhcoF7oKPmPUYzTeTgOonnemCpU=;
        b=a4BZie03IoPZpFFErJCr3bPcz+cegbyCAxljU2DuUQrVD2Le4FsuQTHXP9NlMiN6o6
         eq4adMr8MqW1U9WacRhvSVHMGFz3MxDlkwYIDzx5Qkfvmr6fSZ1/1LEnMj66J+zTAiRd
         Z5CckjhgN4Re/AjuGjc1SfrTgd9OMa0WB2075aSUqeRkx92MAS6lfOfRY0on5IOv73ig
         EYUPb8d24Af/R2+rjDdwSQfUaDS4b/6NHhDALO5xrybP2l9OIxcA5y8lxlc6wJPDf9el
         P8YsYEYFVL60yMCG2RUxEGFgE7KqTuqL6dTXaOBXsbQE7okjQ3BCSxxM1JbySwLNVv9p
         yiZg==
X-Gm-Message-State: AOAM532eoUC/NNQv25QNNRHEJzhlwMwFCVmJRs4BSHYirsm9AQZXkdRA
	CS9HMVVSVfeNNTkmc3c5Mo0rdMbErIsAuBNkpoEG2A==
X-Google-Smtp-Source: ABdhPJyY1+6icu96XuroiXonfBuEVeMr79j7e37fGri7YK7TKCij2SqixO72vqqnp4Yc2n02GlZTqPAoijK4JHeT+rg=
X-Received: by 2002:a17:907:9484:: with SMTP id dm4mr8403153ejc.56.1589872162813;
 Tue, 19 May 2020 00:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200513034705.172983-1-aneesh.kumar@linux.ibm.com>
 <20200513034705.172983-3-aneesh.kumar@linux.ibm.com> <CAPcyv4iAdrdMiSzVr1UL9Naya+Rq70WVuKqCCNFHe1C4n+E6Tw@mail.gmail.com>
 <87v9kspk3x.fsf@linux.ibm.com>
In-Reply-To: <87v9kspk3x.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 May 2020 00:09:11 -0700
Message-ID: <CAPcyv4g+oE305Q5bYWkNBKFifB9c0TZo6+hqFQnqiFqU5QFrhQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] libnvdimm/nvdimm/flush: Allow architecture to
 override the flush barrier
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID-Hash: CSRK7C7ICUYD7XEBCHL5MJP7V4CAPZN6
X-Message-ID-Hash: CSRK7C7ICUYD7XEBCHL5MJP7V4CAPZN6
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, alistair@popple.id.au
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CSRK7C7ICUYD7XEBCHL5MJP7V4CAPZN6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 18, 2020 at 10:30 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
>
> Hi Dan,
>
> Apologies for the delay in response. I was waiting for feedback from
> hardware team before responding to this email.
>
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Tue, May 12, 2020 at 8:47 PM Aneesh Kumar K.V
> > <aneesh.kumar@linux.ibm.com> wrote:
> >>
> >> Architectures like ppc64 provide persistent memory specific barriers
> >> that will ensure that all stores for which the modifications are
> >> written to persistent storage by preceding dcbfps and dcbstps
> >> instructions have updated persistent storage before any data
> >> access or data transfer caused by subsequent instructions is initiated.
> >> This is in addition to the ordering done by wmb()
> >>
> >> Update nvdimm core such that architecture can use barriers other than
> >> wmb to ensure all previous writes are architecturally visible for
> >> the platform buffer flush.
> >
> > This seems like an exceedingly bad idea, maybe I'm missing something.
> > This implies that the deployed base of DAX applications using the old
> > instruction sequence are going to regress on new hardware that
> > requires the new instructions to be deployed.
>
>
> pmdk support for ppc64 is still work in progress and there is pull
> request to switch pmdk to use new instruction.

Ok.

>
> https://github.com/tuliom/pmdk/commit/fix-flush
>
> All userspace applications will be switched to use the new
> instructions. The new instructions are designed such that when running on P8
> and P9 they behave as 'dcbf' and 'hwsync'.

Sure, makes sense.

> Applications using new instructions will behave as expected when running
> on P8 and P9. Only future hardware will differentiate between 'dcbf' and
> 'dcbfps'

Right, this is the problem. Applications using new instructions behave
as expected, the kernel has been shipping of_pmem and papr_scm for
several cycles now, you're saying that the DAX applications written
against those platforms are going to be broken on P8 and P9?

> > I'm thinking the kernel
> > should go as far as to disable DAX operation by default on new
> > hardware until userspace asserts that it is prepared to switch to the
> > new implementation. Is there any other way to ensure the forward
> > compatibility of deployed ppc64 DAX applications?
>
> AFAIU there is no released persistent memory hardware on ppc64 platform
> and we need to make sure before applications get enabled to use these
> persistent memory devices, they should switch to use the new
> instruction?

Right, I want the kernel to offer some level of safety here because
everything you are describing sounds like a flag day conversion. Am I
misreading? Is there some other gate that prevents existing users of
of_pmem and papr_scm from having their expectations violated when
running on P8 / P9 hardware? Maybe there's tighter ecosystem control
that I'm just not familiar with, I'm only going off the fact that the
kernel has shipped a non-zero number of NVDIMM drivers that build with
ARCH=ppc64 for several cycles.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
