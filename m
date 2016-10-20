Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 20 Oct 2016 17:14:53 +0800
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
Message-ID: <20161020091453.mutfhmlgb2lc4gmj@hz-desktop>
References: <CAPcyv4gRMhfU1MF=qYAYfidWwjjRj_qQnH6OpFsodakisP2hfQ@mail.gmail.com>
 <57FF633E0200007800116F59@prv-mh.provo.novell.com>
 <20161013085344.ulju7pnnbvufc4em@hz-desktop>
 <57FF6B130200007800116F96@prv-mh.provo.novell.com>
 <CAPcyv4hpmVU477vrAeJrcHpMS9qRSnRwY1T8FrPqAxZXMyLBOg@mail.gmail.com>
 <ff42a1c8-6b7d-dea5-f1e6-0778f316eb50@citrix.com>
 <CAPcyv4js4fnVfGhfS0TkCCRQGsPen0_tKHNdwjdeP6L28sK4Cg@mail.gmail.com>
 <a69fe867-8d0d-75d9-dabe-509d1fd25646@citrix.com>
 <20161014070850.hbirvazu3e2pp4gb@hz-desktop>
 <e1a1cbad-b13c-7d0e-c0a6-504600fe9498@citrix.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e1a1cbad-b13c-7d0e-c0a6-504600fe9498@citrix.com>
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
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Juergen Gross <JGross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On 10/14/16 13:18 +0100, Andrew Cooper wrote:
>On 14/10/16 08:08, Haozhong Zhang wrote:
>> On 10/13/16 20:33 +0100, Andrew Cooper wrote:
>>> On 13/10/16 19:59, Dan Williams wrote:
>>>> On Thu, Oct 13, 2016 at 9:01 AM, Andrew Cooper
>>>> <andrew.cooper3@citrix.com> wrote:
>>>>> On 13/10/16 16:40, Dan Williams wrote:
>>>>>> On Thu, Oct 13, 2016 at 2:08 AM, Jan Beulich <JBeulich@suse.com>
>>>>>> wrote:
>>>>>> [..]
>>>>>>>> I think we can do the similar for Xen, like to lay another pseudo
>>>>>>>> device on /dev/pmem and do the reservation, like 2. in my previous
>>>>>>>> reply.
>>>>>>> Well, my opinion certainly doesn't count much here, but I
>>>>>>> continue to
>>>>>>> consider this a bad idea. For entities like drivers it may well be
>>>>>>> appropriate, but I think there ought to be an independent concept
>>>>>>> of "OS reserved", and in the Xen case this could then be shared
>>>>>>> between hypervisor and Dom0 kernel. Or if we were to consider Dom0
>>>>>>> "just a guest", things should even be the other way around: Xen gets
>>>>>>> all of the OS reserved space, and Dom0 needs something custom.
>>>>>> You haven't made the case why Xen is special and other
>>>>>> applications of
>>>>>> persistent memory are not.
>>>>> In a Xen system, Xen runs in the baremetal root-mode ring0, and
>>>>> dom0 is
>>>>> a VM running in ring1/3 with the nvdimm driver.  This is the opposite
>>>>> way around to the KVM model.
>>>>>
>>>>> Dom0, being the hardware domain, has default ownership of all the
>>>>> hardware, but to gain access in the first place, it must request a
>>>>> mapping from Xen.
>>>> This is where my understanding the Xen model breaks down.  Are you
>>>> saying dom0 can't access the persistent memory range unless the ring0
>>>> agent has metadata storage space for tracking what it maps into dom0?
>>>
>>> No.  I am trying to point out that the current suggestion wont work, and
>>> needs re-designing.
>>>
>>> Xen *must* be able to properly configure mappings of the NVDIMM for
>>> dom0, *without* modifying any content on the NVDIMM.  Otherwise, data
>>> corruption will occur.
>>>
>>> Whether this means no Xen metadata, or the metadata living elsewhere in
>>> regular ram, such as the main frametable, is an implementation detail.
>>>
>>>>
>>>>> Once dom0 has a mapping of the nvdimm, the nvdimm driver can go to
>>>>> work
>>>>> and figure out what is on the DIMM, and which areas are safe to use.
>>>> I don't understand this ordering of events.  Dom0 needs to have a
>>>> mapping to even write the on-media structure to indicate a
>>>> reservation.  So, initial dom0 access can't depend on metadata
>>>> reservation already being present.
>>>
>>> I agree.
>>>
>>> Overall, I think the following is needed.
>>>
>>> * Xen starts up.
>>> ** Xen might find some NVDIMM SPA/MFN ranges in the NFIT table, and
>>> needs to note this information somehow.
>>> ** Xen might find some Type 7 E820 regions, and needs to note this
>>> information somehow.
>>
>> IIUC, this is to collect MFNs and no need to create frame table and
>> M2P at this stage. If so, what is different from ...
>>
>>> * Xen starts dom0.
>>> * Once OSPM is running, a Xen component in Linux needs to collect and
>>> report all NVDIMM SPA/MFN regions it knowns about.
>>> ** This covers the AML-only case, and the hotplug case.
>>
>> ... the MFNs reported here, especially that the former is a subset
>> (hotplug ones not included in the former) of latter.
>
>Hopefully nothing.  However, Xen shouldn't exclusively rely on the dom0
>when it is capable of working things out itself, (which can aid with
>debugging one half of this arrangement).  Also, the MFNS found by Xen
>alone can be present in the default memory map for dom0.
>

