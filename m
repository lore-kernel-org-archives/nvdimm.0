Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A92F82114A6D1
 for <linux-nvdimm@lists.01.org>; Thu, 20 Sep 2018 19:46:15 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c12-v6so11581369otl.6
 for <linux-nvdimm@lists.01.org>; Thu, 20 Sep 2018 19:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222951.19464.39241.stgit@localhost.localdomain>
 <CAPcyv4hAEOUOBU4GENaFOb-xXi33g_ugCexfmY3DrLH27Z6MKg@mail.gmail.com>
 <b7e87e64-95d7-5118-6c7d-ad78d68dc92e@linux.intel.com>
 <CAPcyv4iE=mrvdfXQ94O1r_u1geLbxpF0so3_3z4JLky4SuUNdw@mail.gmail.com>
 <0d6525c1-2e8b-0e5d-7dae-193bf697a4ec@linux.intel.com>
In-Reply-To: <0d6525c1-2e8b-0e5d-7dae-193bf697a4ec@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Sep 2018 19:46:02 -0700
Message-ID: <CAPcyv4hqERm3YbgsE19M=8SRfrhyEo__LrLdcEj_YsLr2bLviA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] nvdimm: Schedule device registration on node local
 to the device
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
To: alexander.h.duyck@linux.intel.com
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 20, 2018 at 6:34 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
>
>
> On 9/20/2018 5:36 PM, Dan Williams wrote:
> > On Thu, Sep 20, 2018 at 5:26 PM Alexander Duyck
> > <alexander.h.duyck@linux.intel.com> wrote:
> >>
> >> On 9/20/2018 3:59 PM, Dan Williams wrote:
> >>> On Thu, Sep 20, 2018 at 3:31 PM Alexander Duyck
> >>> <alexander.h.duyck@linux.intel.com> wrote:
> >>>>
> >>>> This patch is meant to force the device registration for nvdimm devices to
> >>>> be closer to the actual device. This is achieved by using either the NUMA
> >>>> node ID of the region, or of the parent. By doing this we can have
> >>>> everything above the region based on the region, and everything below the
> >>>> region based on the nvdimm bus.
> >>>>
> >>>> One additional change I made is that we hold onto a reference to the parent
> >>>> while we are going through registration. By doing this we can guarantee we
> >>>> can complete the registration before we have the parent device removed.
> >>>>
> >>>> By guaranteeing NUMA locality I see an improvement of as high as 25% for
> >>>> per-node init of a system with 12TB of persistent memory.
> >>>>
> >>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >>>> ---
> >>>>    drivers/nvdimm/bus.c |   19 +++++++++++++++++--
> >>>>    1 file changed, 17 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> >>>> index 8aae6dcc839f..ca935296d55e 100644
> >>>> --- a/drivers/nvdimm/bus.c
> >>>> +++ b/drivers/nvdimm/bus.c
> >>>> @@ -487,7 +487,9 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
> >>>>                   dev_err(dev, "%s: failed\n", __func__);
> >>>>                   put_device(dev);
> >>>>           }
> >>>> +
> >>>>           put_device(dev);
> >>>> +       put_device(dev->parent);
> >>>
> >>> Good catch. The child does not pin the parent until registration, but
> >>> we need to make sure the parent isn't gone while were waiting for the
> >>> registration work to run.
> >>>
> >>> Let's break this reference count fix out into its own separate patch,
> >>> because this looks to be covering a gap that may need to be
> >>> recommended for -stable.
> >>
> >> Okay, I guess I can do that.
> >>
> >>>
> >>>>
> >>>>    static void nd_async_device_unregister(void *d, async_cookie_t cookie)
> >>>> @@ -504,12 +506,25 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
> >>>>
> >>>>    void __nd_device_register(struct device *dev)
> >>>>    {
> >>>> +       int node;
> >>>> +
> >>>>           if (!dev)
> >>>>                   return;
> >>>> +
> >>>>           dev->bus = &nvdimm_bus_type;
> >>>> +       get_device(dev->parent);
> >>>>           get_device(dev);
> >>>> -       async_schedule_domain(nd_async_device_register, dev,
> >>>> -                       &nd_async_domain);
> >>>> +
> >>>> +       /*
> >>>> +        * For a region we can break away from the parent node,
> >>>> +        * otherwise for all other devices we just inherit the node from
> >>>> +        * the parent.
> >>>> +        */
> >>>> +       node = is_nd_region(dev) ? to_nd_region(dev)->numa_node :
> >>>> +                                  dev_to_node(dev->parent);
> >>>
> >>> Devices already automatically inherit the node of their parent, so I'm
> >>> not understanding why this is needed?
> >>
> >> That doesn't happen until you call device_add, which you don't call
> >> until nd_async_device_register. All that has been called on the device
> >> up to now is device_initialize which leaves the node at NUMA_NO_NODE.
> >
> > Ooh, yeah, missed that. I think I'd prefer this policy to moved out to
> > where we set the dev->parent before calling __nd_device_register, or
> > at least a comment here about *why* we know region devices are special
> > (i.e. because the nd_region_desc specified the node at region creation
> > time).
> >
>
> Are you talking about pulling the scheduling out or just adding a node
> value to the nd_device_register call so it can be set directly from the
> caller?

I was thinking everywhere we set dev->parent before registering, also
set the node...

> If you wanted what I could do is pull the set_dev_node call from
> nvdimm_bus_uevent and place it in nd_device_register. That should stick
> as the node doesn't get overwritten by the parent if it is set after
> device_initialize. If I did that along with the parent bit I was already
> doing then all that would be left to do in is just use the dev_to_node
> call on the device itself.

...but this is even better.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
