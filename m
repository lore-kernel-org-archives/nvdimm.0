Return-Path: <SRS0=VJky=DT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_40,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E7FC433E7
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 16:48:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A6EA52087D
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 16:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r0J6Sx/y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6EA52087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 77C201568AEDE;
	Mon, 12 Oct 2020 09:48:35 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=rdunlap@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D4E2515683B20
	for <linux-nvdimm@lists.01.org>; Mon, 12 Oct 2020 09:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=c0qiq02WC8RL85uMcCI6g0IMZwRK/aQydvv8iai/B5g=; b=r0J6Sx/ynRaXiPD0rYgQZ/hVCO
	GsnX4CJ0amAf2sl19r1hkWbhzOC3Z7pF30zh/Wd23g92NllTpznPd51aqxABPJkK/V38O2aiW2/xK
	SpYuWOGWWMBoDtSSETNdRBCxov5raZFBJ6C9bg80JwlMQHFTmPGImdhxSet8v11X2Q3LFvccMih91
	jUY+UIDyZ3qM2au5/XCe3X4PvtopButc40ce9Ipfuv821LDZ3D+Y4azfFie0TyCXDIdk9tSFbg1rL
	zoLUkkWHgRvcW377XhlrGhYnxiXMxvTpuMe6aONVwutJ0KeRYQmStI0EigcAQ9KJ15qzBDT/xPSKm
	iTxlqv7w==;
Received: from [2601:1c0:6280:3f0::507c]
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kS0zt-0005Ce-38; Mon, 12 Oct 2020 16:48:30 +0000
Subject: Re: [PATCH v2 01/22] mpool: add utility routines and ioctl
 definitions
From: Randy Dunlap <rdunlap@infradead.org>
To: Nabeel M Mohamed <nmeeramohide@micron.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-mm@kvack.org, linux-nvdimm@lists.01.org
References: <20201012162736.65241-1-nmeeramohide@micron.com>
 <20201012162736.65241-2-nmeeramohide@micron.com>
 <954153c4-ee2f-2a2f-8643-8ff67d8cd649@infradead.org>
Message-ID: <bcc66e64-a19a-cb40-34cd-e71fa983b861@infradead.org>
Date: Mon, 12 Oct 2020 09:48:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <954153c4-ee2f-2a2f-8643-8ff67d8cd649@infradead.org>
Content-Language: en-US
Message-ID-Hash: OTCU7NUKY7OIUZVYXWB7CWGUHDFWBKXO
X-Message-ID-Hash: OTCU7NUKY7OIUZVYXWB7CWGUHDFWBKXO
X-MailFrom: rdunlap@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: smoyer@micron.com, gbecker@micron.com, plabat@micron.com, jgroves@micron.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OTCU7NUKY7OIUZVYXWB7CWGUHDFWBKXO/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/12/20 9:45 AM, Randy Dunlap wrote:
> On 10/12/20 9:27 AM, Nabeel M Mohamed wrote:
>> +#define MPIOC_MAGIC             ('2')
> 
> Hi,
> 
> That value should be documented in
> Documentation/userspace-api/ioctl/ioctl-number.rst.


Sorry, I see it now.

thanks.

-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