Sure, I'll add code to parsing NFIT in Xen to discover statically
plugged pmem mode NVDIMM and their MFNs.

By the default memory map for dom0, do you mean making
XENMEM_memory_map returns above MFNs in Dom0 E820?

>>
>> (There is no E820 hole or SRAT entries to tell which address range is
>> reserved for hotplugged NVDIMM)
>>
>>> * Dom0 requests a mapping of the NVDIMMs via the usual mechanism.
>>
>> Two questions:
>> 1. Why is this request necessary? Even without such requests like what
>>   my current implementation, Dom0 can still access NVDIMM.
>
>Can it?  (if so, great, but I don't think this holds in the general
>case.)  Is that a side effect of the NVDIMM being covered by a hole in
>the E820?

In my development environment, NVDIMM MFNs are not covered by any E820
entry and appear after RAM MFNs.

Can you explain more about this point? Why can it work if covered by
E820 hole?

>The current logic for what dom0 may access by default is
>somewhat ad-hoc, and I have a gut feeling that it won't work with E820
>type 7 regions.
>
>>
>>   Or do you mean Xen hypervisor should by default disallow Dom0 to
>>   access MFNs reported in previous step until they are requested?
>
>No - I am not suggesting this.
>
>>
>> 2. Who initiates the requests? If it's the libnvdimm driver, that
>>   means we still need to introduce Xen specific code to the driver.
>>
>>   Or the requests are issued by OSPM (or the Xen component you
>>   mentioned above) when they probe new dimms?
>>
>>   For the latter, Dan, do you think it's acceptable in NFIT code to
>>   call the Xen component to request the access permission of the pmem
>>   regions, e.g. in apic_nfit_insert_resource(). Of course, it's only
>>   used for Dom0 case.
>
>The libnvdimm driver should continue to use ioremap() or whatever it
>currently does.  There shouldn't be Xen modifications like that.
>
>The one issue will come if libnvdimm tries to ioremap()/other an area
>which Xen is unaware is an NVDIMM, and rejects the mapping request.
>Somehow, a Xen component will need to find the MFN/SPA layout and
>register this information with Xen, before the ioremap() call made by
>the libnvdimm driver.  Perhaps a notifier mechanism out from the ACPI
>subsystem might be the best way to make this work in a clean way.
>

Yes, this is necessary for hotplugged NVDIMM.

>>
>>> ** This should work, as Xen is aware that there is something there to be
>>> mapped (rather than just empty physical address space).
>>> * Dom0 finds that some NVDIMM ranges are now available for use (probably
>>> modelled as hotplug events).
>>> * /dev/pmem $STUFF starts happening as normal.
>>>
>>> At some pointer later after dom0 policy decisions are made (ultimately,
>>> by the host administrator):
>>> * If an area of NVDIMM is chosen for Xen to use, Dom0 needs to inform
>>> Xen of the SPA/MFN regions which are safe to use.
>>> * Xen then incorporates these regions into its idea of RAM, and starts
>>> using them for whatever.
>>>
>>
>> Agree. I think we may not need to fix the way/format/... to make the
>> reservation, and instead let the users (host administrators), who have
>> better understanding of their data, make the proper decision.
>
>Yes.  This is the best course of action.
>
>>
>> In a worse case that no reservation is made, Xen hypervisor could turn
>> to use RAM for management structures for NVDIMM, with the cost of less
>> RAM for guests.
>
>Or simply not manage the NVDIMM at all.
>
>OTOH, a different usecase might be to register a small area for Xen to
>use to crash log into.
>

an interesting usage, but I'd like to put it in the future work.

Thanks,
Haozhong
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
