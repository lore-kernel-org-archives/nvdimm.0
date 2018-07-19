Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A67D02098C8C9
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 08:18:52 -0700 (PDT)
Date: Thu, 19 Jul 2018 23:18:46 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v7 1/4] resource: Move reparent_resources() to
 kernel/resource.c and make it public
Message-ID: <20180719151846.GC7147@localhost.localdomain>
References: <20180718024944.577-1-bhe@redhat.com>
 <20180718024944.577-2-bhe@redhat.com>
 <CAHp75VdO88ydJQ9GHdaDUmAmzL6QHR=US6JiXZ1R_EEA-xWR1Q@mail.gmail.com>
 <CAHp75Vf2yEwHhEhhQH2XN+pOQ=-skiAHZ=FgLnfVV8vcm59qeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHp75Vf2yEwHhEhhQH2XN+pOQ=-skiAHZ=FgLnfVV8vcm59qeQ@mail.gmail.com>
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
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, brijesh.singh@amd.com, devicetree <devicetree@vger.kernel.org>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, Max Filippov <jcmvbkbc@gmail.com>, Paul Mackerras <paulus@samba.org>, baiyaowei@cmss.chinamobile.com, KY Srinivasan <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input <linux-input@vger.kernel.org>, Gustavo Padovan <gustavo@padovan.org>, Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Josh Triplett <josh@joshtriplett.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>, Jon Derrick <jonathan.derrick@intel.com>, Chris Zankel <chris@zankel.net>, Michal Simek <monstr@monstr.eu>, linux-parisc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Eric Biederman <ebiederm@xmission.com>, devel@linuxdriverproject.org, Andrew Morton <akpm@linux-foundation.org>, kbuild test robot <fengguang.wu@intel.com>, "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" <linuxppc-dev@lists.ozlabs.org>, "David S. Miller" <davem@davemloft.net>
List-ID: <linux-nvdimm@lists.01.org>

On 07/18/18 at 07:37pm, Andy Shevchenko wrote:
> On Wed, Jul 18, 2018 at 7:36 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Wed, Jul 18, 2018 at 5:49 AM, Baoquan He <bhe@redhat.com> wrote:
> >> reparent_resources() is duplicated in arch/microblaze/pci/pci-common.c
> >> and arch/powerpc/kernel/pci-common.c, so move it to kernel/resource.c
> >> so that it's shared.
> 
> >> + * Returns 0 on success, -ENOTSUPP if child resource is not completely
> >> + * contained by 'res', -ECANCELED if no any conflicting entry found.
> 
> You also can refer to constants by prefixing them with %, e.g. %-ENOTSUPP.
> But this is up to you completely.

Thanks, will fix when repost. 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
