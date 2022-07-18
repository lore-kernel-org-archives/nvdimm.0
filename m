Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B63D96
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658180275; x=1689716275;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4MDpTNrZVOEj5WSRtU1vgmEx0jrQ6p/FbPvAvILaUFE=;
  b=eoh6NASQ3bq4r1ptmw8uCxuEcJ/KmDQTmSFxJf2httE4gJvg27pL2+S5
   LodLDfOEtJSzJOXv5eQH8GbtPbCHz3bCmnvJgyKMsI6rZR4Jdzuce1Jwf
   TTyZoG6v6q7hAG71IXQXjtil+w+K8spSk7ClUL4XXeBiT3b8DWWVVsHLY
   z3SuKUKPyIQb4Ac1Dep2qql4FVIIkw8K5f3k5wvFiNbWiIBrrlRENzpKL
   Nwv3qvoycJzn1XnL/d0nsaKOS3cvRHMXuD7kf/PFbyMBdq9TSWGQoXOSv
   HMuIGUFAQpxtzJTiVD2wdIJg53tMNO1p1lGL6Nhuj0n9Uec/btEWyRscU
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287476041"
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="287476041"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:37:54 -0700
X-IronPort-AV: E=Sophos;i="5.92,282,1650956400"; 
   d="scan'208";a="572578880"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 14:37:54 -0700
Date: Mon, 18 Jul 2022 14:37:53 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Jane Chu <jane.chu@oracle.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v3] x86/mce: retrieve poison range from hardware
Message-ID: <YtXSsUmh5XcVXGa3@agluck-desk3.sc.intel.com>
References: <20220717234805.1084386-1-jane.chu@oracle.com>
 <41db4a4b17a848798e487a058a2bc237@intel.com>
 <62d5b13b2cf1a_9291929433@dwillia2-xfh.jf.intel.com.notmuch>
 <797a2b64ed0949b6905b3c3e8f049a23@intel.com>
 <5a92e418-9f50-8212-92a0-4ac39cefa9ef@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a92e418-9f50-8212-92a0-4ac39cefa9ef@oracle.com>

On Mon, Jul 18, 2022 at 09:11:33PM +0000, Jane Chu wrote:
> On 7/18/2022 12:22 PM, Luck, Tony wrote:
> >> It appears the kernel is trusting that ->physical_addr_mask is non-zero
> >> in other paths. So this is at least equally broken in the presence of a
> >> broken BIOS. The impact is potentially larger though with this change,
> >> so it might be a good follow-on patch to make sure that
> >> ->physical_addr_mask gets fixed up to a minimum mask value.
> > 
> > Agreed. Separate patch to sanitize early, so other kernel code can just use it.
> > 
> 
> Is it possible that with
>    if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> the ->physical_addr_mask is still untrustworthy?

The validation_bits just show which fields the BIOS *says* it filled in.
If a validation bit isn't set, then Linux should certainly ignore that
field. But if it is set, then Linux needs to decide whether to use the
value, or do a sanity check first.

-Tony
