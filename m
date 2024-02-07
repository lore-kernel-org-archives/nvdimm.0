Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBA51CF9A
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 22:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707346448; cv=none; b=P9uDbuMceo/jAZFi2DymLXMf3NKJL3UeAb3EtqO/P1DPLN+B4Lp5APsavSVo/rE6Fnl8kSOmEQKshNqHeblmdlv4H/boZPuVyQ2DnRhJmw0ZF4fGaOIiPtm6XzwFuFLh246odukjtMEHemHw1+CdXS4IaKRw7Bs8rJP2o1vCWCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707346448; c=relaxed/simple;
	bh=Ns5BcPSLKhIaVHunN5WY1aH4q33j9KqumY1Li/7q5iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nqqchFwYWFLjp4ld4YU/+dEqoNWif6uJx/X+bJiDrQSkO0cttqftCFNzaQhxE+mIPh2i5hilHROxvjVmIMdw9KtsZnLO82iw1xYXtMnkzHfcgFRg3/3HttZEA71O9TEARMR9Jn1ISWFpL89zXPziA1wbFm/8Vp+aDv3vFewFSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QV/jqUhH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QV/jqUhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707346446; x=1738882446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ns5BcPSLKhIaVHunN5WY1aH4q33j9KqumY1Li/7q5iE=;
  b=QV/jqUhHldFODRBtlL8/jPR4WcoivVkQxH9q5RZmNPw/sGuVwscM5JM3
   bQThzgsTRxviAWrQRutF20KqCyYOGpLkccjBIIAmf1zIZcocdUQhmz2Uv
   tYvHPPFOp+aL7xBpFK5fYy4KSFS91Fz6D6ndc8Ia9C1ZelGcqWYN+wNQN
   w60XftfRsd80UmnUG/+G4SRej7cUk/LpIsCzXAqqLpRDVqjK3VcpGGMfq
   YYZYpkIqJzORlz6uwJfee3Dh1YUqccYj/qxRoHLGDShgTLuWORnZJZCY8
   RySsRlEu1Cjp4XEiZsm5hcGRLqdxBOIEUf0FvXmCcQN6uOlEfFMy+0Bqu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="26541287"
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="26541287"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 14:54:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,252,1701158400"; 
   d="scan'208";a="1781871"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.105.224])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 14:54:06 -0800
Date: Wed, 7 Feb 2024 14:54:04 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v6 0/7] Support poison list retrieval
Message-ID: <ZcQKDCiNXYqdtQ/z@aschofie-mobl2>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <65a99ea31393a_2d43c29454@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <Zam1iPjxXA9iiUOl@aschofie-mobl2>
 <65a9ba5469bc5_37ad29426@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65a9ba5469bc5_37ad29426@dwillia2-xfh.jf.intel.com.notmuch>

On Thu, Jan 18, 2024 at 03:55:00PM -0800, Dan Williams wrote:
> Alison Schofield wrote:
> [..]
> > > >         "dpa":1073741824,
> > > >         "dpa_length":64,
> > > 
> > > The dpa_length is also the hpa_length, right? So maybe just call the
> > > field "length".
> > > 
> > 
> > No, the length only refers to the device address space. I don't think
> > the hpa is guaranteed to be contiguous, so only the starting hpa addr
> > is offered.
> > 
> > hmm..should we call it 'size' because that seems to imply less
> > contiguous-ness than length?
> 
> The only way the length could be discontiguous in HPA space is if the
> error length is greater than the interleave granularity. Given poison is
> tracked in cachelines and the smallest granularity is 4 cachelines it is
> unlikely to hit the mutiple HPA case.

Hi Dan,

Circling back to this issue, as I'm posting an udpated rev.

I'm not getting how *only* an error length greater that IG can lead to
discontigous HPA. If the poison starts on the last 64 bytes of an IG and
has a length greater than 64 bytes, we go beyond the endpoints mapping,
even if that length is less than IG.

In the layout below, if the device underlying endpoint2 reports
^poison^ as shown, it is discontinguous in HPA space.

HPA 0..........................................................N
ep1 ..........          ..........          ..........    
ep2           ..........          ..........          ..........
bad                   ^poison^ 
good                  ^po          ison^

'bad' is what happens today if length is applied to HPA
'good' is what is right

Am I missing something wrt cachelines you mention?

> 
> However, I think the kernel side should aim to preclude that from
> happening. Given that this is relying on the kernel's translation I
> would make it so that the kernel never leaves the impacted HPAs as
> ambiguous. For example, if the interleave_granularity of the region is
> 256 and the DPA length is 512, it would be helpful if the *kernel* split
> that into multiple trace events to communicate the multiple impacted
> HPAs rather than leave it as an exercise to userspace.
> 

That's a familiar plan that we rejected in the driver implementation,
As defined, a cxl_poison event reports a starting dpa, a dpa_length,
and the starting hpa if the address is mapped. That left userspace to do
the HPA translation work.

We can move that work to the driver independent of this ndctl work.

> 
> Might be useful to capture Erwin's analysis of how to use that field in
> the man page, if it's not there already.

The man page now has the definitions of the source field and a spec
reference.  I don't see the cxl list man page as the place to offer
media-error trouble-shooting tips. 
