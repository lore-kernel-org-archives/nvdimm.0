Return-Path: <SRS0=Plg1=CJ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EFFFC433E2
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 19:20:56 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0ACF32100A
	for <linux-nvdimm@archiver.kernel.org>; Mon, 31 Aug 2020 19:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+M2tjvU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0ACF32100A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EF63912604A76;
	Mon, 31 Aug 2020 12:20:55 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=akpm@linux-foundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C26EA12604A5F
	for <linux-nvdimm@lists.01.org>; Mon, 31 Aug 2020 12:20:53 -0700 (PDT)
Received: from X1 (unknown [65.49.58.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 9D99820FC3;
	Mon, 31 Aug 2020 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598901653;
	bh=gZtRElBlIkTkKjny9lAT11wYTcgum1ipgdXOa4pL5qs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p+M2tjvUfpO4dqGrGR52PplNvObL9ffg8gJg7MwjRXELO08GhxSMd/4ZUX8kYu537
	 sFR/OUH3w/KoqAWwoXV6UJUToA/rmoiGdfPVSX+Kiw6PHdIdBd1OqfdeyFV+NfmgFs
	 OcsDSbXnXGcKzKpbxk+MZFgOCSABTpoUdIRCdv9Y=
Date: Mon, 31 Aug 2020 12:20:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [PATCH v4 1/2] memremap: rename MEMORY_DEVICE_DEVDAX to
 MEMORY_DEVICE_GENERIC
Message-Id: <20200831122051.95d3e558477024819672f4f9@linux-foundation.org>
In-Reply-To: <20200811094447.31208-2-roger.pau@citrix.com>
References: <20200811094447.31208-1-roger.pau@citrix.com>
	<20200811094447.31208-2-roger.pau@citrix.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Message-ID-Hash: TVVS7PWNZGZCBGX3S7UXS2IAPOLRQ5OA
X-Message-ID-Hash: TVVS7PWNZGZCBGX3S7UXS2IAPOLRQ5OA
X-MailFrom: akpm@linux-foundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Logan Gunthorpe <logang@deltatee.com>, linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TVVS7PWNZGZCBGX3S7UXS2IAPOLRQ5OA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 11 Aug 2020 11:44:46 +0200 Roger Pau Monne <roger.pau@citrix.com> wrote:

> This is in preparation for the logic behind MEMORY_DEVICE_DEVDAX also
> being used by non DAX devices.

Acked-by: Andrew Morton <akpm@linux-foundation.org>.

Please add it to the Xen tree when appropriate.

(I'm not sure what David means by "separate type", but we can do that
later if desired.  Dan is taking a taking a bit of downtime).
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
