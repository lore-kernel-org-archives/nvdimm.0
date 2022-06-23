Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52A1FB3;
	Thu, 23 Jun 2022 15:09:10 +0000 (UTC)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LTNrf3TJrz6H6hL;
	Thu, 23 Jun 2022 23:06:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 23 Jun 2022 17:09:00 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 23 Jun
 2022 16:08:59 +0100
Date: Thu, 23 Jun 2022 16:08:57 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <20220623160857.00005fe2@Huawei.com>
In-Reply-To: <62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	<20220520172325.000043d8@huawei.com>
	<CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
	<20220531132157.000022c7@huawei.com>
	<62b3fce0bde02_3baed529440@dwillia2-xfh.notmuch>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 22 Jun 2022 22:40:48 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> > ....
> >   
> > > > Hi Ben,
> > > >
> > > > I finally got around to actually trying this out on top of Dan's recent fix set
> > > > (I rebased it from the cxl/preview branch on kernel.org).
> > > >
> > > > I'm not having much luck actually bring up a region.
> > > >
> > > > The patch set refers to configuring the end point decoders, but all their
> > > > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > > > is the intent that this series is part of the solution only?
> > > >
> > > > I'm confused!    
> > > 
> > > There's a new series that's being reviewed internally before going to the list:
> > > 
> > > https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
> > > 
> > > Given the proximity to the merge window opening and the need to get
> > > the "mem_enabled" series staged, I asked Ben to hold it back from the
> > > list for now.
> > > 
> > > There are some changes I am folding into it, but I hope to send it out
> > > in the next few days after "mem_enabled" is finalized.  
> > 
> > Hi Dan,
> > 
> > I switched from an earlier version of the region code over to a rebase of the tree.
> > Two issues below you may already have fixed.
> > 
> > The second is a carry over from an earlier set so I haven't tested
> > without it but looks like it's still valid.
> > 
> > Anyhow, thought it might save some cycles to preempt you sending
> > out the series if these issues are still present.
> > 
> > Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
> > devices, but once you post I'll test more extensively.  I've not
> > really thought about the below much, so might not be best way to fix.
> > 
> > Found a bug in QEMU code as well (missing write masks for the
> > target list registers) - will post fix for that shortly.  
> 
> Hi Jonathan,
> 
> Tomorrow I'll post the tranche to the list, but wanted to let you and
> others watching that that the 'preview' branch [1] now has the proposed
> initial region support. Once the bots give the thumbs up I'll send it
> along.
> 
> To date I've only tested it with cxl_test and an internal test vehicle.
> The cxl_test script I used to setup and teardown a x8 interleave across
> x2 host bridges and x4 switches is:

Thanks.  Trivial feedback from a very quick play (busy day).

Bit odd that regionX/size is once write - get an error even if
writing same value to it twice.

Also not debugged yet but on just got a null pointer dereference on

echo decoder3.0 > target0

Beyond a stacktrace pointing at store_targetN and dereference is of
0x00008 no idea yet.

I was testing with a slightly modified version of a nasty script
I was using to test with Ben's code previously.  Might well be
doing something wrong but obviously need to fix that crash anyway!
Will move to your nicer script below at somepoint as I've been lazy
enough I'm still hand editing a few lines depending on number on
a particular run.

Should have some time tomorrow to debug, but definitely 'here be
dragons' at the moment.

Jonathan

> 
> ---
> 
> #!/bin/bash
> modprobe cxl_test
> udevadm settle
> decoder=$(cxl list -b cxl_test -D -d root | jq -r ".[] |
>           select(.pmem_capable == true) | 
>           select(.nr_targets == 2) |
>           .decoder")
> 
> readarray -t mem < <(cxl list -M -d $decoder | jq -r ".[].memdev")
> readarray -t endpoint < <(cxl reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
>                           jq -r ".[] | .decoder.decoder")
> region=$(cat /sys/bus/cxl/devices/$decoder/create_pmem_region)
> echo $region > /sys/bus/cxl/devices/$decoder/create_pmem_region
> uuidgen > /sys/bus/cxl/devices/$region/uuid
> nr_targets=${#endpoint[@]}
> echo $nr_targets > /sys/bus/cxl/devices/$region/interleave_ways
> g=$(cat /sys/bus/cxl/devices/$decoder/interleave_granularity)
> echo $g > /sys/bus/cxl/devices/$region/interleave_granularity
> echo $((nr_targets * (256<<20))) > /sys/bus/cxl/devices/$region/size
> port_dev0=$(cxl list -T -d $decoder | jq -r ".[] |
>             .targets | .[] | select(.position == 0) | .target")
> port_dev1=$(cxl list -T -d $decoder | jq -r ".[] |
>             .targets | .[] | select(.position == 1) | .target")
> readarray -t mem_sort0 < <(cxl list -M -p $port_dev0 | jq -r ".[] | .memdev")
> readarray -t mem_sort1 < <(cxl list -M -p $port_dev1 | jq -r ".[] | .memdev")
> mem_sort=()
> mem_sort[0]=${mem_sort0[0]}
> mem_sort[1]=${mem_sort1[0]}
> mem_sort[2]=${mem_sort0[2]}
> mem_sort[3]=${mem_sort1[2]}
> mem_sort[4]=${mem_sort0[1]}
> mem_sort[5]=${mem_sort1[1]}
> mem_sort[6]=${mem_sort0[3]}
> mem_sort[7]=${mem_sort1[3]}
> 
> #mem_sort[2]=${mem_sort0[0]}
> #mem_sort[1]=${mem_sort1[0]}
> #mem_sort[0]=${mem_sort0[2]}
> #mem_sort[3]=${mem_sort1[2]}
> #mem_sort[4]=${mem_sort0[1]}
> #mem_sort[5]=${mem_sort1[1]}
> #mem_sort[6]=${mem_sort0[3]}
> #mem_sort[7]=${mem_sort1[3]}
> 
> endpoint=()
> for i in ${mem_sort[@]}
> do
>         readarray -O ${#endpoint[@]} -t endpoint < <(cxl list -Di -d endpoint -m $i | jq -r ".[] |
>                                                      select(.mode == \"pmem\") | .decoder")
> done
> pos=0
> for i in ${endpoint[@]}
> do
>         echo $i > /sys/bus/cxl/devices/$region/target$pos
>         pos=$((pos+1))
> done
> echo "$region added ${#endpoint[@]} targets: ${endpoint[@]}"
> 
> echo 1 > /sys/bus/cxl/devices/$region/commit
> echo 0 > /sys/bus/cxl/devices/$region/commit
> 
> pos=0
> for i in ${endpoint[@]}
> do
>         echo "" > /sys/bus/cxl/devices/$region/target$pos
>         pos=$((pos+1))
> done
> readarray -t endpoint < <(cxl free-dpa -t pmem ${mem[*]} |
>                           jq -r ".[] | .decoder.decoder")
> echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
> 
> ---
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=preview

