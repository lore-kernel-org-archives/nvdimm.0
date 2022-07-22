Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CA6AD4
	for <nvdimm@lists.linux.dev>; Fri, 22 Jul 2022 19:08:27 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 8C5434049F06;
	Fri, 22 Jul 2022 15:08:20 -0400 (EDT)
Reply-To: moss@cs.umass.edu
Subject: Re: Building on Ubuntu; and persistence_domain:cpu_cache
To: nvdimm@lists.linux.dev
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
 <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
From: Eliot Moss <moss@cs.umass.edu>
Message-ID: <650016e6-496b-fa6d-f898-6983a35069a3@cs.umass.edu>
Date: Fri, 22 Jul 2022 15:08:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 7/22/2022 2:39 PM, Dan Williams wrote:
> Eliot Moss wrote:

>> What concerns me is that it shows "persistence_domain":"memory_controller"
>> when I think it should show the persistence domain as "cpu_cache", since this
>> system is supposed to support eADR.
> 
> This is determined by:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/acpi/nfit/core.c?h=v5.15#n3022
> 
> The first thing to check is whether your ACPI tables have that bit set,
> where that flag is coming from this table:
> 
> https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#platform-capabilities-structure
> 
> You can dump the table with the acpica-tools (acpidump and iasl).  Some
> examples of how to extract and disassemble a table is here (see the
> usage of iasl in the "how does it work" section):
> 
> https://docs.kernel.org/admin-guide/acpi/initrd_table_override.html
> 
>> I wondered if maybe I needed the very latest version of ndctl for it to print
>> that, but I cannot build it.  I did my best to obtain the pre-reqs -- they
>> mostly have different names under Ubunut -- but the first meson command,
>> "meson setup build" hangs and if I then try the compile step it complains.
> 
> ndctl is just packaging up the kernel's sysfs attribute data into JSON.
> That data is coming direct from:
> 
> /sys/bus/devices/nd/$region/persistence_domain
> 
>> I am hoping someone here might be able to shed light on how I can verify that
>> this system does support persistence_domain cpu_cache, or if something needs
>> to be enabled or turned on, etc.  I have also gotten my Dell sales rep to
>> contact the Dell product engineers about this, but have not yet heard back.
> 
> I can't help on that side, but if you do get a contact I expect the
> acpidump result from above will be useful.
> 

Thank you, Dan!  The table in question is, I believe, the NFIT (NVDIMM
Firmware Information Table).  I can see a dump of all 488 bytes of it,
though I am not certain how to pick it apart.  Still, it would seem
that, if this system really *does* support persistence_domain:cpu_cache,
the NFIT is not set up correctly by the vendor.  However, I do wonder,
with technology like this, how much of what's going on lies on Intel's
side in terms of what the P200 boards report and how much on Dell's
side.  How these lower-level pieces go together and are configured lies
beyond my current education :-) ...

I await the Dell engineers' response to my queries.

Regards - Eliot
