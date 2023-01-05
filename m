Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FFB7B
	for <nvdimm@lists.linux.dev>; Thu,  5 Jan 2023 01:02:32 +0000 (UTC)
Received: from [192.168.50.148] (c-24-62-201-179.hsd1.ma.comcast.net [24.62.201.179])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 13FEF402A4ED;
	Wed,  4 Jan 2023 19:53:00 -0500 (EST)
Message-ID: <87ec52d6-23ba-48fb-8cc7-ffbb0738c305@cs.umass.edu>
Date: Wed, 4 Jan 2023 19:52:59 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: moss@cs.umass.edu
Content-Language: en-US
From: Eliot Moss <moss@cs.umass.edu>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: nvdimm fsdax metadata
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

The configuration guidance for nvdimm indicates that fsdax mode requires 64
byte of metadata per 4K bytes of nvdimm.  The map= command line argument can
be used to control whether that metadata is stored in the nvdimm or regular
(presumably DRAM) memory.  We were pondering this as wonder what the metadata
is used for.  I am thinking someone on this list can clarify.  Thanks!

Eliot Moss

PS: Concerning that huge pages mapping question from a while back, is there an
fsdax group / list to which I could post that for followup?  Thanks - EM
