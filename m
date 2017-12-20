Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E551221ED757
 for <linux-nvdimm@lists.01.org>; Wed, 20 Dec 2017 14:36:19 -0800 (PST)
Date: Wed, 20 Dec 2017 15:41:05 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Message-ID: <20171220224105.GA27258@linux.intel.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <2da89d31-27a3-34ab-2dbb-92403c8215ec@intel.com>
 <20171220211649.GA32200@bombadil.infradead.org>
 <20171220212408.GA8308@linux.intel.com>
 <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gTknp=0yQnVrrB5Ui+mJE_x-wdkV86UD4hsYnx3CAjfA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Matthew Wilcox <willy@infradead.org>, Linux ACPI" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, Kogut,, "Marcin  <marcin.koss@intel.com>, Linux API <linux-api@vger.kernel.org>, Brice Goglin" <brice.goglin@gmail.com>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 20, 2017 at 02:29:56PM -0800, Dan Williams wrote:
> On Wed, Dec 20, 2017 at 1:24 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > On Wed, Dec 20, 2017 at 01:16:49PM -0800, Matthew Wilcox wrote:
> >> On Wed, Dec 20, 2017 at 12:22:21PM -0800, Dave Hansen wrote:
> >> > On 12/20/2017 10:19 AM, Matthew Wilcox wrote:
> >> > > I don't know what the right interface is, but my laptop has a set of
> >> > > /sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
> >> > > right place to expose write_bw (etc).
> >> >
> >> > Those directories are already too redundant and wasteful.  I think we'd
> >> > really rather not add to them.  In addition, it's technically possible
> >> > to have a memory section span NUMA nodes and have different performance
> >> > properties, which make it impossible to represent there.
> >> >
> >> > In any case, ACPI PXM's (Proximity Domains) are guaranteed to have
> >> > uniform performance properties in the HMAT, and we just so happen to
> >> > always create one NUMA node per PXM.  So, NUMA nodes really are a good fit.
> >>
> >> I think you're missing my larger point which is that I don't think this
> >> should be exposed to userspace as an ACPI feature.  Because if you do,
> >> then it'll also be exposed to userspace as an openfirmware feature.
> >> And sooner or later a devicetree feature.  And then writing a portable
> >> program becomes an exercise in suffering.
> >>
> >> So, what's the right place in sysfs that isn't tied to ACPI?  A new
> >> directory or set of directories under /sys/devices/system/memory/ ?
> >
> > Oh, the current location isn't at all tied to acpi except that it happens to
> > be named 'hmat'.  When it was all named 'hmem' it was just:
> >
> > /sys/devices/system/hmem
> >
> > Which has no ACPI-isms at all.  I'm happy to move it under
> > /sys/devices/system/memory/hmat if that's helpful, but I think we still have
> > the issue that the data represented therein is still pulled right from the
> > HMAT, and I don't know how to abstract it into something more platform
> > agnostic until I know what data is provided by those other platforms.
> >
> > For example, the HMAT provides latency information and bandwidth information
> > for both reads and writes.  Will the devicetree/openfirmware/etc version have
> > this same info, or will it be just different enough that it won't translate
> > into whatever I choose to stick in sysfs?
> 
> For the initial implementation do we need to have a representation of
> all the performance data? Given that
> /sys/devices/system/node/nodeX/distance is the only generic
> performance attribute published by the kernel today it is already the
> case that applications that need to target specific memories need to
> go parse information that is not provided by the kernel by default.
> The question is can those specialized applications stay special and go
> parse the platform specific data sources, like raw HMAT, directly, or
> do we expect general purpose applications to make use of this data? I
> think a firmware-id to numa-node translation facility
> (/sys/devices/system/node/nodeX/fwid) is a simple start that we can
> build on with more information as specific use cases arise.

We don't represent all the performance data, we only represent the data for
local initiator/target pairs.  I do think that this is useful to have in sysfs
because it provides a way to easily answer the most commonly asked questions
(or at least what I'm guessing will be the most commmonly asked queststions),
i.e. "given a CPU, what are the speeds of the various types of memory attached
to it", and "given a chunk of memory, how fast is it and to which CPU is it
local"?  By providing this base level of information I'm hoping to prevent
most applications from having to parse the HMAT directly.

The question of whether or not to include this local performance information
was one of the main questions of the initial RFC patch series, and I did get
feedback (albiet off-list) that the local performance information was
valuable to at least some users.  I did intentionally structure my (now very
short) set so that the performance information was added as a separate patch,
so we can get to the place you're talking about where we only provide firmware
id <=> proximity domain mappings by just leaving off the last patch in the
series.

I'm personally still of the opinion though that this last patch does add
value.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
