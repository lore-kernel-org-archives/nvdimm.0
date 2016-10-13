Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 13 Oct 2016 17:08:30 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161013090830.lidln5etwvadrfsn@hz-desktop>
References: <CAPcyv4hBzGJeR=6bxa+DEwPGQFSCBGsQ1S18GR+y5_MMq6+f4g@mail.gmail.com>
 <20161012103318.vq36ed5ebb5xxcom@hz-desktop>
 <57FE3B880200007800116A75@prv-mh.provo.novell.com>
 <20161012145826.wwxecoo4o3ypos5o@hz-desktop>
 <57FE75520200007800116D27@prv-mh.provo.novell.com>
 <CAPcyv4jYekNQQnD39sE=HekxUAOgXCx3_c3GLjV7MDUnvrK0vQ@mail.gmail.com>
 <57FE7A710200007800116D60@prv-mh.provo.novell.com>
 <CAPcyv4gRMhfU1MF=qYAYfidWwjjRj_qQnH6OpFsodakisP2hfQ@mail.gmail.com>
 <57FF633E0200007800116F59@prv-mh.provo.novell.com>
 <20161013085344.ulju7pnnbvufc4em@hz-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161013085344.ulju7pnnbvufc4em@hz-desktop>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Beulich <JBeulich@suse.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, andrew.cooper3@citrix.com, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

+Dan Williams

I accidentally dropped him in my last reply. Add him back.

On 10/13/16 16:53 +0800, Haozhong Zhang wrote:
>On 10/13/16 02:34 -0600, Jan Beulich wrote:
>>>>>On 12.10.16 at 18:19, <dan.j.williams@intel.com> wrote:
>>>On Wed, Oct 12, 2016 at 9:01 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>>>>On 12.10.16 at 17:42, <dan.j.williams@intel.com> wrote:
>>>>>On Wed, Oct 12, 2016 at 8:39 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>>>>>>On 12.10.16 at 16:58, <haozhong.zhang@intel.com> wrote:
>>>>>>>On 10/12/16 05:32 -0600, Jan Beulich wrote:
>>>>>>>>>>>On 12.10.16 at 12:33, <haozhong.zhang@intel.com> wrote:
>>>>>>>>>The layout is shown as the following diagram.
>>>>>>>>>
>>>>>>>>>+---------------+-----------+-------+----------+--------------+
>>>>>>>>>| whatever used | Partition | Super | Reserved | /dev/pmem0p1 |
>>>>>>>>>|  by kernel    |   Table   | Block | for Xen  |              |
>>>>>>>>>+---------------+-----------+-------+----------+--------------+
>>>>>>>>>                \_____________________ _______________________/
>>>>>>>>>                                  V
>>>>>>>>>                             /dev/pmem0
>>>>>>>>
>>>>>>>>I have to admit that I dislike this, for not being OS-agnostic.
>>>>>>>>Neither should there be any Xen-specific region, nor should the
>>>>>>>>"whatever used by kernel" one be restricted to just Linux. What
>>>>>>>>I could see is an OS-reserved area ahead of the partition table,
>>>>>>>>the exact usage of which depends on which OS is currently
>>>>>>>>running (and in the Xen case this might be both Xen _and_ the
>>>>>>>>Dom0 kernel, arbitrated by a tbd protocol). After all, when
>>>>>>>>running under Xen, the Dom0 may not have a need for as much
>>>>>>>>control data as it has when running on bare hardware, for it
>>>>>>>>controlling less (if any) of the actual memory ranges when Xen
>>>>>>>>is present.
>>>>>>>>
>>>>>>>
>>>>>>>Isn't this OS-reserved area still not OS-agnostic, as it requires OS
>>>>>>>to know where the reserved area is?  Or do you mean it's not if it's
>>>>>>>defined by a protocol that is accepted by all OSes?
>>>>>>
>>>>>>The latter - we clearly won't get away without some agreement on
>>>>>>where to retrieve position and size of this area. I was simply
>>>>>>assuming that such a protocol already exists.
>>>>>>
>>>>>
>>>>>No, we should not mix the struct page reservation that the Dom0 kernel
>>>>>may actively use with the Xen reservation that the Dom0 kernel does
>>>>>not consume.  Explain again what is wrong with the partition approach?
>>>>
>>>>Not sure what was unclear in my previous reply. I don't think there
>>>>should be apriori knowledge of whether Xen is (going to be) used on
>>>>a system, and even if it gets used, but just occasionally, it would
>>>>(apart from the abstract considerations already given) be a waste
>>>>of resources to set something aside that could be used for other
>>>>purposes while Xen is not running. Static partitioning should only be
>>>>needed for persistent data.
>>>
>>>The reservation needs to be persistent / static even if the data is
>>>volatile, as is the case with struct page, because we can't have the
>>>size of the device change depending on use.  So, from the aspect of
>>>wasting space while Xen is not in use, both partitions and the
>>>intrinsic reservation approach suffer the same problem. Setting that
>>>aside I don't want to mix 2 different use cases into the same
>>>reservation.
>>
>>Then you didn't understand what I've said: I certainly didn't mean
>>the reservation to vary from a device perspective. However, when
>>Xen is in use I don't see why part of that static reservation couldn't
>>be used by Xen, and another part by the Dom0 kernel. The kernel
>>obviously would need to ask the hypervisor how much of the space
>>is left, and where that area starts.
>>
>
>I think Dan means that there should be a clear separation between
>reservations for different usages (kernel/xen/...). The libnvdimm
>driver is for the linux kernel and only needs to maintain the
>reservation for kernel functionality. For others including xen/dm/...,
>if they want reservation for their own purpose, they should maintain
>their own reservations out of libnvdimm driver and avoid bothering the
>libnvdimm driver (e.g. add specific handling in libnvdimm driver).
>
>IIUC, one existing example is device-mapper device (dm) which needs to
>reserve on-device area for its own meta-data. Its choice is to store
>the meta-data on the block device (/dev/pmemN) provided by the
>libnvdimm driver.
>
>I think we can do the similar for Xen, like to lay another pseudo
>device on /dev/pmem and do the reservation, like 2. in my previous
>reply.
>
>Thanks,
>Haozhong
>
>>>The kernel needs to know about the struct page reservation because it
>>>needs to manage the lifetime of page references vs the lifetime of the
>>>device.  It does not have the same relationship with a Xen reservation
>>>which is why I'm proposing they be managed separately.
>>
>>I don't think I understand the difference you try to point out here.
>>Linux'es struct page and Xen's struct page_info serve the same
>>fundamental purpose.
>>
>>Jan
>>
>_______________________________________________
>Linux-nvdimm mailing list
>Linux-nvdimm@lists.01.org
>https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
