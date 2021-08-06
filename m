Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A68A70
	for <nvdimm@lists.linux.dev>; Fri,  6 Aug 2021 09:12:38 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECDA16113C;
	Fri,  6 Aug 2021 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1628241158;
	bh=gVfakN+vVEJEkHVwWBvwIWcsbdvB9+grIspJr8mNPEU=;
	h=Subject:To:References:From:Date:In-Reply-To:From;
	b=Y+v10eWW1J89wUgq2yYaMGLzvwigXh/mmmmi9nVT//xG34nNrbe1IZkeBEVWz/8dI
	 rToriWczbHQ6NH3KF8P375IE+zqapbU12B+we/ctGGbTy0nRUFtUsY6+d+7uKsmKKw
	 w5Y4b4iEE7Ux/SwRRxl8iO/ES3cYyuv5n/Dei1BTtb8jZBXB+Mre5aVWMhermYLoRH
	 0Tk3sfqfsvGChV2RseF5eF3vuewwbE/wqJO3N516fpFY5zJ7dgJzuVwoGCrezscflH
	 U+NA4mkpd2cg1WsjaNztiAF1bOHjOT5ytPU2Ia9O7lFU9vIPBj1YhnO2lxo/Thbmhj
	 y2MDDAqyFA01A==
Subject: Re: [PATCH v3 2/3] erofs: dax support for non-tailpacking regular
 file
To: linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Liu Bo <bo.liu@linux.alibaba.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Liu Jiang
 <gerry@linux.alibaba.com>, Huang Jianan <huangjianan@oppo.com>,
 Tao Ma <boyu.mt@taobao.com>
References: <20210805003601.183063-1-hsiangkao@linux.alibaba.com>
 <20210805003601.183063-3-hsiangkao@linux.alibaba.com>
 <7aa650b8-a853-368d-7a81-f435194eec33@kernel.org>
 <YQtZ+CtvB3P+7Xim@B-P7TQMD6M-0146.local>
From: Chao Yu <chao@kernel.org>
Message-ID: <2bdaab77-c219-3f42-f50d-2af856386006@kernel.org>
Date: Fri, 6 Aug 2021 17:12:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YQtZ+CtvB3P+7Xim@B-P7TQMD6M-0146.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Xiang,

On 2021/8/5 11:24, Gao Xiang wrote:
> Thanks, it originally inherited from filesystems/ext2.rst, I will update
> this into
> dax, dax={always,never}      .....

Above change looks fine to me, thanks.

> 
> Since for such image vm-shared memory scenario, no need to add per-file
> DAX (at least for now.)

Agreed.

Thanks,
