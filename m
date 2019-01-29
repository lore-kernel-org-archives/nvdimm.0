Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9B10211BD5F9
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 11:43:42 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id v6so17219724oif.2
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 11:43:42 -0800 (PST)
MIME-Version: 1.0
References: <20190116094909.23112-1-oohall@gmail.com>
 <20190116094909.23112-6-oohall@gmail.com>
 <CAOSf1CGhcod_5fQfDjkXSNM51ECFaFrjPx-9++xfQmS1OTNbBg@mail.gmail.com>
 <18cf9fb70675d39ecde5cee456e0e87471047d08.camel@intel.com>
In-Reply-To: <18cf9fb70675d39ecde5cee456e0e87471047d08.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Jan 2019 11:43:30 -0800
Message-ID: <CAPcyv4it4KaUHw0BXsRNsc2M84zLVD=gxY1RaCnq0BhM7K9-0w@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ndctl: Add supported_alignments to the JSON output
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 29, 2019 at 11:28 AM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
>
> On Wed, 2019-01-30 at 01:40 +1100, Oliver wrote:
> > On Wed, Jan 16, 2019 at 8:49 PM Oliver O'Halloran <oohall@gmail.com> wrote:
> > > Add the list of supported alignemnts to PFN and DAX namespaces. Also add the
> > > list of supported sector sizes to BTT namespaces.
> > >
> > > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > > ---
> > > Not sure the namespace JSON blob are the best place to put these. The
> > > region might be better, but slightly less accessable to users.
> > > ---
> > >  util/json.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 47 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/util/json.c b/util/json.c
> > > index 77c96fb53c27..6c66033bd312 100644
> > > --- a/util/json.c
> > > +++ b/util/json.c
> > > @@ -303,6 +303,38 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
> > >         return jdevs;
> > >  }
> > >
> > > +#define _SZ(get_max, get_elem, type) \
> > > +static struct json_object *type##_build_size_array(struct type *arg)   \
> > > +{                                                              \
> > > +       struct json_object *arr = json_object_new_array();      \
> > > +       int i;                                                  \
> > > +                                                               \
> > > +       if (!arr)                                               \
> > > +               return NULL;                                    \
> > > +                                                               \
> > > +       for (i = 0; i < get_max(arg); i++) {                    \
> > > +               struct json_object *jobj;                       \
> > > +               int64_t align;                                  \
> > > +                                                               \
> > > +               align = get_elem(arg, i);                       \
> > > +               jobj = json_object_new_int64(align);            \
> > > +               if (!jobj)                                      \
> > > +                       goto err;                               \
> > > +               json_object_array_add(arr, jobj);               \
> > > +       }                                                       \
> > > +                                                               \
> > > +       return arr;                                             \
> > > +err:                                                           \
> > > +       json_object_put(arr);                                   \
> > > +       return NULL;                                            \
> > > +}
> > > +#define SZ(type, kind) _SZ(ndctl_##type##_get_num_##kind##s, \
> > > +                          ndctl_##type##_get_supported_##kind, ndctl_##type)
> > > +SZ(pfn, alignment)
> > > +SZ(dax, alignment)
> > > +SZ(btt, sector_size)
> > > +//SZ(namespace, sector_size)
> > > +
> > >  struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
> > >                 const char *ident, unsigned long flags)
> > >  {
> > > @@ -739,7 +771,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
> > >  {
> > >         struct json_object *jndns = json_object_new_object();
> > >         enum ndctl_pfn_loc loc = NDCTL_PFN_LOC_NONE;
> > > -       struct json_object *jobj, *jbbs = NULL;
> > > +       struct json_object *jobj, *jbbs = NULL, *size_array = NULL;
> > >         const char *locations[] = {
> > >                 [NDCTL_PFN_LOC_NONE] = "none",
> > >                 [NDCTL_PFN_LOC_RAM] = "mem",
> > > @@ -749,6 +781,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
> > >         unsigned int sector_size = UINT_MAX;
> > >         enum ndctl_namespace_mode mode;
> > >         const char *bdev = NULL, *name;
> > > +       const char *size_array_name;
> > >         unsigned int bb_count = 0;
> > >         struct ndctl_btt *btt;
> > >         struct ndctl_pfn *pfn;
> > > @@ -936,6 +969,19 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
> > >                         json_object_object_add(jndns, "numa_node", jobj);
> > >         }
> > >
> > > +       if (pfn) {
> > > +               size_array_name = "supported_alignments";
> > > +               size_array = ndctl_pfn_build_size_array(pfn);
> > > +       } else if (dax) {
> > > +               size_array_name = "supported_alignments";
> > > +               size_array = ndctl_dax_build_size_array(dax);
> > > +       } else if (btt) {
> > > +               size_array_name = "supported sector sizes";
> > > +               size_array = ndctl_btt_build_size_array(btt);
> > > +       }
> > > +       if (size_array)
> > > +               json_object_object_add(jndns, size_array_name, size_array);
> >
> > So apparently I forgot to run the `make check` on v3 because this
> > completely breaks the unit tests.
> >
> > The problem is that the tests rely on a sed script to parse the JSON
> > blob into shell variables. That works when the JSON blob only contains
> > scalars (and strings with no spaces), but it chokes when confronted
> > with a JSON array. I can't think of any simple ways to fix it other
> > than using a real JSON parser (jq?). Should I drop this patch for now?
> > I don't mind doing a real fix if you don't mind waiting a bit longer
> > :)
>
> I think we should just fix the tests to properly parse json - we use jq
> in several other places, and if something that didn't use jq breaks the
> hackier sed/eval stuff, we should just take the chance to fix that in
> the test. If this is a larger piece of work, I'm happy to defer it to
> the next release. The other semi-related question might be, should we
> always show the supported alignments array, or should hide it under one
> or more -v verbosity levels. How often would a user need to know these?
> If the array is now shown at the default non-verbose level, then maybe
> the parsing problem goes away until a future time :)
>

Yeah, if gating this property on UTIL_JSON_VERBOSE fixes the unit test
that seems like the fastest way forward for now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
