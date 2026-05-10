Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA40313551
	for <nvdimm@lists.linux.dev>; Sun, 10 May 2026 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424021; cv=none; b=paEBmx2PXy/KRVf+c6fOvYV0AJe9Cq4w5ktWsJ+wWOolTZ+lHMjYwKu8/JyxJ8CYoc+oyMx46MtCXDDlVWIjLa7uWzf0Oe/vUYtBRsWiC6o/BRW4jKGH1apyl0p5jZ2BTrg1Gq28gVS2fOfa5XmYOri5dDJlSjC9MVEENbmeVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424021; c=relaxed/simple;
	bh=siSpsQjxKBJBQUtqz/CL8FbCQlQeBJKwELhg7lkt6kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BizW0jjGA+iNmBhbtqcvfJE2xw5E9rj6O/UHC/W6h74sdQcaxEczCweydoX67/LzkD6fnUelmUGi+6/6shjRbRc6EpWm3fepZUiK2Hdf9DW97q9rFtH9nqJ+BQDRfqDfDb9hPdi4YNJ0h/3RxmvCFOv3kMmiRSe4bkFSpQoGcg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KszvP3d1; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KszvP3d1"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50fb4a7d704so26189581cf.1
        for <nvdimm@lists.linux.dev>; Sun, 10 May 2026 07:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778424018; x=1779028818; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zN7aWTUA3H4RFHbkfRpLkMHDYoiJE8XD5BaVLkKqp84=;
        b=KszvP3d1VftCbQCs3r49cfo/wc/Rd6Y/8hChWGFDtXmrGXEbOcjhYaIpLyiVRcQDyo
         mBQaKzacufZF5cMpkio+rzA21twlVIaO6PY5HcG2DLjhsG1GBjUAQU2x56rJ5DdlUnLK
         ibudE0Et2G3danIIzWYPsLoF6FK81FleJTmpF3jNtLi8evf2k8tnFdwDEnmGGHhFRmT9
         rR0kSH7tPljlmsL4TWZ6g0POgVegCxAeGwMnqDHaWiOuchedTJqvIRbWW/TObBaiEGT2
         gN1v7CZZmEVpwz5XxBtAHGF20lDExD7U5djgBfyg3IAQ6nblXWO8AeGWNmNuCW1rgzZR
         vThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778424018; x=1779028818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zN7aWTUA3H4RFHbkfRpLkMHDYoiJE8XD5BaVLkKqp84=;
        b=X0a6a/HQyC19m2IvszgvYGZlrUKIpbDxa1WAKD3hphzmlHH8qPAiCqHKVLXEKBXmp9
         xKsq76W5bS1bxfco5vAbcz8dPYSqNOpvwvKmoo4bHO4KAn8o42KBrCBytEjLJHKDFShF
         CSggJ2l+ohx15KM+U64449cTmR3YuPAowgWmkuvmlexjWWA6XvEeKrZRn0TXs+CLdmq/
         TcvsIBpwnmrOfO2MdpTp0cwh44MxUTyliObRKTahLdCvBFNurp1DJsCF5/B23hrM244J
         2L+mLxTsp9QAQkmRYPsHGg3cOc1jF1WwdrogloCNwh/2tRmhUDzSbFDCBHKi/lgWJ1dS
         V4Ww==
X-Forwarded-Encrypted: i=1; AFNElJ+alFUpkLHhaxIRVQSNmcV4T33L4uriR3Uz6UUC/Pwlv3IfGxbdiJcTNdo0rTYRMmeyqfVmrC4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwgXvRC3QwQKDNWvKfB5dnxSu7K584jx9uL5ZBQN4ZXReByS6Hx
	BzfvrwKM3Quyg1UwW6/ascg34RuGsEZKhZ21baYkb38A/WsaCs542NiAsUHLyttGvHU=
X-Gm-Gg: Acq92OGQZb4HTPSUXc5fcSziiJ7LvnSj4c0siE1lNjchU+U2LAJmdnvScRyZIpSJ4eK
	aJJIsG7P5UBGvgzjrfi9JDq+WgLhIZawMzSWVctn2MAD2v30aZLbtyPf6Kx5VaCxMylpscBW+HU
	/AKbksPtG4W7oMULojS+05R7dyNLdmiw+fo51gTGMBeZNa+zJpaU35PJPyB/9qfaQA5Qj16u4hd
	KzDDMLJC5n/8yNVDuGXPDsvUvOItpQU294eaWmh3UjdX5iuXEqGHyIlMwHH7jbGgKzxX3C8+WHE
	2E5WhLWlFuIlTfWH/xl0CIRheVa+91a8pk/sPKPHdbERDFC/AQF1IoBzF9IBGl6IhNIuvP70GHw
	fS+fHlcD/bsTwHXsEAUGSnaQUMyfGd7F3wmBnyage1uAXP2QSlEERWn7VNj2cWB7NSXWDQB7box
	HGcYy9vOPNRWQ3z4jBxL2On4gOEmIrDrQ2xtQfu9RukvpPJvELO7R5tp2Yw1u2td1pIbq07ZgfI
	1H6h1pY+HEJ
X-Received: by 2002:ac8:5e11:0:b0:50e:89e9:271c with SMTP id d75a77b69052e-514a0a60821mr91286531cf.17.1778424018487;
        Sun, 10 May 2026 07:40:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7bef56sm67617811cf.15.2026.05.10.07.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 07:40:17 -0700 (PDT)
Date: Sun, 10 May 2026 10:40:15 -0400
From: Gregory Price <gourry@gourry.net>
To: Ira Weiny <iweiny@fastmail.com>
Cc: Ackerley Tng <ackerleytng@google.com>,
	Dave Jiang <dave.jiang@intel.com>, fvdl@google.com,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com,
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org,
	john@groves.net, rick.p.edgecombe@intel.com
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
Message-ID: <agCYz5O36zLATni6@gourry-fedora-PF4VCD3F>
References: <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
 <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>
 <69fd37c5cfa4a_1d1951006d@xwing.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69fd37c5cfa4a_1d1951006d@xwing.notmuch>

On Thu, May 07, 2026 at 08:09:25PM -0500, Ira Weiny wrote:
> 
> 2) What you propose above does not give the gmem 'protection' for CoCo's.
>    So yea that is the bigger issue.
> 

Realistically, what you actually want is to add:

   private_dax.c
       +
   MEMORY_DEVICE_CONFIDENTIAL

And just make sure they work together to produce:

  a) open() works -> produces an FD
  b) no direct-mappings, struct page exists, can be accessed by KVM
  c) all userland operations fault (memory is never in direct map)
  d) unbind explicitly zeroes or calls a registered sanitize() func

But this adds a new dax mode and a new ZONE_DEVICE mode.

A private node with NP_OPT_NOMAP might be cleaner, but you still have to
do the hotplug/memremap dance either way.

~Gregory
