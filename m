Return-Path: <SRS0=aEgn=X4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4199BC10F14
	for <linux-nvdimm@archiver.kernel.org>; Thu,  3 Oct 2019 00:01:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C1E6215EA
	for <linux-nvdimm@archiver.kernel.org>; Thu,  3 Oct 2019 00:01:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C1E6215EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 4AAD7100DC433;
	Wed,  2 Oct 2019 17:02:46 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.20; helo=mga02.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CEEED100DC430
	for <linux-nvdimm@lists.01.org>; Wed,  2 Oct 2019 17:02:43 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 17:01:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200";
   d="scan'208";a="343491742"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 02 Oct 2019 17:01:26 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 2 Oct 2019 17:01:25 -0700
Received: from fmsmsx113.amr.corp.intel.com ([169.254.13.68]) by
 fmsmsx117.amr.corp.intel.com ([169.254.3.133]) with mapi id 14.03.0439.000;
 Wed, 2 Oct 2019 17:01:25 -0700
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] libdaxctl: fix memory leaks with daxctl_memory
 objects
Thread-Topic: [ndctl PATCH] libdaxctl: fix memory leaks with daxctl_memory
 objects
Thread-Index: AQHVeH7olHKI9xaoIESF1uYlX3Snm6dG4ZuAgAGeIwA=
Date: Thu, 3 Oct 2019 00:01:24 +0000
Message-ID: <796dc27db614dfd931b2568162f5f885195ba408.camel@intel.com>
References: <20191001173726.21846-1-vishal.l.verma@intel.com>
	 <20191001231909.GA11607@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20191001231909.GA11607@iweiny-DESK2.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.164]
Content-ID: <A6F518FC1DC55C4F924FDBA1F4F09D5F@intel.com>
MIME-Version: 1.0
Message-ID-Hash: LFSQBUAHV7VKJKVPKELY3WF7KF4SAVTL
X-Message-ID-Hash: LFSQBUAHV7VKJKVPKELY3WF7KF4SAVTL
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Biesek, Michal" <michal.biesek@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/LFSQBUAHV7VKJKVPKELY3WF7KF4SAVTL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2019-10-01 at 16:19 -0700, Ira Weiny wrote:
> 
> > diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> > index 8abfd64..639224c 100644
> > --- a/daxctl/lib/libdaxctl.c
> > +++ b/daxctl/lib/libdaxctl.c
> > @@ -204,8 +204,9 @@ DAXCTL_EXPORT void daxctl_region_get_uuid(struct daxctl_region *region, uuid_t u
> >  
> >  static void free_mem(struct daxctl_dev *dev)
> >  {
> > -	if (dev && dev->mem) {
> > +	if (dev->mem) {
> 
> There is a comment in daxctl_dev_disable() which says:
> 
>         /* If there is a memory object, first free that */
> 
> I'm 100% sure that dev can't be NULL there.  So that comment no longer applies.
> 
> May want to remove that comment.
> 
Hm, I'm not sure I follow.

Yes, dev can't be null there, but 'mem' can me. Hence the comment saying
if /mem/ is present, free it.

The check in free_mem() only checks for non-NULL mem too.

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
