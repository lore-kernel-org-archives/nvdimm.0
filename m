Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D4622257E
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 15:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093422; cv=none; b=cucXWaRU4PePox7UGf95A7QTqrrk+HPMwIr/lchyCuflLKZ/0gGo4SZ1iiDj71XJ57uWHmKfcRqNBAn2a35oqsXcGdRRgggxMRBdxXtBkYuw839ZFXoBiyUlSDd/ImFGgligec5CRTJgB398IuDeEbgyDAwZArwPXlYU0cwpCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093422; c=relaxed/simple;
	bh=6Lqe39MUqQcRAzsROX8rT3+2sz0xkHDWHLCRqcOU00k=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/s6m1amsZ92K6v+2XOFeZ3g69ILQB+QXeBu/QC/G/nYcoQsOauEPHGL5XMSnlQ/WKfo1Lc4xs9/gwJO/v/NVwreJc0nts9Lmk9hyyKFO+GEHxAeBAvUzXM880Y7dMmr3MLcOIu5PvP1tMEqsdGhcqGdbAoqwc6bfkZ6NtLWou8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fvWGP5WhNzHnGf9;
	Mon, 13 Apr 2026 23:16:45 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 1968B40577;
	Mon, 13 Apr 2026 23:16:58 +0800 (CST)
Received: from localhost (10.203.86.132) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 13 Apr
 2026 16:16:57 +0100
Date: Mon, 13 Apr 2026 16:16:56 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Yahu YH12 Gao <gaoyh12@lenovo.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH V2] drivers/dax: Fix typo in comment
Message-ID: <20260413161656.00003403@huawei.com>
In-Reply-To: <OSNPR03MB95383CB4853CB4CD18C2A376DF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
References: <OSNPR03MB95383CB4853CB4CD18C2A376DF5CA@OSNPR03MB9538.apcprd03.prod.outlook.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Sun, 5 Apr 2026 03:45:43 +0000
Yahu YH12 Gao <gaoyh12@lenovo.com> wrote:

> Fix a typo in dax_copy_to_iter where "vfs_red" should be "vfs_read".
> 
> Signed-off-by: Yahu Gao <gaoyh12@lenovo.com>
> 

Should have change log.  Format as:

---

v2: What changed.


(Though given you've sent this out already just reply here to say what changed)

> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index c00b9dff4a06..e32db0eba9c1 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -192,7 +192,7 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> 
>         /*
>          * The userspace address for the memory copy has already been validated
> -        * via access_ok() in vfs_red, so use the 'no check' version to bypass
> +        * via access_ok() in vfs_read, so use the 'no check' version to bypass
>          * the HARDENED_USERCOPY overhead.
>          */
>         if (test_bit(DAXDEV_NOMC, &dax_dev->flags))
> --
> 2.47.3
> 

