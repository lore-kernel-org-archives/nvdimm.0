Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D5A3FE3
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 17:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646240956; x=1677776956;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ARu95SNjYvUW6s+dQ5hSBTaIXLn2LgPc0xfUHeJLPZ8=;
  b=bf9F9WgAoG2pQ42jr2jO6XYUdvWctKZJFMLdzp6cIcS6ixXLoLSq+vG7
   hDlNZ2X2w5FO363H4wLdQhgKJYPXHJsXipxGqFEfio37/Z2Flm+QSvdCk
   gKGk+SgYI/qy2g1cEmzSciCxKqCsnSc+RWXW0U89VHNZuqtcGVBvsfFCw
   xgRz9v00D6Ux+6wfRXuyO7azS0uwRlthNrptwWzXAQxkAu9z5Gqjs6RDv
   Oxn2RUdAbRH44eQJ/kwoZYmOMiasjdTu8YRPwlwPDpMUfAhqt2KZWZXI5
   pA0l5I05ItA4o30PSX0c0FPP2UiiuATumHWZEjqikAJMFWxTNmB4yu2jf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="233420753"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="233420753"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:09:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="511078765"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:09:12 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1nPSSf-00APUi-LB;
	Wed, 02 Mar 2022 19:08:25 +0200
Date: Wed, 2 Mar 2022 19:08:25 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hui Wang <hui.wang@canonical.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	nvdimm@lists.linux.dev, Len Brown <lenb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v1 1/1] ACPI: Switch to use list_entry_is_head() helper
Message-ID: <Yh+kiSMZPleBcOXh@smile.fi.intel.com>
References: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com>
 <Yh+SHs4CEWkiLxAe@smile.fi.intel.com>
 <CAJZ5v0g_3a7A5aFab6ZsM8nPDmivoTeNgdSG17Lt71mFKmNxmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0g_3a7A5aFab6ZsM8nPDmivoTeNgdSG17Lt71mFKmNxmg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Mar 02, 2022 at 05:36:20PM +0100, Rafael J. Wysocki wrote:
> On Wed, Mar 2, 2022 at 4:50 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Fri, Feb 11, 2022 at 01:04:23PM +0200, Andy Shevchenko wrote:
> > > Since we got list_entry_is_head() helper in the generic header,
> > > we may switch the ACPI modules to use it. This eliminates the
> > > need in additional variable. In some cases it reduces critical
> > > sections as well.
> >
> > Besides the work required in a couple of cases (LKP) there is an
> > ongoing discussion about list loops (and this particular API).
> >
> > Rafael, what do you think is the best course of action here?
> 
> I think the current approach is to do the opposite of what this patch
> is attempting to do: avoid using the list iterator outside of the
> loop.

OK, let's drop this change.

-- 
With Best Regards,
Andy Shevchenko


