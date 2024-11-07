Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CDE1F8932
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730978999; cv=none; b=VJd2N3hV08L7lXQnUiRtCougmMhgkk5kVYSJ5G8t0b/+GS+wlmi0FFkGg7GEC1y4VGUHm9j18KRf7qdQ4W+AOvkNWg2n9OZ1rHIyAdBGq9v48NE8jKA+F0ClDo3jgPuATdMzuIOPF9aYVi78hx9bfU0worJ8m0qxusD0d95PJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730978999; c=relaxed/simple;
	bh=xj7Kavv7JMaQJGhBu/e09GscaMomEYRc0o8Oyg59+TM=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K59BTR68gjN7xMy1/gYZCEhmYUH1UrIaNcIuJQcNqyEFJoAFcLeMOtOdE4uC5zaAhRMZPof55JbGde1Lm8Kpm5b5Ex5lRdiCD9Ydzmu8PVRMIDzuTD23vGv8fLyQktuO++Ig4wlRP2NoFu3rJwvFhV4oHjmuS0VXlZiSFmlp8us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XkfxS5PTcz6LD8b;
	Thu,  7 Nov 2024 19:29:48 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D3F81400DD;
	Thu,  7 Nov 2024 19:29:52 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 7 Nov
 2024 12:29:51 +0100
Date: Thu, 7 Nov 2024 11:29:50 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Navneet
 Singh" <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, "Alison Schofield"
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
	<linux-cxl@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 20/27] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <20241107112950.00000384@Huawei.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-20-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
	<20241105-dcd-type2-upstream-v6-20-85c7fa2140fe@intel.com>
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
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 05 Nov 2024 12:38:42 -0600
ira.weiny@intel.com wrote:

> From: Navneet Singh <navneet.singh@intel.com>
> 
> A dynamic capacity device (DCD) sends events to signal the host for
> changes in the availability of Dynamic Capacity (DC) memory.  These
> events contain extents describing a DPA range and meta data for memory
> to be added or removed.  Events may be sent from the device at any time.
> 
> Three types of events can be signaled, Add, Release, and Force Release.
> 
> On add, the host may accept or reject the memory being offered.  If no
> region exists, or the extent is invalid, the extent should be rejected.
> Add extent events may be grouped by a 'more' bit which indicates those
> extents should be processed as a group.
> 
> On remove, the host can delay the response until the host is safely not
> using the memory.  If no region exists the release can be sent
> immediately.  The host may also release extents (or partial extents) at
> any time.  Thus the 'more' bit grouping of release events is of less
> value and can be ignored in favor of sending multiple release capacity
> responses for groups of release events.
> 
> Force removal is intended as a mechanism between the FM and the device
> and intended only when the host is unresponsive, out of sync, or
> otherwise broken.  Purposely ignore force removal events.
> 
> Regions are made up of one or more devices which may be surfacing memory
> to the host.  Once all devices in a region have surfaced an extent the
> region can expose a corresponding extent for the user to consume.
> Without interleaving a device extent forms a 1:1 relationship with the
> region extent.  Immediately surface a region extent upon getting a
> device extent.
> 
> Per the specification the device is allowed to offer or remove extents
> at any time.  However, anticipated use cases can expect extents to be
> offered, accepted, and removed in well defined chunks.
> 
> Simplify extent tracking with the following restrictions.
> 
> 	1) Flag for removal any extent which overlaps a requested
> 	   release range.
> 	2) Refuse the offer of extents which overlap already accepted
> 	   memory ranges.
> 	3) Accept again a range which has already been accepted by the
> 	   host.  Eating duplicates serves three purposes.  First, this
> 	   simplifies the code if the device should get out of sync with
> 	   the host.  And it should be safe to acknowledge the extent
> 	   again.  Second, this simplifies the code to process existing
> 	   extents if the extent list should change while the extent
> 	   list is being read.  Third, duplicates for a given region
> 	   which are seen during a race between the hardware surfacing
> 	   an extent and the cxl dax driver scanning for existing
> 	   extents will be ignored.
> 
> 	   NOTE: Processing existing extents is done in a later patch.
> 
> Management of the region extent devices must be synchronized with
> potential uses of the memory within the DAX layer.  Create region extent
> devices as children of the cxl_dax_region device such that the DAX
> region driver can co-drive them and synchronize with the DAX layer.
> Synchronization and management is handled in a subsequent patch.
> 
> Tag support within the DAX layer is not yet supported.  To maintain
> compatibility legacy DAX/region processing only tags with a value of 0
> are allowed.  This defines existing DAX devices as having a 0 tag which
> makes the most logical sense as a default.
> 
> Process DCD events and create region devices.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
I gave this on v5, but meh here it is again (obviously subject to
Li Ming's fix which maybe can just get rolled in whilst applying)

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


