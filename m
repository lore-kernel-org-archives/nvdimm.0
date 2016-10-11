From: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Date: Tue, 11 Oct 2016 14:45:34 -0400
Message-ID: <20161011184533.GC23193@localhost.localdomain>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
 <20161011055258.2v67idzs5kjtfs4q@hz-desktop>
 <de62aa59-37e0-b01f-1617-6fc8f6fb3620@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <de62aa59-37e0-b01f-1617-6fc8f6fb3620-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefano Stabellini <stefano-yd54mjeZNzVBDgjK7y7TUQ@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, Oct 11, 2016 at 07:37:09PM +0100, Andrew Cooper wrote:
> On 11/10/16 06:52, Haozhong Zhang wrote:
> > On 10/10/16 17:43, Andrew Cooper wrote:
> >> On 10/10/16 01:35, Haozhong Zhang wrote:
> >>> Overview
> >>> ========
> >>> This RFC kernel patch series along with corresponding patch series of
> >>> Xen, QEMU and ndctl implements Xen vNVDIMM, which can map the host
> >>> NVDIMM devices to Xen HVM domU as vNVDIMM devices.
> >>>
> >>> Xen hypervisor does not include an NVDIMM driver, so it needs the
> >>> assistance from the driver in Dom0 Linux kernel to manage NVDIMM
> >>> devices. We currently only supports NVDIMM devices in pmem mode.
> >>>
> >>> Design and Implementation
> >>> =========================
> >>> The complete design can be found at
> >>>   https://lists.xenproject.org/archives/html/xen-devel/2016-07/msg01921.html.
> >>>
> >>> All patch series can be found at
> >>>   Xen:          https://github.com/hzzhan9/xen.git nvdimm-rfc-v1
> >>>   QEMU:         https://github.com/hzzhan9/qemu.git xen-nvdimm-rfc-v1
> >>>   Linux kernel: https://github.com/hzzhan9/nvdimm.git xen-nvdimm-rfc-v1
> >>>   ndctl:        https://github.com/hzzhan9/ndctl.git pfn-xen-rfc-v1
> >>>
> >>> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
> >>> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
> >>>    memory management data structures, i.e. frame table and M2P table.
> >>> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
> >>>    hypervisor.
> >> Please can we take a step back here before diving down a rabbit hole.
> >>
> >>
> >> How do pblk/pmem regions appear in the E820 map at boot?  At the very
> >> least, I would expect at least a large reserved region.
> > ACPI specification does not require them to appear in E820, though
> > it defines E820 type-7 for persistent memory.
> 
> Ok, so we might get some E820 type-7 ranges, or some holes.
> 
> >
> >> Is the MFN information (SPA in your terminology, so far as I can tell)
> >> available in any static APCI tables, or are they only available as a
> >> result of executing AML methods?
> >>
> > For NVDIMM devices already plugged at power on, their MFN information
> > can be got from NFIT table. However, MFN information for hotplugged
> > NVDIMM devices should be got via AML _FIT method, so point 2) is needed.
> 
> How does NVDIMM hotplug compare to RAM hotplug?  Are the hotplug regions
> described at boot and marked as initially not present, or do you only
> know the hotplugged SPA at the point that it is hotplugged?
> 
> I certainly agree that there needs to be a propagation of the hotplug
> notification from OSPM to Xen, which will involve some glue in the Xen
> subsystem in Linux, but I would expect that this would be similar to the
> existing plain RAM hotplug mechanism.
> 
> >
> >> If the MFN information is only available via AML, then point 2) is
> >> needed, although the reporting back to Xen should be restricted to a xen
> >> component, rather than polluting the main device driver.
> >>
> >> However, I can't see any justification for 1).  Dom0 should not be
> >> involved in Xen's management of its own frame table and m2p.  The mfns
> >> making up the pmem/pblk regions should be treated just like any other
> >> MMIO regions, and be handed wholesale to dom0 by default.
> >>
> > Do you mean to treat them as mmio pages of type p2m_mmio_direct and
> > map them to guest by map_mmio_regions()?
> 
> I don't see any reason why it shouldn't be treated like this.  Xen
> shouldn't be treating it as anything other than an opaque block of MFNs.
> 
> The concept of trying to map a DAX file into the guest physical address
> space of a VM is indeed new and doesn't fit into Xen's current model,
> but all that fixing this requires is a new privileged mapping hypercall
> which takes a source domid and gfn scatter list, and a destination domid
> and scatter list.  (I see from a quick look at your Xen series that your
> XENMEM_populate_pmemmap looks roughly like this)

That can be quite big. Say you want to map an DAX file that has
size of 1TB and the this GFN scatter list has 1073741824 entries?

How do you envision handling this in Xen and populating the P2M entries
with this information?

> 
> ~Andrew
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
