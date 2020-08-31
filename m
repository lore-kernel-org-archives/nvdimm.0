Return-Path: <SRS0=Plg1=CJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78413C433E6
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 16:55:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3835A20866
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 16:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3835A20866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 062F212604A44;
	Mon, 31 Aug 2020 09:55:41 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BD0E412604A41
	for <linux-nvdimm@lists.01.org>; Mon, 31 Aug 2020 09:55:38 -0700 (PDT)
IronPort-SDR: V5sGLhK3B1LsD/AUIDwTRbicG7+ESrBO9eUoPxPZCKcGIFBpA89/oiNnf0hTuHSCkozkHyQZtN
 M5WZPr5ViZ7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="158026746"
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600";
   d="scan'208";a="158026746"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 09:55:37 -0700
IronPort-SDR: RdDWlhackG2fa1GfQ9/UIinriQGEYMNoRxCtVttRxYb5H62b+5nCoQ/kUM6NEryYxmErR85Zs6
 SiXW5991Q/GQ==
X-IronPort-AV: E=Sophos;i="5.76,376,1592895600";
   d="scan'208";a="476802257"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 09:55:37 -0700
Date: Mon, 31 Aug 2020 09:55:37 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Tian Tao <tiantao6@hisilicon.com>
Subject: Re: [PATCH] dax: Use kobj_to_dev() instead of container_of()
Message-ID: <20200831165536.GE1422350@iweiny-DESK2.sc.intel.com>
References: <1598837565-18095-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1598837565-18095-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: AMN6W42BL3DCJ5AMF4OOMHM5JJYSA2SQ
X-Message-ID-Hash: AMN6W42BL3DCJ5AMF4OOMHM5JJYSA2SQ
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linuxarm@huawei.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AMN6W42BL3DCJ5AMF4OOMHM5JJYSA2SQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Aug 31, 2020 at 09:32:45AM +0800, Tian Tao wrote:
> Use kobj_to_dev() instead of container_of()
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/dax/bus.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 092112b..9464b56 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -474,7 +474,7 @@ static DEVICE_ATTR_WO(delete);
>  static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
>  		int n)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct dax_region *dax_region = dev_get_drvdata(dev);
>  
>  	if (is_static(dax_region))
> @@ -1225,7 +1225,7 @@ static DEVICE_ATTR_RO(numa_node);
>  
>  static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct dev_dax *dev_dax = to_dev_dax(dev);
>  	struct dax_region *dax_region = dev_dax->region;
>  
> -- 
> 2.7.4
> _______________________________________________
> Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
> To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
