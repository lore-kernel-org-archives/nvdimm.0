Return-Path: <SRS0=dDVn=YV=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6135BCA9EC0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Oct 2019 21:21:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 34A2421479
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Oct 2019 21:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34A2421479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2E019100EA63C;
	Mon, 28 Oct 2019 14:22:34 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.115; helo=mga14.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 98A9F100EA63A
	for <linux-nvdimm@lists.01.org>; Mon, 28 Oct 2019 14:22:31 -0700 (PDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 14:21:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400";
   d="scan'208";a="210961210"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga001.fm.intel.com with ESMTP; 28 Oct 2019 14:21:42 -0700
Date: Mon, 28 Oct 2019 14:21:42 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [RFC PATCH 1/4] libnvdimm/namespace: Make namespace size
 validation arch dependent
Message-ID: <20191028212142.GB9826@iweiny-DESK2.sc.intel.com>
References: <20191028094825.21448-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191028094825.21448-1-aneesh.kumar@linux.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: NIP5CKM4DS3FOOZUYW5UZKH56PZXNIGV
X-Message-ID-Hash: NIP5CKM4DS3FOOZUYW5UZKH56PZXNIGV
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: mpe@ellerman.id.au, linux-nvdimm@lists.01.org, linuxppc-dev@lists.ozlabs.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NIP5CKM4DS3FOOZUYW5UZKH56PZXNIGV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> diff --git a/arch/powerpc/lib/pmem.c b/arch/powerpc/lib/pmem.c
> index 377712e85605..2e661a08dae5 100644
> --- a/arch/powerpc/lib/pmem.c
> +++ b/arch/powerpc/lib/pmem.c
> @@ -17,14 +17,31 @@ void arch_wb_cache_pmem(void *addr, size_t size)
>  	unsigned long start = (unsigned long) addr;
>  	flush_dcache_range(start, start + size);
>  }
> -EXPORT_SYMBOL(arch_wb_cache_pmem);
> +EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);

Unrelated change?

Ira
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
