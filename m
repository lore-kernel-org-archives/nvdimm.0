Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1911350CF
	for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708988981; cv=none; b=e7oTlhLrruMmhVYWCJaLlQR3/CCZ0UuiTOl62q6wmvsg+pETP+hzXoF1VefS13J8MY2Z+mQhiUjPSd9Bc/zyjxZiW0AQX7QBSoqddo8bB1LScY+QVtDzhpCZnvd14q0dPv5oL9gTxvONAYVwX5JR1REv2Xx3Ih0W63hOT20ATN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708988981; c=relaxed/simple;
	bh=uYkkN/FdFgankiteLx48VCnumQrJ/b0UgjIilRQi83E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cp9SIirN0jw/Gve48XnHjAZ0kv/nbb1FB2O2iZeVQDbgPjmYc5ZXlwpkG4bn9aWi0Wa0PrFjyQxFq02xTItk7BGHutulcN1IJiXHwvB3YZt7oJ3s+nyC9ktE06OQQptKJ1PrMljL3Qbj5+lNi+jOTK/QIsX+9Sv8n61B/HMaCFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fycdGzSC; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fycdGzSC"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c1a1e1e539so1671260b6e.1
        for <nvdimm@lists.linux.dev>; Mon, 26 Feb 2024 15:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708988978; x=1709593778; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hsNP5EK+LFjyhVcocZelct19finr3VBZ9CwQlQrhIjw=;
        b=fycdGzSCQJkD6+1dw8bE548bHkndlgGdEh5PSWR35NhJPnURoS6C0VOndl62N4vn7i
         dAqvyxT0skrNVYQwdkPkEV1uA72NqZkrm6ktwMp6oca0xBbtSTLeSPevZTKqA15TtRwR
         mYZNsiHhALb9WFkFq0yoIKFtcQYFgZeXDbz46PjWAfPMAVHeep4NJhOXLdJeVR6avGeA
         8ptezEWHatkN6nd9tPvJNFEKC+hZZ9crGDHV/Cj+WCcBCr0e+7TslijNaIVGD3ePzfpk
         PP7Z2pWZamIqGRJ7hXbhAYPFuz7WP+d869RKgHPGhL/7VcH62VsURxmeEXmc/IdGwygg
         vTKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708988978; x=1709593778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsNP5EK+LFjyhVcocZelct19finr3VBZ9CwQlQrhIjw=;
        b=sEQPms0E4zy/vc0Zpz2P0bzd4FDuXOda2OLrvphcMB2c9Rtz8QTN7lckY943730SLu
         7PuzHwiR28FPkRtu8Dey4Y4e3DWebsUta+LXRIDp8GjsMEtaTRa5mUdypQS651c6JcEj
         /A4LLeG4jXx+EM/WstrEdxStSfU3a4ECkSQSc+t5cn+HgeOqenr9JGa2gGgtETFrr+A3
         w3I5f++tWtPzFFKU76EEQDcHt5g2st0oRaG2HPPm+3EkZYSbMpPmxD57R4xSr8S343mU
         xXaFLWqdHj8LLD3/Hsjdtmo43jfiwD0fn6UFWgyFL72OnnN6wBFJ8q5ccdF9+a57mzyW
         tLbA==
X-Forwarded-Encrypted: i=1; AJvYcCXoO9WbGySKMSR44mPOZvqBbItETkav67cKErmR84/XImdk+CqAhFXw3aA33oQhhnCqhEHGzrQU4gbkGLyT8DVkMx4fDnAX
X-Gm-Message-State: AOJu0YwBDYcLuKikdK7WovpO63HCPpKDUYxswb7YSRIH7aeAd+3w8vWp
	iEmmWdwFwLMo7B0FX23f7DuLEatm2IfwtxdNphWptdMAvoY40fJR
X-Google-Smtp-Source: AGHT+IEmmB2wgYc/dKohpH8hAGiid/eaRbwOHLzXdUGFfNAOSSLSS1QubvTxHY/CInTKJw0aVBdejg==
X-Received: by 2002:a05:6808:3021:b0:3c1:8493:751f with SMTP id ay33-20020a056808302100b003c18493751fmr552923oib.9.1708988978297;
        Mon, 26 Feb 2024 15:09:38 -0800 (PST)
Received: from Borg-9.local (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id 3-20020a544183000000b003c17fd0ed2bsm1216111oiy.47.2024.02.26.15.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 15:09:38 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 26 Feb 2024 17:09:36 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
	dave.hansen@linux.intel.com, gregory.price@memverge.com
Subject: Re: [RFC PATCH 14/20] famfs: Add struct file_operations
Message-ID: <ulweov27unhr4q6x6oad7vpmemi4ivl5ztls7gish7c7a52t3e@peoqzqt6pk4l>
References: <cover.1708709155.git.john@groves.net>
 <3f19cd8daab0dc3c4d0381019ce61cd106970097.1708709155.git.john@groves.net>
 <20240226133237.0000593c@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226133237.0000593c@Huawei.com>

On 24/02/26 01:32PM, Jonathan Cameron wrote:
> On Fri, 23 Feb 2024 11:41:58 -0600
> John Groves <John@Groves.net> wrote:
> 
> > This commit introduces the famfs file_operations. We call
> > thp_get_unmapped_area() to force PMD page alignment. Our read and
> > write handlers (famfs_dax_read_iter() and famfs_dax_write_iter())
> > call dax_iomap_rw() to do the work.
> > 
> > famfs_file_invalid() checks for various ways a famfs file can be
> > in an invalid state so we can fail I/O or fault resolution in those
> > cases. Those cases include the following:
> > 
> > * No famfs metadata
> > * file i_size does not match the originally allocated size
> > * file is not flagged as DAX
> > * errors were detected previously on the file
> > 
> > An invalid file can often be fixed by replaying the log, or by
> > umount/mount/log replay - all of which are user space operations.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> > ---
> >  fs/famfs/famfs_file.c | 136 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 136 insertions(+)
> > 
> > diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
> > index fc667d5f7be8..5228e9de1e3b 100644
> > --- a/fs/famfs/famfs_file.c
> > +++ b/fs/famfs/famfs_file.c
> > @@ -19,6 +19,142 @@
> >  #include <uapi/linux/famfs_ioctl.h>
> >  #include "famfs_internal.h"
> >  
> > +/*********************************************************************
> > + * file_operations
> > + */
> > +
> > +/* Reject I/O to files that aren't in a valid state */
> > +static ssize_t
> > +famfs_file_invalid(struct inode *inode)
> > +{
> > +	size_t i_size       = i_size_read(inode);
> > +	struct famfs_file_meta *meta = inode->i_private;
> > +
> > +	if (!meta) {
> > +		pr_err("%s: un-initialized famfs file\n", __func__);
> > +		return -EIO;
> > +	}
> > +	if (i_size != meta->file_size) {
> > +		pr_err("%s: something changed the size from  %ld to %ld\n",
> > +		       __func__, meta->file_size, i_size);
> > +		meta->error = 1;
> > +		return -ENXIO;
> > +	}
> > +	if (!IS_DAX(inode)) {
> > +		pr_err("%s: inode %llx IS_DAX is false\n", __func__, (u64)inode);
> > +		meta->error = 1;
> > +		return -ENXIO;
> > +	}
> > +	if (meta->error) {
> > +		pr_err("%s: previously detected metadata errors\n", __func__);
> > +		meta->error = 1;
> 
> Already set?  If treating it as only a boolean, maybe make it one?

Done, thanks

John

