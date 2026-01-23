Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92277238C3A;
	Fri, 23 Jan 2026 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192734; cv=none; b=CYxXeuMgKPocvPYi0kM/vrWW9/wBJgr/OzCbrn9TtpbfylnwrT2CnBpD3Fe2961scDrqja8droy1s9zM2khf+YjCioDEpHq5LOaHNxGWikMlzfyliVC/qGnGTp8d7RVkRZmVt1iHdCv5Q6Q7vmSMP+XCShMVtbha3+jUunHXmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192734; c=relaxed/simple;
	bh=VW7R3rd/BXUDquFzJCJ5EgrsgJ2mIIc9ebQv6uxx16M=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqWm8n9Vp1ry20/duGF/DUXBoTOREQ0ko1ZfQu5yoPyjTkm4cngeUmh2yR5J+p9+URpXKYRDbhaEObNy/tusMbTdSVUZucoDlvD9djSL1d4DIE+ixGwh+YNM5WEWGGCFfGDnX7Ymgd1LQ3g1eXki7j1kPpt9wr1N7wUzotjqjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dyRDV5hM0zJ467F;
	Sat, 24 Jan 2026 02:24:58 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 85A9F40570;
	Sat, 24 Jan 2026 02:25:28 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 23 Jan
 2026 18:25:27 +0000
Date: Fri, 23 Jan 2026 18:25:26 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux.dev>,
	<kernel-team@meta.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <mst@redhat.com>,
	<jasowang@redhat.com>, <xuanzhuo@linux.alibaba.com>, <eperezma@redhat.com>,
	<osalvador@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online
 type control
Message-ID: <20260123182526.00005ee8@huawei.com>
In-Reply-To: <aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
	<20260114085201.3222597-4-gourry@gourry.net>
	<b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
	<aWfR86RIKEvyZsh6@gourry-fedora-PF4VCD3F>
	<4520e7b0-8218-404d-8ede-e62d95c50825@kernel.org>
	<aXLCAtwMkSMH3DNj@gourry-fedora-PF4VCD3F>
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

On Thu, 22 Jan 2026 19:34:10 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Thu, Jan 22, 2026 at 11:41:24PM +0100, David Hildenbrand (Red Hat) wrote:
> > 
> > Right, but I don't want any other OOT kernel module to be able to make use
> > of add_memory_driver_managed() to do arbitrary things, because we don't know
> > if it's really user space setting the policy for that memory then.
> >   
> 
> Ah, this was lost on me.
> 
> > So either restrict add_memory_driver_managed() to kmem+virtio_mem
> > completely, or add another variant that will be kmem-only (or however that
> > dax/cxl module is called).  
> 
> unclear to me how to restrict a function to specific drivers, but i can
> add add_and_online_memory_driver_managed() trivially so no big issue.

Is EXPORT_SYMBOL_GPL_FOR_MODULE() enough?

> 
> You'd be ok with with this?
> 
> add_and_online_memory_driver_managed(..., online_type) {
>    ... existing add_memory_driver_managed() code ...
> }
> 
> add_memory_driver_managed(...) {
>    add_and_online_memory_driver_managed(..., mhp_get_default_policy());
> }

> 
> ~Gregory
> 

