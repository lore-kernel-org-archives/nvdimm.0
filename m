Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E8722063D753
 for <linux-nvdimm@lists.01.org>; Tue, 29 May 2018 11:52:11 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, list: display the 'map' location in listings
Date: Tue, 29 May 2018 18:52:09 +0000
Message-ID: <1527619927.5328.0.camel@intel.com>
References: <20180525223556.9244-1-vishal.l.verma@intel.com>
 <CAA9_cmf6PRzmZBr0aHr65EUqZo_eY95nzD3Y2sW9jho9uPDxeQ@mail.gmail.com>
In-Reply-To: <CAA9_cmf6PRzmZBr0aHr65EUqZo_eY95nzD3Y2sW9jho9uPDxeQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <FACB83138009CC40950D76A28EF60610@intel.com>
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
Cc: "Yigal.Korman@netapp.com" <Yigal.Korman@netapp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-05-28 at 11:04 -0700, Dan Williams wrote:
> On Fri, May 25, 2018 at 3:36 PM Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> 
> > For 'fsdax' and 'devdax' namespaces, a 'map' location may be specified
> > for page structures storage. This can be 'mem', for system RAM, or
> > 'dev'
> > for using pmem as the backing storage. Once set, there was no way of
> > telling using ndctl, which of the two locations a namespace was
> > configured for. Add this in util_namespace_to_json so that all
> > namespace listings contain the map location.
> > Reported-by: "Yigal Korman" <yigal.korman@netapp.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >   util/json.c | 18 ++++++++++++++++++
> >   1 file changed, 18 insertions(+)
> > diff --git a/util/json.c b/util/json.c
> > index c606e1c..17dd90c 100644
> > --- a/util/json.c
> > +++ b/util/json.c
> > @@ -667,11 +667,17 @@ struct json_object *util_namespace_to_json(struct
> 
> ndctl_namespace *ndns,
> >   {
> >          struct json_object *jndns = json_object_new_object();
> >          struct json_object *jobj, *jbbs = NULL;
> > +       const char *locations[] = {
> > +               [NDCTL_PFN_LOC_NONE] = "none",
> > +               [NDCTL_PFN_LOC_RAM] = "mem",
> > +               [NDCTL_PFN_LOC_PMEM] = "dev",
> > +       };
> >          unsigned long long size = ULLONG_MAX;
> >          unsigned int sector_size = UINT_MAX;
> >          enum ndctl_namespace_mode mode;
> >          const char *bdev = NULL, *name;
> >          unsigned int bb_count = 0;
> > +       enum ndctl_pfn_loc loc;
> >          struct ndctl_btt *btt;
> >          struct ndctl_pfn *pfn;
> >          struct ndctl_dax *dax;
> > @@ -749,6 +755,12 @@ struct json_object *util_namespace_to_json(struct
> 
> ndctl_namespace *ndns,
> >                  jobj = util_raw_uuid(ndns);
> >                  if (jobj)
> >                          json_object_object_add(jndns, "raw_uuid",
> > jobj);
> > +               loc = ndctl_pfn_get_location(pfn);
> > +               jobj = json_object_new_string(locations[loc]);
> > +               if (!jobj)
> > +                       goto err;
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "map", jobj);
> >                  bdev = ndctl_pfn_get_block_device(pfn);
> >          } else if (dax) {
> >                  struct daxctl_region *dax_region;
> > @@ -763,6 +775,12 @@ struct json_object *util_namespace_to_json(struct
> 
> ndctl_namespace *ndns,
> >                  jobj = util_raw_uuid(ndns);
> >                  if (jobj)
> >                          json_object_object_add(jndns, "raw_uuid",
> > jobj);
> > +               loc = ndctl_dax_get_location(dax);
> > +               jobj = json_object_new_string(locations[loc]);
> > +               if (!jobj)
> > +                       goto err;
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "map", jobj);
> >                  if ((flags & UTIL_JSON_DAX) && dax_region) {
> >                          jobj = util_daxctl_region_to_json(dax_region,
> 
> NULL,
> >                                          flags);
> 
> There appears to be one case missing in this:
> 
>          case NDCTL_NS_MODE_MEMORY:
>                  if (pfn) /* dynamic memory mode */
>                          size = ndctl_pfn_get_size(pfn);
>                  else /* native/static memory mode */
>                          size = ndctl_namespace_get_size(ndns);
>                  jobj = json_object_new_string("fsdax");
>                  break;
> 
> In the "/* native/static memory mode */" configuration we should emit a
> 'map:"mem"' indication.

Ah good catch. Is this for legacy/labelless namespaces that have been
configured into fsdax mode?

I'll fixup and send a new version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
