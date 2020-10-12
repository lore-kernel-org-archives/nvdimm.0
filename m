Return-Path: <SRS0=VJky=DT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_40,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F77C43457
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 16:46:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 55BD820870
	for <linux-nvdimm@archiver.kernel.org>; Mon, 12 Oct 2020 16:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y1zprB7J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55BD820870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 14DC815B58846;
	Mon, 12 Oct 2020 09:46:02 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2001:8b0:10b:1236::1; helo=casper.infradead.org; envelope-from=rdunlap@infradead.org; receiver=<UNKNOWN> 
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4B6DC15B58841
	for <linux-nvdimm@lists.01.org>; Mon, 12 Oct 2020 09:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=h5j4wcpVtXZLGhNpJo9+h3r4FuiBGt0jGJAE34cafXY=; b=Y1zprB7JIZn1TSp93/8jvbop3Y
	lr3nQrOeisTRQp34205+WklIZoerz74CTIU8V5N3/5/aNs30MmrVglt7ha40qBBu+h5XBl6zqyUxP
	UHivng0mQmJFEivw5XXi+q2jbvXySVQYg9mLXsfud/P9so1HbRcCFYltmN2CIsOsEV/45SdQq1DPq
	/hwNZspPBW/rsjDLBsNDqnHqhBxXXG0CPB0b6Q7DJLPvKC3V4VS9csViwUJOg8R3bYqzrJjjeDU6S
	BQXfecuOpFq50xcc8E0egYCNM5M/Bxz+2GS/BjzWaxtsnTjcVYPAjz2lgniv7nPlCcXzpLkYmFebP
	9YpcNFiQ==;
Received: from [2601:1c0:6280:3f0::507c]
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kS0xP-000538-Rx; Mon, 12 Oct 2020 16:45:56 +0000
Subject: Re: [PATCH v2 01/22] mpool: add utility routines and ioctl
 definitions
To: Nabeel M Mohamed <nmeeramohide@micron.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-mm@kvack.org, linux-nvdimm@lists.01.org
References: <20201012162736.65241-1-nmeeramohide@micron.com>
 <20201012162736.65241-2-nmeeramohide@micron.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <954153c4-ee2f-2a2f-8643-8ff67d8cd649@infradead.org>
Date: Mon, 12 Oct 2020 09:45:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012162736.65241-2-nmeeramohide@micron.com>
Content-Language: en-US
Message-ID-Hash: E5I64FZUSZR4YK4GDQBUIEADFMKMVJXD
X-Message-ID-Hash: E5I64FZUSZR4YK4GDQBUIEADFMKMVJXD
X-MailFrom: rdunlap@infradead.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: smoyer@micron.com, gbecker@micron.com, plabat@micron.com, jgroves@micron.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/E5I64FZUSZR4YK4GDQBUIEADFMKMVJXD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/12/20 9:27 AM, Nabeel M Mohamed wrote:
> +#define MPIOC_MAGIC             ('2')

Hi,

That value should be documented in
Documentation/userspace-api/ioctl/ioctl-number.rst.

thanks.
-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
