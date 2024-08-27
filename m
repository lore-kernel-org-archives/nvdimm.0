Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8A61BD510
	for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764934; cv=none; b=a7rv7eFwloXjyghTSEBPDMlxnOsYvGjqdO76cLS7X+GSqTlCZPiPT60Yns1dIGSnbZflCmI2tKg1gSTSi3nvZrullrLeKR+oLVv/xQugnrELViB06lZqCsD+MQowzG10KUnEN40mO5BMKqW9kIuuqnEC4NuLWlsRs4J1bsXuDwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764934; c=relaxed/simple;
	bh=mmintB9ndCfunLcL05i0iSaGGs9dzvdyankk1KB3g3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spPtt2KiiSbjREgyPjKnNecTac9fpmPKF5iGJ9QsDL96vzxwI2QowL8pZujZAdLbADAuQ9i8E6wK8cnX5rRqy/PnGWBQ7/zfRO1CMm2PiwbnZOnHORcrwCn6eMz3e1IgHkeNxfY6Sh79np6Gn7g56VrnJJcNYIW9m99IKYh0q/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PIN8vPGx; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIN8vPGx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724764933; x=1756300933;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mmintB9ndCfunLcL05i0iSaGGs9dzvdyankk1KB3g3Q=;
  b=PIN8vPGxgRYjR+zKpMCKwz77X5D7CyQX+eiP8uCm86fPdKsF2PVneOZ7
   tpohuVAKelI9kYYwpmRl0c4Dui1HoCJje0P19fILBD5L9E/JBzPu73CNk
   VB6JTI8kzgNITL0YgOKEfCexL5T4rPWES+aolmcNsGBzHXDACN/G8LIMK
   /p1YkzxW2Np+CPp0fKqOkdpsl70ogotF4Jq+I3cOF3KTYZOSQZCkt/YVB
   mvTLM/uh7kSzBGReaK8RtdExgpCtpDjStlKt9zOepAlD8NXbiSGa7MzGw
   /Y2GohRlZJihB15OkxLbG0nw1MgQf6gZPapNrv5dCnNTr3w0MNgjs22us
   A==;
X-CSE-ConnectionGUID: Ys5gUXGkS+m6/Z/h0oo5eg==
X-CSE-MsgGUID: +y7HNooxQNCIc3NzNC80JQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="45759080"
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="45759080"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 06:21:30 -0700
X-CSE-ConnectionGUID: v2v1nDK8QJ2yR5gnvtj3PA==
X-CSE-MsgGUID: plyR9erVT++yURG7ogCnRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,180,1719903600"; 
   d="scan'208";a="62837678"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 06:21:25 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1siw8O-00000002Gxk-3W05;
	Tue, 27 Aug 2024 16:21:20 +0300
Date: Tue, 27 Aug 2024 16:21:20 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 02/25] printk: Add print format (%par) for struct range
Message-ID: <Zs3S0J6xus82y9jh@smile.fi.intel.com>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-2-7c9b96cba6d7@intel.com>
 <ZsSjdjzRSG87alk5@pathway.suse.cz>
 <66c77b1c5c65c_1719d2940@iweiny-mobl.notmuch>
 <Zsd_EctNZ80fuKMu@smile.fi.intel.com>
 <ZsyB5rqhaZ-oRwny@pathway.suse.cz>
 <Zsy6BbJiYqiXORGu@smile.fi.intel.com>
 <66ccf10089b0_e0732294ef@iweiny-mobl.notmuch>
 <Zs2DhzbLK_LU6B0a@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs2DhzbLK_LU6B0a@pathway.suse.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Aug 27, 2024 at 09:43:32AM +0200, Petr Mladek wrote:
> On Mon 2024-08-26 16:17:52, Ira Weiny wrote:
> > Andy Shevchenko wrote:

...

> But I could live with all other variants, except for %pn mentioned below.

I believe %r is also no go as we most likely get a complier warning.

...

> > Am I missing your point somehow?  I considered cramming a struct range into a
> > struct resource to let resource_string() process the data.  But that would
> > involve creating a new IORESOURCE_* flag (not ideal) and also does not allow
> > for the larger u64 data in struct range should this be a 32 bit physical
> > address config.
> 
> This would be nasty. I believe that this is not what Andy meant.

You are right, this is not what I meant.

-- 
With Best Regards,
Andy Shevchenko


