Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D9130AACA
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120872; cv=none; b=nu2HGEK4WpnkTOWnDUOQnSUXiMOAMMTDsWHYBVZd8D32R8wFmqas5z7jOLaaGlDzH4+0gUwd8UrrDQQ6Pf/3mRU+DExvpfVMxWAVRQtBewcfF52CJpSCIxXQoIg2y3WOh6TpXKGKlIs/eAUdCjNq2GBkI+EmN6w+cyhm7iTpiQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120872; c=relaxed/simple;
	bh=KS7kv/NTfqTgr3S5WYRaN2GS8eUh1o3rCXuMhHyakHM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWxLQY0+OMGijd9NF+mf4baJhbZo9kgmZiY7f5b0p0rQqqgh3q+7pMfT0e21lOOIWOkXnxYVUWZtob6ixuUlatzuQLVJYiK2Pr//ndt6BGy6ffDhG/YSJzkuq2VxrZCYIVcaeh7QA2RsUEN+Y9UcYVgYcrU2PrA1SD6m96IIq7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRhWQ61K1z6L60S;
	Wed, 17 Sep 2025 22:49:54 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 7162C1400F4;
	Wed, 17 Sep 2025 22:54:27 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 16:54:26 +0200
Date: Wed, 17 Sep 2025 15:54:25 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 05/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <20250917155425.00003c87@huawei.com>
In-Reply-To: <20250917134116.1623730-6-s.neeraj@samsung.com>
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134138epcas5p2b02390404681df79c26f7a1a0f0262b8@epcas5p2.samsung.com>
	<20250917134116.1623730-6-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 17 Sep 2025 19:11:01 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section 9.13.2.5
> Modified __pmem_label_update function using setter functions to update
> namespace label as per CXL LSA 2.1
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Note I'm not particularly familiar with the nvdimm code so this will ideally
want review from someone who is!

Jonathan
