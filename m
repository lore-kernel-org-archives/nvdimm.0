Received: from barramail.cs.umass.edu (barramail.cs.umass.edu [128.119.240.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E6C823DE
	for <nvdimm@lists.linux.dev>; Tue,  2 Jul 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.119.240.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719923948; cv=none; b=F+m3vuoBpQOBHpMq+a3N1+Ukp7Qa0pGqx2MwlCr/4skBkPsa1FtjT27wyqLaVxzFcnI8ZVPRfOCNRrNu5FqNPxqNgqI6t1NGydeN0wiaJtFVrMrNbOKV22M8/3VfWwlrfNDfTTqzsrHZTIh6dHbF4yooEDv+EfFkUNq+22oCR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719923948; c=relaxed/simple;
	bh=TaUv/uMEdcWqTphQQYIPAUPgc/ojTim9FQJmUaYYu10=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f7bVLdMAcVUdNjMDr9xlGSgYxfVovOk/QvBRdhsre7oUmnG7/0q+QqgQ0ssqs7qXnaOq6ipjqI+NMQ5Ce2HVVRCt6HzU8L1ZQzyK0MJgJF6xsNlQ7ra1Uo23h2KdoV+SFcJINcwOOwNrC5UInFOGUjY9IrGj38UpH37rIQLHvKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.umass.edu; spf=pass smtp.mailfrom=cs.umass.edu; dkim=pass (1024-bit key) header.d=cs.umass.edu header.i=@cs.umass.edu header.b=D5EfCNrs; arc=none smtp.client-ip=128.119.240.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.umass.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.umass.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.umass.edu header.i=@cs.umass.edu header.b="D5EfCNrs"
X-ASG-Debug-ID: 1719922926-24039d23e923f34d0001-vzwpHJ
Received: from mailsrv.cs.umass.edu (mailsrv.cs.umass.edu [128.119.240.136]) by barramail.cs.umass.edu with ESMTP id K1RdAQd252WMV3Is (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Tue, 02 Jul 2024 08:22:06 -0400 (EDT)
X-Barracuda-Envelope-From: moss@cs.umass.edu
X-Barracuda-RBL-Trusted-Forwarder: 128.119.240.136
Received: from [172.27.232.57] (v.cs.umass.edu [128.119.240.133])
	by mailsrv.cs.umass.edu (Postfix) with ESMTPSA id 5E821400F1FB;
	Tue,  2 Jul 2024 08:22:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.umass.edu;
	s=mail0124-cs; t=1719922926;
	bh=2KR0K1aDj9piBH1EYoWRtxzCwY/zMkPr6Ag8r3OLydM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=D5EfCNrs2LqOWUJF9hVo5Ta+Z2iktdhTjo8mW835Ih0OnIYiqrpzh56eGIh1bwtmA
	 t/pWOw3z9h9BCr+zrq75iUJXfw+GEittlttW2grsM6AOlhMNuFQTWzdUoSwyKvmV1b
	 aKWkwzWDAN8eP79kRBmrMzrLQZ6r4sAR3v6VrUE0=
X-Barracuda-RBL-Trusted-Forwarder: 172.27.232.57
Message-ID: <69396f73-7141-8f73-6048-0c868954bcc1@cs.umass.edu>
Date: Tue, 2 Jul 2024 08:22:06 -0400
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 07/13] huge_memory: Allow mappings of PUD sized pages
Content-Language: en-US
X-ASG-Orig-Subj: Re: [PATCH 07/13] huge_memory: Allow mappings of PUD sized pages
To: Alistair Popple <apopple@nvidia.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
References: <cover.66009f59a7fe77320d413011386c3ae5c2ee82eb.1719386613.git-series.apopple@nvidia.com>
 <bd332b0d3971b03152b3541f97470817c5147b51.1719386613.git-series.apopple@nvidia.com>
 <cf572c69-a754-4d41-b9c4-7a079b25b3c3@redhat.com>
 <874j98gjfg.fsf@nvdebian.thelocal>
From: Eliot Moss <moss@cs.umass.edu>
In-Reply-To: <874j98gjfg.fsf@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mailsrv.cs.umass.edu[128.119.240.136]
X-Barracuda-Start-Time: 1719922926
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://barramail.cs.umass.edu:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cs.umass.edu
X-Barracuda-Scan-Msg-Size: 618
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.7 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.127063
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Back in 2022 I posted a bug report that may relate to this area of the code.

You can find the original email by searching the archive for "Possible PMD" and looking for me as sender.

Briefly, it had to do with trying to map 1Gb region, properly aligned.
At the time, 1G pages were not supported, so I expected to get all 2M
pages.  What happened is that all but one were 2G and last 2G was mapped
as individual 4K pages.  Seems like some kind of off-by-one problem
somewhere in the code.  Since you're deep into this part of things,
I thought I might mention this again :-) ...

Best wishes - Eliot Moss
