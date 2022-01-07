Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA32CA1
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641587010; x=1673123010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rxrhjotZlnaVpdS0AlmIFNYo3EwfFDwqHBWA/soSYBA=;
  b=gX13IYJTiFT2vNiE6U9YUp7tshVP5FeRp3tHux5LPP7oFs+czqRZ7Rr4
   xGZVzlXGxKsOMkSS+4VZRcisLFHB/IWaXa77o/FdI3k7RjjauuSDpDIf4
   mBVdNpnPpqjzFlDdfMgZTkGuhhX97ZgIGHqRLNVPIuN6OzSmMrlGhpLrV
   PYF1+bTH/rNag6pg8owrdYzyZeLzCpqbn3gAX0OHRsy47R8Udhmuq1UI6
   wuaS18dvrls8/T3RsiHXabIglQDXEtwBBHvlMwGGkPMpE1G7NwEgyZU5G
   R1KpRlWKZW/NAUMTMw7eLTftNMZS6mB1vdkwQZv30Di5b9xlQbCto2Gms
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="230278246"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="230278246"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:22:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="668875052"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:22:20 -0800
Date: Fri, 7 Jan 2022 12:27:30 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"Widawsky, Ben" <ben.widawsky@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Message-ID: <20220107202730.GD803588@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
 <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
 <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
 <a964f28b2541168b94ed732f658980fc87954391.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a964f28b2541168b94ed732f658980fc87954391.camel@intel.com>

On Thu, Jan 06, 2022 at 01:57:59PM -0800, Vishal Verma wrote:
> 
> Just one nit here about the double verb 'get'. In such cases,
> get_partition_info can just become 'partition_info'
> 
> e.g.: cxl_cmd_partition_info_get_active_volatile_cap(...
> 

Will do - thanks Vishal!

Combiningg w Ira's feedback, it'll be:
cxl_cmd_partition_info_get_active_volatile_bytes(...

> >
> 
