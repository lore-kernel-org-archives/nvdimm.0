Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B617D21276B97
 for <linux-nvdimm@lists.01.org>; Wed, 29 May 2019 10:25:24 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v4 02/10] libdaxctl: cache 'subsystem' in daxctl_ctx
Date: Wed, 29 May 2019 17:25:23 +0000
Message-ID: <8bd400d85de8e4edf151b74c1fc5b857954ea37b.camel@intel.com>
References: <20190528222440.30392-1-vishal.l.verma@intel.com>
 <20190528222440.30392-3-vishal.l.verma@intel.com>
 <CAPcyv4heAvTzOePSe=uJ_+p4gOqG9d9Eqec_nA21P8KzzXS+kw@mail.gmail.com>
In-Reply-To: <CAPcyv4heAvTzOePSe=uJ_+p4gOqG9d9Eqec_nA21P8KzzXS+kw@mail.gmail.com>
Content-Language: en-US
Content-ID: <9511843EF9A92C47A82DEDDA7EDBF15A@intel.com>
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

On Tue, 2019-05-28 at 17:27 -0700, Dan Williams wrote:
> On Tue, May 28, 2019 at 3:24 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > The 'DAX subsystem' in effect is determined at region or device init
> > time, and dictates the sysfs base paths for all device/region
> > operations. In preparation for adding bind/unbind functionality, cache
> > the subsystem as determined at init time in the library context.
> 
> I'm missing how this patch determines the subsystem at init time? ...more below.
> 
[..]

> >  }
> > @@ -454,14 +456,18 @@ static void dax_devices_init(struct daxctl_region *region)
> >         for (i = 0; i < ARRAY_SIZE(dax_subsystems); i++) {
> >                 char *region_path;
> > 
> > -               if (i == DAX_BUS)
> > +               if (i == DAX_BUS) {
> >                         region_path = region->region_path;
> > -               else if (i == DAX_CLASS) {
> > +                       if (ctx->subsys == DAX_UNKNOWN)
> > +                               ctx->subsys = DAX_BUS;
> > +               } else if (i == DAX_CLASS) {
> >                         if (asprintf(&region_path, "%s/dax",
> >                                                 region->region_path) < 0) {
> >                                 dbg(ctx, "region path alloc fail\n");
> >                                 continue;
> >                         }
> > +                       if (ctx->subsys == DAX_UNKNOWN)
> > +                               ctx->subsys = DAX_CLASS;
> >                 } else
> >                         continue;
> >                 sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
> 
> dax_devices_init() is just blindly looping through both device models
> attempting to add devices. If this patch was detecting device-models I
> would expect it would be looking for the first successful
> sysfs_device_parse() to judge which of those blind shots actually
> worked.

I see - I was definitely misunderstanding how this worked. I'll fix up
for v5, essentially something like:

-               sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
-                               add_dax_dev);
+               if (sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
+                               add_dax_dev) == 0)
+                       ctx->subsys = i;



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
