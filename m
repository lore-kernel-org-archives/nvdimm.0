Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEE2E222CB327
 for <linux-nvdimm@lists.01.org>; Fri, 22 Dec 2017 02:26:20 -0800 (PST)
From: "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>
Subject: RE: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Fri, 22 Dec 2017 10:31:05 +0000
Message-ID: <34EF90DF7C7F0647A403B771519912C7F5382CF3@irsmsx111.ger.corp.intel.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <2d6420f7-0a95-adfe-7390-a2aea4385ab2@linux.vnet.ibm.com>
In-Reply-To: <2d6420f7-0a95-adfe-7390-a2aea4385ab2@linux.vnet.ibm.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Box, David E" <david.e.box@intel.com>, Hansen,, "Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Wysocki,, Lukasz, "Robert  <robert.moore@intel.com>, linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, "devel@acpica.org" <devel@acpica.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Koss, Marcin  <marcin.koss@intel.com>, Brice Goglin <brice.goglin@gmail.com>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Koziej, , "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton" <akpm@linux-foundation.org>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> ... first thinking about redesigning the NUMA for
> heterogeneous memory may not be a good idea. Will look into this further.

I agree with comment that first a direction should be defined how to handle heterogeneous memory system.

> https://linuxplumbersconf.org/2017/ocw//system/presentations/4656/original/
> Hierarchical_NUMA_Design_Plumbers_2017.pdf

I miss in the presentation a user perspective of the new approach, e.g.
- How does application developer see/understand the heterogeneous memory system?
- How does app developer use the heterogeneous memory system? 
- What are modification in API/sys interfaces?

In other hand, if we assume that separate memory NUMA node has different memory capabilities/attributes from stand point of particular CPU, it is easy to explain for user how to describe/handle heterogeneous memory. 

Of course, current numa design is not sufficient in kernel in following areas today:
- Exposing memory attributes that describe heterogeneous memory system
- Interfaces to use the heterogeneous memory system, e.g. more sophisticated policies
- Internal mechanism in memory management, e.g. automigration, maybe something else.

> -----Original Message-----
> From: Anshuman Khandual [mailto:khandual@linux.vnet.ibm.com]
> Sent: Friday, December 22, 2017 4:10 AM
> To: Ross Zwisler <ross.zwisler@linux.intel.com>; linux-kernel@vger.kernel.org
> Cc: Anaczkowski, Lukasz <lukasz.anaczkowski@intel.com>; Box, David E
> <david.e.box@intel.com>; Kogut, Jaroslaw <Jaroslaw.Kogut@intel.com>; Koss,
> Marcin <marcin.koss@intel.com>; Koziej, Artur <artur.koziej@intel.com>;
> Lahtinen, Joonas <joonas.lahtinen@intel.com>; Moore, Robert
> <robert.moore@intel.com>; Nachimuthu, Murugasamy
> <murugasamy.nachimuthu@intel.com>; Odzioba, Lukasz
> <lukasz.odzioba@intel.com>; Wysocki, Rafael J <rafael.j.wysocki@intel.com>;
> Rafael J. Wysocki <rjw@rjwysocki.net>; Schmauss, Erik
> <erik.schmauss@intel.com>; Verma, Vishal L <vishal.l.verma@intel.com>;
> Zheng, Lv <lv.zheng@intel.com>; Andrew Morton <akpm@linux-
> foundation.org>; Balbir Singh <bsingharora@gmail.com>; Brice Goglin
> <brice.goglin@gmail.com>; Williams, Dan J <dan.j.williams@intel.com>;
> Hansen, Dave <dave.hansen@intel.com>; Jerome Glisse <jglisse@redhat.com>;
> John Hubbard <jhubbard@nvidia.com>; Len Brown <lenb@kernel.org>; Tim
> Chen <tim.c.chen@linux.intel.com>; devel@acpica.org; linux-
> acpi@vger.kernel.org; linux-mm@kvack.org; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
> 
> On 12/14/2017 07:40 AM, Ross Zwisler wrote:
> > ==== Quick Summary ====
> >
> > Platforms exist today which have multiple types of memory attached to
> > a single CPU.  These disparate memory ranges have some characteristics
> > in common, such as CPU cache coherence, but they can have wide ranges
> > of performance both in terms of latency and bandwidth.
> 
> Right.
> 
> >
> > For example, consider a system that contains persistent memory,
> > standard DDR memory and High Bandwidth Memory (HBM), all attached to
> the same CPU.
> > There could potentially be an order of magnitude or more difference in
> > performance between the slowest and fastest memory attached to that CPU.
> 
> Right.
> 
> >
> > With the current Linux code NUMA nodes are CPU-centric, so all the
> > memory attached to a given CPU will be lumped into the same NUMA node.
> > This makes it very difficult for userspace applications to understand
> > the performance of different memory ranges on a given CPU.
> 
> Right but that might require fundamental changes to the NUMA
> representation.
> Plugging those memory as separate NUMA nodes, identify them through sysfs
> and try allocating from it through mbind() seems like a short term solution.
> 
> Though if we decide to go in this direction, sysfs interface or something similar
> is required to enumerate memory properties.
> 
> >
> > We solve this issue by providing userspace with performance
> > information on individual memory ranges.  This performance information
> > is exposed via
> > sysfs:
> >
> >   # grep . mem_tgt2/* mem_tgt2/local_init/* 2>/dev/null
> >   mem_tgt2/firmware_id:1
> >   mem_tgt2/is_cached:0
> >   mem_tgt2/local_init/read_bw_MBps:40960
> >   mem_tgt2/local_init/read_lat_nsec:50
> >   mem_tgt2/local_init/write_bw_MBps:40960
> >   mem_tgt2/local_init/write_lat_nsec:50
> 
> I might have missed discussions from earlier versions, why we have this kind of
> a "source --> target" model ? We will enlist properties for all possible "source --
> > target" on the system ? Right now it shows only bandwidth and latency
> properties, can it accommodate other properties as well in future ?
> 
> >
> > This allows applications to easily find the memory that they want to use.
> > We expect that the existing NUMA APIs will be enhanced to use this new
> > information so that applications can continue to use them to select
> > their desired memory.
> 
> I had presented a proposal for NUMA redesign in the Plumbers Conference this
> year where various memory devices with different kind of memory attributes
> can be represented in the kernel and be used explicitly from the user space.
> Here is the link to the proposal if you feel interested. The proposal is very
> intrusive and also I dont have a RFC for it yet for discussion here.
> 
> https://linuxplumbersconf.org/2017/ocw//system/presentations/4656/original/
> Hierarchical_NUMA_Design_Plumbers_2017.pdf
> 
> Problem is, designing the sysfs interface for memory attribute detection from
> user space without first thinking about redesigning the NUMA for
> heterogeneous memory may not be a good idea. Will look into this further.

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
