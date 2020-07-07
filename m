Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB87CC433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 19:06:24 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCBFA206E9
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 19:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCBFA206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A483F110B969A;
	Tue,  7 Jul 2020 12:06:24 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.120; helo=mga04.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8E9511108EF2F
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 12:06:21 -0700 (PDT)
IronPort-SDR: V98ZUEXEJOA7UKk/tHM14gljqFvZ6mjTgeQOsgGgt54K39DiicrXgqoFtTz4Y+U71sI6HzFqGf
 a9sjq1hLLOIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145185177"
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800";
   d="scan'208";a="145185177"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 12:06:21 -0700
IronPort-SDR: 6n12UZj2sUorGy6KJ0TJEaat6Sa15U6D21/RtGPUMQ2ca32c/0zdMdDmbVgU1CMieUz5sQLVLZ
 MzJbHJDkrlHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,324,1589266800";
   d="scan'208";a="457219017"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by orsmga005.jf.intel.com with ESMTP; 07 Jul 2020 12:06:20 -0700
Date: Tue, 7 Jul 2020 12:06:20 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Harish <harish@linux.ibm.com>
Subject: Re: [ndctl PATCH] infoblock: Make output mutually exclusive
Message-ID: <20200707190620.GB961523@iweiny-DESK2.sc.intel.com>
References: <20200707164635.31217-1-harish@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200707164635.31217-1-harish@linux.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: UEE6G5NQZ6K3JGCZGOIKGTXWGUBCQ6Y6
X-Message-ID-Hash: UEE6G5NQZ6K3JGCZGOIKGTXWGUBCQ6Y6
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UEE6G5NQZ6K3JGCZGOIKGTXWGUBCQ6Y6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 07, 2020 at 10:16:35PM +0530, Harish wrote:
> Patch fixes checking output filter option (-o <file> or -c) of
> write-infoblock command to be mutually exclusive.
> 
> Signed-off-by: Harish <harish@linux.ibm.com>

Looks reasonable to me.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  ndctl/namespace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 0550580..d3ade25 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -440,7 +440,7 @@ static const char *parse_namespace_options(int argc, const char **argv,
>  		rc = -EINVAL;
>  	}
>  
> -	if (action == ACTION_WRITE_INFOBLOCK && (param.outfile || param.std_out)
> +	if (action == ACTION_WRITE_INFOBLOCK && (param.outfile && param.std_out)
>  			&& argc) {
>  		error("specify only one of a namespace filter, --output, or --stdout\n");
>  		rc = -EINVAL;
> -- 
> 2.26.2
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
