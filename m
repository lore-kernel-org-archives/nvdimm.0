Return-Path: <SRS0=TTaI=AW=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CEEC433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 11 Jul 2020 03:31:51 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36BCC2075D
	for <linux-nvdimm@archiver.kernel.org>; Sat, 11 Jul 2020 03:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36BCC2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 16C52111A3396;
	Fri, 10 Jul 2020 20:31:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.100; helo=mga07.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 506C8111A3391
	for <linux-nvdimm@lists.01.org>; Fri, 10 Jul 2020 20:31:48 -0700 (PDT)
IronPort-SDR: Akj+zWc81YvF/hQf/uP+Abz43S8hOhx5YpsxuSmWtNisz0bKEl7/Y/b5Xz5QWy7qQywBHEoCTI
 PN+xFOODpROw==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="213205545"
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800";
   d="scan'208";a="213205545"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 20:31:48 -0700
IronPort-SDR: R27/5kAH4jxB5nKGWxbKWAGF3DUoXqlbh9j5uNEDeZAP60+BAeYUJ23ptSwG5IhclO9CNjOiCJ
 Rxems7J6o5vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,338,1589266800";
   d="scan'208";a="316792120"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.147])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jul 2020 20:31:47 -0700
Date: Fri, 10 Jul 2020 20:31:47 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Wei Yongjun <weiyongjun1@huawei.com>
Subject: Re: [PATCH -next] device-dax: make dev_dax_kmem_probe() static
Message-ID: <20200711033147.GA3008823@iweiny-DESK2.sc.intel.com>
References: <20200707112340.9178-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200707112340.9178-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: BVZB6BLBTVKSFHSL2KMSVVEMBK34R7HA
X-Message-ID-Hash: BVZB6BLBTVKSFHSL2KMSVVEMBK34R7HA
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Hulk Robot <hulkci@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BVZB6BLBTVKSFHSL2KMSVVEMBK34R7HA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 07, 2020 at 07:23:40PM +0800, Wei Yongjun wrote:
> sparse report warning as follows:
> 
> drivers/dax/kmem.c:22:5: warning:
>  symbol 'dev_dax_kmem_probe' was not declared. Should it be static?
> 
> dev_dax_kmem_probe() is not used outside of kmem.c, so marks
> it static.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Seems ok,

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/dax/kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 275aa5f87399..87e271668170 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -19,7 +19,7 @@ static const char *kmem_name;
>  /* Set if any memory will remain added when the driver will be unloaded. */
>  static bool any_hotremove_failed;
>  
> -int dev_dax_kmem_probe(struct device *dev)
> +static int dev_dax_kmem_probe(struct device *dev)
>  {
>  	struct dev_dax *dev_dax = to_dev_dax(dev);
>  	struct resource *res = &dev_dax->region->res;
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
