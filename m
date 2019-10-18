Return-Path: <SRS0=ufxj=YL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58605CA9EA9
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 18:46:50 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 30F0A20640
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 18:46:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="L8+QOB2S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30F0A20640
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1625410FCB387;
	Fri, 18 Oct 2019 11:48:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::242; helo=mail-oi1-x242.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5DAF410FCB383
	for <linux-nvdimm@lists.01.org>; Fri, 18 Oct 2019 11:48:54 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id t84so6030283oih.10
        for <linux-nvdimm@lists.01.org>; Fri, 18 Oct 2019 11:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F25glRSiJnbQpwu1pg0+4Rgtg/MeBVVy7HWWqEzZCDg=;
        b=L8+QOB2SmBtG9dybLDm2kzf1JCFA4YKz6KaeCUoJpV7zQP3e+RPSQY6tiAyGR0Rkav
         NhZeNdmHfJ/9A+ToqeTGSf7JI8HSMjr+ri572K/3kyqy6737AkQLUkXnA+9VcWb1bcen
         jC2mGyCA+mDQ8fsfT7+DagDp0CEaIljWWQKivhAAvaC5tf0cm0B74JEg8MmOrEYAahio
         cn2mytbElLGVT9+9wLSMt8sutnVCP+YC4QwR1mCJ6yo+8BPwMCOSmiDbevp3AwmECSDD
         E/TiGb494Fy//xoujz+aAZTfd1Rx5iF4GYKoCwnEWeo0Lk8mjtBCDNiGZZYU2ejEprqG
         +55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F25glRSiJnbQpwu1pg0+4Rgtg/MeBVVy7HWWqEzZCDg=;
        b=sOaljyzLdVQwAVYmJkZFgIuGUWRKj/swQhRMwraHF1j9IuhLo9hB7SFWiBRxpCODQT
         IrmVbnJSY9EwlgnQnE5zw+wdTgs0y4qzKIhvI4+T3IRZTm+YYUZ6UXejClbbncc+I5z7
         Z05GRdOEHW6N4Q/TOouZGmlBeMnYCjTFb0wsV6bLL1lWaMP2XGhZsMqSRV61mURjq1AB
         KYOYan5uX50DO73fZRB76xRE4oLem5cCPJmKscolQGnvh5hBNpnuhWYjHie7uxr/gYgG
         vZVhHnDI3wYxZx5Don2H5Dz5V4kiESTEaimo2kDFp+c+oiQO2FC7naJrVKdh+5lURXe2
         qG/g==
X-Gm-Message-State: APjAAAUvCCxwmtBdjYcvNXPSKJ8BHIwZeVbU0JnkIVDVTku+yQi6HsvX
	FHKHDIdafGuzQl/6VA9l4nYIrXdegQ1x2B66l6y8/w==
X-Google-Smtp-Source: APXvYqwWxa20bnozWS4K/7lUCbabsinWXTVqlPUYQFvalXN5yUxdoSleZSM1wTBI/3Z2sZT5/kXvWZZKqhbHbzwxGAQ=
X-Received: by 2002:a05:6808:7cd:: with SMTP id f13mr8688502oij.70.1571424407210;
 Fri, 18 Oct 2019 11:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191002234925.9190-1-vishal.l.verma@intel.com> <20191002234925.9190-4-vishal.l.verma@intel.com>
In-Reply-To: <20191002234925.9190-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Oct 2019 11:46:36 -0700
Message-ID: <CAPcyv4gbnY1kB32zM9SaSMyCwA257TcpNKvq-aZeHR=ORAdpYg@mail.gmail.com>
Subject: Re: [ndctl PATCH 03/10] daxctl/device.c: fix json output omission for reconfigure-device
To: Vishal Verma <vishal.l.verma@intel.com>
Message-ID-Hash: ZVOQZHBYP35BKBIAYD57MSKEY6W2YFUW
X-Message-ID-Hash: ZVOQZHBYP35BKBIAYD57MSKEY6W2YFUW
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ben Olson <ben.olson@intel.com>, Michal Biesek <michal.biesek@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZVOQZHBYP35BKBIAYD57MSKEY6W2YFUW/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 2, 2019 at 4:49 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The reconfig_mode_{devdax,system_ram}() function can have a positive
> return status from memory online/offline operations, indicating skipped
> memory blocks. Don't omit printing the device listing json in these
> cases; the reconfiguration has succeeded, and its results should be
> printed.
>
> Link: https://github.com/pmem/ndctl/issues/115
> Reported-by: Michal Biesek <michal.biesek@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
