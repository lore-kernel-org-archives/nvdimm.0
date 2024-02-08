Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766A44F5E5;
	Thu,  8 Feb 2024 22:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707430255; cv=none; b=EIQhALOD1qKf3cDWN2xcEpGRKKqS0VedmmQ+f+CiHtKHMf26cinN+8i7J1I1hQes5xBSiRH4bLS51GJ0XeKgNssCfCDk+MLuAU2dh01Uqn/jFIusflfPHqLBabh8ad/D0HrsT2FjlM808I9o2toYvPjrZt7N9KhxOJqKiZYs3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707430255; c=relaxed/simple;
	bh=yYXgLGJk/i4/luhdTTNugDTbfNRq3xV0Khh9p27hPtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNHnEp9PFpTBiw2NyV30UHKLek+RZduAaLElybbVEbp8deoKihSGyfX62+RNqtTxiN9MNbaiI62Zoik16ypo1o3UcS0o8mFYE3Zk4dxhnZjygYAUNZbB1uo9TcHQ4bZkBezxjtCLgkTQdM4xyIVmYyj41hVzmsWlZTSqkFUm3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=aiXQH6sA; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="aiXQH6sA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707430253;
	bh=yYXgLGJk/i4/luhdTTNugDTbfNRq3xV0Khh9p27hPtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aiXQH6sAUmxfTGUz6V/GLetjg46iorgn6QrPIhuH83FUsWWo7WgUIhZmGzGmeYLBV
	 fF+Kdi55dlyHZwVEDxRp8jDDeZ2S2GzcnUKgt3h7mu6Fez6I02y/3NrOKFwsJaUky0
	 enpN0jZAyBkx9owHt0MVnnc2PkpXRtYB3ikcq5sYD1Z0rPdWkoPy7znc9PLpLS/+QZ
	 wzDkOj6pcINx9ymwD35o0uYtL8NLNOEWEXLiUrGhjefJ4Ufw6ZGhbeFvj0aPfTTPDa
	 BgPVnCa+KwwEzKZ1jz1v5SI8Kf6yTcz2wMG510iQ/fp8nzpZijZRlPHtC+LSb/vB2D
	 JOWXbZ6pr5KSg==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TWB592jSGzYDC;
	Thu,  8 Feb 2024 17:10:53 -0500 (EST)
Message-ID: <0e6792eb-7504-464a-aefd-d2a803adb440@efficios.com>
Date: Thu, 8 Feb 2024 17:10:59 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] dax: Check for data cache aliasing at runtime
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Russell King <linux@armlinux.org.uk>,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-s390@vger.kernel.org
References: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
 <20240208184913.484340-7-mathieu.desnoyers@efficios.com>
 <65c54a13c52e_afa429444@dwillia2-xfh.jf.intel.com.notmuch>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <65c54a13c52e_afa429444@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-08 16:39, Dan Williams wrote:
[...]
> 
> So per other feedback on earlier patches, I think this hunk deserves to
> be moved to its own patch earlier in the series as a standalone fixup.

Done.

> 
> Rest of this patch looks good to me.

Adding your Acked-by to what is left of this patch if OK with you.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

