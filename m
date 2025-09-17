Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC62F1FFE
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758119918; cv=none; b=oCzS5Hh7d5+dS2WcR64F2gPrtxKf2lv30nD7xwodVkLfA+6LuEW9oR0mPCAAddt86W/+qcEq7go4si6AhPueIlTAvtqo5OEPUL76i4xxZY4LsZsQuRh/rce7ugPZabIoPI/lhmllG41+YyYggaf+AOCBlniyM60nWPX8p6WRke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758119918; c=relaxed/simple;
	bh=qWEktuNLsaiX+QWumT4/houyu4b2+TjgXKezzwlzSqA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1uQagxzN9AhfTEG7waFb+HZNjHRFfyBHC8LiYmZM3xRznDAE7qvzglF3jTv8RrZrGUU1gglAEpD9t8lkObEJCR21r4sYrtqyBZvyCfTVFi66d7RZQnSWF2PnjjM7PFEuladSob1YOWp00nvFBHEOwcmElSIRpBJoHR1ROvzx/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRhDZ0dHnz6GDMx;
	Wed, 17 Sep 2025 22:37:02 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 32BEB1400F4;
	Wed, 17 Sep 2025 22:38:35 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 16:38:34 +0200
Date: Wed, 17 Sep 2025 15:38:33 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V3 03/20] nvdimm/label: Modify nd_label_base() signature
Message-ID: <20250917153833.00000a6b@huawei.com>
In-Reply-To: <20250917132940.1566437-4-s.neeraj@samsung.com>
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133031epcas5p44cb316383361b7b671a15a2d6d7386d1@epcas5p4.samsung.com>
	<20250917132940.1566437-4-s.neeraj@samsung.com>
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

On Wed, 17 Sep 2025 18:59:23 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> nd_label_base() was being used after typecasting with 'unsigned long'. Thus
> modified nd_label_base() to return 'unsigned long' instead of 'struct
> nd_namespace_label *'
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


I'm not that fussy either way on this one, but it seems
a reasonable thing to do.

Jonathan
