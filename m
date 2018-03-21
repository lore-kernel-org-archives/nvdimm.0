Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D369122146754
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 14:28:35 -0700 (PDT)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH v7] ndctl: Add support for get bus and region
 persistence domain
Date: Wed, 21 Mar 2018 21:35:04 +0000
Message-ID: <112A412BB11A1242B37129D931BCE53483099625@fmsmsx117.amr.corp.intel.com>
References: <152166202957.70855.18173170834465139126.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4g_dREKGiaqnk=N9gqO+h3h+__c3RkTmTVX+J4gB87Z7Q@mail.gmail.com>
In-Reply-To: <CAPcyv4g_dREKGiaqnk=N9gqO+h3h+__c3RkTmTVX+J4gB87Z7Q@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Wednesday, March 21, 2018 2:32 PM
> To: Jiang, Dave <dave.jiang@intel.com>
> Cc: Verma, Vishal L <vishal.l.verma@intel.com>; Ross Zwisler <ross.zwisler@linux.intel.com>; linux-nvdimm <linux-
> nvdimm@lists.01.org>
> Subject: Re: [PATCH v7] ndctl: Add support for get bus and region persistence domain
> 
> On Wed, Mar 21, 2018 at 12:55 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> > Adding helper functions to iterate through sysfs region persistence domain
> > attribute. The region will display the domain with the most persistence for the
> > region.  The bus will display the domain attribute with the least persistence
> > amongst all the regions. ndctl_bus_get_persistence_domain() and
> > ndctl_region_get_persistence_domain are exported. ndctl list will also display
> > the region persistence domain as well.
> >
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> > v7:
> > - set attrib to unknown when no attrib detected instead of none. will add
> >   support of none attrib in kernel at a later time.
> >
> > v6:
> > - emit "none" when there's nothing in sysfs attrib, and "unknown" when there
> >   is no sysfs attrib at all.
> > - Use sysfs_read_attr() to retrieve domain values
> > - Change INT32_MAX to INT_MAX.
> >
> > v5:
> > - space out ndctl_persistence_domain for future attributes
> >
> > v4:
> > - change enum ndctl_persistence to enum ndctl_persistence_domain
> >
> > v3:
> > - fixed up return types per Ross's comments
> > - removed persistence_domain for bus and calculate on the fly per Dan's comment
> >
> > v2:
> > - Simplied scanning of persistence domain from Ross's comments.
> >
> >  ndctl/lib/libndctl.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  ndctl/lib/libndctl.sym |    2 +
> >  ndctl/libndctl.h       |   13 +++++++
> >  ndctl/list.c           |   20 +++++++++++
> >  4 files changed, 123 insertions(+)
> >
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index a165e697..991042df 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -180,6 +180,7 @@ struct ndctl_region {
> >         } iset;
> >         FILE *badblocks;
> >         struct badblock bb;
> > +       enum ndctl_persistence_domain persistence_domain;
> >  };
> >
> >  /**
> > @@ -916,6 +917,22 @@ NDCTL_EXPORT struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
> >         return NULL;
> >  }
> >
> > +NDCTL_EXPORT enum ndctl_persistence_domain
> > +ndctl_bus_get_persistence_domain(struct ndctl_bus *bus)
> > +{
> > +       struct ndctl_region *region;
> > +       enum ndctl_persistence_domain pd = PERSISTENCE_UNKNOWN;
> > +
> > +       /* iterate through region to get the region persistence domain */
> > +       ndctl_region_foreach(bus, region) {
> > +               /* we are looking for the least persistence domain */
> > +               if (pd > region->persistence_domain)
> 
> If I'm reading this right it will never return anything other than
> PERSISTENCE_UNKNOWN because nothing is greater than INT_MAX. It seems
> this should start at -1 and then be the max of all regions. If it's
> still -1 at the end of the loop then return PERSISTENCE_UNKNOWN
> otherwise the max.

Yep. Forgot to fixup this part. 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
