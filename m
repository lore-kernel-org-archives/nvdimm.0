From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/5] mm/resource: return real error codes from walk
 failures
Date: Tue, 29 Jan 2019 12:18:05 +1100
Message-ID: <87k1ios1ma.fsf@concordia.ellerman.id.au>
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231442.EFD29EE0@viggo.jf.intel.com>
 <CAErSpo7kMjfi-1r8ZyGbheWzo+JCFkDZ1zpVhyNV7VVy8NOV7g@mail.gmail.com>
 <4898e064-5298-6a82-83ea-23d16f3dfb3d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <4898e064-5298-6a82-83ea-23d16f3dfb3d-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:
> On 1/25/19 1:02 PM, Bjorn Helgaas wrote:
>>> @@ -453,7 +453,7 @@ int walk_system_ram_range(unsigned long
>>>         unsigned long flags;
>>>         struct resource res;
>>>         unsigned long pfn, end_pfn;
>>> -       int ret = -1;
>>> +       int ret = -EINVAL;
>> Can you either make a similar change to the powerpc version of
>> walk_system_ram_range() in arch/powerpc/mm/mem.c or explain why it's
>> not needed?  It *seems* like we'd want both versions of
>> walk_system_ram_range() to behave similarly in this respect.
>
> Sure.  A quick grep shows powerpc being the only other implementation.

Ugh gross, why are we reimplementing it? ...

Oh right, memblock vs iomem. We should fix that one day :/

> I'll just add this hunk:
>
>> diff -puN arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1 arch/powerpc/mm/mem.c
>> --- a/arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1  2019-01-25 12:57:00.000004446 -0800
>> +++ b/arch/powerpc/mm/mem.c     2019-01-25 12:58:13.215004263 -0800 
>> @@ -188,7 +188,7 @@ walk_system_ram_range(unsigned long star 
>>         struct memblock_region *reg; 
>>         unsigned long end_pfn = start_pfn + nr_pages; 
>>         unsigned long tstart, tend; 
>> -       int ret = -1; 
>> +       int ret = -EINVAL; 
>
> I'll also dust off the ol' cross-compiler and make sure I didn't
> fat-finger anything.

Modern Fedora & Ubuntu have packaged cross toolchains. Otherwise there's
the kernel.org ones, or bootlin has versions with libc if you need it.

Patch looks fine. That value could only get to userspace if we have no
memory, which would be interesting.

Acked-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> (powerpc)

cheers
