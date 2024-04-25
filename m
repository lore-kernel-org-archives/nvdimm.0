Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1957F513
	for <nvdimm@lists.linux.dev>; Thu, 25 Apr 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063978; cv=none; b=mFPetA8Jo5vlD05jCGSfqOwmGNxdtyEIm+MVdFDs/1HsS/yHSDE/NGG3IY8Wwgn+NUM+N/mhANzZ77ktj+5LYstLwbgb2svHA5QSDuIcN90htFxtphpdklsLBQhpAZTdRoqchG7KDcb0iSgZj0LKhYjY+nxLR2qYBjw3EtriBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063978; c=relaxed/simple;
	bh=Zkx3vgcHNB0cRQ9rzS5wH406nnXq5OjX5Tdirkbnk8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=URqbrF/YzYyMITfGz4t8IkMye6Lmil57Z0wqRVa8HX6Tdg5PeFp7jnXPLdNaCyb40ugGE6TIyJHrjdFe/B5384EseRMie8Q/GweCSO7EhjHb78JKL2v4C6nI0c4pL+kRr3wFy/L7X5+fojdeZkW8HmEijhBt9G9Qbnbt5ZMhSRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YAzIDowb; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YAzIDowb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714063976; x=1745599976;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Zkx3vgcHNB0cRQ9rzS5wH406nnXq5OjX5Tdirkbnk8o=;
  b=YAzIDowbKc709M3BQz1QmTQI6ix5+nC5KjxQ3ZEtnOC9VPK/KLrnFuUa
   Tr1PeThVsOtmhR/siwaFTH1uElrFa9+At0Ep8zmN52Mgd/+ecVTrvIJlO
   xHp5gKgmJ4ckI0eFDskqx5/34ugpt66As2sSdZX1FElJP/vUV0Mid0kh6
   NNDKdlu3kP3sPTRQjiJ26JMfMMA8IPD3vLVBNd8Pf+zOX+zsaoZAd+Kqz
   SAdbQcJ6kCbB6yVZNekBEah0uKS08+9pBW+hgCA2ONLtsGiboJyrCINiZ
   RCDm9IGQ1Vyc3Avpju/vJ0X2U4pe0g1JNM74gPrWvg92B67JAZqVJwSrJ
   g==;
X-CSE-ConnectionGUID: B8nvOJGWR4+bd5yCCdYGFQ==
X-CSE-MsgGUID: n5t3duCCR4+H5UkHYhVsmQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13551551"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="13551551"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:52:56 -0700
X-CSE-ConnectionGUID: AOB+R/upTH+D1wE+jPrBDg==
X-CSE-MsgGUID: n1ZckBlwRg24G7NKZSHo5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="48380411"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.252.128.24])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 09:52:56 -0700
Date: Thu, 25 Apr 2024 09:52:54 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>,
	"Quanquan Cao (Fujitsu)" <caoqq@fujitsu.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v3 2/2] cxl: Add check for regions before disabling
 memdev
Message-ID: <ZiqKZqsA0JjT51Wl@aschofie-mobl2>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
 <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
 <9b00e36292b7aa19f68bda6912b04207f43c8dc5.camel@intel.com>
 <779cc56f-9958-4c0a-b5d6-2a9d4c3e4260@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <779cc56f-9958-4c0a-b5d6-2a9d4c3e4260@fujitsu.com>

On Thu, Apr 25, 2024 at 05:30:40AM +0000, Zhijian Li (Fujitsu) wrote:
> Hi Verma,
> 
> 
> On 18/04/2024 02:14, Verma, Vishal L wrote:
> > On Wed, 2024-04-17 at 02:46 -0400, Yao Xingtao wrote:
> >>
> >> Hi Dave,
> >>    I have applied this patch in my env, and done a lot of testing,
> >> this
> >> feature is currently working fine.
> >>    But it is not merged into master branch yet, are there any updates
> >> on this feature?
> > 
> > Hi Xingtao,
> > 
> > Turns out that I had applied this to a branch but forgot to merge and
> > push it. Thanks for the ping - done now, and pushed to pending.
> 
> 
> May I know when the next version of NDCTL will be released. It seems like
> it's been a very long time since the last release.

Hi Zhijian,

We appreciate you working with the pending branch while waiting
for the next release. We are aiming to get the poison list feature
merged in the next release, and are getting closer. That's all I
can offer, no date prediction.

-- Alison

> 
> 
> Thanks
> Zhijian
> 
> 
> 
> 
> > 
> >>
> >> Associated patches:
> >> https://lore.kernel.org/linux-cxl/170112921107.2687457.2741231995154639197.stgit@djiang5-mobl3/
> >> https://lore.kernel.org/linux-cxl/170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3/
> >>
> >> Thanks
> >> Xingtao
> > 
