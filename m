Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D592E213236
	for <nvdimm@lists.linux.dev>; Thu,  5 Jun 2025 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749125361; cv=none; b=VUXZJdO1UgcSbyf8FIpuRIt5JIjflxne0Cw9sLk37F12KYUg0NJstaIrpsLjUaHay9buBpsqrDxDYwIuSmBKuF4sK7PbBbhbTYM9y9TNRoGZFPUooRhbHsnbhvtS0YtIIM5GZhr70tfVXAQ/Z3uzxXVmc6BwZHG1hlpWgnmBgIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749125361; c=relaxed/simple;
	bh=68ST4wWru6aYFudYB/AR3+klXokvG7WPyNYVacGmxco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbhSqqohQsUIQu7/iBdxUmwia8ps++LWIgDx+6AwoiCftjQ/c6vLs59znzMMmlcLPKCCt9c+T1sKzB1iBKyYD8gnsSTP6K6t6vTN2Ni7W0mmWHKgd2utftjYWb1Zrw7SoZ66abRC9+OTwAmFjcQjMhShlOW0pAt2WbvrwCxSh7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Afu7DXBU; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Afu7DXBU"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6fadb9a0325so8791516d6.2
        for <nvdimm@lists.linux.dev>; Thu, 05 Jun 2025 05:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1749125358; x=1749730158; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNA1AqJPiuiUBzCeRC8bK1nu38f0qCHlYuwt9uDWl+g=;
        b=Afu7DXBUbk+KXudiK9/tYWjWcqXhRZCHE5qtwkjzz1XvqZxbl+tq1SAMyVFCbgkkgK
         k/3jpMpqLsQMPFGyyABvqBt+RmwlCe5Y6+YYOgXOxmjoM5/wtiFuacKIuEPJoIq00fhU
         ziEEzNTeRIqth4LVNSYsOYF/9LN/9XJ7fHQOSYZTjpdS5VDZlOjLhhAbS1hgs18RW3sC
         XvMukZSNn8m/LXX3T7WGAo3QiqFMrz2LJZO6oxvkoTQwiCKxKsxUq2uIP7cs5hfrum/G
         qH8NIF86ZUGtRu0r2irOTbpFoCwh2/j2+M1Wo+ObX9422caFkb97MlPOzeYF/G7iu9Kp
         Z2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749125358; x=1749730158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNA1AqJPiuiUBzCeRC8bK1nu38f0qCHlYuwt9uDWl+g=;
        b=VizcJVeP7cd7366Dyh6+5NFUQRIZLBfoetT+J6Ip2VSB6DmeUvjemZIpiMY1j9lD9K
         8+6OHDy28OSwtjQB83MpIoLAxOGriPDzDabaUv4AJNuLr1oNrmwH1+o8fw2kSElYz4To
         585kwl1T14htHMd7Ook1TkW0oriyIRPYqW2tMUSKBjGF8HDNDWZGjRcBTdmYcenz61ky
         ATdLlAW8YVfqSwAsS3wP/C4+lv99elg03Lrw4qp3wY8yKZy20ukADbK1pndZcOTY+oX0
         17Se1FR8jxBHAmVjDUjakwgUTY+cMGidgxSO5GJHnGlgTmqfSEDJFy8DoFAwMgD4HCpO
         OE6w==
X-Forwarded-Encrypted: i=1; AJvYcCX4IL/ww175PkknVzfbegBtlS11de67osojLbotVBO+QUKQbzvKD3Xvg8XXFeCDlRz0jmKznvo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDER3fSadxc6aP089r4kxXwQcyd3TCQ5tQP69AnXoUdXtjdzCi
	qmsDrEDj7FrxhhCupy37+bX6dkfbmVxvne7pMDVMVORwE49QSw4uAXcpX9xkto6BVo4=
X-Gm-Gg: ASbGncswAxJuB27cFStuPLPRi2YdCFW2Xtf4RWpe6ryf5382cIuPGT/0ltBS5Krl9Gg
	o2xRzVsVikAQ7OSgNCsXZ6HrFU4GBY6eASjVb1+nyQ4gS80QhMZWHFjku+6L8uKW//ZPe9ec5kw
	2SAC8pkjwpqPtWQ2sFBl4lH+juMgWrhhbkePdcMq46TCzIrdkSGWocoev41CxzMXmyxGa82XqWh
	R6hglbxtmf2uk8nEOnRuI+5DAZSYxq/ySWwzSOyo/XavV3YLPb0wlSc/iLmcLFE0NsLugqesyCm
	9kV7sRDpFbCsDJ1yimjf/Z7+TYYg1hqf9ku4YDqj3rWe+KDhyYtPjBPy7KUcpKOVAGaZQbXUwPb
	2ZDDulijYI8W5yi5twI7CHzQJ1vI=
X-Google-Smtp-Source: AGHT+IGoKm/5U4/UM2uM64qO2HBitYJapsKbuDFJlmk9byEyE/W8ROsmev/IR9V9jeal6LfHAI1O8g==
X-Received: by 2002:a05:6214:224d:b0:6fa:c512:c401 with SMTP id 6a1803df08f44-6faf70163f2mr115317766d6.37.1749125350351;
        Thu, 05 Jun 2025 05:09:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fac6d4c7d8sm120604836d6.36.2025.06.05.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 05:09:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uN9PB-00000000EdT-18gz;
	Thu, 05 Jun 2025 09:09:09 -0300
Date: Thu, 5 Jun 2025 09:09:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, willy@infradead.org,
	david@redhat.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	jhubbard@nvidia.com, hch@lst.de, zhang.lyra@gmail.com,
	debug@rivosinc.com, bjorn@kernel.org, balbirs@nvidia.com,
	lorenzo.stoakes@oracle.com, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, John@groves.net
Subject: Re: [PATCH 07/12] mm: Remove redundant pXd_devmap calls
Message-ID: <20250605120909.GA44681@ziepe.ca>
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <2ee5a64581d2c78445e5c4180d7eceed085825ca.1748500293.git-series.apopple@nvidia.com>
 <6841026c50e57_249110022@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6841026c50e57_249110022@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Jun 04, 2025 at 07:35:24PM -0700, Dan Williams wrote:

> If all dax pages are special, then vm_normal_page() should never find
> them and gup should fail.
> 
> ...oh, but vm_normal_page_p[mu]d() is not used in the gup path, and
> 'special' is not set in the pte path.

That seems really suboptimal?? Why would pmd and pte be different?

> I think for any p[mu]d where p[mu]d_page() is ok to use should never set
> 'special', right?

There should be dedicated functions for installing pages and PFNs,
only the PFN one would set the special bit.

And certainly your tests *should* be failing as special entries should
never ever be converted to struct page.

Jason
