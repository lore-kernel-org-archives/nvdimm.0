Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD422F533F
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 15:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755098001; cv=none; b=Xwa0L1S9PFDAk1lHlgjFeqGT61NssFD2mL5pY8FJtHgxjQxJI6NXAI09qXlQtWegkz+NWtZuYHZfSYlBKYijc44UHPshbkdGZO4tWeP5CL5/sYziEfSuJ/fzjxQXevIU6naJvSTiOExsw5bq0OiZZTcvELSgjIW4XgkRpjZgLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755098001; c=relaxed/simple;
	bh=uOazUY7Am4npUqN6/dxnyqww0kMueYIjYkCCZFttFmQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knYRrRsHz1atEjs8LhRqFyBIcyIvo7225Z1yu5zPXcGWHsbBsXb4peEz8JI74yMCs8eNtfoqPGl3kJb/XLRBl9To3jv4x4RXZFqwKz7BjErtEqAEeF0YXW2WhNnFsKBbFMlbom+1t8PrQZaFsK22tNPf0Qd6vSFbIudKWYS0VlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2BZv66LRz6L54K;
	Wed, 13 Aug 2025 23:08:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BBA5514033C;
	Wed, 13 Aug 2025 23:13:16 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 17:13:16 +0200
Date: Wed, 13 Aug 2025 16:13:15 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 11/20] nvdimm/region_label: Export routine to fetch
 region information
Message-ID: <20250813161315.00006e74@huawei.com>
In-Reply-To: <20250730121209.303202-12-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121236epcas5p4b8939ed1bfff468c965a9dbd6bc261b6@epcas5p4.samsung.com>
	<20250730121209.303202-12-s.neeraj@samsung.com>
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

On Wed, 30 Jul 2025 17:42:00 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> cxl region information preserved from LSA need to be exported so as to
> use by cxl driver for cxl region re-creation

CXL region information preserved from the LAS needs to be exported for
use by the CXL driver for CXL region re-creation.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

