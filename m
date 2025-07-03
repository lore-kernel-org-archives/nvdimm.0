Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65528EA53
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 22:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751582753; cv=none; b=GZVG3ll9b9QieJaig+pSLYi6yXtAPkwxI3CMyVDMvLsNfu1fStmSmKyKThlst3AqFLw7a1rQA111Pnq8lkvJcSG9T+We5IS2iTNVbgrg+AFVWswknRNCrm1sQg1CaEeoi4FR3NeFpedDb3/badCDerg7uJrTPpWxnrhoF9ihIRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751582753; c=relaxed/simple;
	bh=HPiHsjtsNUgZ0EFVulpD9xRBLiID8ZLRDhdfVW3IdsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLl30j8GsFRTYKGP8fprMK8shDr97NAB1S+mWXimnc3teaSu/obwT4JUO7S6F2vcZ7pWNsxEjmI0iu1OvnB7uO7vmArtEj8CeBo3s1pCvlqrX/n+AifIk0SVFo4KZxSo4Rf7bpxcL79mh8hOl36MWP1vS1wE+4xIRiB+qia1Vds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AyikPN0f; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AyikPN0f"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-73c89db3dfcso99739a34.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 15:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751582751; x=1752187551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/YPfgimj3TTDyL48vSPqdxv4VejexqVlnC8mgGOjy00=;
        b=AyikPN0fgzEbQt6oguS/LPGxeDsqAb496ehu5JBfBRZqhxnCzh3Ue//C4nS/jno4mm
         Ge0TXFBblrQZDOiWIghRwDee8VjXEQ4qxloyYr1Pc4Ubmb4iUlufROmHRq+GEgKRx2bu
         17HLdTfSGuqdq/g+/V32FrJFIjXmBDFqCVjfbjwxeIzbvYnvgMkwWZII6JWuYgFcQVZc
         3C5n2LcDFKfcCglvy3sTVTepV5N/7fc51MySb0+R2OlC8EIwnMPkommDhhYSl6XDX9b5
         TepJnz8mQDwrElVBEfIwtOT5GF2TBbWErXRU7odTOSvrpg1uEGpTyyBw8gknvAetf/Ik
         PR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751582751; x=1752187551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/YPfgimj3TTDyL48vSPqdxv4VejexqVlnC8mgGOjy00=;
        b=dDkb+Mu7xE+n91qLSpF3LrGTjshQ8hjVleilWJx2yKQs5A79eZZXcuB4gR0WBO4xT0
         QiLnYya2qC0WJ8fjo4mU0YGLj5mDXTMRG46LWlIv5eyoSSymKvBRnmUnanzgxW05auTA
         HFgmNsLMAT7Zs3CJFxlPxEhGrJIYedheSf/nr8tMWHPpxQNhvTClbHRT75PM6MjAayKU
         TFenjqALFakY8cFF+tDaWSY5Zqe1+6/vWJ0+MGaE9We1OQM9K1uXD3ly5XV+mgSRWj60
         e3uG07j3z+Pzza4ptYNU4LmQo7p/DBsDIP0Y+bu1XYhm0PZbh7AuKXiiEh2Hlef42R1E
         YaeA==
X-Forwarded-Encrypted: i=1; AJvYcCU7S3kIsucfyvAbNdXtEvqDNMFCo0m2ljfGw/jp9ezA3JLe84QAGMNnLQWy5HMSg+T9qaXrRyU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrtiL669ud7lJ4fKh/3/42e4LvlDG7p019Z2sFlqDeVKkRP3DC
	hwXFAknaat4TQdoCBRzLVKv2eWbxQJksqWxZ3dtFZqdw/jp8ZAJQps3s
X-Gm-Gg: ASbGncuBzQjhH9JxGgsbi01FimxHQqx0zIgFwCnrsDirEg4o3m9TxaoB+J3LVks3y5M
	Vr63rKWIlB5D3+NG6H3JyQ8sGozoOG8EUw9J4f+lgkAkwqe31SSDKr6ggkv5TIHctfhcJvTN/Eg
	itf2e1wcYCvX2W2UjAcS1xZBCBqPN2L8L648gmsq0yjNF1Og9WjOT7GiFhWGYzkYhz/OMch8lMZ
	0Lxhs6PotrdRv9YlLAMtvwkZwN08G14gVyNaqN8bJNoHzlRoS1bh4c5EXYEq4u8VT1jT1ye5Jgc
	XYP8mzRDXU6FeBMKvMRQAwAARCGWDftKl12OhbTcgt/3UhlzpHjWqpn88RuF4SbDh/TfZQ57ub9
	Ao++QWYHgoA==
X-Google-Smtp-Source: AGHT+IHgGLtiiEgL7LDQ1Ih8w/gzruS2hdwVBLtgvJrCpoHNfH4Jij5JOMCtHWIqD9KxgQY4KtoqHA==
X-Received: by 2002:a05:6830:2d81:b0:72b:89ca:5120 with SMTP id 46e09a7af769-73ca124817bmr592721a34.8.1751582750775;
        Thu, 03 Jul 2025 15:45:50 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f75356fsm159877a34.26.2025.07.03.15.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 15:45:50 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 3 Jul 2025 17:45:48 -0500
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 10/18] famfs_fuse: Basic fuse kernel ABI enablement for
 famfs
Message-ID: <aimijj4mxtklldc3w6xpuwaaneoa7ekv5cnjj7rva3xmzoslgx@x4cwlmwb7dpm>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-11-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703185032.46568-11-john@groves.net>

On 25/07/03 01:50PM, John Groves wrote:
> * FUSE_DAX_FMAP flag in INIT request/reply
> 
> * fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
>   famfs-enabled connection
> 
> Signed-off-by: John Groves <john@groves.net>
> ---
>  fs/fuse/fuse_i.h          |  3 +++
>  fs/fuse/inode.c           | 14 ++++++++++++++
>  include/uapi/linux/fuse.h |  4 ++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index 9d87ac48d724..a592c1002861 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -873,6 +873,9 @@ struct fuse_conn {
>  	/* Use io_uring for communication */
>  	unsigned int io_uring;
>  
> +	/* dev_dax_iomap support for famfs */
> +	unsigned int famfs_iomap:1;
> +
>  	/** Maximum stack depth for passthrough backing files */
>  	int max_stack_depth;
>  
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 29147657a99f..e48e11c3f9f3 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
>  			}
>  			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
>  				fc->io_uring = 1;
> +			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
> +			    flags & FUSE_DAX_FMAP) {
> +				/* XXX: Should also check that fuse server
> +				 * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
> +				 * since it is directing the kernel to access
> +				 * dax memory directly - but this function
> +				 * appears not to be called in fuse server
> +				 * process context (b/c even if it drops
> +				 * those capabilities, they are held here).
> +				 */
> +				fc->famfs_iomap = 1;

I think there should be a check here that the fuse server is 
capable(CAP_SYS_RAWIO) (or maybe CAP_SYS_ADMIN), but this function doesn't 
run in fuse server context. A famfs fuse server is providing fmaps, which 
map files to devdax memory, which should not be an unprivileged operation.

1) Does fs/fuse already store the capabilities of the fuse server?
2) If not, where do you suggest I do that, and where do you suggest I store
that info? The only dead-obvious place (to me) that fs/fuse runs in server
context is in fuse_dev_open(), but it doesn't store anything...

@Miklos, I'd appreciate your advice here.

Thanks!
John

