Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA4E389473
	for <nvdimm@lists.linux.dev>; Tue, 24 Feb 2026 12:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937139; cv=none; b=QQS8vGrZO/U20wnECJ/Vw+3Rvy23rof9Jenxe2pk3e5gwt6NEgNLLG6tZPYIbfY6M76bcE7xMnHYOxU+BKxLRrm/AkQWhjNZaRUJyuLHsFvEvDyAlIMEQ8D82rE5kM9g9EuFbwCGGTUZIzk2Rvelv6oCPQ83UryrX19ssG069BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937139; c=relaxed/simple;
	bh=RNWGFcORuNRxk21IdfHej9UYm5dtqiO9c5R76E6TVM0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ug5QYdYsFHsJvhK362qrOQVCvdhP4qj6Y4i6CmwM+Wkj/dh/iTKRk7a667jnqv2P3s5B5zVqK6Tfwbmk66CQlElEsjRRbPkwpCEu/SflGQTGnuOXAC8tOWhT2i8CH/VOzvDx34KqXgyb19X3HTCcw8OkFUleqkqAJdH6n+agFhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fKy9L3vLjzHnHBl;
	Tue, 24 Feb 2026 20:44:54 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 778AF40565;
	Tue, 24 Feb 2026 20:45:34 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Feb
 2026 12:45:33 +0000
Date: Tue, 24 Feb 2026 12:45:32 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: <dan.j.williams@intel.com>
CC: Bart Van Assche <bart.vanassche@linux.dev>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon
	<will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
	<longman@redhat.com>, <linux-kernel@vger.kernel.org>, Marco Elver
	<elver@google.com>, Christoph Hellwig <hch@lst.de>, Steven Rostedt
	<rostedt@goodmis.org>, Nick Desaulniers <ndesaulniers@google.com>, "Nathan
 Chancellor" <nathan@kernel.org>, Kees Cook <kees@kernel.org>, Jann Horn
	<jannh@google.com>, Bart Van Assche <bvanassche@acm.org>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [PATCH 04/62] dax/bus.c: Fix a locking bug
Message-ID: <20260224124532.0000153a@huawei.com>
In-Reply-To: <699cd9c94943b_2f4a10073@dwillia2-mobl4.notmuch>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
	<20260223220102.2158611-5-bart.vanassche@linux.dev>
	<699cd9c94943b_2f4a10073@dwillia2-mobl4.notmuch>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 23 Feb 2026 14:50:49 -0800
<dan.j.williams@intel.com> wrote:

> Bart Van Assche wrote:
> > From: Bart Van Assche <bvanassche@acm.org>
> > 
> > Only unlock dax_dev_rwsem if it has been locked. This locking bug was
> > detected by the Clang thread-safety analyzer.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Alison Schofield <alison.schofield@intel.com>
> > Cc: nvdimm@lists.linux.dev
> > Cc: linux-cxl@vger.kernel.org
> > Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>  
> 
> Looks good,
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 

Agreed
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Maybe worth some ACQUIRE() magic as a follow up.

