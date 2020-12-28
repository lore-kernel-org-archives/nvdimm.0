Return-Path: <SRS0=loEu=GA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF7EC433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Dec 2020 17:18:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 811AB22B30
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Dec 2020 17:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 811AB22B30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 120D2100EBB6A;
	Mon, 28 Dec 2020 09:18:02 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.43; helo=mga05.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C1A2D100EBB67
	for <linux-nvdimm@lists.01.org>; Mon, 28 Dec 2020 09:17:59 -0800 (PST)
IronPort-SDR: kYlPLc2vpiw6a6WDgkIwY5dR3UX617FCW1pnZVBrM6EUsqwr8UiBUN2kk89uJeNUQo+WzxH2L4
 jK3KtywO/Qfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9848"; a="261153627"
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400";
   d="scan'208";a="261153627"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 09:17:59 -0800
IronPort-SDR: Rt9Q8FeGS/TGGaVi1S+G65ttUmRswq+WzyoUtrLa3uXgJDHKE4MmdA2H201aGUxDrf0/73bWfX
 UjGbRsKvyiug==
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400";
   d="scan'208";a="418877041"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 09:17:59 -0800
Date: Mon, 28 Dec 2020 09:17:58 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Jianpeng Ma <jianpeng.ma@intel.com>
Subject: Re: [PATCH] libnvdimm/pmem: remove unused header.
Message-ID: <20201228171758.GO1563847@iweiny-DESK2.sc.intel.com>
References: <20201225013546.300116-1-jianpeng.ma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201225013546.300116-1-jianpeng.ma@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: JOGWUR5IMIGZRFDKI7DCOYX3H6344HBL
X-Message-ID-Hash: JOGWUR5IMIGZRFDKI7DCOYX3H6344HBL
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, hch@lst.de
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/JOGWUR5IMIGZRFDKI7DCOYX3H6344HBL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 25, 2020 at 09:35:46AM +0800, Jianpeng Ma wrote:
> 'commit a8b456d01cd6 ("bdi: remove BDI_CAP_SYNCHRONOUS_IO")' forgot

This information should be part of a fixes tag.

Other than that looks ok.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> remove the related header file.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> ---
>  drivers/nvdimm/pmem.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 875076b0ea6c..f33bdae626ba 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -23,7 +23,6 @@
>  #include <linux/uio.h>
>  #include <linux/dax.h>
>  #include <linux/nd.h>
> -#include <linux/backing-dev.h>
>  #include <linux/mm.h>
>  #include <asm/cacheflush.h>
>  #include "pmem.h"
> -- 
> 2.29.2
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
