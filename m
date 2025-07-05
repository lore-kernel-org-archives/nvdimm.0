Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C591B4248
	for <nvdimm@lists.linux.dev>; Sat,  5 Jul 2025 22:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751756188; cv=none; b=nXB2DWSPHZoAo9bjnggiebla9DXhpJRDy758TdiwHlabUoDUECfFonVgTFP2TdqYB7K4gSCIqi1JpfYs9lMYJcb5Aud8WIleSuGEHB5gJYfoK8B4UG28P+XD6MkA2IEJoGOC8Qa4nLLLV5XjuYL9wQSc/Wwgv7EJ4EzXg+P2two=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751756188; c=relaxed/simple;
	bh=a3i4jRGxXCB5XfKRUE99TThgc+EDm/z2Y0g4eZ2mpP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X91hsXTKGdnxrpGBGIGrGDPxsZ43kudULpCrtRNmOZrQixRG+v1ysiFCfQNht62cUMtIOdazzAlLqZFD1itt4j48VSCK1824j+JklU4C4O/vWglJVPuV+m6VHIn7dbSAFhgZJ4iX5TIleBIHaBM1P4+trefTj4mEKycDXSQSfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+HE9kqn; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+HE9kqn"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-73a9c5ccfcdso1131723a34.0
        for <nvdimm@lists.linux.dev>; Sat, 05 Jul 2025 15:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751756186; x=1752360986; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nICa9Cy/Ik1mDrNaapm3C7wILSwFMeL/8n8Vc7ARhtA=;
        b=W+HE9kqnTMNPq1WMTrySHkL4FaQY+gDHY35hXMNJ/tZj6sIAaU78+KW4Ptr7Mp4XwD
         nNdLtyPJ47OdcRAwFTFH7qUf8GZNSA7tjzYi7AJQAVODukEprL6KO0jZSMsRqJaCfWFv
         o0Bk1M+GxxZFWhjsw4aS9Nj3xtJtazed7/jwvse+Jkz7gbJ69l4t9QGybtSpldxvpV44
         iASTLFaN5wB4fsVzq6Yazuy+Ld72OtAXEYR+6rq8IZZZdGPHHg2T5Z9phDalPQXVIIAs
         +6i8LMk+EUev3V5ws7WyM7CHDDOOccUJhb3hRp4l5xWIBs45jlkLbAMpFnrooY+608ww
         e/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751756186; x=1752360986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nICa9Cy/Ik1mDrNaapm3C7wILSwFMeL/8n8Vc7ARhtA=;
        b=bdFzlej+8b1YdY7rvkdr8dxeXoQJ9F6b10hPfbwzxNFeKoB+7caWTgkry2yzmF+jEx
         rHBXSunrKXBvzsBi+04pHTBBzdz/i87DBkepIIqVgnnzdrUFv4x6bV9gv0JcwF3seHIf
         NlBATylRdNpVYcJO2pZr2q6xxthlMYf0Mz8Dr8ypy4Gn0u4yMUaC7RI472sLuf30GVyn
         x2odQJ/sbwY+L4hbUT1pZetpKoK9El+hRZ3ugoUGrj31JjbZqqsxtSnGEl9nOos7Diw0
         pkOm9fKGp61XQaaQfqV+f86a+csTS924AbqNWqzaU+9fcHg7Hz7Yxxo01YrKCiVbt+TY
         h3cw==
X-Forwarded-Encrypted: i=1; AJvYcCV6kvFFgRMQfYCvYzfbSMekZCeehunhgiQXy0Ghe1dWb1Wrm9WcyYX2xZXUO2nOpkk24t6wYDQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiImlA3JeRAvEaXew0do5cPru1sE7+TDWwv9JE3Gjek9i7uEsJ
	Vsh5sCgNHDj0/DUwAMUGXa65qULjnwatyHjkK7cG5R/tuZPcjaX2duCm
X-Gm-Gg: ASbGncvXivut1SUfI2wmvqAxUo4VRZL7XePNvJjllisahonGM5Zt4ngx8lPb2hOdW4H
	w4x1VSEsVu1UEwRteWTbwuRwWmXMayqEEAzE/Y1Sjd7/47DJayAomWB7BQdUiddymtUYqe8u9S9
	4/YgutU6tna06+XrJjtSSsMVfrNaWU34N7giR3OLYjaW2oElF9RPx8jebU0bUbmIcTLFvtwqwR3
	gPxRPumrGXBrr/IUlvKs0TBFtOfyckIFKtuoPISCc6ylDTm1LQ9eexQq+1sv+za4UVTspwFEBHd
	bszxoe6PgtukOyyS+XOoBwd4vjWFpIvmjVOPWQOpuLyE6eyMcd3h16/3BOouKbn6fVaaJDwL4UA
	z
