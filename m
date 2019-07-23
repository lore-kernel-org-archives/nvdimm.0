Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A649921A07094
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 12:02:13 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id l15so45154469otn.9
 for <linux-nvdimm@lists.01.org>; Tue, 23 Jul 2019 11:59:47 -0700 (PDT)
MIME-Version: 1.0
References: <87a7f45qik.fsf@linux.ibm.com> <877ea85p64.fsf@linux.ibm.com>
In-Reply-To: <877ea85p64.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Jul 2019 11:59:35 -0700
Message-ID: <CAPcyv4hKSfeeo+eLu0=4-wca2TwBx5OJfaxD36o5uG8Vd=DibA@mail.gmail.com>
Subject: Re: Picking 0th namespace if it is idle
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 30, 2019 at 1:20 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> aneesh.kumar@linux.ibm.com (Aneesh Kumar K.V) writes:
>
> > Hi Dan,
> >
> > With the patch series to mark the namespace disabled if we have mismatch
> > in pfn superblock, we can endup with namespace0 marked idle/disabled.
> >
> > I am wondering why do do the below in ndctl.
> >
> >
> > static struct ndctl_namespace *region_get_namespace(struct ndctl_region *region)
> > {
> >       struct ndctl_namespace *ndns;
> >
> >       /* prefer the 0th namespace if it is idle */
> >       ndctl_namespace_foreach(region, ndns)
> >               if (ndctl_namespace_get_id(ndns) == 0
> >                               && !is_namespace_active(ndns))
> >                       return ndns;
> >       return ndctl_region_get_namespace_seed(region);

Without this change if you create 2 namespaces, destroy those two
namespaces and then create another namespace that newest namespace
might end up being namespace0.1 instead of namespace0.0. This ends up
confusing end users that don't understand why they end up with
/dev/pmem0.1 and then at reboot it changes back to /dev/pmem0. So it's
purely a cosmetic detail.

I think we could teach ndctl about how to detect this case as separate
from a typically idle namespace state. Effectively pfn-device bind
failures due to missing page size support is a new error state that
ndctl needs to be made aware of independent of the typical idle state.
However, all I think is needed here is to fallback to
ndctl_region_get_namespace_seed() if ndctl_namespace_get_size() is
non-zero.

> > }
> >
> > I have a kernel patch that will create a namespace_seed even if we fail
> > to ename a pfn backing device. Something like below
> >
> > @@ -747,12 +752,23 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
> >               }
> >       }
> >       if (dev->parent && is_nd_region(dev->parent) && probe) {
> >               nd_region = to_nd_region(dev->parent);
> >               nvdimm_bus_lock(dev);
> >               if (nd_region->ns_seed == dev)
> >                       nd_region_create_ns_seed(nd_region);
> >               nvdimm_bus_unlock(dev);
> >       }
> > +
> > +     if (dev->parent && is_nd_region(dev->parent) && !probe && (ret == -EOPNOTSUPP)) {
> > +             nd_region = to_nd_region(dev->parent);
> > +             nvdimm_bus_lock(dev);
> > +             if (nd_region->ns_seed == dev)
> > +                     nd_region_create_ns_seed(nd_region);
> > +             nvdimm_bus_unlock(dev);
> > +     }
> > +
> >
> > With that we can end up with something like the below after boot.
> > :/sys/bus/nd/devices/region0$ sudo ndctl list -Ni
> > [
> >   {
> >     "dev":"namespace0.1",
> >     "mode":"fsdax",
> >     "map":"mem",
> >     "size":0,
> >     "uuid":"00000000-0000-0000-0000-000000000000",
> >     "state":"disabled"
> >   },
> >   {
> >     "dev":"namespace0.0",
> >     "mode":"fsdax",
> >     "map":"mem",
> >     "size":2147483648,
> >     "uuid":"094e703b-4bf8-4078-ad42-50bebc03e538",
> >     "state":"disabled"
> >   }
> > ]
> >
> > namespace0.0 is the one we failed to initialize due to PAGE_SIZE
> > mismatch.
> >
> > We do have namespace_seed pointing to namespacece0.1 correct. But a ndtl
> > create-namespace will pick namespace0.0 even if we have seed file
> > pointing to namespacec0.1.
> >
> >
> > I am trying to resolve the issues related to creation of new namespaces
> > when we have some namespace marked disabled due to pfn_sb setting
> > mismatch.
> >
> > -aneesh
>
> With that ndctl namespace0.0 selection commented out, we do get pick the
> right idle namespace.
>
> #ndctl list -Ni
> [
>   {
>     "dev":"namespace0.1",
>     "mode":"fsdax",
>     "map":"mem",
>     "size":0,
>     "uuid":"00000000-0000-0000-0000-000000000000",
>     "state":"disabled"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"fsdax",
>     "map":"mem",
>     "size":2147483648,

Yes, this being non-zero means the namespace is not idle.

Maybe with --force we can ignore the size checking and just reclaim
the 0th namespace for a new namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
