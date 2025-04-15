Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4701CDA2E
	for <nvdimm@lists.linux.dev>; Tue, 15 Apr 2025 10:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744711437; cv=none; b=s/z5Sq75P2dqyTUKSxQcZT49ROul4pUHztIeEGK89xLAlqs90KZn/1HCF+iz0EZzETIGW5qGSRIt2fS37/arT5+W1lBfMrX61psPARNioJXL8EhTdipurbttInxdHRAy1Paw9x7foJ7Cce45ToSkQACj9kZSfGRvBOlXyx51k48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744711437; c=relaxed/simple;
	bh=q3xoXI5m08zbhSfvedjV/xy6GUy9zXLHyWNtCFQ8avY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Knb+FWUI+G4j0eK6weeCvN4HIy0PxsvpoUUq6CT5f8Bxx+btgmdzeJtJfT0mo5gIT5LWhRlmOthVam5hzS0xUrcVv93jUlfmSA9X8C8uGjYnJ6dTAhSi8hScm/9HbakpT3tf/tb8f9r6YiFP7vA1JwOQhSwRkwoUKOKImpZeBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZcKTQ3Zp2z67FnC;
	Tue, 15 Apr 2025 18:02:34 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 12BB7140520;
	Tue, 15 Apr 2025 18:03:52 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 15 Apr
 2025 12:03:51 +0200
Date: Tue, 15 Apr 2025 11:03:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Fan
 Ni" <fan.ni@samsung.com>, Davidlohr Bueso <dave@stgolabs.net>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <20250415110350.00006eee@huawei.com>
In-Reply-To: <67fde59784933_71fe2945a@dwillia2-xfh.jf.intel.com.notmuch>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250414174757.00000fea@huawei.com>
	<67fde59784933_71fe2945a@dwillia2-xfh.jf.intel.com.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 14 Apr 2025 21:50:31 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> [..]
> > To me we don't need to answer the question of whether we fully understand
> > requirements, or whether this support covers them, but rather to ask
> > if anyone has requirements that are not sensible to satisfy with additional
> > work building on this?  
> 
> Wearing only my upstream kernel development hat, the question for
> merging is "what is the end user visible impact of merging this?". As
> long as DCD remains in proof-of-concept mode then leave the code out of
> tree until it is ready to graduate past that point.

Hi Dan,

Seems like we'll have to disagree on this. The only thing I can
therefore do is help to keep this patch set in a 'ready to go' state.

I would ask that people review it with that in mind so that we can
merge it the day someone is willing to announce a product which
is a lot more about marketing decisions than anything technical.
Note that will be far too late for distro cycles so distro folk
may have to pick up the fork (which they will hate).

Hopefully that 'fork' will provide a base on which we can build
the next set of key features. 

> 
> Same held for HDM-D support which was an out-of-tree POC until
> Alejandro arrived with the SFC consumer.

Obviously I can't comment on status of that hardware!

> 
> DCD is joined by HDM-DB (awaiting an endpoint) and CXL Error Isolation
> (awaiting a production consumer) as solutions that have time to validate
> that the ecosystem is indeed graduating to consume them. 

Those I'm fine with waiting on, though obviously others may not be!

> There was no
> "chicken-egg" paradox for the ecosystem to deliver base
> static-memory-expander CXL support.

That is (at least partly) because the ecosystem for those was initially BIOS
only. That's not true for DCD. So people built devices on basis they didn't
need any kernel support.  Lots of disadvantages to that but it's what happened.
As a side note, I'd much rather that path had never been there as it is
continuing to make a mess for Gregory and others.

> 
> The ongoing failure to get productive engagement on just how ruthlessly
> simple the implementation could be and still meet planned usages
> continues to give the impression that Linux is way out in front of
> hardware here. Uncomfortably so.

I'll keep pushing for others to engage with this. I also have on my
list writing a document on the future of DCD and proposing at least one
way to add all features on that roadmap. A major intent of that being
to show that there is no blocker to what we have here. I.e. we can
extend it in a logical fashion to exactly what is needed.

Reality is I cannot say anything about unannounced products. Whilst some
companies will talk about stuff well ahead of hardware being ready for
customers we do not do that (normally we announce long after customers
have it.) Hence it seems I have no way to get this upstream other than hope
someone else has a more flexible policy.

Jonathan

