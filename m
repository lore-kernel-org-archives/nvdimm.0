Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 20 Dec 2017 13:16:49 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Message-ID: <20171220211649.GA32200@bombadil.infradead.org>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, linux-mm@kvack.org, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, Moore,Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev@lists.ozlabs.org, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, "Koss, Marcin  <marcin.koss@intel.com>, linux-api@vger.kernel.org, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 20, 2017 at 12:22:21PM -0800, Dave Hansen wrote:
> On 12/20/2017 10:19 AM, Matthew Wilcox wrote:
> > I don't know what the right interface is, but my laptop has a set of
> > /sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
> > right place to expose write_bw (etc).
> 
> Those directories are already too redundant and wasteful.  I think we'd
> really rather not add to them.  In addition, it's technically possible
> to have a memory section span NUMA nodes and have different performance
> properties, which make it impossible to represent there.
> 
> In any case, ACPI PXM's (Proximity Domains) are guaranteed to have
> uniform performance properties in the HMAT, and we just so happen to
> always create one NUMA node per PXM.  So, NUMA nodes really are a good fit.

I think you're missing my larger point which is that I don't think this
should be exposed to userspace as an ACPI feature.  Because if you do,
then it'll also be exposed to userspace as an openfirmware feature.
And sooner or later a devicetree feature.  And then writing a portable
program becomes an exercise in suffering.

So, what's the right place in sysfs that isn't tied to ACPI?  A new
directory or set of directories under /sys/devices/system/memory/ ?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
