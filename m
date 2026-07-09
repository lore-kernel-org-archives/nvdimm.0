Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C253C10AE
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783633604; cv=none; b=WQQwcXpA9yDB7G04NjUOthEA1Pe5SusX+cWzaQAG61zoDzck+LAwH2P/y6Pf1tzAyCW3cHHOEhyqeGl0rdWUmymv6SgcqK7gzQP80245EvhiheNktNMKpuchFUS3z5IaGoUKjJ9AfNsRGnqjNaLPu32PEePyCncnXRKg+Eo2cPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783633604; c=relaxed/simple;
	bh=+HUMhj2jNwddM2JyOEMYiYL+KJDhiLET5Lh+METKU8M=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=kwuQmv3T2G6Bsbg11R1mBhXuTgtDbp3Vs2aN7ayVzSWn9/R7Rd/W4SU8BX/pOPsbSst+7IVqir6oLzvqG/gazMRFbA+MXDtYUOm1BuOL2+fbNC5H3mTmIFOXQRnfpWTGmCuQ0l3LNfUHzxcfFtSYxj7JiEv8ZqFt1WW25h0N+F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVKnh4K7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVKnh4K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A0A1F000E9;
	Thu,  9 Jul 2026 21:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783633602;
	bh=xvUpE9WcYp8vTdTGEYoEnE1EtejEUIbK/UADepyuNY0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iVKnh4K7ybLEzV7Rvctk0w0CuSaR2MOl8/3BZm6M0v7bnOxOMambRqn1EKITgQWFW
	 7gN8gNVAyYGj33OEgKV/PPPabOSUCb8o0ss0+Zb0JTjZsPHKeFNvRksMG414Uk7K9s
	 QvUUCEqM4904/do3Y67NO0UxVFZStOFTkvaNIrkh0qSLpd7whmzIF/EGeOW7Fg+C3U
	 2bGg1fR0VVCOqSrw8UrQQgDWOICdQvgnCyxQXdOSDTvUxKsjfu3rqrUr4nlhrv6mkq
	 2f5l7HVJ/UpB3iw1O8LMn2HcQZpPtcFOVzw6KQAnzZMN6RSP/dgSFESeZy9RalaJYM
	 d4sYXgeSH+RWw==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 36203F40074;
	Thu,  9 Jul 2026 17:46:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 09 Jul 2026 17:46:41 -0400
X-ME-Sender: <xms:wRZQatvFWtrTwr1EjET3SY_trkFv5ByXFvxwuRdoxp5nZNvdH5owQg>
    <xme:wRZQamngVETnvwD8NBa-XtvQpVx4724Zay6MVM63n_6ymuey3wfOgySL08LLsooog
    UX-chX-4R6sELh15ZgWdlWqPRhtWCNR2SS_SccjFUcsJISlBQW0Jg>
X-ME-Received: <xmr:wRZQaulAZEPtxDDKpaH_YbkptlPFAMbWXlA7EE85RV-Ons1W6zy6jsk9pC4kEn3uk7t8zBNGPLJp6Q5UyrA4U-G2iQ6f_GlG3-g>
X-ME-Proxy-Cause: dmFkZTE6pGaGaXtiuJOhuGCWlZoBx9j2X3a8VM6fEMYo0GgLn9Toq0lK5LM0v7iRTsbBsV
    qlrEvEtCLS1HyECWCw3IhgieUQHf/LHM2k0r319GerFiWVnYyf1YK+sX/8GKpHbeEDkqtn
    HDG3mhPN5PblOtwUozJ//wR1tQjsfmPDOvoxX5Te1glFqzecABmTR2Zh8nu80wxuLaB9Zq
    2zHMg9W+crhZwO/iasCAkbhbQkiZL/DfjYQadxfklfe3HABtE+ynOGyGbRkgDasbfKe5xO
    VfWC4UbTVVlwtY8KKGNtYMIYw9XkDx/17fWR9Y/a3y7cL3gnrzhViVaOvAGjNANzJ0ugdZ
    5PhTVw9Ns0QhhLKD1lQlPKK1qDIBABInureQW4ET1HapHww8srucCfs+rrvwAVPVpc1PfA
    HYIcCN+U+A5av5qS7mt9cziBggX16xCsoo8ISOQX2m5s/bLHlIFqjSrysZbJ3A8UTjLlcH
    L3uk/yJObKMM5E62Z1vetG3TPwFWzYElHlH/N7CdygvxX0xaTfR0R+ijFpTgtO+dGDZyAd
    yJMUKn+V4nGoInZb4lgPPMBhn6Bw9ObzrTWFW1dVXsVErLJiF5Kp789djPKp0Plu417fRL
    ltx20K8SztGbd39K8VVdFQHFiete1nLG1dIxa8J8RKKm0TJR3JNksl1/9+3w
X-ME-Proxy: <xmx:wRZQaoc4wjzaNgvryg5NN70-1Vatf2xzep1RWYAbyMMVv1jU6GuGUw>
    <xmx:wRZQasIJCeYXn13SMsIuUbkJJctlWeYlyIgEnBRLtc4d-vVKYSLz2g>
    <xmx:wRZQaj5n-_r_R1jtCcxgv8VUDHEvYWm-UIKRMsfxYAmrfmcJ5P0Ibg>
    <xmx:wRZQarTPZpDwzCgul_GWo1SBKOdkWO7HWCqep__MKJzfdeGX2A3UtA>
    <xmx:wRZQajsp5WUuI2CXr6WdWNwkXcx1AADWI-zKxT0Fq1uz1hG6ukfLy3xS>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 17:46:40 -0400 (EDT)
Date: Thu, 09 Jul 2026 14:46:39 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: Gregory Price <gourry@gourry.net>, 
 linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com, 
 david@kernel.org, 
 osalvador@suse.de, 
 gregkh@linuxfoundation.org, 
 rafael@kernel.org, 
 dakr@kernel.org, 
 djbw@kernel.org, 
 vishal.l.verma@intel.com, 
 dave.jiang@intel.com, 
 alison.schofield@intel.com, 
 akpm@linux-foundation.org, 
 ljs@kernel.org, 
 liam@infradead.org, 
 vbabka@kernel.org, 
 rppt@kernel.org, 
 surenb@google.com, 
 mhocko@suse.com, 
 shuah@kernel.org, 
 gourry@gourry.net, 
 iweiny@kernel.org, 
 Smita.KoralahalliChannabasappa@amd.com, 
 apopple@nvidia.com
Message-ID: <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
In-Reply-To: <20260630211842.2252800-8-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Capturing the system default would otherwise break the ABI, because
> the system default can change - but we would be statically assigning
> the value at device creation time.
> 
> To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> the current behavior, while providing a clean way to override it.
> 
> No behavioural change for existing callers (still the system default).

So I know you have some future usage for this ability, but it is not
present in this set. The only piece that *is* used is that the
online-type from the new sysfs interface gets plumbed through to
__add_memory_driver_managed().

Are these touches:

>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/hmem/hmem.c   |  1 +
>  drivers/dax/pmem.c        |  1 +

...premature until the first user arrives that with the background story
about how it knows to set the policy?

If DAX_ONLINE_DEFAULT is a sentinel for "default" should
DAX_KMEM_UNPLUGGED be a different sentinel than (-1)?

Feel free to add:

Reviewed-by: Dan Williams <djbw@kernel.org>

...to this and the previous patches when that is fixed up.
