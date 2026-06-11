Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1A353EF7
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 06:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781158971; cv=none; b=mSbT5Ntz6BX85wl9kF61j4pHS6Ue65um60T9dLy0zlv/xGl5Zr3bc02DjRW6d05muRY9UZ+qgNLvIaPdNuSobYnoJrpurcPcispISQptwwfuPoE6RRLWgOu52klSiAL1L+1X5EUrKpyTF6KuSGm9u82eotI024XHVWGxvtRUumA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781158971; c=relaxed/simple;
	bh=aOEGPw/vtOCxM66iJPQ6H7kLds48Kb65VpUxYO7XjUQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjtf9ho4zGEQgHxaN6iU6rziLznFlKokaTLOloSRLqmCuixHho+qhgnE715gN12y0fuQS77YjlqJwkuOCqRmWGavaeYGa5AlGkygvXzLm7fyPTXi1CUeY9WsRk1nxQhbMDZhjMWIjCYXmNhvleXPUtwbBbjMyb0X5nFCBAgsX6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RSjRrg4e; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSjRrg4e"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-307631dbfedso343613eec.0
        for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 23:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781158968; x=1781763768; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q+r5CsmNZ/qmFA19D/kuAvtdTU1zm5RqRVe0bN9E8Fk=;
        b=RSjRrg4ejXhg2lbeHqPY+UG/nCtRppxAzZvv9iKuA99ZRCa0+vJsAmgjEirehZGIA0
         CwZZ+MDkuR2gDp2zWVcUUPCEzT2vAf/PdnDgsQ3vZ5GiMDBOvLtV4ftF1y1VoG/H2c4z
         WoscAhphk6D0QYOoKuQFsGM+ofJVYMl7GpBP74yToeWVdXxyaCwD1/3WBUJ4h0QBS+ev
         isjZxmiKo9ek1fcOvwM+uFOhlDr7jHXHDHnjMAoFn9oCLaiPnTppjktHA6dJFdZLp+f0
         QhcJHlU9Sa8pgxaZKi9/dPD4IrQKG64Q5SM/vyQMj2jy6CdZE4OLB7SLRQSy0Vl9pN4s
         ObFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781158968; x=1781763768;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+r5CsmNZ/qmFA19D/kuAvtdTU1zm5RqRVe0bN9E8Fk=;
        b=nRFWp/KpLIa9ZsqVz4VljKy8fC6i2LNT2lbskDxXsklovl2geQPpar0hJ58JJTv9WM
         EXk9DucJQZ+jBSOaAMK4GyGY6QL0qzrzLnKd65cWsShv6JW4IjF45OS83h4p0N+6L/Ni
         Zg/jrXv/7E1tDlonmQppRkUUILVKxtohBDr3e0q68hI8n9po1fAdUGz6NGf3czYfzePl
         d0FtxrXoq2IgWnbDVxakfr2iMukrlLnJ5KWiGiUXnK/Q+1Y4VgfrvhXtGCl0Ry+PGlVL
         UyxORk93J7vlFECT2RQMgMhVCoJ2U7suiQkkYOO+ZV+iyl3TaUkyY7zsBeq9h3cL4BuJ
         MsxQ==
X-Forwarded-Encrypted: i=1; AFNElJ91bLppYd+Zb/5Q5IxpIOAzPr2xu3CoVNAI8UBOnfV0N51PtxPbwaGtDawpZWCguD+YQFuQaug=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzv7auT8Hj7forIjAavQARk4w6vz3E6ZoIgfxxykFzZb+1wS+9c
	LqVY0LS6VqwJEpuNMQFtoZ/ttRU/JInSPSyrecFxgk5FeZQjHTyVgoZS
X-Gm-Gg: Acq92OFLV2PZ031sHUpzffkBCNs846It5IfH7PuyUJirD0KLZhhF6+ovV2VYxLR8smZ
	nKI+dfXg/VQO6XHDs+oYp8H2pq14v+AKCtXWF1K35sdnTv47Wxl3MBF70AxN5ZoKWjKMKq1vFEo
	DGb6GruXJkgdnsxRjU/piSqjivR96m9JBTfC9YHvQTf6kOHDI0O2cC9KPcZ7PEnGTLVgDsxIo4U
	Ch2DnqXAEzpiJGxXkdIUr1Ctzng385QhQAFbLaXUyaNmQprt6lx2UDr2of8QRAtFZv8rAxkQQpu
	oSgF/YSTJE1tUOkeInuycreOLfS1JpaZ0CHMcFvsKIRg0jyHc/Tyu727ZfynSdkKUhlO6S595us
	0Fkto1EBoVyeAVSBm2FxRlKzY7z5iCOUTySHWeThQOTKEnIKE4gPTu6+wVqobqxO45Hnu82gt55
	76qeCU98eGeoVW2C6M61wO1/1bhYgwn2m0L7Nuwt3apUN31ywLYfWNCOh/bZ3OHkSDYHAw8om5+
	03GdQ8kypUYpyz2MQ==
