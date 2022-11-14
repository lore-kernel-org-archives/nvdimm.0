Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AB2539B
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 15:09:50 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id C00064032B9E;
	Mon, 14 Nov 2022 10:09:42 -0500 (EST)
Message-ID: <a8cf600d-ee03-d67b-fef2-b8ca3355a263@cs.umass.edu>
Date: Mon, 14 Nov 2022 10:09:43 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: moss@cs.umass.edu
Subject: Re: Detecting whether huge pages are working with fsdax - only
 partial success
Content-Language: en-US
From: Eliot Moss <moss@cs.umass.edu>
To: nvdimm@lists.linux.dev
References: <8635b40a-6e87-b5da-e63d-476309bbc80b@cs.umass.edu>
In-Reply-To: <8635b40a-6e87-b5da-e63d-476309bbc80b@cs.umass.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/2022 4:59 PM, Eliot Moss wrote:
> Dear nvdimmers -
> 
> I tried following Darrick Wong's advice from this page:
> 
> https://nvdimm.wiki.kernel.org/2mib_fs_dax

With more knowledge and some fiddling, I am getting huge pages to work ...
sometimes.

But first, is this the right place to ask questions?  Folks don't seem to
respond.  If this is not the place, perhaps someone could point me to
better places?  Thanks!

Meanwhile, I now see a *mix* of FALLBACK and NOPAGE trace records happening
when I map 32G from a dax file.  I map with:

MAP_SYNC
MAP_SHARED
MAP_SHARED_VALIDATE

not MAP_FIXED

Also, MAP_LOCK and MAP_POPULATE do not seem to change the behavior.

AFAICT, everything has proper 2M alignment - /proc/iomem shows that and
the partition is set to start at 4096 512-byte sectors, ndctl uses 1G
alignment and xfs 2M.

What I see is ~11,000 FALLBACK trace records and about ~11,000 NOPAGE,
with FALLBACK coming first then NOPAGE.  My little app then touches
cache lines sequentially through the 32G region.

I am happy to provide more details, but did not want to create a long
message if this is not the place :-) ...

Also, can fs_dax do 1G huge pages?  If so, how do I make that go, since
the same approach of alignments, etc., does not seem to make it happen.

Regards - Eliot Moss
