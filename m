Return-Path: <SRS0=0Q+M=IU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F26C433C1
	for <linux-nvdimm@archiver.kernel.org>; Mon, 22 Mar 2021 20:20:34 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8A50F61990
	for <linux-nvdimm@archiver.kernel.org>; Mon, 22 Mar 2021 20:20:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A50F61990
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2F190100EB82E;
	Mon, 22 Mar 2021 13:20:33 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id AD530100EBB80
	for <linux-nvdimm@lists.01.org>; Mon, 22 Mar 2021 13:20:30 -0700 (PDT)
IronPort-SDR: mjRvZCSpXcFx2A6r+TYnRt0ykA/z3/Aw9X6dLqCYfOHPAbvK5xXfPgDJBzxpK9EuRvBbkH6QUL
 VIZ9ggxXOYtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190436869"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400";
   d="scan'208";a="190436869"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:20:29 -0700
IronPort-SDR: 6C5Nj2ZylD2XYwjKPnqLs+KXDFNekRQ8zw3ZrFeke9h5NrEQaKMX3hCkNwjXiyd7VrIOp9IDz4
 ERhY2Shm5WlA==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400";
   d="scan'208";a="414632436"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:20:29 -0700
Date: Mon, 22 Mar 2021 13:20:29 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: Re: [PATCH] ndtest: Remove redundant NULL check
Message-ID: <20210322202029.GP3014244@iweiny-DESK2.sc.intel.com>
References: <1616407240-114077-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1616407240-114077-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: VRFAKDMA3T6QNRVDHB5PRC2INCWUJLKT
X-Message-ID-Hash: VRFAKDMA3T6QNRVDHB5PRC2INCWUJLKT
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VRFAKDMA3T6QNRVDHB5PRC2INCWUJLKT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 22, 2021 at 06:00:40PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/testing/nvdimm/test/ndtest.c:491:2-7: WARNING: NULL check before
> some freeing functions is not needed.

I don't think there is anything wrong with this patch specifically but why is
buf not checked for null after the vmalloc?

It seems to me that if size >= DIMM_SIZE and the vmalloc fails the gen pool
allocation is going to be leaked.

Ira

> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/testing/nvdimm/test/ndtest.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
> index 6862915..98b4a43 100644
> --- a/tools/testing/nvdimm/test/ndtest.c
> +++ b/tools/testing/nvdimm/test/ndtest.c
> @@ -487,8 +487,7 @@ static void *ndtest_alloc_resource(struct ndtest_priv *p, size_t size,
>  buf_err:
>  	if (__dma && size >= DIMM_SIZE)
>  		gen_pool_free(ndtest_pool, __dma, size);
> -	if (buf)
> -		vfree(buf);
> +	vfree(buf);
>  	kfree(res);
>  
>  	return NULL;
> -- 
> 1.8.3.1
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
