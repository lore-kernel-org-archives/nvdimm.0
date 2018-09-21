Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 266F9211350C4
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 07:56:32 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id b15-v6so11626112oib.10
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 07:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222951.19464.39241.stgit@localhost.localdomain>
 <CAPcyv4hAEOUOBU4GENaFOb-xXi33g_ugCexfmY3DrLH27Z6MKg@mail.gmail.com>
 <b7e87e64-95d7-5118-6c7d-ad78d68dc92e@linux.intel.com>
 <CAPcyv4iE=mrvdfXQ94O1r_u1geLbxpF0so3_3z4JLky4SuUNdw@mail.gmail.com>
 <0d6525c1-2e8b-0e5d-7dae-193bf697a4ec@linux.intel.com>
 <CAPcyv4hqERm3YbgsE19M=8SRfrhyEo__LrLdcEj_YsLr2bLviA@mail.gmail.com>
 <6e17294f-4847-9e7a-2396-6fffaf8a8f4a@linux.intel.com>
In-Reply-To: <6e17294f-4847-9e7a-2396-6fffaf8a8f4a@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 07:56:20 -0700
Message-ID: <CAPcyv4jP_fx4Y3tmxqXC67nf9NFOEAU9cnesrydu8p3aC3R3=Q@mail.gmail.com>
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

On Fri, Sep 21, 2018 at 7:48 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
[..]
> > I was thinking everywhere we set dev->parent before registering, also
> > set the node...
>
> That will not work unless we move the call to device_initialize to
> somewhere before you are setting the node. That is why I was thinking it
> might work to put the node assignment in nd_device_register itself since
> it looks like the regions don't call __nd_device_register directly.
>
> I guess we could get rid of nd_device_register if we wanted to go that
> route.
>
> >> If you wanted what I could do is pull the set_dev_node call from
> >> nvdimm_bus_uevent and place it in nd_device_register. That should stick
> >> as the node doesn't get overwritten by the parent if it is set after
> >> device_initialize. If I did that along with the parent bit I was already
> >> doing then all that would be left to do in is just use the dev_to_node
> >> call on the device itself.
> >
> > ...but this is even better.
> >
>
> I'm not sure it adds that much. Basically My thought was we just need to
> make sure to set the device node after the call to device_initialize but
> before the call to device_add. This just seems like a bunch more work
> spread the device_initialize calls all over and introduce possible
> regressions.

Yeah, device_initialize() clobbering the numa_node makes it awkward.
Lets go with what you have presently and fix up the comment to say why
region devices are special.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
