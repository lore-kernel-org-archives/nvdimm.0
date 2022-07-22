Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552706AD4
	for <nvdimm@lists.linux.dev>; Fri, 22 Jul 2022 19:22:02 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 1EE254032B9E;
	Fri, 22 Jul 2022 15:22:01 -0400 (EDT)
Reply-To: moss@cs.umass.edu
Subject: Re: Building on Ubuntu; and persistence_domain:cpu_cache
From: Eliot Moss <moss@cs.umass.edu>
To: nvdimm@lists.linux.dev
References: <c8297399-4c99-52d9-861a-62fade81cda1@cs.umass.edu>
 <62daeef3d20b3_2363782948d@dwillia2-xfh.jf.intel.com.notmuch>
 <650016e6-496b-fa6d-f898-6983a35069a3@cs.umass.edu>
Message-ID: <fa3532d7-4d0c-2730-9b75-b92f329e1c00@cs.umass.edu>
Date: Fri, 22 Jul 2022 15:22:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <650016e6-496b-fa6d-f898-6983a35069a3@cs.umass.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 7/22/2022 3:08 PM, Eliot Moss wrote:
> On 7/22/2022 2:39 PM, Dan Williams wrote:
>> Eliot Moss wrote:
> 
>>> What concerns me is that it shows "persistence_domain":"memory_controller"
>>> when I think it should show the persistence domain as "cpu_cache", since this
>>> system is supposed to support eADR.

> Thank you, Dan!  The table in question is, I believe, the NFIT (NVDIMM
> Firmware Information Table).  I can see a dump of all 488 bytes of it,
> though I am not certain how to pick it apart.

A quick followup: I figured out how to parse the table by hand, and sure
enough, the relevant bit is not set.  So ndctl and friends are doing the
right thing.  The issue is either that the platform does not have the
capability we expected or that the NFIT is wrong and not reporting the
capability that the hardware actually provides.

At this point it really does seem to be a manufacturer issue of one kind
or another.

Regards - Eliot
