Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34D18DB26;
	Tue,  4 Aug 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785802415; cv=none; b=TqONyZ7LTlrHBYGe+A/NrRRJHTPOUV16o67KRRF5a8ydPz6Zn9NHzeXCGPzireVZJ170zJ29QzpZ3XopLgoOZJLegnZNyOVbgsffiNW7wq8YorOiMLVxmjwe0DnrlvCxLbCj6qwz4fhFi9//ExA0APHBHufUecdrxNEYeeSG6eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785802415; c=relaxed/simple;
	bh=LVvwzAxoeA9y9gu+rMsJp8MwfarmxHRsSeYc5E5NLZY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMk/++wfFvK5t8lTWlTygby0Z2TS2h09FJhdkIbY95bU+/wWCltRtT1izaJQwyPs2v7neQXBBTUrjijDxp00naFxTenwRJVH8xQGK/YtRWp3xE5nmiRSAcnNNQ4XZ6nwvG0fM3eNrp2pEC8ASoc/0PO+T4jYewxTrk+XSMCYhzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOst+A03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOst+A03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E94D1F000E9;
	Tue,  4 Aug 2026 00:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785802414;
	bh=7JHwMfjOpQvaVjjYGFkJzgOOoPx3jLqdBox8rnHydJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jOst+A03pQ8cDK6mxmC9BWuL+u8fSjpIHs7W8CayNs5WCPxGcRk9mETkGAm7hYSch
	 kbOpqOFLW4zwfi8sCXP+u9x45hwG4XcLi8fBskjxxiNAt0nbbvRe26T84kEFnROzZt
	 PbZTrtO2/IDBJIXc6VBHjDSwFLrLkFTNpdYpwfU9CF/mpt+YJz3FmHW25egbWGuw2/
	 O+Fd2YudQqypVq2/69ev6c3xcw6ilEWM5gb2/5BMj/ZYnhtGq1IEcBfozF3pcIDdQd
	 32lpRthB9DCKAhP8tC+HGgIHlbzjHst6O0/okdFw3zyik+wquNwh7PCEXeHdQMWFI7
	 EAXFweTDYGCdA==
Date: Tue, 4 Aug 2026 01:13:26 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li
 Ming <ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>, Wonjae Lee
 <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, Heesoo Kim
 <habil.kim@samsung.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <20260804011326.73a2b4df@jic23-huawei>
In-Reply-To: <20260731084901.1512819-7-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-7-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 01:48:11 -0700
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism.  The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications.  Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity.  Disable DCD if interrupts are not supported.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
