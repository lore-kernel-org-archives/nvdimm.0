Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB4730E839
	for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236416; cv=none; b=gDs3HtiMhSnJrdr9hxRbbJnWIjNUpnjwqq6CPdaDdeTrhUGDS8tSZyNiUOIFnrrcG3rsNzYm5u4SPO13u69Mbqk/r9wtBex5z+3yywCG2sJRDYdS4JzD+GcjyUlCW3W31WI/L+sKqJl/hiRyRu+e2cbXLVLHqTFNcYyGMjA9Mjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236416; c=relaxed/simple;
	bh=8lgp9tnyFzGocHb8jl6w1NG/N7Zcs3J+oUbbLZskDQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2tHS/698QZYU0o0tlq9s8fRJoM48qvcAcMf99xWdJy01Pslh5mOfwavryhnfh4lTZoEs5pXOu7Yw/pp/pxn1VcY1HdG+APq33t5AimFwOnbelC+h5nylJPZ0G2/uevjhf7564LSnCcGpxFh/S3Q9bklXS2Is2JvGpaJA+yeQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=npXG+tvp; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="npXG+tvp"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7cfb21a52a8so746513a34.2
        for <nvdimm@lists.linux.dev>; Mon, 12 Jan 2026 08:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768236405; x=1768841205; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n6deLDrT44WMlKVvRfzJXPGGgj/xg0j1HG9++H6LUz0=;
        b=npXG+tvpamne4WUqAdsdb2so+23gC5N3TAQmkk/EuP/zbtEgycwtzre/gFwV+72nIN
         R0GrfnKv+2ojKfVrMxq5r3TkpAVMQYDCpvcdQ1bCXj+PfSwSngNeLncPkNZSpcBxVbd9
         0ZouItsi4FQjRL16OkJD7GjicRQitwU/B1JUS9Gs4jpKk2J358cpo3DwE0w2xFMvHMmM
         XtdjA1EdnepihaOCN6fnWje7G3uYnScsOltPtTUW+YrK1Et2nTEEKBWqygjD+nFjIGbe
         1gWqSCMpqoGQXGKDq99iiPahC3tkDg3q5w+00yo7VfAlVBi9y4K3JagATT989V0ETnte
         uoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768236405; x=1768841205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n6deLDrT44WMlKVvRfzJXPGGgj/xg0j1HG9++H6LUz0=;
        b=MLmfFgi3x3sKXW7cCNH0KaBZ6P13+DxR0Z7QkjuvYXgl4VkT+m7O4qsJG6J7FzR1Uy
         PKbS8DM/7PDWSvEhwQLJ8BUCCYoFSNMko+8fjjz1txBr8SwwTF1Y+WJ1/6f4e1Gkow+U
         m6ngQu0KlHFGz7cVilZqumtRbXNR8dXzzgX/UMNXp4SpRZmC3rd5aJw05d3vu+GDZnuc
         rUoDFb3/ntw6XCnRwbcMgmXhqkiivY6a0Jbe8OZDsyzJ2Si8W+LR0I+8MPgVrutIuxY0
         2B4aq5c7w3wpMyRUygvj3NeE7/HzbdtbYVVQALDxnSiNPJwKvoiULv9z1TBuOP7bGTFm
         q1kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbYcn9OumeJenjKgsw4uA29flu2Xl0WNkCDqzpHTaCQyYfLEJMf01iQgWH5GATLExbr7MpYXY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjHtI8BWlby4geyb6snYcbOuw2JD0zlEpgT/rN+Zveo6db5/ms
	h7AeaJhFArJD8hRWe4kTsRcCjI6EeWUwL8FUhUFdCYfml6uvX0sfC7O6
X-Gm-Gg: AY/fxX7Sw+XIUSprCo0cEaFSD5NQB7Ofm7vrtkyJdp5B2IN1y0MJ0S2f13S5wq2Nv/U
	k/dQ8n0s40+HpA891nzaA6Ce7MUbj9HjU3z2mVIX7giysGHVpTLoEbMtGutwVoIoKcVLV0UlVQj
	v+Wh0SkMtj5RthUsPqtTM3OT1F3cp9yl/b1Dwwr439Y9NKLtuM1rCjMtVMVOYre12B/5eXnhCl0
	vUvzE6vQVX5xsAYzd3S8UjWCSDYDjCe/Lk64ECrssue6dk1VNtHVKuJjvMrBFD7wNRVg4edmmKB
	nChuoGxfr9Bqx6wPJ9/WU8d3n8LTyzkswdOtXEqtixjc6Lyw98ojTDjEkiUHHwMQcewcJervKqq
	64DH4F/olfOINTnpwjeMy88vhJLfA7bZgacSoTuBREq1gYllmbSJ1EOdRRUCxsnva2Qz5U39gUj
	C3KHJuuUG8aKgOw0i7pEwG5IOB4XcbCg==
X-Google-Smtp-Source: AGHT+IGkPS/NCs2Mk5Oq2bbD5I5Nrr2IjEdlrsoDxvBDNYRoKgitfj+LmMDnnes+e1yquAKJv+M8AA==
X-Received: by 2002:a05:6830:2e07:b0:7cb:1270:1255 with SMTP id 46e09a7af769-7ce50932573mr13073106a34.16.1768236405392;
        Mon, 12 Jan 2026 08:46:45 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:b02d:f13b:7588:7191])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce4781c286sm14241471a34.8.2026.01.12.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 08:46:45 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Mon, 12 Jan 2026 10:46:42 -0600
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
Subject: Re: [PATCH V3 10/21] famfs_fuse: Kconfig
Message-ID: <26sfkgpuqdle2nmj4kcv7j2bgnrlpfo3wglfzqiuagjucnufx5@b4ggxnalmcwr>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-11-john@groves.net>
 <20260108123638.0000442e@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108123638.0000442e@huawei.com>

On 26/01/08 12:36PM, Jonathan Cameron wrote:
> On Wed,  7 Jan 2026 09:33:19 -0600
> John Groves <John@Groves.net> wrote:
> 
> > Add FUSE_FAMFS_DAX config parameter, to control compilation of famfs
> > within fuse.
> > 
> > Signed-off-by: John Groves <john@groves.net>
> 
> A separate commit for this doesn't obviously add anything over combining
> it with first place the CONFIG_xxx is used.
> 
> Maybe it's a convention for fs/fuse though. If it is ignore me.

I've squashed this into the first commit that uses FUSE_FAMFS_DAX,
which is 2 commits later...

Thanks,
John

