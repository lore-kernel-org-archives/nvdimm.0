Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 712A1211E9593
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 16:31:46 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] nvdimm: btt_devs: fix a NULL pointer dereference and a
 memory leak
Date: Fri, 22 Mar 2019 23:31:43 +0000
Message-ID: <a5240c40ca3353f3798e1a52d4ca663dd278f0aa.camel@intel.com>
References: <20190312081529.4889-1-kjlu@umn.edu>
 <eea1b50fe8c76d45fef0aaca1878c30fa8f2cbde.camel@intel.com>
 <4377c210798b000d60ebdc5150e015737d05565b.camel@intel.com>
In-Reply-To: <4377c210798b000d60ebdc5150e015737d05565b.camel@intel.com>
Content-Language: en-US
Content-ID: <2AD9C8742838CC4E96CFEB432B12CF70@intel.com>
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
To: "kjlu@umn.edu" <kjlu@umn.edu>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>, "pakki001@umn.edu" <pakki001@umn.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2019-03-22 at 22:56 +0000, Verma, Vishal L wrote:
> On Fri, 2019-03-22 at 22:49 +0000, Verma, Vishal L wrote:
> > On Tue, 2019-03-12 at 03:15 -0500, Kangjie Lu wrote:
> > > In case kmemdup fails, the fix releases resources and returns to
> > > avoid the NULL pointer dereference.
> > > Also, the error paths in the following code should release
> > > resources to avoid memory leaks.
> > > 
> > > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> > > ---
> > >  drivers/nvdimm/btt_devs.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > 
> > Looks good,
> > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Looking again, there is another kmemdup() call in __nd_btt_probe which
> is lacking error checking.
> And referring to your other related patch to namespace_devs, that has
> /several/ instances of the same thing.
> 
> Instead of fixing just a couple of these, it might be worthwhile to send
> a wider cleanup patch to catch all of these, at least within
> drivers/nvdimm/ for starters, instead of a select few.

Hm, ignore this comment - these are the only two unchecked instances.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
