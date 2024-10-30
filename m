Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858551E47B6
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294989; cv=none; b=NTf87PAvE/BxcNR/cb5rpzhssFzcY7KMsRI5bErbl9tG4Mpr+AWMU0b+SnWkmnhWJKvv+ZhyO60AJTTnSIiImsav/NsXU2I6qQ+ByeDV89hjrriq6v7n9buFgjmFYoUK3P6DENBtZx+cuza5nrunWfA2vHUwd031+ZxGtY27GCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294989; c=relaxed/simple;
	bh=XCsg+C+F+3tDmNoXevzPMP8VphzK6z555XpSQwVO/LA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s98l/8xQODDYWVXVO4IpgP6HXM4iWVrN2vnjsIvpd8+nwSOi1bKttl0yW1AjSkr9KOuv+f6NKPeCVu4/8oG0RnOCYDKu+ZDInuq9JY73LdrAxc0c4y4PjFhYH3qTkpE7mJiu7wFjLTKB+q/wFPPLYbP2OQncJqYxpIIy4HZ4O28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xdnwl2SqMz6K6Kq;
	Wed, 30 Oct 2024 21:27:19 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 76060140B38;
	Wed, 30 Oct 2024 21:29:44 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 30 Oct
 2024 14:29:43 +0100
Date: Wed, 30 Oct 2024 13:29:42 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 05/27] cxl/hdm: Use guard() in cxl_dpa_set_mode()
Message-ID: <20241030132942.00006e19@Huawei.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-5-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
	<20241029-dcd-type2-upstream-v5-5-8739cb67c374@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 29 Oct 2024 15:34:40 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Additional DCD functionality is being added to this call which will be
> simplified by the use of guard() with the cxl_dpa_rwsem.
> 
> Convert the function to use guard() prior to adding DCD functionality.
> 
> Suggested-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
