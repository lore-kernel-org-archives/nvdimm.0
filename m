Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Fri, 29 Dec 2017 22:58:45 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Message-ID: <20171230065845.GD27959@bombadil.infradead.org>
References: <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
 <20171220224105.GA27258@linux.intel.com>
 <39cbe02a-d309-443d-54c9-678a0799342d@gmail.com>
 <CAPcyv4j9shdJFrvADa=qW4L-jPJJ4S_TJc_c=aRoW3EmSCCChQ@mail.gmail.com>
 <71317994-af66-a1b2-4c7a-86a03253cf62@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <71317994-af66-a1b2-4c7a-86a03253cf62@gmail.com>
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
To: Brice Goglin <brice.goglin@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Schmauss, Erik  <erik.schmauss@intel.com>, Len Brown <lenb@kernel.org>, John Hubbard" <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 27, 2017 at 10:10:34AM +0100, Brice Goglin wrote:
> > Perhaps we can enlist /proc/iomem or a similar enumeration interface
> > to tell userspace the NUMA node and whether the kernel thinks it has
> > better or worse performance characteristics relative to base
> > system-RAM, i.e. new IORES_DESC_* values. I'm worried that if we start
> > publishing absolute numbers in sysfs userspace will default to looking
> > for specific magic numbers in sysfs vs asking the kernel for memory
> > that has performance characteristics relative to base "System RAM". In
> > other words the absolute performance information that the HMAT
> > publishes is useful to the kernel, but it's not clear that userspace
> > needs that vs a relative indicator for making NUMA node preference
> > decisions.
> 
> Some HPC users will benchmark the machine to discovery actual
> performance numbers anyway.
> However, most users won't do this. They will want to know relative
> performance of different nodes. If you normalize HMAT values by dividing
> them with system-RAM values, that's likely OK. If you just say "that
> node is faster than system RAM", it's not precise enough.

So "this memory has 800% bandwidth of normal" and "this memory has 70%
bandwidth of normal"?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
