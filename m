Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D861C2096FAC1
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 00:51:35 -0700 (PDT)
From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [BUG] Injecting bad blocks in the nfit_test module does not
 work with kernel v4.17.4 + ndctl v61.1
Date: Thu, 5 Jul 2018 07:51:25 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEBF4F2E4A2@IRSMSX101.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
 <CAPcyv4gw12anx4tFqG1zeFjS-Be8kxVgXDqNHE5U4eES-=UOBQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gw12anx4tFqG1zeFjS-Be8kxVgXDqNHE5U4eES-=UOBQ@mail.gmail.com>
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
Cc: "Li, ZhijianX" <zhijianx.li@intel.com>, Slusarz,, "Piotr  <piotr.balcer@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, July 4, 2018 4:33 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, Jul 4, 2018 at 5:45 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> > Hi,
> >
> >
> >
> > This is a bug report:  injecting bad blocks in the nfit_test module does not
> > work with the kernel v4.17.4 (the latest stable at this moment) and ndctl
> > v61.1:
> >
> 
> Sorry, yes, this is a known issue. There is no fix on the near
> horizon, this is a casualty of the ARS rework we did in the kernel
> between v4.16 and v4.17. More details here:
> 
> https://github.com/pmem/issues/issues/897#issuecomment-402495154
>

Hi Dan,

Thanks for the fast reply and the explanation.

I tested the workaround (ndctl start-scrub ; ndctl wait-scrub) but it does not work for me (with kernel v4.17.4 and ndctl v61.1):

# ndctl inject-error --block=16838 --count=512 namespace4.0
# ndctl start-scrub
# ndctl wait-scrub      #       <---       I waited 30 minutes for 'ndctl wait-scrub', but it did not finish...

--
Lukasz


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
