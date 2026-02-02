Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C3E2DCBE6
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 18:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770057977; cv=none; b=aLMuRsHmyRRFwoOkSxYTRiTsQMGPXBdHA8WKTGMextu0iPIUJZ4I+2TbKxqdix7XbU4R3Fu7Pn9D8VLJDUXcIiSOjBnovDzqe8TUon8hK02OsU5ILV1sHkmq0lpBwbmMKrg8kc4caohmnG+dMmt7yf4uJs9+w/nO+bTlWYtOFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770057977; c=relaxed/simple;
	bh=3Bb3GA58D7DLWusn0/jAKceagn2uKDar4xbNlnWV1tE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/f2Mt9n905YjPRSHDS7ZaG+ZY/HldPPA5KO3F3fpytX0EnZDoXLWln2GudQiKL7Vqg9a3SGkFbQRnv/Ah9l+Ku6DI54JbjC1UxZ9DrgPOnB3lljRAAGQHYPVLCebyUpd0XFrU4ecg4YLwM2qS8Q/P8AV0iX/yo/2/eg3oBxwIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4bCV0H9xzJ467X;
	Tue,  3 Feb 2026 02:45:26 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 30AC040565;
	Tue,  3 Feb 2026 02:46:12 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 18:46:11 +0000
Date: Mon, 2 Feb 2026 18:46:09 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>, David
 Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Andrew
 Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
Message-ID: <20260202184609.00004a02@huawei.com>
In-Reply-To: <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-3-gourry@gourry.net>
	<20260202172524.00000c6d@huawei.com>
	<aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Mon, 2 Feb 2026 13:02:10 -0500
Gregory Price <gourry@gourry.net> wrote:

> On Mon, Feb 02, 2026 at 05:25:24PM +0000, Jonathan Cameron wrote:
> > On Thu, 29 Jan 2026 16:04:35 -0500
> > Gregory Price <gourry@gourry.net> wrote:
> >   
> > > Enable dax kmem driver to select how to online the memory rather than
> > > implicitly depending on the system default.  This will allow users of
> > > dax to plumb through a preferred auto-online policy for their region.
> > > 
> > > Refactor and new interface:
> > > Add __add_memory_driver_managed() which accepts an explicit online_type
> > > and export mhp_get_default_online_type() so callers can pass it when
> > > they want the default behavior.  
> > 
> > Hi Gregory,
> > 
> > I think maybe I'd have left the export for the first user outside of
> > memory_hotplug.c. Not particularly important however.
> > 
> > Maybe talk about why a caller of __add_memory_driver_managed() might want
> > the default?  Feels like that's for the people who don't...
> >  
> 
> Less about why they want the default, more about maintaining backward
> compatibility.
> 
> In the cxl driver, Ben pointed out something that made me realize we can
> change `region/bind()` to actually use the new `sysram/bind` path by
> just adding a one line `sysram_regionN->online_type = default()`
> 
> I can add this detail to the changelog.
> 
> > 
> > Other comments are mostly about using a named enum. I'm not sure
> > if there is some existing reason why that doesn't work?  -Errno pushed through
> > this variable or anything like that?
> >   
> 
> I can add a cleanup-patch prior to use the enum, but i don't think this
> actually enables the compiler to do anything new at the moment?

Good point. More coffee needed (or sleep)

It lets sparse do some checking, but sadly only for wrong enum assignment.
(Gcc has -Wenum-conversion as well which I think is effectively the same)
I.e. you can't assign a value from a different enum without casting.

It can't do anything if people just pass in an out of range int.

> 
> An enum just resolves to an int, and setting `enum thing val = -1` when
> the enum definition doesn't include -1 doesn't actually fire any errors
> (at least IIRC - maybe i'm just wrong). Same with
> 
>    function(enum) -> function(-1) wouldn't fire a compilation error
> 
> It might actually be worth adding `MMOP_NOT_CONFIGURED = -1` so that the
> cxl-sysram driver can set this explicitly rather than just setting -1
> as an implicit version of this - but then why would memory_hotplug.c
> ever want to expose a NOT_CONFIGURED option lol.
> 
> So, yeah, the enum looks nicer, but not sure how much it buys us beyond
> that.
> 
> > It's a little odd to add nice kernel-doc formatted documentation
> > when the non __ variant has free form docs.  Maybe tidy that up first
> > if we want to go kernel-doc in this file?  (I'm in favor, but no idea
> > on general feelings...)
> >  
> 
> ack.  Can add some more cleanups early in the series.
> 
> > > +	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)  
> > 
> > This is where using an enum would help compiler know what is going on
> > and maybe warn if anyone writes something that isn't defined.
> >  
> 
> I think you still have to sanity check this, but maybe the code looks
> cleaner, so will do. 

I'm in two minds about this. If it's an enum and someone writes an int
I take take the view it's not our problem that they shot themselves in
the foot.  Maybe we should be paranoid...

J


> 
> ~Gregory
> 

