Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961182AEE9
	for <nvdimm@lists.linux.dev>; Thu,  1 May 2025 02:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746065631; cv=none; b=YipbE/daPwf5qu0ARUJErJIK7VCQ0BPVMVkSjJYq78Is/odsCTJtwdQxH8S7j/Swv0gs5Co0NSH1vDFiMiF1FYSlaRR0uTzFz9vR5lss+Acfc+AeAfNQAx9sg+LIZ9fIMdUOHq+0+fvYb8VtcLcLAdCT5Zet2lAKL2O+EKrUSPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746065631; c=relaxed/simple;
	bh=IXL7L7GEzmRTgpRI7W6C+cM7nwoU1zodTrcRAWVG/RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFtNF2o+pZTPBXJqpZHlBCENkBl9WAwH1+61QtVVbMMN/L8CMghj4VMoMbQ1aFwMtHxCw5FungNtEEvnZ/uJrKZqLSteaXniDtbgFDL42glD1/oZ+2IdNDXQ3ZHFI97KfRlKQa9qHWmClNukn9+kbfN+VrAw/qY+/QWhxPODW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8QMQG1i; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8QMQG1i"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-72c172f1de1so285416a34.3
        for <nvdimm@lists.linux.dev>; Wed, 30 Apr 2025 19:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746065628; x=1746670428; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXdPE0dAK6WPnTA+7Y1kfcDmuDvdGOZCfAYjmJvCT6s=;
        b=M8QMQG1i64fALrWEFMYeXs4CGUwmq0edcHIVWr5SEozLdIeWNVOFew0JeNu6jqPYzn
         01zjCEo774rXCHzdBbP5y5nCDYpk7uQNoHQu0abeHcYWleOBW4ocG3v+xabn9cu6RUH0
         aYe6/lPjkPhhapGvojgG8whU4uffOWR90rZNKyAj3b5+JiSbxhrspHT/F8/a2X54F7j4
         BA3U/EK/OYD7v+b7EpmmG3o5oFWL3FFO91BnSV5j0nuB+RCQY70AHN1tatOqgFsBOf9r
         29eDhRBi7Fgh6+2U6PDJStnRYkRM5fbwFhZZVvLjHJOXSj/QO4151er4Mg3H/XfQ01uA
         /Gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746065628; x=1746670428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IXdPE0dAK6WPnTA+7Y1kfcDmuDvdGOZCfAYjmJvCT6s=;
        b=Kg9/wt2rcFK0OO3X9HqldQelukDBEBceztfMCw4uqyVQb/5j8tMhDyMNHvz8vlzDQB
         0Zqh+xmiuuDP4gLitHJRNmHYj4vg0fTapGFiVieHOaRSh3LEz9hJg8Ge2sMBBud7h4wJ
         JXsMiRqurfDmuze+dkI0VkIsapQw+rU9TQxUAvvT8Ja1+5UR71dooVf7iw0xgibwQHVe
         zk1RI5Jfbxt+STILgAJ2MmWPkOjm8DVSSdMYoSB5BKxJPabrIqup2aFeodev7+4SIJNG
         1owQkTRtagr3fuufz/RBcI7SiXBGR2ujZy0lYT/MiRsHBfvNansKjurKEmdgEnKF0e2A
         Cuow==
X-Forwarded-Encrypted: i=1; AJvYcCVTRRTC9WfXPruc5H8DLcObDb47TDkxxq41hdNBelaMKUnjXc5ruzmZcRKiV8iUfpEOHzfVstk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl0CFRLMnik9A6DRpz0k5eYhV1nGaQFUWuCKlFzll69OwmKlB0
	ukKf1rD26YocIdSq3vjtzwNGuYoidG33TjRK7AWVETd1rmxkCqOL
X-Gm-Gg: ASbGncvHjkHZ/54VK4dL7qBD0GkQTy2dLMdRU3XGCEqR8qFkzawBL9GXKWE82WsK2JM
	YPvmHLjdlcXk18fU5/j8D6iVFwY4n+ba5+VL5/cWurDavMJDAOLCZ25xAsi2GVx5Ggo7md7ApQ3
	B1LnLTvSb+mpKS6fPPkBWSx3UNkJ+V3yIKpavOx6CqMU2IKchz8nUbfv3nfnvfD+x7SRbvRwrKj
	+30me0JeJJmR4a66xoi99buDEQ7/IwDSmAGg+kjNwtYwl+DcSmsXAB+ivTr2wEM2WL3tfvplFnJ
	Pv4tnv3VRp3OQLs6FwFv+V389HnvCpQSCL73+4IaqJI2JEKIaQCGZL0R0SxUvEHq7UsdJgDa7gF
	VLoHuK76l
X-Google-Smtp-Source: AGHT+IEmR48bt7XEiYsncU5O4Q5GIS0VjcmLqFK0GdoL7joQ9ta5UZGYwgpLnkZ5GqCYSdv4P6TBYA==
X-Received: by 2002:a05:6830:3982:b0:72b:9cc7:25c4 with SMTP id 46e09a7af769-731ce3f9330mr690833a34.22.1746065628499;
        Wed, 30 Apr 2025 19:13:48 -0700 (PDT)
Received: from groves.net (syn-070-114-204-161.res.spectrum.com. [70.114.204.161])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7308b117371sm1140234a34.16.2025.04.30.19.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 19:13:47 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Wed, 30 Apr 2025 19:13:37 -0700
From: John Groves <John@groves.net>
To: Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredb.hu>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Luis Henriques <luis@igalia.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC PATCH 00/19] famfs: port into fuse
Message-ID: <n4idslcksqlegd5e2nyggyzahwhgfh7qqsh3qni7fgpj342ohr@do2fu5pz7fsv>
References: <20250421013346.32530-1-john@groves.net>
 <20250430154232.000045dd.alireza.sanaee@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430154232.000045dd.alireza.sanaee@huawei.com>

On 25/04/30 03:42PM, Alireza Sanaee wrote:
> On Sun, 20 Apr 2025 20:33:27 -0500
> John Groves <John@Groves.net> wrote:
> 
>> <snip>
> 
> Hi John,
> 
> Apologies if the question is far off or irrelevant.
> 
> I am trying to understand FAMFS, and I am thinking where does FAMFS
> stand when compared to OpenSHMEM PGAS. Can't we have a OpenSHMEM-based
> shared memory implementation over CXL that serves as FAMFS?
> 
> Maybe FAMFS does more than that!?!
> 
> Thanks,
> Alireza
>

Continuation of this conversation likely belongs in the discusison section
at [1], but a couple of thoughts.

Famfs provides a scale-out filesystem mounts where the files that map to the
same disaggregated shared memory. If you mmap a famfs file, you are accessing
the memory directly. Since shmem is file-backed (usually tmpfs or
its ilk), shmem is a higher-level and more specialized abstraction, and
OpenSHMEM may be able to run atop famfs. It looks like OpenSHMEM and PGAS
cover the possibility that "shared memory" might require grabbing a copy via
[r]dma - which famfs will probably never do. Famfs only handles cases where
the memory is actually shared. (hey, I work for a memory company.)

Since famfs provides memory-mappable files, almost all apps can access them
(no requirement to write to the shmem, or other related but more estoteric
interfaces). Apps are responsible for not doing "nonsense" access WRT cache
coherency, but famfs manages cache coherency for its metadata.

The video at [2] may be useful to get up to speed.

[1] http://github.com/cxl-micron-reskit/famfs
[2] https://www.youtube.com/watch?v=L1QNpb-8VgM&t=1680

