Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C988F42
	for <nvdimm@lists.linux.dev>; Mon, 28 Nov 2022 15:03:36 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 3043E4010229;
	Mon, 28 Nov 2022 10:03:35 -0500 (EST)
Message-ID: <ab073836-4131-357c-ba50-0ed6ac4f6775@cs.umass.edu>
Date: Mon, 28 Nov 2022 10:03:35 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: moss@cs.umass.edu
Subject: Re: nvdimm,pmem: makedumpfile: __vtop4_x86_64: Can't get a valid pte.
Content-Language: en-US
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>,
 "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <ac8d815b-b5ca-4c4f-4955-ba9adbce8678@fujitsu.com>
 <103666d5-3dcf-074c-0057-76b865f012a6@cs.umass.edu>
 <35997834-f6d2-0fc6-94a1-a7a25559d5ef@fujitsu.com>
From: Eliot Moss <moss@cs.umass.edu>
In-Reply-To: <35997834-f6d2-0fc6-94a1-a7a25559d5ef@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/28/2022 9:46 AM, lizhijian@fujitsu.com wrote:
> 
> 
> On 28/11/2022 20:53, Eliot Moss wrote:
>> On 11/28/2022 7:04 AM, lizhijian@fujitsu.com wrote:
>>> Hi folks,
>>>
>>> I'm going to make crash coredump support pmem region. So
>>> I have modified kexec-tools to add pmem region to PT_LOAD of vmcore.
>>>
>>> But it failed at makedumpfile, log are as following:
>>>
>>> In my environment, i found the last 512 pages in pmem region will cause the error.
>>
>> I wonder if an issue I reported is related: when set up to map
>> 2Mb (huge) pages, the last 2Mb of a large region got mapped as
>> 4Kb pages, and then later, half of a large region was treated
>> that way.
>>
> Could you share the url/link ? I'd like to take a look

It was in a previous email to the nvdimm list.  the title was:

"Possible PMD (huge pages) bug in fs dax"

And here is the body.  I just sent directly to the list so there
is no URL (if I should be engaging in a different way, please let me know):
================================================================================
Folks - I posted already on nvdimm, but perhaps the topic did not quite grab
anyone's attention.  I had had some trouble figuring all the details to get
dax mapping of files from an xfs file system with underlying Optane DC memory
going, but now have that working reliably.  But there is an odd behavior:

When first mapping a file, I request mapping a 32 Gb range, aligned on a 1 Gb
(and thus clearly on a 2 Mb) boundary.

For each group of 8 Gb, the first 4095 entries map with a 2 Mb huge (PMD)
page.  The 4096th one does FALLBACK.  I suspect some problem in
dax.c:grab_mapping_entry or its callees, but am not personally well enough
versed in either the dax code or the xarray implementation to dig further.


If you'd like a second puzzle 😄 ... after completing this mapping, another
thread accesses the whole range sequentially.  This results in NOPAGE fault
handling for the first 4095+4095 2M regions that previously resulted in
NOPAGE -- so far so good.  But it gives FALLBACK for the upper 16 Gb (except
the two PMD regions it alrady gave FALLBACK for).


I can provide trace output from a run if you'd like and all the ndctl, gdisk
-l, fdisk -l, and xfs_info details if you like.


In my application, it would be nice if dax.c could deliver 1 Gb PUD size
mappings as well, though it would appear that that would require more surgery
on dax.c.  It would be somewhat analogous to what's already there, of course,
but I don't mean to minimize the possible trickiness of it.  I realize I
should submit that request as a separate thread 😄 which I intend to do
later.
================================================================================

Regards - Eliot Moss
