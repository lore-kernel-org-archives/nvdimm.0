Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4FD2FB6
	for <nvdimm@lists.linux.dev>; Mon, 27 Sep 2021 22:13:18 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 014C460F94;
	Mon, 27 Sep 2021 22:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1632780797;
	bh=aUkvMSo84Ts+2hyfPmGVIgM4abSwV67b0JY7DU1pVzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CR3ThJMTzNN7IxGCoQ9SihnqkQkkv3F41YJaAr67klqD8ay7cRcSeppUUhh/8+7PQ
	 DFxOyaBzoI962F2usbjfziq1easTinlTyXoLnTwCKEIgdylqvj9h8QEVuaeDIXyhCf
	 8pRA7I8t7831enPRtpE/358VVKwNsUwrPG5b/lRH5qyH1IXU821Yn+C1LYzW65TQiM
	 Kr2pNyLsYwmCCd+A88QwrYslEh5QjuzWUx1TBVYz6/tBtiRBBMVllLOKUI3Il17WX7
	 FhuTQ1Q9A8S1JL3ILSV0TNBfSOS3l81jmsFCnMM1Pvg1VT7bDaBh2KmwsWKeTC3U9m
	 OIVZBum14ZcHw==
Date: Mon, 27 Sep 2021 15:13:12 -0700
From: Keith Busch <kbusch@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
	sagi@grimberg.me, vishal.l.verma@intel.com,
	dan.j.williams@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
	konrad.wilk@oracle.com, roger.pau@citrix.com,
	boris.ostrovsky@oracle.com, jgross@suse.com, sstabellini@kernel.org,
	minchan@kernel.org, ngupta@vflare.org, senozhatsky@chromium.org,
	xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20210927221312.GD387558@dhcp-10-100-145-180.wdc.com>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
 <20210927220039.1064193-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927220039.1064193-4-mcgrof@kernel.org>

On Mon, Sep 27, 2021 at 03:00:32PM -0700, Luis Chamberlain wrote:
> +	/*
> +	 * test_and_set_bit() is used because it is protecting against two nvme
> +	 * paths simultaneously calling device_add_disk() on the same namespace
> +	 * head.
> +	 */
>  	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
> -		device_add_disk(&head->subsys->dev, head->disk,
> -				nvme_ns_id_attr_groups);
> +		rc = device_add_disk(&head->subsys->dev, head->disk,
> +				     nvme_ns_id_attr_groups);
> +		if (rc)
> +			return;
> +		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);

No need to set_bit() here since the test_and_set_bit() already took care
of that.
