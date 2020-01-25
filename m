Return-Path: <SRS0=lvHn=3O=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D82C2D0CE
	for <linux-nvdimm@archiver.kernel.org>; Sat, 25 Jan 2020 01:59:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 434002071A
	for <linux-nvdimm@archiver.kernel.org>; Sat, 25 Jan 2020 01:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="g22fBtke"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 434002071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 259AD1007B1DA;
	Fri, 24 Jan 2020 18:02:41 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::344; helo=mail-ot1-x344.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4BFB41007B8FF
	for <linux-nvdimm@lists.01.org>; Fri, 24 Jan 2020 18:02:39 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id w21so3493028otj.7
        for <linux-nvdimm@lists.01.org>; Fri, 24 Jan 2020 17:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4LrlDTKaRDJtY4P0/xvZJTawL+rLRj4LAy3fIfUoPL0=;
        b=g22fBtkex1qTMLsrTpfEOm1O/p1k4lhEf9VpJWpUZ8bEtLXIE+Tl9DqwfMcRg6WIpp
         e34zocB+Cb7alkoOmoC0EUICgtMKKmDabo3LsY2zxGlV0dKcCIwGt6k/0qD7PSizGe/4
         2Vbc4yWJ6j7pMIOVMu2FYg/5bYZNdEYhvQMdgBVPdAWd/RE8bDblfEIjubpgYfZ4lkn9
         LP+U02mYWGyBOMhiqZ1ZI4mVLvy/CiAsRXKPW2ik6WnHYZiG22BXELHypDYxKuTtQnNw
         LZHICuiqm5HehSwzCBRjnQ1cKpdX1EytQ9LFS+otD4Ar9hKXWRMtb7KV4qXcOVbq7mst
         XLEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LrlDTKaRDJtY4P0/xvZJTawL+rLRj4LAy3fIfUoPL0=;
        b=rzmXlBCVrIKDF9yWttGi7etT62xNxCoPndKdm4O1P39u1mtM2yrOs/Oc1attHvJmDd
         jiPyw6BgEbjBaBCUSu1XnvNKSx9KzBscFQFUpkNmFb+gvVOOZLmDPSO8JGvPCL+Pr+N8
         nn6ySd7QaUy+iwsPS7JjE6J+5T3AEMeCAbYq5w8lzLvd9gnXt+ptj8Hl5fF9kJ51mVIm
         P+9AGr8HAV6JZuUgn+zpKZYry8AbdEJhZDcNNsA0G2PRAigu08MuwPtSpMl4wkm2oQXe
         fxUcsJpywTuWr8VCp+zMD+aGWgHsPCuotVsJJpWmJozE1jdDLwR8Cu1M0l3Dejj6qMk6
         /J0A==
X-Gm-Message-State: APjAAAWBniiIG99OiHA5y/Kv0rcE5lCfcwizo6rfLX+QmTwbKfA3kh1X
	mq0YvvtUKAU/4QOvVeBnard0U2OCC7iLQxWxj+3cmw==
X-Google-Smtp-Source: APXvYqx26ecJum0tMf56L1U8HAENvPXLPw8cR7sLuixRBt/HbgvBF42YdvYCW8KKNzju8hBrYtqw/gF2KrHZOR/cRWE=
X-Received: by 2002:a9d:6f11:: with SMTP id n17mr4906184otq.126.1579917560012;
 Fri, 24 Jan 2020 17:59:20 -0800 (PST)
MIME-Version: 1.0
References: <20200120140749.69549-1-aneesh.kumar@linux.ibm.com> <20200120140749.69549-4-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20200120140749.69549-4-aneesh.kumar@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jan 2020 17:59:09 -0800
Message-ID: <CAPcyv4gYW0-3T29i8YBzMxAW87HBnbsAhVsfr79ona1FpsfZAw@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] libnvdimm/namespace: Add arch dependent callback
 for namespace create time validation
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID-Hash: IMN7PLBWYBQSXYTWLH555Z53LSBTHRA5
X-Message-ID-Hash: IMN7PLBWYBQSXYTWLH555Z53LSBTHRA5
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IMN7PLBWYBQSXYTWLH555Z53LSBTHRA5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 20, 2020 at 6:08 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Namespace start address and size should be multiple of subsection size to avoid
> handling complex partial subsection addition and removal of memory. Even though
> subsection size is arch independent (2M), architectures do impose further
> restrictions w.r.t namespace size/start addr based on direct-mapping  page size.
>
> This patch adds an arch callback for supporting arch specific restrictions w.r.t
> namespace size. This is different from arch_namespace_map_size() in that this
> validates against SUBSECTION_SIZE. Ideally, kernel should use the same restrictions
> during namespace initialization too. But that prevents an existing unaligned
> namespace initialization to fail. The kernel now allows such namespace initialization
> so that an existing installation is not broken.

I think we only need memremap_compat_align() to default to the
subsection size with the option for Power to override it to 16MiB.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
