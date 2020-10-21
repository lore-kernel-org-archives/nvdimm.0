Return-Path: <SRS0=d0Fg=D4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B8DC388F9
	for <linux-nvdimm@archiver.kernel.org>; Wed, 21 Oct 2020 17:42:57 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A5BC62225F
	for <linux-nvdimm@archiver.kernel.org>; Wed, 21 Oct 2020 17:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5BC62225F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0EAC615F16730;
	Wed, 21 Oct 2020 10:42:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.126; helo=mga18.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C628615F1672C
	for <linux-nvdimm@lists.01.org>; Wed, 21 Oct 2020 10:42:53 -0700 (PDT)
IronPort-SDR: S6pooko+D7DbMF/sb8Yeh9c9bnUQodgsLr3F/QZLE6YWKSnxU4ltrKuHEd0rXmFD/rQa6FPapW
 zybtbP6arAvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="155193989"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400";
   d="scan'208";a="155193989"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:42:52 -0700
IronPort-SDR: xdiPAnI/+Oi4CNdCJwsbauV94JMPds5kMYRZ12ocXHd9cfOid4zINMJ1d8K14zqvnGdfX9VSJl
 6QkTrQJ4JTJw==
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400";
   d="scan'208";a="533622261"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 10:42:53 -0700
Date: Wed, 21 Oct 2020 10:42:52 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH] Rework license identification
Message-ID: <20201021174252.GB165907@iweiny-DESK2.sc.intel.com>
References: <160321640031.3386448.4879860972349220888.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <160321640031.3386448.4879860972349220888.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: GQA7OTBACPKMGVDBTU2DJVG4Q43OVHO5
X-Message-ID-Hash: GQA7OTBACPKMGVDBTU2DJVG4Q43OVHO5
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GQA7OTBACPKMGVDBTU2DJVG4Q43OVHO5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 20, 2020 at 10:53:20AM -0700, Dan Williams wrote:
> Convert to the LICENSES/ directory format for COPYING from the Linux
> kernel, and switch all remaining files over to SPDX annotations.
> 
> Reported-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[snip]

> diff --git a/ndctl/lib/hpe1.h b/ndctl/lib/hpe1.h
> index 1afa54f127a6..acf82af7bb87 100644
> --- a/ndctl/lib/hpe1.h
> +++ b/ndctl/lib/hpe1.h
> @@ -1,16 +1,5 @@
> -/*
> - * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
> - * Copyright (c) 2014-2015, Intel Corporation.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU Lesser General Public License,
> - * version 2.1, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT ANY
> - * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> - * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> - * more details.
> - */
> +// Copyright (C) 2016 Hewlett Packard Enterprise Development LP
> +// SPDX-License-Identifier: LGPL-2.1

Why drop the Intel copyright here but not elsewhere?

>  #ifndef __NDCTL_HPE1_H__
>  #define __NDCTL_HPE1_H__
>  
> diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
> index 815f254308c6..00ef0a4d1d28 100644
> --- a/ndctl/lib/inject.c
> +++ b/ndctl/lib/inject.c
> @@ -1,15 +1,5 @@
> -/*
> - * Copyright (c) 2014-2017, Intel Corporation.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU Lesser General Public License,
> - * version 2.1, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT ANY
> - * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> - * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> - * more details.
> - */
> +// Copyright (c) 2014-2017, Intel Corporation. All rights reserved.
> +// SPDX-License-Identifier: LGPL-2.1

And I'm not sure why some of the copyrights are extended to 2020 while others
are not.  I would think they would all be?  But this is more of a curious
questions.

Ira
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
