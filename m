Return-Path: <SRS0=rtTk=XP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA4C3A5A2
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 18:14:45 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A33A620717
	for <linux-nvdimm@archiver.kernel.org>; Fri, 20 Sep 2019 18:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A33A620717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1B6E4202ECFAD;
	Fri, 20 Sep 2019 11:13:42 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=134.134.136.20; helo=mga02.intel.com;
 envelope-from=dave.jiang@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 044D8202EBEC6
 for <linux-nvdimm@lists.01.org>; Fri, 20 Sep 2019 11:13:40 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 20 Sep 2019 11:14:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,529,1559545200"; d="scan'208";a="192433836"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
 by orsmga006.jf.intel.com with ESMTP; 20 Sep 2019 11:14:43 -0700
Subject: Re: [ndctl PATCH] libndctl: Fix a potentially non NUL-terminated
 string operation
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
References: <20190920180608.8662-1-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Openpgp: preference=signencrypt
Autocrypt: addr=dave.jiang@intel.com; prefer-encrypt=mutual; keydata=
 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
 o6nmKbYpUAltQObU2w==
Message-ID: <d602e9fd-8a39-d75b-f9dc-ed18c054c3ab@intel.com>
Date: Fri, 20 Sep 2019 11:14:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920180608.8662-1-vishal.l.verma@intel.com>
Content-Language: en-US
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>



On 9/20/19 11:06 AM, Vishal Verma wrote:
> Static analysis warns that pread() doesn't NUL-terminate buffers, and
> that we shouldn't pass it directly to strcmp. The sysfs string should
> normally have the right termination, but for correctness in the library,
> we shouldn't rely on that. Replace the strcmp() calls in question with
> an explicit strncmp().
> 
> Fixes: 3c0c7db045ec ("ndctl: add a wait-overwrite command")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/lib/dimm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 2f145be..17344f0 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -825,7 +825,7 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
>  			break;
>  		}
>  
> -		if (strcmp(buf, "overwrite") == 0) {
> +		if (strncmp(buf, "overwrite", 9) == 0) {
>  			rc = poll(&fds, 1, -1);
>  			if (rc < 0) {
>  				rc = -errno;
> @@ -839,7 +839,7 @@ NDCTL_EXPORT int ndctl_dimm_wait_overwrite(struct ndctl_dimm *dimm)
>  			}
>  			fds.revents = 0;
>  		} else {
> -			if (strcmp(buf, "disabled") == 0)
> +			if (strncmp(buf, "disabled", 8) == 0)
>  				rc = 1;
>  			break;
>  		}
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
