Return-Path: <SRS0=RzLO=77=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5083C433E0
	for <linux-nvdimm@archiver.kernel.org>; Thu, 18 Jun 2020 00:11:22 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A07C320897
	for <linux-nvdimm@archiver.kernel.org>; Thu, 18 Jun 2020 00:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A07C320897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2BA2F10FC4AD1;
	Wed, 17 Jun 2020 17:11:22 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4994E10FC447C
	for <linux-nvdimm@lists.01.org>; Wed, 17 Jun 2020 17:11:20 -0700 (PDT)
IronPort-SDR: PLfKLyvym0D5VHPOWmeIu/waIBusmQIJFf2RWmD9ZzeUtRKfCQdxav9yP4F9DeELUVu4e2h9sN
 SzoE7mHOj/nw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 17:11:20 -0700
IronPort-SDR: /0Q3dL8yPlQtS7e3NIaxR5OZBt/WWDI8JgUOL5RbhQX8dpp1zX9oq1tHeKiKs1lbc2Lwy5/X1H
 eqMuKtbjeg7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,524,1583222400";
   d="scan'208";a="262744918"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga007.jf.intel.com with ESMTP; 17 Jun 2020 17:11:20 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.71]) by
 ORSMSX107.amr.corp.intel.com ([169.254.1.92]) with mapi id 14.03.0439.000;
 Wed, 17 Jun 2020 17:11:19 -0700
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [ndctl PATCH v6 2/5] libncdtl: Add initial support for
 NVDIMM_FAMILY_PAPR nvdimm family
Thread-Topic: [ndctl PATCH v6 2/5] libncdtl: Add initial support for
 NVDIMM_FAMILY_PAPR nvdimm family
Thread-Index: AQHWQ59Qyv82nhInrE6CX0GV8knobKjcdBWAgAEGggCAAH19AA==
Date: Thu, 18 Jun 2020 00:11:19 +0000
Message-ID: <b2d0df9ab0874253b81b80509d958c67b8d671cc.camel@intel.com>
References: <20200616053029.84731-1-vaibhav@linux.ibm.com>
	 <20200616053029.84731-3-vaibhav@linux.ibm.com>
	 <64610f17651362e0ecd22ce99740cc9a9e57d6ef.camel@intel.com>
	 <875zbpprtp.fsf@linux.ibm.com>
In-Reply-To: <875zbpprtp.fsf@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
x-originating-ip: [10.18.116.7]
Content-ID: <CB43FC664C2A6F48BE50682FFA8D0149@intel.com>
MIME-Version: 1.0
Message-ID-Hash: XRLIWV42NZFVWKMCLGRSJLSLAI4OPFOB
X-Message-ID-Hash: XRLIWV42NZFVWKMCLGRSJLSLAI4OPFOB
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/XRLIWV42NZFVWKMCLGRSJLSLAI4OPFOB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2020-06-17 at 22:12 +0530, Vaibhav Jain wrote:
> Hi Vishal,
> 
> Thanks for reviewing this patch. I will be addressing your review
> comments in v7 of this patch series.
> 
> ~ Vaibhav
> 
Thanks Vaibhav. The rest of the series looks good to me, so once you
send the update, I'll queue it up for v69.

Thanks,
-Vishal
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
