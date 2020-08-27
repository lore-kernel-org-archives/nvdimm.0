Return-Path: <SRS0=YNfM=CF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B69C433DF
	for <linux-nvdimm@archiver.kernel.org>; Thu, 27 Aug 2020 06:41:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1D4E22B40
	for <linux-nvdimm@archiver.kernel.org>; Thu, 27 Aug 2020 06:41:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1D4E22B40
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B248F12537766;
	Wed, 26 Aug 2020 23:41:36 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E6A011252CCB6
	for <linux-nvdimm@lists.01.org>; Wed, 26 Aug 2020 23:41:34 -0700 (PDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
	by Forcepoint Email with ESMTP id 66EA699BB0E985A9E51E;
	Thu, 27 Aug 2020 14:41:32 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.253) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 14:41:28 +0800
Subject: Re: [PATCH 3/4] libnvdimm: eliminate two unnecessary zero
 initializations in badrange.c
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, linux-nvdimm
	<linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20200820143027.3241-1-thunder.leizhen@huawei.com>
 <20200820143027.3241-4-thunder.leizhen@huawei.com>
From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <962dd111-ceb3-36de-86d9-817e0e0a6e45@huawei.com>
Date: Thu, 27 Aug 2020 14:41:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200820143027.3241-4-thunder.leizhen@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: K7C52ADFTI55LVOTTMKLTW5JWRFZKW7O
X-Message-ID-Hash: K7C52ADFTI55LVOTTMKLTW5JWRFZKW7O
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/K7C52ADFTI55LVOTTMKLTW5JWRFZKW7O/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I will drop this patch, because badrange_add() is unlikely to be called.
There's no need to care about trivial performance improvements.

On 2020/8/20 22:30, Zhen Lei wrote:
> Currently, the "struct badrange_entry" has three members: start, length,
> list. In append_badrange_entry(), "start" and "length" will be assigned
> later, and "list" does not need to be initialized before calling
> list_add_tail(). That means, the kzalloc() in badrange_add() or
> alloc_and_append_badrange_entry() can be replaced with kmalloc(), because
> the zero initialization is not required.
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/nvdimm/badrange.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> index 7f78b659057902d..13145001c52ff39 100644
> --- a/drivers/nvdimm/badrange.c
> +++ b/drivers/nvdimm/badrange.c
> @@ -37,7 +37,7 @@ static int alloc_and_append_badrange_entry(struct badrange *badrange,
>  {
>  	struct badrange_entry *bre;
>  
> -	bre = kzalloc(sizeof(*bre), flags);
> +	bre = kmalloc(sizeof(*bre), flags);
>  	if (!bre)
>  		return -ENOMEM;
>  
> @@ -49,7 +49,7 @@ int badrange_add(struct badrange *badrange, u64 addr, u64 length)
>  {
>  	struct badrange_entry *bre, *bre_new;
>  
> -	bre_new = kzalloc(sizeof(*bre_new), GFP_KERNEL);
> +	bre_new = kmalloc(sizeof(*bre_new), GFP_KERNEL);
>  
>  	spin_lock(&badrange->lock);
>  
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
