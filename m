Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846561B6D18
	for <nvdimm@lists.linux.dev>; Tue, 18 Feb 2025 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896450; cv=none; b=gxSEDiKsQ+hMXEwadF777/PqkQadUTZhifRkPuRXExdNsG2ZwQtcnz1cHg7TrxDDPA5X4jn/+s7oSXhSGYpIq1nDb/jSwlEkQcr1rRLgMMU7/pbFWHl1ygEvzCr090PGveddW/NOx+gt++WOQjbsXe09qF15yk4VeIeuZ2UU4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896450; c=relaxed/simple;
	bh=xoVcHjCHFexyXEFyEN/LYa1+7oUe3rSEcC8Pt+x9MAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDGdyQ/va/kzu60ZOSiiA648Ghwz+fi9BecpFTYDZ1nNSiPznpXv0tu7/sBH5xcLtP1taYhP7vt+3eHBW55Cf4nM2Kkv9dbdN6ByuIGzi86e2qTZH1hYeZ+U5lNEgCNrCUo7GRwMwr0XequYJ+gbfYrnopBUGzHor/RqDy+oB4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibpJhwoH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibpJhwoH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739896448; x=1771432448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xoVcHjCHFexyXEFyEN/LYa1+7oUe3rSEcC8Pt+x9MAE=;
  b=ibpJhwoHafrqFF0AqEAuXkUtDAR5zy0sYgcs0PhYaWW6Rs94TdYAMUMq
   T8TB6/lm5tepspvykNaFH9Qhxqd46Xfrc6/teOZ8JPupzO0aTG/cEKOWW
   oMHx7/P8UpvcGmND2GOIWePAAG9U8Yf4rp/6Q8iVNGEc7dO23SZrrgk2Z
   ujV1h4EdFF/KH4jMf1+DhDr3t5QxHsQfePPPyj+VI7de2Q7HKqhyuVcK5
   JETJXtmZ/uoqGHFvbLz3i4wXG3DResTWKznQOOEudQ7Z8omRbmvme/HI4
   a65QDT1GmkEISZV37iV6iumkHPxigknXJBBZA/CnEL74G1NBO4U0QlOb+
   w==;
X-CSE-ConnectionGUID: oq0CrhCuTFODKL7UL2hd2A==
X-CSE-MsgGUID: uNlZGlwzSs20rJO5tWm+sw==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="65957671"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="65957671"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 08:34:07 -0800
X-CSE-ConnectionGUID: y9OGBqXvTNORWViXIZ0N8A==
X-CSE-MsgGUID: 9MNIg/e7SXCwllOynhtxyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="119656513"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.109.195])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 08:34:04 -0800
Date: Tue, 18 Feb 2025 08:34:03 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: vishal.l.verma@intel.com, y-goto@fujitsu.com, dave.jiang@intel.com,
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <Z7S2e0Bi7OMUviWo@aschofie-mobl2.lan>
References: <20240928211643.140264-1-dave@stgolabs.net>
 <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
 <f6ybfabcft5wcpx2wuoxf3qgwset3h4nhngn5c4jk6ssudl5gj@o2ssocnihy6t>
 <ngnoxz6w6q3y6korof6mepzvw2jyx4trlii7zon5jcoafobbfp@4z5ld55qgvqy>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ngnoxz6w6q3y6korof6mepzvw2jyx4trlii7zon5jcoafobbfp@4z5ld55qgvqy>

On Mon, Sep 30, 2024 at 02:39:33PM -0700, Davidlohr Bueso wrote:
> On Mon, 30 Sep 2024, Davidlohr Bueso wrote:\n

Hi David,

Checking on patches we noted as needing review in last months collab,
and now I'm thinking this one is pending a v2 from you. Is that right?

--Alison

> 
> >     cxl sanitize-memdev -e mem0 <-- secure erase
> >     cxl sanitize-memdev mem0 <-- sanitize
> 
> Not related to this patch (I will post v2), but just for future reference, and
> perhaps someone has thoughts. Whenever the kernel supports Media Operation
> (4402h in 3.1), I see this utility expanding to something like:
> 
>       cxl sanitize-memdev --zero A1-A2 [B1-B2 C1-C2] <-- zero-out ranges
>       cxl sanitize-memdev --zero mem0 <-- internally use all the mem0 range
>       cxl sanitize-memdev A1-A2 [B1-B2 C1-C2] <-- sanitize ranges
>       cxl sanitize-memdev -e A1-A2 [B1-B2 C1-C2] <-- error
> 
> ... and perhaps the kernel would need a security/zero as well as a
> security/{sanitize_range,zero_range} set of files.
> 
> Of course the underlying memdev for the specified ranges would still need to be
> offline entirely, just as is now.
