Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7A8A209605AD
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jul 2018 07:55:13 -0700 (PDT)
Date: Tue, 3 Jul 2018 22:55:03 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v5 1/4] resource: Move reparent_resources() to
 kernel/resource.c and make it public
Message-ID: <20180703145503.GA1225@MiWiFi-R3L-srv>
References: <20180612032831.29747-1-bhe@redhat.com>
 <20180612032831.29747-2-bhe@redhat.com>
 <CAHp75Vd6v4+RTq-5uw_BJpT6=w2KGjTfU+rEst6+8igs2cyntw@mail.gmail.com>
 <20180612093812.GC1820@MiWiFi-R3L-srv>
 <CAHp75Vf_kBLkE6v=JyOdfNoWktWEfKs7JzRP1XEc4TeuT5xqfw@mail.gmail.com>
 <CAHp75Vdaqj+n=F7wSB9PFGpf9Ok2XZzKcq_H0DzmtjmN-4UUfw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHp75Vdaqj+n=F7wSB9PFGpf9Ok2XZzKcq_H0DzmtjmN-4UUfw@mail.gmail.com>
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
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, brijesh.singh@amd.com, devicetree <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, baiyaowei@cmss.chinamobile.com, KY Srinivasan <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input <linux-input@vger.kernel.org>, Gustavo Padovan <gustavo@padovan.org>, Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Josh Triplett <josh@joshtriplett.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>, Jon Derrick <jonathan.derrick@intel.com>, Chris Zankel <chris@zankel.net>, Michal Simek <monstr@monstr.eu>, linux-parisc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, kexec@lists.infradead.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Eric Biederman <ebiederm@xmission.com>, devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>, kbuild test robot <fengguang.wu@intel.com>, "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

Hi Andy,

On 06/12/18 at 05:24pm, Andy Shevchenko wrote:
> On Tue, Jun 12, 2018 at 5:20 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >> Hmm, I just copied it from arch/powerpc/kernel/pci-common.c. The
> >> function interface expects an integer returned value, not sure what a
> >> real error codes look like, could you give more hints? Will change
> >> accordingly.
> >
> > I briefly looked at the code and error codes we have, so, my proposal
> > is one of the following
> 
> >  - use -ECANCELED (not the best choice for first occurrence here,
> > though I can't find better)
> 
> Actually -ENOTSUPP might suit the first case (although the actual
> would be something like -EOVERLAP, which we don't have)

Sorry for late reply, and many thanks for your great suggestion.

I am fine to use -ENOTSUPP as the first returned value, and -ECANCELED
for the 2nd one. Or define an enum as you suggested inside the function
or in header file.

Or use -EBUSY for the first case because existing resource is
overlapping but not fully contained by 'res'; and -EINVAL for
the 2nd case since didn't find any one resources which is contained by
'res', means we passed in a invalid resource. 

All is fine to me, I can repost with each of them.

Thanks
Baoquan

> 
> >  - use positive integers (or enum), like
> >   #define RES_REPARENTED 0
> >   #define RES_OVERLAPPED 1
> >   #define RES_NOCONFLICT 2
> >
> >
> >>> > +               if (firstpp == NULL)
> >>> > +                       firstpp = pp;
> >>> > +       }
> >>>
> >>> > +       if (firstpp == NULL)
> >>> > +               return -1;      /* didn't find any conflicting entries? */
> >>>
> >>> Ditto.
> >
> > Ditto.
> >
> >>>
> >>> > +}
> >>> > +EXPORT_SYMBOL(reparent_resources);
> >
> > --
> > With Best Regards,
> > Andy Shevchenko
> 
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
