Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47E3722135D3E
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 10:40:07 -0800 (PST)
Date: Wed, 7 Mar 2018 11:46:21 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/3] ndctl: add filtering based on numa_node
Message-ID: <20180307184621.GA14531@linux.intel.com>
References: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
 <20180307180237.9289-3-ross.zwisler@linux.intel.com>
 <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 07, 2018 at 10:36:47AM -0800, Dan Williams wrote:
> > @@ -342,6 +372,10 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
> >                                                 param->namespace))
> >                                 continue;
> >
> > +                       if (numa_node != -1 &&
> > +                           ndctl_region_get_numa_node(region) != numa_node)
> > +                               continue;
> 
> Maybe "numa_node >= 0", or "#define NUMA_NO_NODE  (-1)" and use that?

Yea, that does make it easier to read.  Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
