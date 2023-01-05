Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7188EB03
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 17:08:22 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id D88D14032BA7;
	Thu,  5 Jan 2023 12:08:18 -0500 (EST)
Message-ID: <558d0ff1-4658-a11b-5a6d-0be0a3a6799c@cs.umass.edu>
Date: Thu, 5 Jan 2023 12:08:18 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: moss@cs.umass.edu
Subject: Re: nvdimm fsdax metadata
Content-Language: en-US
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <87ec52d6-23ba-48fb-8cc7-ffbb0738c305@cs.umass.edu>
 <63b701a2c1400_5178e2949c@dwillia2-xfh.jf.intel.com.notmuch>
From: Eliot Moss <moss@cs.umass.edu>
In-Reply-To: <63b701a2c1400_5178e2949c@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/2023 11:58 AM, Dan Williams wrote:
> Eliot Moss wrote:
>> The configuration guidance for nvdimm indicates that fsdax mode requires 64
>> byte of metadata per 4K bytes of nvdimm.  The map= command line argument can
>> be used to control whether that metadata is stored in the nvdimm or regular
>> (presumably DRAM) memory.  We were pondering this as wonder what the metadata
>> is used for.  I am thinking someone on this list can clarify.  Thanks!
> 
> sizeof(struct page) == 64 (in most cases)
> 
> 'struct page' is the object that describes the state of physical memory
> pages to the rest of the kernel. Matthew wrote a useful summary of
> 'struct page' here:
> 
> https://blogs.oracle.com/linux/post/struct-page-the-linux-physical-page-frame-data-structure

Excellent coverage - makes sense!  Thank you, Dan.

>> Eliot Moss
>>
>> PS: Concerning that huge pages mapping question from a while back, is there an
>> fsdax group / list to which I could post that for followup?  Thanks - EM
> 
> The 'fsdax' topic ties together linux-mm@kvack.org,
> linux-fsdevel@vger.kernel.org, and nvdimm@lists.linux.dev. So it depends
> on what aspect you're digging into. When in doubt you can start here on
> nvdimm@lists.linux.dev and folks here can help route. IIRC you had a
> question about storage allocation alignment and huge mappings? I forgot
> the details of the questionover the holiday break.

The issue is this.  When mapping a large region, fsdax will *mostly* use
2Mb pages.  It won't use 1Gb pages at all (that would be an enhancement
request, I suppose), but it strangely decided to do certain 2Mb regions
(which *could* be mapped with a 2Mb huge page) using 4Kb pages.  A
possible clue is that when first mapping the region, it is the *last*
2Mb region that gets split into 4Kb pages.  This suggests some kind of
boundary condition not being handled in the desired way (though the
result still *works*, just with more TLB miss overhead).

Sounds like re-posting the original query to linux-mm and linux-fsdevel
might be appropriate since it has to do with mmaping files on fsdax
file systems.

Best - Eliot
