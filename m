Return-Path: <SRS0=RGaW=BA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_05,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8717C433E2
	for <linux-nvdimm@archiver.kernel.org>; Tue, 21 Jul 2020 10:44:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E69B20714
	for <linux-nvdimm@archiver.kernel.org>; Tue, 21 Jul 2020 10:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lidGLm0v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E69B20714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 785B812446CF1;
	Tue, 21 Jul 2020 03:44:36 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8C63A12446CEE
	for <linux-nvdimm@lists.01.org>; Tue, 21 Jul 2020 03:44:34 -0700 (PDT)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id A519920714;
	Tue, 21 Jul 2020 10:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595328274;
	bh=hKuAGs+rUZGDsVHOETa/8eOzLxdSKKQ5+Xvus7yx3To=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lidGLm0vuEFLVdGjNS9+LIQqgAKZtjjCZWgF4v+dLWiU2yA9rJupWOCrIE7rJ505S
	 jjYAJA3kNoGHNz6IdG4M+JGpPZtNEKjs5rNKMT8jxA7Zp7oEBj4p93NQQ1KMkZLnKS
	 oqscEzWz6n4qq61BkRTIdUBucMsE4Nn73icspVUg=
Date: Tue, 21 Jul 2020 12:44:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 08/11] driver-core: Introduce DEVICE_ATTR_ADMIN_{RO,RW}
Message-ID: <20200721104442.GF1676612@kroah.com>
References: <159528284411.993790.11733759435137949717.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159528288766.993790.5647904882591265970.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <159528288766.993790.5647904882591265970.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID-Hash: ICATTHWLO2P7RRH4Y67OTPYOHWXUGYO3
X-Message-ID-Hash: ICATTHWLO2P7RRH4Y67OTPYOHWXUGYO3
X-MailFrom: gregkh@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ICATTHWLO2P7RRH4Y67OTPYOHWXUGYO3/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jul 20, 2020 at 03:08:07PM -0700, Dan Williams wrote:
> A common pattern for using plain DEVICE_ATTR() instead of
> DEVICE_ATTR_RO() and DEVICE_ATTR_RW() is for attributes that want to
> limit read to only root.  I.e. many users of DEVICE_ATTR() are
> specifying 0400 or 0600 for permissions.
> 
> Given the expectation that CAP_SYS_ADMIN is needed to access these
> sensitive attributes add an explicit helper with the _ADMIN_ identifier
> for DEVICE_ATTR_ADMIN_{RO,RW}.
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/device.h |    4 ++++
>  include/linux/sysfs.h  |    7 +++++++
>  2 files changed, 11 insertions(+)

This is 3022c6a1b4b7 ("driver-core: Introduce
DEVICE_ATTR_ADMIN_{RO,RW}") in linux-next now, if anyone cared :)

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
