Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C73A21A09130
 for <linux-nvdimm@lists.01.org>; Thu,  4 Apr 2019 20:30:13 -0700 (PDT)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: DAX numa_attribute vs SubNUMA clusters
Date: Fri, 5 Apr 2019 03:29:01 +0000
Message-ID: <AT5PR8401MB116985B9059D9312A4A1F7AAAB510@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <62b31d43-d12c-ae99-b915-2049e7179e7e@inria.fr>
In-Reply-To: <62b31d43-d12c-ae99-b915-2049e7179e7e@inria.fr>
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
To: Brice Goglin <Brice.Goglin@inria.fr>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Brice Goglin
> Sent: Thursday, April 04, 2019 2:48 PM
> To: linux-nvdimm@lists.01.org
> Subject: DAX numa_attribute vs SubNUMA clusters
> 
> Hello
> 
> I am trying to understand the locality of the DAX devices with
> respect to processors with SubNUMA clustering enabled. The machine
> I am using has 6invalidate_mapping_pages proximity domains: #0-3 are
> the SNCs of both
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
> Maybe there's even a way to share them between DAX devices
> and Dave's KMEM hotplugged NUMA nodes?
> 
> By the way, I am not sure if my above configuration is what
> we should expect on SNC-enabled production machines.
> Is the NFIT table supposed to expose one SPA Range per SNC,
> or one per socket? Should it depend with the SNC config in
> the BIOS?
> 
> If we had one SPA range per SNC, would it still be possible
> to interleave NVDIMMs of both SNC to create a single region
> for each socket?

There is one SPA range for each interleave set. All of these 
are possible (but maybe not supported in a particular system):
* interleave across channels within the SNC
* interleave across SNCs within the package
* interleave across packages

The latter is sometimes called "node interleaving"; with SNC,
there is another level of nodes inside the package, and interleaving
across those could also be called "node interleaving."

In that case, the memory is not really part of one node; it's
equidistant from both nodes.  So, it would most accurately
be described as a separate node with a "distance" of half that
between the nodes. However, the kernel has struggled in the past
handling CPU nodes (especially CPU 0) with no local memory, so
rounding down to node0 and node2 isn't surprising.


> If I don't interleave NVDIMMs, I get the same result even if
> some regions should be only local to node1 (or node3). Maybe
> because they are still in the same SPA range, and thus still
> get the entire range locality?

That sounds like a bug.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
