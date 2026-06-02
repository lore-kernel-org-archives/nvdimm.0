Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8F38B122
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 21:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780437535; cv=none; b=b8VGlJ5yzzZ3C731pbaZa7kUax4cPeazrJy3UyV6P4E7bwvVOft9YnHNZPCSwEIXwYSQfczqRcUfIJI6uBkVIemSax/i6ZxCfi5rHBUyD6yzhpTyRrpl4pL1g5S9DPm06M0Qf0Q5NWczhgYke1fDs+E2g4zXp1pWoJlKkd3VjAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780437535; c=relaxed/simple;
	bh=lNy4OD9Hyui7+ARYdd9IyIqNHVlY1wQRJPb6kguiFcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpErt3PyXrtHN5nBvSk8CaXL5+/uXwI90HNMsf4AGysRuH2+4vHLLjeCu25N2GGvefEnr1ZH18SDbW+AM7oKk1bXoxZk9SJxkimvuA5h3uFCtnCMYCD2ywCqznanSqcy/lHgh5JGI0md4kemeX9sXESp43It7zOIfZLrcRYhLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYNYy6De; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYNYy6De"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780437535; x=1811973535;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lNy4OD9Hyui7+ARYdd9IyIqNHVlY1wQRJPb6kguiFcI=;
  b=bYNYy6DenQmibd184gy309DYHMHwjWYvHZTXDlK7bSrjzpoTIhKrZyoJ
   3jDItJOsf1I1bR9E04I48smfD5NA5VlsswveJLWPt1b81hsByd5lOMM7P
   A2sFtyu5AJ6IhUajRO7DGakjJQWZAtAHDlh2yurEHJHDLbqtu2Yij5sWO
   1uhk8j/Bd+BdtjBfEnbtHsNvVWrTRmHrw8oacseERoYAt5VSI9UTQj+40
   Fey9I0MG+Qg4iffh1k2o7g0dHnfDgR5DDaIk8suCJV7NHyrflQiDL1+Fy
   JAWd9bn5uS0trC6qMhcrfj6Q1mNLJRijr10dZ8SzeCM1fq/Wr//Dv8Q3I
   Q==;
X-CSE-ConnectionGUID: da6zUwyyT4qhh8yyG9QIQA==
X-CSE-MsgGUID: VEsGiND0RgmQJX5veo4CXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="80973649"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="80973649"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:58:54 -0700
X-CSE-ConnectionGUID: IG+QdlJ5TlK0+C4nKDLCdg==
X-CSE-MsgGUID: 9clSxAXFQ5mnHp1Pm9/Kgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="245838734"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.116])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:58:51 -0700
Date: Wed, 3 Jun 2026 00:58:49 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans de Goede <hansg@kernel.org>, Armin Wolf <w_armin@gmx.de>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v1 01/17] ACPI: bus: Introduce
 devm_acpi_install_notify_handler()
Message-ID: <ah9SGXfJv2fz22Yl@ashevche-desk.local>
References: <4739447.LvFx2qVVIh@rafael.j.wysocki>
 <2268031.irdbgypaU6@rafael.j.wysocki>
 <ah8l-p0Ih9tzu0G1@ashevche-desk.local>
 <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0i0bKHa28xoVRiy_7i_PgjqYD_TA0yRoofmjH1oHGQuQA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jun 02, 2026 at 10:57:23PM +0200, Rafael J. Wysocki wrote:
> On Tue, Jun 2, 2026 at 8:50 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Thu, May 21, 2026 at 03:59:50PM +0200, Rafael J. Wysocki wrote:

...

> > > +     acpi_dev_remove_notify_handler(ACPI_COMPANION(dev), dr->handler_type,
> >
> > acpi_dev might be also part of the same data structure, so you won't need to
> > take dev again and derive adev from it.
> 
> I'm not sure what you mean.
> 
> Put acpi_dev into struct acpi_notify_handler_devres?

Yes.

> > > +                                    dr->handler);

...

> > > + * devm_acpi_install_notify_handler - Install an ACPI notify handler for a

> > > + *                                 managed device
> >
> > There is a stray space just after asterisk.
> 
> Which asterisk?

The line above has "<space>*<space>(sic!)<tab><tab> ... managed device".
The <space> after the asterisk is a stray one.

...

> > > +             return dev_err_probe(dev, -ENODEV, "No ACPI companion in %s()\n", __func__);
> >
> > Not sure how __func__ may help here. We will have a device instance to be
> > printed. It's obvious then how to find the culprit call.
> 
> But it doesn't hurt either, does it?

From my p.o.v. it's just extra information that's not needed. But I'm not going
fight to death against it.

...

> So thanks for the review, but I don't think I want to send a v2 at this point.
> 
> I'd rather send a follow-up patch to clean up these things.

Okay!

-- 
With Best Regards,
Andy Shevchenko


