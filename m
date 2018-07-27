Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E1A52097E27C
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 14:30:14 -0700 (PDT)
Received: from G2W6311.americas.hpqcorp.net (g2w6311.austin.hp.com
 [16.197.64.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 421565A
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 21:30:13 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: ndctl create-namespace region order
Date: Fri, 27 Jul 2018 21:30:08 +0000
Message-ID: <AT5PR8401MB1169BA633EC5E3E8D1BB92E4AB2A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Dave Jiang' <dave.jiang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "'Verma, Vishal L'" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

ndctl create-namespace doesn't walk through the regions
from lowest to highest; in this example it's going
1,3,5,0,2,4,6:

$ sudo ndctl create-namespace --verbose
ROB: parsing bus id=0 path=ndbus0
ROB: parsing region id=1 path=region1
namespace_create:770: region1: insufficient capacity size: 0 avail: 0
ROB: parsing region id=3 path=region3
namespace_create:770: region3: insufficient capacity size: 0 avail: 0
ROB: parsing region id=5 path=region5
namespace_create:770: region5: insufficient capacity size: 0 avail: 0
ROB: parsing region id=0 path=region0
namespace_create:770: region0: insufficient capacity size: 0 avail: 0
ROB: parsing region id=2 path=region2

That makes the results unpredictable.

That's from do_xaction_namespace():

        ndctl_bus_foreach(ctx, bus) {
printf("ROB: parsing bus id=%d path=%s\n", ndctl_bus_get_id(bus), ndctl_bus_get_devname(bus));
                if (!util_bus_filter(bus, param.bus))
                        continue;

                ndctl_region_foreach(bus, region) {
printf("ROB: parsing region id=%d path=%s\n", ndctl_region_get_id(region), ndctl_region_get_devname(region));
                        if (!util_region_filter(region, param.region))

The same order is used for other commands like
disable-namespace and destroy-namespace.

Questions
=========
1. Could the busses and regions (anything accessed with
a _foreach() macro) be sorted in ascending order so this
and other commands are more predictable?

2. For create-namespace with no region arguments, rather than
just creating one random namespace, how about creating namespaces
on each available region?

3. The manpage suggests that "-r all" does that, but it seems to 
just make every region number pass the filter in that foreach
loop (i.e., it has no effect for the create-namespace command,
which just creates one and quits).

---
Robert Elliott, HPE Persistent Memory

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
