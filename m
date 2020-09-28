Return-Path: <SRS0=xlp5=DF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB78C2D0A8
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Sep 2020 15:45:21 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFE232074F
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Sep 2020 15:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFE232074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 63B98151C4E50;
	Mon, 28 Sep 2020 08:45:20 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.31; helo=mga06.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7C332151C4E45
	for <linux-nvdimm@lists.01.org>; Mon, 28 Sep 2020 08:45:18 -0700 (PDT)
IronPort-SDR: E6QzXyYL8YUJF1GtlNLHvEli8M6Qu4Ss3bK/JJaoaPRYGDuLFLKX3WohltaZb0pNsKfvmVpGsg
 XxKNAMJSC0ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="223609116"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400";
   d="scan'208";a="223609116"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:45:17 -0700
IronPort-SDR: qOPJKrzOfDHGsK9qtB8ba1xH7UmUmktOCif20xZeUHjB03krI6qr5hcOb45D6THF5KmSq7VCXO
 cX0DwyyHa9ZA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400";
   d="scan'208";a="456875203"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 08:45:17 -0700
Date: Mon, 28 Sep 2020 08:45:16 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] powerpc/papr_scm: Add PAPR command family to
 pass-through command-set
Message-ID: <20200928154516.GA458519@iweiny-DESK2.sc.intel.com>
References: <20200913211904.24472-1-vaibhav@linux.ibm.com>
 <87pn662gc3.fsf@vajain21.in.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87pn662gc3.fsf@vajain21.in.ibm.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: QLKRIZQJG2CPZF2555MZVYQZXJO7HEQI
X-Message-ID-Hash: QLKRIZQJG2CPZF2555MZVYQZXJO7HEQI
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QLKRIZQJG2CPZF2555MZVYQZXJO7HEQI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 28, 2020 at 06:44:52PM +0530, Vaibhav Jain wrote:
> Hi Dan, Ira and Vishal,
> 
> Can you please take a look at this patch. Without it the functionality
> to report nvdimm health via ndctl breaks on 5.9

Sorry...

> 
> Thanks,
> ~ Vaibhav
> 
> Vaibhav Jain <vaibhav@linux.ibm.com> writes:
> 
> > Add NVDIMM_FAMILY_PAPR to the list of valid 'dimm_family_mask'
> > acceptable by papr_scm. This is needed as since commit
> > 92fe2aa859f5 ("libnvdimm: Validate command family indices") libnvdimm
> > performs a validation of 'nd_cmd_pkg.nd_family' received as part of
> > ND_CMD_CALL processing to ensure only known command families can use
> > the general ND_CMD_CALL pass-through functionality.
> >
> > Without this change the ND_CMD_CALL pass-through targeting
> > NVDIMM_FAMILY_PAPR error out with -EINVAL.
> >
> > Fixes: 92fe2aa859f5 ("libnvdimm: Validate command family indices")
> > Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

LGTM

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> > ---
> >  arch/powerpc/platforms/pseries/papr_scm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
> > index 5493bc847bd08..27268370dee00 100644
> > --- a/arch/powerpc/platforms/pseries/papr_scm.c
> > +++ b/arch/powerpc/platforms/pseries/papr_scm.c
> > @@ -898,6 +898,9 @@ static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
> >  	p->bus_desc.of_node = p->pdev->dev.of_node;
> >  	p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
> >  
> > +	/* Set the dimm command family mask to accept PDSMs */
> > +	set_bit(NVDIMM_FAMILY_PAPR, &p->bus_desc.dimm_family_mask);
> > +
> >  	if (!p->bus_desc.provider_name)
> >  		return -ENOMEM;
> >  
> > -- 
> > 2.26.2
> >
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
