Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D7B37F309;
	Mon, 12 Oct 2026 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813916; cv=none; b=PnhJfBJknPKfuO7Ry9v1n96oTVbytNRcuIKA4NLGEcG+5NIsZG5X8phhW6F56C9WhxQeEhArTvO5lqS27fAN8hqRSvoRa5DD0j0XIGtqQ0j974vRyA9hMQcxaOFeboVgyIOlHBFEsu38+nCtanhqIPTBWajcQtm2iTc0UXoV8fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813916; c=relaxed/simple;
	bh=ED2Y8CwDnbtBCBoFbrQlGnD4Obzmmj3aB2Xr5tN4tHc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8X8r+xe7yQUAvEZ10hTn7y4j/cRQYhtmfxNPq8OxtoaQt0MMRJN82UHYzZcZ2h2dc1Lzt9tdkMr+pCfS3So3VyZ43mDR6vb4OalKmFix+FTYYH5fLYbtoTPrVFOIAoVXIuI86QWrmH52x5d/V9Arr1e99NO5IAtkdMnsARrNSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdDGtWhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdDGtWhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB531F0089B;
	Mon, 12 Oct 2026 14:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813914;
	bh=DQHXILWvo5otRdBkHU5iESWga9h9AYc+zF325KqNvok=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hdDGtWhqRw11D0f01qtaluZ2GiUw4a8Zxin/ue8oYrkHKNvDrzRZSmCwjqhuSJ+9g
	 8aQodHGTkGWoKny7oDgOoSDipXeNDzgiWzxtylhsnJieKzP7b6z/VnPZxIpSeYV90N
	 TIKfD5xByScUmM1dNGJDIrGB5mcD4cNrEvSfNEo/y21/0C+YdS+gAxuM2stTauSazR
	 Uy/CxfLkKX25WcynR1bObv03Ev/vp5hz/1zhyc4fpRBRZYdDV2ribCrdCKyFhajadB
	 8/eaMZcbiyYDKeqB08ICzX4t+t4OuhWTudNowEMpzHemQGijT7x2/9WY121V9VVf0a
	 G1E+wY3356prw==
Date: Mon, 12 Oct 2026 15:05:00 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v16 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <20261012150500.03884761@jic23-hlaptop>
In-Reply-To: <20261010225852.10727-7-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
	<20261010225852.10727-7-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 07:54:57 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism. The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications. Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity. Disable DCD if interrupts are not supported.
> 
> The DCD event log is not drained here. cxl_event_drain_mask() reports
> only the logs the driver can service, and the DCD bit is added by
> the patch introducing DCD event handling. Until then a DCD interrupt
> wakes the event thread, which finds no log it owns and returns.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 

One really minor thing below. Up to you on whether you change
it even if you do respin!

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>


>  static bool cxl_event_int_is_fw(u8 setting)
>  {
>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> @@ -651,46 +721,90 @@ static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };

Trivial but in earlier patch you used {}; for the bitmap.
They are equivalent (with modern compilers + the options the kernel uses)
but consistency would nice if you do respin.  Not major enough to justify
doing that though! I think we already have a mix in CXL so this isn't
really making it worse.

Jonathan

> +	bool native_cxl = host_bridge->native_cxl_error;
