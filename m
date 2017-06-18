Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0BAE21A07AA1
 for <linux-nvdimm@lists.01.org>; Sun, 18 Jun 2017 01:35:43 -0700 (PDT)
Date: Sun, 18 Jun 2017 10:37:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 02/14] dm: add ->copy_from_iter() dax operation support
Message-ID: <20170618083702.GB26456@lst.de>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> +size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> +		size_t bytes, struct iov_iter *i)
> +{
> +	if (!dax_alive(dax_dev))
> +		return 0;
> +
> +	if (!dax_dev->ops->copy_from_iter)
> +		return copy_from_iter(addr, bytes, i);
> +	return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
> +}
> +EXPORT_SYMBOL_GPL(dax_copy_from_iter);

Can you remove the fallbacks after this series so that we have
a clean abstraction? 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
