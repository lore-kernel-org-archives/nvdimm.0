Return-Path: <SRS0=IQ1B=E5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58FDC5519F
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 00:47:37 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4A9BD2076E
	for <linux-nvdimm@archiver.kernel.org>; Mon, 23 Nov 2020 00:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A9BD2076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D76B3100ED4A8;
	Sun, 22 Nov 2020 16:47:36 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=45.249.212.190; helo=szxga04-in.huawei.com; envelope-from=liuzhiqiang26@huawei.com; receiver=<UNKNOWN> 
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8F805100ED487
	for <linux-nvdimm@lists.01.org>; Sun, 22 Nov 2020 16:47:34 -0800 (PST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CfT4q25nrzkdLB;
	Mon, 23 Nov 2020 08:47:07 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.238) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 23 Nov 2020
 08:47:21 +0800
Subject: Re: [ndctl PATCH 0/8] fix serverl issues reported by Coverity
To: Jeff Moyer <jmoyer@redhat.com>
References: <bed3b3b3-1f30-6751-c0bf-15ecf70192f9@huawei.com>
 <x49mtzcm0yb.fsf@segfault.boston.devel.redhat.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <44ff2574-48b7-fad8-e892-29ae8bc35e3b@huawei.com>
Date: Mon, 23 Nov 2020 08:47:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <x49mtzcm0yb.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.176.238]
X-CFilter-Loop: Reflected
Message-ID-Hash: 3FMYHTX2DDLS64CMPAHYEWMPY6PI7OWS
X-Message-ID-Hash: 3FMYHTX2DDLS64CMPAHYEWMPY6PI7OWS
X-MailFrom: liuzhiqiang26@huawei.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linfeilong <linfeilong@huawei.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/3FMYHTX2DDLS64CMPAHYEWMPY6PI7OWS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Thanks for your reply.
I will add one empty line in 1/8 patch in v2.

Regards
Zhiqiang Liu

On 2020/11/21 0:45, Jeff Moyer wrote:
> Zhiqiang Liu <liuzhiqiang26@huawei.com> writes:
> 
>> Recently, we use Coverity to analysis the ndctl package.
>> Several issues should be resolved to make Coverity happy.
>>
>> lihaotian9 (8):
>>   namespace: check whether pfn|dax|btt is NULL in setup_namespace
>>   lib/libndctl: fix memory leakage problem in add_bus
>>   libdaxctl: fix memory leakage in add_dax_region()
>>   dimm: fix potential fd leakage in dimm_action()
>>   util/help: check whether strdup returns NULL in exec_man_konqueror
>>   lib/inject: check whether cmd is created successfully
>>   libndctl: check whether ndctl_btt_get_namespace returns NULL in
>>     callers
>>   namespace: check whether seed is NULL in validate_namespace_options
>>
>>  daxctl/lib/libdaxctl.c |  3 +++
>>  ndctl/dimm.c           | 12 +++++++-----
>>  ndctl/lib/inject.c     |  8 ++++++++
>>  ndctl/lib/libndctl.c   |  1 +
>>  ndctl/namespace.c      | 23 ++++++++++++++++++-----
>>  test/libndctl.c        | 16 +++++++++++-----
>>  test/parent-uuid.c     |  2 +-
>>  util/help.c            |  8 +++++++-
>>  util/json.c            |  3 +++
>>  9 files changed, 59 insertions(+), 17 deletions(-)
> 
> Except for the minor nit I pointed out, for the  series:
> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> 
> .
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
