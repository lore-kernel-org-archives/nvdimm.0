Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C8C6211BA455
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 17:28:52 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id w25so7646270otm.13
 for <linux-nvdimm@lists.01.org>; Fri, 01 Feb 2019 17:28:52 -0800 (PST)
MIME-Version: 1.0
References: <PU1P153MB01690EDA138D3ABDE5B4A482BF970@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4jD1oRWzA4ZiMYZm1uxsbOdgqzbb9raH70-HBDqapcE_g@mail.gmail.com>
 <PU1P153MB0169977604493B82B662A01CBF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4haUouYs_Vfju2SMvjcwc7rqY06zqT8NJ-3uakGMZSu0w@mail.gmail.com>
 <PU1P153MB01694FCAF062E089059CD441BF920@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <CAPcyv4gdWJ8qtiASU9ggz56Mkrm9OXfsO74RM9OOrXFmBw_A9Q@mail.gmail.com>
 <PU1P153MB0169D8F7C6E29C22FE122F3FBF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <PU1P153MB0169D661955195EA070E7EF0BF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169D661955195EA070E7EF0BF930@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Feb 2019 17:28:39 -0800
Message-ID: <CAPcyv4iEcCG0h+HLPkfSC0aNDLq9hdoO00XErF93PHTmEgO-TQ@mail.gmail.com>
Subject: Re: [PATCH v2] nfit: add Hyper-V NVDIMM DSM command set to white list
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
To: Dexuan Cui <decui@microsoft.com>
Cc: Josh Poulson <jopoulso@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Haiyang Zhang <haiyangz@microsoft.com>, "driverdev-devel@linuxdriverproject.org" <driverdev-devel@linuxdriverproject.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Michael Kelley <mikelley@microsoft.com>, Sasha Levin <Alexander.Levin@microsoft.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, KY Srinivasan <kys@microsoft.com>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 1, 2019 at 5:06 PM Dexuan Cui <decui@microsoft.com> wrote:
>
> > From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> > Dexuan Cui
> > Sent: Friday, February 1, 2019 4:34 PM
> > > > > ...
> > > > > Those reads find a namespace index block
> > > > > and a label. Unfortunately the label has the LOCAL flag set and Linux
> > > > > explicitly ignores pmem namespace labels with that bit set. The reason
> > > > > for that is due to the fact that the original definition of the LOCAL
> > > > > bit from v1.1 of the namespace label implementation [1] explicitly
> > > > > limited the LOCAL flag to "block aperture" regions. If you clear that
> > > > > LOCAL flag I expect it will work. To my knowledge Windows pretends
> > > > > that the v1.1 definition never existed.
>
> On the libnvdimm-pending branch, I get this:
>
> root@decui-gen2-u1904:~/nvdimm# ndctl list
> root@decui-gen2-u1904:~/nvdimm# ndctl list --idle
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":0,
>     "uuid":"00000000-0000-0000-0000-000000000000",
>     "state":"disabled"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"raw",
>     "size":0,
>     "uuid":"00000000-0000-0000-0000-000000000000",
>     "state":"disabled"
>   }
> ]
>
> With the patch that clears the LOCAL label (BTW, the initial value of flags is 0x3,
> meaning a read-only local label) :
> @@ -2496,6 +2500,7 @@ static int init_active_labels(struct nd_region *nd_region)
>                         if (!label_ent)
>                                 break;
>                         label = nd_label_active(ndd, j);
> +                       label->flags &= ~NSLABEL_FLAG_LOCAL;
>                         label_ent->label = label;
>
> I get this:
>
> root@decui-gen2-u1904:~/nvdimm# ndctl list
> root@decui-gen2-u1904:~/nvdimm# ndctl list --idle
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":0,
>     "uuid":"c258aaab-f72b-e546-bfa5-be5e07761dbc",
>     "state":"disabled",
>     "name":"Microsoft Hyper-V NVDIMM 1 Label"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"raw",
>     "size":0,
>     "uuid":"9f0497a7-4453-7c40-ad35-21a791e00345",
>     "state":"disabled",
>     "name":"Microsoft Hyper-V NVDIMM 0 Label"
>   }
> ]
>
> The "size" and "mode" still don't look right, but the improvement is that
> now I can see a good descriptive "name", which I suppose is retrieved
> from Hyper-V.

Mode is right, there is no way for Hyper-V to create Linux fsdax mode
namespaces it requires some setup using variables only Linux knows.
Can you send the output of:

ndctl read-labels -j all

>
> With Ubuntu 19.04 (4.18.0-11-generic), I get this:
> (Note: the "mode" and "size" are correct. The "uuid" is different from
> the above "9f0497a7-4453-7c40-ad35-21a791e00345" -- this is weird.)
>
> root@decui-gen2-u1904:~# ndctl list
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":137438953472,
>     "blockdev":"pmem1"
>   },
>   {
>     "dev":"namespace0.0",
>     "mode":"fsdax",
>     "map":"dev",
>     "size":33820770304,
>     "uuid":"35018886-397e-4fe7-a348-0a4d16eec44d",
>     "blockdev":"pmem0"
>   }
> ]

This is because the Ubuntu kernel has the bug that causes _LSR to fail
so Linux falls back to a namespace defined by the region boundary. On
that namespace there is an "fsdax" info block located at the region
base +4K. That info block is tagged with the uuid of
"35018886-397e-4fe7-a348-0a4d16eec44d".

> I'm trying to find out the correct solution. I apprecite your insights!

It's a mess. First we need to figure out whether the label is actually
specifying a size of zero, or there is some other bug.

However, the next problem is going to be adding "fsdax" mode support
on top of the read-only defined namespaces. The ndctl reconfiguration
flow:

   ndctl create-namespace -e namespace0.0 -m fsdax -f

...will likely fail because deleting the previous namespace in the
labels is part of that flow. It's always that labels are writable.

Honestly, the quickest path to something functional for Linux is to
simply delete the _LSR support and use raw mode defined namespaces.
Why have labels if they are read-only and the region is sufficient for
defining boundaries?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
