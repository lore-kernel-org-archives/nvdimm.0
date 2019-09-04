From: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ndctl PATCH 2/2] libdaxctl: fix device reconfiguration with
 builtin drivers
Date: Wed, 4 Sep 2019 20:27:07 +0000
Message-ID: <be47815b3d454ce76a81799ba355b5579713c916.camel@intel.com>
References: <20190904010819.11012-1-vishal.l.verma@intel.com>
 <20190904010819.11012-2-vishal.l.verma@intel.com>
 <CAPcyv4ipdLhKSUVZ-U3ZFpcuw=tJJTq1ZW5x6vJ-bJNReyjJbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4ipdLhKSUVZ-U3ZFpcuw=tJJTq1ZW5x6vJ-bJNReyjJbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <659598B110F2684398092EAA311BD800-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Williams, Dan J" <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Brice.Goglin-MZpvjPyXg2s@public.gmane.org" <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, 2019-09-03 at 19:20 -0700, Dan Williams wrote:
> 
> > +static int try_kmod_builtin(struct daxctl_dev *dev, const char *mod_name)
> > +{
> > +       const char *devname = daxctl_dev_get_devname(dev);
> > +       struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> > +       struct kmod_module *kmod;
> > +       int rc = -ENXIO;
> > +
> > +       rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
> > +       if (rc < 0) {
> > +               err(ctx, "%s: failed getting module for: %s: %s\n",
> > +                       devname, mod_name, strerror(-rc));
> > +               return rc;
> > +       }
> > +
> > +       if (kmod_module_get_initstate(kmod) != KMOD_MODULE_BUILTIN)
> > +               return -ENXIO;
> > +
> > +       dbg(ctx, "%s inserting module: %s\n", devname,
> > +               kmod_module_get_name(kmod));
> > +       rc = kmod_module_probe_insert_module(kmod,
> > +                       KMOD_PROBE_APPLY_BLACKLIST,
> > +                       NULL, NULL, NULL, NULL);
> > +       if (rc < 0) {
> > +               err(ctx, "%s: insert failure: %d\n", devname, rc);
> > +               return rc;
> > +       }
> > +       dev->module = kmod;
> > +
> > +       return 0;
> > +}
> > +
> >  static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> >                 const char *mod_name)
> >  {
> > @@ -877,6 +908,8 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
> >         int rc = -ENXIO;
> > 
> >         if (dev->kmod_list == NULL) {
> 
> Hmm, why wait until now to check if this list is NULL. How about fall
> back to kmod_module_new_from_name() at to_module_list() time? That
> would seem to simplify this follow up routine to not need to worry
> about working around a NULL list.

So we moved the list checking to later in the process around v4 of the
original series, so that we don't unnecessarily fail add_dax_dev() if
for some reason a list wasn't created.

Also, we use mod_name = dax_modules[mode] during an 'enable' to
determine the module name to use for the fallback - we wouldn't have
this at add_dax_dev() time.
