Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0E7F211093B7
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jun 2018 16:21:25 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl, list: display the 'map' location in
 listings
Date: Mon, 4 Jun 2018 23:21:22 +0000
Message-ID: <1528154481.5328.19.camel@intel.com>
References: <20180529231503.31710-1-vishal.l.verma@intel.com>
 <CAPcyv4gs7fNLLXx96neHWVVdn_A74_SeDWRKT4054jX5U_21YQ@mail.gmail.com>
In-Reply-To: <CAPcyv4gs7fNLLXx96neHWVVdn_A74_SeDWRKT4054jX5U_21YQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <70BEDA07A38F254C8C22B7A33D64EF55@intel.com>
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
Cc: "yigal.korman@netapp.com" <yigal.korman@netapp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-06-01 at 17:01 -0700, Dan Williams wrote:
> On Tue, May 29, 2018 at 4:15 PM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> > For 'fsdax' and 'devdax' namespaces, a 'map' location may be specified
> > for page structures storage. This can be 'mem', for system RAM, or
> > 'dev'
> > for using pmem as the backing storage. Once set, there was no way of
> > telling using ndctl, which of the two locations a namespace was
> > configured for. Add this in util_namespace_to_json so that all
> > namespace listings contain the map location.
> > 
> > Reported-by: "Yigal Korman" <yigal.korman@netapp.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  util/json.c | 32 +++++++++++++++++++++++++++-----
> >  1 file changed, 27 insertions(+), 5 deletions(-)
> > 
> > v2: Also account for memmap=ss!nn or legacy-e820 namespaces. (Dan)
> > 
> > diff --git a/util/json.c b/util/json.c
> > index c606e1c..b020300 100644
> > --- a/util/json.c
> > +++ b/util/json.c
> > @@ -667,11 +667,17 @@ struct json_object *util_namespace_to_json(struct
> > ndctl_namespace *ndns,
> >  {
> >         struct json_object *jndns = json_object_new_object();
> >         struct json_object *jobj, *jbbs = NULL;
> > +       const char *locations[] = {
> > +               [NDCTL_PFN_LOC_NONE] = "none",
> > +               [NDCTL_PFN_LOC_RAM] = "mem",
> > +               [NDCTL_PFN_LOC_PMEM] = "dev",
> > +       };
> >         unsigned long long size = ULLONG_MAX;
> >         unsigned int sector_size = UINT_MAX;
> >         enum ndctl_namespace_mode mode;
> >         const char *bdev = NULL, *name;
> >         unsigned int bb_count = 0;
> > +       enum ndctl_pfn_loc loc;
> 
> we could initialize loc to NDCTL_PFN_LOC_NONE here.
> 
> >         struct ndctl_btt *btt;
> >         struct ndctl_pfn *pfn;
> >         struct ndctl_dax *dax;
> > @@ -693,33 +699,49 @@ struct json_object *util_namespace_to_json(struct
> > ndctl_namespace *ndns,
> >         mode = ndctl_namespace_get_mode(ndns);
> >         switch (mode) {
> >         case NDCTL_NS_MODE_MEMORY:
> > -               if (pfn) /* dynamic memory mode */
> > +               jobj = json_object_new_string("fsdax");
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "mode", jobj);
> > +               loc = ndctl_pfn_get_location(pfn);
> 
> NULL ptr de-reference if pfn is NULL
> 
> > +               if (pfn) { /* dynamic memory mode */
> 
> 
> >                         size = ndctl_pfn_get_size(pfn);
> > -               else /* native/static memory mode */
> > +                       jobj = json_object_new_string(locations[loc]);
> > +               } else { /* native/static memory mode */
> >                         size = ndctl_namespace_get_size(ndns);
> > -               jobj = json_object_new_string("fsdax");
> > +                       jobj = json_object_new_string("mem");
> 
> We could just set NDCTL_PFN_LOC_RAM here.
> 
> > +               }
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "map", jobj);
> >                 break;
> >         case NDCTL_NS_MODE_DAX:
> >                 if (!dax)
> >                         goto err;
> >                 size = ndctl_dax_get_size(dax);
> >                 jobj = json_object_new_string("devdax");
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "mode", jobj);
> > +               loc = ndctl_dax_get_location(dax);
> > +               jobj = json_object_new_string(locations[loc]);
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "map", jobj);
> >                 break;
> >         case NDCTL_NS_MODE_SAFE:
> >                 if (!btt)
> >                         goto err;
> >                 jobj = json_object_new_string("sector");
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "mode", jobj);
> >                 size = ndctl_btt_get_size(btt);
> >                 break;
> >         case NDCTL_NS_MODE_RAW:
> >                 size = ndctl_namespace_get_size(ndns);
> >                 jobj = json_object_new_string("raw");
> > +               if (jobj)
> > +                       json_object_object_add(jndns, "mode", jobj);
> >                 break;
> >         default:
> >                 jobj = NULL;
> >         }
> > -       if (jobj)
> > -               json_object_object_add(jndns, "mode", jobj);
> 
> Why is mode getting moved into each case?
> 
> I'd put the
> 
>     jobj = json_object_new_string(locations[loc]);
>     if (jobj)
>         json_object_object_add(jndns, "map", jobj);
> 
> ...at the end here and just gate it on mode != NDCTL_NS_MODE_SAFE &&
> mode != NDCTL_NS_MODE_RAW

Good points, this makes it much cleaner. I'll send a new version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
