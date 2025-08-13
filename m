Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3872A2E54C3
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097666; cv=none; b=gsFKTA2fbQIAJFuDUdodXUG7QyrdMKVVwairvUrVNvGabUWrM+aqyNCFQq3DXjIBstrGRNElAMPCpp6Izn4uPcTS5IqmBk4UmLGr+E+RzSERxBtMcc71w2zFQrf1RLUfIJylBvnHOa6a8d3syPlLf0+uPmpx2mpdOIt1LyPNgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097666; c=relaxed/simple;
	bh=aXjzebbFddO40YILFT5Z8xiBxG3ZpokNri+BjawRbDM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZu+1xkaZWaaIoKOr7ZNTSG9uYJ/rxig0NULjCSSoa5Q3nXa356kwuTs1le3jP5CT3/PdcbutGxXSiXxOHCsxT2j0JGUxTOPqWqV3u+rpeTe7id+VAHkd5PdNToT5eOmM0VpkMrpoBBu7Rp7h+sLcrJ+d1Q7Q8sBzamQ0kQgUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2BST25n0z6L54Z;
	Wed, 13 Aug 2025 23:02:49 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B4681400D4;
	Wed, 13 Aug 2025 23:07:42 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 17:07:41 +0200
Date: Wed, 13 Aug 2025 16:07:40 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 08/20] nvdimm/label: Include region label in slot
 validation
Message-ID: <20250813160740.00001ed2@huawei.com>
In-Reply-To: <20250730121209.303202-9-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121232epcas5p4cd632fe09d1bc51499d9e3ac3c2633b3@epcas5p4.samsung.com>
	<20250730121209.303202-9-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 30 Jul 2025 17:41:57 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> slot validation routine validates label slot by calculating label

Slot validation ... or
The slot validation routing ...


> checksum. It was only validating namespace label. This changeset also
> validates region label if present.
> 
> Also validate and calculate lsa v2.1 namespace label checksum

LSA v2.1 ...


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Otherwise LGTM

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



