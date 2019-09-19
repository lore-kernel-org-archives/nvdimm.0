Return-Path: <SRS0=HdMq=XO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903EAC3A5A6
	for <linux-nvdimm@archiver.kernel.org>; Thu, 19 Sep 2019 19:25:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3A39C20717
	for <linux-nvdimm@archiver.kernel.org>; Thu, 19 Sep 2019 19:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPz9yzKZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A39C20717
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4EE3521A07094;
	Thu, 19 Sep 2019 12:24:08 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=198.145.29.99; helo=mail.kernel.org;
 envelope-from=akpm@linux-foundation.org; receiver=linux-nvdimm@lists.01.org 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 02138202EBECD
 for <linux-nvdimm@lists.01.org>; Thu, 19 Sep 2019 12:24:06 -0700 (PDT)
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 357292053B;
 Thu, 19 Sep 2019 19:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1568921102;
 bh=g5OyAi72ILWvzD1XQjQDgV3T9SUTHQN1FC5bx9PVQPQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=gPz9yzKZN9S7vVLFWn/fgNm+R6fyoDTwUXqe0Ew+swSg3IdQ75UOcxOkP/iwnv9Ou
 wYQfTvmC45Z/CCDFxCUj7FMW4Ijel8VgYcS35SP8z6IPDpvoSztKegY20bda937HlV
 nMBvRbvEJnn4FAyxXnyAQyMRcRtA34uSpn+YVaVM=
Date: Thu, 19 Sep 2019 12:25:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v6] mm/pgmap: Use correct alignment when looking at
 first pfn from a region
Message-Id: <20190919122501.df660f0d23806a3f46d11b61@linux-foundation.org>
In-Reply-To: <20190917153129.12905-1-aneesh.kumar@linux.ibm.com>
References: <20190917153129.12905-1-aneesh.kumar@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

On Tue, 17 Sep 2019 21:01:29 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:

> vmem_altmap_offset() adjust the section aligned base_pfn offset.
> So we need to make sure we account for the same when computing base_pfn.
> 
> ie, for altmap_valid case, our pfn_first should be:
> 
> pfn_first = altmap->base_pfn + vmem_altmap_offset(altmap);

What are the user-visible runtime effects of this change?


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
