Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869112F066D
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119744; cv=none; b=RHlOzmHmXtR4w68jkFH7J0L/RPUyX0VsHV8L9Subhv/Dl9gAXmSYvjWAN9Y0uURjjBdHrdO3iooqGhhHFy6x974uxkWAQpMVJPLJr4xzvgu7ZhJYzi7PhdF3xK4JkW1BMuGXV9Qzkxq4KE2Wb6cFOXzBhfxSAS618pKTu0S1RDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119744; c=relaxed/simple;
	bh=GS9LWljY1SEWrLsgkXFogoHaAc/8/nn1zX0oAfW3w2A=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kuDEE61sqwQtVUYQzjyihWke+v7ouSFSoI3Iu1oZBJScStDS7N6TydzGE8JP3rC2rR0U9ZjcIXE30BKwznFwvMbJqxSwTskvH/r83+c6zFuFGRu8o2sCi1ijUbKiTUwUkBVAalZpqdi028LzHrRR69+4BqTf5hpcpNWX+7PDlaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRh9C16b6z6GDNF;
	Wed, 17 Sep 2025 22:34:07 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 4402D1400F4;
	Wed, 17 Sep 2025 22:35:40 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 16:35:39 +0200
Date: Wed, 17 Sep 2025 15:35:38 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V3 01/20] nvdimm/label: Introduce NDD_REGION_LABELING
 flag to set region label
Message-ID: <20250917153538.00001483@huawei.com>
In-Reply-To: <20250917132940.1566437-2-s.neeraj@samsung.com>
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133028epcas5p4ee7d30605213ca589de19b850898cc7b@epcas5p4.samsung.com>
	<20250917132940.1566437-2-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 17 Sep 2025 18:59:21 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
> introduced in CXL 2.0 Spec, which contain region label along with
> namespace label.
> 
> NDD_LABELING flag is used for namespace. Introduced NDD_REGION_LABELING
> flag for region label. Based on these flags nvdimm driver performs
> operation on namespace label or region label.
> 
> NDD_REGION_LABELING will be utilized by cxl driver to enable LSA 2.1
> region label support
> 
> Accordingly updated label index version
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
