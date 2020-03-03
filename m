Return-Path: <SRS0=QvMI=4U=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECF4C3F2CD
	for <linux-nvdimm@archiver.kernel.org>; Tue,  3 Mar 2020 13:28:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E477620838
	for <linux-nvdimm@archiver.kernel.org>; Tue,  3 Mar 2020 13:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E477620838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 33AE210FC3614;
	Tue,  3 Mar 2020 05:29:46 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=jack@suse.cz; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C0E0510FC3603
	for <linux-nvdimm@lists.01.org>; Tue,  3 Mar 2020 05:29:44 -0800 (PST)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 55673AEC2;
	Tue,  3 Mar 2020 13:28:51 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 7A46D1E0E99; Tue,  3 Mar 2020 14:28:50 +0100 (CET)
Date: Tue, 3 Mar 2020 14:28:50 +0100
From: Jan Kara <jack@suse.cz>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 27/36] ndctl/test: Relax dax_pmem_compat requirement
Message-ID: <20200303132850.GA21048@quack2.suse.cz>
References: <158300760415.2141307.14060353322051900501.stgit@dwillia2-desk3.amr.corp.intel.com>
 <158300774836.2141307.13052648687237614794.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <158300774836.2141307.13052648687237614794.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: QZHA4PVMEEEPKG3MOXG6I33KPQ5IKSOO
X-Message-ID-Hash: QZHA4PVMEEEPKG3MOXG6I33KPQ5IKSOO
X-MailFrom: jack@suse.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QZHA4PVMEEEPKG3MOXG6I33KPQ5IKSOO/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat 29-02-20 12:22:28, Dan Williams wrote:
> While there are some tests that require the new "dax-bus" device model,
> none of the tests require compatibility mode. Drop the requirement so
> the tests work with DEV_DAX_PMEM_COMPAT=n kernels.
> 
> Link: http://lore.kernel.org/r/20200123154720.12097-1-jack@suse.cz
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The patch looks good to me. Thanks for fixing this! I just have to say that
the strstr(3) usage in this function looks rather unusual to me. Why not
just strcmp(3)?

								Honza

> ---
>  test/core.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/test/core.c b/test/core.c
> index 888f5d8c0e42..dff842a9f378 100644
> --- a/test/core.c
> +++ b/test/core.c
> @@ -180,6 +180,14 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
>  
>  retry:
>  		rc = kmod_module_new_from_name(*ctx, name, mod);
> +
> +		/*
> +		 * dax_pmem_compat is not required, missing is ok,
> +		 * present-but-production is not ok.
> +		 */
> +		if (rc && strstr(name, "dax_pmem_compat"))
> +			continue;
> +
>  		if (rc) {
>  			log_err(&log_ctx, "%s.ko: missing\n", name);
>  			break;
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
