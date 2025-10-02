Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471CF139E
	for <nvdimm@lists.linux.dev>; Thu,  2 Oct 2025 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759365981; cv=none; b=WfeLDrcEQW4t1GHZxH04KAj7xW6ok7b1ac5FwVEuoeSlVobQjojJPAZOAE1YGuX7/YwmAtwwd64mJc8s0fnsAHz2kewFhfzbN49B3izhLbh7oEwDl5gith+Py6tUb6lHy4dypw6zedUcbHYk+MU5Ifyiex7Phr1vbk0uoIV8rgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759365981; c=relaxed/simple;
	bh=iknqd0eCp2IpeMIo/D430dcU7Bg9EpRrkJmCzOFmSRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SIlkLg+Y0gQfshOci61SMtaOmQ53WiYpEbjC4whSy+80tzZrY6lY5L30bmEFCONxgqEumJ9JJ1St4E1bj6lF0VylTgoXryky8UygTiz8SsQCiMsfYDuHMs87eja0+Ud/P/XhcCPoKB7gDP8Ylwt9Xn037J9XWQD7xP3uMBHCH5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZE4B32Aj; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZE4B32Aj"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759365969; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WuWkMQGeT7UWcs46AL/wq1raG7ZzuHJ8c8y6eoG2uhs=;
	b=ZE4B32AjbNyCMie7Z0FMXMIDGjlYfoRK4WacHd1kbLznDFahHoA0DrHGhZQnUOFfJ78VpTJb3yGuzVBAQyyS50FZwBX9KiZ/7mv+y/4eF8AbM9VoOjRrSO83MhNCCQQrY1Vztfn6xDLCar69jX5/my9nIKfoau+pvCKgFA1dnok=
Received: from 30.180.0.242(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0WpGDiat_1759365968 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Oct 2025 08:46:08 +0800
Message-ID: <f8384ff9-d609-4510-aecc-7aa38d9fd9f4@linux.alibaba.com>
Date: Thu, 2 Oct 2025 08:46:07 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] dax: skip read lock assertion for read-only
 filesystems
To: Yuezhang Mo <Yuezhang.Mo@sony.com>, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Christian Brauner <brauner@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: dan.j.williams@intel.com, Friendy Su <friendy.su@sony.com>,
 Daniel Palmer <daniel.palmer@sony.com>
References: <20250930054256.2461984-2-Yuezhang.Mo@sony.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20250930054256.2461984-2-Yuezhang.Mo@sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2025/9/30 13:42, Yuezhang Mo wrote:
> The commit 168316db3583("dax: assert that i_rwsem is held
> exclusive for writes") added lock assertions to ensure proper
> locking in DAX operations. However, these assertions trigger
> false-positive lockdep warnings since read lock is unnecessary
> on read-only filesystems(e.g., erofs).
> 
> This patch skips the read lock assertion for read-only filesystems,
> eliminating the spurious warnings while maintaining the integrity
> checks for writable filesystems.
> 
> Fixes: 168316db3583 ("dax: assert that i_rwsem is held exclusive for writes")
> Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
> Reviewed-by: Friendy Su <friendy.su@sony.com>
> Reviewed-by: Daniel Palmer <daniel.palmer@sony.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

It should also fix:
https://lore.kernel.org/r/68ddc2f9.a00a0220.102ee.006e.GAE@google.com

Hi Christian and Christoph,
if it looks good to you, could we apply to the vfs tree
for this lockdep warning?

Thanks,
Gao Xiang
