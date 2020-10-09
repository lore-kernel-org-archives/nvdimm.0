Return-Path: <SRS0=cB0/=DQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEBEC433E7
	for <linux-nvdimm@archiver.kernel.org>; Fri,  9 Oct 2020 06:04:16 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E73F22244
	for <linux-nvdimm@archiver.kernel.org>; Fri,  9 Oct 2020 06:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E73F22244
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id B4CE91597317F;
	Thu,  8 Oct 2020 23:04:15 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2401:3900:2:1::2; helo=ozlabs.org; envelope-from=michael@ozlabs.org; receiver=<UNKNOWN> 
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id A8D8E15973159
	for <linux-nvdimm@lists.01.org>; Thu,  8 Oct 2020 23:04:13 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
	id 4C6yFN3dBGz9sVl; Fri,  9 Oct 2020 17:04:07 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linux-nvdimm@lists.01.org, linuxppc-dev@lists.ozlabs.org, Vaibhav Jain <vaibhav@linux.ibm.com>
In-Reply-To: <20200913211904.24472-1-vaibhav@linux.ibm.com>
References: <20200913211904.24472-1-vaibhav@linux.ibm.com>
Subject: Re: [PATCH] powerpc/papr_scm: Add PAPR command family to pass-through command-set
Message-Id: <160222339640.867048.1720728622452479198.b4-ty@ellerman.id.au>
Date: Fri,  9 Oct 2020 17:04:07 +1100 (AEDT)
Message-ID-Hash: PK2AAUDMQEUSED4FDRMWLYZJIRTEWJRG
X-Message-ID-Hash: PK2AAUDMQEUSED4FDRMWLYZJIRTEWJRG
X-MailFrom: michael@ozlabs.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/PK2AAUDMQEUSED4FDRMWLYZJIRTEWJRG/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 14 Sep 2020 02:49:04 +0530, Vaibhav Jain wrote:
> Add NVDIMM_FAMILY_PAPR to the list of valid 'dimm_family_mask'
> acceptable by papr_scm. This is needed as since commit
> 92fe2aa859f5 ("libnvdimm: Validate command family indices") libnvdimm
> performs a validation of 'nd_cmd_pkg.nd_family' received as part of
> ND_CMD_CALL processing to ensure only known command families can use
> the general ND_CMD_CALL pass-through functionality.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/papr_scm: Add PAPR command family to pass-through command-set
      https://git.kernel.org/powerpc/c/13135b461cf205941308984bd3271ec7d403dc40

cheers
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
