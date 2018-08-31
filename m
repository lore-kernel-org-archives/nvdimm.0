Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8DF521106F31
 for <linux-nvdimm@lists.01.org>; Fri, 31 Aug 2018 01:00:51 -0700 (PDT)
Date: Sat, 1 Sep 2018 00:39:42 +0800
From: Yi Zhang <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH V4 4/4] kvm: add a check if pfn is from NVDIMM pmem.
Message-ID: <20180831163941.GA1220@tiger-server>
References: <cover.1534934405.git.yi.z.zhang@linux.intel.com>
 <a4183c0f0adfb6d123599dd306062fd193e83f5a.1534934405.git.yi.z.zhang@linux.intel.com>
 <4192066a-79f3-2b3e-386f-c4ec9b6dd8fd@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4192066a-79f3-2b3e-386f-c4ec9b6dd8fd@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: jglisse@redhat.com, yu.c.zhang@intel.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, jack@suse.cz, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, rkrcmar@redhat.com, pbonzini@redhat.com, hch@lst.de, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 2018-08-30 at 12:07:11 -0700, Dave Hansen wrote:
> On 08/22/2018 03:58 AM, Zhang Yi wrote:
> >  bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> >  {
> > -	if (pfn_valid(pfn))
> > -		return PageReserved(pfn_to_page(pfn));
> > +	struct page *page;
> > +
> > +	if (pfn_valid(pfn)) {
> > +		page = pfn_to_page(pfn);
> > +		return PageReserved(page) && !is_dax_page(page);
> > +	}
> 
> This is in desperate need of commenting about what it is doing and why.
> 
> The changelog alone doesn't cut it.
Thanks, Dave, Will add some comments
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
