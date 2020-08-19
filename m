Return-Path: <SRS0=7jdq=B5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F31C433E1
	for <linux-nvdimm@archiver.kernel.org>; Wed, 19 Aug 2020 13:34:53 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EADD120866
	for <linux-nvdimm@archiver.kernel.org>; Wed, 19 Aug 2020 13:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EADD120866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A243012F414B0;
	Wed, 19 Aug 2020 06:34:52 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.191; helo=huawei.com; envelope-from=thunder.leizhen@huawei.com; receiver=<UNKNOWN> 
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9FA1112F414AD
	for <linux-nvdimm@lists.01.org>; Wed, 19 Aug 2020 06:34:49 -0700 (PDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
	by Forcepoint Email with ESMTP id B2FF87F951F8EE11FFAA;
	Wed, 19 Aug 2020 21:34:44 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.253) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 21:34:39 +0800
Subject: Re: [PATCH v2 1/4] libnvdimm: Fix memory leaks in of_pmem.c
To: Markus Elfring <Markus.Elfring@web.de>, linux-nvdimm
	<linux-nvdimm@lists.01.org>
References: <20200819020503.3079-1-thunder.leizhen@huawei.com>
 <20200819020503.3079-2-thunder.leizhen@huawei.com>
 <5cc26ce3-963e-3ab6-6f97-706cea00c5f3@web.de>
From: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <57fac381-20e5-ce89-7b69-1f2c576e709e@huawei.com>
Date: Wed, 19 Aug 2020 21:34:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5cc26ce3-963e-3ab6-6f97-706cea00c5f3@web.de>
Content-Language: en-US
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Message-ID-Hash: ARR3JYS6PBE2LMTCQAKJI5DPNLRQWBFG
X-Message-ID-Hash: ARR3JYS6PBE2LMTCQAKJI5DPNLRQWBFG
X-MailFrom: thunder.leizhen@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel <linux-kernel@vger.kernel.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ARR3JYS6PBE2LMTCQAKJI5DPNLRQWBFG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 8/19/2020 8:28 PM, Markus Elfring wrote:
>> The memory priv->bus_desc.provider_name allocated by kstrdup() is not
>> freed correctly.
> 
> How do you think about to choose an imperative wording for
> a corresponding change description?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=18445bf405cb331117bc98427b1ba6f12418ad17#n151

OK, thanks. I think I known what "imperative wording" means now.
I will rewrite the descriptions.

> 
> Regards,
> Markus
> 
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
