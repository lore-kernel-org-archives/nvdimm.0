Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3743A211EB815
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 15:17:57 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/8] daxctl: add a new reconfigure-device command
Date: Mon, 6 May 2019 22:17:55 +0000
Message-ID: <6d832ef8fa6e0f1201048021dd1aa18b359efc25.camel@intel.com>
References: <20190503213231.12280-1-vishal.l.verma@intel.com>
 <12edf619-be22-8ae9-77c0-8a81cb353a87@intel.com>
 <e251c59c27e52515a0eb9f93ec1990d37cb8b31d.camel@intel.com>
In-Reply-To: <e251c59c27e52515a0eb9f93ec1990d37cb8b31d.camel@intel.com>
Content-Language: en-US
Content-ID: <9833C5939E7A7E40AF816810441DBF53@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Hansen, Dave" <dave.hansen@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-05-06 at 22:14 +0000, Verma, Vishal L wrote:
> On Mon, 2019-05-06 at 14:50 -0700, Dave Hansen wrote:
> > This all looks quite nice to me.  Thanks, Vishal!
> > 
> > One minor nit: for those of us new to daxctl and friends, they can
> > be
> > a
> > bit hard to get started with.  Could you maybe add a few example
> > invocations to the Documentation, or even this cover letter to help
> > us
> > newbies get started?
> 
> Yes, good idea, I'll add an examples section to the Documentation page
> (other commands do this, and this should too), and add those to the
> cover letter as well for v2.

I meant to add, for now, a few of the most useful invocations probably
look like:

1. # daxctl reconfigure-device --mode=system-ram dax0.0
(this will also online the memory sections)

2. # daxctl reconfigure-device --mode=system-ram --no-online dax0.0
(this will *not* online the memory sections)

3. # daxctl reconfigure-device --mode=devdax --attempt-offline dax0.0
(this requires Pavel's patches for kmem-unbind, and won't work with
vanilla v5.1)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
