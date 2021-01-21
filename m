Return-Path: <SRS0=dbx4=GY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6B0C433DB
	for <linux-nvdimm@archiver.kernel.org>; Thu, 21 Jan 2021 08:13:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A8EA02396D
	for <linux-nvdimm@archiver.kernel.org>; Thu, 21 Jan 2021 08:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8EA02396D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EFBF1100EB349;
	Thu, 21 Jan 2021 00:13:16 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 77598100EB821
	for <linux-nvdimm@lists.01.org>; Thu, 21 Jan 2021 00:13:14 -0800 (PST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id E09E92395B;
	Thu, 21 Jan 2021 08:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1611216793;
	bh=Jv1+7MosJtJk/47qnsHE23CojVtEBdwQu3teqjrEUG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ych4A9+XzpZXkBsCkXP/On+u7xDemwsYafarw38F4mHDP/WP6N8atVJxSu6+bNrG7
	 2uH9IAL/cEmASLMwFiLsOJAgjlLujgG+ZO29Z+a+QdatEfgTsRxPsvsFSS7Hpi2i1q
	 wRvYg7Te/pec9wrDrcpwF7jDootfX4r0APyclbKk=
Date: Thu, 21 Jan 2021 09:13:09 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] cdev: Finish the cdev api with queued mode support
Message-ID: <YAk3lVeFqnv5vzA2@kroah.com>
References: <161117153248.2853729.2452425259045172318.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161117153776.2853729.6944617921517514510.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <161117153776.2853729.6944617921517514510.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID-Hash: W4JG6DD2OQBZBKUILWYJXDDOLX2FWNRU
X-Message-ID-Hash: W4JG6DD2OQBZBKUILWYJXDDOLX2FWNRU
X-MailFrom: gregkh@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Logan Gunthorpe <logang@deltatee.com>, Hans Verkuil <hans.verkuil@cisco.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/W4JG6DD2OQBZBKUILWYJXDDOLX2FWNRU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 20, 2021 at 11:38:57AM -0800, Dan Williams wrote:
> -void cdev_del(struct cdev *p)
> +void cdev_del(struct cdev *cdev)
>  {
> -	cdev_unmap(p->dev, p->count);
> -	kobject_put(&p->kobj);
> +	cdev_unmap(cdev->dev, cdev->count);
> +	kobject_put(&cdev->kobj);

After Christoph's patch series, the kobject in struct cdev does nothing,
so I will be removing it.  So I don't think this patch set is going to
do what you want :(

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
