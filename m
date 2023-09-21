Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D2623D9
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 08:34:31 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="134385974"
X-IronPort-AV: E=Sophos;i="6.03,164,1694703600"; 
   d="scan'208";a="134385974"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:33:09 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 19F65C68E1
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 17:33:07 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 55ADBD67A4
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 17:33:06 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id D32A56B4F3
	for <nvdimm@lists.linux.dev>; Thu, 21 Sep 2023 17:33:05 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 32D3F1A0085;
	Thu, 21 Sep 2023 16:33:05 +0800 (CST)
Message-ID: <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
Date: Thu, 21 Sep 2023 16:33:04 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
Cc: djwong@kernel.org, chandan.babu@oracle.com, dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
In-Reply-To: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27888.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27888.006
X-TMASE-Result: 10-0.031700-10.000000
X-TMASE-MatchedRID: hwtUKlde9zGPvrMjLFD6eDjNGpWCIvfT1KDIlODIu+X6t7zbE1rC9wYE
	LASKZobWBNyCmIook0cJKoJfwgWhzbVQ6XPWwtdyEXjPIvKd74BMkOX0UoduuRz8TwDJiHPoNiL
	P5F13qP7nzlXMYw4XMCAtDqHg/4Qmv79FIUygvZzZs3HUcS/scCq2rl3dzGQ1kFmoecv+RE241u
	Vp06SlZKbkJdESNECViXnp3Tl79ABmzTBoPxkj6zqLTpHlB2+SPoq0wVsiK7kDcHQCp5ROP+AlX
	X4WyiQqZr2cb5iz368JCuHHcDs8RyWtwY45TPtNPQO/EEw5sBQadJO6FnuPXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hi,

Any comments?


--
Thanks,
Ruan.


在 2023/9/15 14:38, Shiyang Ruan 写道:
> FSDAX and reflink can work together now, let's drop this warning.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   fs/xfs/xfs_super.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 1f77014c6e1a..faee773fa026 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>   		return -EINVAL;
>   	}
>   
> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>   	return 0;
>   
>   disable_dax:
