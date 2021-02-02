Return-Path: <SRS0=J6SA=HE=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FD8C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Feb 2021 18:33:31 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0383C64F7E
	for <linux-nvdimm@archiver.kernel.org>; Tue,  2 Feb 2021 18:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0383C64F7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C53F2100EA2CB;
	Tue,  2 Feb 2021 10:33:30 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.31; helo=mga06.intel.com; envelope-from=ben.widawsky@intel.com; receiver=<UNKNOWN> 
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1F2E8100EAB46
	for <linux-nvdimm@lists.01.org>; Tue,  2 Feb 2021 10:33:29 -0800 (PST)
IronPort-SDR: 8SRGcIiFHivwT46E564xIroEZ26wDop2l9YhVpQlXMoiw1XmhPoD0vQ/67g8OAHOr0VPQVJvDw
 b+xscdWDD5Wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242421455"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400";
   d="scan'208";a="242421455"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 10:33:28 -0800
IronPort-SDR: o0BhQQsQFexfvQyPOkPHDvxmcu9hxi3ywGSD4mrPrneLs4gP1togqGK+AONy7stmmIWpDROh81
 OpG9MSEPKy+Q==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400";
   d="scan'208";a="582136028"
Received: from joship1x-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.131.202])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 10:33:26 -0800
Date: Tue, 2 Feb 2021 10:33:25 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/14] cxl/mem: Add basic IOCTL interface
Message-ID: <20210202183325.ls7o54zza4obw6df@intel.com>
References: <20210130002438.1872527-1-ben.widawsky@intel.com>
 <20210130002438.1872527-7-ben.widawsky@intel.com>
 <20210202181505.GF3708021@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210202181505.GF3708021@infradead.org>
Message-ID-Hash: KCPDQKF66CVJZBBS5J62Z627QMF2QGC5
X-Message-ID-Hash: KCPDQKF66CVJZBBS5J62Z627QMF2QGC5
X-MailFrom: ben.widawsky@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-cxl@vger.kernel.org, kernel test robot <lkp@intel.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, daniel.lll@alibaba-inc.com, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KCPDQKF66CVJZBBS5J62Z627QMF2QGC5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 21-02-02 18:15:05, Christoph Hellwig wrote:
> > +#if defined(__cplusplus)
> > +extern "C" {
> > +#endif
> 
> This has no business in a kernel header.

This was copypasta from DRM headers (which as you're probably aware wasn't
always part of the kernel)... It's my mistake and I will get rid of it.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
