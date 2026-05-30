Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA3946B5
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780099479; cv=none; b=i9UeD1URvweue1MNwL3Q5QFhVZrAnMoXv3tRLCLP+LqnoHxb20Cb873bQSaZ5eByeNPCYrHQTAoptDagzEKj/S/NVBuYZBUdD+4+dBs/iNbbbf91F4r2l31upFereeUIab/ExTQRE9uRsu83ea4hX/hKQeqJyyRRg5ggHBqvrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780099479; c=relaxed/simple;
	bh=W+eSIK2s1c9SlFH0SBZ70mCj0LzhyiVL/pvn+0kKIiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nG+Xf0Y87keMyYihm7t9Osdlws+lRoHYav+yJe+mbPpljKcKcvyT2JPJbow9d2CK6DCOHR9MdAgLtquS1TSQ9KWtTWmlphCFExErATBTKgPHkLlykH24G/n4QSRebKWfXuBhgwVf3J7A7xGqEWec5K+Q82GaoHSgJz+QrSVAvV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF018C0680;
	Sat, 30 May 2026 00:04:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf03.hostedemail.com (Postfix) with ESMTPA id DB7D06000B;
	Sat, 30 May 2026 00:04:31 +0000 (UTC)
Date: Fri, 29 May 2026 19:04:30 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 3/7] dax/fsdev: fix kaddr for multi-range and fail
 probe on invalid pgmap offset
Message-ID: <ahopdHYhO2x9E5-_@groves.net>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191859.79167-1-john@jagalactic.com>
 <0100019e51208026-d62e0ffa-73d4-4cac-b950-dbbbb13ab38c-000000@email.amazonses.com>
 <1aa37178-4d36-4a4c-8b36-bf2789ce9655@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aa37178-4d36-4a4c-8b36-bf2789ce9655@intel.com>
X-Stat-Signature: fktne5rgu9jqyndra1htdmubhsxhofiy
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: DB7D06000B
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18uDUuCppJvPq2aWc5YSXzIQdPFIXrOEYs=
X-HE-Tag: 1780099471-924468
X-HE-Meta: U2FsdGVkX19MRAxqPWBREwjd+kVfmw7Ed45/YJU/VxhqGuNHyl7/ejBlhm+GvPp2lJGB3NfLaY9rCV6Vbv1pWXGw9jqZ/z6mwmW8C3bGm1f2QHeyde4wAFOMBZOGEUMWzJUFH0yzVbGRhWLTdNVp9BBtq2A/IAcQr8GadHZNNoeviW7A8lI0Ya81wFA0faLMTvrhD+r1KUWImPgXkODJkYoP8qySnhrZj468Od6wEzqZiOS5ATbdgoeUqlyIUXhCeBwCjmGIzjRQxFyKrlfCWgI0BFqDaaeu/oJRXu6bDn1CAYjKTXvNtVTN45weZjGEJkkXGGCOW1MI9yM2zUyGJAegCKZnAx/2aYj7axLW20I7IVZdxGZPd8uaX/vf4GU9

On 26/05/26 04:31PM, Dave Jiang wrote:
> 
> 
> On 5/22/26 12:19 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > Two fixes for virtual address handling in fsdev:
> > 
> > 1. Use __va(phys) instead of virt_addr + linear_offset for the kaddr
> >    return in __fsdev_dax_direct_access(). The previous code added a
> >    device-linear byte offset to virt_addr (which is __va of ranges[0]),
> >    but for multi-range devices with physical gaps between ranges, this
> >    linear arithmetic crosses the gap and produces a wrong kernel virtual
> >    address. Using __va(phys) where phys comes from dax_pgoff_to_phys()
> >    is correct for any range layout because the direct map translates
> >    each physical address independently.
> > 
> > 2. Convert the WARN_ON to a fatal error when pgmap_phys > phys. This
> >    condition means the remapped region starts after the device's data
> >    region, which is an impossible state. Previously the probe continued
> >    with data_offset=0, leaving virt_addr silently misaligned. Now probe
> >    returns -EINVAL with a diagnostic message.
> 
> Split to 2 different patches I'd say.
> 
> DJ

Agree - done. Thanks!

John

<snip>