X-Received: by 2002:a05:7300:7305:b0:304:c520:4e0c with SMTP id 5a478bee46e88-3080479b610mr1200660eec.6.1781158967959;
        Wed, 10 Jun 2026 23:22:47 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30806c2f3absm917761eec.5.2026.06.10.23.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 23:22:47 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 10 Jun 2026 23:22:45 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 15/31] cxl/mem: Drop misaligned DCD extent groups
Message-ID: <aipUNZIxgAenJjLM@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <60e23199f7ef7dd3008bb3275c40d242334275c9.1779528761.git.anisa.su@samsung.com>
 <c09e9ae9-d5b9-48b6-9225-98f53022545d@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c09e9ae9-d5b9-48b6-9225-98f53022545d@intel.com>

On Thu, May 28, 2026 at 02:03:12PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > Add an alignment gate to cxl_add_pending(): every extent in a tag group
> > must have its start_dpa and length aligned to CXL_DCD_EXTENT_ALIGN (SZ_2M,
> > the minimum device-dax mapping granularity on every architecture that
> > enables CXL DCD).  A misaligned extent makes the resulting dax device
> > unusable, so drop the whole group rather than accept a partial allocation
> > that would surface a broken dax_resource.
> > 
> > Based on patches by John Groves.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: John Groves <John@Groves.net>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: split out as a separate validation step]
> > ---
> >  drivers/cxl/core/mbox.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index e5edc3975e8f..421bd716a273 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/unaligned.h>
> >  #include <linux/list.h>
> >  #include <linux/list_sort.h>
> > +#include <linux/sizes.h>
> >  #include <cxlpci.h>
> >  #include <cxlmem.h>
> >  #include <cxl.h>
> > @@ -1280,6 +1281,24 @@ static int add_to_pending_list(struct list_head *pending_list,
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Device-dax requires extent boundaries aligned to its mapping granularity.
> > + * Use SZ_2M as a conservative default; a tighter check that queries the
> > + * cxl_dax_region / cxl_endpoint_decoder for its actual alignment would be
> > + * strictly more correct, but SZ_2M is the minimum device-dax supports on
> > + * every architecture that enables CXL DCD today.
> > + */
> > +#define CXL_DCD_EXTENT_ALIGN	SZ_2M
> 
> Wonder if this would cause issues in DAX on ARM64 with 64k page size since its PMD size is 512M. 
> 
Changed to use PMD_SIZE

> DJ
> > +
> > +static bool cxl_extent_dcd_aligned(const struct cxl_extent *extent)
> > +{
> > +	u64 start = le64_to_cpu(extent->start_dpa);
> > +	u64 len = le64_to_cpu(extent->length);
> > +
> > +	return IS_ALIGNED(start, CXL_DCD_EXTENT_ALIGN) &&
> > +	       IS_ALIGNED(len, CXL_DCD_EXTENT_ALIGN);
> > +}
> > +
> >  /*
> >   * Compare two extents by shared_extn_seq (ascending).  list_sort is
> >   * stable so when shared_extn_seq is 0 for every entry (non-sharable
> > @@ -1352,6 +1371,26 @@ static int cxl_add_pending(struct cxl_memdev_state *mds)
> >  		extract_tag_group(pending, &tag, &group);
> >  		list_sort(NULL, &group, extent_seq_compare);
> >  
> > +		/* Alignment gate — abort the group if any member fails */
> > +		bool aligned = true;
> 
> declaring var in middle of code
> 
Moved up
> > +		list_for_each_entry(pos, &group, list) {
> > +			if (!cxl_extent_dcd_aligned(pos->extent)) {
> > +				dev_warn(dev,
> > +					 "Tag %pUb: dropping group, extent DPA:%#llx LEN:%#llx not %u-aligned\n",
> > +					 &tag,
> > +					 le64_to_cpu(pos->extent->start_dpa),
> > +					 le64_to_cpu(pos->extent->length),
> > +					 CXL_DCD_EXTENT_ALIGN);
> > +				aligned = false;
> > +				break;
> > +			}
> > +		}
> > +		if (!aligned) {
> > +			list_for_each_entry_safe(pos, tmp, &group, list)
> > +				delete_extent_node(pos);
> > +			continue;
> > +		}
> > +
> >  		u16 logical_seq = 1;
> 
> Looks like this one came from a previous patch.
> 
Moved up in prev patch

Thanks,
Anisa
> 
> >  		list_for_each_entry_safe(pos, tmp, &group, list) {
> >  			u16 raw = le16_to_cpu(pos->extent->shared_extn_seq);
> 
