Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE18168
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641595285; x=1673131285;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vU+VQTJZcneIj0AHn0ZBZd38i7/hK46ZCtk+FENkkMQ=;
  b=AkMAcP4fkz6WtvGNl/P0JlOEuKPKEPGy71VE0Sb8/IyAUDDZU/4emy5R
   0DCKBU0BzTLcuzXmVUil2vtipfUW/zrTh/8fLzFOe3HCcLGit7rWw2Wa3
   wsSlpBWTINo1lHVCVMrKithZO4ELWl2E2qUG38QZyirJweMSks3CuEaPB
   jS3ZZCTiHAXUCyEutP4RyUq5Pteggozblu/vNv/9iSA8AU2AU81CrKW4y
   nAFwVcMWspTnQx7XXGH5oi/SHUQYOKHU2AuYSoYevQVNPDRt/4JJpGV4t
   rfPR2o99AcgxGYGJQt776taU6WAzupm0iuXi/AzzYe0zQSZVmkbvzx6BB
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="267260454"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="267260454"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:41:25 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="591839729"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:41:24 -0800
Date: Fri, 7 Jan 2022 14:46:34 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
Message-ID: <20220107224634.GB804232@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
 <CAPcyv4iPJb8AGOcgW5ncid2GTtft5UzxmXWD4U8bNn1JCCMaLA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iPJb8AGOcgW5ncid2GTtft5UzxmXWD4U8bNn1JCCMaLA@mail.gmail.com>

On Thu, Jan 06, 2022 at 01:35:03PM -0800, Dan Williams wrote:
> On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
> >
> >         unsigned offset;
> >         bool verbose;
> > +       unsigned long long volatile_size;
> 
> This should be a string.
> 
> See parse_size64() that handles suffixes like K,M,G,T, so you can do
> things like "cxl set-partition -s 256M" and behave like the other
> "--size" options in ndctl.

Got it. Thanks! This will fix a couple of pesky UI things I was
worried about.
