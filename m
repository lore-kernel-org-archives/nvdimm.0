Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA2F7211648BC
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 12:05:01 -0700 (PDT)
Date: Wed, 6 Jun 2018 22:04:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [qemu PATCH v4 3/4] nvdimm, acpi: support NFIT platform
 capabilities
Message-ID: <20180606220431-mutt-send-email-mst@kernel.org>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180521163203.26590-4-ross.zwisler@linux.intel.com>
 <20180605182243-mutt-send-email-mst@kernel.org>
 <20180605164205.GA21034@linux.intel.com>
 <CAPcyv4jSoFifTc05WGgxkEX6i7b12zYyB+VchJVW_+QPQzO7Fg@mail.gmail.com>
 <20180605213547-mutt-send-email-mst@kernel.org>
 <20180605220700.GB16066@linux.intel.com>
 <CAPcyv4irudGth3+WZtgF4TjGL53s8mN70aVXpGWjj_Lc=7AMVg@mail.gmail.com>
 <20180606165051.GC30568@linux.intel.com>
 <20180606170033.GA29035@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180606170033.GA29035@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 06, 2018 at 11:00:33AM -0600, Ross Zwisler wrote:
> On Wed, Jun 06, 2018 at 10:50:51AM -0600, Ross Zwisler wrote:
> > On Tue, Jun 05, 2018 at 03:21:30PM -0700, Dan Williams wrote:
> > > On Tue, Jun 5, 2018 at 3:07 PM, Ross Zwisler
> > > <ross.zwisler@linux.intel.com> wrote:
> > > > On Tue, Jun 05, 2018 at 09:37:25PM +0300, Michael S. Tsirkin wrote:
> > > >> On Tue, Jun 05, 2018 at 11:15:00AM -0700, Dan Williams wrote:
> > > >> > On Tue, Jun 5, 2018 at 9:42 AM, Ross Zwisler
> > > >> > <ross.zwisler@linux.intel.com> wrote:
> > > >> > > On Tue, Jun 05, 2018 at 06:25:27PM +0300, Michael S. Tsirkin wrote:
> > > >> > >> On Mon, May 21, 2018 at 10:32:02AM -0600, Ross Zwisler wrote:
> > > >> > >> > Add a machine command line option to allow the user to control the Platform
> > > >> > >> > Capabilities Structure in the virtualized NFIT.  This Platform Capabilities
> > > >> > >> > Structure was added in ACPI 6.2 Errata A.
> > > >> > >> >
> > > >> > >> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > >> > >>
> > > >> > >> I tried playing with it and encoding the capabilities is
> > > >> > >> quite awkward.
> > > >> > >>
> > > >> > >> Can we add bits for specific capabilities instead of nvdimm-cap?
> > > >> > >>
> > > >> > >> How about:
> > > >> > >>
> > > >> > >> "cpu-flush-on-power-loss-cap"
> > > >> > >> "memory-flush-on-power-loss-cap"
> > > >> > >> "byte-addressable-mirroring-cap"
> > > >> > >
> > > >> > > Hmmm...I don't like that as much because:
> > > >> > >
> > > >> > > a) It's very verbose.  Looking at my current qemu command line few other
> > > >> > >    options require that many characters, and you'd commonly be defining more
> > > >> > >    than one of these for a given VM.
> > > >> > >
> > > >> > > b) It means that the QEMU will need to be updated if/when new flags are added,
> > > >> > >    because we'll have to have new options for each flag.  The current
> > > >> > >    implementation is more future-proof because you can specify any flags
> > > >> > >    value you want.
> > > >> > >
> > > >> > > However, if you feel strongly about this, I'll make the change.
> > > >> >
> > > >> > Straw-man: Could we do something similar with what we are doing in ndctl?
> > > >> >
> > > >> > enum ndctl_persistence_domain {
> > > >> >         PERSISTENCE_NONE = 0,
> > > >> >         PERSISTENCE_MEM_CTRL = 10,
> > > >> >         PERSISTENCE_CPU_CACHE = 20,
> > > >> >         PERSISTENCE_UNKNOWN = INT_MAX,
> > > >> > };
> > > >> >
> > > >> > ...and have the command line take a number where "10" and "20" are
> > > >> > supported today, but allows us to adapt to new persistence domains in
> > > >> > the future.
> > > >>
> > > >> I'm fine with that except can we have symbolic names instead of numbers
> > > >> on command line?
> > > >>
> > > >> --
> > > >> MST
> > > >
> > > > Okay, we can move to the symbolic names.  Do you want them to be that long, or
> > > > would:
> > > >
> > > > nvdimm-cap-cpu
> > > > nvdimm-cap-mem-ctrl
> > > > nvdimm-cap-mirroring
> > > 
> > > Wait, why is mirroring part of this?
> > > 
> > > I was thinking this option would be:
> > > 
> > >     --persistence-domain={cpu,mem-ctrl}
> > > 
> > > ...and try not to let ACPI specifics leak into the qemu command line
> > > interface. For example PowerPC qemu could have a persistence domain
> > > communicated via Open Firmware or some other mechanism.
> > 
> > Sure, this seems fine, though we may want to throw an "nvdimm" in the name
> > somewhere so it's clear what the option affects.
> > 
> > nvdimm-persistence={cpu,mem-ctrl} maybe?
> > 
> > Michael, does this work for you?
> 
> Hmm...also, the version of these patches that used numeric values did go
> upstream in QEMU.  So, do we need to leave that interface intact, and just add
> a new one that uses symbolic names?  Or did you still just want to replace the
> numeric one since it hasn't appeared in a QEMU release yet?

The later. No release => no stable APIs.

-- 
MST
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
