Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7726A212E1597
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jul 2019 16:33:19 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v7 11/13] contrib/ndctl: fix region-id completions
 for daxctl
Date: Fri, 26 Jul 2019 23:30:50 +0000
Message-ID: <a6ca723887fab20429929217baa08ae26513eb26.camel@intel.com>
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-12-vishal.l.verma@intel.com>
 <CAPcyv4g82poaqSNZh+Q_QpdWVqjmz3C=BM74Guoe_Wj7bv6kwQ@mail.gmail.com>
In-Reply-To: <CAPcyv4g82poaqSNZh+Q_QpdWVqjmz3C=BM74Guoe_Wj7bv6kwQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <A67E4798195B8347A92385AE07A174F8@intel.com>
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
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2019-07-25 at 19:55 -0700, Dan Williams wrote:
> On Wed, Jul 24, 2019 at 2:58 PM Vishal Verma <vishal.l.verma@intel.com
> > wrote:
> > The completion helpers for daxctl assumed the region arguments for
> > specifying daxctl regions were the same as ndctl regions, i.e.
> > "regionX". This is not true - daxctl region arguments are a simple
> > numeric 'id'.
> 
> Oh, that's an unfortunate difference, but too late to change now I
> think, good find.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Yep - though I think I like --region=0 better than --region=region0,
less redundancy.  But agreed, probably too late to change.

Thanks for reviewing these!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
