Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FE26159E
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120659; cv=none; b=BmM00uWnuZq9yvBp0rveHyf48/I79M5bS2mLCyddd/w+eqhjFe/P26WVrdmO0x7RwJ79nkHpN+Z7KdOBAqd3VHjslQTG/KMboBMmUbQB7CZJgCW4sFgXGm9yQ5b7Tpj2J5GrtwgSbnlgxCvdBzkWfuisM/UnSIF1uio8bTQF5Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120659; c=relaxed/simple;
	bh=/LXEnIcwyCEUv71E6xA1Aye6oJJBu2ChihUDc3nrTBk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2BVQ8u9b/kFXNKTDhDGXMNjcthEJ1cMgZkgwZ1yBBJl0Crxl9ZYbIjOapiXO2qzC5mKhLIdZpJRyqpRyL9k89Hn1szwZMJSlrnNJsp3oQoFW0cTGdqZFoNYdF0/RRlY4lcpYLyV4xQB/Z2FBCiPaBKowwHXLrRySiSXLiMh7lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRhVn6KHfz6GDNh;
	Wed, 17 Sep 2025 22:49:21 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 07E12140373;
	Wed, 17 Sep 2025 22:50:55 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 16:50:54 +0200
Date: Wed, 17 Sep 2025 15:50:53 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>,
	<neeraj.kernel@gmail.com>, <cpgs@samsung.com>
Subject: Re: [PATCH V3 00/20] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <20250917155053.00004c03@huawei.com>
In-Reply-To: <20250917134116.1623730-1-s.neeraj@samsung.com>
References: <CGME20250917134126epcas5p3e20c773759b91f70a1caa32b9f6f27ff@epcas5p3.samsung.com>
	<20250917134116.1623730-1-s.neeraj@samsung.com>
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

On Wed, 17 Sep 2025 19:10:56 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:


Hi,
Not sure what difference between the two versions I'm seeing is.
Patch 02 is missing in both of them.

Jonathan
