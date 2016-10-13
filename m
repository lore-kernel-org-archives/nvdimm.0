Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161011194810.GD25907@localhost.localdomain>
 <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
 <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
 <57FE3B880200007800116A75@prv-mh.provo.novell.com>
 <20161012145826.wwxecoo4o3ypos5o@hz-desktop>
 <57FE75520200007800116D27@prv-mh.provo.novell.com>
 <CAPcyv4jYekNQQnD39sE=HekxUAOgXCx3_c3GLjV7MDUnvrK0vQ@mail.gmail.com>
 <57FE7A710200007800116D60@prv-mh.provo.novell.com>
 <CAPcyv4gRMhfU1MF=qYAYfidWwjjRj_qQnH6OpFsodakisP2hfQ@mail.gmail.com>
 <57FF633E0200007800116F59@prv-mh.provo.novell.com>
 <20161013085344.ulju7pnnbvufc4em@hz-desktop>
 <57FF6B130200007800116F96@prv-mh.provo.novell.com>
 <CAPcyv4hpmVU477vrAeJrcHpMS9qRSnRwY1T8FrPqAxZXMyLBOg@mail.gmail.com>
From: Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <ff42a1c8-6b7d-dea5-f1e6-0778f316eb50@citrix.com>
Date: Thu, 13 Oct 2016 17:01:37 +0100
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hpmVU477vrAeJrcHpMS9qRSnRwY1T8FrPqAxZXMyLBOg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Jan Beulich <JBeulich@suse.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 13/10/16 16:40, Dan Williams wrote:
> On Thu, Oct 13, 2016 at 2:08 AM, Jan Beulich <JBeulich@suse.com> wrote:
> [..]
>>> I think we can do the similar for Xen, like to lay another pseudo
>>> device on /dev/pmem and do the reservation, like 2. in my previous
>>> reply.
>> Well, my opinion certainly doesn't count much here, but I continue to
>> consider this a bad idea. For entities like drivers it may well be
>> appropriate, but I think there ought to be an independent concept
>> of "OS reserved", and in the Xen case this could then be shared
>> between hypervisor and Dom0 kernel. Or if we were to consider Dom0
>> "just a guest", things should even be the other way around: Xen gets
>> all of the OS reserved space, and Dom0 needs something custom.
> You haven't made the case why Xen is special and other applications of
> persistent memory are not.

In a Xen system, Xen runs in the baremetal root-mode ring0, and dom0 is
a VM running in ring1/3 with the nvdimm driver.  This is the opposite
way around to the KVM model.

Dom0, being the hardware domain, has default ownership of all the
hardware, but to gain access in the first place, it must request a
mapping from Xen.  Xen therefore needs to know and cope with being able
to give dom0 a mapping to the nvdimms, without touching the content of
the nvidmm itself (so as to avoid corrupting data).

Once dom0 has a mapping of the nvdimm, the nvdimm driver can go to work
and figure out what is on the DIMM, and which areas are safe to use.

At this point, a Xen subsystem in Linux could choose one or more areas
to hand back to the hypervisor to use as RAM/other.

~Andrew
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
