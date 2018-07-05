Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED500210DBE8E
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 03:54:35 -0700 (PDT)
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [BUG] Injecting bad blocks in the nfit_test module does not
 work with kernel v4.17.4 + ndctl v61.1
Date: Thu, 5 Jul 2018 10:54:33 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEBF4F2E897@IRSMSX101.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
 <CAPcyv4gw12anx4tFqG1zeFjS-Be8kxVgXDqNHE5U4eES-=UOBQ@mail.gmail.com>
 <D9FFE20C522965449E182ACE73889AEBF4F2E6E9@IRSMSX101.ger.corp.intel.com>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEBF4F2E6E9@IRSMSX101.ger.corp.intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Li, ZhijianX" <zhijianx.li@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Balcer,, Marcin
List-ID: <linux-nvdimm@lists.01.org>

On Thu, July 5, 2018 10:29 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> On Thu, July 5, 2018 9:51 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> >
> > I tested the workaround (ndctl start-scrub ; ndctl wait-scrub) but it does not work
> > for me (with kernel v4.17.4 and ndctl v61.1):
> >
> > # ndctl inject-error --block=16838 --count=512 namespace4.0
> > # ndctl start-scrub
> > # ndctl wait-scrub      #       <---       I waited 30 minutes for 'ndctl wait-scrub', but it
> > did not finish...
> >
> 
> It is polling forever in ndctl_bus_wait_for_scrub_completion() at libndctl.c:1239:
> 

When I replaced '--count=512' with '--count=1', it works well ...
 
--
Lukasz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
