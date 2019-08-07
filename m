Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9A25212BF9A5
 for <linux-nvdimm@lists.01.org>; Wed,  7 Aug 2019 08:37:05 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s20so40459144otp.4
 for <linux-nvdimm@lists.01.org>; Wed, 07 Aug 2019 08:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190807040029.11344-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4haXOjn7K-HgPV_WLqbfqRQbbiq=LvLt5Ue=OPAaBWN6A@mail.gmail.com>
 <c99ecdad-e9de-cd76-1601-841de35602a0@linux.ibm.com>
 <CAPcyv4ia5F73Qd0FyOWkHAUGoXrPFFQwA-R3DNXb0mGyOS5fgQ@mail.gmail.com>
 <9c397eca-9152-9da7-fcde-8aa424c8fede@linux.ibm.com>
In-Reply-To: <9c397eca-9152-9da7-fcde-8aa424c8fede@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Aug 2019 08:34:23 -0700
Message-ID: <CAPcyv4gEUQWXv7ROjmoxe715UBwBbJKoWoNeRQUgoN_=H=-p+w@mail.gmail.com>
Subject: Re: [PATCH] nvdimm/of_pmem: Provide a unique name for bus provider
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
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 6, 2019 at 11:00 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> On 8/7/19 10:22 AM, Dan Williams wrote:
> > On Tue, Aug 6, 2019 at 9:17 PM Aneesh Kumar K.V
> > <aneesh.kumar@linux.ibm.com> wrote:
> >>
> >> On 8/7/19 9:43 AM, Dan Williams wrote:
> >>> On Tue, Aug 6, 2019 at 9:00 PM Aneesh Kumar K.V
> >>> <aneesh.kumar@linux.ibm.com> wrote:
> >>>>
> >>>> ndctl utility requires the ndbus to have unique names. If not while
> >>>> enumerating the bus in userspace it drops bus with similar names.
> >>>> This results in us not listing devices beneath the bus.
> >>>
> >>> It does?
> >>>
> >>>>
> >>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> >>>> ---
> >>>>    drivers/nvdimm/of_pmem.c | 2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> >>>> index a0c8dcfa0bf9..97187d6c0bdb 100644
> >>>> --- a/drivers/nvdimm/of_pmem.c
> >>>> +++ b/drivers/nvdimm/of_pmem.c
> >>>> @@ -42,7 +42,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
> >>>>                   return -ENOMEM;
> >>>>
> >>>>           priv->bus_desc.attr_groups = bus_attr_groups;
> >>>> -       priv->bus_desc.provider_name = "of_pmem";
> >>>> +       priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
> >>>
> >>> This looks ok to me to address support for older ndctl binaries, but
> >>> I'd like to also fix the ndctl bug that makes non-unique provider
> >>> names fail.
> >>>
> >>
> >> 0462269ab121d323a016874ebdd42217f2911ee7 (ndctl: provide a method to
> >> invalidate the bus list)
> >>
> >> This hunk does the filtering.
> >>
> >> @@ -928,6 +929,14 @@ static int add_bus(void *parent, int id, const char
> >> *ctl_base)
> >>                  goto err_read;
> >>          bus->buf_len = strlen(bus->bus_path) + 50;
> >>
> >> +       ndctl_bus_foreach(ctx, bus_dup)
> >> +               if (strcmp(ndctl_bus_get_provider(bus_dup),
> >> +                                       ndctl_bus_get_provider(bus)) == 0) {
> >> +                       free_bus(bus, NULL);
> >> +                       free(path);
> >> +                       return 1;
> >> +               }
> >> +
> >
> > Yup, that's broken, does this incremental fix work?
> >
> > diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> > index 4d9cc7e29c6b..6596f94edef8 100644
> > --- a/ndctl/lib/libndctl.c
> > +++ b/ndctl/lib/libndctl.c
> > @@ -889,7 +889,9 @@ static void *add_bus(void *parent, int id, const
> > char *ctl_base)
> >
> >          ndctl_bus_foreach(ctx, bus_dup)
> >                  if (strcmp(ndctl_bus_get_provider(bus_dup),
> > -                                       ndctl_bus_get_provider(bus)) == 0) {
> > +                                       ndctl_bus_get_provider(bus)) == 0
> > +                               && strcmp(ndctl_bus_get_devname(bus_dup),
> > +                                       ndctl_bus_get_devname(bus)) == 0) {
> >                          free_bus(bus, NULL);
> >                          free(path);
> >                          return bus_dup;
> >
>
> That worked.

Great. I'll make a formal patch, and I'll amend the changelog of the
proposed kernel change to say "older ndctl binaries mistakenly
require"
>
> -aneesh
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
