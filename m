Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFF033C524
	for <nvdimm@lists.linux.dev>; Tue, 28 Oct 2025 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664120; cv=none; b=g4kZ42pgE6QLe5okgPoHa6ebDkEBvMuKYK1rmNLmvm57T0xo8SWD3pl9KQ0cWKwjBt/fTNbk4L3DLyxc98KafXEi799vdZQj1fyBpMhCqkCeOXwOE7nqH9yFQRo1zVTEIOOfh0B3PbIFXtpeqtylxbbcPkZfJ0R9fPTSzXzdw6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664120; c=relaxed/simple;
	bh=dTbcHDn+RO3JFyZiIfTVSmVikKP62pzNO34OdD97sBg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JqNWjsn6x5+N6d/P9ckPIODapkSza/SjjTJnHECQMj0QyczIewQsNzg+UTNxFgWnZxxRVj8UF9r0vp/Sg3BSwRrYVrD4Pb7AcrKyLoJj5/ZOKdCwDjx06CAp5gNeQAR1e+mdFQsqqldfmkD6VexslTdGWV0DxxOGhd2j5HPxMmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cwty44dY4z6L4sL;
	Tue, 28 Oct 2025 23:06:52 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id BE9C71400C8;
	Tue, 28 Oct 2025 23:08:32 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 28 Oct
 2025 15:08:31 +0000
Date: Tue, 28 Oct 2025 15:08:30 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dave Jiang <dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <rafael@kernel.org>
Subject: Re: [PATCH v3 1/2] acpi/hmat: Return when generic target is updated
Message-ID: <20251028150830.00000c64@huawei.com>
In-Reply-To: <20251017212105.4069510-2-dave.jiang@intel.com>
References: <20251017212105.4069510-1-dave.jiang@intel.com>
	<20251017212105.4069510-2-dave.jiang@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 17 Oct 2025 14:21:04 -0700
Dave Jiang <dave.jiang@intel.com> wrote:

> With the current code flow, once the generic target is updated
> target->registered is set and the remaining code is skipped.
> So return immediately instead of going through the checks and
> then skip.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
