Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157212E842
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 20:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967337; cv=none; b=LugnF5umZk3f0OWtWc+rOyyC4lL+AIxecwrvNQjVDoqRAkkT3gcOeKe5w8r65k4iQzotRZl3l3gm958Or0YM/GE9o0T6XydGmxTrX+bNBqQV+KZQWIun1jAcOnES5S2IYt6HgnkDU842uADrFqJabUielhxdM2W0byY9bJrUGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967337; c=relaxed/simple;
	bh=v+4WUabNYalf5GqvqVmymAuxC3nMRa6sUIZkJKh0g5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gzQnl+bWzSIoxFlJ2CJocl1yeS37ezKl6GmXJ05Natvk+4PQkf/4lSZEKQRzKojpthGlmocyT2kzXRkEG13GhwMLSYD/b8gz35Y9cNylGMHOBhrcdyPuJLhMIWm9uVlz6P7iuGoBpw94OZ1dNrVBaSVY/f3wi87tZbsv1VTZu0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpKUxaav; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpKUxaav"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710967336; x=1742503336;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v+4WUabNYalf5GqvqVmymAuxC3nMRa6sUIZkJKh0g5w=;
  b=MpKUxaavKsCbDbrTbuB5IDz4Dc8/48Uqr2FvMIjZHZ6UBT59mHZsg1Fx
   QLPJm3G9yYihTEMrDi/qxz8l7dG/yaYwiipPuRul6+UVtF7QUTXVtLH0H
   qQDd+VH//u8u7Ksmu6TRuuvQxXdqlD5KCxn4dsqmfPWDCm4uSvPfg5gh7
   RJFd9e9HZvEPwXKTe0nU+g1BYcCQJ7bjnqXrPs+ifCesXBDq0GneN6yk0
   BU+8mFH+5li9pzKx2tanVKm962q7f7ti4honieLLVwPBlVKYCoeANGHrp
   Z8N4/W3e0dMIBJrdDzRCeTuLUBZ0mX2IpzYCS2/208cHio8f8SY5guANC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="28397554"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="28397554"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:42:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14294453"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.72.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:42:10 -0700
Date: Wed, 20 Mar 2024 13:42:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v11 0/7] Support poison list retrieval
Message-ID: <ZftKIJSSIm4cZUje@aschofie-mobl2>
References: <cover.1710386468.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1710386468.git.alison.schofield@intel.com>

On Wed, Mar 13, 2024 at 09:05:16PM -0700, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>

Asking folks to share this with future users of the poison list
feature of ndctl. ie. cxl list --media-errors

I'd like to get additional 'user' input on the json output provided by
this --media-errors option to cxl-list. After a few iterations of what
should be included in the cxl-list output, I'm not so sure that we've
captured sufficient input from potential users. (Since they typically
won't use this til it's released in ndctl.)

To guide your thinking recall that users can retrieve a devices poison
list now without any cxl-cli (ndctl) tool support. Users can trigger
the collection via sysfs and see the results in the trace logs like:

this:
- echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
- echo 1 > /sys/bus/cxl/devices/memX/trigger_poison_list
- Examine the cxl_poison events in the trace file at 

or this:
- cxl monitor --daemon --log=<poison-log-path>
- echo 1 > /sys/bus/cxl/devices/memX/trigger_poison_list
- Examine the cxl_poison events in the monitor log

or this:
- enable tp_printk
- echo 1 > /sys/kernel/tracing/events/cxl/cxl_poison/enable
- echo 1 > /sys/bus/cxl/devices/memX/trigger_poison_list
- Examine the cxl_poison events in the dmesg log

So, a few ways to get at this cxl_poison trace data:
memdev=mem9
host=cxl_mem.5 
serial=5 
trace_type=List 
region=region5 
region_uuid=99352a43-44cb-405d-85c9-fdbd971455d8
hpa=0xf110001000
dpa=0x40000000
dpa_length=0x40
source=Injected
flags=
overflow_time=0

The tool should be providing a better experience that the sysfs/trace.
The tools does look up memdevs contributing to a region and triggers
the needed poison list reads, so that's a small convenience. It's
usefulness needs to extend to the json listing.

Here's history of json output pulled from the patch cover letters.
It's long, but I didn't want to omit any detail.

I've appended here the history of changes to the output.
Only including samples where the json output actually changed.
I'm including it to spur conversation not as a guideline.

Subject: [ndctl PATCH v11 0/7] Support poison list retrieval

           # cxl list -m mem9 --media-errors -u
           {
             "memdev":"mem9",
             "pmem_size":"1024.00 MiB (1073.74 MB)",
             "pmem_qos_class":42,
             "ram_size":"1024.00 MiB (1073.74 MB)",
             "ram_qos_class":42,
             "serial":"0x5",
             "numa_node":1,
             "host":"cxl_mem.5",
             "media_errors":[
               {
                 "offset":"0x40000000",
                 "length":64,
                 "source":"Injected"
               }
             ]
           }


           # cxl list -r region5 --media-errors -u
           {
             "region":"region5",
             "resource":"0xf110000000",
             "size":"2.00 GiB (2.15 GB)",
             "type":"pmem",
             "interleave_ways":2,
             "interleave_granularity":4096,
             "decode_state":"commit",
             "media_errors":[
               {
                 "offset":"0x1000",
                 "length":64,
                 "source":"Injected"
               },
               {
                 "offset":"0x2000",
                 "length":64,
                 "source":"Injected"
               }
             ]
           }


