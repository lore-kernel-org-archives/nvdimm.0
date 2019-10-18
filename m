Return-Path: <SRS0=ufxj=YL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF0ACA9EA9
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 20:55:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE70E2064B
	for <linux-nvdimm@archiver.kernel.org>; Fri, 18 Oct 2019 20:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE70E2064B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2D49D10FCB928;
	Fri, 18 Oct 2019 13:58:04 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.136; helo=mga12.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 01C8310FCB923
	for <linux-nvdimm@lists.01.org>; Fri, 18 Oct 2019 13:58:01 -0700 (PDT)
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Oct 2019 13:55:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,313,1566889200";
   d="scan'208";a="202812938"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Oct 2019 13:55:56 -0700
Date: Fri, 18 Oct 2019 13:55:56 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl patch 1/4] util/abspath: cleanup prefix_filename
Message-ID: <20191018205555.GB12760@iweiny-DESK2.sc.intel.com>
References: <20191018202302.8122-1-jmoyer@redhat.com>
 <20191018202302.8122-2-jmoyer@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191018202302.8122-2-jmoyer@redhat.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: C3J7JAHWRHLOZKY3QIQ6V6R75YL2MXBL
X-Message-ID-Hash: C3J7JAHWRHLOZKY3QIQ6V6R75YL2MXBL
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/C3J7JAHWRHLOZKY3QIQ6V6R75YL2MXBL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 18, 2019 at 04:22:59PM -0400, Jeff Moyer wrote:
> Static checkers complain about the unused assignment to pfx_len.
> The code can obviously be simplified.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  util/abspath.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/util/abspath.c b/util/abspath.c
> index 09bbd27..e44236f 100644
> --- a/util/abspath.c
> +++ b/util/abspath.c
> @@ -9,11 +9,7 @@ char *prefix_filename(const char *pfx, const char *arg)
>  	struct strbuf path = STRBUF_INIT;
>  	size_t pfx_len = pfx ? strlen(pfx) : 0;
>  
> -	if (!pfx_len)
> -		;
> -	else if (is_absolute_path(arg))
> -		pfx_len = 0;
> -	else
> +	if (pfx_len && !is_absolute_path(arg))
>  		strbuf_add(&path, pfx, pfx_len);
>  
>  	strbuf_addstr(&path, arg);
> -- 
> 2.19.1
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
