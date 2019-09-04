From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ndctl PATCH 2/2] libdaxctl: fix device reconfiguration with
 builtin drivers
Date: Wed, 4 Sep 2019 14:39:56 -0700
Message-ID: <CAPcyv4iTH9SuCUNSJ0Snw5cz6YpX6O887PAkR6fPEmQ7iWRGmw@mail.gmail.com>
References: <20190904010819.11012-1-vishal.l.verma@intel.com>
 <20190904010819.11012-2-vishal.l.verma@intel.com>
 <CAPcyv4ipdLhKSUVZ-U3ZFpcuw=tJJTq1ZW5x6vJ-bJNReyjJbQ@mail.gmail.com>
 <be47815b3d454ce76a81799ba355b5579713c916.camel@intel.com>
 <CAPcyv4inooSbqCaAXJ4KzwVMxcDpfKpMD2QG5aXOP_sKnFy6UQ@mail.gmail.com>
 <25878b6903086ee20d332a02cd784065d93cea61.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <25878b6903086ee20d332a02cd784065d93cea61.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Brice.Goglin-MZpvjPyXg2s@public.gmane.org" <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 4, 2019 at 2:17 PM Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> On Wed, 2019-09-04 at 14:01 -0700, Dan Williams wrote:
> > On Wed, Sep 4, 2019 at 1:27 PM Verma, Vishal L <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > On Tue, 2019-09-03 at 19:20 -0700, Dan Williams wrote:
> > > >
> > > > Hmm, why wait until now to check if this list is NULL. How about fall
> > > > back to kmod_module_new_from_name() at to_module_list() time? That
> > > > would seem to simplify this follow up routine to not need to worry
> > > > about working around a NULL list.
> > >
> > > So we moved the list checking to later in the process around v4 of the
> > > original series, so that we don't unnecessarily fail add_dax_dev() if
> > > for some reason a list wasn't created.
> >
> > Ah true, I forgot that wrinkle, however...
> >
> > > Also, we use mod_name = dax_modules[mode] during an 'enable' to
> > > determine the module name to use for the fallback - we wouldn't have
> > > this at add_dax_dev() time.
> >
> > Since modalias is already not reliable it seems the implementation
> > should go ahead never do module lookups and just do everything based
> > on module names.
> >
> > In other words the libndctl panacea of not needing to hard code module
> > names is already lost in libdaxctl land. If the code drops modalias
> > usage does that clean up some of these flows?
>
> Yep I think so - we use modalias to construct a lookup list, but we
> still have to use the name to resolve to the final module based on the
> mode. I think we can remove the list lookup and replace it with simply:
>
>         kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
>
> It would clean up the module related flows, but is there any
> disadvantage to doing this?

The small disadvantage is that now libdaxctl is not immune to upstream
kernel reworks that might rename, or eliminate the module. libndctl
has that immunity to those type of reworks, but it is only a
theoretical problem. In practice modules don't renamed or eliminated
all that often. In the case of dax the device-model reworks almost
violated that assumption, but CONFIG_DEV_DAX_PMEM_COMPAT covered the
gap.
