Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64B7388846
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770055037; cv=none; b=L32NREP3AQIAhsfiRAvY1pwhCcrfBuZOzKsjiyprBuMU3nw/SuuZk8wNVw87FIqsD/MNkrjyekOdrM5LAFix1DnA25uacooT/4b5YJpzi5o8VbH6mdp+iZCsG3rFmjxZg+IGCpLql6m2g64z+Py4nCaaI4kD9xhZhAFlc0Tybwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770055037; c=relaxed/simple;
	bh=YN7IjAEshAO9I2F+7UJYSubChTzurjmBJ3G57Aho9po=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pB25wocR2K/itQHAShiLgyPoa+XF9fZoyoJ0Fz345Tgj14ahRe8I1Xbjk3Vy68QgQMYWCV5DOb6WLNZpyvPly5ZQr+kbjHJNizA8e57NPU4UHIs2N5xV9x9REDcs6sFz1LSlup19aCISWft1CM1/SkfFD9KOptmnShEWuvWP6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z6z3Hl0zJ467h;
	Tue,  3 Feb 2026 01:56:27 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 8880240539;
	Tue,  3 Feb 2026 01:57:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:57:12 +0000
Date: Mon, 2 Feb 2026 17:57:11 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 6/9] cxl/core/region: move dax region device logic into
 dax_region.c
Message-ID: <20260202175711.000021d4@huawei.com>
In-Reply-To: <20260129210442.3951412-7-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-7-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Thu, 29 Jan 2026 16:04:39 -0500
Gregory Price <gourry@gourry.net> wrote:

> Move the CXL DAX region device infrastructure from region.c into a
> new dax_region.c file.

Likewise. Why?

> 
> No functional changes.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>


