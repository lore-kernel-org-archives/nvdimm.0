Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B6168
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 22:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641595605; x=1673131605;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=PLbe2U12s+p3QaQLSUDB0vGbPz4PjL9pp6ut+sJNQyE=;
  b=hey/3VmNnrGF0jmdqMZfzJDHuwxp8eQobt9ldhPdY+JbNylQXmi54Dqh
   J1GWyKV/Smm4ysxOWGCqdFsGve1NDI7qvEtylNrc4n6ycztkVfFwTc3dd
   cam0qJwCVJcXte095vDml4y00LHblgKjH0whURlXvO+c6pG3ljbA3bRbh
   m2GvBUHWY0R8OXgZtHsF5KNKodv3ZIitg2b7r90qGGZdysahYvri3Urud
   CaGTPrnN0LRGUIcoItYKAXLvwpgHu9imvvPrTcHWWl1/1wbW+Dqj0U2sL
   lsNultZEyV582/oXOFt7Xeg+i0GjgzrrgkW9PcD7IqLI3xbVhQ0LvCUKR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242754819"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242754819"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:46:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="591840552"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:46:32 -0800
Date: Fri, 7 Jan 2022 14:51:41 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
Message-ID: <20220107225141.GC804232@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
 <20220106210526.GH178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106210526.GH178135@iweiny-DESK2.sc.intel.com>

On Thu, Jan 06, 2022 at 01:05:26PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:18PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> 
> "User will need a command line option for setting partition info.  Add
> 'set-partition-info' to the cxl command line tool."
> 
> > The command 'cxl set-partition-info' operates on a CXL memdev,
> > or a set of memdevs, allowing the user to change the partition
> > layout of the device.
>                 ^^^^^^
> 		device(s).
> 

Got it. Thanks!

> > 
snip

> 
> Did I miss the update to the cxl-list command documentation?
You must've blinked ;)
See Patch 4 - cxl: add memdev partition information to cxl-list

> 
snip
>
> > +
> > +	rc = cxl_memdev_set_partition_info(memdev, volatile_request, 0);
> 
> CXL_CMD_SET_PARTITION_INFO_NO_FLAG?

Yeah...I couldn't get to that at the last minute. 
Will figure that out and use it here.
Thanks!

> 
> Ira
