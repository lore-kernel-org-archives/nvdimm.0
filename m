Return-Path: <SRS0=wSbi=E2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0860C63798
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Nov 2020 09:27:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B822222BA
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Nov 2020 09:27:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B822222BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D80F0100EBBBA;
	Fri, 20 Nov 2020 01:27:35 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=szxga05-in.huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 929C0100EBBB1
	for <linux-nvdimm@lists.01.org>; Fri, 20 Nov 2020 01:27:32 -0800 (PST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcrmB6BLXzLrMn;
	Fri, 20 Nov 2020 17:27:06 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.144) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 20 Nov 2020
 17:27:26 +0800
Subject: Re: [PATCH 1/1] device-dax: delete a redundancy check in
 dev_dax_validate_align()
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm
	<linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20201120092057.2144-1-thunder.leizhen@huawei.com>
From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <7ccddd02-e2e6-ec48-43b8-10700285e61c@huawei.com>
Date: Fri, 20 Nov 2020 17:27:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20201120092057.2144-1-thunder.leizhen@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.176.144]
X-CFilter-Loop: Reflected
Message-ID-Hash: RLHIYC7AY5RKINHGYIR7XKAEAOA45PV7
X-Message-ID-Hash: RLHIYC7AY5RKINHGYIR7XKAEAOA45PV7
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RLHIYC7AY5RKINHGYIR7XKAEAOA45PV7/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2020/11/20 17:20, Zhen Lei wrote:
> After we have done the alignment check for the length of each range, the
> alignment check for dev_dax_size(dev_dax) is no longer needed, because it
> get the sum of the length of each range.

For example:
x/M + y/M = (x + y)/M
If x/M is a integer and y/M is also a integer, then (x + y)/M must be a integer.

> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/dax/bus.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 1efae11d947a..35f9238c0139 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1109,16 +1109,9 @@ static ssize_t align_show(struct device *dev,
>  
>  static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
>  {
> -	resource_size_t dev_size = dev_dax_size(dev_dax);
>  	struct device *dev = &dev_dax->dev;
>  	int i;
>  
> -	if (dev_size > 0 && !alloc_is_aligned(dev_dax, dev_size)) {
> -		dev_dbg(dev, "%s: align %u invalid for size %pa\n",
> -			__func__, dev_dax->align, &dev_size);
> -		return -EINVAL;
> -	}
> -
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		size_t len = range_len(&dev_dax->ranges[i].range);
>  
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
