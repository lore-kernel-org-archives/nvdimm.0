Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971932CA1
	for <nvdimm@lists.linux.dev>; Thu, 27 Jan 2022 05:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643261992; x=1674797992;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EokrHqfA7vWfvlxb+/FaHr7Z5GBS3hJ/BD9JQb4yPVQ=;
  b=CFvyVsr4E7LvJOmVLe6WCy9Rkck2A81A7oYMwcLuSkRH/nZHUb6J+83O
   jW+76cSs7jZb62Z6JnoQDSuU73J/TAFie3U5ydK3iuuFQFSEDsAuOuOaT
   Qr8EqH+YQF18zjZQq3RlPR45/eab3/PIPMchrOIOdTobz4GI+C6ZdF9E/
   zsKrBbEbXmyF7Hr78aGS2WBFeq0FHzJe6Ti7+CvvC8sZ4VqvSXLWvog9j
   tu6+qgFip75d22Be7SHKZDnAcx9YaA6bbXHC9+p54MDpVGsWF/ijyYfYk
   Qkk3nXCuhyzNDDmHnj9qx7Gllg8iWVZ1ikjrLs/MvRbS2QaR5dXGqTSCl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="310068906"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="310068906"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 21:39:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="769615312"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 21:39:51 -0800
Date: Wed, 26 Jan 2022 21:44:21 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 6/6] cxl: add command set-partition-info
Message-ID: <20220127054421.GE890284@alison-desk>
References: <cover.1642535478.git.alison.schofield@intel.com>
 <d8760a4a0ca5b28be4eee27a2581ca8c2abe3e49.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4gx+mvAPEmYstUXAsjWY=Aq7zb4y4V+QGzwnauk1F8DEw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gx+mvAPEmYstUXAsjWY=Aq7zb4y4V+QGzwnauk1F8DEw@mail.gmail.com>

On Wed, Jan 26, 2022 at 05:44:54PM -0800, Dan Williams wrote:
> On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
> >
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Users may want to change the partition layout of a memory
> > device using the CXL command line tool.
> 
> How about:
> 
> CXL devices may support both volatile and persistent memory capacity.
> The amount of device capacity set aside for each type is typically
> established at the factory, but some devices also allow for dynamic
> re-partitioning, add a command for this purpose.

Thanks!
> 
> > Add a new CXL command,
> > 'cxl set-partition-info', that operates on a CXL memdev, or a
> > set of memdevs, and allows the user to change the partition
> > layout of the device(s).
> >
> > Synopsis:
> > Usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]
> 
> It's unfortunate that the specification kept the word "info" in the
> set-partition command name, let's leave it out of this name and just
> call this 'cxl set-partition'.
> 
Will do. 

> >
> >         -v, --verbose           turn on debug
> >         -s, --volatile_size <n>
> >                                 next volatile partition size in bytes
> 
> Some users will come to this tool with the thought, "I want volatile
> capacity X", others "I want pmem capacity Y". All but the most
> advanced users will not understand how the volatile setting affects
> the pmem and vice versa, nor will they understand that capacity might
> be fixed and other capacity is dynamic.

I went very by the spec here, with those advance users in mind. I do
think the user with limited knowledge may get frustrated by the rules.
ie. like finding that their total capacity is not all partitionable
capacity. I looked at ipmctl goal setting, where they do percentages,
and didn't pursue - stuck with the spec.

I like this below. If user wants 100% of any type, no math needed. But,
anything else the user will have to specify a byte value.

> So how about a set of options like:
> 
> -t, --type=<volatile,pmem>
> -s,--size=<size>
> 
> ...where by default -t is 'pmem' and -s is '0' for 100% of the dynamic
> capacity set to PMEM.
>
I don't get the language "and -s is '0' for 100%", specifically, the
"-s is 0".

If -s is ommitted the default behavior will be to set 100% of the
partitionable capacity to type.

If both type and size are ommitted, 100% of partitionable capacity is
set to PMEM.

Humor me...are these right?  

set-partition mem0
	100% to pmem

set-partition mem0 -tpmem 
	100% to pmem

set-partition mem0 -tvolatile -s0
	100% to pmem          ^^ That's what I think a -s0 does?!?

set-partition mem0 -tvolatile
	100% to volatile

set-partition mem0 -tvolatile -s256MB
	256MB to volatile
	Remainder to pmem

set-partition mem0 -s256MB
	256MB to pmem
	Remainder to volatile

Thanks!

> The tool can then help the user get what they want relative to
> whatever frame of reference led them to read the set-partition man
> page. The tool can figure out the details behind the scenes, or warn
> them if they want something impossible like setting PMEM capacity to
> 1GB on a device where 2GB of PMEM is statically allocated.
> 
> This also helps with future proofing in case there are other types
> that come along.
> 
Got it.

> >
> > The included MAN page explains how to find the partitioning
> > capabilities and restrictions of a CXL memory device.
> >
snip

> > +-------
> > +<memory device(s)>::
> > +include::memdev-option.txt[]
> > +
> > +-s::
> > +--size=::
> 
> This is "--volatile_size" in the current patch, but that's moot with
> feedback to move to a --type + --size scheme.

Got it.

> 
> > +        Size in bytes of the volatile partition requested.
> > +
> > +        Size must align to the devices partition_alignment_bytes.
> > +        Use 'cxl list -m <memdev> -I' to find partition_alignment_bytes.
> 
> This a static 256M, that can just be documented here.
> 
My read of the spec says partition alignment is "Expressed in multiples
of 256MB", not static. Where is it defined as static?

> > +
> > +        Size must be less than or equal to the device's partitionable bytes.
> > +        Calculate partitionable bytes by subracting the volatile_only_bytes,
> 
> s/subracting/subtracting/
> 
> ...but rather than teaching the user to input valid values, tell them
> the validation and translation the tool will do on their behalf with
> the input based on type and the details they don't need to worry
> about.

Got it.

Thanks Dan.
