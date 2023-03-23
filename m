Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D0817CE
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 03:20:15 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id F28234029631;
	Wed, 22 Mar 2023 23:10:04 -0400 (EDT)
Message-ID: <95253bde-dcdd-d454-fa72-75b341b40fe0@cs.umass.edu>
Date: Wed, 22 Mar 2023 23:10:03 -0400
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Reply-To: moss@cs.umass.edu
Subject: Re: Determining if optane memory is installed
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, Ian Rogers <irogers@google.com>,
 nvdimm@lists.linux.dev
Cc: linux-perf-users <linux-perf-users@vger.kernel.org>,
 "Taylor, Perry" <perry.taylor@intel.com>,
 "Biggers, Caleb" <caleb.biggers@intel.com>,
 "Alt, Samantha" <samantha.alt@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>
References: <CAP-5=fV_A0A8-BnfaWFoXX2a284UDp8JHvaBLC_FXPzW5GT+=Q@mail.gmail.com>
 <641bbe1eced26_1b98bb29440@dwillia2-xfh.jf.intel.com.notmuch>
From: Eliot Moss <moss@cs.umass.edu>
In-Reply-To: <641bbe1eced26_1b98bb29440@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/22/2023 10:49 PM, Dan Williams wrote:
> Ian Rogers wrote:
>> Hi nvdimm@,
>>
>> In the perf tool there are metrics for platforms like cascade lake
>> where we're collecting data for optane memory [1] but if optane memory
>> isn't installed then the counters will always read 0. Is there a
>> relatively simple way of determining if Optane memory is installed?
>> For example, the presence of a file in /sys/devices. I'd like to
>> integrate detection of this and make the perf metrics more efficient
>> for the case where Optane memory isn't installed.
> 
> In simple terms the presence of an ACPI NFIT table is probably enough to
> tell you that the platform has persistent memory of some form:
> 
>      test -e /sys/firmware/acpi/tables/NFIT
> 
> ...if you need precision to tell the difference between battery backed
> NVDIMMs and Optane memory then you are looking for something like:
> 
>      ndctl list -D
> 
> ...which gathers NVDIMM device data from sysfs and spits it out in json
> of the form:
> 
>      {
>        "dev":"nmem0",
>        "id":"cdab-0a-07e0-ffffffff",
>        "handle":0,
>        "phys_id":0,
>        "security:":"disabled"
>      }
> 
> ...where the id string follow the format defined here:
> 
> https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#nvdimm-representation-format
> 
> ...and then you would need to know the id string of Optane devices vs
> other NVDIMM vendors, which I think is overkill for what seems like a
> simple case of hide counters that will never increment.

Cool!  My older machine with first gen Optane DC shows:

     "id":"8089-a2-1911-0000148d",
     "id":"8089-a2-1911-00001546",
     "id":"8089-a2-1911-0000173c",
     "id":"8089-a2-1911-00001781",
     "id":"8089-a2-1911-00001a7f",
     "id":"8089-a2-1911-00001a8e",
     "id":"8089-a2-1911-00001a9c",
     "id":"8089-a2-1911-00001aba",
     "id":"8089-a2-1911-00001b0a",
     "id":"8089-a2-1911-00001b1f",
     "id":"8089-a2-1911-00001b31",
     "id":"8089-a2-1911-00001b33",

My newer one with second gen shows:

     "id":"8089-a2-2134-00000027",
     "id":"8089-a2-2134-00000156",
     "id":"8089-a2-2134-00000159",
     "id":"8089-a2-2134-00000317",
     "id":"8089-a2-2134-00000709",
     "id":"8089-a2-2134-0000091e",
     "id":"8089-a2-2134-00000935",
     "id":"8089-a2-2134-00000981",

Enjoy!  Eliot Moss
