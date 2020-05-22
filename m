Return-Path: <SRS0=FjO5=7E=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E75D2C433E0
	for <linux-nvdimm@archiver.kernel.org>; Fri, 22 May 2020 11:58:05 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCC38206C3
	for <linux-nvdimm@archiver.kernel.org>; Fri, 22 May 2020 11:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxDa1xFa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCC38206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1149C11FC564B;
	Fri, 22 May 2020 04:54:28 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=198.145.29.99; helo=mail.kernel.org; envelope-from=gregkh@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 548EE11FC5648
	for <linux-nvdimm@lists.01.org>; Fri, 22 May 2020 04:54:26 -0700 (PDT)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id D7061206B6;
	Fri, 22 May 2020 11:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590148683;
	bh=i73lIcu8dbreoO8obOxlyGP8aRtVvKMSUrIAxBKQ5sE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HxDa1xFahyEe06z1Ou+CNgPH9HX4eD62wMLeUU9BMpbjQPALTjvGznv84gDb3ABRX
	 5RRFuKTyPUZ65qrhpd5rPHGrNAwVd0xLEZgLkuKR8iMY+IwjumgCy3TxNoj9e5XtY6
	 qB54WbrTNgRD2a4B1HtzL9ZwBqP3MHlcub3AakdI=
Date: Fri, 22 May 2020 13:58:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [5.4-stable PATCH 0/7] libnvdimm: Cross-arch compatible
 namespace alignment
Message-ID: <20200522115800.GA1451824@kroah.com>
References: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <159010426294.1062454.8853083370975871627.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID-Hash: YXYXGBXG6RUW76WWHSWPZWNIOOOE7JWM
X-Message-ID-Hash: YXYXGBXG6RUW76WWHSWPZWNIOOOE7JWM
X-MailFrom: gregkh@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: stable@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Christoph Hellwig <hch@lst.de>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YXYXGBXG6RUW76WWHSWPZWNIOOOE7JWM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 21, 2020 at 04:37:43PM -0700, Dan Williams wrote:
> Hello stable team,
> 
> These patches have been shipping in mainline since v5.7-rc1 with no
> reported issues. They address long standing problems in libnvdimm's
> handling of namespace provisioning relative to alignment constraints
> including crashes trying to even load the driver on some PowerPC
> configurations.
> 
> I did fold one build fix [1] into "libnvdimm/region: Introduce an 'align'
> attribute" so as to not convey the bisection breakage to -stable.
> 
> Please consider them for v5.4-stable. They do pass the latest
> version of the ndctl unit tests.

What about 5.6.y?  Any user upgrading from 5.4-stable to 5.6-stable
would hit a regression, right?

So can we get a series backported to 5.6.y as well?  I need that before
I can take this series.

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
