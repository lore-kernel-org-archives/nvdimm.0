Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C079811E2
	for <nvdimm@lists.linux.dev>; Mon, 26 Aug 2024 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724702656; cv=none; b=KYeotC1n1ro+J9hq8AlP4gNmgLxydNsPVqf3SAZEVNiDXiMWcZbKudN93gap8RKQH//3eazVdBUDI0tBf7j0CnCieSgPWfpIJ+nrW9loR6sD7GbL9pLSRhRCo/9oXWS3zvxMcNYZ4ILhiNw/1eZzptB6OqcwUn7TZpOnya1yf7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724702656; c=relaxed/simple;
	bh=B2SgICr1DtC5S04KOZv7RNG3dcyhxKW67FSmHRsY/Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9SJ8zr9KdFnjKZksSK3+ooY/rMtaanpsQvVDkiRaG5ayJiey6Q8KVIORvsOTfBbjs1x8fpq70j7QZ6ICkcIYUq5X07Nt6F0J0Fi/GX+Lv+4ad8SX5bHAcsKIE5cvUuGlmCad2LCHcpE/wwHOtTHJYq2HRkJdER+D1Mx6xoIwzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kDS4z3av; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kDS4z3av"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724702654; x=1756238654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B2SgICr1DtC5S04KOZv7RNG3dcyhxKW67FSmHRsY/Ow=;
  b=kDS4z3av65Ud4K1qJG3l1lJoGjlx/iKklFQojrOTkFsL5u5wBSaZKCU6
   EaZW6hHiBEDnJEN91ZM0F+Ep6hfuQToCTN4tRNVBR1B6ipgc1W056ZeYi
   otI5cAUmp+il6xgASVJ1dB1eIzDiAQZ5thDUYlX2p6ujqRLMUrXN3Y8t/
   5970SznUvsnFNV1BVveKEhCC4wlbUC/xBa4JGUDrmh4Sx4XbAilxBgP5n
   1xas95RYbfNF1KV6lr5zJG/DAPCuvW0ubnV1GveWv+X/EW8KHXkvAX0gK
   615sMk8t2RNocVPUxG8mFdnTs+rJpCIZaAcbiuU2svsdkvpszt+g4Zv5i
   g==;
X-CSE-ConnectionGUID: EcM/hgvgRBaMou+iIAafnQ==
X-CSE-MsgGUID: 8KetPWehTUyTmN3kjoOtwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23304845"
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="23304845"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 13:04:14 -0700
X-CSE-ConnectionGUID: BTjInYYQSVWAgrEyX8hyhA==
X-CSE-MsgGUID: rA8dqDiLTa2Uspn1YtiZmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="62604446"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 13:04:12 -0700
Date: Mon, 26 Aug 2024 13:04:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Fan Ni <fan.ni@samsung.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v3 1/2] daxctl: Fail create-device if extra
 parameters are present
Message-ID: <Zszfukri8-pGOGNN@aschofie-mobl2.lan>
References: <20240606035149.1030610-1-lizhijian@fujitsu.com>
 <44be9d98-1e34-469e-b76c-5ed65e4e49b0@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44be9d98-1e34-469e-b76c-5ed65e4e49b0@fujitsu.com>

On Thu, Aug 22, 2024 at 08:28:17AM +0000, Zhijian Li (Fujitsu) wrote:
> 
> Ping, I think these 2 patches should be included into v80

Thanks for the reminder. I've queued them for v80 here:
https://github.com/pmem/ndctl/tree/pending

--Alison

> 
> 
> 
> On 06/06/2024 11:51, Li Zhijian wrote:
> > Previously, an incorrect index(1) for create-device is causing the 1st
> > extra parameter to be ignored, which is wrong. For example:
> > $ daxctl create-device region0
> > [
> >    {
> >      "chardev":"dax0.1",
> >      "size":268435456,
> >      "target_node":1,
> >      "align":2097152,
> >      "mode":"devdax"
> >    }
> > ]
> > created 1 device
> > 
> > where above user would want to specify '-r region0'.
> > 
> > Check extra parameters starting from index 0 to ensure no extra parameters
> > are specified for create-device.
> > 
> > Cc: Fan Ni <fan.ni@samsung.com>
> > Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> > Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> > V3:
> >    - Fix commit message and move the 'i' setting near the usage # Alison
> >    - collect reviewed tags, no logical changes.
> > 
> > V2:
> > Remove the external link[0] in case it get disappeared in the future.
> > [0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram
> > Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> > ---
> >   daxctl/device.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/daxctl/device.c b/daxctl/device.c
> > index 839134301409..6ea91eb45315 100644
> > --- a/daxctl/device.c
> > +++ b/daxctl/device.c
> > @@ -402,7 +402,10 @@ static const char *parse_device_options(int argc, const char **argv,
> >   			action_string);
> >   		rc = -EINVAL;
> >   	}
> > -	for (i = 1; i < argc; i++) {
> > +
> > +	/* ACTION_CREATE expects 0 parameters */
> > +	i = action == ACTION_CREATE ? 0 : 1;
> > +	for (; i < argc; i++) {
> >   		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
> >   		rc = -EINVAL;
> >   	}
