Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46A47A
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 15:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646236245; x=1677772245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D1uiCJhxBtjA4oR6+KrFSQrnollkmcJKddeu5cuEKpA=;
  b=NOMHmvMMm/eXUeh8uOrm0K+SQH7Jfy8/ETAWfbc/yIwjh9vFXyJ9C7GM
   9LxdeCibf85NrJfZSR9IESvrjDffk8wYcXBktIJECAjazMMyhj7Ia+Hw/
   H9GBaK6tzByBpKI5Ribta9g1V7jjilyRJ2q9wPWcA0K+CX7KChUuFsYj2
   ddUrDYhZ2W/2C1qhRRBHBxKFlO7669Jl5QeS0rwaFh19Mz59NDS97NN5w
   utg1guIBZKwTyvITiEdQAsSh3MXdWQRZeFdGwn6TgoihwAgPa6M/hDn45
   UVtNmtY9iSiBHl8VOPOlU6fi2j6HoTDJuqIfvb51gNU4Qfmwpx4QeR5m8
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="234048576"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="234048576"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:50:40 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="709553789"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:50:37 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1nPREc-00AMq2-Dc;
	Wed, 02 Mar 2022 17:49:50 +0200
Date: Wed, 2 Mar 2022 17:49:50 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hui Wang <hui.wang@canonical.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v1 1/1] ACPI: Switch to use list_entry_is_head() helper
Message-ID: <Yh+SHs4CEWkiLxAe@smile.fi.intel.com>
References: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Feb 11, 2022 at 01:04:23PM +0200, Andy Shevchenko wrote:
> Since we got list_entry_is_head() helper in the generic header,
> we may switch the ACPI modules to use it. This eliminates the
> need in additional variable. In some cases it reduces critical
> sections as well.

Besides the work required in a couple of cases (LKP) there is an
ongoing discussion about list loops (and this particular API).

Rafael, what do you think is the best course of action here?

-- 
With Best Regards,
Andy Shevchenko


