Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773357B
	for <nvdimm@lists.linux.dev>; Sat, 29 Oct 2022 00:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667005076; x=1698541076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Lu+uv2aV4mQPc4RLEVThORis3M/8587F7OJPaTx4clg=;
  b=OqDFei4yrhI25XWfi48fdhYuMMpE1nxopGVnwSJHgEEC00wFIJE82sqW
   e/UoDVWOz4elzBnMW/VQ4w/HSzxK6Y+oII/mN38bDqH/V/+hNrJaccgWl
   9Jji+PtLvL897AVW/LuyZfmF8no2VkO2tCAxhqdPYHZ/Jt0Dhol3iL1c4
   oco6Nts+ZdpewYpESU/CokqXQC2jjHkhYUpZbw0Ou4ytvI0mrs63IwyvT
   zjLmaIPwY6481+txP5+M+ZZ7bGNt0BnFukbKhLLE2Qhl1MiHNahzdT2DZ
   JtO6PLnHKpoCpcmuke6mKmbAo82ooJczcrGN8Jwbi46G/43a40HhrdobD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="394938151"
X-IronPort-AV: E=Sophos;i="5.95,222,1661842800"; 
   d="scan'208";a="394938151"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 17:57:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="627708634"
X-IronPort-AV: E=Sophos;i="5.95,222,1661842800"; 
   d="scan'208";a="627708634"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.175.207])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 17:57:55 -0700
Date: Fri, 28 Oct 2022 17:57:53 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v2] cxl/test: add cxl_xor_region test
Message-ID: <Y1x6kcSxODzHktUD@aschofie-mobl2>
References: <20221027041252.665456-1-alison.schofield@intel.com>
 <51950cdc-bb8d-1fc2-3d57-10e69d9592ca@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51950cdc-bb8d-1fc2-3d57-10e69d9592ca@intel.com>

On Fri, Oct 28, 2022 at 09:27:04AM -0700, Dave Jiang wrote:
> 
> On 10/26/2022 9:12 PM, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Exercise the kernel driver support of XOR math by creating regions
> > with 1, 2, and 4-way interleaves using XOR interleave arithmetic.
> > 
> > Use module parameter "interleave_arithmetic=1" to select the cxl_test
> > topology that supports XOR math. XOR math is not used in the default
> > cxl_test module.
> > 
> > Add this test to the 'cxl' suite so that it gets exercised routinely.
> > If the topology defined in cxl_test changes, this test may require
> > an update.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> > Depends on
> > https://lore.kernel.org/linux-cxl/cover.1666841669.git.alison.schofield@intel.com/
> > 
> > Changes in v2
> > - Update to match cxl_test topology changes
> > - Remove 3-way interleave
> > - Small naming updates
> > 
> >   test/cxl-xor-region.sh | 100 +++++++++++++++++++++++++++++++++++++++++
> >   test/meson.build       |   2 +
> >   2 files changed, 102 insertions(+)
> >   create mode 100644 test/cxl-xor-region.sh
> > 
> > diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> > new file mode 100644
> > index 000000000000..64a0b234896a
> > --- /dev/null
> > +++ b/test/cxl-xor-region.sh
> > @@ -0,0 +1,100 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2022 Intel Corporation. All rights reserved.
> > +
> > +. $(dirname $0)/common
> > +
> > +rc=1
> > +
> > +set -ex
> > +
> > +trap 'err $LINENO' ERR
> > +
> > +check_prereq "jq"
> > +
> > +modprobe -r cxl_test
> > +modprobe cxl_test interleave_arithmetic=1
> > +udevadm settle
> > +
> > +# THEORY OF OPERATION: Create x1,x2,x4 regions to exercise the XOR math
> > +# option of the CXL driver. As with other cxl_test tests, changes to the
> > +# CXL topology in tools/testing/cxl/test/cxl.c may require an update here.
> > +
> > +create_region()
> 
> create_and_destroy_region() seems more descriptive of what this function do?
> 
> DJ

You're right. Will rename.
Thanks for the review,
Alison

> 
> > +{
> > +	region=$($CXL create-region -d $decoder -m $memdevs | jq -r ".region")
> > +
> > +	if [[ ! $region ]]; then
> > +		echo "create-region failed for $decoder"
> > +		err "$LINENO"
> > +	fi
> > +
> > +	$CXL destroy-region -f -b cxl_test "$region"
> > +}
> > +
> > +setup_x1()
> > +{
> > +        # Find an x1 decoder
> > +        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> > +          select(.pmem_capable == true) |
> > +          select(.nr_targets == 1) |
> > +          .decoder")
> > +
> > +        # Find a memdev for this host-bridge
> > +        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 0) | .target")
> > +        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
> > +        memdevs="$mem0"
> > +}
> > +
> > +setup_x2()
> > +{
> > +        # Find an x2 decoder
> > +        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> > +          select(.pmem_capable == true) |
> > +          select(.nr_targets == 2) |
> > +          .decoder")
> > +
> > +        # Find a memdev for each host-bridge interleave position
> > +        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 0) | .target")
> > +        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 1) | .target")
> > +        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
> > +        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
> > +        memdevs="$mem0 $mem1"
> > +}
> > +
> > +setup_x4()
> > +{
> > +        # find x4 decoder
> > +        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> > +          select(.pmem_capable == true) |
> > +          select(.nr_targets == 4) |
> > +          .decoder")
> > +
> > +        # Find a memdev for each host-bridge interleave position
> > +        port_dev0=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 0) | .target")
> > +        port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 1) | .target")
> > +        port_dev2=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 2) | .target")
> > +        port_dev3=$($CXL list -T -d $decoder | jq -r ".[] |
> > +            .targets | .[] | select(.position == 3) | .target")
> > +        mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
> > +        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
> > +        mem2=$($CXL list -M -p $port_dev2 | jq -r ".[2].memdev")
> > +        mem3=$($CXL list -M -p $port_dev3 | jq -r ".[3].memdev")
> > +        memdevs="$mem0 $mem1 $mem2 $mem3"
> > +}
> > +
> > +setup_x1
> > +create_region
> > +setup_x2
> > +create_region
> > +setup_x4
> > +create_region
> > +
> > +modprobe -r cxl_test
> > +
> > diff --git a/test/meson.build b/test/meson.build
> > index 5953c286d13f..89cae9e99dff 100644
> > --- a/test/meson.build
> > +++ b/test/meson.build
> > @@ -154,6 +154,7 @@ cxl_topo = find_program('cxl-topology.sh')
> >   cxl_sysfs = find_program('cxl-region-sysfs.sh')
> >   cxl_labels = find_program('cxl-labels.sh')
> >   cxl_create_region = find_program('cxl-create-region.sh')
> > +cxl_xor_region = find_program('cxl-xor-region.sh')
> >   tests = [
> >     [ 'libndctl',               libndctl,		  'ndctl' ],
> > @@ -182,6 +183,7 @@ tests = [
> >     [ 'cxl-region-sysfs.sh',    cxl_sysfs,	  'cxl'   ],
> >     [ 'cxl-labels.sh',          cxl_labels,	  'cxl'   ],
> >     [ 'cxl-create-region.sh',   cxl_create_region,  'cxl'   ],
> > +  [ 'cxl-xor-region.sh',      cxl_xor_region,     'cxl'   ],
> >   ]
> >   if get_option('destructive').enabled()
