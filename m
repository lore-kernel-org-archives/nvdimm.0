Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E37749E
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 19:16:57 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 2E3AB402962E;
	Mon, 14 Nov 2022 14:16:56 -0500 (EST)
Message-ID: <baca5cfb-9613-dd07-8d97-e76033b059a5@cs.umass.edu>
Date: Mon, 14 Nov 2022 14:16:56 -0500
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
 <a8cf600d-ee03-d67b-fef2-b8ca3355a263@cs.umass.edu>
In-Reply-To: <a8cf600d-ee03-d67b-fef2-b8ca3355a263@cs.umass.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

A quick followup, which may indicate a flaw in fs_dax page mapping code.

When doing that mapping of 32G, for each group of 8G, all but the last 2M
resulted in a NOPAGE 2M fault.  The very last 2M chunk of each 8G region
resulted in FALLBACK.

Then, a spawned thread accessed the same region sequentially,  This caused
the upper 16G all to result in FALLBACK (except those two 2M regions that
already had done FALLBACK).

The first case "smells" like some kind of range error in the code.

The second one is also curiously regular, but I have less of a theory
about it.

Is this the right place for discussion of this behavior and possible patches?

Regards - Eliot Moss
