Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B982FE0C
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIW4gGvt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700238103; x=1731774103;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qXieTkKvKgzXEmI4Qca10WkoRHAlM77qqndTUqjqj8Y=;
  b=PIW4gGvt2jAIdgm5vzplwxdv50t2QYwO9CGGrqFlwVUcg7EtmRtb8t63
   fux1puBzRZSOBq0qAKwpi47ISQyrhDyBa2+quFg5wgEYYtpAL8ldn/MHR
   ykZaDv22Obhkf5p4Fp6BZW0WMk8FuoG+KrnQhgerP3HH0zt4lRh3kQhSW
   DzAg9WryislrYSc6uTLFzDsjBsYK8y6xT+uZkx3iyCJRhy4BjHZ1NaC/w
   Oe/3KO7aiEW5XTxCY2NukJ762wGg0kjCLwrNXGdWSrik0MQDUnnRLdv4S
   pjiyOqUzw9FiccPJwzwwkJVjbkS4kCxzzjO1jPWDc3VtONJBykrdctV+y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="455627180"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="455627180"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:21:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="13530604"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.86.159])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:21:07 -0800
Date: Fri, 17 Nov 2023 08:21:05 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 1/5] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <ZVeS8SOzxCqnNfIZ@aschofie-mobl2>
References: <cover.1696196382.git.alison.schofield@intel.com>
 <f59b7ae3277342f54bbcf409ac075a9c122ecd79.1696196382.git.alison.schofield@intel.com>
 <9341c2e5f120cebe139125fccfda48d2b9f9c008.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9341c2e5f120cebe139125fccfda48d2b9f9c008.camel@intel.com>

On Wed, Nov 15, 2023 at 02:08:03AM -0800, Vishal Verma wrote:
> On Sun, 2023-10-01 at 15:31 -0700, alison.schofield@intel.com wrote:

snip

> > +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> > +{
> > +       struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > +       char *path = memdev->dev_buf;
> > +       int len = memdev->buf_len, rc;
> > +
> > +       if (snprintf(path, len, "%s/trigger_poison_list", memdev->dev_path) >=
> > +           len) {
> 
> I see this unfortunate line break Jonathan commented on still crept in,
> agreed that breaking up snprintf's args would look better.

Fixed up in v3.
Thanks!


> 
> 
