Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D1173
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 19:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641585057; x=1673121057;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=TbrSIOX+KFbOuadh3uaV5XYoKdWfz8KB2vx65GzLMT0=;
  b=aAb963FsM05Na/j8YlciIVOTdYoiF31NwxAkd+bqi+SIkmD66/Yrksav
   iUw+uaP6cEBUlP0OXQYRf+Q3/HX23mfSvSiTo/On2xEr06ZdibmJJAVbP
   Mm47k2Kem2BGZFBGByDa7SEmbz7SkYicqecnDW6J0ToDqy6ZtSIWmSrOm
   UmBb8J1w3u52BsmhOihbMlA/d9cEPqIV/2NBCP2lGhjdUrUFiBTC9g5Gz
   rHURXSflbuBCW2BjndNV+Ro8aEky88t1E7NJjTH7ZaNvO2P0GUc/kVuks
   YG1JL0jIeHMJJPpgEkdkfz4EpWeTishgU85DDJAEm2ff2HSlx4eRqWp5f
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="243129455"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="243129455"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:50:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="557363951"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 11:50:55 -0800
Date: Fri, 7 Jan 2022 11:56:05 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Message-ID: <20220107195605.GB803588@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
 <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>

Thanks for the review Ira!

On Thu, Jan 06, 2022 at 12:19:07PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:12PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command, the
> > command output data structure (privately), and accessor APIs to return
> > the different fields in the partition info output.
> 
> I would rephrase this:
> 
> libcxl provides functions for C code to issue cxl mailbox commands as well as
> parse the output returned.  Get partition info should be part of this API.
> 
> Add the libcxl get partition info mailbox support as well as an API to parse
> the fields of the command returned.
> 
> All fields are specified in multiples of 256MB so also define a capacity
> multiplier to convert the raw data into bytes.
> 
Will do. Thanks.

> > 

snip.
 
> I also wonder if the conversion to bytes should be reflected in the function
> name.  Because returning 'cap' might imply to someone they are getting the raw
> data field.

Agree. Will s/cap/bytes

>

Some additional comments were addressed by Dan & Vishal responses.

