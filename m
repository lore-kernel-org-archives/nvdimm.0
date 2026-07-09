Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507423E1689
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 22:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783635781; cv=none; b=AHa80t/ZjtTM8vOAMmEI9F0hkuBJDgavx0zkBpikBCCvaXHsLz35ZlvoLkLRpzWxrUK0NX5ZJCkAlKCfCnI3USwj572dX/pfhHD2HOsA6lsFQrpOMN2Arf02gzrvPqDw7yTE9HjVUYy1/DvKyLrZ6Nm5O8pqyWAzb+5vozvrrxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783635781; c=relaxed/simple;
	bh=F9KJPRgK4L705MdJhF7jSetuwwe9QE17mcbAei3OvSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1W267T535pVt93+dstW91OnZaPskeEO0WI4opwz9jJXZFMJI5ZPPuEZ4PyyWvawR9tm2cRIm+Bl0n7APjkm8o95tSPMMlzdtxKkv3GmCq6NicLLZ2cXIyhNxCIi0BW8CywRXwmBS3oPYkQalhCmE8GRvF/ccbILJeaN2nncDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZXayyXmG; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ZXayyXmG"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c5382806fso2404451cf.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 15:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783635777; x=1784240577; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b50SGMSOIyssQj3plHocLLhkQW1pcBLVRqoMkWAD4k0=;
        b=ZXayyXmGIWU7MWpOrUls0hVj1yvt9I6eZokmhsW4INGCgEBhqDUNr+K9fwVOv1bh0g
         8vZ3N4WiPusM4p4UsxOwQfTiZiPJ/tSGOieip0Do3CO6YsGzAPIb7Qx/K06OQCNI3Ylt
         7gRUsvGfKLSBoMUINhK6oS6C+AFFCmETy8Tzadp5id5Q8EgkbBYRZf/3COlnMqLM0kkN
         FMyJvg+G1bAwiQEiY5ZJ1hVkejKZHh4rajU+Qyi0U9SwadUQUqkVq87J4TEpc+eGbJPE
         98llFruO81Tz0R5AygOmQAm2QAaffYxVsa8b8gMIk/8lfTZXCbVowgD6Vgoah6ZN37fv
         0vDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783635777; x=1784240577;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b50SGMSOIyssQj3plHocLLhkQW1pcBLVRqoMkWAD4k0=;
        b=hUAx+QZDHQHPZrr2Wej6ilPj5Kd2yLa9vKQVvTjhUUJBYnHfRJD1AHiOW+DbHF3S8+
         YsutYiuRciN412FKELxC9pknv2/iJ3eseVIfiavR/jqDinIru4PJFIh3Eu4GyMOm4Wax
         OD3kXpkeNB/lPAtvu338WpbBY9ElDcAuRJDBIx6uOArQtw7G179UFLdrAE2t+EmfneI6
         mKcjxmuaYk9G20uMjGLeJ3BhU6ks5fwdQoD5ncza2HXSL4+SD+NRHpZlfGHQ+6zZU9si
         JpC1ihY+LXSGelPxyvm8y/jNTeNuwZjibJfGUf42aadc5yJADcG9QnK8gP3Xxhvp9ixR
         1HJg==
X-Forwarded-Encrypted: i=1; AHgh+RoqgsUFevJY1L40hoKP+tfk6SFIiOWwp2Q9J0cKQVgoABtzZzsXwjOP5jQKbeCoOEGnw6C2MkM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZvtSIKnJ7+y4APccGr7JaRm9mNFym6z/9dawutkvCrAhJS3US
	77RbVWiJzpRCIyizkLHU8ztPNu5YX0n3ePa7pni6pGXvLzKy5gPB/Se1I/fkX64B/cI=
X-Gm-Gg: AfdE7clcxsf1gruPkr0/yHChU4Z3ngOUqCa12VKIGXar+DcopD/UeqwpQ5ETzOGC2s4
	E2tQfORxxxt5X4p4ZJTlTuGJCRqRHqQUlUCOlwJ4lqjJCSdLWz9yvjJJ8KygKuPA68m54EmLRYf
	/i9fCwQddKAsIylYLC/PnGnlH7E2Lv1zTYdvw0Vt9YAAIexMyGimUqQKOiLp7fS5BMrGYfUC0+x
	Tk2VUzi45f04w1jcUskS9Scwn6MthdFV2iijuCZK+nSO98g6qoeG7XQNfsKy0PgVf9DoXMNzmGd
	QbO2n4/Hyn9qMUgdcbEQgAjSjcBSw/AvU0CftyAh2JMJ5ol4iOu5UZKHZAyioRJdcRqM17Nem73
	3AcUf9N4n42O3qo8z0rO3KXbkXOOryyskBhQi0p/Ar2IBqz6suMuITzpa1/G3loVidp6JThj9n4
	SUgRSrEQTH33I1Mnt6LDRWfmYX+8/eDmVPd7OXxruW6XfCyCP5xdhIKpn7wXhprkXBY0HF
X-Received: by 2002:ac8:5a02:0:b0:51a:8c97:fb91 with SMTP id d75a77b69052e-51c8b4bac92mr100050501cf.58.1783635777304;
        Thu, 09 Jul 2026 15:22:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caace31a4sm4283401cf.12.2026.07.09.15.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 15:22:56 -0700 (PDT)
Date: Thu, 9 Jul 2026 18:22:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <alAfOxnnYQxPW8DO@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6fd50351-93e0-4d65-960f-53dee655a786@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fd50351-93e0-4d65-960f-53dee655a786@intel.com>

On Thu, Jul 09, 2026 at 03:14:26PM -0700, Dave Jiang wrote:
> > diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
> > index b34266bfae49..2dcad1e9dad0 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-dax
> > +++ b/Documentation/ABI/testing/sysfs-bus-dax
> > @@ -151,3 +151,29 @@ Description:
> >  		memmap_on_memory parameter for memory_hotplug. This is
> >  		typically set on the kernel command line -
> >  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> > +
> > +What:		/sys/bus/dax/devices/daxX.Y/state
> > +Date:		June, 2026
> > +KernelVersion:	v6.21
> 
> Kernel version a bit old :)
> 
> DJ
> 

It has been a hot second since i started this n_n;;;;

~Gregory
