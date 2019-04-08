Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com
 [IPv6:2607:f8b0:4864:20::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3663C211F99D8
 for <linux-nvdimm@lists.01.org>; Sun,  7 Apr 2019 21:26:57 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id a6so9410221oie.5
 for <linux-nvdimm@lists.01.org>; Sun, 07 Apr 2019 21:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <62b31d43-d12c-ae99-b915-2049e7179e7e@inria.fr>
In-Reply-To: <62b31d43-d12c-ae99-b915-2049e7179e7e@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 7 Apr 2019 21:26:43 -0700
Message-ID: <CAPcyv4h=m_zQg_C2kZyMTo1H2CP0qnuQ7e=0NE4rPWkvWMCHLA@mail.gmail.com>
Subject: Re: DAX numa_attribute vs SubNUMA clusters
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 4, 2019 at 12:48 PM Brice Goglin <Brice.Goglin@inria.fr> wrote:
>
> Hello
>
> I am trying to understand the locality of the DAX devices with
> respect to processors with SubNUMA clustering enabled. The machine
> I am using has 6invalidate_mapping_pages proximity domains: #0-3 are the SNCs of both
> processors, #4-5 are prox domains for each socket set of NVDIMMs.
>
> SLIT says the topology looks like this, which seems OK to me:
>
>   Package 0 ---------- Package 1
>   NVregion0            NVregion1
>    |     |              |     |
> SNC 0   SNC 1        SNC 2   SNC 3
> node0   node1        node2   node3
>
> However each DAX "numa_node" attribute contains a single node ID,
> which leads to this topology instead:
>
>   Package 0 ---------- Package 1
>    |     |              |     |
> SNC 0   SNC 1        SNC 2   SNC 3
> node0   node1        node2   node3
>    |                   |
> dax0.0               dax1.0
>
> It looks like this is caused by acpi_map_pxm_to_online_node()
> only returning the first closest node found in the SLIT.
> However, even if we change it to return multiple local nodes,
> the DAX "numa_node" attribute cannot expose multiple nodes.
> Should we rather expose Keith HMAT attributes for DAX devices?

If I understand the suggestion correctly you're referring to the
"target_node" or the unique node number that gets assigned when the
memory is transitioned online. I struggle to see the incremental
benefit relative to what we lose with compatibility of the
"traditional" numa node interpretation for a device that indicates
which cpus are close to the given device. I think the bulk of the
problem is solved with the next suggestion below.

> Maybe there's even a way to share them between DAX devices
> and Dave's KMEM hotplugged NUMA nodes?

In this instance, where the expectation is that the NVDIMM range is
equidistant from both SNC nodes on a package, I would teach numactl
tool and other tooling to return a list of local nodes rather than the
single attribute. Effectively an operation like "numactl --preferred
block:pmem0" would return a node-mask that includes nodes 0 and 1.

> By the way, I am not sure if my above configuration is what
> we should expect on SNC-enabled production machines.
> Is the NFIT table supposed to expose one SPA Range per SNC,
> or one per socket? Should it depend with the SNC config in
> the BIOS?

The NFIT is "supposed" to expose the interleave boundaries, and in
this case it seems to be saying that System RAM is interleaved
differently than the PMEM. Whether that is correct or not is for the
platform BIOS developer to validate. The OS is only equipped to trust
the SLIT.

> If we had one SPA range per SNC, would it still be possible
> to interleave NVDIMMs of both SNC to create a single region
> for each socket?

I don't follow the question, if the SPA range is split you want the
SLIT to lie and say it isn't?

> If I don't interleave NVDIMMs, I get the same result even if
> some regions should be only local to node1 (or node3). Maybe
> because they are still in the same SPA range, and thus still
> get the entire range locality?

...or the SLIT is incorrect for that config.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
