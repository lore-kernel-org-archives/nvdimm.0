Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36672FD1C1
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762764665; cv=none; b=ZnZFwcrFMp7rnxt8g4OO/a5XaUoD835E0D8QRIs4I8YdYWpQYOXQfD7+SC4tFynXN4OOfOLDqZR5RT3I50upYY9MaO8LhoZLIkF+K3r4TYtUppFYuf/hJ4J4tD9uqfWKs4AG/oWACtBg32okP/0lnaYePF0O5mEGxbEZOTpgcK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762764665; c=relaxed/simple;
	bh=HICpxDEAAop30JD/2xaSQaJSlMCODSC3b+mqQGoAk4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KKJ6Tot/hDwQxgJp31nnZu3dSsWiZZ2tL+bQM9g6hi1GOAbJ6xV1H/xRb7hAqZxfhBVYXknHznE6RKrmXbJA0SWm2p9CFXedIDbDHnqb966zo3iYe4J3PTS/SHepLpmUPma4rwV9ODcKVNUXJ6fNAH/4ESl7ABwodfDRlNJYuw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IxamUy5f; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IxamUy5f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762764664; x=1794300664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HICpxDEAAop30JD/2xaSQaJSlMCODSC3b+mqQGoAk4s=;
  b=IxamUy5fYmqQHBFASjsM/Iz4uqkwJlF3Upp7T/Bup5HBt9T49MLE7JrX
   /2A9F2arvEvP5U1h141tSBBriRG5Vzoe7GjMd8HBrbn3debJn052uWCAP
   UErhhiaHq73f8UELEfmipqbffRnOgTpItThjMmb1mAbbOSeaHvek9tBn7
   PBycv+0ibFEDlEPReVqm2Se/URSZFTr6r7HUGSkacZkAAD65/Bhr7Gp1k
   ltRj9HTx0/hB/RhS26eKkq9RIIzPeGJJFFfZHHOenC09eg0VU5YO/38TR
   qkyjYPgpgbzA6kqMBsbLosjjA2sWRa1euyGG9KlKl1IEt69r7+MgsDYFr
   g==;
X-CSE-ConnectionGUID: KrRfAOR+QISAxvaR0c5RWQ==
X-CSE-MsgGUID: voeg2o/GTviZWXBSLbREeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="75105363"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="75105363"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 00:51:04 -0800
X-CSE-ConnectionGUID: xf658jH4TyiUTDsVG8IFOg==
X-CSE-MsgGUID: RYBkIJePSzGsqkovY4YVUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="193801340"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.235])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 00:51:02 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vINc3-00000007PI0-0nu9;
	Mon, 10 Nov 2025 10:50:59 +0200
Date: Mon, 10 Nov 2025 10:50:58 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <aRGncoEEcbq_D6mV@smile.fi.intel.com>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
 <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
 <aQ2iJUZUDf5FLAW-@smile.fi.intel.com>
 <690e1d0428207_301e35100f6@iweiny-mobl.notmuch>
 <aRERqoS2aetTyDvL@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRERqoS2aetTyDvL@aschofie-mobl2.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Sun, Nov 09, 2025 at 02:11:54PM -0800, Alison Schofield wrote:
> On Fri, Nov 07, 2025 at 10:23:32AM -0600, Ira Weiny wrote:
> > 
> > Yea putting this in the commit message but more importantly knowing you
> > looked through the logic of how claim class is used is what I'm looking
> > for.
> 
> Coming back around to this patch after a few days, after initially
> commenting on the unexplained behavior change, I realize a better
> response would have been a simple NAK.
> 
> This patch demonstrates why style-only cleanups are generally discouraged
> outside of drivers/staging. It creates code churn without fixing bugs
> or adding functionality, the changes aren't justified in the commit
> message, it adds risk, and consumes limited reviewer and maintainer
> bandwidth.
> 
> To recoup value from the time already spent on this, I suggest using
> this opportunity to set a clear position and precedent, like:
> 
> 	"Style cleanups are not welcomed in the NVDIMM subsystem unless
> 	they're part of a fix or a patch series that includes substantive
> 	changes to the same code area."

Let's rotten it with the old APIs and style then :-)

I have heard you and I won't try even bring any new patch in this subsystem, thanks.

> FWIW, if folks are looking to dive into this code, there is a patchset
> in review here[1] that adds new functionality to this area. Reviews,
> including style reviews, are welcomed.
> 
> Regardless of a commit message update or a change to the code, this
> one is a NAK from me.
> 
> [1] https://lore.kernel.org/nvdimm/20250917132940.1566437-1-s.neeraj@samsung.com/

-- 
With Best Regards,
Andy Shevchenko


