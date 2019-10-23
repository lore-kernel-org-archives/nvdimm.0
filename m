Return-Path: <SRS0=0rKH=YQ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798A2CA9EB9
	for <linux-nvdimm@archiver.kernel.org>; Wed, 23 Oct 2019 22:51:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4E95620663
	for <linux-nvdimm@archiver.kernel.org>; Wed, 23 Oct 2019 22:51:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E95620663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5FBC3100EEB91;
	Wed, 23 Oct 2019 15:52:53 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.120; helo=mga04.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 806EB100EEB8E
	for <linux-nvdimm@lists.01.org>; Wed, 23 Oct 2019 15:52:50 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 15:51:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400";
   d="scan'208";a="210184609"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 23 Oct 2019 15:51:22 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 23 Oct 2019 15:51:22 -0700
Received: from fmsmsx114.amr.corp.intel.com ([169.254.6.30]) by
 FMSMSX102.amr.corp.intel.com ([169.254.10.231]) with mapi id 14.03.0439.000;
 Wed, 23 Oct 2019 15:51:22 -0700
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jmoyer@redhat.com" <jmoyer@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [ndctl patch 3/4] query_fw_finish_status: get rid of redundant
 variable
Thread-Topic: [ndctl patch 3/4] query_fw_finish_status: get rid of redundant
 variable
Thread-Index: AQHVhffdKVQAtmMLOEqII07S9c0vNKdpS+GAgAAGTQA=
Date: Wed, 23 Oct 2019 22:51:21 +0000
Message-ID: <7187044f4f6dca57f43879cd2d493949735f63a2.camel@intel.com>
References: <20191018202302.8122-1-jmoyer@redhat.com>
	 <20191018202302.8122-4-jmoyer@redhat.com>
	 <20191018205424.GA12760@iweiny-DESK2.sc.intel.com>
	 <x49sgnp7ohp.fsf@segfault.boston.devel.redhat.com>
	 <49b7cb5dae88ada6945b15eb1cf2e5e798173861.camel@intel.com>
In-Reply-To: <49b7cb5dae88ada6945b15eb1cf2e5e798173861.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
x-originating-ip: [10.232.112.164]
Content-ID: <8C094CBE4DE17F4F9433D4A1A2950519@intel.com>
MIME-Version: 1.0
Message-ID-Hash: S56G7SDVG33SYTW6XRRQQPIJ3YTP3AK3
X-Message-ID-Hash: S56G7SDVG33SYTW6XRRQQPIJ3YTP3AK3
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/S56G7SDVG33SYTW6XRRQQPIJ3YTP3AK3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2019-10-23 at 22:28 +0000, Verma, Vishal L wrote:
> On Fri, 2019-10-18 at 17:06 -0400, Jeff Moyer wrote:
> > Ira Weiny <ira.weiny@intel.com> writes:
> > > On Fri, Oct 18, 2019 at 04:23:01PM -0400, Jeff Moyer wrote:
> > > > The 'done' variable only adds confusion.
> > > > 
> > > > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> > > > ---
> > > >  ndctl/dimm.c | 7 +------
> > > >  1 file changed, 1 insertion(+), 6 deletions(-)
> > > > 
> > > > diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> > > > index c8821d6..f28b9c1 100644
> > > > --- a/ndctl/dimm.c
> > > > +++ b/ndctl/dimm.c
> > > > @@ -682,7 +682,6 @@ static int query_fw_finish_status(struct ndctl_dimm *dimm,
> > > >  	struct ndctl_cmd *cmd;
> > > >  	int rc;
> > > >  	enum ND_FW_STATUS status;
> > > > -	bool done = false;
> > > >  	struct timespec now, before, after;
> > > >  	uint64_t ver;
> > > >  
> > > > @@ -716,7 +715,6 @@ static int query_fw_finish_status(struct ndctl_dimm *dimm,
> > > >  					ndctl_dimm_get_devname(dimm));
> > > >  			printf("Firmware version %#lx.\n", ver);
> > > >  			printf("Cold reboot to activate.\n");
> > > > -			done = true;
> > > >  			rc = 0;
> > > 
> > > Do we need "goto out" here?
> > 
> > Yes, I missed that one.  Thanks.
> 
> This actually looks fine, since there is a 'break' down below.
> 
> > > >  			break;
> > > >  		case FW_EBUSY:

(Watching the unit test run fall into an infinite loop..) Nope, the
break is in the switch scope, the while loop needs the 'goto out'.

Yes this bit definitely needs to be refactored :)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
