Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5703718C031
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744649284; cv=none; b=QYe7Tp15VNLoF8hpp0KFvE7fSJjckHzo28OBmvvXcOVZ4bR+Z1mS2pLDG/TOHnr2WprYuIXr0A9y1L1W5wrkbjmVofPfh5IQQJMP0CQ2bBGjyOSkl27mRI/dGm3o9ESV9ChazFNwlNbS0Sk4zmK3B/rT2IcVhJt0GgRdHtW0rQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744649284; c=relaxed/simple;
	bh=f/WChhpYkdKS0Bfr+KpWWihP2h/l15jvh0stxorbCfY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nE4iGffLb/TDlfHKcC9WxOXTBvL1xx3M6ZLoXvcau5kTawdJjOycBm5pgcKxTISxD61VO8lY2vCxC1nq56wDr4IbqKwixKdAXMuhPxIY/pO58XlhFC4y34SNmHN4NlCVKTv8jaGn2puT9JNi+QnP1M21u/a2LLS3sQL+qJIsROY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbtQt1W85z6K9BZ;
	Tue, 15 Apr 2025 00:43:50 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3693D1402F4;
	Tue, 15 Apr 2025 00:47:59 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 18:47:58 +0200
Date: Mon, 14 Apr 2025 17:47:57 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Li Ming
	<ming.li@zohomail.com>
Subject: Re: [PATCH v9 00/19] DCD: Add support for Dynamic Capacity Devices
 (DCD)
Message-ID: <20250414174757.00000fea@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
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

On Sun, 13 Apr 2025 17:52:08 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> A git tree of this series can be found here:
> 
> 	https://github.com/weiny2/linux-kernel/tree/dcd-v6-2025-04-13
> 
> This is now based on 6.15-rc2.

Hi Ira,

Firstly thanks for the update and your hard work driving this forwards.

> 
> Due to the stagnation of solid requirements for users of DCD I do not
> plan to rev this work in Q2 of 2025 and possibly beyond.

Hopefully there will be limited need to make changes (it looks pretty 
good to me - we'll run a bunch of tests though which I haven't done
yet).  I do have reason to want this code upstream and it is
now simple enough that I hope it is not controversial. Let's discuss
path forwards on the sync call tomorrow as I'm sure I'm not the only one.

If needed I'm fine picking up the baton to keep this moving forwards
(I'm even more happy to let someone else step up though!)

To me we don't need to answer the question of whether we fully understand
requirements, or whether this support covers them, but rather to ask
if anyone has requirements that are not sensible to satisfy with additional
work building on this?

I'm not aware of any such blocker.  For the things I care about the
path forwards looks fine (particularly tagged capacity and sharing).

> 
> It is anticipated that this will support at least the initial
> implementation of DCD devices, if and when they appear in the ecosystem.
> The patch set should be reviewed with the limited set of functionality in
> mind.  Additional functionality can be added as devices support them.

Personally I think that's a chicken and egg problem but fully understand
the desire to keep things simple in the short term.  Getting initial DCD
support in will help reduce the response (that I frequently hear) of
'the ecosystem isn't ready, let's leave that for a generation'.


> 
> It is strongly encouraged for individuals or companies wishing to bring
> DCD devices to market review this set with the customer use cases they
> have in mind.
> 

Absolutely.  I can't share anything about devices at this time but you
can read whatever you want into my willingness to help get this (and a
bunch of things built on top of it) over the line.



> Remaining work:
> 
> 	1) Allow mapping to specific extents (perhaps based on
> 	   label/tag)
> 	   1a) devise region size reporting based on tags
> 	2) Interleave support

I'd maybe label these as 'additional possible future features'.
Personally I'm doubtful that hardware interleave of DCD is a short
term feature and it definitely doesn't have to be there for this to be useful.

Tags will matter but that is a 'next step' that this series does
not seem to hinder.


> 
> Possible additional work depending on requirements:
> 
> 	1) Accept a new extent which extends (but overlaps) already
> 	   accepted extent(s)
> 	2) Rework DAX device interfaces, memfd has been explored a bit
> 	3) Support more than 1 DC partition
> 
> [1] https://github.com/weiny2/ndctl/tree/dcd-region3-2025-04-13

Thanks,

Jonathan


