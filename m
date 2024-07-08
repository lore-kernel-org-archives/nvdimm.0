Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D723146016
	for <nvdimm@lists.linux.dev>; Mon,  8 Jul 2024 20:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720472077; cv=none; b=L+1EFO4tifWI3SbNCI2FmvLRQt9QqWLzQ+4MiROzrr9VVSinam8TqjfDMZVNkh6UURzOOgbgkokFuT1FtziCfoBY22VH5v/dYTMa/IWuIPtm0fcKhV3qAvEX/ZckTq3TeJvr+DhuxHYt3tCnv5E66iHX0EdHW5KZwUpqzOCsz1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720472077; c=relaxed/simple;
	bh=pzEQCKW06tzwbc4tbAwQvkRlr1ZNwcWvPABCq9MAs/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f/jx2mgjHPwnd6oquXI9zN88uQqvKf/JVk9s4oTJI5lNJbdiispv680pS8CShsN7L8fLDhEi1xaw/NgZvBQK+89BQEWJ2ieJ41B0LlZOaXSQwgiq8gzrGHM5NnD4j9mMzTpp0FyujFb1F11Sb/ngaRRYF5w1mv1f1VSUG6spadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9opYNSo; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9opYNSo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720472076; x=1752008076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pzEQCKW06tzwbc4tbAwQvkRlr1ZNwcWvPABCq9MAs/I=;
  b=j9opYNSove3K+wWp37r50qadCILbw/GU1cDq0W6lXPMrNC4HV5f4Q/aG
   9eKMYrdd60yMgawc6w0MANJ4FJiHGfmYIk3sSqUzZzdMPO/Kd+A4xGXQp
   0Ad9O1bsPmpMglNYUFthSwrFPKFZaqFl3B1wMTxQv00kYlhBTW9H8Qi5h
   THbb76EqtwBhDkXZUooudZglnTOQcDriH/TNTtKdmK4JC07B5NqPbV/2W
   h/HR5DCQI2nTbmLZlRitBAqa8pt8ymmMQbgs8mdk2G19BouIvQ+H5JZdp
   p5kPT4EV1YAtvjXhPQF2a2yYWMwVRtqIxm61yvF82IpY0aYKWdA0YOsdS
   Q==;
X-CSE-ConnectionGUID: cUuBc8YPTUiJDw1EOe7g/A==
X-CSE-MsgGUID: iSJ7avScQs+tuSEfeiUWcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="21462786"
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="21462786"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 13:54:36 -0700
X-CSE-ConnectionGUID: dYI7AkokRlmg5R3ynL5u3g==
X-CSE-MsgGUID: vJkMa5g9SqKxmX8ulWeWLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="48349454"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.105.241])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 13:54:26 -0700
Date: Mon, 8 Jul 2024 13:54:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v13 6/8] cxl/list: collect and parse media_error
 records
Message-ID: <ZoxSAC5XV9kTNwy+@aschofie-mobl2>
References: <cover.1720241079.git.alison.schofield@intel.com>
 <d267fb81f39c64979e47dd52391f458b0d9178e2.1720241079.git.alison.schofield@intel.com>
 <OSZPR01MB64538FDD3908A8A2CBBEDD938DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSZPR01MB64538FDD3908A8A2CBBEDD938DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>

On Mon, Jul 08, 2024 at 02:07:41AM +0000, Xingtao Yao (Fujitsu) wrote:
> > +/* CXL Spec 3.1 Table 8-140 Media Error Record */
> > +#define CXL_POISON_SOURCE_MAX 7
> > +static const char * const poison_source[] = { "Unknown", "External", "Internal",
> > +					     "Injected", "Reserved", "Reserved",
> > +					     "Reserved", "Vendor" };
> it might be better to use "Vendor Specific" instead of "Vendor".

I see that "Vendor Specific" would be an exact match with the spec, so yes,
I'll change that. Thanks for pointing out.

--Alison

> 
> Reviewed-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>
