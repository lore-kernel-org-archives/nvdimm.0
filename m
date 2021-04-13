Return-Path: <SRS0=nxeM=JK=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09CF9C433ED
	for <linux-nvdimm@archiver.kernel.org>; Tue, 13 Apr 2021 12:55:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F9536109D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 13 Apr 2021 12:55:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F9536109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3536E100EB83A;
	Tue, 13 Apr 2021 05:55:08 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.35; helo=szxga07-in.huawei.com; envelope-from=shikemeng@huawei.com; receiver=<UNKNOWN> 
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C93F5100EB82F
	for <linux-nvdimm@lists.01.org>; Tue, 13 Apr 2021 05:55:04 -0700 (PDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FKQW106NHzB09P;
	Tue, 13 Apr 2021 20:52:45 +0800 (CST)
Received: from [10.174.177.246] (10.174.177.246) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 13 Apr 2021 20:54:55 +0800
Subject: Re:Re: [PATCH] x86: Accelerate copy_page with non-temporal in X86
To: Borislav Petkov <bp@alien8.de>
References: <3f28adee-8214-fa8e-b368-eaf8b193469e@huawei.com>
 <20210413110137.GD16519@zn.tnic>
From: Kemeng Shi <shikemeng@huawei.com>
Message-ID: <bfa4fd38-0874-63b3-991a-1102af9f47a6@huawei.com>
Date: Tue, 13 Apr 2021 20:54:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20210413110137.GD16519@zn.tnic>
X-Originating-IP: [10.174.177.246]
X-CFilter-Loop: Reflected
Message-ID-Hash: 4PPTK2V5SGN4GNXUVRVKDQWRQ7ZC7XAG
X-Message-ID-Hash: 4PPTK2V5SGN4GNXUVRVKDQWRQ7ZC7XAG
X-MailFrom: shikemeng@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4PPTK2V5SGN4GNXUVRVKDQWRQ7ZC7XAG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



on 2021/4/13 19:01, Borislav Petkov wrote:
> + linux-nvdimm
> 
> Original mail at https://lkml.kernel.org/r/3f28adee-8214-fa8e-b368-eaf8b193469e@huawei.com
> 
> On Tue, Apr 13, 2021 at 02:25:58PM +0800, Kemeng Shi wrote:
>> I'm using AEP with dax_kmem drvier, and AEP is export as a NUMA node in
> 
> What is AEP?
> 
AEP is a type of persistent memory produced by Intel. It's slower than
normal memory but is persistent.
>> my system. I will move cold pages from DRAM node to AEP node with
>> move_pages system call. With old "rep movsq', it costs 2030ms to move
>> 1 GB pages. With "movnti", it only cost about 890ms to move 1GB pages.
> 
> So there's __copy_user_nocache() which does NT stores.
> 
>> -	ALTERNATIVE "jmp copy_page_regs", "", X86_FEATURE_REP_GOOD
>> +	ALTERNATIVE_2 "jmp copy_page_regs", "", X86_FEATURE_REP_GOOD, \
>> +                      "jmp copy_page_nt", X86_FEATURE_XMM2
> 
> This makes every machine which has sse2 do NT stores now. Which means
> *every* machine practically.
> 
Yes. And NT stores should be better for copy_page especially copying a lot
of pages as only partial memory of copied page will be access recently.
> The folks on linux-nvdimm@ should be able to give you a better idea what
> to do.
> 
> HTH.
> 
Thanks for response and help.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
