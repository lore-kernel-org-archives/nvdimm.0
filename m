Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3152B2263DD6D
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 14:47:48 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, util: add a raw_uuid field to namespace
 listings
Date: Mon, 16 Apr 2018 21:47:46 +0000
Message-ID: <1523915264.2552.7.camel@intel.com>
References: <20180416212703.14805-1-vishal.l.verma@intel.com>
 <CAPcyv4gWkF0cTCVH1_BNw8287Z_p-ObFS7jM7HUwzXb91xBM3Q@mail.gmail.com>
In-Reply-To: <CAPcyv4gWkF0cTCVH1_BNw8287Z_p-ObFS7jM7HUwzXb91xBM3Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <7D062AA341AF8E4BADAC5D4C8C34AAF6@intel.com>
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

On Mon, 2018-04-16 at 14:41 -0700, Dan Williams wrote:
> On Mon, Apr 16, 2018 at 2:27 PM, Vishal Verma <vishal.l.verma@intel.com>
> wrote:
> > For boot support efibootmgr needs to be able to lookup up the raw
> > namespace uuid to match the device-path that EFI emits. By default
> > 'ndctl list' displays the uuid that is present in the address
> > abstraction info-block. Add a "raw_uuid" so that tooling can
> > correlate the default uuid with the base uuid for the namespace.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  util/json.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/util/json.c b/util/json.c
> > index 8d65525..efad8f7 100644
> > --- a/util/json.c
> > +++ b/util/json.c
> > @@ -650,6 +650,17 @@ static struct json_object
> > *util_dax_badblocks_to_json(struct ndctl_dax *dax,
> >                         bb_count, flags);
> >  }
> > 
> > +static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
> > +{
> > +       struct json_object *jobj;
> > +       uuid_t raw_uuid;
> > +       char buf[40];
> > +
> > +       ndctl_namespace_get_uuid(ndns, raw_uuid);
> > +       uuid_unparse(raw_uuid, buf);
> > +       return json_object_new_string(buf);
> > +}
> > +
> 
> I don't mind this new helper, but it seems out of place given all the
> other uuid-to-json-string conversions are open-coded in
> util_namespace_to_json(). Let's just open-code like all the rest, and
> maybe follow on with a global cleanup to use a helper in a later
> patch. However, I'm not sure it will be worth it / a net code
> reduction.

Sure - the others were calling ndctl_{btt,pfn,dax}_get_uuid, where as with
this, all the instances call ndctl namespace_get_uuid hence I factored it
out as a function, but I'm happy to open code it in the three sites.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
