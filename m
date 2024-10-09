Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C14719149F
	for <nvdimm@lists.linux.dev>; Wed,  9 Oct 2024 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728476652; cv=none; b=pYcYPqm2u7i9D++yVoWqWxghVBb8All4ubzdVW7Oxzdc8XdFFWiE+PQxlNfhGXVo4pLMjTBgibjY0Y4TmwvvVypTkJ9att3Wr6EKHhP8CNfnI0+HNnoBKmSJd9f+szakhWUjmMOkJ2QubzTcShZyAHHOQiNVab5NfZU2pjon7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728476652; c=relaxed/simple;
	bh=hhocxfvtHIadllzM1IXK9MVEK8WE49Q8Sup5vkSk3nw=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RfmA9+FU724PtGsKJB02/I9JKqFaY/hLZkYysMzJ8zSKOTxCyKAolDlTFB6s8kHNaYKuJ2Gxr2x/SfR3lRwGywGKPrGPODQo+haIN2eDX7EpnUUmX8aWckjCYSLN58YXnT9GtP7CryJjWZN75BeAPNvV+ELmLTePb3lH437OovU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XNsV10GDzz6K71T;
	Wed,  9 Oct 2024 20:22:49 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A5B0E140A90;
	Wed,  9 Oct 2024 20:24:06 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 9 Oct
 2024 14:24:04 +0200
Date: Wed, 9 Oct 2024 13:24:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-btrfs@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Steven
 Rostedt <rostedt@goodmis.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4 01/28] test printk: Add very basic struct resource
 tests
Message-ID: <20241009132402.000029b2@Huawei.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
	<20241007-dcd-type2-upstream-v4-1-c261ee6eeded@intel.com>
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
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Mon, 07 Oct 2024 18:16:07 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> The printk tests for struct resource were stubbed out.  struct range
> printing will leverage the struct resource implementation.
> 
> To prevent regression add some basic sanity tests for struct resource.
> 
> To: Petr Mladek <pmladek@suse.com>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> To: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
Looks sane to me.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
