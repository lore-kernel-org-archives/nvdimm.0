Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F13201105
	for <nvdimm@lists.linux.dev>; Fri, 18 Oct 2024 10:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729246937; cv=none; b=TNYeuRnn6KvOCoGDKGx4/Wdz9ULkeJV7Hv+XpcybdDGd4LRb7OB4AVqrTejfeHaRk3t5VJRJJ6m8RqfG4aHBkEKLoQG+XepBFGZdZSdrSOH3x0Iy+SOvetWHHrkWJ8QPTwuy5CHltLidTYRfzivEjcYUCRV+CrqAERRUgFik8+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729246937; c=relaxed/simple;
	bh=hA134TEANHPZgfEeupic1B+HCLw3uNQGD74SOm3zUv0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hbJ3MX5qv8lGhEita1deYUc0tdDqpzuFRPpRMw8BBiDhUWK1hqpGtYTyomjnADHmJnaLdCcfpkUX7x94rjR0XDGK/oYSdaUvWGmg45P5X4qVIhDuEAUQ9qUG6cq80WEShxe7zdDT2MN6pxj5M0fZbMwJclwNxmkarnFfDIDkn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XVLMs4B9Zz6JBH3;
	Fri, 18 Oct 2024 18:21:29 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D352140556;
	Fri, 18 Oct 2024 18:22:12 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 18 Oct
 2024 12:22:11 +0200
Date: Fri, 18 Oct 2024 11:22:10 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alison Schofield <alison.schofield@intel.com>
CC: Coly Li <colyli@suse.de>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, "Bowman, Terry" <kibowman@amd.com>
Subject: Re: Removing a misleading warning message?
Message-ID: <20241018112210.00004179@Huawei.com>
In-Reply-To: <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
	<ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100002.china.huawei.com (7.191.160.241) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 17 Oct 2024 07:56:03 -0700
Alison Schofield <alison.schofield@intel.com> wrote:

> + linux-cxl mailing list
> 
> On Fri, Oct 11, 2024 at 05:58:52PM +0800, Coly Li wrote:
> > Hi list,
> > 
> > Recently I have a report for a warning message from CXL subsystem,
> > [ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144704] cxl_port port3: HDM decoder capability not found
> > [ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.144859] cxl_port port4: HDM decoder capability not found
> > [ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.174689] cxl_port port7: HDM decoder capability not found
> > [ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and CXL.mem capability array header.
> > [ 48.175105] cxl_port port8: HDM decoder capability not found
> > 
> > After checking the source code I realize this is not a real bug, just a warning message that expected device was not detected.

I'd like to understand a little more about the hardware.
Superficially this looks to be a screaming about non spec compliant (i.e. broken) ports.

Are these on a switch or all root ports?  What is connected to the ports?

Understanding what exactly is going on may affect how this is suppressed (which seems
reasonable to do if this is production hardware).

There have been a few mentions of 'late' register validity on specific root ports. Maybe
that is going on here? +CC Terry.

Jonathan 

> > But from the above warning information itself, users/customers are worried there is something wrong (IMHO indeed not).
> > 
> > Is there any chance that we can improve the code logic that only printing out the warning message when it is really a problem to be noticed? 
> > 
> > Thanks in advance.
> > 
> > Coly Li   
> 