X-Google-Smtp-Source: AGHT+IHuG5FCYsJhjMJavIVyVhItZa43h5Kj54uCqORVbS+uRUzsxc+GupAT4W0CSWAPweEMZrVidA==
X-Received: by 2002:a05:6830:348f:b0:73b:1efa:5f43 with SMTP id 46e09a7af769-73ca0fdda45mr5358902a34.0.1751756185894;
        Sat, 05 Jul 2025 15:56:25 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:d5d4:7402:f107:a815])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f75354bsm944468a34.16.2025.07.05.15.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 15:56:25 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sat, 5 Jul 2025 17:56:23 -0500
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 04/18] dev_dax_iomap: Add dax_operations for use by
 fs-dax on devdax
Message-ID: <ahu24cm4ibrrch4jo2iobhrlxfs3kzyt46ylfovmhy2ztv2qad@upimvr47jvwf>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-5-john@groves.net>
 <20250704134744.00006bcd@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704134744.00006bcd@huawei.com>

On 25/07/04 01:47PM, Jonathan Cameron wrote:
> On Thu,  3 Jul 2025 13:50:18 -0500
> John Groves <John@Groves.net> wrote:
> 
> > Notes about this commit:
> > 
> > * These methods are based on pmem_dax_ops from drivers/nvdimm/pmem.c
> > 
> > * dev_dax_direct_access() is returns the hpa, pfn and kva. The kva was
> >   newly stored as dev_dax->virt_addr by dev_dax_probe().
> > 
> > * The hpa/pfn are used for mmap (dax_iomap_fault()), and the kva is used
> >   for read/write (dax_iomap_rw())
> > 
> > * dev_dax_recovery_write() and dev_dax_zero_page_range() have not been
> >   tested yet. I'm looking for suggestions as to how to test those.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> A few trivial things noticed whilst reading through.

BTW thanks for looking at the dev_dax_iomap part of the series. These are
basically identical to the two standalone-famfs series' I put out last year,
but have IIRC not gotten review comments before this.

> 
> > ---
> >  drivers/dax/bus.c | 120 ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 115 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index 9d9a4ae7bbc0..61a8d1b3c07a 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -7,6 +7,10 @@
> >  #include <linux/slab.h>
> >  #include <linux/dax.h>
> >  #include <linux/io.h>
> > +#include <linux/backing-dev.h>
> > +#include <linux/pfn_t.h>
> > +#include <linux/range.h>
> > +#include <linux/uio.h>
> >  #include "dax-private.h"
> >  #include "bus.h"
> >  
> > @@ -1441,6 +1445,105 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
> >  }
> >  EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
> >  
> > +#if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
> > +
> > +static void write_dax(void *pmem_addr, struct page *page,
> > +		unsigned int off, unsigned int len)
> > +{
> > +	unsigned int chunk;
> > +	void *mem;
> 
> I'd move these two into the loop - similar to what you have
> in other cases with more local scope.

Done, thanks.

> 
> > +
> > +	while (len) {
> > +		mem = kmap_local_page(page);
> > +		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
> > +		memcpy_flushcache(pmem_addr, mem + off, chunk);
> > +		kunmap_local(mem);
> > +		len -= chunk;
> > +		off = 0;
> > +		page++;
> > +		pmem_addr += chunk;
> > +	}
> > +}
> > +
> > +static long __dev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> > +			long nr_pages, enum dax_access_mode mode, void **kaddr,
> > +			pfn_t *pfn)
> > +{
> > +	struct dev_dax *dev_dax = dax_get_private(dax_dev);
> > +	size_t size = nr_pages << PAGE_SHIFT;
> > +	size_t offset = pgoff << PAGE_SHIFT;
> > +	void *virt_addr = dev_dax->virt_addr + offset;
> > +	u64 flags = PFN_DEV|PFN_MAP;
> 
> spaces around the |
> 
> Though given it's in just one place, just put these inline next
> to the question...

Done and done.

> 
> 
> > +	phys_addr_t phys;
> > +	pfn_t local_pfn;
> > +	size_t dax_size;
> > +
> > +	WARN_ON(!dev_dax->virt_addr);
> > +
> > +	if (down_read_interruptible(&dax_dev_rwsem))
> > +		return 0; /* no valid data since we were killed */
> > +	dax_size = dev_dax_size(dev_dax);
> > +	up_read(&dax_dev_rwsem);
> > +
> > +	phys = dax_pgoff_to_phys(dev_dax, pgoff, nr_pages << PAGE_SHIFT);
> > +
> > +	if (kaddr)
> > +		*kaddr = virt_addr;
> > +
> > +	local_pfn = phys_to_pfn_t(phys, flags); /* are flags correct? */
> > +	if (pfn)
> > +		*pfn = local_pfn;
> > +
> > +	/* This the valid size at the specified address */
> > +	return PHYS_PFN(min_t(size_t, size, dax_size - offset));
> > +}
> 
> > +static size_t dev_dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> > +		void *addr, size_t bytes, struct iov_iter *i)
> > +{
> > +	size_t off;
> > +
> > +	off = offset_in_page(addr);
> 
> Unused.

Righto. Thanks.

> > +
> > +	return _copy_from_iter_flushcache(addr, bytes, i);
> > +}
> 
> 

Thanks!
John

