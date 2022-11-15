Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615888AD0
	for <nvdimm@lists.linux.dev>; Tue, 15 Nov 2022 21:15:53 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id CE26340376A5;
	Tue, 15 Nov 2022 16:15:45 -0500 (EST)
Message-ID: <d2a5fefa-f018-6063-0c3f-bf6bd845af8b@cs.umass.edu>
Date: Tue, 15 Nov 2022 16:15:46 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Reply-To: moss@cs.umass.edu
Content-Language: en-US
From: Eliot Moss <moss@cs.umass.edu>
To: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Subject: Possible PMD (huge pages) bug in fs dax
Cc: nvdimm@lists.linux.dev
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

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


If you'd like a second puzzle :-) ... after completing this mapping, another
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
should submit that request as a separate thread :-) which I intend to do
later.

Regards - Eliot Moss
