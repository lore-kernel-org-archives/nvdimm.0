Return-Path: <SRS0=TPW+=6O=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFCCC83006
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 06:03:53 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 349E52137B
	for <linux-nvdimm@archiver.kernel.org>; Thu, 30 Apr 2020 06:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="QYD1i3dW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 349E52137B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 279D01118FE26;
	Wed, 29 Apr 2020 23:02:44 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2401:3900:2:1::2; helo=ozlabs.org; envelope-from=mpe@ellerman.id.au; receiver=<UNKNOWN> 
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7EC851118FE0B
	for <linux-nvdimm@lists.01.org>; Wed, 29 Apr 2020 23:02:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 49CPvj4Cknz9sSg;
	Thu, 30 Apr 2020 16:03:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
	s=201909; t=1588226626;
	bh=elBER65qppGyFsY+iYRbJD5NeTDZbQ7OyBJU28uzXyM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QYD1i3dWyp2wgbuqUrLUzmq+uNN+0F2STt43/RyPvqIEyGmTBVs2npXqAvXtjZNpo
	 NxlTH8+wVAZALLZGaFvwW88v00ixfkN5Hwx37mX8Z5efoqnCzTIM+SZvaPMEg3qB47
	 WXZR+eslYkazw/CWFYtCyRNUXnr1BYVRnf9IYhqvYA1sXKkqumZ0rs2RQ8LKDlgnSi
	 0nuxkCIfq6MV5CqsemkEgHceump3foznBPJWfRrQgmb4lpBjfnKyAGD2s/4K0vjWom
	 +PM3BpNdGcS/CVV7cwOAyUn44OvlNqnFGHzVs3b2CfFOLjAVPPa7ELG0AaekkqnLDi
	 LI1SVrW/z62ZA==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Subject: Re: [PATCH v6 1/4] powerpc: Document details on H_SCM_HEALTH hcall
In-Reply-To: <20200420070711.223545-2-vaibhav@linux.ibm.com>
References: <20200420070711.223545-1-vaibhav@linux.ibm.com> <20200420070711.223545-2-vaibhav@linux.ibm.com>
Date: Thu, 30 Apr 2020 16:04:01 +1000
Message-ID: <87r1w5echa.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-ID-Hash: GPFPV65ZNCWSQATESMQ5CHOUG24LKZLY
X-Message-ID-Hash: GPFPV65ZNCWSQATESMQ5CHOUG24LKZLY
X-MailFrom: mpe@ellerman.id.au
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/GPFPV65ZNCWSQATESMQ5CHOUG24LKZLY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> Add documentation to 'papr_hcalls.rst' describing the bitmap flags
> that are returned from H_SCM_HEALTH hcall as per the PAPR-SCM
> specification.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
> Changelog:
>
> v5..v6
> * New patch in the series
> ---
>  Documentation/powerpc/papr_hcalls.rst | 43 ++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/powerpc/papr_hcalls.rst b/Documentation/powerpc/papr_hcalls.rst
> index 3493631a60f8..9a5ba5eaf323 100644
> --- a/Documentation/powerpc/papr_hcalls.rst
> +++ b/Documentation/powerpc/papr_hcalls.rst
> @@ -220,13 +220,48 @@ from the LPAR memory.
>  **H_SCM_HEALTH**
>  
>  | Input: drcIndex
> -| Out: *health-bitmap, health-bit-valid-bitmap*
> +| Out: *health-bitmap (r4), health-bit-valid-bitmap (r5)*
>  | Return Value: *H_Success, H_Parameter, H_Hardware*
>  
>  Given a DRC Index return the info on predictive failure and overall health of
> -the NVDIMM. The asserted bits in the health-bitmap indicate a single predictive
> -failure and health-bit-valid-bitmap indicate which bits in health-bitmap are
> -valid.
> +the NVDIMM. The asserted bits in the health-bitmap indicate one or more states
> +(described in table below) of the NVDIMM and health-bit-valid-bitmap indicate
> +which bits in health-bitmap are valid.
> +
> +Health Bitmap Flags:
> +
> ++------+-----------------------------------------------------------------------+
> +|  Bit |               Definition                                              |
> ++======+=======================================================================+
> +|  00  | SCM device is unable to persist memory contents.                      |
> +|      | If the system is powered down, nothing will be saved.                 |
> ++------+-----------------------------------------------------------------------+

Are these correct bit numbers or backward IBM big endian bit numbers?

ie. which bit is LSB?

cheers
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
