Return-Path: <SRS0=baXv=HT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEBCC433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 17 Feb 2021 09:57:26 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B8E8A64D9A
	for <linux-nvdimm@archiver.kernel.org>; Wed, 17 Feb 2021 09:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8E8A64D9A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=Huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 61054100EC1E4;
	Wed, 17 Feb 2021 01:57:22 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=185.176.79.56; helo=frasgout.his.huawei.com; envelope-from=jonathan.cameron@huawei.com; receiver=<UNKNOWN> 
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 818F8100ED4A4
	for <linux-nvdimm@lists.01.org>; Wed, 17 Feb 2021 01:56:34 -0800 (PST)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DgY545pj4z67nyq;
	Wed, 17 Feb 2021 17:51:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Feb 2021 10:56:31 +0100
Received: from localhost (10.47.29.73) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 17 Feb
 2021 09:56:30 +0000
Date: Wed, 17 Feb 2021 09:55:24 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>
Subject: Re: [PATCH v4 4/9] cxl/mem: Add basic IOCTL interface
Message-ID: <20210217095524.000071f5@Huawei.com>
In-Reply-To: <20210216183432.lf2uj63uckogfad4@intel.com>
References: <20210216014538.268106-1-ben.widawsky@intel.com>
	<20210216014538.268106-5-ben.widawsky@intel.com>
	<20210216152223.000009e8@Huawei.com>
	<20210216175314.ut2dn5ujayj57zp2@intel.com>
	<20210216182849.00002c8c@Huawei.com>
	<20210216183432.lf2uj63uckogfad4@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.47.29.73]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Message-ID-Hash: J3XQQWQIC4ENMSDPBYSDWHDBRZN4WPX6
X-Message-ID-Hash: J3XQQWQIC4ENMSDPBYSDWHDBRZN4WPX6
X-MailFrom: jonathan.cameron@huawei.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-cxl@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, "Chris Browy  <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>,  Dan Williams  <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, David Rientjes" <rientjes@google.com>, "Jon Masters  <jcm@jonmasters.org>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap" <rdunlap@infradead.org>, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>, kernel test robot <lkp@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <>
List-Archive: <>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 16 Feb 2021 10:34:32 -0800
Ben Widawsky <ben.widawsky@intel.com> wrote:

...

> > > diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> > > index 237b956f0be0..4ca4f5afd9d2 100644
> > > --- a/drivers/cxl/mem.c
> > > +++ b/drivers/cxl/mem.c
> > > @@ -686,7 +686,11 @@ static int cxl_validate_cmd_from_user(struct cxl_mem *cxlm,
> > > 
> > >         memcpy(out_cmd, c, sizeof(*c));
> > >         out_cmd->info.size_in = send_cmd->in.size;
> > > -       out_cmd->info.size_out = send_cmd->out.size;
> > > +       /*
> > > +        * XXX: out_cmd->info.size_out will be controlled by the driver, and the
> > > +        * specified number of bytes @send_cmd->out.size will be copied back out
> > > +        * to userspace.
> > > +        */
> > > 
> > >         return 0;
> > >  }  
> > 
> > This deals with the buffer overflow being triggered from userspace.
> > 
> > I'm still nervous.  I really don't like assuming hardware will do the right
> > thing and never send us more data than we expect.
> > 
> > Given the check that it will fit in the target buffer is simple,
> > I'd prefer to harden it and know we can't have a problem.
> > 
> > Jonathan  
> 
> I'm working on hardening __cxl_mem_mbox_send_cmd now per your request. With
> that, I think this solves the issue, right?

Should do.  Thanks,

Jonathan
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
