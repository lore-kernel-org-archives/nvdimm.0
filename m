Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0983A3E7F
	for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776432632; cv=none; b=HY7E0cBvFyvlFwjRbPG9g+px47xXw0pVTYIEeLH41SKBVfA9ZJWDbFsFw0eSmHP7SvcfnSaOt20pdYcbQRv+9bZDylYxcdbsLmod5FMtrpqV1qvunTBkGP53NCTqGNtYV4PbmXeCiEEISO95gQlL/jniTV47A+cP27zxtxkuc2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776432632; c=relaxed/simple;
	bh=hkpNLJ3ybawOIa1fkGOwYhoNiDG571CgTvN9uVT7u+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEA2VXvM9/TwbbwbI3FqYPu6PcrDQ9DYnEpl8gj+ykyvudmZuoIKZ/FzRNGQuSOkDdbONB7ZhO6ddoIkJb3lOY//1XcQ8c5UHp/GdJXO4yXSWPTREQUPoiM9ilH7cdJ2YBSZQuJ2Ym+zQqPCpmrlal+SEB2H5m9mw0vxUnXrnjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=cro4DDd9; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="cro4DDd9"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50697d6a69cso3416891cf.2
        for <nvdimm@lists.linux.dev>; Fri, 17 Apr 2026 06:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776432629; x=1777037429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xgTqv4J4Fl9HXQyBvnfY8cYHtSEuC0puU/+LlJmiu7o=;
        b=cro4DDd9bweWnZFwuOe+/bo1QOB9yAVNwnUL57TZYEGd4h6Dr8sE3yeziEmxphqSYS
         P12BKOr0BYvZpjSexzub7ji1P4far7IFFcVH2hsEIcGuCgpHYoAGAHt5lIixxRmQhNdx
         OEpWCGRExyaS4PcpZ0zEISdtqcXA6h5gOFnQ1TU0NTMeYUj7kpHsi0tt5c468wNruGk5
         e8z+7WNgNBVlWk3UhJXxo1f+pDQdRFOvASI17q+VKhVr3Mgk3gX57A4XmLYOi7mFBfLq
         E5Gb9pILpU4u7NUTdjiU/FvLoe4ULUx2U131J1MYPgxiYDwNCiifgopqR/tz356Dpqco
         FDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776432629; x=1777037429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgTqv4J4Fl9HXQyBvnfY8cYHtSEuC0puU/+LlJmiu7o=;
        b=mxs1I6gKjBxXsR+0lq1snxy/DnO346tJ6fdXc7uqHYTfScmccx+MxqRoXQ1fhJfUw2
         QhAvWJKubzygzX4tskzr9UodQxvgDqVZtrrqXnAE2yS86LLsfInO639zV+IWCrxvFB2R
         nB4B6hGrJkYHQPSTwP2gJexP5VCb4Br3XmCcZ/cYJyszeLPYrszfzbVdG5ILIaVJnSAL
         Fo6JOa8o6L9CPRlHiIwfTr9kzgF8sJDIB48m20BxrooUrCMEKQ76Zz3BrKBjuz0LhXJw
         hJTsNMDJ7DZs+nuKkjIrpIVC/7zBmmWV1hw6pSw6Qzo1gCRGB6aVV9QzfAtx3DBefYfk
         c4hQ==
X-Forwarded-Encrypted: i=1; AFNElJ+gWuKT+GUPosA7eA2NLkEA9LqaBOPNDPFyPohbnBk9r0rmRfvVszeHjz4oo3Qj7M4t+VM4wPA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcTqRRZSpPCR1WZvmyh4c/5PoENIVnEXylC3Q1JiKiCIF4RQcA
	3s9x0B+LyqcHcKRcggaP/U+JLaJGe1bySIs2YOAqdeLKUcMm/JJaIRNoF1T0v3fJ4Zw=
X-Gm-Gg: AeBDieuNOEgUQQyW4ePq75Wecl2wKeCWho4nY2eXd+9qxuCV4Q3nMnErG3HZP9zbpIX
	7k7W7UQ7W+Z2LjT+EnTzZd7qlbcCdYV57DU9vpB4EmXAOQfWbD7LXyayNWKoxW6xkypbGVASziH
	XsOHG5EWcQHt4bTxMze1KfbJGRW93gC5BJxsA5NflMMvGb63No8JtT+drtEnOfJ9cKyPVWpECgH
	bpgfW0ErR4PqhSwflS/YhPmS6wv/3TXf0Es+OcvuCxJvAb3PD+C8t87SMGN7a6Yo00hiMQUGHiE
	bYx6meHn5nhyE1LM9T+Lf0F4InSHyfLmYeq7a5y+TSCF1FDam3XTAnpwbfzVuFMVvo64iWCpZpm
	jQZkQ2Sg3iKmJg2OBejcNU71uszR0VNcZJYH+BeUgx+kn+6jNjrrMd578ZdbTgPboWmY5izEN5z
	85M2HdkbwC6v73ru3dMgJwZLimsoBg2rHdT5+Jxp8c41td/0Akx6oKNlXkfqQpFgKU2EM7ltbFY
	ze3WJF/XFtgRKzx+VzR
X-Received: by 2002:a05:622a:1f17:b0:50d:80ee:3962 with SMTP id d75a77b69052e-50e3683091dmr40533621cf.17.1776432629479;
        Fri, 17 Apr 2026 06:30:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-108-18-109-80.washdc.ftas.verizon.net. [108.18.109.80])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e3bf260fbsm9752291cf.10.2026.04.17.06.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 06:30:28 -0700 (PDT)
Date: Fri, 17 Apr 2026 09:30:25 -0400
From: Gregory Price <gourry@gourry.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dan Williams <djbw@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	John Groves <John@groves.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan J Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aeI18Q2lcxZLw-1V@gourry-fedora-PF4VCD3F>
References: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <CAJnrk1ZgcMuwfMpT1fXvUwBBiq9eWFHWVeOFQFFKiamGGe1RJg@mail.gmail.com>
 <ad7Tps4tkNbndd9Z@groves.net>
 <CAJnrk1ZWVsKW2dhAWdBkCQskoTE+hmOhPFDhyz4EtExn=GdXGA@mail.gmail.com>
 <aeFDCeqZDPI3rm3s@gourry-fedora-PF4VCD3F>
 <43d36427-4629-4712-a262-391e64006eb5@app.fastmail.com>
 <20260416224331.GD114184@frogsfrogsfrogs>
 <aeHrsIGagdmZJ1Fw@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHrsIGagdmZJ1Fw@infradead.org>

On Fri, Apr 17, 2026 at 01:13:36AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 16, 2026 at 03:43:31PM -0700, Darrick J. Wong wrote:
> 
> > ...however the strongest case (IMO) would be if (having merged famfs) we
> > then merge fuse-iomap after famfs.  Then we extend the existing
> > fuse-iomap-bpf prototype to allow per-mount and per-inode iomap bpf ops.
> > That enables us to analyze thoroughly the performance characteristics of:
> 
> Don't go there.  I think that you two are comining up with two
> interfaces for roughly the same thing is a pretty clear indicator
> that this needs to be fully hashed out as a single interface first,
> and any kind of preliminary merging is just going to create problems.
>

We're not sure how deep this rathole goes, and John's work has been
in the rathole for a few years now.  Hence the desire to hedge.

But it's obvious no decisions will be made before LSFMM - so we can
take a breath and chew on it. Maybe we'll get there in person.

~Gregory
