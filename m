Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 30 Sep 2015 17:40:49 -0400
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] devm: make allocations numa aware by default
Message-ID: <20150930214049.GH2627@mtj.duckdns.org>
References: <20150926011243.2848.82422.stgit@dwillia2-desk3.jf.intel.com>
 <20150926011742.2848.89427.stgit@dwillia2-desk3.jf.intel.com>
 <CAPcyv4hzefF90mxm9yOCmKcDxFc_Wz_BcH3b14Mi5W-vt0gi9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hzefF90mxm9yOCmKcDxFc_Wz_BcH3b14Mi5W-vt0gi9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 29, 2015 at 05:30:26PM -0700, Dan Williams wrote:
> Hi Tejun, any thoughts on this, or concerns about globally enabling
> numa hints for devm allocations?

Looks good to me.  Please feel free to add

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
