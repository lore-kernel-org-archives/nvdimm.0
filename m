Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA59D29CA
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641588439; x=1673124439;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=EwJKm/cfMNOSUAQYjxrqkuKRTPRHV1fvwr0IyL7FZnQ=;
  b=b3816tmgnZpPnXh3yLgsCSuWcPsVa2cj++B691nJfPwSj09Jd2LYmbbw
   hCLRKSa+C9R61Ee/u1HtVz7cDQOqMgOeMhuk1s6os2uf68tkU+PWLSHhh
   CrZstd90NOaWXTsXPjUKtbXlMch6MUyi06dmKveriyUsQnohoNug622tr
   D0xKLy9EVOb91a/nFhuGL4/3pssRn1eBGVRW56B8rH2BOLgz4ULYg3mHL
   EdMyI9+B+9ERz8hTsXdVhsEVSUQ9JR1oDfal1Fo/YsQOIx6F8EilHVOek
   aBNLl+bscfPw4u4NsouORFT5R3G94Hsrzy//eTyZLBTj6+AiVMolzOt3N
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="243138243"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="243138243"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:47:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="612294581"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:47:18 -0800
Date: Fri, 7 Jan 2022 12:52:28 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 4/7] cxl: add memdev partition information to
 cxl-list
Message-ID: <20220107205228.GF803588@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <78ff68a062f23cef48fb6ea1f91bcd7e11e4fa6e.1641233076.git.alison.schofield@intel.com>
 <20220106204905.GE178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106204905.GE178135@iweiny-DESK2.sc.intel.com>


On Thu, Jan 06, 2022 at 12:49:05PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:15PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> 
> "Users will want to be able to check the current partition information.  In
> addition they will need to know the capacity values to form a valid set
> partition information command."
>

I do see the pattern you are after. Problem statement separate from
solution statement. Will reword.

> > Add information useful for managing memdev partitions to cxl-list
>      ^
>    "optional"
> 
> > output. Include all of the fields from GET_PARTITION_INFO and the
> > partitioning related fields from the IDENTIFY mailbox command.
> > 
> 
> "Sample output for this section is:"
> 
> >     "partition":{
> >       "active_volatile_capacity":273535729664,
> >       "active_persistent_capacity":0,
> >       "next_volatile_capacity":0,
> >       "next_persistent_capacity":0,
> >       "total_capacity":273535729664,
> >       "volatile_only_capacity":0,
> >       "persistent_only_capacity":0,
> >       "partition_alignment":268435456
> >     }
> > 

snip

> > +	if (jobj)
> > +		json_object_object_add(jpart, "partition_alignment", jobj);
> > +
> > +	return jpart;
> > +
> > +err_cmd:
> 
> Doesn't this need to be called always, not just on error?

cxl_cmd_unref(), sure does. Thanks for the catch!

> 
> Ira
> 
