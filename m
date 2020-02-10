Return-Path: <SRS0=nxzV=36=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAED0C352A3
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Feb 2020 11:28:08 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 61A9120838
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Feb 2020 11:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61A9120838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 493A41007B1F6;
	Mon, 10 Feb 2020 03:31:25 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=jack@suse.cz; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id AE8F810097DC6
	for <linux-nvdimm@lists.01.org>; Mon, 10 Feb 2020 03:31:23 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id A8F81B1A8;
	Mon, 10 Feb 2020 11:28:04 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id E7A521E0E2C; Mon, 10 Feb 2020 12:28:03 +0100 (CET)
Date: Mon, 10 Feb 2020 12:28:03 +0100
From: Jan Kara <jack@suse.cz>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] tools/testing/nvdimm: Fix compilation failure without
 CONFIG_DEV_DAX_PMEM_COMPAT
Message-ID: <20200210112803.GA16326@quack2.suse.cz>
References: <20200123154720.12097-1-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200123154720.12097-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: MCD6Q3QOZNN7N6RQ2LQ2ZPDTOZRUELNS
X-Message-ID-Hash: MCD6Q3QOZNN7N6RQ2LQ2ZPDTOZRUELNS
X-MailFrom: jack@suse.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/MCD6Q3QOZNN7N6RQ2LQ2ZPDTOZRUELNS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 23-01-20 16:47:20, Jan Kara wrote:
> When a kernel is configured without CONFIG_DEV_DAX_PMEM_COMPAT, the
> compilation of tools/testing/nvdimm fails with:
> 
>   Building modules, stage 2.
>   MODPOST 11 modules
> ERROR: "dax_pmem_compat_test" [tools/testing/nvdimm/test/nfit_test.ko] undefined!
> 
> Fix the problem by calling dax_pmem_compat_test() only if the kernel has
> the required functionality.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Ping?

								Honza

> ---
>  tools/testing/nvdimm/test/nfit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index bf6422a6af7f..a8ee5c4d41eb 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -3164,7 +3164,9 @@ static __init int nfit_test_init(void)
>  	mcsafe_test();
>  	dax_pmem_test();
>  	dax_pmem_core_test();
> +#ifdef CONFIG_DEV_DAX_PMEM_COMPAT
>  	dax_pmem_compat_test();
> +#endif
>  
>  	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
>  
> -- 
> 2.16.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
