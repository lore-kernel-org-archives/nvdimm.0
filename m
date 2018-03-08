Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59D1D2256862C
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 09:15:21 -0800 (PST)
Date: Thu, 8 Mar 2018 10:21:34 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 3/3] ndctl: add filtering based on numa_node
Message-ID: <20180308172134.GC18491@linux.intel.com>
References: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
 <20180307185355.4425-1-ross.zwisler@linux.intel.com>
 <1520455336.6316.4.camel@intel.com>
 <CAPcyv4jC3G0CdBwY_4EVOqNEgYvxmGPiHPt5yUFMH0PJ0jxxVA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jC3G0CdBwY_4EVOqNEgYvxmGPiHPt5yUFMH0PJ0jxxVA@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 07, 2018 at 12:48:28PM -0800, Dan Williams wrote:
> On Wed, Mar 7, 2018 at 12:42 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> >
> > On Wed, 2018-03-07 at 11:53 -0700, Ross Zwisler wrote:
> >> Add support to 'ndctl list' so that we can filter DIMMs, regions and
> >> namespaces based on numa node.
> >
> > Something for the future - perhaps we can add this same numa node based
> > filtering to all the operations on namespaces/regions/dimms.
> 
> This does have the region filtering, and that should also
> automatically filter namespaces since we wouldn't even consider the
> namespaces on a region where the numa node doesn't match.

What other supports of operations were you thinking about?  Like

ndctl disable-region --numa_node=0

or something?  It doesn't look like we use other ndctl list type filters for
other operations like that today?  This seems powerful if we were to implement
it, but easy to accidentally operate on namespaces/regions you didn't intend.

> > Does it make sense to accept an 'all' option for numa node? We're only
> > using it for filtering, and 'all' == not supplying the option at all..
> 
> Same could be said for all the other places we accept all, I think it
> should be "all or nothing" (heh heh heh), i.e. if we accept it as an
> option for dimms regions and namespaces, why not numa nodes?

On a somewhat related note, what do you guys think of an option like this:

ndctl list --all

Which would just give you a full dump of all the various bits of info, so it
would currently be equivalent to:

ndctl list --buses --dimms --health --device-dax  --regions --namespaces
	--idle --media-errors

Providing you with a single short command to get as much info about a system
as possible?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