Subject: [ndctl PATCH v7 0/7] Support poison list retrieval

# cxl list -m mem1 --media-errors
[
  {
    "memdev":"mem1",
    "pmem_size":1073741824,
    "ram_size":1073741824,
    "serial":1,
    "numa_node":1,
    "host":"cxl_mem.1",
    "media_errors":[
      {
        "dpa":0,
        "length":64,
        "source":"Internal"
      },
      {
        "decoder":"decoder10.0",
        "hpa":1035355557888,
        "dpa":1073741824,
        "length":64,
        "source":"External"
      },
      {
        "decoder":"decoder10.0",
        "hpa":1035355566080,
        "dpa":1073745920,
        "length":64,
        "source":"Injected"
      }
    ]
  }
]

# cxl list -r region5 --media-errors
[
  {
    "region":"region5",
    "resource":1035355553792,
    "size":2147483648,
    "type":"pmem",
    "interleave_ways":2,
    "interleave_granularity":4096,
    "decode_state":"commit",
    "media_errors":[
      {
        "decoder":"decoder10.0",
        "hpa":1035355557888,
        "dpa":1073741824,
        "length":64,
        "source":"External"
      },
      {
        "decoder":"decoder8.1",
        "hpa":1035355566080,
        "dpa":1073745920,
        "length":64,
        "source":"Internal"
      }
    ]
  }
]

Subject: [ndctl PATCH v6 0/7] Support poison list retrieval

# cxl list -m mem1 --media-errors
[
  {
    "memdev":"mem1",
    "pmem_size":1073741824,
    "ram_size":1073741824,
    "serial":1,
    "numa_node":1,
    "host":"cxl_mem.1",
    "media_errors":[
      {
        "dpa":0,
        "dpa_length":64,
        "source":"Injected"
      },
      {
        "region":"region5",
        "dpa":1073741824,
        "dpa_length":64,
        "hpa":1035355557888,
        "source":"Injected"
      },
      {
        "region":"region5",
        "dpa":1073745920,
        "dpa_length":64,
        "hpa":1035355566080,
        "source":"Injected"
      }
    ]
  }
]

# cxl list -r region5 --media-errors
[
  {
    "region":"region5",
    "resource":1035355553792,
    "size":2147483648,
    "type":"pmem",
    "interleave_ways":2,
    "interleave_granularity":4096,
    "decode_state":"commit",
    "media_errors":[
      {
        "memdev":"mem1",
        "dpa":1073741824,
        "dpa_length":64,
        "hpa":1035355557888,
        "source":"Injected"
      },
      {
        "memdev":"mem1",
        "dpa":1073745920,
        "dpa_length":64,
        "hpa":1035355566080,
        "source":"Injected"
      }
    ]
  }
]

Subject: [ndctl PATCH v2 0/3] Support poison list retrieval

Example: By memdev
cxl list -m mem1 --poison -u
{
  "memdev":"mem1",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x1",
  "numa_node":1,
  "host":"cxl_mem.1",
  "poison":{
    "nr_poison_records":4,
    "poison_records":[
      {
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0x40001000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "dpa":"0x600",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}

Example: By region
cxl list -r region5 --poison -u
{
  "region":"region5",
  "resource":"0xf110000000",
  "size":"2.00 GiB (2.15 GB)",
  "type":"pmem",
  "interleave_ways":2,
  "interleave_granularity":4096,
  "decode_state":"commit",
  "poison":{
    "nr_poison_records":2,
    "poison_records":[
      {
        "memdev":"mem1",
        "region":"region5",
        "hpa":"0xf110001000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      },
      {
        "memdev":"mem0",
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}


Example: By memdev and coincidentally in a region
# cxl list -m mem0 --poison -u
{
  "memdev":"mem0",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0",
  "numa_node":0,
  "host":"cxl_mem.0",
  "poison":{
    "nr_poison_records":1,
    "poison_records":[
      {
        "region":"region5",
        "hpa":"0xf110000000",
        "dpa":"0x40000000",
        "dpa_length":64,
        "source":"Injected",
        "flags":""
      }
    ]
  }
}


Example: No poison found
cxl list -m mem9 --poison -u
{
  "memdev":"mem9",
  "pmem_size":"1024.00 MiB (1073.74 MB)",
  "ram_size":"1024.00 MiB (1073.74 MB)",
  "serial":"0x9",
  "numa_node":1,
  "host":"cxl_mem.9",
  "poison":{
    "nr_poison_records":0
  }
}

