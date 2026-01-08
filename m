Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED3315D2B
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767885334; cv=none; b=E+51r9jNwgnBuDVLl7bXhwp9dRbwg//euCvCr/lVVKAJQ3Dr4nE5i2AEknqkOKuD3c7Llkv51d/PdxR24tD60Gs6e9Num3DedjLiJPI8tEDjg019ldx5/TyuM92K1szryBaXcKIXxBN98VAjQpXhjNcv9/+6pW3J3BYd7kKck+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767885334; c=relaxed/simple;
	bh=QWFzW8AiryxbX9bHsSDyy6FhwD+iu2OibSf5IcWI1Sg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eggl/cJoVTY5hE992rX6jpE0I2l45eV8My2IvEGvL175lZ+b4b7076AID7JylDzvJCoSw/p6lGSrprFtyH/Hne87u1FfvVOagvG/CdNoxqZnQIK0n+NAIMnQEErfzulGO5+3FjzY3CJaBpLDy1GUh55GHKl342HKaZobV8g8o/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xac5bCZp; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xac5bCZp"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cdd651c884so1518041a34.1
        for <nvdimm@lists.linux.dev>; Thu, 08 Jan 2026 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767885332; x=1768490132; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vcFV42Btb4Pg72+ADKdt3ZJAxf5GS4JhHeJgrxvwKog=;
        b=Xac5bCZpK3IhuXspEDs9qZ/XG5LJ0EMtV1BDYzwKIDexW6MzKClGiSiZhQRrgHTOYo
         RnTKLb1Na96wmgLauiCqCS0KYXCzK/rf5VMq2KD+01vjofMtDHGieqYcJ16qFlRMkiHD
         qLQ/x1EyYINUkCUwWurKKopzPb7txFQbZGL0T7/2JD3oUQZ4v5La2TrQr8orl0LQsD+I
         DdEGWbBBKcCo8/Jy17anLk5cC03mfV01Sf2i8i386B1Go7RNrMqnPlxGuLdzUKb90M6j
         /VB96esbilVG3IPlDignZrvRRDt704kIUUUOxGVdFbQ1mS/LLpMVEjH/CG8lnoP348WY
         w1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767885332; x=1768490132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vcFV42Btb4Pg72+ADKdt3ZJAxf5GS4JhHeJgrxvwKog=;
        b=Lf/EfriTyQmIVUMo4/drmphzPTRboVD9oEgmALMTyOsgXYRVvaOYI5mD69XFniP0iu
         3ru7pP4zn16239uNrnTTxEYezY5XwEmdzIA/3mcwIjIs94I2Q4yyPmN5ZdLOOO1grdFJ
         bjDdyjFd+Z53NtmvtVtKJrlhY73weFypak5VG0KlIjj/ZAxQ7mhjXxVivuOp2nrFIRdf
         mDUnyJnKbjF4zb+IV8Y871gQA+juS2FFWD5jRVVbwMbMO1iV5kDpqJ5yAmmE/RIT5XO9
         Mlb0BD++0hvGmdIzVWHnIQEQeO4HJqcA+sO3D74oVan2meuXI2JaRqjvGq5FwgJKsuZ+
         Qxaw==
X-Forwarded-Encrypted: i=1; AJvYcCUmjQqUnvmzN/c+XTZQv/pWvf7B7iFdRzNd+aKvL+Rurl8KUQu3VYtWOpa5vnV03YvCYZikLDM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCRnqPCoDMTWRHWzVLwRqKA2kmKsl+QRcTFUjSm5qF2pMbIMTG
	eixiwJcSfnqIVyckXiiMBvcWnpUx8T1iC+aDNqC0uOG+8mqWlxOx2AZq
X-Gm-Gg: AY/fxX55vCgDlc4FCB6XXUwYK4Zv0a/9w5pLSwwspVfti+vhnTMR8zrVxYcRbukqdgR
	xqSSARDW4R1c7XNfHEWOWh6ncOaDqRFkskcF2b94KdvcoRgnE9UPFGYBcRtqAHDWQTm8kjIX5ws
	yAQOhtZscK2lT+IugewEJXIh2HW7UMWDNjLvI5quqWSYu1mHP69QGRqh6PepQEoC8Udu/42+oqs
	QsLxGjEG0TvWskUbW+Ua152OpJ5iDh16oq7Eng/8lZq7rBzh1fSkJWBm4Iihc/HZ7kSYkx2EkcB
	/Jbu8UjdniFViytC7b4VNOiP+9syyFk2Tld1PtSEep+7E7gLtJKqhwjSwPKbWASKZjYbK3wjFVP
	IPh5Vx0+lIf/uTsn1JWm3qVOhc1bFD+K+EU87vX18G2TRAJdF6HdblyXOjymJjixiDTpPtO/LHW
	SSLqzq2hhtuBDGhBZzbrBeHJkFwKZCqg==
X-Google-Smtp-Source: AGHT+IEwgFQoT6qI08G95oHchDEjjGEhvVdx57kWehu/9O96BbjgHzcPqrjy1Acp6iwhXUgPqgye5Q==
X-Received: by 2002:a9d:4c94:0:b0:7ce:5139:301b with SMTP id 46e09a7af769-7ce5139308emr2469509a34.8.1767885331763;
        Thu, 08 Jan 2026 07:15:31 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:902b:954a:a912:b0f5])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce4781c286sm5799755a34.8.2026.01.08.07.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 07:15:31 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 8 Jan 2026 09:15:29 -0600
From: John Groves <John@groves.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 03/21] dax: Save the kva from memremap
Message-ID: <djiagki7jvoyonnr5ajt43xwasgil6j7sfjhs27gbb6uwckyds@i52ef23dwakh>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-4-john@groves.net>
 <20260108113251.00004f1c@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108113251.00004f1c@huawei.com>

On 26/01/08 11:32AM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:12 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Save the kva from memremap because we need it for iomap rw support.
> > 
> > Prior to famfs, there were no iomap users of /dev/dax - so the virtual
> > address from memremap was not needed.
> > 
> > (also fill in missing kerneldoc comment fields for struct dev_dax)
> 
> Do that as a precursor that can be picked up ahead of the rest of the series.

Makes sense. Actually, I'll just send it as a separate standalone patch...

Thanks,
John

[ ... ]


