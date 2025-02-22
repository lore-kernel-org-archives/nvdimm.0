Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1264A05;
	Sat, 22 Feb 2025 06:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740204988; cv=none; b=S729q2FE2QviejZwfKC9O9fZzBotxTF/fgmV3LKgHOnqcIZbnKAmbebi4NIGNLQYvYnh7TybnG8G56oBWdetvU0XQTM/8aG1q/aL4cKDZ3xo88hKp2OuFHoSRYL865LBHhtL67EQdL4lFxRo3jPnHK6D/3fL4rcBhPjxrnobA0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740204988; c=relaxed/simple;
	bh=oGZoiV9szH/n+CCiiT61/xRNb8iIu1mf7maB15reJTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSQO5UMBfQrP56+OGh6Yh3EG4BrPHDOimxrz/CEXCtXIePZT/P8Zj3pSYzAE3mXzNzPY1CVhdA8dN4LGe0UBInbvd2Y72Ll+LXSsCq1zZDKn06eKu4zs66l60RprrQoOmBg983VlCzuGXcOCkhYLW4g4U+hE86lWFEcRDXyfxug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hq+ME5gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hq+ME5gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B99C4CED1;
	Sat, 22 Feb 2025 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740204987;
	bh=oGZoiV9szH/n+CCiiT61/xRNb8iIu1mf7maB15reJTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hq+ME5gdhxzS2e8SGGcQ3Ithruzy66tOJe642PIpHKndQVtDLRHSlecMJSoJrR4MI
	 RY1RHAtfKsOPFxTzO+B5HBAwnOMvSEcHLKEuGe9dm325p7KEaxmY0qH7ui/RNUhhuE
	 AUxZXwMd7zdVENAmvfFdA+mD+FCuRer3voQSuZe4Io/r1eYdpv1M3wNwtTWyBlhTvY
	 kbGfKiy/WaqcH1CYSSiTn7pzl334FSHYdKAKH4OtoEk0+OIsI3bssjs6CHWPQ1Ghv+
	 GNSW3X8TzQ83wfkxDKB/wu29Lry2u9ftWN+B54G7w0LONhwDg30a3HR6derXc1vEhn
	 md3dkAmWy3TEg==
Date: Sat, 22 Feb 2025 14:16:17 +0800
From: Coly Li <colyli@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Coly Li <i@coly.li>, Zheng Qixing <zhengqixing@huaweicloud.com>, 
	axboe@kernel.dk, song@kernel.org, dan.j.williams@intel.com, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, dlemoal@kernel.org, 
	yanjun.zhu@linux.dev, kch@nvidia.com, Hannes Reinecke <hare@suse.de>, 
	zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org, xni@redhat.com, 
	colyli@suse.de, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 05/12] badblocks: return error if any badblock set fails
Message-ID: <vdd6yaz3opuhufbfhbkhwtfj4a3oiskem7o23n3axtzy5e74xp@fibgbwxospom>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-6-zhengqixing@huaweicloud.com>
 <4qo5qliidycbjmauq22tqgv6nbw2dus2xlhg2qvfss7nawdr27@arztxmrwdhzb>
 <272e37ea-886c-8a44-fd6b-96940a268906@huaweicloud.com>
 <70D2392E-4F75-43C6-8C34-498AACC78E0C@coly.li>
 <a3c74c7c-44b6-c4c0-872d-0de7e29214c0@huaweicloud.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a3c74c7c-44b6-c4c0-872d-0de7e29214c0@huaweicloud.com>

On Sat, Feb 22, 2025 at 09:12:53AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2025/02/21 18:12, Coly Li 写道:
> > So we don’t need to add a negative return value for partial success/failure?
> > 
> > Coly Li.
> 
> Yes, I think so. No one really use this value, and patch 10 clean this
> up by changing return type to bool.

OK, then it is fine to me.

It will be good to add a code comment that parital setting will be treated as failure.

Thanks.


-- 
Coly Li
