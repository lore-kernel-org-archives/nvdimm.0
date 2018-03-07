Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CB3D21E082BC
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 12:44:19 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 3/3] ndctl: add filtering based on numa_node
Date: Wed, 7 Mar 2018 20:50:34 +0000
Message-ID: <1520455832.6316.5.camel@intel.com>
References: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
 <20180307185355.4425-1-ross.zwisler@linux.intel.com>
 <1520455336.6316.4.camel@intel.com>
 <CAPcyv4jC3G0CdBwY_4EVOqNEgYvxmGPiHPt5yUFMH0PJ0jxxVA@mail.gmail.com>
In-Reply-To: <CAPcyv4jC3G0CdBwY_4EVOqNEgYvxmGPiHPt5yUFMH0PJ0jxxVA@mail.gmail.com>
Content-Language: en-US
Content-ID: <93DFE6D2B9C4AD4ABF5A8D50D84F5771@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2018-03-07 at 12:48 -0800, Dan Williams wrote:
> On Wed, Mar 7, 2018 at 12:42 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > 
> > On Wed, 2018-03-07 at 11:53 -0700, Ross Zwisler wrote:
> > > Add support to 'ndctl list' so that we can filter DIMMs, regions
> > > and
> > > namespaces based on numa node.
> > 
> > Something for the future - perhaps we can add this same numa node
> > based
> > filtering to all the operations on namespaces/regions/dimms.
> 
> This does have the region filtering, and that should also
> automatically filter namespaces since we wouldn't even consider the
> namespaces on a region where the numa node doesn't match.
> 
> > 
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > ---
> > > v2: Use NUMA_NO_NODE intead of hard coding -1 (Dan).
> > > ---
> > >  Documentation/ndctl/ndctl-list.txt |  4 ++++
> > >  ndctl/list.c                       |  2 ++
> > >  util/filter.c                      | 40
> > > ++++++++++++++++++++++++++++++++++++--
> > >  util/filter.h                      |  1 +
> > >  4 files changed, 45 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/Documentation/ndctl/ndctl-list.txt
> > > b/Documentation/ndctl/ndctl-list.txt
> > > index 02d4f04..c711c1f 100644
> > > --- a/Documentation/ndctl/ndctl-list.txt
> > > +++ b/Documentation/ndctl/ndctl-list.txt
> > > @@ -83,6 +83,10 @@ include::xable-region-options.txt[]
> > >       Filter listing by the mode ('raw', 'fsdax', 'sector' or
> > > 'devdax')
> > >       of the namespace(s).
> > > 
> > > +-U::
> > > +--numa_node=::
> > > +     Filter listing by numa node
> > > +
> > >  -B::
> > >  --buses::
> > >       Include bus info in the listing
> > > diff --git a/ndctl/list.c b/ndctl/list.c
> > > index 4cb66de..e861f8b 100644
> > > --- a/ndctl/list.c
> > > +++ b/ndctl/list.c
> > > @@ -400,6 +400,8 @@ int cmd_list(int argc, const char **argv,
> > > void
> > > *ctx)
> > >                               "filter by namespace mode"),
> > >               OPT_STRING('t', "type", &param.type, "region-type",
> > >                               "filter by region-type"),
> > > +             OPT_STRING('U', "numa_node", &param.numa_node,
> > > "numa
> > > node",
> > > +                             "filter by numa node"),
> > >               OPT_BOOLEAN('B', "buses", &list.buses, "include bus
> > > info"),
> > >               OPT_BOOLEAN('D', "dimms", &list.dimms, "include
> > > dimm
> > > info"),
> > >               OPT_BOOLEAN('F', "firmware", &list.firmware,
> > > "include firmware info"),
> > > diff --git a/util/filter.c b/util/filter.c
> > > index b0b7fdf..291d7ed 100644
> > > --- a/util/filter.c
> > > +++ b/util/filter.c
> > > @@ -20,6 +20,8 @@
> > >  #include <ndctl/libndctl.h>
> > >  #include <daxctl/libdaxctl.h>
> > > 
> > > +#define NUMA_NO_NODE    (-1)
> > > +
> > >  struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const
> > > char
> > > *ident)
> > >  {
> > >       char *end = NULL;
> > > @@ -146,7 +148,6 @@ struct ndctl_bus
> > > *util_bus_filter_by_region(struct ndctl_bus *bus,
> > >       return NULL;
> > >  }
> > > 
> > > -
> > >  struct ndctl_bus *util_bus_filter_by_namespace(struct ndctl_bus
> > > *bus,
> > >               const char *ident)
> > >  {
> > > @@ -223,6 +224,25 @@ struct ndctl_dimm
> > > *util_dimm_filter_by_namespace(struct ndctl_dimm *dimm,
> > >       return NULL;
> > >  }
> > > 
> > > +struct ndctl_dimm *util_dimm_filter_by_numa_node(struct
> > > ndctl_dimm
> > > *dimm,
> > > +             int numa_node)
> > > +{
> > > +     struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
> > > +     struct ndctl_region *region;
> > > +     struct ndctl_dimm *check;
> > > +
> > > +     if (numa_node == NUMA_NO_NODE)
> > > +             return dimm;
> > > +
> > > +     ndctl_region_foreach(bus, region)
> > > +             ndctl_dimm_foreach_in_region(region, check)
> > > +                     if (check == dimm &&
> > > +                         ndctl_region_get_numa_node(region) ==
> > > numa_node)
> > > +                             return dimm;
> > > +
> > > +     return NULL;
> > > +}
> > > +
> > >  struct ndctl_region *util_region_filter_by_namespace(struct
> > > ndctl_region *region,
> > >               const char *ident)
> > >  {
> > > @@ -285,6 +305,8 @@ int util_filter_walk(struct ndctl_ctx *ctx,
> > > struct util_filter_ctx *fctx,
> > >  {
> > >       struct ndctl_bus *bus;
> > >       unsigned int type = 0;
> > > +     int numa_node = NUMA_NO_NODE;
> > > +     char *end = NULL;
> > > 
> > >       if (param->type && (strcmp(param->type, "pmem") != 0
> > >                               && strcmp(param->type, "blk") !=
> > > 0))
> > > {
> > > @@ -305,6 +327,14 @@ int util_filter_walk(struct ndctl_ctx *ctx,
> > > struct util_filter_ctx *fctx,
> > >               return -EINVAL;
> > >       }
> > > 
> > > +     if (param->numa_node && strcmp(param->numa_node, "all") !=
> > > 0) {
> > 
> > Does it make sense to accept an 'all' option for numa node? We're
> > only
> > using it for filtering, and 'all' == not supplying the option at
> > all..
> 
> Same could be said for all the other places we accept all, I think it
> should be "all or nothing" (heh heh heh), i.e. if we accept it as an
> option for dimms regions and namespaces, why not numa nodes?

Ah I didn't know we accepted all for the other things. /me wonders
whether it merits a bash completion update :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
