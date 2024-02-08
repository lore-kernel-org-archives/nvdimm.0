Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B11B4F5E5;
	Thu,  8 Feb 2024 22:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707432138; cv=none; b=PTt41BpMgeb7vFopj0rb8uqaxl8ZbzT3X6gSQbSu4m5MQ1tD9dOUJGm5zzYnaOW0KQ1R04advO4v30FCc4L1Cfp7FWdmChf5Hnj233e23vW/o+rV9mMjxVxN4f1EbMzFA5K5AOi3bkLQ7whAB/4E9/hFVYK/tCY8wTsKT/mu9n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707432138; c=relaxed/simple;
	bh=NhfI9CxiogmvQ0tMHv4XKQ/4Wsf7q5uvmw1GU45BQKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JPRFqCefM5P1nvpyhXYD7Ic0QFEpY44dsBi/Z8nqems9HJK4w3fPSmAAMs2nvDSnwIAz2ccCzEocSQv/3Y59xNwnoLFPBimJgSYaUiio6N3qa0xhLyPy9fpbdegFbb+K1ODgUotWbULk4HLQQBMwbkw5O3hJ5IYctanlzoCZ+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=AeGeX7kQ; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="AeGeX7kQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707432135;
	bh=NhfI9CxiogmvQ0tMHv4XKQ/4Wsf7q5uvmw1GU45BQKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AeGeX7kQ49yC5AcFerxBLe7y0eJHatSpT7NcXeuTVU3oluYj8errrXmqswmseoPDt
	 D3ah1MieEHfNwBYykfLwXfXMMJbWeH5Zqo33eaidaJZ1q+zAH9sZN2YmfxvMKEjwHu
	 5j2FukA0KclYpCmLbg7kz7Wjwu5xKanWlKr6Bk8cW+OSlDRriqz7L6zshIVtQRAyp9
	 ZO2cU55CX/E18xCLyVCPeykZB4Mg1jf69kP7nxVaPDwcPX1LiA+FTLz4/TivoHzyJo
	 3vmVzcWJiVPjogNnn1zBLhuRHyDt53WwNUxVQ31iSPU5xO5LMeNLKZljKT5OBcmDB6
	 j43QH2gh7IKEQ==
Received: from [172.16.0.134] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TWBnM0z5GzY2Z;
	Thu,  8 Feb 2024 17:42:15 -0500 (EST)
Message-ID: <5328e7f0-0864-4626-aa6c-fef5f3f62dc8@efficios.com>
Date: Thu, 8 Feb 2024 17:42:21 -0500
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
 <0e6792eb-7504-464a-aefd-d2a803adb440@efficios.com>
 <65c557a2e77f7_afa429490@dwillia2-xfh.jf.intel.com.notmuch>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <65c557a2e77f7_afa429490@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024-02-08 17:37, Dan Williams wrote:
> Mathieu Desnoyers wrote:
>> On 2024-02-08 16:39, Dan Williams wrote:
>> [...]
>>>
>>> So per other feedback on earlier patches, I think this hunk deserves to
>>> be moved to its own patch earlier in the series as a standalone fixup.
>>
>> Done.
>>
>>>
>>> Rest of this patch looks good to me.
>>
>> Adding your Acked-by to what is left of this patch if OK with you.
> 
> You can add:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...after that re-org.

Just to make sure: are you OK with me adding your Reviewed-by
only for what is left of this patch, or also to the other driver
patches after integrating your requested changes ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

