Return-Path: <SRS0=AX0L=F2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9873FC433DB
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 11:12:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDE8C22516
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 11:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDE8C22516
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7E3DF100EBB7B;
	Tue, 22 Dec 2020 03:12:21 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=85.233.160.19; helo=smtp.hosts.co.uk; envelope-from=antlists@youngman.org.uk; receiver=<UNKNOWN> 
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B37D9100EC1E7
	for <linux-nvdimm@lists.01.org>; Tue, 22 Dec 2020 03:12:17 -0800 (PST)
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1krfaQ-000BhF-5h; Tue, 22 Dec 2020 11:12:14 +0000
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
To: Coly Li <colyli@suse.de>, axboe@kernel.dk, dan.j.williams@intel.com,
 vishal.l.verma@intel.com
References: <20201203171535.67715-1-colyli@suse.de>
 <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
 <c50e7c65-d7bf-e957-d8eb-efed6c24f089@suse.de>
From: antlists <antlists@youngman.org.uk>
Message-ID: <3233b821-4674-b45a-cad4-4943401eff3d@youngman.org.uk>
Date: Tue, 22 Dec 2020 11:12:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c50e7c65-d7bf-e957-d8eb-efed6c24f089@suse.de>
Content-Language: en-GB
Message-ID-Hash: C4QJSFCVTMXPIULAKBRAAJMJCV5MCD2Q
X-Message-ID-Hash: C4QJSFCVTMXPIULAKBRAAJMJCV5MCD2Q
X-MailFrom: antlists@youngman.org.uk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/C4QJSFCVTMXPIULAKBRAAJMJCV5MCD2Q/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On 20/12/2020 09:46, Coly Li wrote:
> Currently blocks/badblocks.c is used by md raid and nvdimm code, and the
> badblocks table is irrelevant to any of these two subsystems.

Good to know.
> 
> If there will be better code for similar or better functionality, it
> should be cool. For me, if the reporting bug is fixed, no difference in
> my view:-)
> 
Hopefully that will improve the badblocks handling in md. Sounds like 
that could in part be the problems we've been seeing.

If I integrate dm-integrity into md, badblocks should be mutually 
exclusive with it, but because dm-integrity is both a performance and 
disk-space hit, people might well not want to enable it.

Cheers,
Wol
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
