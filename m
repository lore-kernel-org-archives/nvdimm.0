Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E30C274674
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 15:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744644972; cv=none; b=a54ZM4WXjYWKDobTP6Gib5az/hUFbgH6bp8AjyDCzdep/w6/Y8YF1mS3p7Xho//AUez9Zk23UsTrIBFMPFJ7Ou6KCpqRMsQblH55VNZuK2okkpgtn33vq7Gdd2AysqNZZ8bGEhcFqloX/cKs67BiqiJ22Hn8DIhTeAtYJk5I2/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744644972; c=relaxed/simple;
	bh=HZUyZl0U+ZEgkxFXywMHlDcIaFBX828g6Ua3936TNtE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5gCpWdPG/rPoOFmNz91HE+WoLH8xSMKIH6phhg8NPLR4gzNvME5rr6xrYl4MgbNtPhbKmZsQop8SFeyGsOouK/9uAR9ExjE5ASxAZLgBEgcla6X6Uo0kdK+3nS2Ug99eF1ebENc19hNHhgC0IV4dsFTX7uqL+S/S7QrxC7IV+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbrvK2Hr5z6FGcX;
	Mon, 14 Apr 2025 23:34:53 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D8001401DC;
	Mon, 14 Apr 2025 23:36:08 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 17:36:07 +0200
Date: Mon, 14 Apr 2025 16:36:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 06/19] cxl/port: Add 'dynamic_ram_a' to endpoint
 decoder mode
Message-ID: <20250414163606.00000311@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-6-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-6-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Sun, 13 Apr 2025 17:52:14 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Endpoints can now support a single dynamic ram partition following the
> persistent memory partition.
> 
> Expand the mode to allow a decoder to point to the first dynamic ram
> partition.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

