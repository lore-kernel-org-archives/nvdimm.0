Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F45D1A9B24
	for <nvdimm@lists.linux.dev>; Wed, 10 Sep 2025 14:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757513009; cv=none; b=OppHyfvRvf0JWvihpyQXSVNFFwWv6yPLXFR4TLC0l1v2TMMoUF25UTroWcrr6E2rBG77H/u24ALAPTbB6SCUxOboTS0dGhm7Tw9391esvGfke/a0x4oo5FXPRZtSzf7IWZCLNNDGdwQsV0MMfcnnMT/iaQeJk2Xs7tnrqO1fr/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757513009; c=relaxed/simple;
	bh=TQDrVeY3489/FH/73wZC6CHaQ0RWriZ2IW3o9GYBPSE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZmXvWz2X5hcgqevx4w296gtVekX1nHUBUcKonlLOtrB30b6nwpebSfp54O9aBg6R4bcQSEPoYIkohIbn3RksTkFGzlnk21KFkcl/wNQ0hYEj5evDU+EvSo8ft098dwPUt3Qi0rwc/I4nsU3on7ET92iJVfJKMPy+heM4xBG1fOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cMMkB0cgMz6K5xZ;
	Wed, 10 Sep 2025 21:59:14 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AD2FF1402F7;
	Wed, 10 Sep 2025 22:03:24 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 10 Sep
 2025 16:03:23 +0200
Date: Wed, 10 Sep 2025 15:03:22 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<gost.dev@samsung.com>, <a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Message-ID: <20250910150322.00001ea4@huawei.com>
In-Reply-To: <158453976.61757055783236.JavaMail.epsvc@epcpadp2new>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>
	<20250730121209.303202-6-s.neeraj@samsung.com>
	<534936cc-4ecc-46e5-8196-bc3992e086ab@intel.com>
	<158453976.61757055783236.JavaMail.epsvc@epcpadp2new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 4 Sep 2025 19:42:31 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> On 15/08/25 02:55PM, Dave Jiang wrote:
> >
> >
> >On 7/30/25 5:11 AM, Neeraj Kumar wrote:  
> >> Added __pmem_region_label_update region label update routine to update
> >> region label.
> >>
> >> Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
> >> mutex_unlock()
> >>
> >> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>  
> >
> >Subject, s/updation/update/ ?  
> 
> Thanks Dave, Sure. Will fix it in next patch-set
> 

Hi Neeraj,
 
Really small process point.  We all get too many emails, so
when replying crop out anything that doesn't need more discussion.
Where you are just saying you agree, leave that for the change logs of the
next version (and appropriate thanks can go there as well).

I know not replying can feel little rude, but trust me when I say all
or almost all who review a lot appreciate efficiency!

It also makes it a lot harder to miss the more substantial replies.

> >> +int nd_pmem_region_label_update(struct nd_region *nd_region)
> >> +{
> >> +	int i, rc;
> >> +
> >> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> >> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> >> +		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> >> +
> >> +		/* No need to update region label for non cxl format */
> >> +		if (!ndd->cxl)
> >> +			continue;  
> >
> >Would there be a mix of different nd mappings? I wonder if you can just 'return 0' if you find ndd->cxl on the first one and just skip everything.  
> 
> When we create cxl region with two mem device, then we will have two separate
> nd_mapping for both mem devices. But Yes, I don't see difference in both device
> nd_mapping characters. So instead of "continue", I will just "return 0".
> 

This for instance is good discussion and well worth the reply!

Good discussion is great, but reducing the noise is key to keeping
things manageable.

Jonathan

p.s. I'm having a full day or reviewing code so getting a little grumpier
than I was first thing this morning when I might not have given this feedback!
