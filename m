Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD570222F4E3E
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 15:17:42 -0800 (PST)
Date: Fri, 22 Dec 2017 16:22:31 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Message-ID: <20171222232231.GA26715@linux.intel.com>
References: <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Matthew Wilcox <willy@infradead.org>, Linux ACPI" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 22, 2017 at 02:53:42PM -0800, Dan Williams wrote:
> On Thu, Dec 21, 2017 at 12:31 PM, Brice Goglin <brice.goglin@gmail.com> w=
rote:
> > Le 20/12/2017 =E0 23:41, Ross Zwisler a =E9crit :
> [..]
> > Hello
> >
> > I can confirm that HPC runtimes are going to use these patches (at least
> > all runtimes that use hwloc for topology discovery, but that's the vast
> > majority of HPC anyway).
> >
> > We really didn't like KNL exposing a hacky SLIT table [1]. We had to
> > explicitly detect that specific crazy table to find out which NUMA nodes
> > were local to which cores, and to find out which NUMA nodes were
> > HBM/MCDRAM or DDR. And then we had to hide the SLIT values to the
> > application because the reported latencies didn't match reality. Quite
> > annoying.
> >
> > With Ross' patches, we can easily get what we need:
> > * which NUMA nodes are local to which CPUs? /sys/devices/system/node/
> > can only report a single local node per CPU (doesn't work for KNL and
> > upcoming architectures with HBM+DDR+...)
> > * which NUMA nodes are slow/fast (for both bandwidth and latency)
> > And we can still look at SLIT under /sys/devices/system/node if really
> > needed.
> >
> > And of course having this in sysfs is much better than parsing ACPI
> > tables that are only accessible to root :)
> =

> On this point, it's not clear to me that we should allow these sysfs
> entries to be world readable. Given /proc/iomem now hides physical
> address information from non-root we at least need to be careful not
> to undo that with new sysfs HMAT attributes.

This enabling does not expose any physical addresses to userspace.  It only
provides performance numbers from the HMAT and associates them with existing
NUMA nodes.  Are you worried that exposing performance numbers to non-root
users via sysfs poses a security risk?

> Once you need to be root for this info, is parsing binary HMAT vs sysfs a
> blocker for the HPC use case?
> =

> Perhaps we can enlist /proc/iomem or a similar enumeration interface
> to tell userspace the NUMA node and whether the kernel thinks it has
> better or worse performance characteristics relative to base
> system-RAM, i.e. new IORES_DESC_* values. I'm worried that if we start
> publishing absolute numbers in sysfs userspace will default to looking
> for specific magic numbers in sysfs vs asking the kernel for memory
> that has performance characteristics relative to base "System RAM". In
> other words the absolute performance information that the HMAT
> publishes is useful to the kernel, but it's not clear that userspace
> needs that vs a relative indicator for making NUMA node preference
> decisions.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
