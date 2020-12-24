Return-Path: <SRS0=fnpI=F4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36F9C433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:27:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84E3C225AA
	for <linux-nvdimm@archiver.kernel.org>; Thu, 24 Dec 2020 18:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84E3C225AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0E179100EC1EB;
	Thu, 24 Dec 2020 10:27:08 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62c; helo=mail-ej1-x62c.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CA65C100EC1E6
	for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:27:04 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id d17so4175072ejy.9
        for <linux-nvdimm@lists.01.org>; Thu, 24 Dec 2020 10:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CvJf6LiVwAphOWqFm8rH3oQQ7G3MppReQprUE6fDi1A=;
        b=c2C/dfADEA1C4D6mtUhKHjrOlRT+y2lrpUT8HtvMbzRd53ijATFXypruar6Dsrlj5h
         2uRH9sGtVAEKIVoBsB34utTRGY8rZxMnfd43DcpCysDtj8sdSqStbpIWOkcKvC8yygGC
         PZPLxH8bmMk7hgtopssV2eVwN9S2hK4Uc9xjareao62wZGsIe8Aef/2Z17BdYRimnSjG
         Dye8vs0oIDvhDzlVRRLQCUUzUatErkrk1mGcPFOXcRQx8I1crrxtuO6ytWcdPWdqsezT
         qqbZVIu+qLgQtWx0Z9u1Kc0ACDTtR4banuln/XinBERq8deaQMMdeJ8bwqb2KaeOGgoG
         chWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvJf6LiVwAphOWqFm8rH3oQQ7G3MppReQprUE6fDi1A=;
        b=rBMIaYMfdfTvGIrFohtGcDWfodTJ6tQaM0kllobVe5Rb4wEVY3SGmRNWBw23iGsy/6
         fK9Xwrm0WOCPrjzeHCCdtS76FWHxsTkAV1nEfWkDwAMMMUjgrkBaeCW3NQY1mGeUFNbB
         S+q7jIvYorF+IRBFjf/lSQPKytgFdg3++igDztYxrQwGKJM5n1nOCo9lJ96VcAPhCrpB
         FfZMyGWxBjJbl5Q7cHVrQYhKLaX/bvJGef92EmK6oNXBqyyIfbutm+uO9vayXPOaFBrL
         AX2+ujqkT6zf13P+/zm7to4lgB5V/b3pmDT9nexZB0k0w8vD3uRE91Q1ew0yk5/Kqnmc
         7mSQ==
X-Gm-Message-State: AOAM532mq+HNVACuI/H6mI2h8fwRKL5Zs1BvSsShROreEHBQTzbomtOF
	oYYGI8V6vR6UECdrOvUrMSlDvNxsn8XTRhihpbLX1Q==
X-Google-Smtp-Source: ABdhPJyY4MAtd2QZ2rWByPyvmx75vHY+c9DcNHZFXiqKIdkMn14OGhFXvWuWSauXIVcP+O2fIELr0j6dBrS3uXDY1A0=
X-Received: by 2002:a17:906:4146:: with SMTP id l6mr29399960ejk.341.1608834423214;
 Thu, 24 Dec 2020 10:27:03 -0800 (PST)
MIME-Version: 1.0
References: <20201222042240.2983755-1-santosh@fossix.org>
In-Reply-To: <20201222042240.2983755-1-santosh@fossix.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Dec 2020 10:26:52 -0800
Message-ID: <CAPcyv4hsEB-LuecTvVXgC5CAW_XyxktoS4iC05ExFLhDZChO=g@mail.gmail.com>
Subject: Re: [0/7] PMEM device emulation without nfit depenency
To: Santosh Sivaraj <santosh@fossix.org>
Message-ID-Hash: BUOHBV4HSNK7GEJLEO5IEM7LWSZHF5HQ
X-Message-ID-Hash: BUOHBV4HSNK7GEJLEO5IEM7LWSZHF5HQ
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Linux NVDIMM <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, Harish Sriram <harish@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BUOHBV4HSNK7GEJLEO5IEM7LWSZHF5HQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 21, 2020 at 8:23 PM Santosh Sivaraj <santosh@fossix.org> wrote:
>
> The current test module cannot be used for testing platforms (make check)
> that do not have support for NFIT. In order to get the ndctl tests working,
> we need a module which can emulate NVDIMM devices without relying on
> ACPI/NFIT.
>
> The emulated PMEM device is made part of the PAPR family.
>
> Corresponding changes for ndctl is also required, to add attributes needed
> for the test, which will be sent as a reply to this patch.
>
> None of tests passed on PAPR before, now there are 16 test that pass. Error
> injection tests and SMART are not yet implemented.
>

Thanks Santosh, I'll circle back to this after the holiday break. I
assume it can go in for v5.11 post -rc1 since it has zero regression
risk.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
